Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab2DULmm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 07:42:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46982 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab2DULmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 07:42:40 -0400
From: Valentin Ilie <valentin.ilie@gmail.com>
To: akpm@linux-foundation.org, paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, Valentin Ilie <valentin.ilie@gmail.com>
Subject: [PATCH] kernel: sys.c: Fixed coding style issues
Date: Sat, 21 Apr 2012 14:42:23 +0300
Message-Id: <1335008543-13399-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some minor coding style issues.

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 kernel/sys.c |  526 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 262 insertions(+), 264 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index e7006eb..b088fe0 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -55,28 +55,28 @@
 #include <asm/unistd.h>
 
 #ifndef SET_UNALIGN_CTL
-# define SET_UNALIGN_CTL(a,b)	(-EINVAL)
+# define SET_UNALIGN_CTL(a, b)	(-EINVAL)
 #endif
 #ifndef GET_UNALIGN_CTL
-# define GET_UNALIGN_CTL(a,b)	(-EINVAL)
+# define GET_UNALIGN_CTL(a, b)	(-EINVAL)
 #endif
 #ifndef SET_FPEMU_CTL
-# define SET_FPEMU_CTL(a,b)	(-EINVAL)
+# define SET_FPEMU_CTL(a, b)	(-EINVAL)
 #endif
 #ifndef GET_FPEMU_CTL
-# define GET_FPEMU_CTL(a,b)	(-EINVAL)
+# define GET_FPEMU_CTL(a, b)	(-EINVAL)
 #endif
 #ifndef SET_FPEXC_CTL
-# define SET_FPEXC_CTL(a,b)	(-EINVAL)
+# define SET_FPEXC_CTL(a, b)	(-EINVAL)
 #endif
 #ifndef GET_FPEXC_CTL
-# define GET_FPEXC_CTL(a,b)	(-EINVAL)
+# define GET_FPEXC_CTL(a, b)	(-EINVAL)
 #endif
 #ifndef GET_ENDIAN
-# define GET_ENDIAN(a,b)	(-EINVAL)
+# define GET_ENDIAN(a, b)	(-EINVAL)
 #endif
 #ifndef SET_ENDIAN
-# define SET_ENDIAN(a,b)	(-EINVAL)
+# define SET_ENDIAN(a, b)	(-EINVAL)
 #endif
 #ifndef GET_TSC_CTL
 # define GET_TSC_CTL(a)		(-EINVAL)
@@ -191,38 +191,37 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
 	rcu_read_lock();
 	read_lock(&tasklist_lock);
 	switch (which) {
-		case PRIO_PROCESS:
-			if (who)
-				p = find_task_by_vpid(who);
-			else
-				p = current;
-			if (p)
-				error = set_one_prio(p, niceval, error);
-			break;
-		case PRIO_PGRP:
-			if (who)
-				pgrp = find_vpid(who);
-			else
-				pgrp = task_pgrp(current);
-			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
+	case PRIO_PROCESS:
+		if (who)
+			p = find_task_by_vpid(who);
+		else
+			p = current;
+		if (p)
+			error = set_one_prio(p, niceval, error);
+		break;
+	case PRIO_PGRP:
+		if (who)
+			pgrp = find_vpid(who);
+		else
+			pgrp = task_pgrp(current);
+		do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
+			error = set_one_prio(p, niceval, error);
+		} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
+		break;
+	case PRIO_USER:
+		user = (struct user_struct *) cred->user;
+		if (!who)
+			who = cred->uid;
+		else if ((who != cred->uid) && !(user = find_user(who)))
+			goto out_unlock;	/* No processes for this user */
+
+		do_each_thread(g, p) {
+			if (__task_cred(p)->uid == who)
 				error = set_one_prio(p, niceval, error);
-			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
-			break;
-		case PRIO_USER:
-			user = (struct user_struct *) cred->user;
-			if (!who)
-				who = cred->uid;
-			else if ((who != cred->uid) &&
-				 !(user = find_user(who)))
-				goto out_unlock;	/* No processes for this user */
-
-			do_each_thread(g, p) {
-				if (__task_cred(p)->uid == who)
-					error = set_one_prio(p, niceval, error);
-			} while_each_thread(g, p);
-			if (who != cred->uid)
-				free_uid(user);		/* For find_user() */
-			break;
+		} while_each_thread(g, p);
+		if (who != cred->uid)
+			free_uid(user);		/* For find_user() */
+		break;
 	}
 out_unlock:
 	read_unlock(&tasklist_lock);
