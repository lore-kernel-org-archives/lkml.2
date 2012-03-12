Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2CLIVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 04:21:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39445 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab2CLIVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 04:21:31 -0400
From: Yang Bai <hamo.by@gmail.com>
To: mmarek@suse.cz, rostedt@goodmis.org, sboyd@codeaurora.org,
        hamo.by@gmail.com, adobriyan@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] scripts: refactor remove structure forward declarations
Date: Mon, 12 Mar 2012 16:20:51 +0800
Message-Id: <1331540451-2380-1-git-send-email-hamo.by@gmail.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since now it has some problems when generate TAGS,
refactor this code. Now it will not show the error
message and will remove declarations using emacs etags.

Signed-off-by: Yang Bai <hamo.by@gmail.com>
---
 scripts/tags.sh |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 833813a..2b377fc 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -166,9 +166,6 @@ exuberant()
 	all_defconfigs | xargs -r $1 -a                         \
 	--langdef=dotconfig --language-force=dotconfig          \
 	--regex-dotconfig='/^#?[[:blank:]]*(CONFIG_[[:alnum:]_]+)/\1/'
-
-	# Remove structure forward declarations.
-	LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' tags
 }
 
 emacs()
@@ -233,6 +230,7 @@ if [ "${ARCH}" = "um" ]; then
 	fi
 fi
 
+remove_structs=
 case "$1" in
 	"cscope")
 		docscope
@@ -245,10 +243,17 @@ case "$1" in
 	"tags")
 		rm -f tags
 		xtags ctags
+		remove_structs=y
 		;;
 
 	"TAGS")
 		rm -f TAGS
 		xtags etags
+		remove_structs=y
 		;;
 esac
+
+# Remove structure forward declarations.
+if [ -n $remove_structs ]; then
+    LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' $1
+fi
-- 
1.7.9.1

