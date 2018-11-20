#!/bin/bash
# Example of concatenating 3 mp4s together with 1-second transitions between them.

./ffmpeg/ffmpeg_g \
  -i media/0_item_0.mp4 \
  -i media/0_item_1.mp4 \
  -i media/0_item_2.mp4 \
  -filter_complex " \
    [0:v]split[v000][v010]; \
    [v000]trim=0:3[v001]; \
    [v010]trim=3:4[v011t]; \
    [v011t]setpts=PTS-STARTPTS[v011]; \
    [1:v]split[v100][v110]; \
    [v100]trim=0:3[v101]; \
    [v110]trim=3:4[v111t]; \
    [v111t]setpts=PTS-STARTPTS[v111]; \
    [2:v]split[v200][v210]; \
    [v200]trim=0:3[v201]; \
    [v210]trim=3:4[v211t]; \
    [v211t]setpts=PTS-STARTPTS[v211]; \
    [v011][v101]gltransition=duration=1:source=./gl-transitions/transitions/cube.glsl[vt0]; \
    [v111][v201]gltransition=duration=1:source=./gl-transitions/transitions/cube.glsl[vt1]; \
    [v001][vt0][vt1][v211]concat=n=4[outv]" \
  -map "[outv]" \
  -c:v libx264 -profile:v baseline -preset slow -movflags faststart -pix_fmt yuv420p \
  -y out.mp4