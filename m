Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab1FQISR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:18:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53914 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527Ab1FQISO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:18:14 -0400
From: Chris Forbes <chrisf@ijw.co.nz>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Forbes <chrisf@ijw.co.nz>
Subject: [PATCH] fs: file_table: fix coding style issues
Date: Fri, 17 Jun 2011 20:17:59 +1200
Message-Id: <1308298679-32158-1-git-send-email-chrisf@ijw.co.nz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues flagged by checkpatch.pl

Signed-off-by: Chris Forbes <chrisf@ijw.co.nz>
---
 fs/file_table.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 01e4c1e..47d002e 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -25,7 +25,7 @@
 #include <linux/percpu.h>
 #include <linux/ima.h>
 
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include "internal.h"
 
@@ -79,14 +79,14 @@ EXPORT_SYMBOL_GPL(get_max_files);
  */
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
 int proc_nr_files(ctl_table *table, int write,
-                     void __user *buffer, size_t *lenp, loff_t *ppos)
+		void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	files_stat.nr_files = get_nr_files();
 	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
 #else
 int proc_nr_files(ctl_table *table, int write,
-                     void __user *buffer, size_t *lenp, loff_t *ppos)
+		void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
 }
@@ -106,7 +106,7 @@ struct file *get_empty_filp(void)
 {
 	const struct cred *cred = current_cred();
 	static long old_max;
-	struct file * f;
+	struct file *f;
 
 	/*
 	 * Privileged users can go above max_files
@@ -116,7 +116,8 @@ struct file *get_empty_filp(void)
 		 * percpu_counters are inaccurate.  Do an expensive check before
 		 * we go and fail.
 		 */
-		if (percpu_counter_sum_positive(&nr_files) >= files_stat.max_files)
+		if (percpu_counter_sum_positive(&nr_files) >=
+			files_stat.max_files)
 			goto over;
 	}
 
@@ -186,7 +187,8 @@ struct file *alloc_file(struct path *path, fmode_t mode,
 	 * visible.  We do this for consistency, and so
 	 * that we can do debugging checks at __fput()
 	 */
-	if ((mode & FMODE_WRITE) && !special_file(path->dentry->d_inode->i_mode)) {
+	if ((mode & FMODE_WRITE) &&
+		!special_file(path->dentry->d_inode->i_mode)) {
 		file_take_write(file);
 		WARN_ON(mnt_clone_write(path->mnt));
 	}
@@ -270,7 +272,6 @@ void fput(struct file *file)
 	if (atomic_long_dec_and_test(&file->f_count))
 		__fput(file);
 }
-
 EXPORT_SYMBOL(fput);
 
 struct file *fget(unsigned int fd)
@@ -290,7 +291,6 @@ struct file *fget(unsigned int fd)
 
 	return file;
 }
-
 EXPORT_SYMBOL(fget);
 
 struct file *fget_raw(unsigned int fd)
@@ -309,7 +309,6 @@ struct file *fget_raw(unsigned int fd)
 
 	return file;
 }
-
 EXPORT_SYMBOL(fget_raw);
 
 /*
@@ -513,7 +512,7 @@ retry:
 	do_file_list_for_each_entry(sb, f) {
 		struct vfsmount *mnt;
 		if (!S_ISREG(f->f_path.dentry->d_inode->i_mode))
-		       continue;
+			continue;
 		if (!file_count(f))
 			continue;
 		if (!(f->f_mode & FMODE_WRITE))
@@ -535,7 +534,7 @@ retry:
 }
 
 void __init files_init(unsigned long mempages)
-{ 
+{
 	unsigned long n;
 
 	filp_cachep = kmem_cache_create("filp", sizeof(struct file), 0,
@@ -543,12 +542,12 @@ void __init files_init(unsigned long mempages)
 
 	/*
 	 * One file with associated inode and dcache is very roughly 1K.
-	 * Per default don't use more than 10% of our memory for files. 
-	 */ 
+	 * Per default don't use more than 10% of our memory for files.
+	 */
 
 	n = (mempages * (PAGE_SIZE / 1024)) / 10;
 	files_stat.max_files = max_t(unsigned long, n, NR_FILE);
 	files_defer_init();
 	lg_lock_init(files_lglock);
 	percpu_counter_init(&nr_files, 0);
-} 
+}
-- 
1.7.4.1

