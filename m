Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380Ab1CaVs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 17:48:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65246 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759102Ab1CaVs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 17:48:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=f7VBNrbUmG5AZ+0xQMJmcS9fBK8cjmdsd4ff0354B6D4ppRgxhYK8SbI3ycixh3GaK
         czRSWvz2f/jCBbikv50r2PL5fpnyVmbWZiHOMdIS8ldWutZicwZ625r7HSoH+Jxct5PH
         W7K73Q5ItPQXeO7goMrJ8vB3gZ8qsdEPLM2Wk=
MIME-Version: 1.0
Date: Fri, 1 Apr 2011 03:18:55 +0530
Message-ID: <AANLkTi=jHAJ8H0penc8Tkz6w2ihaP3CrkZoQAB9L1G2T@mail.gmail.com>
Subject: [PATCH] kernel: Fix style problems in fork.c
From: Aakash Goenka <aakash.goenka@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Fixes most style errors and warnings.
 Signed-off-by: Aakash Goenka <aakash.goenka@gmail.com>

---
 kernel/fork.c |   96 ++++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 57 insertions(+), 39 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index e7548de..de4cd1d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -82,7 +82,7 @@
  * Protected counters by write_lock_irq(&tasklist_lock)
  */
 unsigned long total_forks;	/* Handle normal Linux uptimes. */
-int nr_threads; 		/* The idle threads do not count.. */
+int nr_threads;			/* The idle threads do not count.. */

 int max_threads;		/* tunable limit on nr_threads */

@@ -234,7 +234,7 @@ void __init fork_init(unsigned long mempages)
 	/*
 	 * we need to allow at least 20 threads to boot a system
 	 */
-	if(max_threads < 20)
+	if (max_threads < 20)
 		max_threads = 20;

 	init_task.signal->rlim[RLIMIT_NPROC].rlim_cur = max_threads/2;
@@ -270,7 +270,7 @@ static struct task_struct *dup_task_struct(struct
task_struct *orig)
 		return NULL;
 	}

- 	err = arch_dup_task_struct(tsk, orig);
+	err = arch_dup_task_struct(tsk, orig);
 	if (err)
 		goto out;

@@ -290,8 +290,10 @@ static struct task_struct *dup_task_struct(struct
task_struct *orig)
 	tsk->stack_canary = get_random_int();
 #endif

-	/* One for us, one for whoever does the "release_task()" (usually parent) */
-	atomic_set(&tsk->usage,2);
+	/* One for us, one for whoever does the
+	 * "release_task()" (usually parent)
+	 */
+	atomic_set(&tsk->usage, 2);
 	atomic_set(&tsk->fs_excl, 0);
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	tsk->btrace_seq = 0;
@@ -355,7 +357,8 @@ static int dup_mmap(struct mm_struct *mm, struct
mm_struct *oldmm)
 		}
 		charge = 0;
 		if (mpnt->vm_flags & VM_ACCOUNT) {
-			unsigned int len = (mpnt->vm_end - mpnt->vm_start) >> PAGE_SHIFT;
+			unsigned int len =
+			    (mpnt->vm_end - mpnt->vm_start) >> PAGE_SHIFT;
 			if (security_vm_enough_memory(len))
 				goto fail_nomem;
 			charge = len;
@@ -441,7 +444,7 @@ fail_nomem:
 	goto out;
 }

-static inline int mm_alloc_pgd(struct mm_struct * mm)
+static inline int mm_alloc_pgd(struct mm_struct *mm)
 {
 	mm->pgd = pgd_alloc(mm);
 	if (unlikely(!mm->pgd))
@@ -449,7 +452,7 @@ static inline int mm_alloc_pgd(struct mm_struct * mm)
 	return 0;
 }

-static inline void mm_free_pgd(struct mm_struct * mm)
+static inline void mm_free_pgd(struct mm_struct *mm)
 {
 	pgd_free(mm, mm->pgd);
 }
