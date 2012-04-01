Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab2DALc1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 07:32:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab2DALcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 07:32:25 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Yang Bai <hamo.by@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH] scripts, Fix 'make cscope'
Date: Sun,  1 Apr 2012 07:31:58 -0400
Message-Id: <1333279918-29466-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 66979224c0d288331edcadb1e6ebd978d920d476, scripts: refactor remove
 structure forward declarations, breaks 'make cscope' which now gives the
 following error:

[prarit@prarit linux-2.6]$ make cscope
  GEN     cscope
  sed: can't read cscope: No such file or directory
  make: *** [cscope] Error 2

Fix a typo in the commit.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Yang Bai <hamo.by@gmail.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Michal Marek <mmarek@suse.cz>
---
 scripts/tags.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 0d6004e..b501e84 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -255,5 +255,5 @@ esac
 
 # Remove structure forward declarations.
 if [ -n $remove_structs ]; then
-    LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' $1
+    LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' tags
 fi
-- 
1.7.1

