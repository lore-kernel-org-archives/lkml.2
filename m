Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab1DDWMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:12:48 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:39389 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752484Ab1DDWMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:12:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Atdy6rqyOia91QwBaVD0zNb+vuarekyBzcVH0SGTVXQvh6sZ87D6TsKF0767DgZGEnEHk2X4tmiXTQ4yFS0FlTqULPxLJ7+/o6DHLDgJuubARLQabMZ1k5IjOCDhvh73;
Date: Mon, 4 Apr 2011 15:00:26 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3/8] kernel/signal.c: add kernel-doc notation to syscalls
Message-Id: <20110404150026.46478a04.rdunlap@xenotime.net>
In-Reply-To: <20110404145803.8663081d.rdunlap@xenotime.net>
References: <20110404145803.8663081d.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add kernel-doc to syscalls in signal.c.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/signal.c |   65 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 2 deletions(-)

--- linux-2.6.38-git18.orig/kernel/signal.c
+++ linux-2.6.38-git18/kernel/signal.c
@@ -2075,6 +2075,9 @@ EXPORT_SYMBOL(unblock_all_signals);
  * System call entry points.
  */
 
+/**
+ *  sys_restart_syscall - restart a system call
+ */
 SYSCALL_DEFINE0(restart_syscall)
 {
 	struct restart_block *restart = &current_thread_info()->restart_block;
@@ -2128,6 +2131,13 @@ int sigprocmask(int how, sigset_t *set, 
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
@@ -2188,6 +2198,12 @@ out:
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
@@ -2267,6 +2283,14 @@ int copy_siginfo_to_user(siginfo_t __use
 
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
@@ -2344,6 +2368,11 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const s
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
@@ -2419,7 +2448,11 @@ SYSCALL_DEFINE3(tgkill, pid_t, tgid, pid
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
@@ -2431,6 +2464,12 @@ SYSCALL_DEFINE2(tkill, pid_t, pid, int, 
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
@@ -2596,6 +2635,10 @@ out:
 
 #ifdef __ARCH_WANT_SYS_SIGPENDING
 
+/**
+ *  sys_sigpending - examine pending signals
+ *  @set: where mask of pending signal is returned
+ */
 SYSCALL_DEFINE1(sigpending, old_sigset_t __user *, set)
 {
 	return do_sigpending(set, sizeof(*set));
@@ -2604,7 +2647,12 @@ SYSCALL_DEFINE1(sigpending, old_sigset_t
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
@@ -2660,6 +2708,13 @@ out:
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
@@ -2746,6 +2801,12 @@ SYSCALL_DEFINE0(pause)
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
