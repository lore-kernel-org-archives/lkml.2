Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458Ab0JYXju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:39:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53159 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758414Ab0JYXjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:39:48 -0400
Date: Mon, 25 Oct 2010 16:03:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] signal.c: coding style and comment fixes
Message-Id: <20101025160304.49385168.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

General coding style and comment fixes:

- Use multi-line-comment coding style.
- Hyphenate some words.
- Spell Posix as POSIX.
- Correct typos & spellos in some comments.
- Drop trailing whitespace.
- End sentences with periods.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/signal.c |   82 +++++++++++++++++++++++++---------------------
 1 file changed, 45 insertions(+), 37 deletions(-)

--- linux-2.6.36-git6.orig/kernel/signal.c
+++ linux-2.6.36-git6/kernel/signal.c
@@ -375,15 +375,15 @@ int unhandled_signal(struct task_struct 
 	return !tracehook_consider_fatal_signal(tsk, sig);
 }
 
-
-/* Notify the system that a driver wants to block all signals for this
+/*
+ * Notify the system that a driver wants to block all signals for this
  * process, and wants to be notified if any signals at all were to be
  * sent/acted upon.  If the notifier routine returns non-zero, then the
  * signal will be acted upon after all.  If the notifier routine returns 0,
  * then then signal will be blocked.  Only one block per process is
  * allowed.  priv is a pointer to private data that the notifier routine
- * can use to determine if the signal should be blocked or not.  */
-
+ * can use to determine if the signal should be blocked or not.
+ */
 void
 block_all_signals(int (*notifier)(void *priv), void *priv, sigset_t *mask)
 {
@@ -434,9 +434,10 @@ still_pending:
 		copy_siginfo(info, &first->info);
 		__sigqueue_free(first);
 	} else {
-		/* Ok, it wasn't in the queue.  This must be
-		   a fast-pathed signal or we must have been
-		   out of queue space.  So zero out the info.
+		/*
+		 * Ok, it wasn't in the queue.  This must be
+		 * a fast-pathed signal or we must have been
+		 * out of queue space.  So zero out the info.
 		 */
 		info->si_signo = sig;
 		info->si_errno = 0;
@@ -468,7 +469,7 @@ static int __dequeue_signal(struct sigpe
 }
 
 /*
- * Dequeue a signal and return the element to the caller, which is 
+ * Dequeue a signal and return the element to the caller, which is
  * expected to free it.
  *
  * All callers have to hold the siglock.
@@ -490,7 +491,7 @@ int dequeue_signal(struct task_struct *t
 		 * itimers are process shared and we restart periodic
 		 * itimers in the signal delivery path to prevent DoS
 		 * attacks in the high resolution timer case. This is
-		 * compliant with the old way of self restarting
+		 * compliant with the old way of self-restarting
 		 * itimers, as the SIGALRM is a legacy signal and only
 		 * queued once. Changing the restart behaviour to
 		 * restart the timer in the signal dequeue path is
@@ -909,14 +910,15 @@ static int __send_signal(int sig, struct
 	if (info == SEND_SIG_FORCED)
 		goto out_set;
 
-	/* Real-time signals must be queued if sent by sigqueue, or
-	   some other real-time mechanism.  It is implementation
-	   defined whether kill() does so.  We attempt to do so, on
-	   the principle of least surprise, but since kill is not
-	   allowed to fail with EAGAIN when low on memory we just
-	   make sure at least one signal gets delivered and don't
-	   pass on the info struct.  */
-
+	/*
+	 * Real-time signals must be queued if sent by sigqueue, or
+	 * some other real-time mechanism.  It is implementation
+	 * defined whether kill() does so.  We attempt to do so, on
+	 * the principle of least surprise, but since kill is not
+	 * allowed to fail with EAGAIN when low on memory we just
+	 * make sure at least one signal gets delivered and don't
+	 * pass on the info struct.
+	 */
 	if (sig < SIGRTMIN)
 		override_rlimit = (is_si_special(info) || info->si_code >= 0);
 	else
@@ -1353,7 +1355,7 @@ EXPORT_SYMBOL(kill_pid);
  * These functions support sending signals using preallocated sigqueue
  * structures.  This is needed "because realtime applications cannot
  * afford to lose notifications of asynchronous events, like timer
- * expirations or I/O completions".  In the case of Posix Timers
+ * expirations or I/O completions".  In the case of POSIX Timers
  * we allocate the sigqueue structure from the timer_create.  If this
  * allocation fails we are able to report the failure to the application
  * with an EAGAIN error.
@@ -1538,7 +1540,7 @@ static void do_notify_parent_cldstop(str
 	info.si_signo = SIGCHLD;
 	info.si_errno = 0;
 	/*
-	 * see comment in do_notify_parent() abot the following 3 lines
+	 * see comment in do_notify_parent() about the following 4 lines
 	 */
 	rcu_read_lock();
 	info.si_pid = task_pid_nr_ns(tsk, parent->nsproxy->pid_ns);
@@ -1596,7 +1598,7 @@ static inline int may_ptrace_stop(void)
 }
 
 /*
- * Return nonzero if there is a SIGKILL that should be waking us up.
+ * Return non-zero if there is a SIGKILL that should be waking us up.
  * Called with the siglock held.
  */
 static int sigkill_pending(struct task_struct *tsk)
@@ -1718,7 +1720,7 @@ void ptrace_notify(int exit_code)
 /*
  * This performs the stopping for SIGSTOP and other stop signals.
  * We have to stop all threads in the thread group.
- * Returns nonzero if we've actually stopped and released the siglock.
+ * Returns non-zero if we've actually stopped and released the siglock.
  * Returns zero if we didn't stop and still hold the siglock.
  */
 static int do_signal_stop(int signr)
@@ -1806,10 +1808,12 @@ static int ptrace_signal(int signr, sigi
 
 	current->exit_code = 0;
 
-	/* Update the siginfo structure if the signal has
-	   changed.  If the debugger wanted something
-	   specific in the siginfo structure then it should
-	   have updated *info via PTRACE_SETSIGINFO.  */
+	/*
+	 * Update the siginfo structure if the signal has
+	 * changed.  If the debugger wanted something
+	 * specific in the siginfo structure then it should
+	 * have updated *info via PTRACE_SETSIGINFO.
+	 */
 	if (signr != info->si_signo) {
 		info->si_signo = signr;
 		info->si_errno = 0;
@@ -2017,7 +2021,8 @@ void exit_signals(struct task_struct *ts
 	if (!signal_pending(tsk))
 		goto out;
 
-	/* It could be that __group_complete_signal() choose us to
+	/*
+	 * It could be that __group_complete_signal() choose us to
 	 * notify about group-wide signal. Another thread should be
 	 * woken now to take the signal since we will not.
 	 */
@@ -2166,7 +2171,7 @@ long do_sigpending(void __user *set, uns
 
 out:
 	return error;
-}	
+}
 
 SYSCALL_DEFINE2(rt_sigpending, sigset_t __user *, set, size_t, sigsetsize)
 {
@@ -2216,9 +2221,9 @@ int copy_siginfo_to_user(siginfo_t __use
 		err |= __put_user(from->si_trapno, &to->si_trapno);
 #endif
 #ifdef BUS_MCEERR_AO
-		/* 
+		/*
 		 * Other callers might not initialize the si_lsb field,
-	 	 * so check explicitely for the right codes here.
+	 	 * so check explicitly for the right codes here.
 		 */
 		if (from->si_code == BUS_MCEERR_AR || from->si_code == BUS_MCEERR_AO)
 			err |= __put_user(from->si_addr_lsb, &to->si_addr_lsb);
@@ -2263,7 +2268,7 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const s
 
 	if (copy_from_user(&these, uthese, sizeof(these)))
 		return -EFAULT;
-		
+
 	/*
 	 * Invert the set of allowed signals to get those we
 	 * want to block.
@@ -2288,9 +2293,11 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const s
 				   + (ts.tv_sec || ts.tv_nsec));
 
 		if (timeout) {
-			/* None ready -- temporarily unblock those we're
+			/*
+			 * None ready -- temporarily unblock those we're
 			 * interested while we are sleeping in so that we'll
-			 * be awakened when they arrive.  */
+			 * be awakened when they arrive.
+			 */
 			current->real_blocked = current->blocked;
 			sigandsets(&current->blocked, &current->blocked, &these);
 			recalc_sigpending();
@@ -2528,12 +2535,11 @@ do_sigaltstack (const stack_t __user *us
 
 		error = -EINVAL;
 		/*
-		 *
-		 * Note - this code used to test ss_flags incorrectly
+		 * Note - this code used to test ss_flags incorrectly:
 		 *  	  old code may have been written using ss_flags==0
 		 *	  to mean ss_flags==SS_ONSTACK (as this was the only
 		 *	  way that worked) - this fix preserves that older
-		 *	  mechanism
+		 *	  mechanism.
 		 */
 		if (ss_flags != SS_DISABLE && ss_flags != SS_ONSTACK && ss_flags != 0)
 			goto out;
@@ -2575,8 +2581,10 @@ SYSCALL_DEFINE1(sigpending, old_sigset_t
 #endif
 
 #ifdef __ARCH_WANT_SYS_SIGPROCMASK
-/* Some platforms have their own version with special arguments others
-   support only sys_rt_sigprocmask.  */
+/*
+ * Some platforms have their own version with special arguments;
+ * others support only sys_rt_sigprocmask.
+ */
 
 SYSCALL_DEFINE3(sigprocmask, int, how, old_sigset_t __user *, set,
 		old_sigset_t __user *, oset)
