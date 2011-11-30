Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669Ab1K3CSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:18:18 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:60371 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757650Ab1K3CSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:18:14 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 19/28] fcntl: checkpatch wanking
Date: Tue, 29 Nov 2011 18:14:17 -0800
Message-Id: <6d4c513e051b6cf1082e7ae36c93b3b81c95b5dc.1322609673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now checkpatch clean.

$ ./scripts/checkpatch.pl -f --terse --nosummary fs/fcntl.c | \
  cut -f3- -d":" | sort | uniq -c
      5  ERROR: code indent should use tabs where possible
      6  ERROR: "foo * bar" should be "foo *bar"
      2  ERROR: switch and case should be at the same indent
      9  ERROR: trailing whitespace
      1  WARNING: braces {} are not necessary for single statement blocks
      1  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
      4  WARNING: line over 80 characters
      1  WARNING: please, no space before tabs
      4  WARNING: please, no spaces at the start of a line
      1  WARNING: suspect code indent for conditional statements (15, 19)
      1  WARNING: suspect code indent for conditional statements (8, 15)
      1  WARNING: Use #include <linux/poll.h> instead of <asm/poll.h>
      1  WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/fcntl.c |  128 +++++++++++++++++++++++++++++++-----------------------------
 1 files changed, 66 insertions(+), 62 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 5d16b1d..cc887fd 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -22,10 +22,9 @@
 #include <linux/signal.h>
 #include <linux/rcupdate.h>
 #include <linux/pid_namespace.h>
-
-#include <asm/poll.h>
+#include <linux/poll.h>
+#include <linux/uaccess.h>
 #include <asm/siginfo.h>