@@ -251,46 +250,45 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 	rcu_read_lock();
 	read_lock(&tasklist_lock);
 	switch (which) {
-		case PRIO_PROCESS:
-			if (who)
-				p = find_task_by_vpid(who);
-			else
-				p = current;
-			if (p) {
+	case PRIO_PROCESS:
+		if (who)
+			p = find_task_by_vpid(who);
+		else
+			p = current;
+		if (p) {
+			niceval = 20 - task_nice(p);
+			if (niceval > retval)
+				retval = niceval;
+		}
+		break;
+	case PRIO_PGRP:
+		if (who)
+			pgrp = find_vpid(who);
+		else
+			pgrp = task_pgrp(current);
+		do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
+			niceval = 20 - task_nice(p);
+			if (niceval > retval)
+				retval = niceval;
+		} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
+		break;
+	case PRIO_USER:
+		user = (struct user_struct *) cred->user;
+		if (!who)
+			who = cred->uid;
+		else if ((who != cred->uid) && !(user = find_user(who)))
+			goto out_unlock;	/* No processes for this user */
+
+		do_each_thread(g, p) {
+			if (__task_cred(p)->uid == who) {
 				niceval = 20 - task_nice(p);
 				if (niceval > retval)
 					retval = niceval;
 			}
-			break;
-		case PRIO_PGRP:
-			if (who)
-				pgrp = find_vpid(who);
-			else
-				pgrp = task_pgrp(current);
-			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
-				niceval = 20 - task_nice(p);
-				if (niceval > retval)
-					retval = niceval;
-			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
-			break;
-		case PRIO_USER:
-			user = (struct user_struct *) cred->user;
-			if (!who)
-				who = cred->uid;
-			else if ((who != cred->uid) &&
-				 !(user = find_user(who)))
-				goto out_unlock;	/* No processes for this user */
-
-			do_each_thread(g, p) {
-				if (__task_cred(p)->uid == who) {
-					niceval = 20 - task_nice(p);
-					if (niceval > retval)
-						retval = niceval;
-				}
-			} while_each_thread(g, p);
-			if (who != cred->uid)
-				free_uid(user);		/* for find_user() */
-			break;
+		} while_each_thread(g, p);
+		if (who != cred->uid)
+			free_uid(user);		/* for find_user() */
+		break;
 	}
 out_unlock:
 	read_unlock(&tasklist_lock);
@@ -377,7 +375,7 @@ EXPORT_SYMBOL_GPL(kernel_restart);
 static void kernel_shutdown_prepare(enum system_states state)
 {
 	blocking_notifier_call_chain(&reboot_notifier_list,
-		(state == SYSTEM_HALT)?SYS_HALT:SYS_POWER_OFF, NULL);
+		(state == SYSTEM_HALT) ? SYS_HALT : SYS_POWER_OFF, NULL);
 	system_state = state;
 	usermodehelper_disable();
 	device_shutdown();
@@ -439,9 +437,9 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 	/* For safety, we require "magic" arguments. */
 	if (magic1 != LINUX_REBOOT_MAGIC1 ||
 	    (magic2 != LINUX_REBOOT_MAGIC2 &&
-	                magic2 != LINUX_REBOOT_MAGIC2A &&
-			magic2 != LINUX_REBOOT_MAGIC2B &&
-	                magic2 != LINUX_REBOOT_MAGIC2C))
+		magic2 != LINUX_REBOOT_MAGIC2A &&
+		magic2 != LINUX_REBOOT_MAGIC2B &&
+		magic2 != LINUX_REBOOT_MAGIC2C))
 		return -EINVAL;
 
 	/*
@@ -532,7 +530,7 @@ void ctrl_alt_del(void)
 	else
 		kill_cad_pid(SIGINT, 1);
 }
-	
+
 /*
  * Unprivileged users may change the real gid to the effective gid
  * or vice versa.  (BSD-style)
@@ -546,7 +544,7 @@ void ctrl_alt_del(void)
  *
  * The general idea is that a program which uses just setregid() will be
  * 100% compatible with BSD.  A program which uses just setgid() will be
- * 100% compatible with POSIX with saved IDs. 
+ * 100% compatible with POSIX with saved IDs.
  *
  * SMP: There are not races, the GIDs are checked only by filesystem
  *      operations (as far as semantic preservation is concerned).
@@ -594,7 +592,7 @@ error:
 }
 
 /*
- * setgid() is implemented like SysV w/ SAVED_IDS 
+ * setgid() is implemented like SysV w/ SAVED_IDS
  *
  * SMP: Same implicit races as above.
  */
