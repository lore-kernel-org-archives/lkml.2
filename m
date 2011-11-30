Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab1K3CTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:19:01 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:44822 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932083Ab1K3CS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:18:57 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 23/28] stat: checkpatch wanking
Date: Tue, 29 Nov 2011 18:14:21 -0800
Message-Id: <5d748cf8232664cdad000479009db0ca89febd64.1322609673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now checkpatch clean.

$ ./scripts/checkpatch.pl -f --terse --nosummary fs/stat.c | \
  cut -f3- -d":" | sort | uniq -c
      3  ERROR: space required after that ',' (ctx:VxO)
      3  ERROR: space required after that ',' (ctx:VxV)
      3  ERROR: space required before that '&' (ctx:OxV)
      3  ERROR: trailing whitespace
      6  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
      2  WARNING: line over 80 characters
      1  WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
      1  WARNING: Use #include <linux/unistd.h> instead of <asm/unistd.h>

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/stat.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index ff9be35..829d9e9 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -16,9 +16,8 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/pagemap.h>
-
-#include <asm/uaccess.h>
-#include <asm/unistd.h>
+#include <linux/uaccess.h>
+#include <linux/unistd.h>
 
 void generic_fillattr(struct inode *inode, struct kstat *stat)
 {
@@ -36,7 +35,6 @@ void generic_fillattr(struct inode *inode, struct kstat *stat)
 	stat->blksize = (1 << inode->i_blkbits);
 	stat->blocks = inode->i_blocks;
 }
-
 EXPORT_SYMBOL(generic_fillattr);
 
 int vfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
@@ -54,7 +52,6 @@ int vfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 	generic_fillattr(inode, stat);
 	return 0;
 }
-
 EXPORT_SYMBOL(vfs_getattr);
 
 int vfs_fstat(unsigned int fd, struct kstat *stat)
@@ -116,11 +113,12 @@ EXPORT_SYMBOL(vfs_lstat);
  * For backward compatibility?  Maybe this should be moved
  * into arch/i386 instead?
  */
-static int cp_old_stat(struct kstat *stat, struct __old_kernel_stat __user * statbuf)
+static int cp_old_stat(struct kstat *stat,
+		       struct __old_kernel_stat __user *statbuf)
 {
 	static int warncount = 5;
 	struct __old_kernel_stat tmp;
-	
+
 	if (warncount > 0) {
 		warncount--;
 		pr_warn("VFS: Warning: %s using old stat() call. Recompile your binary.\n",
@@ -145,12 +143,12 @@ static int cp_old_stat(struct kstat *stat, struct __old_kernel_stat __user * sta
 #if BITS_PER_LONG == 32
 	if (stat->size > MAX_NON_LFS)
 		return -EOVERFLOW;
-#endif	
+#endif
 	tmp.st_size = stat->size;
 	tmp.st_atime = stat->atime.tv_sec;
 	tmp.st_mtime = stat->mtime.tv_sec;
 	tmp.st_ctime = stat->ctime.tv_sec;
-	return copy_to_user(statbuf,&tmp,sizeof(tmp)) ? -EFAULT : 0;
+	return copy_to_user(statbuf, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
 
 SYSCALL_DEFINE2(stat, const char __user *, filename,
@@ -179,7 +177,8 @@ SYSCALL_DEFINE2(lstat, const char __user *, filename,
 	return cp_old_stat(&stat, statbuf);
 }
 
-SYSCALL_DEFINE2(fstat, unsigned int, fd, struct __old_kernel_stat __user *, statbuf)
+SYSCALL_DEFINE2(fstat, unsigned int, fd, struct __old_kernel_stat __user *,
+		statbuf)
 {
 	struct kstat stat;
 	int error = vfs_fstat(fd, &stat);
@@ -227,7 +226,7 @@ static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
 #if BITS_PER_LONG == 32
 	if (stat->size > MAX_NON_LFS)
 		return -EOVERFLOW;
-#endif	
+#endif
 	tmp.st_size = stat->size;
 	tmp.st_atime = stat->atime.tv_sec;
 	tmp.st_mtime = stat->mtime.tv_sec;
@@ -239,7 +238,7 @@ static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
 #endif
 	tmp.st_blocks = stat->blocks;
 	tmp.st_blksize = stat->blksize;
-	return copy_to_user(statbuf,&tmp,sizeof(tmp)) ? -EFAULT : 0;
+	return copy_to_user(statbuf, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
 
 SYSCALL_DEFINE2(newstat, const char __user *, filename,
@@ -363,7 +362,7 @@ static long cp_new_stat64(struct kstat *stat, struct stat64 __user *statbuf)
 	tmp.st_size = stat->size;
 	tmp.st_blocks = stat->blocks;
 	tmp.st_blksize = stat->blksize;
-	return copy_to_user(statbuf,&tmp,sizeof(tmp)) ? -EFAULT : 0;
+	return copy_to_user(statbuf, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
 
 SYSCALL_DEFINE2(stat64, const char __user *, filename,
@@ -432,7 +431,6 @@ void inode_add_bytes(struct inode *inode, loff_t bytes)
 	__inode_add_bytes(inode, bytes);
 	spin_unlock(&inode->i_lock);
 }
-
 EXPORT_SYMBOL(inode_add_bytes);
 
 void inode_sub_bytes(struct inode *inode, loff_t bytes)
@@ -447,7 +445,6 @@ void inode_sub_bytes(struct inode *inode, loff_t bytes)
 	inode->i_bytes -= bytes;
 	spin_unlock(&inode->i_lock);
 }
-
 EXPORT_SYMBOL(inode_sub_bytes);
 
 loff_t inode_get_bytes(struct inode *inode)
@@ -459,7 +456,6 @@ loff_t inode_get_bytes(struct inode *inode)
 	spin_unlock(&inode->i_lock);
 	return ret;
 }
-
 EXPORT_SYMBOL(inode_get_bytes);
 
 void inode_set_bytes(struct inode *inode, loff_t bytes)
@@ -469,5 +465,4 @@ void inode_set_bytes(struct inode *inode, loff_t bytes)
 	inode->i_blocks = bytes >> 9;
 	inode->i_bytes = bytes & 511;
 }
-
 EXPORT_SYMBOL(inode_set_bytes);
-- 
1.7.6.405.gc1be0

