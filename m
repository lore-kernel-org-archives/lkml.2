Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab0IHSSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 14:18:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61109 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab0IHSSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 14:18:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=muxmmclDsLz/XbISeXgnZFQYtgrvs1tC9vVml1XWBBXfGsajNqwfnOOIoTRYHKnbxF
         vs2kie27a+plhDMH5QlB5ZlgG1MFY6sDLqeLt1XDdQV61fUQ7ZLcVvEwGzecsh9Zr04R
         7Y1oywdom1m9Ps7HG3MalaUF+n2c1vX8j8TNQ=
From: crquan@gmail.com
To: Mel Gorman <mel@csn.ul.ie>, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sysctl: change vm.drop_caches perm to 0200 to avoid misleading
Date: Thu,  9 Sep 2010 02:17:46 +0800
Message-Id: <1283969866-4960-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Renquan <crquan@gmail.com>

The original vm.drop_caches perm is 0644 that allows users to read
its current value, that is quite misleading, I read articles often
on that topic teaching people how to see its current value, and how
to change its value to 3; that would make readers to misunderstand
that varaiable works like a long time state variable, and have long
time effect after writing its value to 3:
http://www.penglixun.com/tech/system/manual_free_linux_memory.html

In fact, this value is for debugging purpose only, and only effect
while writing, means during writing its value to 3, the kernel would
reclaim pagecache and slabcache memory explicitly, it works for only
one time; so only its write permission is meaningful, reading that
var's current value is meaningless and quite misleading, and the best
way to stop misleading is to mark it as write only;

Signed-off-by: Cheng Renquan <crquan@gmail.com>
---
 kernel/sysctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ca38e8e..0e37e89 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1126,7 +1126,7 @@ static struct ctl_table vm_table[] = {
 		.procname	= "drop_caches",
 		.data		= &sysctl_drop_caches,
 		.maxlen		= sizeof(int),
-		.mode		= 0644,
+		.mode		= 0200,
 		.proc_handler	= drop_caches_sysctl_handler,
 	},
 #ifdef CONFIG_COMPACTION
-- 
1.7.0.4

