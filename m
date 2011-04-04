Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab1DDWMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:12:50 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:33569 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754278Ab1DDWMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:12:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BrIlOF4n42nCOStOnum8OIkUguY0s7Q/UQZlYseCyZ797TAyCcEun5tHI3BhkE3CBxRzs55O4/JZnCiRh8DMUXoDlcKYOGHQuSAUt4j6u8f1KLtsW3uRzp8Ud4gq/0Ri;
Date: Mon, 4 Apr 2011 14:59:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/8] kernel/signal.c: fix typos and coding style
Message-Id: <20110404145931.14bb0ecb.rdunlap@xenotime.net>
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

General coding style and comment fixes; no code changes:

- Use multi-line-comment coding style.
- Put some function signatures completely on one line.
- Hyphenate some words.
- Spell Posix as POSIX.
- Correct typos & spellos in some comments.
- Drop trailing whitespace.
- End sentences with periods.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/signal.c |   90 ++++++++++++++++++++++++----------------------
 1 file changed, 48 insertions(+), 42 deletions(-)

--- linux-2.6.38-git18.orig/kernel/signal.c
+++ linux-2.6.38-git18/kernel/signal.c
@@ -226,7 +226,7 @@ static inline void print_dropped_signal(
 /*
  * allocate a new signal queue record
  * - this may be called without locks if and only if t == current, otherwise an
- *   appopriate lock must be held to stop the target task from exiting
+ *   appropriate lock must be held to stop the target task from exiting
  */
 static struct sigqueue *
 __sigqueue_alloc(int sig, struct task_struct *t, gfp_t flags, int override_rlimit)
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
@@ -923,14 +924,15 @@ static int __send_signal(int sig, struct
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
@@ -1201,8 +1203,7 @@ retry:
 	return error;
 }
 
-int
-kill_proc_info(int sig, struct siginfo *info, pid_t pid)
+int kill_proc_info(int sig, struct siginfo *info, pid_t pid)
 {
 	int error;
 	rcu_read_lock();
@@ -1299,8 +1300,7 @@ static int kill_something_info(int sig, 
  * These are for backward compatibility with the rest of the kernel source.
  */
 
-int
-send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
+int send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 {
 	/*
 	 * Make sure legacy kernel users don't send in bad values
@@ -1368,7 +1368,7 @@ EXPORT_SYMBOL(kill_pid);
  * These functions support sending signals using preallocated sigqueue
  * structures.  This is needed "because realtime applications cannot
  * afford to lose notifications of asynchronous events, like timer
- * expirations or I/O completions".  In the case of Posix Timers
+ * expirations or I/O completions".  In the case of POSIX Timers
  * we allocate the sigqueue structure from the timer_create.  If this
  * allocation fails we are able to report the failure to the application
  * with an EAGAIN error.
@@ -1553,7 +1553,7 @@ static void do_notify_parent_cldstop(str
 	info.si_signo = SIGCHLD;
 	info.si_errno = 0;
 	/*
-	 * see comment in do_notify_parent() abot the following 3 lines
+	 * see comment in do_notify_parent() about the following 4 lines
 	 */
 	rcu_read_lock();
 	info.si_pid = task_pid_nr_ns(tsk, parent->nsproxy->pid_ns);
@@ -1611,7 +1611,7 @@ static inline int may_ptrace_stop(void)
 }
 
 /*
- * Return nonzero if there is a SIGKILL that should be waking us up.
+ * Return non-zero if there is a SIGKILL that should be waking us up.
  * Called with the siglock held.
  */
 static int sigkill_pending(struct task_struct *tsk)
@@ -1735,7 +1735,7 @@ void ptrace_notify(int exit_code)
 /*
  * This performs the stopping for SIGSTOP and other stop signals.
  * We have to stop all threads in the thread group.
- * Returns nonzero if we've actually stopped and released the siglock.
+ * Returns non-zero if we've actually stopped and released the siglock.
  * Returns zero if we didn't stop and still hold the siglock.
  */
 static int do_signal_stop(int signr)
@@ -1823,10 +1823,12 @@ static int ptrace_signal(int signr, sigi
 
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
@@ -2034,7 +2036,8 @@ void exit_signals(struct task_struct *ts
 	if (!signal_pending(tsk))
 		goto out;
 
-	/* It could be that __group_complete_signal() choose us to
+	/*
+	 * It could be that __group_complete_signal() choose us to
 	 * notify about group-wide signal. Another thread should be
 	 * woken now to take the signal since we will not.
 	 */
@@ -2183,7 +2186,7 @@ long do_sigpending(void __user *set, uns
 
 out:
 	return error;
-}	
+}
 
 SYSCALL_DEFINE2(rt_sigpending, sigset_t __user *, set, size_t, sigsetsize)
 {
@@ -2233,9 +2236,9 @@ int copy_siginfo_to_user(siginfo_t __use
 		err |= __put_user(from->si_trapno, &to->si_trapno);
 #endif
 #ifdef BUS_MCEERR_AO
-		/* 
+		/*
 		 * Other callers might not initialize the si_lsb field,
-	 	 * so check explicitely for the right codes here.
+		 * so check explicitly for the right codes here.
 		 */
 		if (from->si_code == BUS_MCEERR_AR || from->si_code == BUS_MCEERR_AO)
 			err |= __put_user(from->si_addr_lsb, &to->si_addr_lsb);
@@ -2280,7 +2283,7 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const s
 
 	if (copy_from_user(&these, uthese, sizeof(these)))
 		return -EFAULT;
-		
+
 	/*
 	 * Invert the set of allowed signals to get those we
 	 * want to block.
@@ -2305,9 +2308,11 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const s
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
@@ -2553,12 +2558,11 @@ do_sigaltstack (const stack_t __user *us
 
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
@@ -2600,8 +2604,10 @@ SYSCALL_DEFINE1(sigpending, old_sigset_t
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