@@ -486,7 +489,7 @@ static void mm_init_aio(struct mm_struct *mm)
 #endif
 }

-static struct mm_struct * mm_init(struct mm_struct * mm, struct task_struct *p)
+static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 {
 	atomic_set(&mm->mm_users, 1);
 	atomic_set(&mm->mm_count, 1);
@@ -517,9 +520,9 @@ static struct mm_struct * mm_init(struct mm_struct
* mm, struct task_struct *p)
 /*
  * Allocate and initialize an mm_struct.
  */
-struct mm_struct * mm_alloc(void)
+struct mm_struct *mm_alloc(void)
 {
-	struct mm_struct * mm;
+	struct mm_struct *mm;

 	mm = allocate_mm();
 	if (mm) {
@@ -726,9 +729,9 @@ fail_nocontext:
 	return NULL;
 }

-static int copy_mm(unsigned long clone_flags, struct task_struct * tsk)
+static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
 {
-	struct mm_struct * mm, *oldmm;
+	struct mm_struct *mm, *oldmm;
 	int retval;

 	tsk->min_flt = tsk->maj_flt = 0;
@@ -795,7 +798,7 @@ static int copy_fs(unsigned long clone_flags,
struct task_struct *tsk)
 	return 0;
 }

-static int copy_files(unsigned long clone_flags, struct task_struct * tsk)
+static int copy_files(unsigned long clone_flags, struct task_struct *tsk)
 {
 	struct files_struct *oldf, *newf;
 	int error = 0;
@@ -1112,11 +1115,11 @@ static struct task_struct
*copy_process(unsigned long clone_flags,
 	cgroup_fork(p);
 #ifdef CONFIG_NUMA
 	p->mempolicy = mpol_dup(p->mempolicy);
- 	if (IS_ERR(p->mempolicy)) {
- 		retval = PTR_ERR(p->mempolicy);
- 		p->mempolicy = NULL;
- 		goto bad_fork_cleanup_cgroup;
- 	}
+	if (IS_ERR(p->mempolicy)) {
+		retval = PTR_ERR(p->mempolicy);
+		p->mempolicy = NULL;
+		goto bad_fork_cleanup_cgroup;
+	}
 	mpol_fix_fork_child_flag(p);
 #endif
 #ifdef CONFIG_TRACE_IRQFLAGS
@@ -1158,25 +1161,33 @@ static struct task_struct
*copy_process(unsigned long clone_flags,
 	retval = perf_event_init_task(p);
 	if (retval)
 		goto bad_fork_cleanup_policy;
-
-	if ((retval = audit_alloc(p)))
+	retval = audit_alloc(p);
+	if (retval)
 		goto bad_fork_cleanup_policy;
 	/* copy all the process information */
-	if ((retval = copy_semundo(clone_flags, p)))
+	retval = copy_semundo(clone_flags, p);
+	if (retval)
 		goto bad_fork_cleanup_audit;
-	if ((retval = copy_files(clone_flags, p)))
+	retval = copy_files(clone_flags, p);
+	if (retval)
 		goto bad_fork_cleanup_semundo;
-	if ((retval = copy_fs(clone_flags, p)))
+	retval = copy_fs(clone_flags, p);
+	if (retval)
 		goto bad_fork_cleanup_files;
-	if ((retval = copy_sighand(clone_flags, p)))
+	retval = copy_sighand(clone_flags, p);
+	if (retval)
 		goto bad_fork_cleanup_fs;
-	if ((retval = copy_signal(clone_flags, p)))
+	retval = copy_signal(clone_flags, p);
+	if (retval)
 		goto bad_fork_cleanup_sighand;
-	if ((retval = copy_mm(clone_flags, p)))
+	retval = copy_mm(clone_flags, p);
+	if (retval)
 		goto bad_fork_cleanup_signal;
-	if ((retval = copy_namespaces(clone_flags, p)))
+	retval = copy_namespaces(clone_flags, p);
+	if (retval)
 		goto bad_fork_cleanup_mm;
-	if ((retval = copy_io(clone_flags, p)))
+	retval = copy_io(clone_flags, p);
+	if (retval)
 		goto bad_fork_cleanup_namespaces;
 	retval = copy_thread(clone_flags, stack_start, stack_size, p, regs);
 	if (retval)
@@ -1200,11 +1211,13 @@ static struct task_struct
*copy_process(unsigned long clone_flags,
 			goto bad_fork_free_pid;
 	}

-	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? child_tidptr : NULL;
+	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ?
+			    child_tidptr : NULL;
 	/*
 	 * Clear TID on mm_release()?
 	 */
-	p->clear_child_tid = (clone_flags & CLONE_CHILD_CLEARTID) ?
child_tidptr: NULL;
+	p->clear_child_tid = (clone_flags & CLONE_CHILD_CLEARTID) ?
+			      child_tidptr : NULL;
 #ifdef CONFIG_BLOCK
 	p->plug = NULL;
 #endif
@@ -1234,7 +1247,8 @@ static struct task_struct *copy_process(unsigned
long clone_flags,
 	clear_all_latency_tracing(p);

 	/* ok, now we should be set up.. */
-	p->exit_signal = (clone_flags & CLONE_THREAD) ? -1 : (clone_flags & CSIGNAL);
+	p->exit_signal = (clone_flags & CLONE_THREAD) ?
+			  -1 : (clone_flags & CSIGNAL);
 	p->pdeath_signal = 0;
 	p->exit_state = 0;

@@ -1272,7 +1286,7 @@ static struct task_struct *copy_process(unsigned
long clone_flags,
 	 * it's process group.
 	 * A fatal signal pending means that current will exit, so the new
 	 * thread can't slip out of an OOM kill (or normal SIGKILL).
- 	 */
+	 */
 	recalc_sigpending();
 	if (signal_pending(current)) {
 		spin_unlock(&current->sighand->siglock);
@@ -1286,7 +1300,8 @@ static struct task_struct *copy_process(unsigned
long clone_flags,
 		atomic_inc(&current->signal->live);
 		atomic_inc(&current->signal->sigcnt);
 		p->group_leader = current->group_leader;
-		list_add_tail_rcu(&p->thread_group, &p->group_leader->thread_group);
+		list_add_tail_rcu(&p->thread_group,
+				  &p->group_leader->thread_group);
 	}

 	if (likely(p->pid)) {
@@ -1562,7 +1577,8 @@ static int unshare_fs(unsigned long
unshare_flags, struct fs_struct **new_fsp)
 /*
  * Unshare file descriptor table if it is being shared
  */
-static int unshare_fd(unsigned long unshare_flags, struct
files_struct **new_fdp)
+static int unshare_fd(unsigned long unshare_flags,
+		      struct files_struct **new_fdp)
 {
 	struct files_struct *fd = current->files;
 	int error = 0;
@@ -1609,12 +1625,14 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_flags)
 	 */
 	if (unshare_flags & (CLONE_NEWIPC|CLONE_SYSVSEM))
 		do_sysvsem = 1;
-	if ((err = unshare_fs(unshare_flags, &new_fs)))
+	err = unshare_fs(unshare_flags, &new_fs);
+	if (err)
 		goto bad_unshare_out;
-	if ((err = unshare_fd(unshare_flags, &new_fd)))
+	err = unshare_fd(unshare_flags, &new_fd);
+	if (err)
 		goto bad_unshare_cleanup_fs;
-	if ((err = unshare_nsproxy_namespaces(unshare_flags, &new_nsproxy,
-			new_fs)))
+	err = unshare_nsproxy_namespaces(unshare_flags, &new_nsproxy, new_fs);
+	if (err)
 		goto bad_unshare_cleanup_fd;

 	if (new_fs || new_fd || do_sysvsem || new_nsproxy) {
-- 
1.7.0.4
