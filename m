Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab1K3CSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:18:51 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:33521 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932083Ab1K3CSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:18:47 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 22/28] open: checkpatch wanking
Date: Tue, 29 Nov 2011 18:14:20 -0800
Message-Id: <f990bb411dd5db3ded9f5fb9c5671b575f92ce48.1322609673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now checkpatch clean.

$ ./scripts/checkpatch.pl -f --terse --nosummary fs/open.c | \
  cut -f3- -d":" | sort | uniq -c
      8  ERROR: "foo * bar" should be "foo *bar"
      5  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
      4  WARNING: line over 80 characters
      1  WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/open.c |   37 ++++++++++++++++++-------------------
 1 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 58c8d94..bb3e0e5 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -21,7 +21,7 @@
 #include <linux/mount.h>
 #include <linux/fcntl.h>
 #include <linux/slab.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/fs.h>
 #include <linux/personality.h>
 #include <linux/pagemap.h>
@@ -134,9 +134,9 @@ SYSCALL_DEFINE2(truncate, const char __user *, path, long, length)
 
 static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 {
-	struct inode * inode;
+	struct inode *inode;
 	struct dentry *dentry;
-	struct file * file;
+	struct file *file;
 	int error;
 
 	error = -EINVAL;
@@ -170,7 +170,8 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 	if (!error)
 		error = security_path_truncate(&file->f_path);
 	if (!error)
-		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, file);
+		error = do_truncate(dentry, length, ATTR_MTIME | ATTR_CTIME,
+				    file);
 out_putf:
 	fput(file);
 out:
@@ -187,7 +188,7 @@ SYSCALL_DEFINE2(ftruncate, unsigned int, fd, unsigned long, length)
 
 /* LFS versions of truncate are only needed on 32 bit machines */
 #if BITS_PER_LONG == 32
-SYSCALL_DEFINE(truncate64)(const char __user * path, loff_t length)
+SYSCALL_DEFINE(truncate64)(const char __user *path, loff_t length)
 {
 	return do_sys_truncate(path, length);
 }
@@ -472,7 +473,7 @@ out_unlock:
 
 SYSCALL_DEFINE2(fchmod, unsigned int, fd, mode_t, mode)
 {
-	struct file * file;
+	struct file *file;
 	int err = -EBADF;
 
 	file = fget(fd);
@@ -575,7 +576,8 @@ out:
 	return error;
 }
 
-SYSCALL_DEFINE3(lchown, const char __user *, filename, uid_t, user, gid_t, group)
+SYSCALL_DEFINE3(lchown, const char __user *, filename, uid_t, user, gid_t,
+		group)
 {
 	struct path path;
 	int error;
@@ -596,9 +598,9 @@ out:
 
 SYSCALL_DEFINE3(fchown, unsigned int, fd, uid_t, user, gid_t, group)
 {
-	struct file * file;
+	struct file *file;
 	int error = -EBADF;
-	struct dentry * dentry;
+	struct dentry *dentry;
 
 	file = fget(fd);
 	if (!file)
@@ -648,7 +650,8 @@ static inline int __get_file_write_access(struct inode *inode,
 
 static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 					struct file *f,
-					int (*open)(struct inode *, struct file *),
+					int (*open)(struct inode *,
+						    struct file *),
 					const struct cred *cred)
 {
 	static const struct file_operations empty_fops = {};
@@ -761,8 +764,9 @@ cleanup_file:
  * If the open callback is set to NULL, then the standard f_op->open()
  * filesystem callback is substituted.
  */
-struct file *lookup_instantiate_filp(struct nameidata *nd, struct dentry *dentry,
-		int (*open)(struct inode *, struct file *))
+struct file *lookup_instantiate_filp(struct nameidata *nd,
+				     struct dentry *dentry,
+				     int (*open)(struct inode *, struct file *))
 {
 	const struct cred *cred = current_cred();
 
@@ -850,7 +854,6 @@ void put_unused_fd(unsigned int fd)
 	__put_unused_fd(files, fd);
 	spin_unlock(&files->file_lock);
 }
-
 EXPORT_SYMBOL(put_unused_fd);
 
 /*
@@ -876,7 +879,6 @@ void fd_install(unsigned int fd, struct file *file)
 	rcu_assign_pointer(fdt->fd[fd], file);
 	spin_unlock(&files->file_lock);
 }
-
 EXPORT_SYMBOL(fd_install);
 
 static inline int build_open_flags(int flags, int mode, struct open_flags *op)
@@ -1059,7 +1061,6 @@ int filp_close(struct file *filp, fl_owner_t id)
 	fput(filp);
 	return retval;
 }
-
 EXPORT_SYMBOL(filp_close);
 
 /*
@@ -1069,7 +1070,7 @@ EXPORT_SYMBOL(filp_close);
  */
 SYSCALL_DEFINE1(close, unsigned int, fd)
 {
-	struct file * filp;
+	struct file *filp;
 	struct files_struct *files = current->files;
 	struct fdtable *fdt;
 	int retval;
@@ -1121,13 +1122,12 @@ SYSCALL_DEFINE0(vhangup)
  * the caller didn't specify O_LARGEFILE.  On 64bit systems we force
  * on this flag in sys_open.
  */
-int generic_file_open(struct inode * inode, struct file * filp)
+int generic_file_open(struct inode *inode, struct file *filp)
 {
 	if (!(filp->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
 		return -EOVERFLOW;
 	return 0;
 }
-
 EXPORT_SYMBOL(generic_file_open);
 
 /*
@@ -1141,5 +1141,4 @@ int nonseekable_open(struct inode *inode, struct file *filp)
 	filp->f_mode &= ~(FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE);
 	return 0;
 }
-
 EXPORT_SYMBOL(nonseekable_open);
-- 
1.7.6.405.gc1be0

