Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978Ab1BPMAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:00:44 -0500
Received: from miraculix-out.informatik.uni-kiel.de ([134.245.248.209]:64362
	"EHLO miraculix.informatik.uni-kiel.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758964Ab1BPMAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:00:40 -0500
From: Timo von Holtz <tvh@informatik.uni-kiel.de>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Timo von Holtz <tvh@informatik.uni-kiel.de>
Subject: [PATCH] fs: compat: fixed some coding style issues
Date: Wed, 16 Feb 2011 13:00:26 +0100
Message-Id: <1297857626-670-1-git-send-email-tvh@informatik.uni-kiel.de>
X-Mailer: git-send-email 1.7.4.1
X-Null-Tag: 8a314e6727f12a0d1a22ea716702f5e6
X-Authenticated-Sender: user tvh from 86.103.157.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed nearly all coding style issues classified as ERROR

Signed-off-by: Timo von Holtz <tvh@informatik.uni-kiel.de>
---
 fs/compat.c |   82 ++++++++++++++++++++++++++++++----------------------------
 1 files changed, 42 insertions(+), 40 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index f6fd0a0..8899446 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -7,7 +7,7 @@
  *  Copyright (C) 2002       Stephen Rothwell, IBM Corporation
  *  Copyright (C) 1997-2000  Jakub Jelinek  (jakub@redhat.com)
  *  Copyright (C) 1998       Eddie C. Dost  (ecd@skynet.be)
- *  Copyright (C) 2001,2002  Andi Kleen, SuSE Labs 
+ *  Copyright (C) 2001,2002  Andi Kleen, SuSE Labs
  *  Copyright (C) 2003       Pavel Machek (pavel@ucw.cz)
  *
  *  This program is free software; you can redistribute it and/or modify
@@ -169,7 +169,7 @@ static int cp_compat_stat(struct kstat *stat, struct compat_stat __user *ubuf)
 	return err;
 }
 
