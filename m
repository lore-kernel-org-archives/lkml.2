Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab1BJMYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:24:39 -0500
Received: from cantor.suse.de ([195.135.220.2]:33699 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab1BJMYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:24:36 -0500
From: stable-bot for Dhaval Giani <dhaval.giani@gmail.com>
Date: Thu, 10 Feb 2011 09:48:04 +0100
Subject: [PATCH 01/28] sched: Remove USER_SCHED
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Message-ID: <1297340643.5512.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: 7c9414385ebfdd87cc542d4e7e3bb0dbb2d3ce25 upstream
Author: Dhaval Giani <dhaval.giani@gmail.com>
AuthorDate: Wed Jan 20 13:26:18 2010 +0100

Remove the USER_SCHED feature. It has been scheduled to be removed in
2.6.34 as per http://marc.info/?l=linux-kernel&m=125728479022976&w=2

[trace from referenced thread]
[1046577.884289] general protection fault: 0000 [#1] SMP
[1046577.911332] last sysfs file: /sys/devices/platform/coretemp.7/temp1_input
[1046577.938715] CPU 3
[1046577.965814] Modules linked in: ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables coretemp k8temp
[1046577.994456] Pid: 38, comm: events/3 Not tainted 2.6.32.27intel #1 X8DT3
[1046578.023166] RIP: 0010:[] [] sched_destroy_group+0x3c/0x10d
[1046578.052639] RSP: 0000:ffff88043e5abe10 EFLAGS: 00010097
[1046578.081360] RAX: ffff880139fa5540 RBX: ffff8803d18419c0 RCX: ffff8801d2f8fb78
[1046578.109903] RDX: dead000000200200 RSI: 0000000000000000 RDI: 0000000000000000
[1046578.109905] RBP: 0000000000000246 R08: 0000000000000020 R09: ffffffff816339b8
[1046578.109907] R10: 0000000004e6e5f0 R11: 0000000000000006 R12: ffffffff816339b8
[1046578.109909] R13: ffff8803d63ac4e0 R14: ffff88043e582340 R15: ffffffff8104a216
[1046578.109911] FS: 0000000000000000(0000) GS:ffff880028260000(0000) knlGS:0000000000000000
[1046578.109914] CS: 0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[1046578.109915] CR2: 00007f55ab220000 CR3: 00000001e5797000 CR4: 00000000000006e0
[1046578.109917] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1046578.109919] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[1046578.109922] Process events/3 (pid: 38, threadinfo ffff88043e5aa000, task ffff88043e582340)
[1046578.109923] Stack:
[1046578.109924] ffff8803d63ac498 ffff8803d63ac4d8 ffff8803d63ac440 ffffffff8104a2c3
[1046578.109927] <0> ffff88043e5abef8 ffff880028276040 ffff8803d63ac4d8 ffffffff81050395
[1046578.109929] <0> ffff88043e582340 ffff88043e5826c8 ffff88043e582340 ffff88043e5abfd8
[1046578.109932] Call Trace:
[1046578.109938] [] ? cleanup_user_struct+0xad/0xcc
[1046578.109942] [] ? worker_thread+0x148/0x1d4
[1046578.109946] [] ? autoremove_wake_function+0x0/0x2e
[1046578.109948] [] ? worker_thread+0x0/0x1d4
[1046578.109951] [] ? kthread+0x79/0x81
[1046578.109955] [] ? child_rip+0xa/0x20
[1046578.109957] [] ? kthread+0x0/0x81
[1046578.109959] [] ? child_rip+0x0/0x20
[1046578.109961] Code: 3c 00 4c 8b 25 02 98 3d 00 48 89 c5 83 cf ff eb 5c 48 8b 43 10 48 63 f7 48 8b 04 f0 48 8b 90 80 00 00 00 48 8b 48 78 48 89 51 08 <48> 89 0a 48 b9 00 02 20 00 00 00 ad de 48 89 88 80 00 00 00 48
[1046578.109975] RIP [] sched_destroy_group+0x3c/0x10d
[1046578.109979] RSP
[1046578.109981] ---[ end trace 5ebc2944b7872d4a ]---

Signed-off-by: Dhaval Giani <dhaval.giani@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1263990378.24844.3.camel@localhost>
LKML-Reference: http://marc.info/?l=linux-kernel&m=129466345327931
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |   14 +--
 init/Kconfig          |   81 +++++--------
 kernel/ksysfs.c       |    8 --
 kernel/sched.c        |  108 +----------------
 kernel/sys.c          |    5 -
 kernel/user.c         |  305 -------------------------------------------------
 6 files changed, 38 insertions(+), 483 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 957a25f..c1b6ab9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -728,14 +728,6 @@ struct user_struct {
 	uid_t uid;
 	struct user_namespace *user_ns;
 
-#ifdef CONFIG_USER_SCHED
-	struct task_group *tg;
-#ifdef CONFIG_SYSFS
-	struct kobject kobj;
-	struct delayed_work work;
-#endif
-#endif
-
 #ifdef CONFIG_PERF_EVENTS
 	atomic_long_t locked_vm;
 #endif
@@ -2500,13 +2492,9 @@ extern long sched_getaffinity(pid_t pid, struct cpumask *mask);
 
 extern void normalize_rt_tasks(void);
 
-#ifdef CONFIG_GROUP_SCHED
+#ifdef CONFIG_CGROUP_SCHED
 
 extern struct task_group init_task_group;
-#ifdef CONFIG_USER_SCHED
-extern struct task_group root_task_group;
-extern void set_tg_uid(struct user_struct *user);
-#endif
 
 extern struct task_group *sched_create_group(struct task_group *parent);
 extern void sched_destroy_group(struct task_group *tg);
diff --git a/init/Kconfig b/init/Kconfig
index eb4b337..e83ea10 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -426,57 +426,6 @@ config LOG_BUF_SHIFT
 config HAVE_UNSTABLE_SCHED_CLOCK
 	bool
 
-config GROUP_SCHED
-	bool "Group CPU scheduler"
-	depends on EXPERIMENTAL
-	default n
-	help
-	  This feature lets CPU scheduler recognize task groups and control CPU
-	  bandwidth allocation to such task groups.
-	  In order to create a group from arbitrary set of processes, use
-	  CONFIG_CGROUPS. (See Control Group support.)
-
-config FAIR_GROUP_SCHED
-	bool "Group scheduling for SCHED_OTHER"
-	depends on GROUP_SCHED
-	default GROUP_SCHED
-
-config RT_GROUP_SCHED
-	bool "Group scheduling for SCHED_RR/FIFO"
-	depends on EXPERIMENTAL
-	depends on GROUP_SCHED
-	default n
-	help
-	  This feature lets you explicitly allocate real CPU bandwidth
-	  to users or control groups (depending on the "Basis for grouping tasks"
-	  setting below. If enabled, it will also make it impossible to
-	  schedule realtime tasks for non-root users until you allocate
-	  realtime bandwidth for them.
-	  See Documentation/scheduler/sched-rt-group.txt for more information.
-
-choice
-	depends on GROUP_SCHED
-	prompt "Basis for grouping tasks"
-	default USER_SCHED
-
-config USER_SCHED
-	bool "user id"
-	help
-	  This option will choose userid as the basis for grouping
-	  tasks, thus providing equal CPU bandwidth to each user.
-
-config CGROUP_SCHED
-	bool "Control groups"
- 	depends on CGROUPS
- 	help
-	  This option allows you to create arbitrary task groups
-	  using the "cgroup" pseudo filesystem and control
-	  the cpu bandwidth allocated to each such task group.
-	  Refer to Documentation/cgroups/cgroups.txt for more
-	  information on "cgroup" pseudo filesystem.
-
-endchoice
-
 menuconfig CGROUPS
 	boolean "Control Group support"
 	help
@@ -597,6 +546,36 @@ config CGROUP_MEM_RES_CTLR_SWAP
 	  Now, memory usage of swap_cgroup is 2 bytes per entry. If swap page
 	  size is 4096bytes, 512k per 1Gbytes of swap.
 
+menuconfig CGROUP_SCHED
+	bool "Group CPU scheduler"
+	depends on EXPERIMENTAL && CGROUPS
+	default n
+	help
+	  This feature lets CPU scheduler recognize task groups and control CPU
+	  bandwidth allocation to such task groups. It uses cgroups to group
+	  tasks.
+
+if CGROUP_SCHED
+config FAIR_GROUP_SCHED
+	bool "Group scheduling for SCHED_OTHER"
+	depends on CGROUP_SCHED
+	default CGROUP_SCHED
+
+config RT_GROUP_SCHED
+	bool "Group scheduling for SCHED_RR/FIFO"
+	depends on EXPERIMENTAL
+	depends on CGROUP_SCHED
+	default n
+	help
+	  This feature lets you explicitly allocate real CPU bandwidth
+	  to users or control groups (depending on the "Basis for grouping tasks"
+	  setting below. If enabled, it will also make it impossible to
+	  schedule realtime tasks for non-root users until you allocate
+	  realtime bandwidth for them.
+	  See Documentation/scheduler/sched-rt-group.txt for more information.
+
+endif #CGROUP_SCHED
+
 endif # CGROUPS
 
 config MM_OWNER
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 528dd78..9cd2b1c 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -176,16 +176,8 @@ static int __init ksysfs_init(void)
 			goto group_exit;
 	}
 
-	/* create the /sys/kernel/uids/ directory */
-	error = uids_sysfs_init();
-	if (error)
-		goto notes_exit;
-
 	return 0;
 
-notes_exit:
-	if (notes_size > 0)
-		sysfs_remove_bin_file(kernel_kobj, &notes_attr);
 group_exit:
 	sysfs_remove_group(kernel_kobj, &kernel_attr_group);
 kset_exit:
diff --git a/kernel/sched.c b/kernel/sched.c
index 9652eca..4e6dcdd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -233,7 +233,7 @@ static void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
  */
 static DEFINE_MUTEX(sched_domains_mutex);
 
-#ifdef CONFIG_GROUP_SCHED
+#ifdef CONFIG_CGROUP_SCHED
 
 #include <linux/cgroup.h>
 
@@ -243,13 +243,7 @@ static LIST_HEAD(task_groups);
 
 /* task group related information */
 struct task_group {
-#ifdef CONFIG_CGROUP_SCHED
 	struct cgroup_subsys_state css;
-#endif
-
-#ifdef CONFIG_USER_SCHED
-	uid_t uid;
-#endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* schedulable entities of this group on each cpu */
@@ -274,35 +268,7 @@ struct task_group {
 	struct list_head children;
 };
 
-#ifdef CONFIG_USER_SCHED
-
-/* Helper function to pass uid information to create_sched_user() */
-void set_tg_uid(struct user_struct *user)
-{
-	user->tg->uid = user->uid;
-}
-
-/*
- * Root task group.
- *	Every UID task group (including init_task_group aka UID-0) will
- *	be a child to this group.
- */
-struct task_group root_task_group;
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-/* Default task group's sched entity on each cpu */
-static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
-/* Default task group's cfs_rq on each cpu */
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct cfs_rq, init_tg_cfs_rq);
-#endif /* CONFIG_FAIR_GROUP_SCHED */
-
-#ifdef CONFIG_RT_GROUP_SCHED
-static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct rt_rq, init_rt_rq);
-#endif /* CONFIG_RT_GROUP_SCHED */
-#else /* !CONFIG_USER_SCHED */
 #define root_task_group init_task_group
-#endif /* CONFIG_USER_SCHED */
 
 /* task_group_lock serializes add/remove of task groups and also changes to
  * a task group's cpu shares.
@@ -318,11 +284,7 @@ static int root_task_group_empty(void)
 }
 #endif
 
-#ifdef CONFIG_USER_SCHED
-# define INIT_TASK_GROUP_LOAD	(2*NICE_0_LOAD)
-#else /* !CONFIG_USER_SCHED */
 # define INIT_TASK_GROUP_LOAD	NICE_0_LOAD
-#endif /* CONFIG_USER_SCHED */
 
 /*
  * A weight of 0 or 1 can cause arithmetics problems.
@@ -348,11 +310,7 @@ static inline struct task_group *task_group(struct task_struct *p)
 {
 	struct task_group *tg;
 
-#ifdef CONFIG_USER_SCHED
-	rcu_read_lock();
-	tg = __task_cred(p)->user->tg;
-	rcu_read_unlock();
-#elif defined(CONFIG_CGROUP_SCHED)
+#ifdef CONFIG_CGROUP_SCHED
 	tg = container_of(task_subsys_state(p, cpu_cgroup_subsys_id),
 				struct task_group, css);
 #else
@@ -383,7 +341,7 @@ static inline struct task_group *task_group(struct task_struct *p)
 	return NULL;
 }
 
-#endif	/* CONFIG_GROUP_SCHED */
+#endif	/* CONFIG_CGROUP_SCHED */
 
 /* CFS-related fields in a runqueue */
 struct cfs_rq {
@@ -9511,9 +9469,6 @@ void __init sched_init(void)
 #ifdef CONFIG_RT_GROUP_SCHED
 	alloc_size += 2 * nr_cpu_ids * sizeof(void **);
 #endif
-#ifdef CONFIG_USER_SCHED
-	alloc_size *= 2;
-#endif
 #ifdef CONFIG_CPUMASK_OFFSTACK
 	alloc_size += num_possible_cpus() * cpumask_size();
 #endif
@@ -9531,13 +9486,6 @@ void __init sched_init(void)
 		init_task_group.cfs_rq = (struct cfs_rq **)ptr;
 		ptr += nr_cpu_ids * sizeof(void **);
 
-#ifdef CONFIG_USER_SCHED
-		root_task_group.se = (struct sched_entity **)ptr;
-		ptr += nr_cpu_ids * sizeof(void **);
-
-		root_task_group.cfs_rq = (struct cfs_rq **)ptr;
-		ptr += nr_cpu_ids * sizeof(void **);
-#endif /* CONFIG_USER_SCHED */
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 #ifdef CONFIG_RT_GROUP_SCHED
 		init_task_group.rt_se = (struct sched_rt_entity **)ptr;
@@ -9546,13 +9494,6 @@ void __init sched_init(void)
 		init_task_group.rt_rq = (struct rt_rq **)ptr;
 		ptr += nr_cpu_ids * sizeof(void **);
 
-#ifdef CONFIG_USER_SCHED
-		root_task_group.rt_se = (struct sched_rt_entity **)ptr;
-		ptr += nr_cpu_ids * sizeof(void **);
-
-		root_task_group.rt_rq = (struct rt_rq **)ptr;
-		ptr += nr_cpu_ids * sizeof(void **);
-#endif /* CONFIG_USER_SCHED */
 #endif /* CONFIG_RT_GROUP_SCHED */
 #ifdef CONFIG_CPUMASK_OFFSTACK
 		for_each_possible_cpu(i) {
@@ -9572,22 +9513,13 @@ void __init sched_init(void)
 #ifdef CONFIG_RT_GROUP_SCHED
 	init_rt_bandwidth(&init_task_group.rt_bandwidth,
 			global_rt_period(), global_rt_runtime());
-#ifdef CONFIG_USER_SCHED
-	init_rt_bandwidth(&root_task_group.rt_bandwidth,
-			global_rt_period(), RUNTIME_INF);
-#endif /* CONFIG_USER_SCHED */
 #endif /* CONFIG_RT_GROUP_SCHED */
 
-#ifdef CONFIG_GROUP_SCHED
+#ifdef CONFIG_CGROUP_SCHED
 	list_add(&init_task_group.list, &task_groups);
 	INIT_LIST_HEAD(&init_task_group.children);
 
-#ifdef CONFIG_USER_SCHED
-	INIT_LIST_HEAD(&root_task_group.children);
-	init_task_group.parent = &root_task_group;
-	list_add(&init_task_group.siblings, &root_task_group.children);
-#endif /* CONFIG_USER_SCHED */
-#endif /* CONFIG_GROUP_SCHED */
+#endif /* CONFIG_CGROUP_SCHED */
 
 #if defined CONFIG_FAIR_GROUP_SCHED && defined CONFIG_SMP
 	update_shares_data = __alloc_percpu(nr_cpu_ids * sizeof(unsigned long),
@@ -9627,25 +9559,6 @@ void __init sched_init(void)
 		 * directly in rq->cfs (i.e init_task_group->se[] = NULL).
 		 */
 		init_tg_cfs_entry(&init_task_group, &rq->cfs, NULL, i, 1, NULL);
-#elif defined CONFIG_USER_SCHED
-		root_task_group.shares = NICE_0_LOAD;
-		init_tg_cfs_entry(&root_task_group, &rq->cfs, NULL, i, 0, NULL);
-		/*
-		 * In case of task-groups formed thr' the user id of tasks,
-		 * init_task_group represents tasks belonging to root user.
-		 * Hence it forms a sibling of all subsequent groups formed.
-		 * In this case, init_task_group gets only a fraction of overall
-		 * system cpu resource, based on the weight assigned to root
-		 * user's cpu share (INIT_TASK_GROUP_LOAD). This is accomplished
-		 * by letting tasks of init_task_group sit in a separate cfs_rq
-		 * (init_tg_cfs_rq) and having one entity represent this group of
-		 * tasks in rq->cfs (i.e init_task_group->se[] != NULL).
-		 */
-		init_tg_cfs_entry(&init_task_group,
-				&per_cpu(init_tg_cfs_rq, i),
-				&per_cpu(init_sched_entity, i), i, 1,
-				root_task_group.se[i]);
-
 #endif
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
@@ -10051,7 +9964,7 @@ static inline void unregister_rt_sched_group(struct task_group *tg, int cpu)
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
-#ifdef CONFIG_GROUP_SCHED
+#ifdef CONFIG_CGROUP_SCHED
 static void free_sched_group(struct task_group *tg)
 {
 	free_fair_sched_group(tg);
@@ -10160,7 +10073,7 @@ void sched_move_task(struct task_struct *tsk)
 
 	task_rq_unlock(rq, &flags);
 }
-#endif /* CONFIG_GROUP_SCHED */
+#endif /* CONFIG_CGROUP_SCHED */
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void __set_se_shares(struct sched_entity *se, unsigned long shares)
@@ -10302,13 +10215,6 @@ static int tg_schedulable(struct task_group *tg, void *data)
 		runtime = d->rt_runtime;
 	}
 
-#ifdef CONFIG_USER_SCHED
-	if (tg == &root_task_group) {
-		period = global_rt_period();
-		runtime = global_rt_runtime();
-	}
-#endif
-
 	/*
 	 * Cannot have more runtime than the period.
 	 */
diff --git a/kernel/sys.c b/kernel/sys.c
index 440ca69..e9512b1 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -567,11 +567,6 @@ static int set_user(struct cred *new)
 	if (!new_user)
 		return -EAGAIN;
 
-	if (!task_can_switch_user(new_user, current)) {
-		free_uid(new_user);
-		return -EINVAL;
-	}
-
 	if (atomic_read(&new_user->processes) >=
 				current->signal->rlim[RLIMIT_NPROC].rlim_cur &&
 			new_user != INIT_USER) {
diff --git a/kernel/user.c b/kernel/user.c
index 46d0165..766467b 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -56,9 +56,6 @@ struct user_struct root_user = {
 	.sigpending	= ATOMIC_INIT(0),
 	.locked_shm     = 0,
 	.user_ns	= &init_user_ns,
-#ifdef CONFIG_USER_SCHED
-	.tg		= &init_task_group,
-#endif
 };
 
 /*
@@ -75,268 +72,6 @@ static void uid_hash_remove(struct user_struct *up)
 	put_user_ns(up->user_ns);
 }
 
-#ifdef CONFIG_USER_SCHED
-
-static void sched_destroy_user(struct user_struct *up)
-{
-	sched_destroy_group(up->tg);
-}
-
-static int sched_create_user(struct user_struct *up)
-{
-	int rc = 0;
-
-	up->tg = sched_create_group(&root_task_group);
-	if (IS_ERR(up->tg))
-		rc = -ENOMEM;
-
-	set_tg_uid(up);
-
-	return rc;
-}
-
-#else	/* CONFIG_USER_SCHED */
-
-static void sched_destroy_user(struct user_struct *up) { }
-static int sched_create_user(struct user_struct *up) { return 0; }
-
-#endif	/* CONFIG_USER_SCHED */
-
-#if defined(CONFIG_USER_SCHED) && defined(CONFIG_SYSFS)
-
-static struct user_struct *uid_hash_find(uid_t uid, struct hlist_head *hashent)
-{
-	struct user_struct *user;
-	struct hlist_node *h;
-
-	hlist_for_each_entry(user, h, hashent, uidhash_node) {
-		if (user->uid == uid) {
-			/* possibly resurrect an "almost deleted" object */
-			if (atomic_inc_return(&user->__count) == 1)
-				cancel_delayed_work(&user->work);
-			return user;
-		}
-	}
-
-	return NULL;
-}
-
-static struct kset *uids_kset; /* represents the /sys/kernel/uids/ directory */
-static DEFINE_MUTEX(uids_mutex);
-
-static inline void uids_mutex_lock(void)
-{
-	mutex_lock(&uids_mutex);
-}
-
-static inline void uids_mutex_unlock(void)
-{
-	mutex_unlock(&uids_mutex);
-}
-
-/* uid directory attributes */
-#ifdef CONFIG_FAIR_GROUP_SCHED
-static ssize_t cpu_shares_show(struct kobject *kobj,
-			       struct kobj_attribute *attr,
-			       char *buf)
-{
-	struct user_struct *up = container_of(kobj, struct user_struct, kobj);
-
-	return sprintf(buf, "%lu\n", sched_group_shares(up->tg));
-}
-
-static ssize_t cpu_shares_store(struct kobject *kobj,
-				struct kobj_attribute *attr,
-				const char *buf, size_t size)
-{
-	struct user_struct *up = container_of(kobj, struct user_struct, kobj);
-	unsigned long shares;
-	int rc;
-
-	sscanf(buf, "%lu", &shares);
-
-	rc = sched_group_set_shares(up->tg, shares);
-
-	return (rc ? rc : size);
-}
-
-static struct kobj_attribute cpu_share_attr =
-	__ATTR(cpu_share, 0644, cpu_shares_show, cpu_shares_store);
-#endif
-
-#ifdef CONFIG_RT_GROUP_SCHED
-static ssize_t cpu_rt_runtime_show(struct kobject *kobj,
-				   struct kobj_attribute *attr,
-				   char *buf)
-{
-	struct user_struct *up = container_of(kobj, struct user_struct, kobj);
-
-	return sprintf(buf, "%ld\n", sched_group_rt_runtime(up->tg));
-}
-
-static ssize_t cpu_rt_runtime_store(struct kobject *kobj,
-				    struct kobj_attribute *attr,
-				    const char *buf, size_t size)
-{
-	struct user_struct *up = container_of(kobj, struct user_struct, kobj);
-	unsigned long rt_runtime;
-	int rc;
-
-	sscanf(buf, "%ld", &rt_runtime);
-
-	rc = sched_group_set_rt_runtime(up->tg, rt_runtime);
-
-	return (rc ? rc : size);
-}
-
-static struct kobj_attribute cpu_rt_runtime_attr =
-	__ATTR(cpu_rt_runtime, 0644, cpu_rt_runtime_show, cpu_rt_runtime_store);
-
-static ssize_t cpu_rt_period_show(struct kobject *kobj,
-				   struct kobj_attribute *attr,
-				   char *buf)
-{
-	struct user_struct *up = container_of(kobj, struct user_struct, kobj);
-
-	return sprintf(buf, "%lu\n", sched_group_rt_period(up->tg));
-}
-
-static ssize_t cpu_rt_period_store(struct kobject *kobj,
-				    struct kobj_attribute *attr,
-				    const char *buf, size_t size)
-{
-	struct user_struct *up = container_of(kobj, struct user_struct, kobj);
-	unsigned long rt_period;
-	int rc;
-
-	sscanf(buf, "%lu", &rt_period);
-
-	rc = sched_group_set_rt_period(up->tg, rt_period);
-
-	return (rc ? rc : size);
-}
-
-static struct kobj_attribute cpu_rt_period_attr =
-	__ATTR(cpu_rt_period, 0644, cpu_rt_period_show, cpu_rt_period_store);
-#endif
-
-/* default attributes per uid directory */
-static struct attribute *uids_attributes[] = {
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	&cpu_share_attr.attr,
-#endif
-#ifdef CONFIG_RT_GROUP_SCHED
-	&cpu_rt_runtime_attr.attr,
-	&cpu_rt_period_attr.attr,
-#endif
-	NULL
-};
-
-/* the lifetime of user_struct is not managed by the core (now) */
-static void uids_release(struct kobject *kobj)
-{
-	return;
-}
-
-static struct kobj_type uids_ktype = {
-	.sysfs_ops = &kobj_sysfs_ops,
-	.default_attrs = uids_attributes,
-	.release = uids_release,
-};
-
-/*
- * Create /sys/kernel/uids/<uid>/cpu_share file for this user
- * We do not create this file for users in a user namespace (until
- * sysfs tagging is implemented).
- *
- * See Documentation/scheduler/sched-design-CFS.txt for ramifications.
- */
-static int uids_user_create(struct user_struct *up)
-{
-	struct kobject *kobj = &up->kobj;
-	int error;
-
-	memset(kobj, 0, sizeof(struct kobject));
-	if (up->user_ns != &init_user_ns)
-		return 0;
-	kobj->kset = uids_kset;
-	error = kobject_init_and_add(kobj, &uids_ktype, NULL, "%d", up->uid);
-	if (error) {
-		kobject_put(kobj);
-		goto done;
-	}
-
-	kobject_uevent(kobj, KOBJ_ADD);
-done:
-	return error;
-}
-
-/* create these entries in sysfs:
- * 	"/sys/kernel/uids" directory
- * 	"/sys/kernel/uids/0" directory (for root user)
- * 	"/sys/kernel/uids/0/cpu_share" file (for root user)
- */
-int __init uids_sysfs_init(void)
-{
-	uids_kset = kset_create_and_add("uids", NULL, kernel_kobj);
-	if (!uids_kset)
-		return -ENOMEM;
-
-	return uids_user_create(&root_user);
-}
-
-/* delayed work function to remove sysfs directory for a user and free up
- * corresponding structures.
- */
-static void cleanup_user_struct(struct work_struct *w)
-{
-	struct user_struct *up = container_of(w, struct user_struct, work.work);
-	unsigned long flags;
-	int remove_user = 0;
-
-	/* Make uid_hash_remove() + sysfs_remove_file() + kobject_del()
-	 * atomic.
-	 */
-	uids_mutex_lock();
-
-	spin_lock_irqsave(&uidhash_lock, flags);
-	if (atomic_read(&up->__count) == 0) {
-		uid_hash_remove(up);
-		remove_user = 1;
-	}
-	spin_unlock_irqrestore(&uidhash_lock, flags);
-
-	if (!remove_user)
-		goto done;
-
-	if (up->user_ns == &init_user_ns) {
-		kobject_uevent(&up->kobj, KOBJ_REMOVE);
-		kobject_del(&up->kobj);
-		kobject_put(&up->kobj);
-	}
-
-	sched_destroy_user(up);
-	key_put(up->uid_keyring);
-	key_put(up->session_keyring);
-	kmem_cache_free(uid_cachep, up);
-
-done:
-	uids_mutex_unlock();
-}
-
-/* IRQs are disabled and uidhash_lock is held upon function entry.
- * IRQ state (as stored in flags) is restored and uidhash_lock released
- * upon function exit.
- */
-static void free_user(struct user_struct *up, unsigned long flags)
-{
-	INIT_DELAYED_WORK(&up->work, cleanup_user_struct);
-	schedule_delayed_work(&up->work, msecs_to_jiffies(1000));
-	spin_unlock_irqrestore(&uidhash_lock, flags);
-}
-
-#else	/* CONFIG_USER_SCHED && CONFIG_SYSFS */
-
 static struct user_struct *uid_hash_find(uid_t uid, struct hlist_head *hashent)
 {
 	struct user_struct *user;
@@ -352,11 +87,6 @@ static struct user_struct *uid_hash_find(uid_t uid, struct hlist_head *hashent)
 	return NULL;
 }
 
-int uids_sysfs_init(void) { return 0; }
-static inline int uids_user_create(struct user_struct *up) { return 0; }
-static inline void uids_mutex_lock(void) { }
-static inline void uids_mutex_unlock(void) { }
-
 /* IRQs are disabled and uidhash_lock is held upon function entry.
  * IRQ state (as stored in flags) is restored and uidhash_lock released
  * upon function exit.
@@ -365,32 +95,11 @@ static void free_user(struct user_struct *up, unsigned long flags)
 {
 	uid_hash_remove(up);
 	spin_unlock_irqrestore(&uidhash_lock, flags);
-	sched_destroy_user(up);
 	key_put(up->uid_keyring);
 	key_put(up->session_keyring);
 	kmem_cache_free(uid_cachep, up);
 }
 
-#endif
-
-#if defined(CONFIG_RT_GROUP_SCHED) && defined(CONFIG_USER_SCHED)
-/*
- * We need to check if a setuid can take place. This function should be called
- * before successfully completing the setuid.
- */
-int task_can_switch_user(struct user_struct *up, struct task_struct *tsk)
-{
-
-	return sched_rt_can_attach(up->tg, tsk);
-
-}
-#else
-int task_can_switch_user(struct user_struct *up, struct task_struct *tsk)
-{
-	return 1;
-}
-#endif
-
 /*
  * Locate the user_struct for the passed UID.  If found, take a ref on it.  The
  * caller must undo that ref with free_uid().
@@ -431,8 +140,6 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 	/* Make uid_hash_find() + uids_user_create() + uid_hash_insert()
 	 * atomic.
 	 */
-	uids_mutex_lock();
-
 	spin_lock_irq(&uidhash_lock);
 	up = uid_hash_find(uid, hashent);
 	spin_unlock_irq(&uidhash_lock);
@@ -445,14 +152,8 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 		new->uid = uid;
 		atomic_set(&new->__count, 1);
 
-		if (sched_create_user(new) < 0)
-			goto out_free_user;
-
 		new->user_ns = get_user_ns(ns);
 
-		if (uids_user_create(new))
-			goto out_destoy_sched;
-
 		/*
 		 * Before adding this, check whether we raced
 		 * on adding the same user already..
@@ -475,17 +176,11 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 		spin_unlock_irq(&uidhash_lock);
 	}
 
-	uids_mutex_unlock();
-
 	return up;
 
-out_destoy_sched:
-	sched_destroy_user(new);
 	put_user_ns(new->user_ns);
-out_free_user:
 	kmem_cache_free(uid_cachep, new);
 out_unlock:
-	uids_mutex_unlock();
 	return NULL;
 }
 
-- 
1.7.4


