Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938140Ab0CPRrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:47:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938110Ab0CPRr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:47:26 -0400
Date: Tue, 16 Mar 2010 13:47:01 -0400
From: Jason Baron <jbaron@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       hpa@zytor.com, tglx@linutronix.de, mhiramat@redhat.com,
       heiko.carstens@de.ibm.com, benh@kernel.crashing.org,
       davem@davemloft.net, lethal@linux-sh.org, schwidefsky@de.ibm.com,
       brueckner@linux.vnet.ibm.com, tony.luck@intel.com
Message-Id: <b5eab933e655309f3453313588ba2b216c8d1e3c.1268749695.git.jbaron@redhat.com>
In-Reply-To: <cover.1268749695.git.jbaron@redhat.com>
References: <cover.1268749695.git.jbaron@redhat.com>
Subject: [PATCH 11/14] compat: convert fs compat to use COMPAT_SYSCALL_DEFINE#N() macros
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

convert the fs/compat.c file to use the COMPAT_SYSCALL_DEFINE#N() macros to tie
them into the generic compat layer.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 fs/compat.c |  147 +++++++++++++++++++++++++++++------------------------------
 1 files changed, 72 insertions(+), 75 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 00d90c2..c20c2ca 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -75,7 +75,7 @@ int compat_printk(const char *fmt, ...)
  * Not all architectures have sys_utime, so implement this in terms
  * of sys_utimes.
  */
