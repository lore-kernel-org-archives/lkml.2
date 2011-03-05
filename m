Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184Ab1CEBno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:43:44 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:21311 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab1CEBnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:43:43 -0500
Date: Fri, 4 Mar 2011 17:42:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] kernel/signal.c: add kernel-doc to syscalls
Message-Id: <20110304174239.9632800a.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D71954D.007F,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add kernel-doc to syscalls in signal.c.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/signal.c |   65 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 2 deletions(-)

--- lnx-2638-rc7.orig/kernel/signal.c
+++ lnx-2638-rc7/kernel/signal.c
@@ -2061,6 +2061,9 @@ EXPORT_SYMBOL(unblock_all_signals);
  * System call entry points.
  */
 
+/**
+ *  sys_restart_syscall - restart a system call
+ */
 SYSCALL_DEFINE0(restart_syscall)
 {
 	struct restart_block *restart = &current_thread_info()->restart_block;
@@ -2114,6 +2117,13 @@ int sigprocmask(int how, sigset_t *set, 
 	return error;
 }
 
+/**
+ *  sys_rt_sigprocmask - change the list of currently blocked signals
+ *  @how: whether to add, remove, or set signals
+ *  @set: stores pending signals
+ *  @oset: previous value of signal mask if non-null
+ *  @sigsetsize: size of sigset_t type
+ */
 SYSCALL_DEFINE4(rt_sigprocmask, int, how, sigset_t __user *, set,
 		sigset_t __user *, oset, size_t, sigsetsize)
 {
@@ -2174,6 +2184,12 @@ out:
 	return error;
 }
 
+/**
+ *  sys_rt_sigpending - examine a pending signal that has been raised
+ *			while blocked
+ *  @set: stores pending signals
+ *  @sigsetsize: size of sigset_t type or larger
+ */
 SYSCALL_DEFINE2(rt_sigpending, sigset_t __user *, set, size_t, sigsetsize)
 {
 	return do_sigpending(set, sigsetsize);
@@ -2253,6 +2269,14 @@ int copy_siginfo_to_user(siginfo_t __use
 
 #endif
 
+/**
+ *  sys_rt_sigtimedwait - synchronously wait for queued signals specified
+ *			in @uthese
+ *  @uthese: queued signals to wait for
+ *  @uinfo: if non-null, the signal's siginfo is returned here
+ *  @uts: upper bound on process time suspension
+ *  @sigsetsize: size of sigset_t type
+ */
 SYSCALL_DEFINE4(rt_sigtimedwait, const sigset_t __user *, uthese,
 		siginfo_t __user *, uinfo, const struct timespec __user *, uts,
 		size_t, sigsetsize)
@@ -2330,6 +2354,11 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const s
 	return ret;
 }
 
+/**
+ *  sys_kill - send a signal to a process
+ *  @pid: the PID of the process
+ *  @sig: signal to be sent
+ */
 SYSCALL_DEFINE2(kill, pid_t, pid, int, sig)
 {
 	struct siginfo info;
@@ -2405,7 +2434,11 @@ SYSCALL_DEFINE3(tgkill, pid_t, tgid, pid
 	return do_tkill(tgid, pid, sig);
 }
 
-/*
+/**
+ *  sys_tkill - send signal to one specific task
+ *  @pid: the PID of the task
+ *  @sig: signal to be sent
+ *
  *  Send a signal to only one task, even if it's a CLONE_THREAD task.
  */
 SYSCALL_DEFINE2(tkill, pid_t, pid, int, sig)
@@ -2417,6 +2450,12 @@ SYSCALL_DEFINE2(tkill, pid_t, pid, int, 
 	return do_tkill(0, pid, sig);
 }
 
+/**
+ *  sys_rt_sigqueueinfo - send signal information to a signal
+ *  @pid: the PID of the thread
+ *  @sig: signal to be sent
+ *  @uinfo: signal info to be sent
+ */
 SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t, pid, int, sig,
 		siginfo_t __user *, uinfo)
 {
@@ -2574,6 +2613,10 @@ out:
 
 #ifdef __ARCH_WANT_SYS_SIGPENDING
 
+/**
+ *  sys_sigpending - examine pending signals
+ *  @set: where mask of pending signal is returned
+ */
 SYSCALL_DEFINE1(sigpending, old_sigset_t __user *, set)
 {
 	return do_sigpending(set, sizeof(*set));
@@ -2582,7 +2625,12 @@ SYSCALL_DEFINE1(sigpending, old_sigset_t
 #endif
 
 #ifdef __ARCH_WANT_SYS_SIGPROCMASK
-/*
+/**
+ *  sys_sigprocmask - examine and change blocked signals
+ *  @how: whether to add, remove, or set signals
+ *  @set: signals to add or remove (if non-null)
+ *  @oset: previous value of signal mask if non-null
+ *
  * Some platforms have their own version with special arguments;
  * others support only sys_rt_sigprocmask.
  */
@@ -2638,6 +2686,13 @@ out:
 #endif /* __ARCH_WANT_SYS_SIGPROCMASK */
 
 #ifdef __ARCH_WANT_SYS_RT_SIGACTION
+/**
+ *  sys_rt_sigaction - alter an action taken by a process
+ *  @sig: signal to be sent
+ *  @act: the thread group ID of the thread
+ *  @oact: the PID of the thread
+ *  @sigsetsize: size of sigset_t type
+ */
 SYSCALL_DEFINE4(rt_sigaction, int, sig,
 		const struct sigaction __user *, act,
 		struct sigaction __user *, oact,
@@ -2724,6 +2779,12 @@ SYSCALL_DEFINE0(pause)
 #endif
 
 #ifdef __ARCH_WANT_SYS_RT_SIGSUSPEND
+/**
+ *  sys_rt_sigsuspend - replace the signal mask for a value with the
+ *	@unewset value until a signal is received
+ *  @unewset: new signal mask value
+ *  @sigsetsize: size of sigset_t type
+ */
 SYSCALL_DEFINE2(rt_sigsuspend, sigset_t __user *, unewset, size_t, sigsetsize)
 {
 	sigset_t newset;
