Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab1K3CRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:17:21 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:60722 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756637Ab1K3CRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:17:17 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/28] stat: Use current logging style
Date: Tue, 29 Nov 2011 18:14:12 -0800
Message-Id: <907275d1c1f28214ec7e0c27529412c05e36f0ad.1322609673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add and use pr_fmt and pr_<level>.
No change to output with #define pr_fmt(fmt) fmt

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/stat.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index 8806b89..ff9be35 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -4,6 +4,8 @@
  *  Copyright (C) 1991, 1992  Linus Torvalds
  */
 
+#define pr_fmt(fmt) fmt
+
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/errno.h>
@@ -121,7 +123,7 @@ static int cp_old_stat(struct kstat *stat, struct __old_kernel_stat __user * sta
 	
 	if (warncount > 0) {
 		warncount--;
-		printk(KERN_WARNING "VFS: Warning: %s using old stat() call. Recompile your binary.\n",
+		pr_warn("VFS: Warning: %s using old stat() call. Recompile your binary.\n",
 			current->comm);
 	} else if (warncount < 0) {
 		/* it's laughable, but... */
-- 
1.7.6.405.gc1be0

