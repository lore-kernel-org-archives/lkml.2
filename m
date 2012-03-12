Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab2CLDy4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 23:54:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41695 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab2CLDyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 23:54:49 -0400
From: Yang Bai <hamo.by@gmail.com>
To: mmarek@suse.cz, rostedt@goodmis.org, sboyd@codeaurora.org,
        hamo.by@gmail.com, adobriyan@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Makefile: fix error when gen TAGS
Date: Mon, 12 Mar 2012 11:53:17 +0800
Message-Id: <1331524397-19783-1-git-send-email-hamo.by@gmail.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scripts/tags.sh has a problem that it does not
test which kind of tags we are generating and
assumes tags. So when gen TAGS it shows:
  GEN     TAGS
  sed: can't read tags: No such file or directory
  make: *** [TAGS] Error 2

Signed-off-by: Yang Bai <hamo.by@gmail.com>
---
 scripts/tags.sh |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 833813a..ce94e34 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -168,7 +168,11 @@ exuberant()
 	--regex-dotconfig='/^#?[[:blank:]]*(CONFIG_[[:alnum:]_]+)/\1/'
 
 	# Remove structure forward declarations.
-	LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' tags
+	if [[ -e tags ]]; then
+	    LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' tags
+	else
+	    LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' TAGS
+	fi
 }
 
 emacs()
-- 
1.7.9.1