-asmlinkage long compat_sys_utime(char __user *filename, struct compat_utimbuf __user *t)
+COMPAT_SYSCALL_DEFINE2(utime, char __user *, filename, struct compat_utimbuf __user *, t)
 {
 	struct timespec tv[2];
 
@@ -89,7 +89,7 @@ asmlinkage long compat_sys_utime(char __user *filename, struct compat_utimbuf __
 	return do_utimes(AT_FDCWD, filename, t ? tv : NULL, 0);
 }
 
-asmlinkage long compat_sys_utimensat(unsigned int dfd, char __user *filename, struct compat_timespec __user *t, int flags)
+COMPAT_SYSCALL_DEFINE4(utimensat, unsigned int, dfd, char __user *, filename, struct compat_timespec __user *, t, int, flags)
 {
 	struct timespec tv[2];
 
@@ -104,7 +104,7 @@ asmlinkage long compat_sys_utimensat(unsigned int dfd, char __user *filename, st
 	return do_utimes(dfd, filename, t ? tv : NULL, flags);
 }
 
-asmlinkage long compat_sys_futimesat(unsigned int dfd, char __user *filename, struct compat_timeval __user *t)
+COMPAT_SYSCALL_DEFINE3(futimesat, unsigned int, dfd, char __user *, filename, struct compat_timeval __user *, t)
 {
 	struct timespec tv[2];
 
@@ -123,7 +123,7 @@ asmlinkage long compat_sys_futimesat(unsigned int dfd, char __user *filename, st
 	return do_utimes(dfd, filename, t ? tv : NULL, 0);
 }
 
-asmlinkage long compat_sys_utimes(char __user *filename, struct compat_timeval __user *t)
+COMPAT_SYSCALL_DEFINE2(utimes, char __user *, filename, struct compat_timeval __user *, t)
 {
 	return compat_sys_futimesat(AT_FDCWD, filename, t);
 }
@@ -167,8 +167,8 @@ static int cp_compat_stat(struct kstat *stat, struct compat_stat __user *ubuf)
 	return err;
 }
 
-asmlinkage long compat_sys_newstat(char __user * filename,
-		struct compat_stat __user *statbuf)
+COMPAT_SYSCALL_DEFINE2(newstat, char __user *, filename,
+			struct compat_stat __user *, statbuf)
 {
 	struct kstat stat;
 	int error;
@@ -179,8 +179,8 @@ asmlinkage long compat_sys_newstat(char __user * filename,
 	return cp_compat_stat(&stat, statbuf);
 }
 
-asmlinkage long compat_sys_newlstat(char __user * filename,
-		struct compat_stat __user *statbuf)
+COMPAT_SYSCALL_DEFINE2(newlstat, char __user *, filename,
+			struct compat_stat __user *, statbuf)
 {
 	struct kstat stat;
 	int error;
@@ -192,8 +192,8 @@ asmlinkage long compat_sys_newlstat(char __user * filename,
 }
 
 #ifndef __ARCH_WANT_STAT64
-asmlinkage long compat_sys_newfstatat(unsigned int dfd, char __user *filename,
-		struct compat_stat __user *statbuf, int flag)
+COMPAT_SYSCALL_DEFINE4(newfstatat, unsigned int, dfd, char __user *, filename,
+			struct compat_stat __user *, statbuf, int, flag)
 {
 	struct kstat stat;
 	int error;
@@ -205,8 +205,8 @@ asmlinkage long compat_sys_newfstatat(unsigned int dfd, char __user *filename,
 }
 #endif
 
-asmlinkage long compat_sys_newfstat(unsigned int fd,
-		struct compat_stat __user * statbuf)
+COMPAT_SYSCALL_DEFINE2(newfstat, unsigned int, fd,
+			struct compat_stat __user *, statbuf)
 {
 	struct kstat stat;
 	int error = vfs_fstat(fd, &stat);
@@ -257,7 +257,7 @@ static int put_compat_statfs(struct compat_statfs __user *ubuf, struct kstatfs *
  * The following statfs calls are copies of code from fs/open.c and
  * should be checked against those from time to time
  */
-asmlinkage long compat_sys_statfs(const char __user *pathname, struct compat_statfs __user *buf)
+COMPAT_SYSCALL_DEFINE2(statfs, const char __user *, pathname, struct compat_statfs __user *, buf)
 {
 	struct path path;
 	int error;
@@ -273,7 +273,7 @@ asmlinkage long compat_sys_statfs(const char __user *pathname, struct compat_sta
 	return error;
 }
 
-asmlinkage long compat_sys_fstatfs(unsigned int fd, struct compat_statfs __user *buf)
+COMPAT_SYSCALL_DEFINE2(fstatfs, unsigned int, fd, struct compat_statfs __user *, buf)
 {
 	struct file * file;
 	struct kstatfs tmp;
@@ -322,7 +322,7 @@ static int put_compat_statfs64(struct compat_statfs64 __user *ubuf, struct kstat
 	return 0;
 }
 
-asmlinkage long compat_sys_statfs64(const char __user *pathname, compat_size_t sz, struct compat_statfs64 __user *buf)
+COMPAT_SYSCALL_DEFINE3(statfs64, const char __user *, pathname, compat_size_t, sz, struct compat_statfs64 __user *, buf)
 {
 	struct path path;
 	int error;
@@ -341,7 +341,7 @@ asmlinkage long compat_sys_statfs64(const char __user *pathname, compat_size_t s
 	return error;
 }
 
-asmlinkage long compat_sys_fstatfs64(unsigned int fd, compat_size_t sz, struct compat_statfs64 __user *buf)
+COMPAT_SYSCALL_DEFINE3(fstatfs64, unsigned int, fd, compat_size_t, sz, struct compat_statfs64 __user *, buf)
 {
 	struct file * file;
 	struct kstatfs tmp;
@@ -367,7 +367,7 @@ out:
  * Given how simple this syscall is that apporach is more maintainable
  * than the various conversion hacks.
  */
-asmlinkage long compat_sys_ustat(unsigned dev, struct compat_ustat __user *u)
+COMPAT_SYSCALL_DEFINE2(ustat, unsigned, dev, struct compat_ustat __user *, u)
 {
 	struct super_block *sb;
 	struct compat_ustat tmp;
@@ -442,8 +442,8 @@ static int put_compat_flock64(struct flock *kfl, struct compat_flock64 __user *u
 }
 #endif
 
-asmlinkage long compat_sys_fcntl64(unsigned int fd, unsigned int cmd,
-		unsigned long arg)
+COMPAT_SYSCALL_DEFINE3(fcntl64, unsigned int, fd, unsigned int, cmd,
+			unsigned long, arg)
 {
 	mm_segment_t old_fs;
 	struct flock f;
@@ -511,16 +511,15 @@ asmlinkage long compat_sys_fcntl64(unsigned int fd, unsigned int cmd,
 	return ret;
 }
 
-asmlinkage long compat_sys_fcntl(unsigned int fd, unsigned int cmd,
-		unsigned long arg)
+COMPAT_SYSCALL_DEFINE3(fcntl, unsigned int, fd, unsigned int, cmd,
+			unsigned long, arg)
 {
 	if ((cmd == F_GETLK64) || (cmd == F_SETLK64) || (cmd == F_SETLKW64))
 		return -EINVAL;
 	return compat_sys_fcntl64(fd, cmd, arg);
 }
 
-asmlinkage long
-compat_sys_io_setup(unsigned nr_reqs, u32 __user *ctx32p)
+COMPAT_SYSCALL_DEFINE2(io_setup, unsigned, nr_reqs, u32 __user *, ctx32p)
 {
 	long ret;
 	aio_context_t ctx64;
@@ -539,12 +538,11 @@ compat_sys_io_setup(unsigned nr_reqs, u32 __user *ctx32p)
 	return ret;
 }
 
-asmlinkage long
-compat_sys_io_getevents(aio_context_t ctx_id,
-				 unsigned long min_nr,
-				 unsigned long nr,
-				 struct io_event __user *events,
-				 struct compat_timespec __user *timeout)
+COMPAT_SYSCALL_DEFINE5(io_getevents, aio_context_t, ctx_id,
+				 unsigned long, min_nr,
+				 unsigned long, nr,
+				 struct io_event __user *, events,
+				 struct compat_timespec __user *, timeout)
 {
 	long ret;
 	struct timespec t;
@@ -584,8 +582,7 @@ copy_iocb(long nr, u32 __user *ptr32, struct iocb __user * __user *ptr64)
 
 #define MAX_AIO_SUBMITS 	(PAGE_SIZE/sizeof(struct iocb *))
 
-asmlinkage long
-compat_sys_io_submit(aio_context_t ctx_id, int nr, u32 __user *iocb)
+COMPAT_SYSCALL_DEFINE3(io_submit, aio_context_t, ctx_id, int, nr, u32 __user *, iocb)
 {
 	struct iocb __user * __user *iocb64; 
 	long ret;
@@ -762,9 +759,9 @@ static int do_nfs4_super_data_conv(void *raw_data)
 #define NCPFS_NAME      "ncpfs"
 #define NFS4_NAME	"nfs4"
 
-asmlinkage long compat_sys_mount(char __user * dev_name, char __user * dir_name,
-				 char __user * type, unsigned long flags,
-				 void __user * data)
+COMPAT_SYSCALL_DEFINE5(mount, char __user *, dev_name, char __user *, dir_name,
+			char __user *, type, unsigned long, flags,
+			void __user *, data)
 {
 	char *kernel_type;
 	unsigned long data_page;
@@ -863,8 +860,9 @@ efault:
 	return -EFAULT;
 }
 
-asmlinkage long compat_sys_old_readdir(unsigned int fd,
-	struct compat_old_linux_dirent __user *dirent, unsigned int count)
+COMPAT_SYSCALL_DEFINE3(old_readdir, unsigned int, fd,
+			struct compat_old_linux_dirent __user *, dirent,
+			unsigned int, count)
 {
 	int error;
 	struct file *file;
@@ -943,8 +941,9 @@ efault:
 	return -EFAULT;
 }
 
-asmlinkage long compat_sys_getdents(unsigned int fd,
-		struct compat_linux_dirent __user *dirent, unsigned int count)
+COMPAT_SYSCALL_DEFINE3(getdents, unsigned int, fd,
+			struct compat_linux_dirent __user *, dirent,
+			unsigned int, count)
 {
 	struct file * file;
 	struct compat_linux_dirent __user * lastdirent;
@@ -1031,8 +1030,9 @@ efault:
 	return -EFAULT;
 }
 
-asmlinkage long compat_sys_getdents64(unsigned int fd,
-		struct linux_dirent64 __user * dirent, unsigned int count)
+COMPAT_SYSCALL_DEFINE3(getdents64, unsigned int, fd,
+			struct linux_dirent64 __user *, dirent,
+			unsigned int, count)
 {
 	struct file * file;
 	struct linux_dirent64 __user * lastdirent;
@@ -1291,9 +1291,8 @@ compat_sys_pwritev(unsigned long fd, const struct compat_iovec __user *vec,
 	return ret;
 }
 
-asmlinkage long
-compat_sys_vmsplice(int fd, const struct compat_iovec __user *iov32,
-		    unsigned int nr_segs, unsigned int flags)
+COMPAT_SYSCALL_DEFINE4(vmsplice, int, fd, const struct compat_iovec __user *, iov32,
+			unsigned int, nr_segs, unsigned int, flags)
 {
 	unsigned i;
 	struct iovec __user *iov;
@@ -1315,8 +1314,7 @@ compat_sys_vmsplice(int fd, const struct compat_iovec __user *iov32,
  * Exactly like fs/open.c:sys_open(), except that it doesn't set the
  * O_LARGEFILE flag.
  */
-asmlinkage long
-compat_sys_open(const char __user *filename, int flags, int mode)
+COMPAT_SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, int, mode)
 {
 	return do_sys_open(AT_FDCWD, filename, flags, mode);
 }
@@ -1325,8 +1323,7 @@ compat_sys_open(const char __user *filename, int flags, int mode)
  * Exactly like fs/open.c:sys_openat(), except that it doesn't set the
  * O_LARGEFILE flag.
  */
-asmlinkage long
-compat_sys_openat(unsigned int dfd, const char __user *filename, int flags, int mode)
+COMPAT_SYSCALL_DEFINE4(openat, unsigned int, dfd, const char __user *, filename, int, flags, int, mode)
 {
 	return do_sys_open(dfd, filename, flags, mode);
 }
@@ -1770,9 +1767,9 @@ out_nofds:
 	return ret;
 }
 
-asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
-	compat_ulong_t __user *outp, compat_ulong_t __user *exp,
-	struct compat_timeval __user *tvp)
+COMPAT_SYSCALL_DEFINE5(select, int, n, compat_ulong_t __user *, inp,
+			compat_ulong_t __user *, outp, compat_ulong_t __user *, exp,
+			struct compat_timeval __user *, tvp)
 {
 	struct timespec end_time, *to = NULL;
 	struct compat_timeval tv;
@@ -1847,9 +1844,9 @@ static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 	return ret;
 }
 
-asmlinkage long compat_sys_pselect6(int n, compat_ulong_t __user *inp,
-	compat_ulong_t __user *outp, compat_ulong_t __user *exp,
-	struct compat_timespec __user *tsp, void __user *sig)
+COMPAT_SYSCALL_DEFINE6(pselect6, int, n, compat_ulong_t __user *, inp,
+			compat_ulong_t __user *, outp, compat_ulong_t __user *, exp,
+			struct compat_timespec __user *, tsp, void __user *, sig)
 {
 	compat_size_t sigsetsize = 0;
 	compat_uptr_t up = 0;
@@ -1866,9 +1863,9 @@ asmlinkage long compat_sys_pselect6(int n, compat_ulong_t __user *inp,
 				 sigsetsize);
 }
 
-asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
-	unsigned int nfds, struct compat_timespec __user *tsp,
-	const compat_sigset_t __user *sigmask, compat_size_t sigsetsize)
+COMPAT_SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds,
+			unsigned int, nfds, struct compat_timespec __user *, tsp,
+			const compat_sigset_t __user *, sigmask, compat_size_t, sigsetsize)
 {
 	compat_sigset_t ss32;
 	sigset_t ksigmask, sigsaved;
@@ -2096,9 +2093,9 @@ static int compat_nfs_getfh_res_trans(union nfsctl_res *kres,
 	return (err) ? -EFAULT : 0;
 }
 
-asmlinkage long compat_sys_nfsservctl(int cmd,
-				struct compat_nfsctl_arg __user *arg,
-				union compat_nfsctl_res __user *res)
+COMPAT_SYSCALL_DEFINE3(nfsservctl, int cmd,
+			struct compat_nfsctl_arg __user *, arg,
+			union compat_nfsctl_res __user *, res)
 {
 	struct nfsctl_arg *karg;
 	union nfsctl_res *kres;
@@ -2174,11 +2171,11 @@ long asmlinkage compat_sys_nfsservctl(int cmd, void *notused, void *notused2)
 #ifdef CONFIG_EPOLL
 
 #ifdef HAVE_SET_RESTORE_SIGMASK
-asmlinkage long compat_sys_epoll_pwait(int epfd,
-			struct compat_epoll_event __user *events,
-			int maxevents, int timeout,
-			const compat_sigset_t __user *sigmask,
-			compat_size_t sigsetsize)
+COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
+			struct compat_epoll_event __user *, events,
+			int, maxevents, int, timeout,
+			const compat_sigset_t __user *, sigmask,
+			compat_size_t, sigsetsize)
 {
 	long err;
 	compat_sigset_t csigmask;
@@ -2223,9 +2220,9 @@ asmlinkage long compat_sys_epoll_pwait(int epfd,
 
 #ifdef CONFIG_SIGNALFD
 
-asmlinkage long compat_sys_signalfd4(int ufd,
-				     const compat_sigset_t __user *sigmask,
-				     compat_size_t sigsetsize, int flags)
+COMPAT_SYSCALL_DEFINE4(signalfd4, int, ufd,
+			const compat_sigset_t __user *, sigmask,
+			compat_size_t, sigsetsize, int, flags)
 {
 	compat_sigset_t ss32;
 	sigset_t tmp;
@@ -2243,9 +2240,9 @@ asmlinkage long compat_sys_signalfd4(int ufd,
 	return sys_signalfd4(ufd, ksigmask, sizeof(sigset_t), flags);
 }
 
-asmlinkage long compat_sys_signalfd(int ufd,
-				    const compat_sigset_t __user *sigmask,
-				    compat_size_t sigsetsize)
+COMPAT_SYSCALL_DEFINE3(signalfd, int, ufd,
+			const compat_sigset_t __user *, sigmask,
+			compat_size_t, sigsetsize)
 {
 	return compat_sys_signalfd4(ufd, sigmask, sigsetsize, 0);
 }
@@ -2253,9 +2250,9 @@ asmlinkage long compat_sys_signalfd(int ufd,
 
 #ifdef CONFIG_TIMERFD
 
-asmlinkage long compat_sys_timerfd_settime(int ufd, int flags,
-				   const struct compat_itimerspec __user *utmr,
-				   struct compat_itimerspec __user *otmr)
+COMPAT_SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
+			const struct compat_itimerspec __user *, utmr,
+			struct compat_itimerspec __user *, otmr)
 {
 	int error;
 	struct itimerspec t;
@@ -2274,8 +2271,8 @@ asmlinkage long compat_sys_timerfd_settime(int ufd, int flags,
 	return error;
 }
 
-asmlinkage long compat_sys_timerfd_gettime(int ufd,
-				   struct compat_itimerspec __user *otmr)
+COMPAT_SYSCALL_DEFINE2(timerfd_gettime, int, ufd,
+			struct compat_itimerspec __user *, otmr)
 {
 	int error;
 	struct itimerspec t;
-- 
1.6.5.1

