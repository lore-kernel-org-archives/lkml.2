Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab1K3CSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:18:43 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:56903 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757639Ab1K3CSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:18:38 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 21/28] locks: checkpatch wanking
Date: Tue, 29 Nov 2011 18:14:19 -0800
Message-Id: <20c8b026947681180b216f1cea71a0832eb5ca2a.1322609673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Almost checkpatch clean, a couple long line warnings remain.

$ ./scripts/checkpatch.pl -f --terse --nosummary fs/locks.c | \
  cut -f3- -d":" | sort | uniq -c
      3  ERROR: code indent should use tabs where possible
      1  ERROR: else should follow close brace '}'
      2  ERROR: "foo * bar" should be "foo *bar"
      1  ERROR: open brace '{' following function declarations go on the next line
      4  ERROR: return is not a function, parentheses are not required
     14  ERROR: trailing whitespace
      1  WARNING: braces {} are not necessary for any arm of this statement
      2  WARNING: braces {} are not necessary for single statement blocks
     12  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
      1  WARNING: labels should not be indented
      2  WARNING: %Ld/%Lu are not-standard C, use %lld/%llu
     11  WARNING: line over 80 characters
      3  WARNING: please, no space before tabs
      6  WARNING: please, no spaces at the start of a line
      1  WARNING: space prohibited between function name and open parenthesis '('
      1  WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/locks.c |  121 ++++++++++++++++++++++++++++--------------------------------
 1 files changed, 56 insertions(+), 65 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 10f2bdb..268da7c 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -11,11 +11,11 @@
  *
  *  Miscellaneous edits, and a total rewrite of posix_lock_file() code.
  *  Kai Petzke (wpp@marie.physik.tu-berlin.de), 1994
- *  
+ *
  *  Converted file_lock_table to a linked list from an array, which eliminates
  *  the limits on how many active file locks are open.
  *  Chad Page (pageone@netcom.com), November 27, 1994
- * 
+ *
  *  Removed dependency on file descriptors. dup()'ed file descriptors now
  *  get the same locks as the original file descriptors, and a close() on
  *  any file descriptor removes ALL the locks on the file for the current
@@ -41,7 +41,7 @@
  *  with a file pointer (filp). As a result they can be shared by a parent
  *  process and its children after a fork(). They are removed when the last
  *  file descriptor referring to the file pointer is closed (unless explicitly
- *  unlocked). 
+ *  unlocked).
  *
  *  FL_FLOCK locks never deadlock, an existing lock is always removed before
  *  upgrading from shared to exclusive (or vice versa). When this happens
@@ -50,7 +50,7 @@
  *  Andy Walker (andy@lysaker.kvaerner.no), June 09, 1995
  *
  *  Removed some race conditions in flock_lock_file(), marked other possible
- *  races. Just grep for FIXME to see them. 
+ *  races. Just grep for FIXME to see them.
  *  Dmitry Gorodchanin (pgmdsg@ibi.com), February 09, 1996.
  *
  *  Addressed Dmitry's concerns. Deadlock checking no longer recursive.
@@ -101,7 +101,8 @@
  *  Some adaptations for NFS support.
  *  Olaf Kirch (okir@monad.swb.de), Dec 1996,
  *
- *  Fixed /proc/locks interface so that we can't overrun the buffer we are handed.
+ *  Fixed /proc/locks interface so that we can't overrun the buffer
+ *  we are handed.
  *  Andy Walker (andy@lysaker.kvaerner.no), May 12, 1997.
  *
  *  Use slab allocator instead of kmalloc/kfree.
@@ -128,8 +129,7 @@
 #include <linux/time.h>
 #include <linux/rcupdate.h>
 #include <linux/pid_namespace.h>
-
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #define IS_POSIX(fl)	(fl->fl_flags & FL_POSIX)
 #define IS_FLOCK(fl)	(fl->fl_flags & FL_FLOCK)