-#include <asm/uaccess.h>
 
 void set_close_on_exec(unsigned int fd, int flag)
 {
@@ -55,8 +54,8 @@ static int get_close_on_exec(unsigned int fd)
 SYSCALL_DEFINE3(dup3, unsigned int, oldfd, unsigned int, newfd, int, flags)
 {
 	int err = -EBADF;
-	struct file * file, *tofree;
-	struct files_struct * files = current->files;
+	struct file *file, *tofree;
+	struct files_struct *files = current->files;
 	struct fdtable *fdt;
 
 	if ((flags & ~O_CLOEXEC) != 0)
@@ -147,9 +146,9 @@ SYSCALL_DEFINE1(dup, unsigned int, fildes)
 
 #define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME)
 
-static int setfl(int fd, struct file * filp, unsigned long arg)
+static int setfl(int fd, struct file *filp, unsigned long arg)
 {
-	struct inode * inode = filp->f_path.dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	int error = 0;
 
 	/*
@@ -165,9 +164,10 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 			return -EPERM;
 
 	/* required for strict SunOS emulation */
-	if (O_NONBLOCK != O_NDELAY)
-	       if (arg & O_NDELAY)
-		   arg |= O_NONBLOCK;
+	if (O_NONBLOCK != O_NDELAY) {
+		if (arg & O_NDELAY)
+			arg |= O_NONBLOCK;
+	}
 
 	if (arg & O_DIRECT) {
 		if (!filp->f_mapping || !filp->f_mapping->a_ops ||
@@ -200,7 +200,7 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 }
 
 static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
-                     int force)
+		     int force)
 {
 	write_lock_irq(&filp->f_owner.lock);
 	if (force || !filp->f_owner.pid) {
@@ -403,9 +403,8 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 		break;
 	case F_SETSIG:
 		/* arg == 0 restores default behaviour. */
-		if (!valid_signal(arg)) {
+		if (!valid_signal(arg))
 			break;
-		}
 		err = 0;
 		filp->f_owner.signum = arg;
 		break;
@@ -442,7 +441,7 @@ static int check_fcntl_cmd(unsigned cmd)
 }
 
 SYSCALL_DEFINE3(fcntl, unsigned int, fd, unsigned int, cmd, unsigned long, arg)
-{	
+{
 	struct file *filp;
 	long err = -EBADF;
 
@@ -465,7 +464,7 @@ SYSCALL_DEFINE3(fcntl, unsigned int, fd, unsigned int, cmd, unsigned long, arg)
 
 	err = do_fcntl(fd, cmd, arg, filp);
 
- 	fput(filp);
+	fput(filp);
 out:
 	return err;
 }
@@ -473,8 +472,8 @@ out:
 #if BITS_PER_LONG == 32
 SYSCALL_DEFINE3(fcntl64, unsigned int, fd, unsigned int, cmd,
 		unsigned long, arg)
-{	
-	struct file * filp;
+{
+	struct file *filp;
 	long err;
 
 	err = -EBADF;
@@ -495,19 +494,19 @@ SYSCALL_DEFINE3(fcntl64, unsigned int, fd, unsigned int, cmd,
 		return err;
 	}
 	err = -EBADF;
-	
+
 	switch (cmd) {
-		case F_GETLK64:
-			err = fcntl_getlk64(filp, (struct flock64 __user *) arg);
-			break;
-		case F_SETLK64:
-		case F_SETLKW64:
-			err = fcntl_setlk64(fd, filp, cmd,
-					(struct flock64 __user *) arg);
-			break;
-		default:
-			err = do_fcntl(fd, cmd, arg, filp);
-			break;
+	case F_GETLK64:
+		err = fcntl_getlk64(filp, (struct flock64 __user *)arg);
+		break;
+	case F_SETLK64:
+	case F_SETLKW64:
+		err = fcntl_setlk64(fd, filp, cmd,
+				    (struct flock64 __user *)arg);
+		break;
+	default:
+		err = do_fcntl(fd, cmd, arg, filp);
+		break;
 	}
 	fput(filp);
 out:
@@ -527,7 +526,7 @@ static const long band_table[NSIGPOLL] = {
 };
 
 static inline int sigio_perm(struct task_struct *p,
-                             struct fown_struct *fown, int sig)
+			     struct fown_struct *fown, int sig)
 {
 	const struct cred *cred;
 	int ret;
@@ -556,31 +555,33 @@ static void send_sigio_to_task(struct task_struct *p,
 		return;
 
 	switch (signum) {
+	default: {
 		siginfo_t si;
-		default:
-			/* Queue a rt signal with the appropriate fd as its
-			   value.  We use SI_SIGIO as the source, not 
-			   SI_KERNEL, since kernel signals always get 
-			   delivered even if we can't queue.  Failure to
-			   queue in this case _should_ be reported; we fall
-			   back to SIGIO in that case. --sct */
-			si.si_signo = signum;
-			si.si_errno = 0;
-		        si.si_code  = reason;
-			/* Make sure we are called with one of the POLL_*
-			   reasons, otherwise we could leak kernel stack into
-			   userspace.  */
-			BUG_ON((reason & __SI_MASK) != __SI_POLL);
-			if (reason - POLL_IN >= NSIGPOLL)
-				si.si_band  = ~0L;
-			else
-				si.si_band = band_table[reason - POLL_IN];
-			si.si_fd    = fd;
-			if (!do_send_sig_info(signum, &si, p, group))
-				break;
+
+		/* Queue a rt signal with the appropriate fd as its
+		   value.  We use SI_SIGIO as the source, not
+		   SI_KERNEL, since kernel signals always get
+		   delivered even if we can't queue.  Failure to
+		   queue in this case _should_ be reported; we fall
+		   back to SIGIO in that case. --sct */
+		si.si_signo = signum;
+		si.si_errno = 0;
+		si.si_code  = reason;
+		/* Make sure we are called with one of the POLL_*
+		   reasons, otherwise we could leak kernel stack into
+		   userspace.  */
+		BUG_ON((reason & __SI_MASK) != __SI_POLL);
+		if (reason - POLL_IN >= NSIGPOLL)
+			si.si_band  = ~0L;
+		else
+			si.si_band = band_table[reason - POLL_IN];
+		si.si_fd    = fd;
+		if (!do_send_sig_info(signum, &si, p, group))
+			break;
 		/* fall-through: fall back on the old plain SIGIO signal */
-		case 0:
-			do_send_sig_info(SIGIO, SEND_SIG_PRIV, p, group);
+	}
+	case 0:
+		do_send_sig_info(SIGIO, SEND_SIG_PRIV, p, group);
 	}
 }
 
@@ -590,7 +591,7 @@ void send_sigio(struct fown_struct *fown, int fd, int band)
 	enum pid_type type;
 	struct pid *pid;
 	int group = 1;
-	
+
 	read_lock(&fown->lock);
 
 	type = fown->pid_type;
@@ -602,7 +603,7 @@ void send_sigio(struct fown_struct *fown, int fd, int band)
 	pid = fown->pid;
 	if (!pid)
 		goto out_unlock_fown;
-	
+
 	read_lock(&tasklist_lock);
 	do_each_pid_task(pid, type, p) {
 		send_sigio_to_task(p, fown, fd, band, group);
@@ -626,7 +627,7 @@ int send_sigurg(struct fown_struct *fown)
 	struct pid *pid;
 	int group = 1;
 	int ret = 0;
-	
+
 	read_lock(&fown->lock);
 
 	type = fown->pid_type;
@@ -640,7 +641,7 @@ int send_sigurg(struct fown_struct *fown)
 		goto out_unlock_fown;
 
 	ret = 1;
-	
+
 	read_lock(&tasklist_lock);
 	do_each_pid_task(pid, type, p) {
 		send_sigurg_to_task(p, fown, group);
@@ -717,9 +718,11 @@ void fasync_free(struct fasync_struct *new)
  * NOTE! It is very important that the FASYNC flag always
  * match the state "is the filp on a fasync list".
  */
-struct fasync_struct *fasync_insert_entry(int fd, struct file *filp, struct fasync_struct **fapp, struct fasync_struct *new)
+struct fasync_struct *
+fasync_insert_entry(int fd, struct file *filp, struct fasync_struct **fapp,
+		    struct fasync_struct *new)
 {
-        struct fasync_struct *fa, **fp;
+	struct fasync_struct *fa, **fp;
 
 	spin_lock(&filp->f_lock);
 	spin_lock(&fasync_lock);
@@ -751,7 +754,8 @@ out:
  * Add a fasync entry. Return negative on error, positive if
  * added, and zero if did nothing but change an existing one.
  */
-static int fasync_add_entry(int fd, struct file *filp, struct fasync_struct **fapp)
+static int
+fasync_add_entry(int fd, struct file *filp, struct fasync_struct **fapp)
 {
 	struct fasync_struct *new;
 
@@ -780,13 +784,13 @@ static int fasync_add_entry(int fd, struct file *filp, struct fasync_struct **fa
  * lease code. It returns negative on error, 0 if it did no changes
  * and positive if it added/deleted the entry.
  */
-int fasync_helper(int fd, struct file * filp, int on, struct fasync_struct **fapp)
+int
+fasync_helper(int fd, struct file *filp, int on, struct fasync_struct **fapp)
 {
 	if (!on)
 		return fasync_remove_entry(filp, fapp);
 	return fasync_add_entry(fd, filp, fapp);
 }
-
 EXPORT_SYMBOL(fasync_helper);
 
 /*
-- 
1.7.6.405.gc1be0