-asmlinkage long compat_sys_newstat(const char __user * filename,
+asmlinkage long compat_sys_newstat(const char __user *filename,
 		struct compat_stat __user *statbuf)
 {
 	struct kstat stat;
@@ -181,7 +181,7 @@ asmlinkage long compat_sys_newstat(const char __user * filename,
 	return cp_compat_stat(&stat, statbuf);
 }
 
-asmlinkage long compat_sys_newlstat(const char __user * filename,
+asmlinkage long compat_sys_newlstat(const char __user *filename,
 		struct compat_stat __user *statbuf)
 {
 	struct kstat stat;
@@ -209,7 +209,7 @@ asmlinkage long compat_sys_newfstatat(unsigned int dfd,
 #endif
 
 asmlinkage long compat_sys_newfstat(unsigned int fd,
-		struct compat_stat __user * statbuf)
+		struct compat_stat __user *statbuf)
 {
 	struct kstat stat;
 	int error = vfs_fstat(fd, &stat);
@@ -221,7 +221,7 @@ asmlinkage long compat_sys_newfstat(unsigned int fd,
 
 static int put_compat_statfs(struct compat_statfs __user *ubuf, struct kstatfs *kbuf)
 {
-	
+
 	if (sizeof ubuf->f_blocks == 4) {
 		if ((kbuf->f_blocks | kbuf->f_bfree | kbuf->f_bavail |
 		     kbuf->f_bsize | kbuf->f_frsize) & 0xffffffff00000000ULL)
@@ -247,10 +247,10 @@ static int put_compat_statfs(struct compat_statfs __user *ubuf, struct kstatfs *
 	    __put_user(kbuf->f_fsid.val[0], &ubuf->f_fsid.val[0]) ||
 	    __put_user(kbuf->f_fsid.val[1], &ubuf->f_fsid.val[1]) ||
 	    __put_user(kbuf->f_frsize, &ubuf->f_frsize) ||
-	    __put_user(0, &ubuf->f_spare[0]) || 
-	    __put_user(0, &ubuf->f_spare[1]) || 
-	    __put_user(0, &ubuf->f_spare[2]) || 
-	    __put_user(0, &ubuf->f_spare[3]) || 
+	    __put_user(0, &ubuf->f_spare[0]) ||
+	    __put_user(0, &ubuf->f_spare[1]) ||
+	    __put_user(0, &ubuf->f_spare[2]) ||
+	    __put_user(0, &ubuf->f_spare[3]) ||
 	    __put_user(0, &ubuf->f_spare[4]))
 		return -EFAULT;
 	return 0;
@@ -278,7 +278,7 @@ asmlinkage long compat_sys_statfs(const char __user *pathname, struct compat_sta
 
 asmlinkage long compat_sys_fstatfs(unsigned int fd, struct compat_statfs __user *buf)
 {
-	struct file * file;
+	struct file *file;
 	struct kstatfs tmp;
 	int error;
 
@@ -348,7 +348,7 @@ asmlinkage long compat_sys_statfs64(const char __user *pathname, compat_size_t s
 
 asmlinkage long compat_sys_fstatfs64(unsigned int fd, compat_size_t sz, struct compat_statfs64 __user *buf)
 {
-	struct file * file;
+	struct file *file;
 	struct kstatfs tmp;
 	int error;
 
@@ -556,7 +556,7 @@ compat_sys_io_getevents(aio_context_t ctx_id,
 	struct timespec __user *ut = NULL;
 
 	ret = -EFAULT;
-	if (unlikely(!access_ok(VERIFY_WRITE, events, 
+	if (unlikely(!access_ok(VERIFY_WRITE, events,
 				nr * sizeof(struct io_event))))
 		goto out;
 	if (timeout) {
@@ -564,9 +564,9 @@ compat_sys_io_getevents(aio_context_t ctx_id,
 			goto out;
 
 		ut = compat_alloc_user_space(sizeof(*ut));
-		if (copy_to_user(ut, &t, sizeof(t)) )
+		if (copy_to_user(ut, &t, sizeof(t)))
 			goto out;
-	} 
+	}
 	ret = sys_io_getevents(ctx_id, min_nr, nr, events, ut);
 out:
 	return ret;
@@ -663,7 +663,7 @@ copy_iocb(long nr, u32 __user *ptr32, struct iocb __user * __user *ptr64)
 asmlinkage long
 compat_sys_io_submit(aio_context_t ctx_id, int nr, u32 __user *iocb)
 {
-	struct iocb __user * __user *iocb64; 
+	struct iocb __user * __user *iocb64;
 	long ret;
 
 	if (unlikely(nr < 0))
@@ -671,7 +671,7 @@ compat_sys_io_submit(aio_context_t ctx_id, int nr, u32 __user *iocb)
 
 	if (nr > MAX_AIO_SUBMITS)
 		nr = MAX_AIO_SUBMITS;
-	
+
 	iocb64 = compat_alloc_user_space(nr * sizeof(*iocb64));
 	ret = copy_iocb(nr, iocb, iocb64);
 	if (!ret)
@@ -813,10 +813,10 @@ static int do_nfs4_super_data_conv(void *raw_data)
 #define NCPFS_NAME      "ncpfs"
 #define NFS4_NAME	"nfs4"
 
-asmlinkage long compat_sys_mount(const char __user * dev_name,
-				 const char __user * dir_name,
-				 const char __user * type, unsigned long flags,
-				 const void __user * data)
+asmlinkage long compat_sys_mount(const char __user *dev_name,
+				 const char __user *dir_name,
+				 const char __user *type, unsigned long flags,
+				 const void __user *data)
 {
 	char *kernel_type;
 	unsigned long data_page;
@@ -853,7 +853,7 @@ asmlinkage long compat_sys_mount(const char __user * dev_name,
 	}
 
 	retval = do_mount(kernel_dev, dir_page, kernel_type,
-			flags, (void*)data_page);
+			flags, (void *)data_page);
 
  out4:
 	free_page(data_page);
@@ -952,7 +952,7 @@ struct compat_getdents_callback {
 static int compat_filldir(void *__buf, const char *name, int namlen,
 		loff_t offset, u64 ino, unsigned int d_type)
 {
-	struct compat_linux_dirent __user * dirent;
+	struct compat_linux_dirent __user *dirent;
 	struct compat_getdents_callback *buf = __buf;
 	compat_ulong_t d_ino;
 	int reclen = ALIGN(offsetof(struct compat_linux_dirent, d_name) +
@@ -995,8 +995,8 @@ efault:
 asmlinkage long compat_sys_getdents(unsigned int fd,
 		struct compat_linux_dirent __user *dirent, unsigned int count)
 {
-	struct file * file;
-	struct compat_linux_dirent __user * lastdirent;
+	struct file *file;
+	struct compat_linux_dirent __user *lastdirent;
 	struct compat_getdents_callback buf;
 	int error;
 
@@ -1038,7 +1038,7 @@ struct compat_getdents_callback64 {
 	int error;
 };
 
-static int compat_filldir64(void * __buf, const char * name, int namlen, loff_t offset,
+static int compat_filldir64(void *__buf, const char *name, int namlen, loff_t offset,
 		     u64 ino, unsigned int d_type)
 {
 	struct linux_dirent64 __user *dirent;
@@ -1081,10 +1081,10 @@ efault:
 }
 
 asmlinkage long compat_sys_getdents64(unsigned int fd,
-		struct linux_dirent64 __user * dirent, unsigned int count)
+		struct linux_dirent64 __user *dirent, unsigned int count)
 {
-	struct file * file;
-	struct linux_dirent64 __user * lastdirent;
+	struct file *file;
+	struct linux_dirent64 __user *lastdirent;
 	struct compat_getdents_callback64 buf;
 	int error;
 
@@ -1455,10 +1455,10 @@ out:
  * compat_do_execve() is mostly a copy of do_execve(), with the exception
  * that it processes 32 bit argv and envp pointers.
  */
-int compat_do_execve(char * filename,
+int compat_do_execve(char *filename,
 	compat_uptr_t __user *argv,
 	compat_uptr_t __user *envp,
-	struct pt_regs * regs)
+	struct pt_regs *regs)
 {
 	struct linux_binprm *bprm;
 	struct file *file;
@@ -1501,11 +1501,13 @@ int compat_do_execve(char * filename,
 		goto out_file;
 
 	bprm->argc = compat_count(argv, MAX_ARG_STRINGS);
-	if ((retval = bprm->argc) < 0)
+	retval = bprm->argc;
+	if (retval < 0)
 		goto out;
 
 	bprm->envc = compat_count(envp, MAX_ARG_STRINGS);
-	if ((retval = bprm->envc) < 0)
+	retval =  bprm->envc;
+	if (retval < 0)
 		goto out;
 
 	retval = prepare_binprm(bprm);
@@ -1874,8 +1876,8 @@ asmlinkage long compat_sys_pselect6(int n, compat_ulong_t __user *inp,
 	if (sig) {
 		if (!access_ok(VERIFY_READ, sig,
 				sizeof(compat_uptr_t)+sizeof(compat_size_t)) ||
-		    	__get_user(up, (compat_uptr_t __user *)sig) ||
-		    	__get_user(sigsetsize,
+			__get_user(up, (compat_uptr_t __user *)sig) ||
+			__get_user(sigsetsize,
 				(compat_size_t __user *)(sig+sizeof(up))))
 			return -EFAULT;
 	}
@@ -2085,7 +2087,7 @@ static int compat_nfs_getfd_trans(struct nfsctl_arg *karg,
 static int compat_nfs_getfs_trans(struct nfsctl_arg *karg,
 				struct compat_nfsctl_arg __user *arg)
 {
-	if (!access_ok(VERIFY_READ,&arg->ca32_getfs,sizeof(arg->ca32_getfs)) ||
+	if (!access_ok(VERIFY_READ, &arg->ca32_getfs, sizeof(arg->ca32_getfs)) ||
 		get_user(karg->ca_version, &arg->ca32_version) ||
 		__copy_from_user(&karg->ca_getfs.gd_addr,
 				&arg->ca32_getfs.gd32_addr,
@@ -2124,12 +2126,12 @@ asmlinkage long compat_sys_nfsservctl(int cmd,
 
 	karg = kmalloc(sizeof(*karg), GFP_USER);
 	kres = kmalloc(sizeof(*kres), GFP_USER);
-	if(!karg || !kres) {
+	if (!karg || !kres) {
 		err = -ENOMEM;
 		goto done;
 	}
 
-	switch(cmd) {
+	switch (cmd) {
 	case NFSCTL_SVC:
 		err = compat_nfs_svc_trans(karg, arg);
 		break;
@@ -2172,7 +2174,7 @@ asmlinkage long compat_sys_nfsservctl(int cmd,
 	if (err)
 		goto done;
 
-	if((cmd == NFSCTL_GETFD) ||
+	if ((cmd == NFSCTL_GETFD) ||
 	   (cmd == NFSCTL_GETFS))
 		err = compat_nfs_getfh_res_trans(kres, res);
 
@@ -2286,7 +2288,7 @@ asmlinkage long compat_sys_timerfd_settime(int ufd, int flags,
 	error = sys_timerfd_settime(ufd, flags, &ut[0], &ut[1]);
 	if (!error && otmr)
 		error = (copy_from_user(&t, &ut[1], sizeof(struct itimerspec)) ||
-			 put_compat_itimerspec(otmr, &t)) ? -EFAULT: 0;
+			 put_compat_itimerspec(otmr, &t)) ? -EFAULT : 0;
 
 	return error;
 }
@@ -2302,7 +2304,7 @@ asmlinkage long compat_sys_timerfd_gettime(int ufd,
 	error = sys_timerfd_gettime(ufd, ut);
 	if (!error)
 		error = (copy_from_user(&t, ut, sizeof(struct itimerspec)) ||
-			 put_compat_itimerspec(otmr, &t)) ? -EFAULT: 0;
+			 put_compat_itimerspec(otmr, &t)) ? -EFAULT : 0;
 
 	return error;
 }
-- 
1.7.4.1