@@ -152,8 +152,10 @@ static int target_leasetype(struct file_lock *fl)
 int leases_enable = 1;
 int lease_break_time = 45;
 
-#define for_each_lock(inode, lockp) \
-	for (lockp = &inode->i_flock; *lockp != NULL; lockp = &(*lockp)->fl_next)
+#define for_each_lock(inode, lockp)				\
+	for (lockp = &inode->i_flock;				\
+	     *lockp != NULL;					\
+	     lockp = &(*lockp)->fl_next)
 
 static LIST_HEAD(file_lock_list);
 static LIST_HEAD(blocked_list);
@@ -228,7 +230,6 @@ void locks_init_lock(struct file_lock *fl)
 	memset(fl, 0, sizeof(struct file_lock));
 	locks_init_lock_heads(fl);
 }
-
 EXPORT_SYMBOL(locks_init_lock);
 
 static void locks_copy_private(struct file_lock *new, struct file_lock *fl)
@@ -270,10 +271,10 @@ void locks_copy_lock(struct file_lock *new, struct file_lock *fl)
 
 	locks_copy_private(new, fl);
 }
-
 EXPORT_SYMBOL(locks_copy_lock);
 
-static inline int flock_translate_cmd(int cmd) {
+static inline int flock_translate_cmd(int cmd)
+{
 	if (cmd & LOCK_MAND)
 		return cmd & (LOCK_MAND | LOCK_RW);
 	switch (cmd) {
@@ -295,7 +296,7 @@ static int flock_make_lock(struct file *filp, struct file_lock **lock,
 	int type = flock_translate_cmd(cmd);
 	if (type < 0)
 		return type;
-	
+
 	fl = locks_alloc_lock();
 	if (fl == NULL)
 		return -ENOMEM;
@@ -305,7 +306,7 @@ static int flock_make_lock(struct file *filp, struct file_lock **lock,
 	fl->fl_flags = FL_FLOCK;
 	fl->fl_type = type;
 	fl->fl_end = OFFSET_MAX;
-	
+
 	*lock = fl;
 	return 0;
 }
@@ -365,7 +366,7 @@ static int flock_to_posix_lock(struct file *filp, struct file_lock *fl,
 	fl->fl_start = start;	/* we record the absolute position */
 	if (fl->fl_end < fl->fl_start)
 		return -EOVERFLOW;
-	
+
 	fl->fl_owner = current->files;
 	fl->fl_pid = current->tgid;
 	fl->fl_file = filp;
@@ -411,7 +412,7 @@ static int flock64_to_posix_lock(struct file *filp, struct file_lock *fl,
 	fl->fl_start = start;	/* we record the absolute position */
 	if (fl->fl_end < fl->fl_start)
 		return -EOVERFLOW;
-	
+
 	fl->fl_owner = current->files;
 	fl->fl_pid = current->tgid;
 	fl->fl_file = filp;
@@ -448,7 +449,7 @@ static const struct lock_manager_operations lease_manager_ops = {
  * Initialize a lease, use the default lock manager operations
  */
 static int lease_init(struct file *filp, int type, struct file_lock *fl)
- {
+{
 	if (assign_type(fl, type) != 0)
 		return -EINVAL;
 
@@ -524,7 +525,7 @@ static void locks_delete_block(struct file_lock *waiter)
  * the order they blocked. The documentation doesn't require this but
  * it seems like the reasonable thing to do.
  */
-static void locks_insert_block(struct file_lock *blocker, 
+static void locks_insert_block(struct file_lock *blocker,
 			       struct file_lock *waiter)
 {
 	BUG_ON(!list_empty(&waiter->fl_block));
@@ -611,35 +612,37 @@ static int locks_conflict(struct file_lock *caller_fl, struct file_lock *sys_fl)
 /* Determine if lock sys_fl blocks lock caller_fl. POSIX specific
  * checking before calling the locks_conflict().
  */
-static int posix_locks_conflict(struct file_lock *caller_fl, struct file_lock *sys_fl)
+static int posix_locks_conflict(struct file_lock *caller_fl,
+				struct file_lock *sys_fl)
 {
 	/* POSIX locks owned by the same process do not conflict with
 	 * each other.
 	 */
 	if (!IS_POSIX(sys_fl) || posix_same_owner(caller_fl, sys_fl))
-		return (0);
+		return 0;
 
 	/* Check whether they overlap */
 	if (!locks_overlap(caller_fl, sys_fl))
 		return 0;
 
-	return (locks_conflict(caller_fl, sys_fl));
+	return locks_conflict(caller_fl, sys_fl);
 }
 
 /* Determine if lock sys_fl blocks lock caller_fl. FLOCK specific
  * checking before calling the locks_conflict().
  */
-static int flock_locks_conflict(struct file_lock *caller_fl, struct file_lock *sys_fl)
+static int flock_locks_conflict(struct file_lock *caller_fl,
+				struct file_lock *sys_fl)
 {
 	/* FLOCK locks referring to the same filp do not conflict with
 	 * each other.
 	 */
 	if (!IS_FLOCK(sys_fl) || (caller_fl->fl_file == sys_fl->fl_file))
-		return (0);
+		return 0;
 	if ((caller_fl->fl_type & LOCK_MAND) || (sys_fl->fl_type & LOCK_MAND))
 		return 0;
 
-	return (locks_conflict(caller_fl, sys_fl));
+	return locks_conflict(caller_fl, sys_fl);
 }
 
 void
@@ -729,7 +732,7 @@ static int flock_lock_file(struct file *filp, struct file_lock *request)
 {
 	struct file_lock *new_fl = NULL;
 	struct file_lock **before;
-	struct inode * inode = filp->f_path.dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	int error = 0;
 	int found = 0;
 
@@ -804,7 +807,8 @@ out:
 	return error;
 }
 
-static int __posix_lock_file(struct inode *inode, struct file_lock *request, struct file_lock *conflock)
+static int __posix_lock_file(struct inode *inode, struct file_lock *request,
+			     struct file_lock *conflock)
 {
 	struct file_lock *fl;
 	struct file_lock *new_fl = NULL;
@@ -846,18 +850,15 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 			error = FILE_LOCK_DEFERRED;
 			locks_insert_block(fl, request);
 			goto out;
-  		}
-  	}
+		}
+	}
 
 	/* If we're just looking for a conflict, we're done. */
 	error = 0;
 	if (request->fl_flags & FL_ACCESS)
 		goto out;
 
-	/*
-	 * Find the first old lock with the same owner as the new lock.
-	 */
-	
+	/* Find the first old lock with the same owner as the new lock. */
 	before = &inode->i_flock;
 
 	/* First skip locks owned by other processes.  */
@@ -902,8 +903,7 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 			}
 			request = fl;
 			added = 1;
-		}
-		else {
+		} else {
 			/* Processing for different lock types is a bit
 			 * more complex.
 			 */
@@ -947,7 +947,7 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 		}
 		/* Go on to next lock.
 		 */
-	next_lock:
+next_lock:
 		before = &fl->fl_next;
 	}
 
@@ -1039,7 +1039,7 @@ EXPORT_SYMBOL(posix_lock_file);
 int posix_lock_file_wait(struct file *filp, struct file_lock *fl)
 {
 	int error;
-	might_sleep ();
+	might_sleep();
 	for (;;) {
 		error = posix_lock_file(filp, fl, NULL);
 		if (error != FILE_LOCK_DEFERRED)
@@ -1132,7 +1132,6 @@ int locks_mandatory_area(int read_write, struct inode *inode,
 
 	return error;
 }
-
 EXPORT_SYMBOL(locks_mandatory_area);
 
 static void lease_clear_pending(struct file_lock *fl, int arg)
@@ -1160,7 +1159,6 @@ int lease_modify(struct file_lock **before, int arg)
 		locks_delete_lock(before);
 	return 0;
 }
-
 EXPORT_SYMBOL(lease_modify);
 
 static bool past_time(unsigned long then)
@@ -1290,7 +1288,6 @@ out:
 		locks_free_lock(new_fl);
 	return error;
 }
-
 EXPORT_SYMBOL(__break_lease);
 
 /**
@@ -1310,7 +1307,6 @@ void lease_get_mtime(struct inode *inode, struct timespec *time)
 	else
 		*time = inode->i_mtime;
 }
-
 EXPORT_SYMBOL(lease_get_mtime);
 
 /**
@@ -1617,7 +1613,6 @@ int flock_lock_file_wait(struct file *filp, struct file_lock *fl)
 	}
 	return error;
 }
-
 EXPORT_SYMBOL(flock_lock_file_wait);
 
 /**
@@ -1634,7 +1629,8 @@ EXPORT_SYMBOL(flock_lock_file_wait);
  *
  *	%LOCK_UN -- remove an existing lock.
  *
- *	%LOCK_MAND -- a `mandatory' flock.  This exists to emulate Windows Share Modes.
+ *	%LOCK_MAND -- a `mandatory' flock.
+ *	This exists to emulate Windows Share Modes.
  *
  *	%LOCK_MAND can be combined with %LOCK_READ or %LOCK_WRITE to allow other
  *	processes read and write access respectively.
@@ -1758,7 +1754,7 @@ int fcntl_getlk(struct file *filp, struct flock __user *l)
 	error = vfs_test_lock(filp, &file_lock);
 	if (error)
 		goto out;
- 
+
 	flock.l_type = file_lock.fl_type;
 	if (file_lock.fl_type != F_UNLCK) {
 		error = posix_lock_to_flock(&flock, &file_lock);
@@ -1805,7 +1801,8 @@ out:
  * ->lm_grant() before returning to the caller with a FILE_LOCK_DEFERRED
  * return code.
  */
-int vfs_lock_file(struct file *filp, unsigned int cmd, struct file_lock *fl, struct file_lock *conf)
+int vfs_lock_file(struct file *filp, unsigned int cmd, struct file_lock *fl,
+		  struct file_lock *conf)
 {
 	if (filp->f_op && filp->f_op->lock)
 		return filp->f_op->lock(filp, cmd, fl);
@@ -1874,10 +1871,9 @@ again:
 	error = flock_to_posix_lock(filp, file_lock, &flock);
 	if (error)
 		goto out;
-	if (cmd == F_SETLKW) {
+	if (cmd == F_SETLKW)
 		file_lock->fl_flags |= FL_SLEEP;
-	}
-	
+
 	error = -EBADF;
 	switch (flock.l_type) {
 	case F_RDLCK:
@@ -1951,7 +1947,7 @@ int fcntl_getlk64(struct file *filp, struct flock64 __user *l)
 	error = -EFAULT;
 	if (!copy_to_user(l, &flock, sizeof(flock)))
 		error = 0;
-  
+
 out:
 	return error;
 }
@@ -1992,10 +1988,9 @@ again:
 	error = flock64_to_posix_lock(filp, file_lock, &flock);
 	if (error)
 		goto out;
-	if (cmd == F_SETLKW64) {
+	if (cmd == F_SETLKW64)
 		file_lock->fl_flags |= FL_SLEEP;
-	}
-	
+
 	error = -EBADF;
 	switch (flock.l_type) {
 	case F_RDLCK:
@@ -2065,7 +2060,6 @@ void locks_remove_posix(struct file *filp, fl_owner_t owner)
 	if (lock.fl_ops && lock.fl_ops->fl_release_private)
 		lock.fl_ops->fl_release_private(&lock);
 }
-
 EXPORT_SYMBOL(locks_remove_posix);
 
 /*
@@ -2073,7 +2067,7 @@ EXPORT_SYMBOL(locks_remove_posix);
  */
 void locks_remove_flock(struct file *filp)
 {
-	struct inode * inode = filp->f_path.dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct file_lock *fl;
 	struct file_lock **before;
 
@@ -2108,7 +2102,7 @@ void locks_remove_flock(struct file *filp)
 			}
 			/* What? */
 			BUG();
- 		}
+		}
 		before = &fl->fl_next;
 	}
 	unlock_flocks();
@@ -2134,7 +2128,6 @@ posix_unblock_lock(struct file *filp, struct file_lock *waiter)
 	unlock_flocks();
 	return status;
 }
-
 EXPORT_SYMBOL(posix_unblock_lock);
 
 /**
@@ -2150,7 +2143,6 @@ int vfs_cancel_lock(struct file *filp, struct file_lock *fl)
 		return filp->f_op->lock(filp, F_CANCELLK, fl);
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(vfs_cancel_lock);
 
 #ifdef CONFIG_PROC_FS
@@ -2178,11 +2170,10 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
 			     (inode == NULL) ? "*NOINODE*" :
 			     mandatory_lock(inode) ? "MANDATORY" : "ADVISORY ");
 	} else if (IS_FLOCK(fl)) {
-		if (fl->fl_type & LOCK_MAND) {
+		if (fl->fl_type & LOCK_MAND)
 			seq_printf(f, "FLOCK  MSNFS     ");
-		} else {
+		else
 			seq_printf(f, "FLOCK  ADVISORY  ");
-		}
 	} else if (IS_LEASE(fl)) {
 		seq_printf(f, "LEASE  ");
 		if (lease_breaking(fl))
@@ -2220,9 +2211,9 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
 	}
 	if (IS_POSIX(fl)) {
 		if (fl->fl_end == OFFSET_MAX)
-			seq_printf(f, "%Ld EOF\n", fl->fl_start);
+			seq_printf(f, "%lld EOF\n", fl->fl_start);
 		else
-			seq_printf(f, "%Ld %Ld\n", fl->fl_start, fl->fl_end);
+			seq_printf(f, "%lld %lld\n", fl->fl_start, fl->fl_end);
 	} else {
 		seq_printf(f, "0 EOF\n");
 	}
@@ -2312,7 +2303,8 @@ int lock_may_read(struct inode *inode, loff_t start, unsigned long len)
 		if (IS_POSIX(fl)) {
 			if (fl->fl_type == F_RDLCK)
 				continue;
-			if ((fl->fl_end < start) || (fl->fl_start > (start + len)))
+			if ((fl->fl_end < start) ||
+			    (fl->fl_start > (start + len)))
 				continue;
 		} else if (IS_FLOCK(fl)) {
 			if (!(fl->fl_type & LOCK_MAND))
@@ -2327,7 +2319,6 @@ int lock_may_read(struct inode *inode, loff_t start, unsigned long len)
 	unlock_flocks();
 	return result;
 }
-
 EXPORT_SYMBOL(lock_may_read);
 
 /**
@@ -2350,7 +2341,8 @@ int lock_may_write(struct inode *inode, loff_t start, unsigned long len)
 	lock_flocks();
 	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
 		if (IS_POSIX(fl)) {
-			if ((fl->fl_end < start) || (fl->fl_start > (start + len)))
+			if ((fl->fl_end < start) ||
+			    (fl->fl_start > (start + len)))
 				continue;
 		} else if (IS_FLOCK(fl)) {
 			if (!(fl->fl_type & LOCK_MAND))
@@ -2365,7 +2357,6 @@ int lock_may_write(struct inode *inode, loff_t start, unsigned long len)
 	unlock_flocks();
 	return result;
 }
-
 EXPORT_SYMBOL(lock_may_write);
 
 static int __init filelock_init(void)
-- 
1.7.6.405.gc1be0

