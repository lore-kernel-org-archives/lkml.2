Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab2CLHUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 03:20:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43093 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab2CLHU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 03:20:29 -0400
From: Yang Bai <hamo.by@gmail.com>
To: mmarek@suse.cz, rostedt@goodmis.org, sboyd@codeaurora.org,
        hamo.by@gmail.com, adobriyan@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Makefile: remove forward declaration using etags
Date: Mon, 12 Mar 2012 15:19:52 +0800
Message-Id: <1331536793-32625-1-git-send-email-hamo.by@gmail.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using exuberant, we will remove all forward
declaration of struct at the end, add this function
to etags.

Signed-off-by: Yang Bai <hamo.by@gmail.com>
---
 scripts/tags.sh |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 833813a..261dfd2 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -208,6 +208,9 @@ emacs()
 
 	all_defconfigs | xargs -r $1 -a                         \
 	--regex='/^#?[ \t]?\(CONFIG_[a-zA-Z0-9_]+\)/\1/'
+
+	# Remove structure forward declarations.
+	LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' TAGS
 }
 
 xtags()
-- 
1.7.9.1

