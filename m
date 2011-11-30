Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab1K3CQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:16:15 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:59094 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756637Ab1K3CQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:16:11 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/28] dcache: Use current logging style
Date: Tue, 29 Nov 2011 18:14:07 -0800
Message-Id: <31eb7095cd8703290ec522a356d9876c5f68e8d8.1322609672.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add and use pr_fmt and pr_<level>.
No change in output with #define pr_fmt(fmt) fmt

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/dcache.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 3abfec7..6055631 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -14,6 +14,8 @@
  * the dcache entry is deleted or garbage collected.
  */
 
+#define pr_fmt(fmt) fmt
+
 #include <linux/syscalls.h>
 #include <linux/string.h>
 #include <linux/mm.h>
@@ -890,10 +892,7 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 			__d_shrink(dentry);
 
 			if (dentry->d_count != 0) {
-				printk(KERN_ERR
-				       "BUG: Dentry %p{i=%lx,n=%s}"
-				       " still in use (%d)"
-				       " [unmount of %s %s]\n",
+				pr_err("BUG: Dentry %p{i=%lx,n=%s} still in use (%d) [unmount of %s %s]\n",
 				       dentry,
 				       dentry->d_inode ?
 				       dentry->d_inode->i_ino : 0UL,
@@ -2164,7 +2163,7 @@ static void dentry_unlock_parents_for_move(struct dentry *dentry,
 static void __d_move(struct dentry * dentry, struct dentry * target)
 {
 	if (!dentry->d_inode)
-		printk(KERN_WARNING "VFS: moving negative dcache entry\n");
+		pr_warn("VFS: moving negative dcache entry\n");
 
 	BUG_ON(d_ancestor(dentry, target));
 	BUG_ON(d_ancestor(target, dentry));
-- 
1.7.6.405.gc1be0