@@ -666,7 +664,7 @@ static int set_user(struct cred *new)
  *
  * The general idea is that a program which uses just setreuid() will be
  * 100% compatible with BSD.  A program which uses just setuid() will be
- * 100% compatible with POSIX with saved IDs. 
+ * 100% compatible with POSIX with saved IDs.
  */
 SYSCALL_DEFINE2(setreuid, uid_t, ruid, uid_t, euid)
 {
@@ -717,17 +715,17 @@ error:
 	abort_creds(new);
 	return retval;
 }
-		
+
 /*
- * setuid() is implemented like SysV with SAVED_IDS 
- * 
+ * setuid() is implemented like SysV with SAVED_IDS
+ *
  * Note that SAVED_ID's is deficient in that a setuid root program
- * like sendmail, for example, cannot set its uid to be a normal 
+ * like sendmail, for example, cannot set its uid to be a normal
  * user and then switch back, because if you're root, setuid() sets
  * the saved uid too.  If you don't like this, blame the bright people
  * in the POSIX committee and/or USG.  Note that the BSD-style setreuid()
  * will allow a root program to temporarily drop privileges and be able to
- * regain them by swapping the real and effective uid.  
+ * regain them by swapping the real and effective uid.
  */
 SYSCALL_DEFINE1(setuid, uid_t, uid)
 {
@@ -1369,7 +1367,7 @@ SYSCALL_DEFINE2(getrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 /*
  *	Back compatibility for getrlimit. Needed for some apps.
  */
- 
+
 SYSCALL_DEFINE2(old_getrlimit, unsigned int, resource,
 		struct rlimit __user *, rlim)
 {
@@ -1384,7 +1382,7 @@ SYSCALL_DEFINE2(old_getrlimit, unsigned int, resource,
 		x.rlim_cur = 0x7FFFFFFF;
 	if (x.rlim_max > 0x7FFFFFFF)
 		x.rlim_max = 0x7FFFFFFF;
-	return copy_to_user(rlim, &x, sizeof(x))?-EFAULT:0;
+	return copy_to_user(rlim, &x, sizeof(x)) ? -EFAULT : 0;
 }
 
 #endif
@@ -1627,42 +1625,42 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 		return;
 
 	switch (who) {
-		case RUSAGE_BOTH:
-		case RUSAGE_CHILDREN:
-			utime = p->signal->cutime;
-			stime = p->signal->cstime;
-			r->ru_nvcsw = p->signal->cnvcsw;
-			r->ru_nivcsw = p->signal->cnivcsw;
-			r->ru_minflt = p->signal->cmin_flt;
-			r->ru_majflt = p->signal->cmaj_flt;
-			r->ru_inblock = p->signal->cinblock;
-			r->ru_oublock = p->signal->coublock;
-			maxrss = p->signal->cmaxrss;
-
-			if (who == RUSAGE_CHILDREN)
-				break;
-
-		case RUSAGE_SELF:
-			thread_group_times(p, &tgutime, &tgstime);
-			utime += tgutime;
-			stime += tgstime;
-			r->ru_nvcsw += p->signal->nvcsw;
-			r->ru_nivcsw += p->signal->nivcsw;
-			r->ru_minflt += p->signal->min_flt;
-			r->ru_majflt += p->signal->maj_flt;
-			r->ru_inblock += p->signal->inblock;
-			r->ru_oublock += p->signal->oublock;
-			if (maxrss < p->signal->maxrss)
-				maxrss = p->signal->maxrss;
-			t = p;
-			do {
-				accumulate_thread_rusage(t, r);
-				t = next_thread(t);
-			} while (t != p);
+	case RUSAGE_BOTH:
+	case RUSAGE_CHILDREN:
+		utime = p->signal->cutime;
+		stime = p->signal->cstime;
+		r->ru_nvcsw = p->signal->cnvcsw;
+		r->ru_nivcsw = p->signal->cnivcsw;
+		r->ru_minflt = p->signal->cmin_flt;
+		r->ru_majflt = p->signal->cmaj_flt;
+		r->ru_inblock = p->signal->cinblock;
+		r->ru_oublock = p->signal->coublock;
+		maxrss = p->signal->cmaxrss;
+
+		if (who == RUSAGE_CHILDREN)
 			break;
 
-		default:
-			BUG();
+	case RUSAGE_SELF:
+		thread_group_times(p, &tgutime, &tgstime);
+		utime += tgutime;
+		stime += tgstime;
+		r->ru_nvcsw += p->signal->nvcsw;
+		r->ru_nivcsw += p->signal->nivcsw;
+		r->ru_minflt += p->signal->min_flt;
+		r->ru_majflt += p->signal->maj_flt;
+		r->ru_inblock += p->signal->inblock;
+		r->ru_oublock += p->signal->oublock;
+		if (maxrss < p->signal->maxrss)
+			maxrss = p->signal->maxrss;
+		t = p;
+		do {
+			accumulate_thread_rusage(t, r);
+			t = next_thread(t);
+		} while (t != p);
+		break;
+
+	default:
+		BUG();
 	}
 	unlock_task_sighand(p, &flags);
 
@@ -1832,156 +1830,156 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 
 	error = 0;
 	switch (option) {
-		case PR_SET_PDEATHSIG:
-			if (!valid_signal(arg2)) {
-				error = -EINVAL;
-				break;
-			}
-			me->pdeath_signal = arg2;
-			error = 0;
-			break;
-		case PR_GET_PDEATHSIG:
-			error = put_user(me->pdeath_signal, (int __user *)arg2);
-			break;
-		case PR_GET_DUMPABLE:
-			error = get_dumpable(me->mm);
+	case PR_SET_PDEATHSIG:
+		if (!valid_signal(arg2)) {
+			error = -EINVAL;
 			break;
-		case PR_SET_DUMPABLE:
-			if (arg2 < 0 || arg2 > 1) {
-				error = -EINVAL;
-				break;
-			}
-			set_dumpable(me->mm, arg2);
-			error = 0;
+		}
+		me->pdeath_signal = arg2;
+		error = 0;
+		break;
+	case PR_GET_PDEATHSIG:
+		error = put_user(me->pdeath_signal, (int __user *)arg2);
+		break;
+	case PR_GET_DUMPABLE:
+		error = get_dumpable(me->mm);
+		break;
+	case PR_SET_DUMPABLE:
+		if (arg2 < 0 || arg2 > 1) {
+			error = -EINVAL;
 			break;
+		}
+		set_dumpable(me->mm, arg2);
+		error = 0;
+		break;
 
-		case PR_SET_UNALIGN:
-			error = SET_UNALIGN_CTL(me, arg2);
-			break;
-		case PR_GET_UNALIGN:
-			error = GET_UNALIGN_CTL(me, arg2);
-			break;
-		case PR_SET_FPEMU:
-			error = SET_FPEMU_CTL(me, arg2);
-			break;
-		case PR_GET_FPEMU:
-			error = GET_FPEMU_CTL(me, arg2);
-			break;
-		case PR_SET_FPEXC:
-			error = SET_FPEXC_CTL(me, arg2);
-			break;
-		case PR_GET_FPEXC:
-			error = GET_FPEXC_CTL(me, arg2);
-			break;
-		case PR_GET_TIMING:
-			error = PR_TIMING_STATISTICAL;
-			break;
-		case PR_SET_TIMING:
-			if (arg2 != PR_TIMING_STATISTICAL)
-				error = -EINVAL;
-			else
-				error = 0;
-			break;
+	case PR_SET_UNALIGN:
+		error = SET_UNALIGN_CTL(me, arg2);
+		break;
+	case PR_GET_UNALIGN:
+		error = GET_UNALIGN_CTL(me, arg2);
+		break;
+	case PR_SET_FPEMU:
+		error = SET_FPEMU_CTL(me, arg2);
+		break;
+	case PR_GET_FPEMU:
+		error = GET_FPEMU_CTL(me, arg2);
+		break;
+	case PR_SET_FPEXC:
+		error = SET_FPEXC_CTL(me, arg2);
+		break;
+	case PR_GET_FPEXC:
+		error = GET_FPEXC_CTL(me, arg2);
+		break;
+	case PR_GET_TIMING:
+		error = PR_TIMING_STATISTICAL;
+		break;
+	case PR_SET_TIMING:
+		if (arg2 != PR_TIMING_STATISTICAL)
+			error = -EINVAL;
+		else
+			error = 0;
+		break;
 
-		case PR_SET_NAME:
-			comm[sizeof(me->comm)-1] = 0;
-			if (strncpy_from_user(comm, (char __user *)arg2,
-					      sizeof(me->comm) - 1) < 0)
-				return -EFAULT;
-			set_task_comm(me, comm);
-			proc_comm_connector(me);
-			return 0;
-		case PR_GET_NAME:
-			get_task_comm(comm, me);
-			if (copy_to_user((char __user *)arg2, comm,
+	case PR_SET_NAME:
+		comm[sizeof(me->comm)-1] = 0;
+		if (strncpy_from_user(comm, (char __user *)arg2,
+				      sizeof(me->comm) - 1) < 0)
+			return -EFAULT;
+		set_task_comm(me, comm);
+		proc_comm_connector(me);
+		return 0;
+	case PR_GET_NAME:
+		get_task_comm(comm, me);
+		if (copy_to_user((char __user *)arg2, comm,
 					 sizeof(comm)))
-				return -EFAULT;
-			return 0;
-		case PR_GET_ENDIAN:
-			error = GET_ENDIAN(me, arg2);
-			break;
-		case PR_SET_ENDIAN:
-			error = SET_ENDIAN(me, arg2);
-			break;
+			return -EFAULT;
+		return 0;
+	case PR_GET_ENDIAN:
+		error = GET_ENDIAN(me, arg2);
+		break;
+	case PR_SET_ENDIAN:
+		error = SET_ENDIAN(me, arg2);
+		break;
 
-		case PR_GET_SECCOMP:
-			error = prctl_get_seccomp();
-			break;
-		case PR_SET_SECCOMP:
-			error = prctl_set_seccomp(arg2);
-			break;
-		case PR_GET_TSC:
-			error = GET_TSC_CTL(arg2);
-			break;
-		case PR_SET_TSC:
-			error = SET_TSC_CTL(arg2);
-			break;
-		case PR_TASK_PERF_EVENTS_DISABLE:
-			error = perf_event_task_disable();
-			break;
-		case PR_TASK_PERF_EVENTS_ENABLE:
-			error = perf_event_task_enable();
-			break;
-		case PR_GET_TIMERSLACK:
-			error = current->timer_slack_ns;
-			break;
-		case PR_SET_TIMERSLACK:
-			if (arg2 <= 0)
-				current->timer_slack_ns =
-					current->default_timer_slack_ns;
-			else
-				current->timer_slack_ns = arg2;
-			error = 0;
-			break;
-		case PR_MCE_KILL:
-			if (arg4 | arg5)
-				return -EINVAL;
-			switch (arg2) {
-			case PR_MCE_KILL_CLEAR:
-				if (arg3 != 0)
-					return -EINVAL;
-				current->flags &= ~PF_MCE_PROCESS;
-				break;
-			case PR_MCE_KILL_SET:
-				current->flags |= PF_MCE_PROCESS;
-				if (arg3 == PR_MCE_KILL_EARLY)
-					current->flags |= PF_MCE_EARLY;
-				else if (arg3 == PR_MCE_KILL_LATE)
-					current->flags &= ~PF_MCE_EARLY;
-				else if (arg3 == PR_MCE_KILL_DEFAULT)
-					current->flags &=
-						~(PF_MCE_EARLY|PF_MCE_PROCESS);
-				else
-					return -EINVAL;
-				break;
-			default:
+	case PR_GET_SECCOMP:
+		error = prctl_get_seccomp();
+		break;
+	case PR_SET_SECCOMP:
+		error = prctl_set_seccomp(arg2);
+		break;
+	case PR_GET_TSC:
+		error = GET_TSC_CTL(arg2);
+		break;
+	case PR_SET_TSC:
+		error = SET_TSC_CTL(arg2);
+		break;
+	case PR_TASK_PERF_EVENTS_DISABLE:
+		error = perf_event_task_disable();
+		break;
+	case PR_TASK_PERF_EVENTS_ENABLE:
+		error = perf_event_task_enable();
+		break;
+	case PR_GET_TIMERSLACK:
+		error = current->timer_slack_ns;
+		break;
+	case PR_SET_TIMERSLACK:
+		if (arg2 <= 0)
+			current->timer_slack_ns =
+				current->default_timer_slack_ns;
+		else
+			current->timer_slack_ns = arg2;
+		error = 0;
+		break;
+	case PR_MCE_KILL:
+		if (arg4 | arg5)
+			return -EINVAL;
+		switch (arg2) {
+		case PR_MCE_KILL_CLEAR:
+			if (arg3 != 0)
 				return -EINVAL;
-			}
-			error = 0;
+			current->flags &= ~PF_MCE_PROCESS;
 			break;
-		case PR_MCE_KILL_GET:
-			if (arg2 | arg3 | arg4 | arg5)
-				return -EINVAL;
-			if (current->flags & PF_MCE_PROCESS)
-				error = (current->flags & PF_MCE_EARLY) ?
-					PR_MCE_KILL_EARLY : PR_MCE_KILL_LATE;
+		case PR_MCE_KILL_SET:
+			current->flags |= PF_MCE_PROCESS;
+			if (arg3 == PR_MCE_KILL_EARLY)
+				current->flags |= PF_MCE_EARLY;
+			else if (arg3 == PR_MCE_KILL_LATE)
+				current->flags &= ~PF_MCE_EARLY;
+			else if (arg3 == PR_MCE_KILL_DEFAULT)
+				current->flags &=
+					~(PF_MCE_EARLY|PF_MCE_PROCESS);
 			else
-				error = PR_MCE_KILL_DEFAULT;
-			break;
-		case PR_SET_MM:
-			error = prctl_set_mm(arg2, arg3, arg4, arg5);
-			break;
-		case PR_SET_CHILD_SUBREAPER:
-			me->signal->is_child_subreaper = !!arg2;
-			error = 0;
-			break;
-		case PR_GET_CHILD_SUBREAPER:
-			error = put_user(me->signal->is_child_subreaper,
-					 (int __user *) arg2);
+				return -EINVAL;
 			break;
 		default:
-			error = -EINVAL;
-			break;
+			return -EINVAL;
+		}
+		error = 0;
+		break;
+	case PR_MCE_KILL_GET:
+		if (arg2 | arg3 | arg4 | arg5)
+			return -EINVAL;
+		if (current->flags & PF_MCE_PROCESS)
+			error = (current->flags & PF_MCE_EARLY) ?
+				PR_MCE_KILL_EARLY : PR_MCE_KILL_LATE;
+		else
+			error = PR_MCE_KILL_DEFAULT;
+		break;
+	case PR_SET_MM:
+		error = prctl_set_mm(arg2, arg3, arg4, arg5);
+		break;
+	case PR_SET_CHILD_SUBREAPER:
+		me->signal->is_child_subreaper = !!arg2;
+		error = 0;
+		break;
+	case PR_GET_CHILD_SUBREAPER:
+		error = put_user(me->signal->is_child_subreaper,
+				 (int __user *) arg2);
+		break;
+	default:
+		error = -EINVAL;
+		break;
 	}
 	return error;
 }
@@ -2040,7 +2038,7 @@ int orderly_poweroff(bool force)
 
 	ret = call_usermodehelper_exec(info, UMH_NO_WAIT);
 
-  out:
+out:
 	if (ret && force) {
 		printk(KERN_WARNING "Failed to start orderly shutdown: "
 		       "forcing the issue\n");
-- 
1.7.9.5

