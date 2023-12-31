#!/bin/bash

VERSION="2.2.3"

NAME="uGet"
ICONNAME="uGet.icns"
VOLNAME="${NAME} ${VERSION}"
DMGNAME="uget-${VERSION}_osx.dmg"
APPNAME="${NAME}.app"
TMPDIR="tmp-out"

FILE_TYPE=`file uGet.app/Contents/MacOS/uGet`
if [[ "$FILE_TYPE" == *"arm64"* ]]; then
	DMGNAME="uget-${VERSION}_osx_arm64.dmg"
else
	DMGNAME="uget-${VERSION}_osx_x86_64.dmg"
fi

mkdir "$TMPDIR"
cp -R "$APPNAME" "$TMPDIR"

test -f "$DMGNAME" && rm "$DMGNAME"
create-dmg \
--volname "$VOLNAME" \
--volicon "$ICONNAME" \
--window-pos 200 120 \
--window-size 700 350 \
--icon-size 128 \
--icon $APPNAME 180 150 \
--hide-extension "$APPNAME" \
--app-drop-link 520 150 \
--format UDBZ \
"$DMGNAME" \
"$TMPDIR"

rm -rf "${TMPDIR}"

if [ -n "$SIGN_CERTIFICATE" ]
then
	codesign -s "$SIGN_CERTIFICATE" --options runtime "$DMGNAME"
fi
