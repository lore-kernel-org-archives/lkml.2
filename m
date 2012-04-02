Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab2DBLWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:22:05 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49245 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab2DBLWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:22:03 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: mmarek@suse.cz
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Yang Bai <hamo.by@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 1/1] scripts: fix cscope breakage
Date: Mon,  2 Apr 2012 13:18:37 +0200
Message-Id: <1333365517-18936-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 66979224c0d2 (scripts: refactor remove structure forward
declarations) introduced a breakage in tags.sh for others than tags.
So make cscope now fails with:
sed: can't read cscope: No such file or directory

Fix it by quoting remove_structs properly.

Guys, for how long has this been in -next? I update -next and run
cscope once a week and this issue is new this week. And the patch is
already in -rc1? WTF?

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Yang Bai <hamo.by@gmail.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Michal Marek <mmarek@suse.cz>
---
 scripts/tags.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 0d6004e..cf7b12f 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -254,6 +254,6 @@ case "$1" in
 esac
 
 # Remove structure forward declarations.
-if [ -n $remove_structs ]; then
+if [ -n "$remove_structs" ]; then
     LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' $1
 fi
-- 
1.7.9.2


