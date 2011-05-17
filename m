Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363Ab1ERSHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:07:14 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:26559 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab1ERSHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:07:11 -0400
Message-Id: <201105181807.p4II77NX015218@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 17 May 2011 14:41:06 -0400
Subject: [PATCH] clean up checkpatch warnings in <linux/compat.h>
In-Reply-To: <20110511153551.3514371b.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Moyer <jmoyer@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 18 May 2011 18:07:10.0477 (UTC) FILETIME=[683163D0:01CC1586]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I touched this file when adding support for the "tilegx" sub-architecture,
and Andrew Morton observed "The file's a mismash of old-style, wrong-style
and right-style.  There's no point in doing mishmash preservation!
May as well fix things up when we touch them."

Accordingly, this change makes <linux/compat.h> as checkpatch-clean
as possible.  It makes no semantic changes whatsoever.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 include/linux/compat.h |   74 ++++++++++++++++++++++++++---------------------
 1 files changed, 41 insertions(+), 33 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index e941848..644e1a4 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -27,7 +27,7 @@ typedef __compat_gid32_t	compat_gid_t;
 struct compat_sel_arg_struct;
 struct rusage;
 
-struct compat_itimerspec { 
+struct compat_itimerspec {
 	struct compat_timespec it_interval;
 	struct compat_timespec it_value;
 };
@@ -71,9 +71,9 @@ struct compat_timex {
 	compat_long_t stbcnt;
 	compat_int_t tai;
 
-	compat_int_t :32; compat_int_t :32; compat_int_t :32; compat_int_t :32;
-	compat_int_t :32; compat_int_t :32; compat_int_t :32; compat_int_t :32;
-	compat_int_t :32; compat_int_t :32; compat_int_t :32;
+	compat_int_t:32; compat_int_t:32; compat_int_t:32; compat_int_t:32;
+	compat_int_t:32; compat_int_t:32; compat_int_t:32; compat_int_t:32;
+	compat_int_t:32; compat_int_t:32; compat_int_t:32;
 };
 
 #define _COMPAT_NSIG_WORDS	(_COMPAT_NSIG / _COMPAT_NSIG_BPW)
@@ -82,8 +82,10 @@ typedef struct {
 	compat_sigset_word	sig[_COMPAT_NSIG_WORDS];
 } compat_sigset_t;
 
-extern int get_compat_timespec(struct timespec *, const struct compat_timespec __user *);
-extern int put_compat_timespec(const struct timespec *, struct compat_timespec __user *);
+extern int get_compat_timespec(struct timespec *,
+			       const struct compat_timespec __user *);
+extern int put_compat_timespec(const struct timespec *,
+			       struct compat_timespec __user *);
 
 struct compat_iovec {
 	compat_uptr_t	iov_base;
@@ -114,7 +116,8 @@ struct compat_rusage {
 	compat_long_t	ru_nivcsw;
 };
 
-extern int put_compat_rusage(const struct rusage *, struct compat_rusage __user *);
+extern int put_compat_rusage(const struct rusage *,
+			     struct compat_rusage __user *);
 
 struct compat_siginfo;
 
@@ -167,8 +170,7 @@ struct compat_ifmap {
 	unsigned char port;
 };
 
-struct compat_if_settings
-{
+struct compat_if_settings {
 	unsigned int type;	/* Type of physical device or protocol */
 	unsigned int size;	/* Size of the data allocated by the caller */
 	compat_uptr_t ifs_ifsu;	/* union of pointers */
@@ -196,8 +198,8 @@ struct compat_ifreq {
 };
 
 struct compat_ifconf {
-        compat_int_t	ifc_len;                        /* size of buffer       */
-        compat_caddr_t  ifcbuf;
+	compat_int_t	ifc_len;                /* size of buffer */
+	compat_caddr_t  ifcbuf;
 };
 
 struct compat_robust_list {
@@ -256,8 +258,8 @@ asmlinkage ssize_t compat_sys_pwritev(unsigned long fd,
 		const struct compat_iovec __user *vec,
 		unsigned long vlen, u32 pos_low, u32 pos_high);
 
-int compat_do_execve(char * filename, compat_uptr_t __user *argv,
-	        compat_uptr_t __user *envp, struct pt_regs * regs);
+int compat_do_execve(char *filename, compat_uptr_t __user *argv,
+		     compat_uptr_t __user *envp, struct pt_regs *regs);
 
 asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
 		compat_ulong_t __user *outp, compat_ulong_t __user *exp,
@@ -346,14 +348,16 @@ asmlinkage long compat_sys_epoll_pwait(int epfd,
 
 asmlinkage long compat_sys_utime(const char __user *filename,
 				 struct compat_utimbuf __user *t);
-asmlinkage long compat_sys_utimensat(unsigned int dfd, const char __user *filename,
-				struct compat_timespec __user *t, int flags);
+asmlinkage long compat_sys_utimensat(unsigned int dfd,
+				     const char __user *filename,
+				     struct compat_timespec __user *t,
+				     int flags);
 
 asmlinkage long compat_sys_time(compat_time_t __user *tloc);
 asmlinkage long compat_sys_stime(compat_time_t __user *tptr);
 asmlinkage long compat_sys_signalfd(int ufd,
-				const compat_sigset_t __user *sigmask,
-                                compat_size_t sigsetsize);
+				    const compat_sigset_t __user *sigmask,
+				    compat_size_t sigsetsize);
 asmlinkage long compat_sys_timerfd_settime(int ufd, int flags,
 				   const struct compat_itimerspec __user *utmr,
 				   struct compat_itimerspec __user *otmr);
@@ -365,19 +369,21 @@ asmlinkage long compat_sys_move_pages(pid_t pid, unsigned long nr_page,
 				      const int __user *nodes,
 				      int __user *status,
 				      int flags);
-asmlinkage long compat_sys_futimesat(unsigned int dfd, const char __user *filename,
+asmlinkage long compat_sys_futimesat(unsigned int dfd,
+				     const char __user *filename,
 				     struct compat_timeval __user *t);
 asmlinkage long compat_sys_utimes(const char __user *filename,
 				  struct compat_timeval __user *t);
-asmlinkage long compat_sys_newstat(const char __user * filename,
+asmlinkage long compat_sys_newstat(const char __user *filename,
 				   struct compat_stat __user *statbuf);
-asmlinkage long compat_sys_newlstat(const char __user * filename,
+asmlinkage long compat_sys_newlstat(const char __user *filename,
 				    struct compat_stat __user *statbuf);
-asmlinkage long compat_sys_newfstatat(unsigned int dfd, const char __user * filename,
+asmlinkage long compat_sys_newfstatat(unsigned int dfd,
+				      const char __user *filename,
 				      struct compat_stat __user *statbuf,
 				      int flag);
 asmlinkage long compat_sys_newfstat(unsigned int fd,
-				    struct compat_stat __user * statbuf);
+				    struct compat_stat __user *statbuf);
 asmlinkage long compat_sys_statfs(const char __user *pathname,
 				  struct compat_statfs __user *buf);
 asmlinkage long compat_sys_fstatfs(unsigned int fd,
@@ -399,10 +405,10 @@ asmlinkage long compat_sys_io_getevents(aio_context_t ctx_id,
 					struct compat_timespec __user *timeout);
 asmlinkage long compat_sys_io_submit(aio_context_t ctx_id, int nr,
 				     u32 __user *iocb);
-asmlinkage long compat_sys_mount(const char __user * dev_name,
-				 const char __user * dir_name,
-				 const char __user * type, unsigned long flags,
-				 const void __user * data);
+asmlinkage long compat_sys_mount(const char __user *dev_name,
+				 const char __user *dir_name,
+				 const char __user *type, unsigned long flags,
+				 const void __user *data);
 asmlinkage long compat_sys_old_readdir(unsigned int fd,
 				       struct compat_old_linux_dirent __user *,
 				       unsigned int count);
@@ -410,7 +416,7 @@ asmlinkage long compat_sys_getdents(unsigned int fd,
 				    struct compat_linux_dirent __user *dirent,
 				    unsigned int count);
 asmlinkage long compat_sys_getdents64(unsigned int fd,
-				      struct linux_dirent64 __user * dirent,
+				      struct linux_dirent64 __user *dirent,
 				      unsigned int count);
 asmlinkage long compat_sys_vmsplice(int fd, const struct compat_iovec __user *,
 				    unsigned int nr_segs, unsigned int flags);
@@ -431,14 +437,15 @@ asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
 				 struct compat_timespec __user *tsp,
 				 const compat_sigset_t __user *sigmask,
 				 compat_size_t sigsetsize);
-#if (defined(CONFIG_NFSD) || defined(CONFIG_NFSD_MODULE)) && !defined(CONFIG_NFSD_DEPRECATED)
+#if (defined(CONFIG_NFSD) || defined(CONFIG_NFSD_MODULE)) && \
+	!defined(CONFIG_NFSD_DEPRECATED)
 union compat_nfsctl_res;
 struct compat_nfsctl_arg;
 asmlinkage long compat_sys_nfsservctl(int cmd,
 				      struct compat_nfsctl_arg __user *arg,
 				      union compat_nfsctl_res __user *res);
 #else
-long asmlinkage compat_sys_nfsservctl(int cmd, void *notused, void *notused2);
+asmlinkage long compat_sys_nfsservctl(int cmd, void *notused, void *notused2);
 #endif
 asmlinkage long compat_sys_signalfd4(int ufd,
 				     const compat_sigset_t __user *sigmask,
@@ -479,8 +486,8 @@ asmlinkage long compat_sys_setitimer(int which,
 asmlinkage long compat_sys_times(struct compat_tms __user *tbuf);
 asmlinkage long compat_sys_setrlimit(unsigned int resource,
 				     struct compat_rlimit __user *rlim);
-asmlinkage long compat_sys_getrlimit (unsigned int resource,
-				      struct compat_rlimit __user *rlim);
+asmlinkage long compat_sys_getrlimit(unsigned int resource,
+				     struct compat_rlimit __user *rlim);
 asmlinkage long compat_sys_getrusage(int who, struct compat_rusage __user *ru);
 asmlinkage long compat_sys_sched_setaffinity(compat_pid_t pid,
 				     unsigned int len,
@@ -507,7 +514,7 @@ asmlinkage long compat_sys_clock_getres(clockid_t which_clock,
 asmlinkage long compat_sys_clock_nanosleep(clockid_t which_clock, int flags,
 					   struct compat_timespec __user *rqtp,
 					   struct compat_timespec __user *rmtp);
-asmlinkage long compat_sys_rt_sigtimedwait (compat_sigset_t __user *uthese,
+asmlinkage long compat_sys_rt_sigtimedwait(compat_sigset_t __user *uthese,
 		struct compat_siginfo __user *uinfo,
 		struct compat_timespec __user *uts, compat_size_t sigsetsize);
 asmlinkage long compat_sys_rt_sigsuspend(compat_sigset_t __user *unewset,
@@ -544,7 +551,8 @@ asmlinkage long compat_sys_socketcall(int call, u32 __user *args);
 asmlinkage long compat_sys_sysctl(struct compat_sysctl_args __user *args);
 
 extern ssize_t compat_rw_copy_check_uvector(int type,
-		const struct compat_iovec __user *uvector, unsigned long nr_segs,
+		const struct compat_iovec __user *uvector,
+		unsigned long nr_segs,
 		unsigned long fast_segs, struct iovec *fast_pointer,
 		struct iovec **ret_pointer);
 
-- 
1.6.5.2

