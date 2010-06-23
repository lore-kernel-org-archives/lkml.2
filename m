Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab0FWKLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:11:45 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:51555 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab0FWKEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:21 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH 12/40] x86, compat: convert ia32 layer to use
Date: Wed, 23 Jun 2010 20:02:53 +1000
Message-Id: <1277287401-28571-13-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Make use of the new ARCH_COMPAT_SYSCALL_DEFINE#N() macros to tie the compat
syscalls into the event tracer.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/x86/ia32/sys_ia32.c |  102 +++++++++++++++++++++++-----------------------
 1 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 626be15..a844f54 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -51,15 +51,15 @@
 #define AA(__x)		((unsigned long)(__x))
 
 
-asmlinkage long sys32_truncate64(char __user *filename,
-				 unsigned long offset_low,
-				 unsigned long offset_high)
+ARCH_COMPAT_SYSCALL_DEFINE3(truncate64, char __user *, filename,
+				 unsigned long, offset_low,
+				 unsigned long, offset_high)
 {
        return sys_truncate(filename, ((loff_t) offset_high << 32) | offset_low);
 }
 
-asmlinkage long sys32_ftruncate64(unsigned int fd, unsigned long offset_low,
-				  unsigned long offset_high)
+ARCH_COMPAT_SYSCALL_DEFINE3(ftruncate64, unsigned int, fd, unsigned long, offset_low,
+				  unsigned long, offset_high)
 {
        return sys_ftruncate(fd, ((loff_t) offset_high << 32) | offset_low);
 }
@@ -96,8 +96,8 @@ static int cp_stat64(struct stat64 __user *ubuf, struct kstat *stat)
 	return 0;
 }
 
