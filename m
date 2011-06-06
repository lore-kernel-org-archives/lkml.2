Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab1FFI0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:26:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45942 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab1FFI0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:26:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=P1z4hv0PChbriefrdlEa1ceqWq6BxgfENjP6SEfslwKtx36UPtMlliiXtANVNuKXir
         y2R8f0ocd/+dbTFugyZv+fC6THunH1BL4LOPxuCCxB7XZZJdDVkFRo5fQi42xuo31gGB
         bfqVk7RoY8hT1NWD30i5wM1/EIN1b++DigGjs=
From: Daniel Rebelo de Oliveira <psykon@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Daniel Rebelo de Oliveira <psykon@gmail.com>
Subject: [PATCH] kernel: fork: Fixed a few coding style issues
Date: Mon,  6 Jun 2011 09:25:27 +0100
Message-Id: <1307348727-17305-1-git-send-email-psykon@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Rebelo de Oliveira <psykon@gmail.com>
---
 kernel/fork.c |   78 ++++++++++++++++++++++++++++++++-------------------------
 1 files changed, 44 insertions(+), 34 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 0276c30..9a9b0ba 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -81,7 +81,7 @@
  * Protected counters by write_lock_irq(&tasklist_lock)
  */
 unsigned long total_forks;	/* Handle normal Linux uptimes. */
-int nr_threads; 		/* The idle threads do not count.. */
+int nr_threads;			/* The idle threads do not count.. */
 
 int max_threads;		/* tunable limit on nr_threads */
 
@@ -233,7 +233,7 @@ void __init fork_init(unsigned long mempages)
 	/*
 	 * we need to allow at least 20 threads to boot a system
 	 */
-	if(max_threads < 20)
+	if (max_threads < 20)
 		max_threads = 20;
 
 	init_task.signal->rlim[RLIMIT_NPROC].rlim_cur = max_threads/2;
@@ -269,7 +269,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 		return NULL;
 	}
 
- 	err = arch_dup_task_struct(tsk, orig);
+	err = arch_dup_task_struct(tsk, orig);
 	if (err)
 		goto out;
 
@@ -290,7 +290,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 #endif
 
 	/* One for us, one for whoever does the "release_task()" (usually parent) */
-	atomic_set(&tsk->usage,2);
+	atomic_set(&tsk->usage, 2);
 	atomic_set(&tsk->fs_excl, 0);
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	tsk->btrace_seq = 0;
@@ -439,7 +439,7 @@ fail_nomem:
 	goto out;
 }
 
-static inline int mm_alloc_pgd(struct mm_struct * mm)
+static inline int mm_alloc_pgd(struct mm_struct *mm)
 {
 	mm->pgd = pgd_alloc(mm);
 	if (unlikely(!mm->pgd))
@@ -447,7 +447,7 @@ static inline int mm_alloc_pgd(struct mm_struct * mm)
 	return 0;
 }
 
-static inline void mm_free_pgd(struct mm_struct * mm)
+static inline void mm_free_pgd(struct mm_struct *mm)
 {
 	pgd_free(mm, mm->pgd);
 }
@@ -484,7 +484,7 @@ static void mm_init_aio(struct mm_struct *mm)
 #endif
 }
 
-static struct mm_struct * mm_init(struct mm_struct * mm, struct task_struct *p)
+static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 {
 	atomic_set(&mm->mm_users, 1);
 	atomic_set(&mm->mm_count, 1);
@@ -515,9 +515,9 @@ static struct mm_struct * mm_init(struct mm_struct * mm, struct task_struct *p)
 /*
  * Allocate and initialize an mm_struct.
  */
-struct mm_struct * mm_alloc(void)
+struct mm_struct *mm_alloc(void)
 {
-	struct mm_struct * mm;
+	struct mm_struct *mm;
 
 	mm = allocate_mm();
 	if (!mm)
@@ -585,7 +585,7 @@ void added_exe_file_vma(struct mm_struct *mm)
 void removed_exe_file_vma(struct mm_struct *mm)
 {
 	mm->num_exe_file_vmas--;
-	if ((mm->num_exe_file_vmas == 0) && mm->exe_file){
+	if ((mm->num_exe_file_vmas == 0) && mm->exe_file) {
 		fput(mm->exe_file);
 		mm->exe_file = NULL;
 	}
@@ -777,9 +777,9 @@ fail_nocontext:
 	return NULL;
 }
 
-static int copy_mm(unsigned long clone_flags, struct task_struct * tsk)
+static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
 {
-	struct mm_struct * mm, *oldmm;
+	struct mm_struct *mm, *oldmm;
 	int retval;
 
 	tsk->min_flt = tsk->maj_flt = 0;
@@ -846,7 +846,7 @@ static int copy_fs(unsigned long clone_flags, struct task_struct *tsk)
 	return 0;
 }
 
-static int copy_files(unsigned long clone_flags, struct task_struct * tsk)
+static int copy_files(unsigned long clone_flags, struct task_struct *tsk)
 {
 	struct files_struct *oldf, *newf;
 	int error = 0;
@@ -1168,11 +1168,11 @@ static struct task_struct *copy_process(unsigned long clone_flags,
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
@@ -1214,25 +1214,33 @@ static struct task_struct *copy_process(unsigned long clone_flags,
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
@@ -1254,7 +1262,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	/*
 	 * Clear TID on mm_release()?
 	 */
-	p->clear_child_tid = (clone_flags & CLONE_CHILD_CLEARTID) ? child_tidptr: NULL;
+	p->clear_child_tid = (clone_flags & CLONE_CHILD_CLEARTID) ? child_tidptr : NULL;
 #ifdef CONFIG_BLOCK
 	p->plug = NULL;
 #endif
@@ -1322,7 +1330,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 * it's process group.
 	 * A fatal signal pending means that current will exit, so the new
 	 * thread can't slip out of an OOM kill (or normal SIGKILL).
- 	 */
+	*/
 	recalc_sigpending();
 	if (signal_pending(current)) {
 		spin_unlock(&current->sighand->siglock);
@@ -1670,12 +1678,14 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_flags)
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
1.7.3.4