-asmlinkage long sys32_stat64(char __user *filename,
-			     struct stat64 __user *statbuf)
+ARCH_COMPAT_SYSCALL_DEFINE2(stat64, char __user *, filename,
+			     struct stat64 __user *, statbuf)
 {
 	struct kstat stat;
 	int ret = vfs_stat(filename, &stat);
@@ -107,8 +107,8 @@ asmlinkage long sys32_stat64(char __user *filename,
 	return ret;
 }
 
-asmlinkage long sys32_lstat64(char __user *filename,
-			      struct stat64 __user *statbuf)
+ARCH_COMPAT_SYSCALL_DEFINE2(lstat64, char __user *, filename,
+			      struct stat64 __user *, statbuf)
 {
 	struct kstat stat;
 	int ret = vfs_lstat(filename, &stat);
@@ -117,7 +117,7 @@ asmlinkage long sys32_lstat64(char __user *filename,
 	return ret;
 }
 
-asmlinkage long sys32_fstat64(unsigned int fd, struct stat64 __user *statbuf)
+ARCH_COMPAT_SYSCALL_DEFINE2(fstat64, unsigned int, fd, struct stat64 __user *, statbuf)
 {
 	struct kstat stat;
 	int ret = vfs_fstat(fd, &stat);
@@ -126,8 +126,8 @@ asmlinkage long sys32_fstat64(unsigned int fd, struct stat64 __user *statbuf)
 	return ret;
 }
 
-asmlinkage long sys32_fstatat(unsigned int dfd, char __user *filename,
-			      struct stat64 __user *statbuf, int flag)
+ARCH_COMPAT_SYSCALL_DEFINE4(fstatat, unsigned int, dfd, char __user *, filename,
+			      struct stat64 __user *, statbuf, int, flag)
 {
 	struct kstat stat;
 	int error;
@@ -153,7 +153,7 @@ struct mmap_arg_struct32 {
 	unsigned int offset;
 };
 
-asmlinkage long sys32_mmap(struct mmap_arg_struct32 __user *arg)
+ARCH_COMPAT_SYSCALL_DEFINE1(mmap, struct mmap_arg_struct32 __user *, arg)
 {
 	struct mmap_arg_struct32 a;
 
@@ -167,15 +167,15 @@ asmlinkage long sys32_mmap(struct mmap_arg_struct32 __user *arg)
 			       a.offset>>PAGE_SHIFT);
 }
 
-asmlinkage long sys32_mprotect(unsigned long start, size_t len,
-			       unsigned long prot)
+ARCH_COMPAT_SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
+			       unsigned long, prot)
 {
 	return sys_mprotect(start, len, prot);
 }
 
-asmlinkage long sys32_rt_sigaction(int sig, struct sigaction32 __user *act,
-				   struct sigaction32 __user *oact,
-				   unsigned int sigsetsize)
+ARCH_COMPAT_SYSCALL_DEFINE4(rt_sigaction, int, sig, struct sigaction32 __user *, act,
+				   struct sigaction32 __user *, oact,
+				   unsigned int, sigsetsize)
 {
 	struct k_sigaction new_ka, old_ka;
 	int ret;
@@ -249,8 +249,8 @@ asmlinkage long sys32_rt_sigaction(int sig, struct sigaction32 __user *act,
 	return ret;
 }
 
-asmlinkage long sys32_sigaction(int sig, struct old_sigaction32 __user *act,
-				struct old_sigaction32 __user *oact)
+ARCH_COMPAT_SYSCALL_DEFINE3(sigaction, int, sig, struct old_sigaction32 __user *, act,
+				struct old_sigaction32 __user *, oact)
 {
 	struct k_sigaction new_ka, old_ka;
 	int ret;
@@ -288,9 +288,9 @@ asmlinkage long sys32_sigaction(int sig, struct old_sigaction32 __user *act,
 	return ret;
 }
 
-asmlinkage long sys32_rt_sigprocmask(int how, compat_sigset_t __user *set,
-				     compat_sigset_t __user *oset,
-				     unsigned int sigsetsize)
+ARCH_COMPAT_SYSCALL_DEFINE4(rt_sigprocmask, int, how, compat_sigset_t __user *, set,
+				     compat_sigset_t __user *, oset,
+				     unsigned int, sigsetsize)
 {
 	sigset_t s;
 	compat_sigset_t s32;
@@ -328,26 +328,26 @@ asmlinkage long sys32_rt_sigprocmask(int how, compat_sigset_t __user *set,
 	return 0;
 }
 
-asmlinkage long sys32_alarm(unsigned int seconds)
+ARCH_COMPAT_SYSCALL_DEFINE1(alarm, unsigned int, seconds)
 {
 	return alarm_setitimer(seconds);
 }
 
-asmlinkage long sys32_waitpid(compat_pid_t pid, unsigned int *stat_addr,
-			      int options)
+ARCH_COMPAT_SYSCALL_DEFINE3(waitpid, compat_pid_t, pid, unsigned int *, stat_addr,
+			      int, options)
 {
 	return compat_sys_wait4(pid, stat_addr, options, NULL);
 }
 
 /* 32-bit timeval and related flotsam.  */
 
-asmlinkage long sys32_sysfs(int option, u32 arg1, u32 arg2)
+ARCH_COMPAT_SYSCALL_DEFINE3(sysfs, int, option, u32, arg1, u32, arg2)
 {
 	return sys_sysfs(option, arg1, arg2);
 }
 
-asmlinkage long sys32_sched_rr_get_interval(compat_pid_t pid,
-				    struct compat_timespec __user *interval)
+ARCH_COMPAT_SYSCALL_DEFINE2(sched_rr_get_interval, compat_pid_t, pid,
+				    struct compat_timespec __user *, interval)
 {
 	struct timespec t;
 	int ret;
@@ -361,8 +361,8 @@ asmlinkage long sys32_sched_rr_get_interval(compat_pid_t pid,
 	return ret;
 }
 
-asmlinkage long sys32_rt_sigpending(compat_sigset_t __user *set,
-				    compat_size_t sigsetsize)
+ARCH_COMPAT_SYSCALL_DEFINE2(rt_sigpending, compat_sigset_t __user *, set,
+				    compat_size_t, sigsetsize)
 {
 	sigset_t s;
 	compat_sigset_t s32;
@@ -385,8 +385,8 @@ asmlinkage long sys32_rt_sigpending(compat_sigset_t __user *set,
 	return ret;
 }
 
-asmlinkage long sys32_rt_sigqueueinfo(int pid, int sig,
-				      compat_siginfo_t __user *uinfo)
+ARCH_COMPAT_SYSCALL_DEFINE3(rt_sigqueueinfo, int, pid, int, sig,
+				      compat_siginfo_t __user *, uinfo)
 {
 	siginfo_t info;
 	int ret;
@@ -401,22 +401,22 @@ asmlinkage long sys32_rt_sigqueueinfo(int pid, int sig,
 }
 
 /* warning: next two assume little endian */
-asmlinkage long sys32_pread(unsigned int fd, char __user *ubuf, u32 count,
-			    u32 poslo, u32 poshi)
+ARCH_COMPAT_SYSCALL_DEFINE5(pread, unsigned int, fd, char __user *, ubuf, u32, count,
+			    u32, poslo, u32, poshi)
 {
 	return sys_pread64(fd, ubuf, count,
 			 ((loff_t)AA(poshi) << 32) | AA(poslo));
 }
 
-asmlinkage long sys32_pwrite(unsigned int fd, char __user *ubuf, u32 count,
-			     u32 poslo, u32 poshi)
+ARCH_COMPAT_SYSCALL_DEFINE5(pwrite, unsigned int, fd, char __user *, ubuf, u32, count,
+			     u32, poslo, u32, poshi)
 {
 	return sys_pwrite64(fd, ubuf, count,
 			  ((loff_t)AA(poshi) << 32) | AA(poslo));
 }
 
 
-asmlinkage long sys32_personality(unsigned long personality)
+ARCH_COMPAT_SYSCALL_DEFINE1(personality, unsigned long, personality)
 {
 	int ret;
 
@@ -429,8 +429,8 @@ asmlinkage long sys32_personality(unsigned long personality)
 	return ret;
 }
 
-asmlinkage long sys32_sendfile(int out_fd, int in_fd,
-			       compat_off_t __user *offset, s32 count)
+ARCH_COMPAT_SYSCALL_DEFINE4(sendfile, int, out_fd, int, in_fd,
+			       compat_off_t __user *, offset, s32, count)
 {
 	mm_segment_t old_fs = get_fs();
 	int ret;
@@ -449,8 +449,8 @@ asmlinkage long sys32_sendfile(int out_fd, int in_fd,
 	return ret;
 }
 
-asmlinkage long sys32_execve(char __user *name, compat_uptr_t __user *argv,
-			     compat_uptr_t __user *envp, struct pt_regs *regs)
+ARCH_COMPAT_SYSCALL_DEFINE4(execve, char __user *, name, compat_uptr_t __user *, argv,
+			compat_uptr_t __user *, envp, struct pt_regs *, regs)
 {
 	long error;
 	char *filename;
@@ -464,8 +464,8 @@ asmlinkage long sys32_execve(char __user *name, compat_uptr_t __user *argv,
 	return error;
 }
 
-asmlinkage long sys32_clone(unsigned int clone_flags, unsigned int newsp,
-			    struct pt_regs *regs)
+ARCH_COMPAT_SYSCALL_DEFINE3(clone, unsigned int, clone_flags, unsigned int, newsp,
+			    struct pt_regs *, regs)
 {
 	void __user *parent_tid = (void __user *)regs->dx;
 	void __user *child_tid = (void __user *)regs->di;
@@ -524,24 +524,24 @@ asmlinkage ssize_t sys32_readahead(int fd, unsigned off_lo, unsigned off_hi,
 	return sys_readahead(fd, ((u64)off_hi << 32) | off_lo, count);
 }
 
-asmlinkage long sys32_sync_file_range(int fd, unsigned off_low, unsigned off_hi,
-				      unsigned n_low, unsigned n_hi,  int flags)
+ARCH_COMPAT_SYSCALL_DEFINE6(sync_file_range, int, fd, unsigned, off_low, unsigned, off_hi,
+			unsigned, n_low, unsigned, n_hi,  int, flags)
 {
 	return sys_sync_file_range(fd,
 				   ((u64)off_hi << 32) | off_low,
 				   ((u64)n_hi << 32) | n_low, flags);
 }
 
-asmlinkage long sys32_fadvise64(int fd, unsigned offset_lo, unsigned offset_hi,
-				size_t len, int advice)
+ARCH_COMPAT_SYSCALL_DEFINE5(fadvise64, int, fd, unsigned, offset_lo, unsigned, offset_hi,
+				size_t, len, int, advice)
 {
 	return sys_fadvise64_64(fd, ((u64)offset_hi << 32) | offset_lo,
 				len, advice);
 }
 
-asmlinkage long sys32_fallocate(int fd, int mode, unsigned offset_lo,
-				unsigned offset_hi, unsigned len_lo,
-				unsigned len_hi)
+ARCH_COMPAT_SYSCALL_DEFINE6(fallocate, int, fd, int, mode, unsigned, offset_lo,
+				unsigned, offset_hi, unsigned, len_lo,
+				unsigned, len_hi)
 {
 	return sys_fallocate(fd, mode, ((u64)offset_hi << 32) | offset_lo,
 			     ((u64)len_hi << 32) | len_lo);
-- 
1.7.1

