Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab0EQW3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:29:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38237 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133Ab0EQW1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:27:18 -0400
Date: Tue, 18 May 2010 00:26:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] sched/core changes for v2.6.35
Message-ID: <20100517222614.GA5786@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 2.2
X-ELTE-SpamLevel: ss
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=2.2 required=5.9 tests=BAYES_50,DRUGS_ERECTILE autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
	1.2 DRUGS_ERECTILE         Refers to an erectile drug
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-core-for-linus

One notable user visible feature is that it should 
fix the long-standing (and serious) ondemand governor 
performance problem Andrew reported which caused him 
30-40% slowdowns on his laptop.

 Thanks,

	Ingo

------------------>
Arjan van de Ven (8):
      sched: Add a comment to get_cpu_idle_time_us()
      sched: Introduce a function to update the idle statistics
      sched: Update the idle statistics in get_cpu_idle_time_us()
      sched: Fold updating of the last_update_time_info into update_ts_time_stats()
      sched: Eliminate the ts->idle_lastupdate field
      sched: Intoduce get_cpu_iowait_time_us()
      ondemand: Solve a big performance issue by counting IOWAIT time as busy
      ondemand: Make the iowait-is-busy time a sysfs tunable

Changli Gao (1):
      sched, wait: Use wrapper functions

Dan Carpenter (1):
      sched: Remove some dead code

Ingo Molnar (1):
      stop_machine: Move local variable closer to the usage site in cpu_stop_cpu_callback()

Li Zefan (3):
      sched: Remove remaining USER_SCHED code
      sched: Remove USER_SCHED from documentation
      sched: Remove a stale comment

Lucas De Marchi (1):
      sched: Implement group scheduler statistics in one struct

Mike Galbraith (13):
      sched: Rate-limit nohz
      sched: Remove avg_wakeup
      sched: Remove avg_overlap
      sched: Cleanup/optimize clock updates
      sched: Tweak sched_latency and min_granularity
      sched: Fix select_idle_sibling()
      sched: Remove NORMALIZED_SLEEPER
      sched: Remove FAIR_SLEEPERS feature
      sched: Remove WAKEUP_SYNC feature
      sched: Remove SYNC_WAKEUPS feature
      sched: Remove ASYM_GRAN feature
      sched: Remove AFFINE_WAKEUPS feature
      sched: Fix UP update_avg() build warning

Oleg Nesterov (6):
      sched: Kill the broken and deadlockable cpuset_lock/cpuset_cpus_allowed_locked code
      sched: move_task_off_dead_cpu(): Take rq->lock around select_fallback_rq()
      sched: move_task_off_dead_cpu(): Remove retry logic
      sched: sched_exec(): Remove the select_fallback_rq() logic
      sched: _cpu_down(): Don't play with current->cpus_allowed
      sched: Make select_fallback_rq() cpuset friendly

Paul E. McKenney (2):
      sched: correctly place paranioa memory barriers in synchronize_sched_expedited()
      rcu: need barrier() in UP synchronize_sched_expedited()

Peter Zijlstra (7):
      sched: Fix TASK_WAKING vs fork deadlock
      sched: Optimize task_rq_lock()
      sched: Fix nr_uninterruptible count
      sched: Add enqueue/dequeue flags
      sched: Cure load average vs NO_HZ woes
      sched: Pre-compute cpumask_weight(sched_domain_span(sd))
      sched: Remove rq argument to the tracepoints

Suresh Siddha (1):
      sched: Fix select_idle_sibling() logic in select_task_rq_fair()

Tejun Heo (5):
      cpu_stop: implement stop_cpu[s]()
      stop_machine: reimplement using cpu_stop
      sched: replace migration_thread with cpu_stop
      sched: kill paranoia check in synchronize_sched_expedited()
      cpu_stop: add dummy implementation for UP


 Documentation/RCU/torture.txt                |   10 -
 Documentation/scheduler/sched-design-CFS.txt |   54 +--
 Documentation/scheduler/sched-rt-group.txt   |   20 +-
 arch/s390/kernel/time.c                      |    1 -
 drivers/cpufreq/cpufreq_ondemand.c           |   75 +++-
 drivers/xen/manage.c                         |   14 +-
 fs/eventpoll.c                               |    3 +-
 include/linux/cpuset.h                       |   16 +-
 include/linux/rcutiny.h                      |    2 -
 include/linux/rcutree.h                      |    1 -
 include/linux/sched.h                        |   70 ++--
 include/linux/stop_machine.h                 |  122 ++++-
 include/linux/tick.h                         |    5 +-
 include/linux/wait.h                         |   35 +-
 include/trace/events/sched.h                 |   32 +-
 init/Kconfig                                 |    3 +-
 kernel/Makefile                              |    2 +-
 kernel/capability.c                          |    1 -
 kernel/cgroup.c                              |    2 +-
 kernel/cpu.c                                 |   26 +-
 kernel/cpuset.c                              |   67 ++-
 kernel/cred-internals.h                      |   21 -
 kernel/cred.c                                |    3 -
 kernel/exit.c                                |    1 -
 kernel/module.c                              |   14 +-
 kernel/rcutorture.c                          |    2 +-
 kernel/sched.c                               |  726 ++++++++++----------------
 kernel/sched_debug.c                         |  108 ++---
 kernel/sched_fair.c                          |  350 ++++++-------
 kernel/sched_features.h                      |   55 --
 kernel/sched_idletask.c                      |    8 +-
 kernel/sched_rt.c                            |   15 +-
 kernel/stop_machine.c                        |  537 +++++++++++++++-----
 kernel/time/tick-sched.c                     |   84 +++-
 kernel/time/timer_list.c                     |    1 +
 kernel/trace/ftrace.c                        |    3 +-
 kernel/trace/trace_sched_switch.c            |    5 +-
 kernel/trace/trace_sched_wakeup.c            |    5 +-
 kernel/user.c                                |   11 -
 39 files changed, 1251 insertions(+), 1259 deletions(-)
 delete mode 100644 kernel/cred-internals.h

diff --git a/Documentation/RCU/torture.txt b/Documentation/RCU/torture.txt
index 0e50bc2..5d90167 100644
--- a/Documentation/RCU/torture.txt
+++ b/Documentation/RCU/torture.txt
@@ -182,16 +182,6 @@ Similarly, sched_expedited RCU provides the following:
 	sched_expedited-torture: Reader Pipe:  12660320201 95875 0 0 0 0 0 0 0 0 0
 	sched_expedited-torture: Reader Batch:  12660424885 0 0 0 0 0 0 0 0 0 0
 	sched_expedited-torture: Free-Block Circulation:  1090795 1090795 1090794 1090793 1090792 1090791 1090790 1090789 1090788 1090787 0
-	state: -1 / 0:0 3:0 4:0
-
-As before, the first four lines are similar to those for RCU.
-The last line shows the task-migration state.  The first number is
--1 if synchronize_sched_expedited() is idle, -2 if in the process of
-posting wakeups to the migration kthreads, and N when waiting on CPU N.
-Each of the colon-separated fields following the "/" is a CPU:state pair.
-Valid states are "0" for idle, "1" for waiting for quiescent state,
-"2" for passed through quiescent state, and "3" when a race with a
-CPU-hotplug event forces use of the synchronize_sched() primitive.
 
 
 USAGE
diff --git a/Documentation/scheduler/sched-design-CFS.txt b/Documentation/scheduler/sched-design-CFS.txt
index 6f33593..8239ebb 100644
--- a/Documentation/scheduler/sched-design-CFS.txt
+++ b/Documentation/scheduler/sched-design-CFS.txt
@@ -211,7 +211,7 @@ provide fair CPU time to each such task group.  For example, it may be
 desirable to first provide fair CPU time to each user on the system and then to
 each task belonging to a user.
 
-CONFIG_GROUP_SCHED strives to achieve exactly that.  It lets tasks to be
+CONFIG_CGROUP_SCHED strives to achieve exactly that.  It lets tasks to be
 grouped and divides CPU time fairly among such groups.
 
 CONFIG_RT_GROUP_SCHED permits to group real-time (i.e., SCHED_FIFO and
@@ -220,38 +220,11 @@ SCHED_RR) tasks.
 CONFIG_FAIR_GROUP_SCHED permits to group CFS (i.e., SCHED_NORMAL and
 SCHED_BATCH) tasks.
 
-At present, there are two (mutually exclusive) mechanisms to group tasks for
-CPU bandwidth control purposes:
-
- - Based on user id (CONFIG_USER_SCHED)
-
-   With this option, tasks are grouped according to their user id.
-
- - Based on "cgroup" pseudo filesystem (CONFIG_CGROUP_SCHED)
-
-   This options needs CONFIG_CGROUPS to be defined, and lets the administrator
+   These options need CONFIG_CGROUPS to be defined, and let the administrator
    create arbitrary groups of tasks, using the "cgroup" pseudo filesystem.  See
    Documentation/cgroups/cgroups.txt for more information about this filesystem.
 
-Only one of these options to group tasks can be chosen and not both.
-
-When CONFIG_USER_SCHED is defined, a directory is created in sysfs for each new
-user and a "cpu_share" file is added in that directory.
-
-	# cd /sys/kernel/uids
-	# cat 512/cpu_share		# Display user 512's CPU share
-	1024
-	# echo 2048 > 512/cpu_share	# Modify user 512's CPU share
-	# cat 512/cpu_share		# Display user 512's CPU share
-	2048
-	#
-
-CPU bandwidth between two users is divided in the ratio of their CPU shares.
-For example: if you would like user "root" to get twice the bandwidth of user
-"guest," then set the cpu_share for both the users such that "root"'s cpu_share
-is twice "guest"'s cpu_share.
-
-When CONFIG_CGROUP_SCHED is defined, a "cpu.shares" file is created for each
+When CONFIG_FAIR_GROUP_SCHED is defined, a "cpu.shares" file is created for each
 group created using the pseudo filesystem.  See example steps below to create
 task groups and modify their CPU share using the "cgroups" pseudo filesystem.
 
@@ -273,24 +246,3 @@ task groups and modify their CPU share using the "cgroups" pseudo filesystem.
 
 	# #Launch gmplayer (or your favourite movie player)
 	# echo <movie_player_pid> > multimedia/tasks
-
-8. Implementation note: user namespaces
-
-User namespaces are intended to be hierarchical.  But they are currently
-only partially implemented.  Each of those has ramifications for CFS.
-
-First, since user namespaces are hierarchical, the /sys/kernel/uids
-presentation is inadequate.  Eventually we will likely want to use sysfs
-tagging to provide private views of /sys/kernel/uids within each user
-namespace.
-
-Second, the hierarchical nature is intended to support completely
-unprivileged use of user namespaces.  So if using user groups, then
-we want the users in a user namespace to be children of the user
-who created it.
-
-That is currently unimplemented.  So instead, every user in a new
-user namespace will receive 1024 shares just like any user in the
-initial user namespace.  Note that at the moment creation of a new
-user namespace requires each of CAP_SYS_ADMIN, CAP_SETUID, and
-CAP_SETGID.
diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
index 86eabe6..605b0d4 100644
--- a/Documentation/scheduler/sched-rt-group.txt
+++ b/Documentation/scheduler/sched-rt-group.txt
@@ -126,23 +126,12 @@ priority!
 2.3 Basis for grouping tasks
 ----------------------------
 
-There are two compile-time settings for allocating CPU bandwidth. These are
-configured using the "Basis for grouping tasks" multiple choice menu under
-General setup > Group CPU Scheduler:
-
-a. CONFIG_USER_SCHED (aka "Basis for grouping tasks" =  "user id")
-
-This lets you use the virtual files under
-"/sys/kernel/uids/<uid>/cpu_rt_runtime_us" to control he CPU time reserved for
-each user .
-
-The other option is:
-
-.o CONFIG_CGROUP_SCHED (aka "Basis for grouping tasks" = "Control groups")
+Enabling CONFIG_RT_GROUP_SCHED lets you explicitly allocate real
+CPU bandwidth to task groups.
 
 This uses the /cgroup virtual file system and
 "/cgroup/<cgroup>/cpu.rt_runtime_us" to control the CPU time reserved for each
-control group instead.
+control group.
 
 For more information on working with control groups, you should read
 Documentation/cgroups/cgroups.txt as well.
@@ -161,8 +150,7 @@ For now, this can be simplified to just the following (but see Future plans):
 ===============
 
 There is work in progress to make the scheduling period for each group
-("/sys/kernel/uids/<uid>/cpu_rt_period_us" or
-"/cgroup/<cgroup>/cpu.rt_period_us" respectively) configurable as well.
+("/cgroup/<cgroup>/cpu.rt_period_us") configurable as well.
 
 The constraint on the period is that a subgroup must have a smaller or
 equal period to its parent. But realistically its not very useful _yet_
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index d906bf1..a2163c9 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -391,7 +391,6 @@ static void __init time_init_wq(void)
 	if (time_sync_wq)
 		return;
 	time_sync_wq = create_singlethread_workqueue("timesync");
-	stop_machine_create();
 }
 
 /*
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index bd444dc..8e9dbdc 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -73,6 +73,7 @@ enum {DBS_NORMAL_SAMPLE, DBS_SUB_SAMPLE};
 
 struct cpu_dbs_info_s {
 	cputime64_t prev_cpu_idle;
+	cputime64_t prev_cpu_iowait;
 	cputime64_t prev_cpu_wall;
 	cputime64_t prev_cpu_nice;
 	struct cpufreq_policy *cur_policy;
@@ -108,6 +109,7 @@ static struct dbs_tuners {
 	unsigned int down_differential;
 	unsigned int ignore_nice;
 	unsigned int powersave_bias;
+	unsigned int io_is_busy;
 } dbs_tuners_ins = {
 	.up_threshold = DEF_FREQUENCY_UP_THRESHOLD,
 	.down_differential = DEF_FREQUENCY_DOWN_DIFFERENTIAL,
@@ -148,6 +150,16 @@ static inline cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t *wall)
 	return idle_time;
 }
 
+static inline cputime64_t get_cpu_iowait_time(unsigned int cpu, cputime64_t *wall)
+{
+	u64 iowait_time = get_cpu_iowait_time_us(cpu, wall);
+
+	if (iowait_time == -1ULL)
+		return 0;
+
+	return iowait_time;
+}
+
 /*
  * Find right freq to be set now with powersave_bias on.
  * Returns the freq_hi to be used right now and will set freq_hi_jiffies,
@@ -249,6 +261,7 @@ static ssize_t show_##file_name						\
 	return sprintf(buf, "%u\n", dbs_tuners_ins.object);		\
 }
 show_one(sampling_rate, sampling_rate);
+show_one(io_is_busy, io_is_busy);
 show_one(up_threshold, up_threshold);
 show_one(ignore_nice_load, ignore_nice);
 show_one(powersave_bias, powersave_bias);
@@ -299,6 +312,23 @@ static ssize_t store_sampling_rate(struct kobject *a, struct attribute *b,
 	return count;
 }
 
+static ssize_t store_io_is_busy(struct kobject *a, struct attribute *b,
+				   const char *buf, size_t count)
+{
+	unsigned int input;
+	int ret;
+
+	ret = sscanf(buf, "%u", &input);
+	if (ret != 1)
+		return -EINVAL;
+
+	mutex_lock(&dbs_mutex);
+	dbs_tuners_ins.io_is_busy = !!input;
+	mutex_unlock(&dbs_mutex);
+
+	return count;
+}
+
 static ssize_t store_up_threshold(struct kobject *a, struct attribute *b,
 				  const char *buf, size_t count)
 {
@@ -381,6 +411,7 @@ static struct global_attr _name = \
 __ATTR(_name, 0644, show_##_name, store_##_name)
 
 define_one_rw(sampling_rate);
+define_one_rw(io_is_busy);
 define_one_rw(up_threshold);
 define_one_rw(ignore_nice_load);
 define_one_rw(powersave_bias);
@@ -392,6 +423,7 @@ static struct attribute *dbs_attributes[] = {
 	&up_threshold.attr,
 	&ignore_nice_load.attr,
 	&powersave_bias.attr,
+	&io_is_busy.attr,
 	NULL
 };
 
@@ -470,14 +502,15 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 
 	for_each_cpu(j, policy->cpus) {
 		struct cpu_dbs_info_s *j_dbs_info;
-		cputime64_t cur_wall_time, cur_idle_time;
-		unsigned int idle_time, wall_time;
+		cputime64_t cur_wall_time, cur_idle_time, cur_iowait_time;
+		unsigned int idle_time, wall_time, iowait_time;
 		unsigned int load, load_freq;
 		int freq_avg;
 
 		j_dbs_info = &per_cpu(od_cpu_dbs_info, j);
 
 		cur_idle_time = get_cpu_idle_time(j, &cur_wall_time);
+		cur_iowait_time = get_cpu_iowait_time(j, &cur_wall_time);
 
 		wall_time = (unsigned int) cputime64_sub(cur_wall_time,
 				j_dbs_info->prev_cpu_wall);
@@ -487,6 +520,10 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 				j_dbs_info->prev_cpu_idle);
 		j_dbs_info->prev_cpu_idle = cur_idle_time;
 
+		iowait_time = (unsigned int) cputime64_sub(cur_iowait_time,
+				j_dbs_info->prev_cpu_iowait);
+		j_dbs_info->prev_cpu_iowait = cur_iowait_time;
+
 		if (dbs_tuners_ins.ignore_nice) {
 			cputime64_t cur_nice;
 			unsigned long cur_nice_jiffies;
@@ -504,6 +541,16 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 			idle_time += jiffies_to_usecs(cur_nice_jiffies);
 		}
 
+		/*
+		 * For the purpose of ondemand, waiting for disk IO is an
+		 * indication that you're performance critical, and not that
+		 * the system is actually idle. So subtract the iowait time
+		 * from the cpu idle time.
+		 */
+
+		if (dbs_tuners_ins.io_is_busy && idle_time >= iowait_time)
+			idle_time -= iowait_time;
+
 		if (unlikely(!wall_time || wall_time < idle_time))
 			continue;
 
@@ -617,6 +664,29 @@ static inline void dbs_timer_exit(struct cpu_dbs_info_s *dbs_info)
 	cancel_delayed_work_sync(&dbs_info->work);
 }
 
+/*
+ * Not all CPUs want IO time to be accounted as busy; this dependson how
+ * efficient idling at a higher frequency/voltage is.
+ * Pavel Machek says this is not so for various generations of AMD and old
+ * Intel systems.
+ * Mike Chan (androidlcom) calis this is also not true for ARM.
+ * Because of this, whitelist specific known (series) of CPUs by default, and
+ * leave all others up to the user.
+ */
+static int should_io_be_busy(void)
+{
+#if defined(CONFIG_X86)
+	/*
+	 * For Intel, Core 2 (model 15) andl later have an efficient idle.
+	 */
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
+	    boot_cpu_data.x86 == 6 &&
+	    boot_cpu_data.x86_model >= 15)
+		return 1;
+#endif
+	return 0;
+}
+
 static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 				   unsigned int event)
 {
@@ -679,6 +749,7 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 			dbs_tuners_ins.sampling_rate =
 				max(min_sampling_rate,
 				    latency * LATENCY_MULTIPLIER);
+			dbs_tuners_ins.io_is_busy = should_io_be_busy();
 		}
 		mutex_unlock(&dbs_mutex);
 
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 2ac4440..8943b8c 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -80,12 +80,6 @@ static void do_suspend(void)
 
 	shutting_down = SHUTDOWN_SUSPEND;
 
-	err = stop_machine_create();
-	if (err) {
-		printk(KERN_ERR "xen suspend: failed to setup stop_machine %d\n", err);
-		goto out;
-	}
-
 #ifdef CONFIG_PREEMPT
 	/* If the kernel is preemptible, we need to freeze all the processes
 	   to prevent them from being in the middle of a pagetable update
@@ -93,7 +87,7 @@ static void do_suspend(void)
 	err = freeze_processes();
 	if (err) {
 		printk(KERN_ERR "xen suspend: freeze failed %d\n", err);
-		goto out_destroy_sm;
+		goto out;
 	}
 #endif
 
@@ -136,12 +130,8 @@ out_resume:
 out_thaw:
 #ifdef CONFIG_PREEMPT
 	thaw_processes();
-
-out_destroy_sm:
-#endif
-	stop_machine_destroy();
-
 out:
+#endif
 	shutting_down = SHUTDOWN_INVALID;
 }
 #endif	/* CONFIG_PM_SLEEP */
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index bd056a5..3817149 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1140,8 +1140,7 @@ retry:
 		 * ep_poll_callback() when events will become available.
 		 */
 		init_waitqueue_entry(&wait, current);
-		wait.flags |= WQ_FLAG_EXCLUSIVE;
-		__add_wait_queue(&ep->wq, &wait);
+		__add_wait_queue_exclusive(&ep->wq, &wait);
 
 		for (;;) {
 			/*
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index a5740fc..a73454a 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -21,8 +21,7 @@ extern int number_of_cpusets;	/* How many cpusets are defined in system? */
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
-extern void cpuset_cpus_allowed_locked(struct task_struct *p,
-				       struct cpumask *mask);
+extern int cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
@@ -69,9 +68,6 @@ struct seq_file;
 extern void cpuset_task_status_allowed(struct seq_file *m,
 					struct task_struct *task);
 
-extern void cpuset_lock(void);
-extern void cpuset_unlock(void);
-
 extern int cpuset_mem_spread_node(void);
 
 static inline int cpuset_do_page_mem_spread(void)
@@ -105,10 +101,11 @@ static inline void cpuset_cpus_allowed(struct task_struct *p,
 {
 	cpumask_copy(mask, cpu_possible_mask);
 }
-static inline void cpuset_cpus_allowed_locked(struct task_struct *p,
-					      struct cpumask *mask)
+
+static inline int cpuset_cpus_allowed_fallback(struct task_struct *p)
 {
-	cpumask_copy(mask, cpu_possible_mask);
+	cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
+	return cpumask_any(cpu_active_mask);
 }
 
 static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
@@ -157,9 +154,6 @@ static inline void cpuset_task_status_allowed(struct seq_file *m,
 {
 }
 
-static inline void cpuset_lock(void) {}
-static inline void cpuset_unlock(void) {}
-
 static inline int cpuset_mem_spread_node(void)
 {
 	return 0;
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index a519587..0006b2d 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -60,8 +60,6 @@ static inline long rcu_batches_completed_bh(void)
 	return 0;
 }
 
-extern int rcu_expedited_torture_stats(char *page);
-
 static inline void rcu_force_quiescent_state(void)
 {
 }
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 42cc3a0..24e467e 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -35,7 +35,6 @@ struct notifier_block;
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern int rcu_needs_cpu(int cpu);
-extern int rcu_expedited_torture_stats(char *page);
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index dad7f66..dfea405 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -275,11 +275,17 @@ extern cpumask_var_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
 extern int select_nohz_load_balancer(int cpu);
 extern int get_nohz_load_balancer(void);
+extern int nohz_ratelimit(int cpu);
 #else
 static inline int select_nohz_load_balancer(int cpu)
 {
 	return 0;
 }
+
+static inline int nohz_ratelimit(int cpu)
+{
+	return 0;
+}
 #endif
 
 /*
@@ -954,6 +960,7 @@ struct sched_domain {
 	char *name;
 #endif
 
+	unsigned int span_weight;
 	/*
 	 * Span of all CPUs in this domain.
 	 *
@@ -1026,12 +1033,17 @@ struct sched_domain;
 #define WF_SYNC		0x01		/* waker goes to sleep after wakup */
 #define WF_FORK		0x02		/* child wakeup after fork */
 
+#define ENQUEUE_WAKEUP		1
+#define ENQUEUE_WAKING		2
+#define ENQUEUE_HEAD		4
+
+#define DEQUEUE_SLEEP		1
+
 struct sched_class {
 	const struct sched_class *next;
 
-	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup,
-			      bool head);
-	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
+	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int flags);
+	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int flags);
 	void (*yield_task) (struct rq *rq);
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
@@ -1040,7 +1052,8 @@ struct sched_class {
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 #ifdef CONFIG_SMP
-	int  (*select_task_rq)(struct task_struct *p, int sd_flag, int flags);
+	int  (*select_task_rq)(struct rq *rq, struct task_struct *p,
+			       int sd_flag, int flags);
 
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
@@ -1077,36 +1090,8 @@ struct load_weight {
 	unsigned long weight, inv_weight;
 };
 
-/*
- * CFS stats for a schedulable entity (task, task-group etc)
- *
- * Current field usage histogram:
- *
- *     4 se->block_start
- *     4 se->run_node
- *     4 se->sleep_start
- *     6 se->load.weight
- */
-struct sched_entity {
-	struct load_weight	load;		/* for load-balancing */
-	struct rb_node		run_node;
-	struct list_head	group_node;
-	unsigned int		on_rq;
-
-	u64			exec_start;
-	u64			sum_exec_runtime;
-	u64			vruntime;
-	u64			prev_sum_exec_runtime;
-
-	u64			last_wakeup;
-	u64			avg_overlap;
-
-	u64			nr_migrations;
-
-	u64			start_runtime;
-	u64			avg_wakeup;
-
 #ifdef CONFIG_SCHEDSTATS
+struct sched_statistics {
 	u64			wait_start;
 	u64			wait_max;
 	u64			wait_count;
@@ -1138,6 +1123,24 @@ struct sched_entity {
 	u64			nr_wakeups_affine_attempts;
 	u64			nr_wakeups_passive;
 	u64			nr_wakeups_idle;
+};
+#endif
+
+struct sched_entity {
+	struct load_weight	load;		/* for load-balancing */
+	struct rb_node		run_node;
+	struct list_head	group_node;
+	unsigned int		on_rq;
+
+	u64			exec_start;
+	u64			sum_exec_runtime;
+	u64			vruntime;
+	u64			prev_sum_exec_runtime;
+
+	u64			nr_migrations;
+
+#ifdef CONFIG_SCHEDSTATS
+	struct sched_statistics statistics;
 #endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -1847,6 +1850,7 @@ extern void sched_clock_idle_sleep_event(void);
 extern void sched_clock_idle_wakeup_event(u64 delta_ns);
 
 #ifdef CONFIG_HOTPLUG_CPU
+extern void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p);
 extern void idle_task_exit(void);
 #else
 static inline void idle_task_exit(void) {}
diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index baba3a2..6b524a0 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -1,13 +1,101 @@
 #ifndef _LINUX_STOP_MACHINE
 #define _LINUX_STOP_MACHINE
-/* "Bogolock": stop the entire machine, disable interrupts.  This is a
-   very heavy lock, which is equivalent to grabbing every spinlock
-   (and more).  So the "read" side to such a lock is anything which
-   disables preeempt. */
+
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
+#include <linux/list.h>
 #include <asm/system.h>
 
+/*
+ * stop_cpu[s]() is simplistic per-cpu maximum priority cpu
+ * monopolization mechanism.  The caller can specify a non-sleeping
+ * function to be executed on a single or multiple cpus preempting all
+ * other processes and monopolizing those cpus until it finishes.
+ *
+ * Resources for this mechanism are preallocated when a cpu is brought
+ * up and requests are guaranteed to be served as long as the target
+ * cpus are online.
+ */
+typedef int (*cpu_stop_fn_t)(void *arg);
+
+#ifdef CONFIG_SMP
+
+struct cpu_stop_work {
+	struct list_head	list;		/* cpu_stopper->works */
+	cpu_stop_fn_t		fn;
+	void			*arg;
+	struct cpu_stop_done	*done;
+};
+
+int stop_one_cpu(unsigned int cpu, cpu_stop_fn_t fn, void *arg);
+void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void *arg,
+			 struct cpu_stop_work *work_buf);
+int stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg);
+int try_stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg);
+
+#else	/* CONFIG_SMP */
+
+#include <linux/workqueue.h>
+
+struct cpu_stop_work {
+	struct work_struct	work;
+	cpu_stop_fn_t		fn;
+	void			*arg;
+};
+
+static inline int stop_one_cpu(unsigned int cpu, cpu_stop_fn_t fn, void *arg)
+{
+	int ret = -ENOENT;
+	preempt_disable();
+	if (cpu == smp_processor_id())
+		ret = fn(arg);
+	preempt_enable();
+	return ret;
+}
+
+static void stop_one_cpu_nowait_workfn(struct work_struct *work)
+{
+	struct cpu_stop_work *stwork =
+		container_of(work, struct cpu_stop_work, work);
+	preempt_disable();
+	stwork->fn(stwork->arg);
+	preempt_enable();
+}
+
+static inline void stop_one_cpu_nowait(unsigned int cpu,
+				       cpu_stop_fn_t fn, void *arg,
+				       struct cpu_stop_work *work_buf)
+{
+	if (cpu == smp_processor_id()) {
+		INIT_WORK(&work_buf->work, stop_one_cpu_nowait_workfn);
+		work_buf->fn = fn;
+		work_buf->arg = arg;
+		schedule_work(&work_buf->work);
+	}
+}
+
+static inline int stop_cpus(const struct cpumask *cpumask,
+			    cpu_stop_fn_t fn, void *arg)
+{
+	if (cpumask_test_cpu(raw_smp_processor_id(), cpumask))
+		return stop_one_cpu(raw_smp_processor_id(), fn, arg);
+	return -ENOENT;
+}
+
+static inline int try_stop_cpus(const struct cpumask *cpumask,
+				cpu_stop_fn_t fn, void *arg)
+{
+	return stop_cpus(cpumask, fn, arg);
+}
+
+#endif	/* CONFIG_SMP */
+
+/*
+ * stop_machine "Bogolock": stop the entire machine, disable
+ * interrupts.  This is a very heavy lock, which is equivalent to
+ * grabbing every spinlock (and more).  So the "read" side to such a
+ * lock is anything which disables preeempt.
+ */
 #if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
 
 /**
@@ -36,24 +124,7 @@ int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
  */
 int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
 
-/**
- * stop_machine_create: create all stop_machine threads
- *
- * Description: This causes all stop_machine threads to be created before
- * stop_machine actually gets called. This can be used by subsystems that
- * need a non failing stop_machine infrastructure.
- */
-int stop_machine_create(void);
-
-/**
- * stop_machine_destroy: destroy all stop_machine threads
- *
- * Description: This causes all stop_machine threads which were created with
- * stop_machine_create to be destroyed again.
- */
-void stop_machine_destroy(void);
-
-#else
+#else	 /* CONFIG_STOP_MACHINE && CONFIG_SMP */
 
 static inline int stop_machine(int (*fn)(void *), void *data,
 			       const struct cpumask *cpus)
@@ -65,8 +136,5 @@ static inline int stop_machine(int (*fn)(void *), void *data,
 	return ret;
 }
 
-static inline int stop_machine_create(void) { return 0; }
-static inline void stop_machine_destroy(void) { }
-
-#endif /* CONFIG_SMP */
-#endif /* _LINUX_STOP_MACHINE */
+#endif	/* CONFIG_STOP_MACHINE && CONFIG_SMP */
+#endif	/* _LINUX_STOP_MACHINE */
diff --git a/include/linux/tick.h b/include/linux/tick.h
index d2ae79e..b232ccc 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -42,6 +42,7 @@ enum tick_nohz_mode {
  * @idle_waketime:	Time when the idle was interrupted
  * @idle_exittime:	Time when the idle state was left
  * @idle_sleeptime:	Sum of the time slept in idle with sched tick stopped
+ * @iowait_sleeptime:	Sum of the time slept in idle with sched tick stopped, with IO outstanding
  * @sleep_length:	Duration of the current idle sleep
  * @do_timer_lst:	CPU was the last one doing do_timer before going idle
  */
@@ -60,7 +61,7 @@ struct tick_sched {
 	ktime_t				idle_waketime;
 	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
-	ktime_t				idle_lastupdate;
+	ktime_t				iowait_sleeptime;
 	ktime_t				sleep_length;
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
@@ -124,6 +125,7 @@ extern void tick_nohz_stop_sched_tick(int inidle);
 extern void tick_nohz_restart_sched_tick(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
+extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 # else
 static inline void tick_nohz_stop_sched_tick(int inidle) { }
 static inline void tick_nohz_restart_sched_tick(void) { }
@@ -134,6 +136,7 @@ static inline ktime_t tick_nohz_get_sleep_length(void)
 	return len;
 }
 static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
+static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 # endif /* !NO_HZ */
 
 #endif
diff --git a/include/linux/wait.h b/include/linux/wait.h
index a48e16b..76d96d0 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -127,12 +127,26 @@ static inline void __add_wait_queue(wait_queue_head_t *head, wait_queue_t *new)
 /*
  * Used for wake-one threads:
  */
+static inline void __add_wait_queue_exclusive(wait_queue_head_t *q,
+					      wait_queue_t *wait)
+{
+	wait->flags |= WQ_FLAG_EXCLUSIVE;
+	__add_wait_queue(q, wait);
+}
+
 static inline void __add_wait_queue_tail(wait_queue_head_t *head,
-						wait_queue_t *new)
+					 wait_queue_t *new)
 {
 	list_add_tail(&new->task_list, &head->task_list);
 }
 
+static inline void __add_wait_queue_tail_exclusive(wait_queue_head_t *q,
+					      wait_queue_t *wait)
+{
+	wait->flags |= WQ_FLAG_EXCLUSIVE;
+	__add_wait_queue_tail(q, wait);
+}
+
 static inline void __remove_wait_queue(wait_queue_head_t *head,
 							wait_queue_t *old)
 {
@@ -404,25 +418,6 @@ do {									\
 })
 
 /*
- * Must be called with the spinlock in the wait_queue_head_t held.
- */
-static inline void add_wait_queue_exclusive_locked(wait_queue_head_t *q,
-						   wait_queue_t * wait)
-{
-	wait->flags |= WQ_FLAG_EXCLUSIVE;
-	__add_wait_queue_tail(q,  wait);
-}
-
-/*
- * Must be called with the spinlock in the wait_queue_head_t held.
- */
-static inline void remove_wait_queue_locked(wait_queue_head_t *q,
-					    wait_queue_t * wait)
-{
-	__remove_wait_queue(q,  wait);
-}
-
-/*
  * These are the old interfaces to sleep waiting for an event.
  * They are racy.  DO NOT use them, use the wait_event* interfaces above.
  * We plan to remove these interfaces.
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index cfceb0b..4f733ec 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -51,15 +51,12 @@ TRACE_EVENT(sched_kthread_stop_ret,
 
 /*
  * Tracepoint for waiting on task to unschedule:
- *
- * (NOTE: the 'rq' argument is not used by generic trace events,
- *        but used by the latency tracer plugin. )
  */
 TRACE_EVENT(sched_wait_task,
 
-	TP_PROTO(struct rq *rq, struct task_struct *p),
+	TP_PROTO(struct task_struct *p),
 
-	TP_ARGS(rq, p),
+	TP_ARGS(p),
 
 	TP_STRUCT__entry(
 		__array(	char,	comm,	TASK_COMM_LEN	)
@@ -79,15 +76,12 @@ TRACE_EVENT(sched_wait_task,
 
 /*
  * Tracepoint for waking up a task:
- *
- * (NOTE: the 'rq' argument is not used by generic trace events,
- *        but used by the latency tracer plugin. )
  */
 DECLARE_EVENT_CLASS(sched_wakeup_template,
 
-	TP_PROTO(struct rq *rq, struct task_struct *p, int success),
+	TP_PROTO(struct task_struct *p, int success),
 
-	TP_ARGS(rq, p, success),
+	TP_ARGS(p, success),
 
 	TP_STRUCT__entry(
 		__array(	char,	comm,	TASK_COMM_LEN	)
@@ -111,31 +105,25 @@ DECLARE_EVENT_CLASS(sched_wakeup_template,
 );
 
 DEFINE_EVENT(sched_wakeup_template, sched_wakeup,
-	     TP_PROTO(struct rq *rq, struct task_struct *p, int success),
-	     TP_ARGS(rq, p, success));
+	     TP_PROTO(struct task_struct *p, int success),
+	     TP_ARGS(p, success));
 
 /*
  * Tracepoint for waking up a new task:
- *
- * (NOTE: the 'rq' argument is not used by generic trace events,
- *        but used by the latency tracer plugin. )
  */
 DEFINE_EVENT(sched_wakeup_template, sched_wakeup_new,
-	     TP_PROTO(struct rq *rq, struct task_struct *p, int success),
-	     TP_ARGS(rq, p, success));
+	     TP_PROTO(struct task_struct *p, int success),
+	     TP_ARGS(p, success));
 
 /*
  * Tracepoint for task switches, performed by the scheduler:
- *
- * (NOTE: the 'rq' argument is not used by generic trace events,
- *        but used by the latency tracer plugin. )
  */
 TRACE_EVENT(sched_switch,
 
-	TP_PROTO(struct rq *rq, struct task_struct *prev,
+	TP_PROTO(struct task_struct *prev,
 		 struct task_struct *next),
 
-	TP_ARGS(rq, prev, next),
+	TP_ARGS(prev, next),
 
 	TP_STRUCT__entry(
 		__array(	char,	prev_comm,	TASK_COMM_LEN	)
diff --git a/init/Kconfig b/init/Kconfig
index eb77e8c..5fe94b8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -604,8 +604,7 @@ config RT_GROUP_SCHED
 	default n
 	help
 	  This feature lets you explicitly allocate real CPU bandwidth
-	  to users or control groups (depending on the "Basis for grouping tasks"
-	  setting below. If enabled, it will also make it impossible to
+	  to task groups. If enabled, it will also make it impossible to
 	  schedule realtime tasks for non-root users until you allocate
 	  realtime bandwidth for them.
 	  See Documentation/scheduler/sched-rt-group.txt for more information.
diff --git a/kernel/Makefile b/kernel/Makefile
index a987aa1..149e18e 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -68,7 +68,7 @@ obj-$(CONFIG_USER_NS) += user_namespace.o
 obj-$(CONFIG_PID_NS) += pid_namespace.o
 obj-$(CONFIG_IKCONFIG) += configs.o
 obj-$(CONFIG_RESOURCE_COUNTERS) += res_counter.o
-obj-$(CONFIG_STOP_MACHINE) += stop_machine.o
+obj-$(CONFIG_SMP) += stop_machine.o
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
 obj-$(CONFIG_AUDIT) += audit.o auditfilter.o audit_watch.o
 obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
diff --git a/kernel/capability.c b/kernel/capability.c
index 9e4697e..2f05303 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -15,7 +15,6 @@
 #include <linux/syscalls.h>
 #include <linux/pid_namespace.h>
 #include <asm/uaccess.h>
-#include "cred-internals.h"
 
 /*
  * Leveraged for setting/resetting capabilities
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e2769e1..4a07d05 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3010,7 +3010,7 @@ static int cgroup_event_wake(wait_queue_t *wait, unsigned mode,
 	unsigned long flags = (unsigned long)key;
 
 	if (flags & POLLHUP) {
-		remove_wait_queue_locked(event->wqh, &event->wait);
+		__remove_wait_queue(event->wqh, &event->wait);
 		spin_lock(&cgrp->event_list_lock);
 		list_del(&event->list);
 		spin_unlock(&cgrp->event_list_lock);
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 25bba73..5457775 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -164,6 +164,7 @@ static inline void check_for_tasks(int cpu)
 }
 
 struct take_cpu_down_param {
+	struct task_struct *caller;
 	unsigned long mod;
 	void *hcpu;
 };
@@ -172,6 +173,7 @@ struct take_cpu_down_param {
 static int __ref take_cpu_down(void *_param)
 {
 	struct take_cpu_down_param *param = _param;
+	unsigned int cpu = (unsigned long)param->hcpu;
 	int err;
 
 	/* Ensure this CPU doesn't handle any more interrupts. */
@@ -182,6 +184,8 @@ static int __ref take_cpu_down(void *_param)
 	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
 				param->hcpu);
 
+	if (task_cpu(param->caller) == cpu)
+		move_task_off_dead_cpu(cpu, param->caller);
 	/* Force idle task to run as soon as we yield: it should
 	   immediately notice cpu is offline and die quickly. */
 	sched_idle_next();
@@ -192,10 +196,10 @@ static int __ref take_cpu_down(void *_param)
 static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 {
 	int err, nr_calls = 0;
-	cpumask_var_t old_allowed;
 	void *hcpu = (void *)(long)cpu;
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct take_cpu_down_param tcd_param = {
+		.caller = current,
 		.mod = mod,
 		.hcpu = hcpu,
 	};
@@ -206,9 +210,6 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
-	if (!alloc_cpumask_var(&old_allowed, GFP_KERNEL))
-		return -ENOMEM;
-
 	cpu_hotplug_begin();
 	set_cpu_active(cpu, false);
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
@@ -225,10 +226,6 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 		goto out_release;
 	}
 
-	/* Ensure that we are not runnable on dying cpu */
-	cpumask_copy(old_allowed, &current->cpus_allowed);
-	set_cpus_allowed_ptr(current, cpu_active_mask);
-
 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
 	if (err) {
 		set_cpu_active(cpu, true);
@@ -237,7 +234,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 
-		goto out_allowed;
+		goto out_release;
 	}
 	BUG_ON(cpu_online(cpu));
 
@@ -255,8 +252,6 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 
 	check_for_tasks(cpu);
 
-out_allowed:
-	set_cpus_allowed_ptr(current, old_allowed);
 out_release:
 	cpu_hotplug_done();
 	if (!err) {
@@ -264,7 +259,6 @@ out_release:
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 	}
-	free_cpumask_var(old_allowed);
 	return err;
 }
 
@@ -272,9 +266,6 @@ int __ref cpu_down(unsigned int cpu)
 {
 	int err;
 
-	err = stop_machine_create();
-	if (err)
-		return err;
 	cpu_maps_update_begin();
 
 	if (cpu_hotplug_disabled) {
@@ -286,7 +277,6 @@ int __ref cpu_down(unsigned int cpu)
 
 out:
 	cpu_maps_update_done();
-	stop_machine_destroy();
 	return err;
 }
 EXPORT_SYMBOL(cpu_down);
@@ -367,9 +357,6 @@ int disable_nonboot_cpus(void)
 {
 	int cpu, first_cpu, error;
 
-	error = stop_machine_create();
-	if (error)
-		return error;
 	cpu_maps_update_begin();
 	first_cpu = cpumask_first(cpu_online_mask);
 	/*
@@ -400,7 +387,6 @@ int disable_nonboot_cpus(void)
 		printk(KERN_ERR "Non-boot CPUs are not disabled\n");
 	}
 	cpu_maps_update_done();
-	stop_machine_destroy();
 	return error;
 }
 
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index d109467..9a50c5f 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2182,19 +2182,52 @@ void __init cpuset_init_smp(void)
 void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 {
 	mutex_lock(&callback_mutex);
-	cpuset_cpus_allowed_locked(tsk, pmask);
+	task_lock(tsk);
+	guarantee_online_cpus(task_cs(tsk), pmask);
+	task_unlock(tsk);
 	mutex_unlock(&callback_mutex);
 }
 
-/**
- * cpuset_cpus_allowed_locked - return cpus_allowed mask from a tasks cpuset.
- * Must be called with callback_mutex held.
- **/
-void cpuset_cpus_allowed_locked(struct task_struct *tsk, struct cpumask *pmask)
+int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 {
-	task_lock(tsk);
-	guarantee_online_cpus(task_cs(tsk), pmask);
-	task_unlock(tsk);
+	const struct cpuset *cs;
+	int cpu;
+
+	rcu_read_lock();
+	cs = task_cs(tsk);
+	if (cs)
+		cpumask_copy(&tsk->cpus_allowed, cs->cpus_allowed);
+	rcu_read_unlock();
+
+	/*
+	 * We own tsk->cpus_allowed, nobody can change it under us.
+	 *
+	 * But we used cs && cs->cpus_allowed lockless and thus can
+	 * race with cgroup_attach_task() or update_cpumask() and get
+	 * the wrong tsk->cpus_allowed. However, both cases imply the
+	 * subsequent cpuset_change_cpumask()->set_cpus_allowed_ptr()
+	 * which takes task_rq_lock().
+	 *
+	 * If we are called after it dropped the lock we must see all
+	 * changes in tsk_cs()->cpus_allowed. Otherwise we can temporary
+	 * set any mask even if it is not right from task_cs() pov,
+	 * the pending set_cpus_allowed_ptr() will fix things.
+	 */
+
+	cpu = cpumask_any_and(&tsk->cpus_allowed, cpu_active_mask);
+	if (cpu >= nr_cpu_ids) {
+		/*
+		 * Either tsk->cpus_allowed is wrong (see above) or it
+		 * is actually empty. The latter case is only possible
+		 * if we are racing with remove_tasks_in_empty_cpuset().
+		 * Like above we can temporary set any mask and rely on
+		 * set_cpus_allowed_ptr() as synchronization point.
+		 */
+		cpumask_copy(&tsk->cpus_allowed, cpu_possible_mask);
+		cpu = cpumask_any(cpu_active_mask);
+	}
+
+	return cpu;
 }
 
 void cpuset_init_current_mems_allowed(void)
@@ -2383,22 +2416,6 @@ int __cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask)
 }
 
 /**
- * cpuset_lock - lock out any changes to cpuset structures
- *
- * The out of memory (oom) code needs to mutex_lock cpusets
- * from being changed while it scans the tasklist looking for a
- * task in an overlapping cpuset.  Expose callback_mutex via this
- * cpuset_lock() routine, so the oom code can lock it, before
- * locking the task list.  The tasklist_lock is a spinlock, so
- * must be taken inside callback_mutex.
- */
-
-void cpuset_lock(void)
-{
-	mutex_lock(&callback_mutex);
-}
-
-/**
  * cpuset_unlock - release lock on cpuset changes
  *
  * Undo the lock taken in a previous cpuset_lock() call.
diff --git a/kernel/cred-internals.h b/kernel/cred-internals.h
deleted file mode 100644
index 2dc4fc2..0000000
--- a/kernel/cred-internals.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/* Internal credentials stuff
- *
- * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-
-/*
- * user.c
- */
-static inline void sched_switch_user(struct task_struct *p)
-{
-#ifdef CONFIG_USER_SCHED
-	sched_move_task(p);
-#endif	/* CONFIG_USER_SCHED */
-}
-
diff --git a/kernel/cred.c b/kernel/cred.c
index 62af181..8f3672a 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -17,7 +17,6 @@
 #include <linux/init_task.h>
 #include <linux/security.h>
 #include <linux/cn_proc.h>
-#include "cred-internals.h"
 
 #if 0
 #define kdebug(FMT, ...) \
@@ -560,8 +559,6 @@ int commit_creds(struct cred *new)
 		atomic_dec(&old->user->processes);
 	alter_cred_subscribers(old, -2);
 
-	sched_switch_user(task);
-
 	/* send notifications */
 	if (new->uid   != old->uid  ||
 	    new->euid  != old->euid ||
diff --git a/kernel/exit.c b/kernel/exit.c
index 7f2683a..eabca5a 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -55,7 +55,6 @@
 #include <asm/unistd.h>
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
-#include "cred-internals.h"
 
 static void exit_mm(struct task_struct * tsk);
 
diff --git a/kernel/module.c b/kernel/module.c
index 1016b75..0838246 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -723,16 +723,8 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 		return -EFAULT;
 	name[MODULE_NAME_LEN-1] = '\0';
 
-	/* Create stop_machine threads since free_module relies on
-	 * a non-failing stop_machine call. */
-	ret = stop_machine_create();
-	if (ret)
-		return ret;
-
-	if (mutex_lock_interruptible(&module_mutex) != 0) {
-		ret = -EINTR;
-		goto out_stop;
-	}
+	if (mutex_lock_interruptible(&module_mutex) != 0)
+		return -EINTR;
 
 	mod = find_module(name);
 	if (!mod) {
@@ -792,8 +784,6 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 
  out:
 	mutex_unlock(&module_mutex);
-out_stop:
-	stop_machine_destroy();
 	return ret;
 }
 
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 58df55b..2b676f3 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -669,7 +669,7 @@ static struct rcu_torture_ops sched_expedited_ops = {
 	.sync		= synchronize_sched_expedited,
 	.cb_barrier	= NULL,
 	.fqs		= rcu_sched_force_quiescent_state,
-	.stats		= rcu_expedited_torture_stats,
+	.stats		= NULL,
 	.irq_capable	= 1,
 	.name		= "sched_expedited"
 };
diff --git a/kernel/sched.c b/kernel/sched.c
index 6af210a..b531d79 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -55,9 +55,9 @@
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
 #include <linux/percpu.h>
-#include <linux/kthread.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/stop_machine.h>
 #include <linux/sysctl.h>
 #include <linux/syscalls.h>
 #include <linux/times.h>
@@ -493,8 +493,11 @@ struct rq {
 	#define CPU_LOAD_IDX_MAX 5
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
 #ifdef CONFIG_NO_HZ
+	u64 nohz_stamp;
 	unsigned char in_nohz_recently;
 #endif
+	unsigned int skip_clock_update;
+
 	/* capture load from *all* tasks on this cpu: */
 	struct load_weight load;
 	unsigned long nr_load_updates;
@@ -536,15 +539,13 @@ struct rq {
 	int post_schedule;
 	int active_balance;
 	int push_cpu;
+	struct cpu_stop_work active_balance_work;
 	/* cpu of this runqueue: */
 	int cpu;
 	int online;
 
 	unsigned long avg_load_per_task;
 
-	struct task_struct *migration_thread;
-	struct list_head migration_queue;
-
 	u64 rt_avg;
 	u64 age_stamp;
 	u64 idle_stamp;
@@ -592,6 +593,13 @@ static inline
 void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
 {
 	rq->curr->sched_class->check_preempt_curr(rq, p, flags);
+
+	/*
+	 * A queue event has occurred, and we're going to schedule.  In
+	 * this case, we can save a useless back to back clock update.
+	 */
+	if (test_tsk_need_resched(p))
+		rq->skip_clock_update = 1;
 }
 
 static inline int cpu_of(struct rq *rq)
@@ -626,7 +634,8 @@ static inline int cpu_of(struct rq *rq)
 
 inline void update_rq_clock(struct rq *rq)
 {
-	rq->clock = sched_clock_cpu(cpu_of(rq));
+	if (!rq->skip_clock_update)
+		rq->clock = sched_clock_cpu(cpu_of(rq));
 }
 
 /*
@@ -904,16 +913,12 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 #endif /* __ARCH_WANT_UNLOCKED_CTXSW */
 
 /*
- * Check whether the task is waking, we use this to synchronize against
- * ttwu() so that task_cpu() reports a stable number.
- *
- * We need to make an exception for PF_STARTING tasks because the fork
- * path might require task_rq_lock() to work, eg. it can call
- * set_cpus_allowed_ptr() from the cpuset clone_ns code.
+ * Check whether the task is waking, we use this to synchronize ->cpus_allowed
+ * against ttwu().
  */
 static inline int task_is_waking(struct task_struct *p)
 {
-	return unlikely((p->state == TASK_WAKING) && !(p->flags & PF_STARTING));
+	return unlikely(p->state == TASK_WAKING);
 }
 
 /*
@@ -926,11 +931,9 @@ static inline struct rq *__task_rq_lock(struct task_struct *p)
 	struct rq *rq;
 
 	for (;;) {
-		while (task_is_waking(p))
-			cpu_relax();
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p) && !task_is_waking(p)))
+		if (likely(rq == task_rq(p)))
 			return rq;
 		raw_spin_unlock(&rq->lock);
 	}
@@ -947,12 +950,10 @@ static struct rq *task_rq_lock(struct task_struct *p, unsigned long *flags)
 	struct rq *rq;
 
 	for (;;) {
-		while (task_is_waking(p))
-			cpu_relax();
 		local_irq_save(*flags);
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p) && !task_is_waking(p)))
+		if (likely(rq == task_rq(p)))
 			return rq;
 		raw_spin_unlock_irqrestore(&rq->lock, *flags);
 	}
@@ -1229,6 +1230,17 @@ void wake_up_idle_cpu(int cpu)
 	if (!tsk_is_polling(rq->idle))
 		smp_send_reschedule(cpu);
 }
+
+int nohz_ratelimit(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	u64 diff = rq->clock - rq->nohz_stamp;
+
+	rq->nohz_stamp = rq->clock;
+
+	return diff < (NSEC_PER_SEC / HZ) >> 1;
+}
+
 #endif /* CONFIG_NO_HZ */
 
 static u64 sched_avg_period(void)
@@ -1771,8 +1783,6 @@ static void double_rq_lock(struct rq *rq1, struct rq *rq2)
 			raw_spin_lock_nested(&rq1->lock, SINGLE_DEPTH_NESTING);
 		}
 	}
-	update_rq_clock(rq1);
-	update_rq_clock(rq2);
 }
 
 /*
@@ -1803,7 +1813,7 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 }
 #endif
 
-static void calc_load_account_active(struct rq *this_rq);
+static void calc_load_account_idle(struct rq *this_rq);
 static void update_sysctl(void);
 static int get_update_sysctl_factor(void);
 
@@ -1860,62 +1870,43 @@ static void set_load_weight(struct task_struct *p)
 	p->se.load.inv_weight = prio_to_wmult[p->static_prio - MAX_RT_PRIO];
 }
 
-static void update_avg(u64 *avg, u64 sample)
+static void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
 {
-	s64 diff = sample - *avg;
-	*avg += diff >> 3;
-}
-
-static void
-enqueue_task(struct rq *rq, struct task_struct *p, int wakeup, bool head)
-{
-	if (wakeup)
-		p->se.start_runtime = p->se.sum_exec_runtime;
-
+	update_rq_clock(rq);
 	sched_info_queued(p);
-	p->sched_class->enqueue_task(rq, p, wakeup, head);
+	p->sched_class->enqueue_task(rq, p, flags);
 	p->se.on_rq = 1;
 }
 
-static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
+static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
 {
-	if (sleep) {
-		if (p->se.last_wakeup) {
-			update_avg(&p->se.avg_overlap,
-				p->se.sum_exec_runtime - p->se.last_wakeup);
-			p->se.last_wakeup = 0;
-		} else {
-			update_avg(&p->se.avg_wakeup,
-				sysctl_sched_wakeup_granularity);
-		}
-	}
-
+	update_rq_clock(rq);
 	sched_info_dequeued(p);
-	p->sched_class->dequeue_task(rq, p, sleep);
+	p->sched_class->dequeue_task(rq, p, flags);
 	p->se.on_rq = 0;
 }
 
 /*
  * activate_task - move a task to the runqueue.
  */
-static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
+static void activate_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
 
-	enqueue_task(rq, p, wakeup, false);
+	enqueue_task(rq, p, flags);
 	inc_nr_running(rq);
 }
 
 /*
  * deactivate_task - remove a task from the runqueue.
  */
-static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
+static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible++;
 
-	dequeue_task(rq, p, sleep);
+	dequeue_task(rq, p, flags);
 	dec_nr_running(rq);
 }
 
@@ -2044,21 +2035,18 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 	__set_task_cpu(p, new_cpu);
 }
 
-struct migration_req {
-	struct list_head list;
-
+struct migration_arg {
 	struct task_struct *task;
 	int dest_cpu;
-
-	struct completion done;
 };
 
+static int migration_cpu_stop(void *data);
+
 /*
  * The task's runqueue lock must be held.
  * Returns true if you have to wait for migration thread.
  */
-static int
-migrate_task(struct task_struct *p, int dest_cpu, struct migration_req *req)
+static bool migrate_task(struct task_struct *p, int dest_cpu)
 {
 	struct rq *rq = task_rq(p);
 
@@ -2066,15 +2054,7 @@ migrate_task(struct task_struct *p, int dest_cpu, struct migration_req *req)
 	 * If the task is not on a runqueue (and not running), then
 	 * the next wake-up will properly place the task.
 	 */
-	if (!p->se.on_rq && !task_running(rq, p))
-		return 0;
-
-	init_completion(&req->done);
-	req->task = p;
-	req->dest_cpu = dest_cpu;
-	list_add(&req->list, &rq->migration_queue);
-
-	return 1;
+	return p->se.on_rq || task_running(rq, p);
 }
 
 /*
@@ -2175,7 +2155,7 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		 * just go back and repeat.
 		 */
 		rq = task_rq_lock(p, &flags);
-		trace_sched_wait_task(rq, p);
+		trace_sched_wait_task(p);
 		running = task_running(rq, p);
 		on_rq = p->se.on_rq;
 		ncsw = 0;
@@ -2273,6 +2253,9 @@ void task_oncpu_function_call(struct task_struct *p,
 }
 
 #ifdef CONFIG_SMP
+/*
+ * ->cpus_allowed is protected by either TASK_WAKING or rq->lock held.
+ */
 static int select_fallback_rq(int cpu, struct task_struct *p)
 {
 	int dest_cpu;
@@ -2289,12 +2272,8 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 		return dest_cpu;
 
 	/* No more Mr. Nice Guy. */
-	if (dest_cpu >= nr_cpu_ids) {
-		rcu_read_lock();
-		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
-		rcu_read_unlock();
-		dest_cpu = cpumask_any_and(cpu_active_mask, &p->cpus_allowed);
-
+	if (unlikely(dest_cpu >= nr_cpu_ids)) {
+		dest_cpu = cpuset_cpus_allowed_fallback(p);
 		/*
 		 * Don't tell them about moving exiting tasks or
 		 * kernel threads (both mm NULL), since they never
@@ -2311,17 +2290,12 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 }
 
 /*
- * Gets called from 3 sites (exec, fork, wakeup), since it is called without
- * holding rq->lock we need to ensure ->cpus_allowed is stable, this is done
- * by:
- *
- *  exec:           is unstable, retry loop
- *  fork & wake-up: serialize ->cpus_allowed against TASK_WAKING
+ * The caller (fork, wakeup) owns TASK_WAKING, ->cpus_allowed is stable.
  */
 static inline
-int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
+int select_task_rq(struct rq *rq, struct task_struct *p, int sd_flags, int wake_flags)
 {
-	int cpu = p->sched_class->select_task_rq(p, sd_flags, wake_flags);
+	int cpu = p->sched_class->select_task_rq(rq, p, sd_flags, wake_flags);
 
 	/*
 	 * In order not to call set_task_cpu() on a blocking task we need
@@ -2339,6 +2313,12 @@ int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
 
 	return cpu;
 }
+
+static void update_avg(u64 *avg, u64 sample)
+{
+	s64 diff = sample - *avg;
+	*avg += diff >> 3;
+}
 #endif
 
 /***
@@ -2360,16 +2340,13 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 {
 	int cpu, orig_cpu, this_cpu, success = 0;
 	unsigned long flags;
+	unsigned long en_flags = ENQUEUE_WAKEUP;
 	struct rq *rq;
 
-	if (!sched_feat(SYNC_WAKEUPS))
-		wake_flags &= ~WF_SYNC;
-
 	this_cpu = get_cpu();
 
 	smp_wmb();
 	rq = task_rq_lock(p, &flags);
-	update_rq_clock(rq);
 	if (!(p->state & state))
 		goto out;
 
@@ -2389,28 +2366,26 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	 *
 	 * First fix up the nr_uninterruptible count:
 	 */
-	if (task_contributes_to_load(p))
-		rq->nr_uninterruptible--;
+	if (task_contributes_to_load(p)) {
+		if (likely(cpu_online(orig_cpu)))
+			rq->nr_uninterruptible--;
+		else
+			this_rq()->nr_uninterruptible--;
+	}
 	p->state = TASK_WAKING;
 
-	if (p->sched_class->task_waking)
+	if (p->sched_class->task_waking) {
 		p->sched_class->task_waking(rq, p);
+		en_flags |= ENQUEUE_WAKING;
+	}
 
-	__task_rq_unlock(rq);
-
-	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
-	if (cpu != orig_cpu) {
-		/*
-		 * Since we migrate the task without holding any rq->lock,
-		 * we need to be careful with task_rq_lock(), since that
-		 * might end up locking an invalid rq.
-		 */
+	cpu = select_task_rq(rq, p, SD_BALANCE_WAKE, wake_flags);
+	if (cpu != orig_cpu)
 		set_task_cpu(p, cpu);
-	}
+	__task_rq_unlock(rq);
 
 	rq = cpu_rq(cpu);
 	raw_spin_lock(&rq->lock);
-	update_rq_clock(rq);
 
 	/*
 	 * We migrated the task without holding either rq->lock, however
@@ -2438,36 +2413,20 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 
 out_activate:
 #endif /* CONFIG_SMP */
-	schedstat_inc(p, se.nr_wakeups);
+	schedstat_inc(p, se.statistics.nr_wakeups);
 	if (wake_flags & WF_SYNC)
-		schedstat_inc(p, se.nr_wakeups_sync);
+		schedstat_inc(p, se.statistics.nr_wakeups_sync);
 	if (orig_cpu != cpu)
-		schedstat_inc(p, se.nr_wakeups_migrate);
+		schedstat_inc(p, se.statistics.nr_wakeups_migrate);
 	if (cpu == this_cpu)
-		schedstat_inc(p, se.nr_wakeups_local);
+		schedstat_inc(p, se.statistics.nr_wakeups_local);
 	else
-		schedstat_inc(p, se.nr_wakeups_remote);
-	activate_task(rq, p, 1);
+		schedstat_inc(p, se.statistics.nr_wakeups_remote);
+	activate_task(rq, p, en_flags);
 	success = 1;
 
-	/*
-	 * Only attribute actual wakeups done by this task.
-	 */
-	if (!in_interrupt()) {
-		struct sched_entity *se = &current->se;
-		u64 sample = se->sum_exec_runtime;
-
-		if (se->last_wakeup)
-			sample -= se->last_wakeup;
-		else
-			sample -= se->start_runtime;
-		update_avg(&se->avg_wakeup, sample);
-
-		se->last_wakeup = se->sum_exec_runtime;
-	}
-
 out_running:
-	trace_sched_wakeup(rq, p, success);
+	trace_sched_wakeup(p, success);
 	check_preempt_curr(rq, p, wake_flags);
 
 	p->state = TASK_RUNNING;
@@ -2527,42 +2486,9 @@ static void __sched_fork(struct task_struct *p)
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
 	p->se.nr_migrations		= 0;
-	p->se.last_wakeup		= 0;
-	p->se.avg_overlap		= 0;
-	p->se.start_runtime		= 0;
-	p->se.avg_wakeup		= sysctl_sched_wakeup_granularity;
 
 #ifdef CONFIG_SCHEDSTATS
-	p->se.wait_start			= 0;
-	p->se.wait_max				= 0;
-	p->se.wait_count			= 0;
-	p->se.wait_sum				= 0;
-
-	p->se.sleep_start			= 0;
-	p->se.sleep_max				= 0;
-	p->se.sum_sleep_runtime			= 0;
-
-	p->se.block_start			= 0;
-	p->se.block_max				= 0;
-	p->se.exec_max				= 0;
-	p->se.slice_max				= 0;
-
-	p->se.nr_migrations_cold		= 0;
-	p->se.nr_failed_migrations_affine	= 0;
-	p->se.nr_failed_migrations_running	= 0;
-	p->se.nr_failed_migrations_hot		= 0;
-	p->se.nr_forced_migrations		= 0;
-
-	p->se.nr_wakeups			= 0;
-	p->se.nr_wakeups_sync			= 0;
-	p->se.nr_wakeups_migrate		= 0;
-	p->se.nr_wakeups_local			= 0;
-	p->se.nr_wakeups_remote			= 0;
-	p->se.nr_wakeups_affine			= 0;
-	p->se.nr_wakeups_affine_attempts	= 0;
-	p->se.nr_wakeups_passive		= 0;
-	p->se.nr_wakeups_idle			= 0;
-
+	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
 #endif
 
 	INIT_LIST_HEAD(&p->rt.run_list);
@@ -2583,11 +2509,11 @@ void sched_fork(struct task_struct *p, int clone_flags)
 
 	__sched_fork(p);
 	/*
-	 * We mark the process as waking here. This guarantees that
+	 * We mark the process as running here. This guarantees that
 	 * nobody will actually run it, and a signal or other external
 	 * event cannot wake it up and insert it on the runqueue either.
 	 */
-	p->state = TASK_WAKING;
+	p->state = TASK_RUNNING;
 
 	/*
 	 * Revert to default priority/policy on fork if requested.
@@ -2654,31 +2580,27 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	int cpu __maybe_unused = get_cpu();
 
 #ifdef CONFIG_SMP
+	rq = task_rq_lock(p, &flags);
+	p->state = TASK_WAKING;
+
 	/*
 	 * Fork balancing, do it here and not earlier because:
 	 *  - cpus_allowed can change in the fork path
 	 *  - any previously selected cpu might disappear through hotplug
 	 *
-	 * We still have TASK_WAKING but PF_STARTING is gone now, meaning
-	 * ->cpus_allowed is stable, we have preemption disabled, meaning
-	 * cpu_online_mask is stable.
+	 * We set TASK_WAKING so that select_task_rq() can drop rq->lock
+	 * without people poking at ->cpus_allowed.
 	 */
-	cpu = select_task_rq(p, SD_BALANCE_FORK, 0);
+	cpu = select_task_rq(rq, p, SD_BALANCE_FORK, 0);
 	set_task_cpu(p, cpu);
-#endif
 
-	/*
-	 * Since the task is not on the rq and we still have TASK_WAKING set
-	 * nobody else will migrate this task.
-	 */
-	rq = cpu_rq(cpu);
-	raw_spin_lock_irqsave(&rq->lock, flags);
-
-	BUG_ON(p->state != TASK_WAKING);
 	p->state = TASK_RUNNING;
-	update_rq_clock(rq);
+	task_rq_unlock(rq, &flags);
+#endif
+
+	rq = task_rq_lock(p, &flags);
 	activate_task(rq, p, 0);
-	trace_sched_wakeup_new(rq, p, 1);
+	trace_sched_wakeup_new(p, 1);
 	check_preempt_curr(rq, p, WF_FORK);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_woken)
@@ -2898,7 +2820,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	struct mm_struct *mm, *oldmm;
 
 	prepare_task_switch(rq, prev, next);
-	trace_sched_switch(rq, prev, next);
+	trace_sched_switch(prev, next);
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*
@@ -3015,6 +2937,61 @@ static unsigned long calc_load_update;
 unsigned long avenrun[3];
 EXPORT_SYMBOL(avenrun);
 
+static long calc_load_fold_active(struct rq *this_rq)
+{
+	long nr_active, delta = 0;
+
+	nr_active = this_rq->nr_running;
+	nr_active += (long) this_rq->nr_uninterruptible;
+
+	if (nr_active != this_rq->calc_load_active) {
+		delta = nr_active - this_rq->calc_load_active;
+		this_rq->calc_load_active = nr_active;
+	}
+
+	return delta;
+}
+
+#ifdef CONFIG_NO_HZ
+/*
+ * For NO_HZ we delay the active fold to the next LOAD_FREQ update.
+ *
+ * When making the ILB scale, we should try to pull this in as well.
+ */
+static atomic_long_t calc_load_tasks_idle;
+
+static void calc_load_account_idle(struct rq *this_rq)
+{
+	long delta;
+
+	delta = calc_load_fold_active(this_rq);
+	if (delta)
+		atomic_long_add(delta, &calc_load_tasks_idle);
+}
+
+static long calc_load_fold_idle(void)
+{
+	long delta = 0;
+
+	/*
+	 * Its got a race, we don't care...
+	 */
+	if (atomic_long_read(&calc_load_tasks_idle))
+		delta = atomic_long_xchg(&calc_load_tasks_idle, 0);
+
+	return delta;
+}
+#else
+static void calc_load_account_idle(struct rq *this_rq)
+{
+}
+
+static inline long calc_load_fold_idle(void)
+{
+	return 0;
+}
+#endif
+
 /**
  * get_avenrun - get the load average array
  * @loads:	pointer to dest load array
@@ -3061,20 +3038,22 @@ void calc_global_load(void)
 }
 
 /*
- * Either called from update_cpu_load() or from a cpu going idle
+ * Called from update_cpu_load() to periodically update this CPU's
+ * active count.
  */
 static void calc_load_account_active(struct rq *this_rq)
 {
-	long nr_active, delta;
+	long delta;
 
-	nr_active = this_rq->nr_running;
-	nr_active += (long) this_rq->nr_uninterruptible;
+	if (time_before(jiffies, this_rq->calc_load_update))
+		return;
 
-	if (nr_active != this_rq->calc_load_active) {
-		delta = nr_active - this_rq->calc_load_active;
-		this_rq->calc_load_active = nr_active;
+	delta  = calc_load_fold_active(this_rq);
+	delta += calc_load_fold_idle();
+	if (delta)
 		atomic_long_add(delta, &calc_load_tasks);
-	}
+
+	this_rq->calc_load_update += LOAD_FREQ;
 }
 
 /*
@@ -3106,10 +3085,7 @@ static void update_cpu_load(struct rq *this_rq)
 		this_rq->cpu_load[i] = (old_load*(scale-1) + new_load) >> i;
 	}
 
-	if (time_after_eq(jiffies, this_rq->calc_load_update)) {
-		this_rq->calc_load_update += LOAD_FREQ;
-		calc_load_account_active(this_rq);
-	}
+	calc_load_account_active(this_rq);
 }
 
 #ifdef CONFIG_SMP
@@ -3121,44 +3097,27 @@ static void update_cpu_load(struct rq *this_rq)
 void sched_exec(void)
 {
 	struct task_struct *p = current;
-	struct migration_req req;
-	int dest_cpu, this_cpu;
 	unsigned long flags;
 	struct rq *rq;
-
-again:
-	this_cpu = get_cpu();
-	dest_cpu = select_task_rq(p, SD_BALANCE_EXEC, 0);
-	if (dest_cpu == this_cpu) {
-		put_cpu();
-		return;
-	}
+	int dest_cpu;
 
 	rq = task_rq_lock(p, &flags);
-	put_cpu();
+	dest_cpu = p->sched_class->select_task_rq(rq, p, SD_BALANCE_EXEC, 0);
+	if (dest_cpu == smp_processor_id())
+		goto unlock;
 
 	/*
 	 * select_task_rq() can race against ->cpus_allowed
 	 */
-	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed)
-	    || unlikely(!cpu_active(dest_cpu))) {
-		task_rq_unlock(rq, &flags);
-		goto again;
-	}
+	if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed) &&
+	    likely(cpu_active(dest_cpu)) && migrate_task(p, dest_cpu)) {
+		struct migration_arg arg = { p, dest_cpu };
 
-	/* force the process onto the specified CPU */
-	if (migrate_task(p, dest_cpu, &req)) {
-		/* Need to wait for migration thread (might exit: take ref). */
-		struct task_struct *mt = rq->migration_thread;
-
-		get_task_struct(mt);
 		task_rq_unlock(rq, &flags);
-		wake_up_process(mt);
-		put_task_struct(mt);
-		wait_for_completion(&req.done);
-
+		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
 		return;
 	}
+unlock:
 	task_rq_unlock(rq, &flags);
 }
 
@@ -3630,23 +3589,9 @@ static inline void schedule_debug(struct task_struct *prev)
 
 static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
-	if (prev->state == TASK_RUNNING) {
-		u64 runtime = prev->se.sum_exec_runtime;
-
-		runtime -= prev->se.prev_sum_exec_runtime;
-		runtime = min_t(u64, runtime, 2*sysctl_sched_migration_cost);
-
-		/*
-		 * In order to avoid avg_overlap growing stale when we are
-		 * indeed overlapping and hence not getting put to sleep, grow
-		 * the avg_overlap on preemption.
-		 *
-		 * We use the average preemption runtime because that
-		 * correlates to the amount of cache footprint a task can
-		 * build up.
-		 */
-		update_avg(&prev->se.avg_overlap, runtime);
-	}
+	if (prev->se.on_rq)
+		update_rq_clock(rq);
+	rq->skip_clock_update = 0;
 	prev->sched_class->put_prev_task(rq, prev);
 }
 
@@ -3709,14 +3654,13 @@ need_resched_nonpreemptible:
 		hrtick_clear(rq);
 
 	raw_spin_lock_irq(&rq->lock);
-	update_rq_clock(rq);
 	clear_tsk_need_resched(prev);
 
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
 		if (unlikely(signal_pending_state(prev->state, prev)))
 			prev->state = TASK_RUNNING;
 		else
-			deactivate_task(rq, prev, 1);
+			deactivate_task(rq, prev, DEQUEUE_SLEEP);
 		switch_count = &prev->nvcsw;
 	}
 
@@ -4039,8 +3983,7 @@ do_wait_for_common(struct completion *x, long timeout, int state)
 	if (!x->done) {
 		DECLARE_WAITQUEUE(wait, current);
 
-		wait.flags |= WQ_FLAG_EXCLUSIVE;
-		__add_wait_queue_tail(&x->wait, &wait);
+		__add_wait_queue_tail_exclusive(&x->wait, &wait);
 		do {
 			if (signal_pending_state(state, current)) {
 				timeout = -ERESTARTSYS;
@@ -4266,7 +4209,6 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	BUG_ON(prio < 0 || prio > MAX_PRIO);
 
 	rq = task_rq_lock(p, &flags);
-	update_rq_clock(rq);
 
 	oldprio = p->prio;
 	prev_class = p->sched_class;
@@ -4287,7 +4229,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	if (running)
 		p->sched_class->set_curr_task(rq);
 	if (on_rq) {
-		enqueue_task(rq, p, 0, oldprio < prio);
+		enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);
 
 		check_class_changed(rq, p, prev_class, oldprio, running);
 	}
@@ -4309,7 +4251,6 @@ void set_user_nice(struct task_struct *p, long nice)
 	 * the task might be in the middle of scheduling on another CPU.
 	 */
 	rq = task_rq_lock(p, &flags);
-	update_rq_clock(rq);
 	/*
 	 * The RT priorities are set via sched_setscheduler(), but we still
 	 * allow the 'normal' nice value to be set - but as expected
@@ -4331,7 +4272,7 @@ void set_user_nice(struct task_struct *p, long nice)
 	delta = p->prio - old_prio;
 
 	if (on_rq) {
-		enqueue_task(rq, p, 0, false);
+		enqueue_task(rq, p, 0);
 		/*
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:
@@ -4592,7 +4533,6 @@ recheck:
 		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 		goto recheck;
 	}
-	update_rq_clock(rq);
 	on_rq = p->se.on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
@@ -5329,17 +5269,15 @@ static inline void sched_init_granularity(void)
 /*
  * This is how migration works:
  *
- * 1) we queue a struct migration_req structure in the source CPU's
- *    runqueue and wake up that CPU's migration thread.
- * 2) we down() the locked semaphore => thread blocks.
- * 3) migration thread wakes up (implicitly it forces the migrated
- *    thread off the CPU)
- * 4) it gets the migration request and checks whether the migrated
- *    task is still in the wrong runqueue.
- * 5) if it's in the wrong runqueue then the migration thread removes
+ * 1) we invoke migration_cpu_stop() on the target CPU using
+ *    stop_one_cpu().
+ * 2) stopper starts to run (implicitly forcing the migrated thread
+ *    off the CPU)
+ * 3) it checks whether the migrated task is still in the wrong runqueue.
+ * 4) if it's in the wrong runqueue then the migration thread removes
  *    it and puts it into the right queue.
- * 6) migration thread up()s the semaphore.
- * 7) we wake up and the migration is done.
+ * 5) stopper completes and stop_one_cpu() returns and the migration
+ *    is done.
  */
 
 /*
@@ -5353,12 +5291,23 @@ static inline void sched_init_granularity(void)
  */
 int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 {
-	struct migration_req req;
 	unsigned long flags;
 	struct rq *rq;
+	unsigned int dest_cpu;
 	int ret = 0;
 
+	/*
+	 * Serialize against TASK_WAKING so that ttwu() and wunt() can
+	 * drop the rq->lock and still rely on ->cpus_allowed.
+	 */
+again:
+	while (task_is_waking(p))
+		cpu_relax();
 	rq = task_rq_lock(p, &flags);
+	if (task_is_waking(p)) {
+		task_rq_unlock(rq, &flags);
+		goto again;
+	}
 
 	if (!cpumask_intersects(new_mask, cpu_active_mask)) {
 		ret = -EINVAL;
@@ -5382,15 +5331,12 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 	if (cpumask_test_cpu(task_cpu(p), new_mask))
 		goto out;
 
-	if (migrate_task(p, cpumask_any_and(cpu_active_mask, new_mask), &req)) {
+	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
+	if (migrate_task(p, dest_cpu)) {
+		struct migration_arg arg = { p, dest_cpu };
 		/* Need help from migration thread: drop lock and wait. */
-		struct task_struct *mt = rq->migration_thread;
-
-		get_task_struct(mt);
 		task_rq_unlock(rq, &flags);
-		wake_up_process(mt);
-		put_task_struct(mt);
-		wait_for_completion(&req.done);
+		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
 		tlb_migrate_finish(p->mm);
 		return 0;
 	}
@@ -5448,98 +5394,49 @@ fail:
 	return ret;
 }
 
-#define RCU_MIGRATION_IDLE	0
-#define RCU_MIGRATION_NEED_QS	1
-#define RCU_MIGRATION_GOT_QS	2
-#define RCU_MIGRATION_MUST_SYNC	3
-
 /*
- * migration_thread - this is a highprio system thread that performs
- * thread migration by bumping thread off CPU then 'pushing' onto
- * another runqueue.
+ * migration_cpu_stop - this will be executed by a highprio stopper thread
+ * and performs thread migration by bumping thread off CPU then
+ * 'pushing' onto another runqueue.
  */
-static int migration_thread(void *data)
+static int migration_cpu_stop(void *data)
 {
-	int badcpu;
-	int cpu = (long)data;
-	struct rq *rq;
-
-	rq = cpu_rq(cpu);
-	BUG_ON(rq->migration_thread != current);
-
-	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop()) {
-		struct migration_req *req;
-		struct list_head *head;
-
-		raw_spin_lock_irq(&rq->lock);
-
-		if (cpu_is_offline(cpu)) {
-			raw_spin_unlock_irq(&rq->lock);
-			break;
-		}
-
-		if (rq->active_balance) {
-			active_load_balance(rq, cpu);
-			rq->active_balance = 0;
-		}
-
-		head = &rq->migration_queue;
-
-		if (list_empty(head)) {
-			raw_spin_unlock_irq(&rq->lock);
-			schedule();
-			set_current_state(TASK_INTERRUPTIBLE);
-			continue;
-		}
-		req = list_entry(head->next, struct migration_req, list);
-		list_del_init(head->next);
-
-		if (req->task != NULL) {
-			raw_spin_unlock(&rq->lock);
-			__migrate_task(req->task, cpu, req->dest_cpu);
-		} else if (likely(cpu == (badcpu = smp_processor_id()))) {
-			req->dest_cpu = RCU_MIGRATION_GOT_QS;
-			raw_spin_unlock(&rq->lock);
-		} else {
-			req->dest_cpu = RCU_MIGRATION_MUST_SYNC;
-			raw_spin_unlock(&rq->lock);
-			WARN_ONCE(1, "migration_thread() on CPU %d, expected %d\n", badcpu, cpu);
-		}
-		local_irq_enable();
-
-		complete(&req->done);
-	}
-	__set_current_state(TASK_RUNNING);
-
-	return 0;
-}
-
-#ifdef CONFIG_HOTPLUG_CPU
-
-static int __migrate_task_irq(struct task_struct *p, int src_cpu, int dest_cpu)
-{
-	int ret;
+	struct migration_arg *arg = data;
 
+	/*
+	 * The original target cpu might have gone down and we might
+	 * be on another cpu but it doesn't matter.
+	 */
 	local_irq_disable();
-	ret = __migrate_task(p, src_cpu, dest_cpu);
+	__migrate_task(arg->task, raw_smp_processor_id(), arg->dest_cpu);
 	local_irq_enable();
-	return ret;
+	return 0;
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
 /*
  * Figure out where task on dead CPU should go, use force if necessary.
  */
-static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
+void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
-	int dest_cpu;
+	struct rq *rq = cpu_rq(dead_cpu);
+	int needs_cpu, uninitialized_var(dest_cpu);
+	unsigned long flags;
 
-again:
-	dest_cpu = select_fallback_rq(dead_cpu, p);
+	local_irq_save(flags);
 
-	/* It can have affinity changed while we were choosing. */
-	if (unlikely(!__migrate_task_irq(p, dead_cpu, dest_cpu)))
-		goto again;
+	raw_spin_lock(&rq->lock);
+	needs_cpu = (task_cpu(p) == dead_cpu) && (p->state != TASK_WAKING);
+	if (needs_cpu)
+		dest_cpu = select_fallback_rq(dead_cpu, p);
+	raw_spin_unlock(&rq->lock);
+	/*
+	 * It can only fail if we race with set_cpus_allowed(),
+	 * in the racer should migrate the task anyway.
+	 */
+	if (needs_cpu)
+		__migrate_task(p, dead_cpu, dest_cpu);
+	local_irq_restore(flags);
 }
 
 /*
@@ -5603,7 +5500,6 @@ void sched_idle_next(void)
 
 	__setscheduler(rq, p, SCHED_FIFO, MAX_RT_PRIO-1);
 
-	update_rq_clock(rq);
 	activate_task(rq, p, 0);
 
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
@@ -5658,7 +5554,6 @@ static void migrate_dead_tasks(unsigned int dead_cpu)
 	for ( ; ; ) {
 		if (!rq->nr_running)
 			break;
-		update_rq_clock(rq);
 		next = pick_next_task(rq);
 		if (!next)
 			break;
@@ -5881,35 +5776,20 @@ static void set_rq_offline(struct rq *rq)
 static int __cpuinit
 migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
-	struct task_struct *p;
 	int cpu = (long)hcpu;
 	unsigned long flags;
-	struct rq *rq;
+	struct rq *rq = cpu_rq(cpu);
 
 	switch (action) {
 
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		p = kthread_create(migration_thread, hcpu, "migration/%d", cpu);
-		if (IS_ERR(p))
-			return NOTIFY_BAD;
-		kthread_bind(p, cpu);
-		/* Must be high prio: stop_machine expects to yield to it. */
-		rq = task_rq_lock(p, &flags);
-		__setscheduler(rq, p, SCHED_FIFO, MAX_RT_PRIO-1);
-		task_rq_unlock(rq, &flags);
-		get_task_struct(p);
-		cpu_rq(cpu)->migration_thread = p;
 		rq->calc_load_update = calc_load_update;
 		break;
 
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		/* Strictly unnecessary, as first user will wake it. */
-		wake_up_process(cpu_rq(cpu)->migration_thread);
-
 		/* Update our root-domain */
-		rq = cpu_rq(cpu);
 		raw_spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
 			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
@@ -5920,61 +5800,24 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-		if (!cpu_rq(cpu)->migration_thread)
-			break;
-		/* Unbind it from offline cpu so it can run. Fall thru. */
-		kthread_bind(cpu_rq(cpu)->migration_thread,
-			     cpumask_any(cpu_online_mask));
-		kthread_stop(cpu_rq(cpu)->migration_thread);
-		put_task_struct(cpu_rq(cpu)->migration_thread);
-		cpu_rq(cpu)->migration_thread = NULL;
-		break;
-
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		cpuset_lock(); /* around calls to cpuset_cpus_allowed_lock() */
 		migrate_live_tasks(cpu);
-		rq = cpu_rq(cpu);
-		kthread_stop(rq->migration_thread);
-		put_task_struct(rq->migration_thread);
-		rq->migration_thread = NULL;
 		/* Idle task back to normal (off runqueue, low prio) */
 		raw_spin_lock_irq(&rq->lock);
-		update_rq_clock(rq);
 		deactivate_task(rq, rq->idle, 0);
 		__setscheduler(rq, rq->idle, SCHED_NORMAL, 0);
 		rq->idle->sched_class = &idle_sched_class;
 		migrate_dead_tasks(cpu);
 		raw_spin_unlock_irq(&rq->lock);
-		cpuset_unlock();
 		migrate_nr_uninterruptible(rq);
 		BUG_ON(rq->nr_running != 0);
 		calc_global_load_remove(rq);
-		/*
-		 * No need to migrate the tasks: it was best-effort if
-		 * they didn't take sched_hotcpu_mutex. Just wake up
-		 * the requestors.
-		 */
-		raw_spin_lock_irq(&rq->lock);
-		while (!list_empty(&rq->migration_queue)) {
-			struct migration_req *req;
-
-			req = list_entry(rq->migration_queue.next,
-					 struct migration_req, list);
-			list_del_init(&req->list);
-			raw_spin_unlock_irq(&rq->lock);
-			complete(&req->done);
-			raw_spin_lock_irq(&rq->lock);
-		}
-		raw_spin_unlock_irq(&rq->lock);
 		break;
 
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
 		/* Update our root-domain */
-		rq = cpu_rq(cpu);
 		raw_spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
 			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
@@ -6305,6 +6148,9 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	struct sched_domain *tmp;
 
+	for (tmp = sd; tmp; tmp = tmp->parent)
+		tmp->span_weight = cpumask_weight(sched_domain_span(tmp));
+
 	/* Remove the sched domains which do not contribute to scheduling. */
 	for (tmp = sd; tmp; ) {
 		struct sched_domain *parent = tmp->parent;
@@ -7788,10 +7634,8 @@ void __init sched_init(void)
 		rq->push_cpu = 0;
 		rq->cpu = i;
 		rq->online = 0;
-		rq->migration_thread = NULL;
 		rq->idle_stamp = 0;
 		rq->avg_idle = 2*sysctl_sched_migration_cost;
-		INIT_LIST_HEAD(&rq->migration_queue);
 		rq_attach_root(rq, &def_root_domain);
 #endif
 		init_rq_hrtick(rq);
@@ -7892,7 +7736,6 @@ static void normalize_task(struct rq *rq, struct task_struct *p)
 {
 	int on_rq;
 
-	update_rq_clock(rq);
 	on_rq = p->se.on_rq;
 	if (on_rq)
 		deactivate_task(rq, p, 0);
@@ -7919,9 +7762,9 @@ void normalize_rt_tasks(void)
 
 		p->se.exec_start		= 0;
 #ifdef CONFIG_SCHEDSTATS
-		p->se.wait_start		= 0;
-		p->se.sleep_start		= 0;
-		p->se.block_start		= 0;
+		p->se.statistics.wait_start	= 0;
+		p->se.statistics.sleep_start	= 0;
+		p->se.statistics.block_start	= 0;
 #endif
 
 		if (!rt_task(p)) {
@@ -8254,8 +8097,6 @@ void sched_move_task(struct task_struct *tsk)
 
 	rq = task_rq_lock(tsk, &flags);
 
-	update_rq_clock(rq);
-
 	running = task_current(rq, tsk);
 	on_rq = tsk->se.on_rq;
 
@@ -8274,7 +8115,7 @@ void sched_move_task(struct task_struct *tsk)
 	if (unlikely(running))
 		tsk->sched_class->set_curr_task(rq);
 	if (on_rq)
-		enqueue_task(rq, tsk, 0, false);
+		enqueue_task(rq, tsk, 0);
 
 	task_rq_unlock(rq, &flags);
 }
@@ -9088,43 +8929,32 @@ struct cgroup_subsys cpuacct_subsys = {
 
 #ifndef CONFIG_SMP
 
-int rcu_expedited_torture_stats(char *page)
-{
-	return 0;
-}
-EXPORT_SYMBOL_GPL(rcu_expedited_torture_stats);
-
 void synchronize_sched_expedited(void)
 {
+	barrier();
 }
 EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
 
 #else /* #ifndef CONFIG_SMP */
 
-static DEFINE_PER_CPU(struct migration_req, rcu_migration_req);
-static DEFINE_MUTEX(rcu_sched_expedited_mutex);
-
-#define RCU_EXPEDITED_STATE_POST -2
-#define RCU_EXPEDITED_STATE_IDLE -1
-
-static int rcu_expedited_state = RCU_EXPEDITED_STATE_IDLE;
+static atomic_t synchronize_sched_expedited_count = ATOMIC_INIT(0);
 
-int rcu_expedited_torture_stats(char *page)
+static int synchronize_sched_expedited_cpu_stop(void *data)
 {
-	int cnt = 0;
-	int cpu;
-
-	cnt += sprintf(&page[cnt], "state: %d /", rcu_expedited_state);
-	for_each_online_cpu(cpu) {
-		 cnt += sprintf(&page[cnt], " %d:%d",
-				cpu, per_cpu(rcu_migration_req, cpu).dest_cpu);
-	}
-	cnt += sprintf(&page[cnt], "\n");
-	return cnt;
+	/*
+	 * There must be a full memory barrier on each affected CPU
+	 * between the time that try_stop_cpus() is called and the
+	 * time that it returns.
+	 *
+	 * In the current initial implementation of cpu_stop, the
+	 * above condition is already met when the control reaches
+	 * this point and the following smp_mb() is not strictly
+	 * necessary.  Do smp_mb() anyway for documentation and
+	 * robustness against future implementation changes.
+	 */
+	smp_mb(); /* See above comment block. */
+	return 0;
 }
-EXPORT_SYMBOL_GPL(rcu_expedited_torture_stats);
-
-static long synchronize_sched_expedited_count;
 
 /*
  * Wait for an rcu-sched grace period to elapse, but use "big hammer"
@@ -9138,18 +8968,14 @@ static long synchronize_sched_expedited_count;
  */
 void synchronize_sched_expedited(void)
 {
-	int cpu;
-	unsigned long flags;
-	bool need_full_sync = 0;
-	struct rq *rq;
-	struct migration_req *req;
-	long snap;
-	int trycount = 0;
+	int snap, trycount = 0;
 
 	smp_mb();  /* ensure prior mod happens before capturing snap. */
-	snap = ACCESS_ONCE(synchronize_sched_expedited_count) + 1;
+	snap = atomic_read(&synchronize_sched_expedited_count) + 1;
 	get_online_cpus();
-	while (!mutex_trylock(&rcu_sched_expedited_mutex)) {
+	while (try_stop_cpus(cpu_online_mask,
+			     synchronize_sched_expedited_cpu_stop,
+			     NULL) == -EAGAIN) {
 		put_online_cpus();
 		if (trycount++ < 10)
 			udelay(trycount * num_online_cpus());
@@ -9157,41 +8983,15 @@ void synchronize_sched_expedited(void)
 			synchronize_sched();
 			return;
 		}
-		if (ACCESS_ONCE(synchronize_sched_expedited_count) - snap > 0) {
+		if (atomic_read(&synchronize_sched_expedited_count) - snap > 0) {
 			smp_mb(); /* ensure test happens before caller kfree */
 			return;
 		}
 		get_online_cpus();
 	}
-	rcu_expedited_state = RCU_EXPEDITED_STATE_POST;
-	for_each_online_cpu(cpu) {
-		rq = cpu_rq(cpu);
-		req = &per_cpu(rcu_migration_req, cpu);
-		init_completion(&req->done);
-		req->task = NULL;
-		req->dest_cpu = RCU_MIGRATION_NEED_QS;
-		raw_spin_lock_irqsave(&rq->lock, flags);
-		list_add(&req->list, &rq->migration_queue);
-		raw_spin_unlock_irqrestore(&rq->lock, flags);
-		wake_up_process(rq->migration_thread);
-	}
-	for_each_online_cpu(cpu) {
-		rcu_expedited_state = cpu;
-		req = &per_cpu(rcu_migration_req, cpu);
-		rq = cpu_rq(cpu);
-		wait_for_completion(&req->done);
-		raw_spin_lock_irqsave(&rq->lock, flags);
-		if (unlikely(req->dest_cpu == RCU_MIGRATION_MUST_SYNC))
-			need_full_sync = 1;
-		req->dest_cpu = RCU_MIGRATION_IDLE;
-		raw_spin_unlock_irqrestore(&rq->lock, flags);
-	}
-	rcu_expedited_state = RCU_EXPEDITED_STATE_IDLE;
-	synchronize_sched_expedited_count++;
-	mutex_unlock(&rcu_sched_expedited_mutex);
+	atomic_inc(&synchronize_sched_expedited_count);
+	smp_mb__after_atomic_inc(); /* ensure post-GP actions seen after GP. */
 	put_online_cpus();
-	if (need_full_sync)
-		synchronize_sched();
 }
 EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
 
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 9b49db1..9cf1baf 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -70,16 +70,16 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu,
 	PN(se->vruntime);
 	PN(se->sum_exec_runtime);
 #ifdef CONFIG_SCHEDSTATS
-	PN(se->wait_start);
-	PN(se->sleep_start);
-	PN(se->block_start);
-	PN(se->sleep_max);
-	PN(se->block_max);
-	PN(se->exec_max);
-	PN(se->slice_max);
-	PN(se->wait_max);
-	PN(se->wait_sum);
-	P(se->wait_count);
+	PN(se->statistics.wait_start);
+	PN(se->statistics.sleep_start);
+	PN(se->statistics.block_start);
+	PN(se->statistics.sleep_max);
+	PN(se->statistics.block_max);
+	PN(se->statistics.exec_max);
+	PN(se->statistics.slice_max);
+	PN(se->statistics.wait_max);
+	PN(se->statistics.wait_sum);
+	P(se->statistics.wait_count);
 #endif
 	P(se->load.weight);
 #undef PN
@@ -104,7 +104,7 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 	SEQ_printf(m, "%9Ld.%06ld %9Ld.%06ld %9Ld.%06ld",
 		SPLIT_NS(p->se.vruntime),
 		SPLIT_NS(p->se.sum_exec_runtime),
-		SPLIT_NS(p->se.sum_sleep_runtime));
+		SPLIT_NS(p->se.statistics.sum_sleep_runtime));
 #else
 	SEQ_printf(m, "%15Ld %15Ld %15Ld.%06ld %15Ld.%06ld %15Ld.%06ld",
 		0LL, 0LL, 0LL, 0L, 0LL, 0L, 0LL, 0L);
@@ -173,11 +173,6 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	task_group_path(tg, path, sizeof(path));
 
 	SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, path);
-#elif defined(CONFIG_USER_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)
-	{
-		uid_t uid = cfs_rq->tg->uid;
-		SEQ_printf(m, "\ncfs_rq[%d] for UID: %u\n", cpu, uid);
-	}
 #else
 	SEQ_printf(m, "\ncfs_rq[%d]:\n", cpu);
 #endif
@@ -407,40 +402,38 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	PN(se.exec_start);
 	PN(se.vruntime);
 	PN(se.sum_exec_runtime);
-	PN(se.avg_overlap);
-	PN(se.avg_wakeup);
 
 	nr_switches = p->nvcsw + p->nivcsw;
 
 #ifdef CONFIG_SCHEDSTATS
-	PN(se.wait_start);
-	PN(se.sleep_start);
-	PN(se.block_start);
-	PN(se.sleep_max);
-	PN(se.block_max);
-	PN(se.exec_max);
-	PN(se.slice_max);
-	PN(se.wait_max);
-	PN(se.wait_sum);
-	P(se.wait_count);
-	PN(se.iowait_sum);
-	P(se.iowait_count);
+	PN(se.statistics.wait_start);
+	PN(se.statistics.sleep_start);
+	PN(se.statistics.block_start);
+	PN(se.statistics.sleep_max);
+	PN(se.statistics.block_max);
+	PN(se.statistics.exec_max);
+	PN(se.statistics.slice_max);
+	PN(se.statistics.wait_max);
+	PN(se.statistics.wait_sum);
+	P(se.statistics.wait_count);
+	PN(se.statistics.iowait_sum);
+	P(se.statistics.iowait_count);
 	P(sched_info.bkl_count);
 	P(se.nr_migrations);
-	P(se.nr_migrations_cold);
-	P(se.nr_failed_migrations_affine);
-	P(se.nr_failed_migrations_running);
-	P(se.nr_failed_migrations_hot);
-	P(se.nr_forced_migrations);
-	P(se.nr_wakeups);
-	P(se.nr_wakeups_sync);
-	P(se.nr_wakeups_migrate);
-	P(se.nr_wakeups_local);
-	P(se.nr_wakeups_remote);
-	P(se.nr_wakeups_affine);
-	P(se.nr_wakeups_affine_attempts);
-	P(se.nr_wakeups_passive);
-	P(se.nr_wakeups_idle);
+	P(se.statistics.nr_migrations_cold);
+	P(se.statistics.nr_failed_migrations_affine);
+	P(se.statistics.nr_failed_migrations_running);
+	P(se.statistics.nr_failed_migrations_hot);
+	P(se.statistics.nr_forced_migrations);
+	P(se.statistics.nr_wakeups);
+	P(se.statistics.nr_wakeups_sync);
+	P(se.statistics.nr_wakeups_migrate);
+	P(se.statistics.nr_wakeups_local);
+	P(se.statistics.nr_wakeups_remote);
+	P(se.statistics.nr_wakeups_affine);
+	P(se.statistics.nr_wakeups_affine_attempts);
+	P(se.statistics.nr_wakeups_passive);
+	P(se.statistics.nr_wakeups_idle);
 
 	{
 		u64 avg_atom, avg_per_cpu;
@@ -491,31 +484,6 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 void proc_sched_set_task(struct task_struct *p)
 {
 #ifdef CONFIG_SCHEDSTATS
-	p->se.wait_max				= 0;
-	p->se.wait_sum				= 0;
-	p->se.wait_count			= 0;
-	p->se.iowait_sum			= 0;
-	p->se.iowait_count			= 0;
-	p->se.sleep_max				= 0;
-	p->se.sum_sleep_runtime			= 0;
-	p->se.block_max				= 0;
-	p->se.exec_max				= 0;
-	p->se.slice_max				= 0;
-	p->se.nr_migrations			= 0;
-	p->se.nr_migrations_cold		= 0;
-	p->se.nr_failed_migrations_affine	= 0;
-	p->se.nr_failed_migrations_running	= 0;
-	p->se.nr_failed_migrations_hot		= 0;
-	p->se.nr_forced_migrations		= 0;
-	p->se.nr_wakeups			= 0;
-	p->se.nr_wakeups_sync			= 0;
-	p->se.nr_wakeups_migrate		= 0;
-	p->se.nr_wakeups_local			= 0;
-	p->se.nr_wakeups_remote			= 0;
-	p->se.nr_wakeups_affine			= 0;
-	p->se.nr_wakeups_affine_attempts	= 0;
-	p->se.nr_wakeups_passive		= 0;
-	p->se.nr_wakeups_idle			= 0;
-	p->sched_info.bkl_count			= 0;
+	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
 #endif
 }
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5a5ea2c..217e4a9 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -35,8 +35,8 @@
  * (to see the precise effective timeslice length of your workload,
  *  run vmstat and monitor the context-switches (cs) field)
  */
-unsigned int sysctl_sched_latency = 5000000ULL;
-unsigned int normalized_sysctl_sched_latency = 5000000ULL;
+unsigned int sysctl_sched_latency = 6000000ULL;
+unsigned int normalized_sysctl_sched_latency = 6000000ULL;
 
 /*
  * The initial- and re-scaling of tunables is configurable
@@ -52,15 +52,15 @@ enum sched_tunable_scaling sysctl_sched_tunable_scaling
 
 /*
  * Minimal preemption granularity for CPU-bound tasks:
- * (default: 1 msec * (1 + ilog(ncpus)), units: nanoseconds)
+ * (default: 2 msec * (1 + ilog(ncpus)), units: nanoseconds)
  */
-unsigned int sysctl_sched_min_granularity = 1000000ULL;
-unsigned int normalized_sysctl_sched_min_granularity = 1000000ULL;
+unsigned int sysctl_sched_min_granularity = 2000000ULL;
+unsigned int normalized_sysctl_sched_min_granularity = 2000000ULL;
 
 /*
  * is kept at sysctl_sched_latency / sysctl_sched_min_granularity
  */
-static unsigned int sched_nr_latency = 5;
+static unsigned int sched_nr_latency = 3;
 
 /*
  * After fork, child runs first. If set to 0 (default) then
@@ -505,7 +505,8 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 {
 	unsigned long delta_exec_weighted;
 
-	schedstat_set(curr->exec_max, max((u64)delta_exec, curr->exec_max));
+	schedstat_set(curr->statistics.exec_max,
+		      max((u64)delta_exec, curr->statistics.exec_max));
 
 	curr->sum_exec_runtime += delta_exec;
 	schedstat_add(cfs_rq, exec_clock, delta_exec);
@@ -548,7 +549,7 @@ static void update_curr(struct cfs_rq *cfs_rq)
 static inline void
 update_stats_wait_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	schedstat_set(se->wait_start, rq_of(cfs_rq)->clock);
+	schedstat_set(se->statistics.wait_start, rq_of(cfs_rq)->clock);
 }
 
 /*
@@ -567,18 +568,18 @@ static void update_stats_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 static void
 update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	schedstat_set(se->wait_max, max(se->wait_max,
-			rq_of(cfs_rq)->clock - se->wait_start));
-	schedstat_set(se->wait_count, se->wait_count + 1);
-	schedstat_set(se->wait_sum, se->wait_sum +
-			rq_of(cfs_rq)->clock - se->wait_start);
+	schedstat_set(se->statistics.wait_max, max(se->statistics.wait_max,
+			rq_of(cfs_rq)->clock - se->statistics.wait_start));
+	schedstat_set(se->statistics.wait_count, se->statistics.wait_count + 1);
+	schedstat_set(se->statistics.wait_sum, se->statistics.wait_sum +
+			rq_of(cfs_rq)->clock - se->statistics.wait_start);
 #ifdef CONFIG_SCHEDSTATS
 	if (entity_is_task(se)) {
 		trace_sched_stat_wait(task_of(se),
-			rq_of(cfs_rq)->clock - se->wait_start);
+			rq_of(cfs_rq)->clock - se->statistics.wait_start);
 	}
 #endif
-	schedstat_set(se->wait_start, 0);
+	schedstat_set(se->statistics.wait_start, 0);
 }
 
 static inline void
@@ -657,39 +658,39 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	if (entity_is_task(se))
 		tsk = task_of(se);
 
-	if (se->sleep_start) {
-		u64 delta = rq_of(cfs_rq)->clock - se->sleep_start;
+	if (se->statistics.sleep_start) {
+		u64 delta = rq_of(cfs_rq)->clock - se->statistics.sleep_start;
 
 		if ((s64)delta < 0)
 			delta = 0;
 
-		if (unlikely(delta > se->sleep_max))
-			se->sleep_max = delta;
+		if (unlikely(delta > se->statistics.sleep_max))
+			se->statistics.sleep_max = delta;
 
-		se->sleep_start = 0;
-		se->sum_sleep_runtime += delta;
+		se->statistics.sleep_start = 0;
+		se->statistics.sum_sleep_runtime += delta;
 
 		if (tsk) {
 			account_scheduler_latency(tsk, delta >> 10, 1);
 			trace_sched_stat_sleep(tsk, delta);
 		}
 	}
-	if (se->block_start) {
-		u64 delta = rq_of(cfs_rq)->clock - se->block_start;
+	if (se->statistics.block_start) {
+		u64 delta = rq_of(cfs_rq)->clock - se->statistics.block_start;
 
 		if ((s64)delta < 0)
 			delta = 0;
 
-		if (unlikely(delta > se->block_max))
-			se->block_max = delta;
+		if (unlikely(delta > se->statistics.block_max))
+			se->statistics.block_max = delta;
 
-		se->block_start = 0;
-		se->sum_sleep_runtime += delta;
+		se->statistics.block_start = 0;
+		se->statistics.sum_sleep_runtime += delta;
 
 		if (tsk) {
 			if (tsk->in_iowait) {
-				se->iowait_sum += delta;
-				se->iowait_count++;
+				se->statistics.iowait_sum += delta;
+				se->statistics.iowait_count++;
 				trace_sched_stat_iowait(tsk, delta);
 			}
 
@@ -737,20 +738,10 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 		vruntime += sched_vslice(cfs_rq, se);
 
 	/* sleeps up to a single latency don't count. */
-	if (!initial && sched_feat(FAIR_SLEEPERS)) {
+	if (!initial) {
 		unsigned long thresh = sysctl_sched_latency;
 
 		/*
-		 * Convert the sleeper threshold into virtual time.
-		 * SCHED_IDLE is a special sub-class.  We care about
-		 * fairness only relative to other SCHED_IDLE tasks,
-		 * all of which have the same weight.
-		 */
-		if (sched_feat(NORMALIZED_SLEEPER) && (!entity_is_task(se) ||
-				 task_of(se)->policy != SCHED_IDLE))
-			thresh = calc_delta_fair(thresh, se);
-
-		/*
 		 * Halve their sleep time's effect, to allow
 		 * for a gentler effect of sleepers:
 		 */
@@ -766,9 +757,6 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	se->vruntime = vruntime;
 }
 
-#define ENQUEUE_WAKEUP	1
-#define ENQUEUE_MIGRATE 2
-
 static void
 enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
@@ -776,7 +764,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update the normalized vruntime before updating min_vruntime
 	 * through callig update_curr().
 	 */
-	if (!(flags & ENQUEUE_WAKEUP) || (flags & ENQUEUE_MIGRATE))
+	if (!(flags & ENQUEUE_WAKEUP) || (flags & ENQUEUE_WAKING))
 		se->vruntime += cfs_rq->min_vruntime;
 
 	/*
@@ -812,7 +800,7 @@ static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 static void
-dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
+dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
 	/*
 	 * Update run-time statistics of the 'current'.
@@ -820,15 +808,15 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 	update_curr(cfs_rq);
 
 	update_stats_dequeue(cfs_rq, se);
-	if (sleep) {
+	if (flags & DEQUEUE_SLEEP) {
 #ifdef CONFIG_SCHEDSTATS
 		if (entity_is_task(se)) {
 			struct task_struct *tsk = task_of(se);
 
 			if (tsk->state & TASK_INTERRUPTIBLE)
-				se->sleep_start = rq_of(cfs_rq)->clock;
+				se->statistics.sleep_start = rq_of(cfs_rq)->clock;
 			if (tsk->state & TASK_UNINTERRUPTIBLE)
-				se->block_start = rq_of(cfs_rq)->clock;
+				se->statistics.block_start = rq_of(cfs_rq)->clock;
 		}
 #endif
 	}
@@ -845,7 +833,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 	 * update can refer to the ->curr item and we need to reflect this
 	 * movement in our normalized position.
 	 */
-	if (!sleep)
+	if (!(flags & DEQUEUE_SLEEP))
 		se->vruntime -= cfs_rq->min_vruntime;
 }
 
@@ -912,7 +900,7 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	 * when there are only lesser-weight tasks around):
 	 */
 	if (rq_of(cfs_rq)->load.weight >= 2*se->load.weight) {
-		se->slice_max = max(se->slice_max,
+		se->statistics.slice_max = max(se->statistics.slice_max,
 			se->sum_exec_runtime - se->prev_sum_exec_runtime);
 	}
 #endif
@@ -1054,16 +1042,10 @@ static inline void hrtick_update(struct rq *rq)
  * then put the task into the rbtree:
  */
 static void
-enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup, bool head)
+enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
-	int flags = 0;
-
-	if (wakeup)
-		flags |= ENQUEUE_WAKEUP;
-	if (p->state == TASK_WAKING)
-		flags |= ENQUEUE_MIGRATE;
 
 	for_each_sched_entity(se) {
 		if (se->on_rq)
@@ -1081,18 +1063,18 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup, bool head)
  * decreased. We remove the task from the rbtree and
  * update the fair scheduling stats:
  */
-static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int sleep)
+static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
 
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
-		dequeue_entity(cfs_rq, se, sleep);
+		dequeue_entity(cfs_rq, se, flags);
 		/* Don't dequeue parent if it has other entities besides us */
 		if (cfs_rq->load.weight)
 			break;
-		sleep = 1;
+		flags |= DEQUEUE_SLEEP;
 	}
 
 	hrtick_update(rq);
@@ -1240,7 +1222,6 @@ static inline unsigned long effective_load(struct task_group *tg, int cpu,
 
 static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
-	struct task_struct *curr = current;
 	unsigned long this_load, load;
 	int idx, this_cpu, prev_cpu;
 	unsigned long tl_per_task;
@@ -1255,18 +1236,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	load	  = source_load(prev_cpu, idx);
 	this_load = target_load(this_cpu, idx);
 
-	if (sync) {
-	       if (sched_feat(SYNC_LESS) &&
-		   (curr->se.avg_overlap > sysctl_sched_migration_cost ||
-		    p->se.avg_overlap > sysctl_sched_migration_cost))
-		       sync = 0;
-	} else {
-		if (sched_feat(SYNC_MORE) &&
-		    (curr->se.avg_overlap < sysctl_sched_migration_cost &&
-		     p->se.avg_overlap < sysctl_sched_migration_cost))
-			sync = 1;
-	}
-
 	/*
 	 * If sync wakeup then subtract the (maximum possible)
 	 * effect of the currently running task from the load
@@ -1306,7 +1275,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	if (sync && balanced)
 		return 1;
 
-	schedstat_inc(p, se.nr_wakeups_affine_attempts);
+	schedstat_inc(p, se.statistics.nr_wakeups_affine_attempts);
 	tl_per_task = cpu_avg_load_per_task(this_cpu);
 
 	if (balanced ||
@@ -1318,7 +1287,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 		 * there is no bad imbalance.
 		 */
 		schedstat_inc(sd, ttwu_move_affine);
-		schedstat_inc(p, se.nr_wakeups_affine);
+		schedstat_inc(p, se.statistics.nr_wakeups_affine);
 
 		return 1;
 	}
@@ -1406,29 +1375,48 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 /*
  * Try and locate an idle CPU in the sched_domain.
  */
-static int
-select_idle_sibling(struct task_struct *p, struct sched_domain *sd, int target)
+static int select_idle_sibling(struct task_struct *p, int target)
 {
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
+	struct sched_domain *sd;
 	int i;
 
 	/*
-	 * If this domain spans both cpu and prev_cpu (see the SD_WAKE_AFFINE
-	 * test in select_task_rq_fair) and the prev_cpu is idle then that's
-	 * always a better target than the current cpu.
+	 * If the task is going to be woken-up on this cpu and if it is
+	 * already idle, then it is the right target.
 	 */
-	if (target == cpu && !cpu_rq(prev_cpu)->cfs.nr_running)
+	if (target == cpu && idle_cpu(cpu))
+		return cpu;
+
+	/*
+	 * If the task is going to be woken-up on the cpu where it previously
+	 * ran and if it is currently idle, then it the right target.
+	 */
+	if (target == prev_cpu && idle_cpu(prev_cpu))
 		return prev_cpu;
 
 	/*
-	 * Otherwise, iterate the domain and find an elegible idle cpu.
+	 * Otherwise, iterate the domains and find an elegible idle cpu.
 	 */
-	for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
-		if (!cpu_rq(i)->cfs.nr_running) {
-			target = i;
+	for_each_domain(target, sd) {
+		if (!(sd->flags & SD_SHARE_PKG_RESOURCES))
 			break;
+
+		for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
+			if (idle_cpu(i)) {
+				target = i;
+				break;
+			}
 		}
+
+		/*
+		 * Lets stop looking for an idle sibling when we reached
+		 * the domain that spans the current cpu and prev_cpu.
+		 */
+		if (cpumask_test_cpu(cpu, sched_domain_span(sd)) &&
+		    cpumask_test_cpu(prev_cpu, sched_domain_span(sd)))
+			break;
 	}
 
 	return target;
@@ -1445,7 +1433,8 @@ select_idle_sibling(struct task_struct *p, struct sched_domain *sd, int target)
  *
  * preempt must be disabled.
  */
-static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
+static int
+select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_flags)
 {
 	struct sched_domain *tmp, *affine_sd = NULL, *sd = NULL;
 	int cpu = smp_processor_id();
@@ -1456,8 +1445,7 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 	int sync = wake_flags & WF_SYNC;
 
 	if (sd_flag & SD_BALANCE_WAKE) {
-		if (sched_feat(AFFINE_WAKEUPS) &&
-		    cpumask_test_cpu(cpu, &p->cpus_allowed))
+		if (cpumask_test_cpu(cpu, &p->cpus_allowed))
 			want_affine = 1;
 		new_cpu = prev_cpu;
 	}
@@ -1491,34 +1479,13 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 		}
 
 		/*
-		 * While iterating the domains looking for a spanning
-		 * WAKE_AFFINE domain, adjust the affine target to any idle cpu
-		 * in cache sharing domains along the way.
+		 * If both cpu and prev_cpu are part of this domain,
+		 * cpu is a valid SD_WAKE_AFFINE target.
 		 */
-		if (want_affine) {
-			int target = -1;
-
-			/*
-			 * If both cpu and prev_cpu are part of this domain,
-			 * cpu is a valid SD_WAKE_AFFINE target.
-			 */
-			if (cpumask_test_cpu(prev_cpu, sched_domain_span(tmp)))
-				target = cpu;
-
-			/*
-			 * If there's an idle sibling in this domain, make that
-			 * the wake_affine target instead of the current cpu.
-			 */
-			if (tmp->flags & SD_SHARE_PKG_RESOURCES)
-				target = select_idle_sibling(p, tmp, target);
-
-			if (target >= 0) {
-				if (tmp->flags & SD_WAKE_AFFINE) {
-					affine_sd = tmp;
-					want_affine = 0;
-				}
-				cpu = target;
-			}
+		if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
+		    cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {
+			affine_sd = tmp;
+			want_affine = 0;
 		}
 
 		if (!want_sd && !want_affine)
@@ -1531,22 +1498,29 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 			sd = tmp;
 	}
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	if (sched_feat(LB_SHARES_UPDATE)) {
 		/*
 		 * Pick the largest domain to update shares over
 		 */
 		tmp = sd;
-		if (affine_sd && (!tmp ||
-				  cpumask_weight(sched_domain_span(affine_sd)) >
-				  cpumask_weight(sched_domain_span(sd))))
+		if (affine_sd && (!tmp || affine_sd->span_weight > sd->span_weight))
 			tmp = affine_sd;
 
-		if (tmp)
+		if (tmp) {
+			raw_spin_unlock(&rq->lock);
 			update_shares(tmp);
+			raw_spin_lock(&rq->lock);
+		}
 	}
+#endif
 
-	if (affine_sd && wake_affine(affine_sd, p, sync))
-		return cpu;
+	if (affine_sd) {
+		if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
+			return select_idle_sibling(p, cpu);
+		else
+			return select_idle_sibling(p, prev_cpu);
+	}
 
 	while (sd) {
 		int load_idx = sd->forkexec_idx;
@@ -1576,10 +1550,10 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 
 		/* Now try balancing at a lower domain level of new_cpu */
 		cpu = new_cpu;
-		weight = cpumask_weight(sched_domain_span(sd));
+		weight = sd->span_weight;
 		sd = NULL;
 		for_each_domain(cpu, tmp) {
-			if (weight <= cpumask_weight(sched_domain_span(tmp)))
+			if (weight <= tmp->span_weight)
 				break;
 			if (tmp->flags & sd_flag)
 				sd = tmp;
@@ -1591,63 +1565,26 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 }
 #endif /* CONFIG_SMP */
 
-/*
- * Adaptive granularity
- *
- * se->avg_wakeup gives the average time a task runs until it does a wakeup,
- * with the limit of wakeup_gran -- when it never does a wakeup.
- *
- * So the smaller avg_wakeup is the faster we want this task to preempt,
- * but we don't want to treat the preemptee unfairly and therefore allow it
- * to run for at least the amount of time we'd like to run.
- *
- * NOTE: we use 2*avg_wakeup to increase the probability of actually doing one
- *
- * NOTE: we use *nr_running to scale with load, this nicely matches the
- *       degrading latency on load.
- */
-static unsigned long
-adaptive_gran(struct sched_entity *curr, struct sched_entity *se)
-{
-	u64 this_run = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
-	u64 expected_wakeup = 2*se->avg_wakeup * cfs_rq_of(se)->nr_running;
-	u64 gran = 0;
-
-	if (this_run < expected_wakeup)
-		gran = expected_wakeup - this_run;
-
-	return min_t(s64, gran, sysctl_sched_wakeup_granularity);
-}
-
 static unsigned long
 wakeup_gran(struct sched_entity *curr, struct sched_entity *se)
 {
 	unsigned long gran = sysctl_sched_wakeup_granularity;
 
-	if (cfs_rq_of(curr)->curr && sched_feat(ADAPTIVE_GRAN))
-		gran = adaptive_gran(curr, se);
-
 	/*
 	 * Since its curr running now, convert the gran from real-time
 	 * to virtual-time in his units.
+	 *
+	 * By using 'se' instead of 'curr' we penalize light tasks, so
+	 * they get preempted easier. That is, if 'se' < 'curr' then
+	 * the resulting gran will be larger, therefore penalizing the
+	 * lighter, if otoh 'se' > 'curr' then the resulting gran will
+	 * be smaller, again penalizing the lighter task.
+	 *
+	 * This is especially important for buddies when the leftmost
+	 * task is higher priority than the buddy.
 	 */
-	if (sched_feat(ASYM_GRAN)) {
-		/*
-		 * By using 'se' instead of 'curr' we penalize light tasks, so
-		 * they get preempted easier. That is, if 'se' < 'curr' then
-		 * the resulting gran will be larger, therefore penalizing the
-		 * lighter, if otoh 'se' > 'curr' then the resulting gran will
-		 * be smaller, again penalizing the lighter task.
-		 *
-		 * This is especially important for buddies when the leftmost
-		 * task is higher priority than the buddy.
-		 */
-		if (unlikely(se->load.weight != NICE_0_LOAD))
-			gran = calc_delta_fair(gran, se);
-	} else {
-		if (unlikely(curr->load.weight != NICE_0_LOAD))
-			gran = calc_delta_fair(gran, curr);
-	}
+	if (unlikely(se->load.weight != NICE_0_LOAD))
+		gran = calc_delta_fair(gran, se);
 
 	return gran;
 }
@@ -1705,7 +1642,6 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	struct task_struct *curr = rq->curr;
 	struct sched_entity *se = &curr->se, *pse = &p->se;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
-	int sync = wake_flags & WF_SYNC;
 	int scale = cfs_rq->nr_running >= sched_nr_latency;
 
 	if (unlikely(rt_prio(p->prio)))
@@ -1738,14 +1674,6 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	if (unlikely(curr->policy == SCHED_IDLE))
 		goto preempt;
 
-	if (sched_feat(WAKEUP_SYNC) && sync)
-		goto preempt;
-
-	if (sched_feat(WAKEUP_OVERLAP) &&
-			se->avg_overlap < sysctl_sched_migration_cost &&
-			pse->avg_overlap < sysctl_sched_migration_cost)
-		goto preempt;
-
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
@@ -1844,13 +1772,13 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 	 * 3) are cache-hot on their current CPU.
 	 */
 	if (!cpumask_test_cpu(this_cpu, &p->cpus_allowed)) {
-		schedstat_inc(p, se.nr_failed_migrations_affine);
+		schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
 		return 0;
 	}
 	*all_pinned = 0;
 
 	if (task_running(rq, p)) {
-		schedstat_inc(p, se.nr_failed_migrations_running);
+		schedstat_inc(p, se.statistics.nr_failed_migrations_running);
 		return 0;
 	}
 
@@ -1866,14 +1794,14 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 #ifdef CONFIG_SCHEDSTATS
 		if (tsk_cache_hot) {
 			schedstat_inc(sd, lb_hot_gained[idle]);
-			schedstat_inc(p, se.nr_forced_migrations);
+			schedstat_inc(p, se.statistics.nr_forced_migrations);
 		}
 #endif
 		return 1;
 	}
 
 	if (tsk_cache_hot) {
-		schedstat_inc(p, se.nr_failed_migrations_hot);
+		schedstat_inc(p, se.statistics.nr_failed_migrations_hot);
 		return 0;
 	}
 	return 1;
@@ -2311,7 +2239,7 @@ unsigned long __weak arch_scale_freq_power(struct sched_domain *sd, int cpu)
 
 unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu)
 {
-	unsigned long weight = cpumask_weight(sched_domain_span(sd));
+	unsigned long weight = sd->span_weight;
 	unsigned long smt_gain = sd->smt_gain;
 
 	smt_gain /= weight;
@@ -2344,7 +2272,7 @@ unsigned long scale_rt_power(int cpu)
 
 static void update_cpu_power(struct sched_domain *sd, int cpu)
 {
-	unsigned long weight = cpumask_weight(sched_domain_span(sd));
+	unsigned long weight = sd->span_weight;
 	unsigned long power = SCHED_LOAD_SCALE;
 	struct sched_group *sdg = sd->groups;
 
@@ -2870,6 +2798,8 @@ static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle)
 	return unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2);
 }
 
+static int active_load_balance_cpu_stop(void *data);
+
 /*
  * Check this_cpu to ensure it is balanced within domain. Attempt to move
  * tasks if there is an imbalance.
@@ -2959,8 +2889,9 @@ redo:
 		if (need_active_balance(sd, sd_idle, idle)) {
 			raw_spin_lock_irqsave(&busiest->lock, flags);
 
-			/* don't kick the migration_thread, if the curr
-			 * task on busiest cpu can't be moved to this_cpu
+			/* don't kick the active_load_balance_cpu_stop,
+			 * if the curr task on busiest cpu can't be
+			 * moved to this_cpu
 			 */
 			if (!cpumask_test_cpu(this_cpu,
 					      &busiest->curr->cpus_allowed)) {
@@ -2970,14 +2901,22 @@ redo:
 				goto out_one_pinned;
 			}
 
+			/*
+			 * ->active_balance synchronizes accesses to
+			 * ->active_balance_work.  Once set, it's cleared
+			 * only after active load balance is finished.
+			 */
 			if (!busiest->active_balance) {
 				busiest->active_balance = 1;
 				busiest->push_cpu = this_cpu;
 				active_balance = 1;
 			}
 			raw_spin_unlock_irqrestore(&busiest->lock, flags);
+
 			if (active_balance)
-				wake_up_process(busiest->migration_thread);
+				stop_one_cpu_nowait(cpu_of(busiest),
+					active_load_balance_cpu_stop, busiest,
+					&busiest->active_balance_work);
 
 			/*
 			 * We've kicked active balancing, reset the failure
@@ -3084,24 +3023,29 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 }
 
 /*
- * active_load_balance is run by migration threads. It pushes running tasks
- * off the busiest CPU onto idle CPUs. It requires at least 1 task to be
- * running on each physical CPU where possible, and avoids physical /
- * logical imbalances.
- *
- * Called with busiest_rq locked.
+ * active_load_balance_cpu_stop is run by cpu stopper. It pushes
+ * running tasks off the busiest CPU onto idle CPUs. It requires at
+ * least 1 task to be running on each physical CPU where possible, and
+ * avoids physical / logical imbalances.
  */
-static void active_load_balance(struct rq *busiest_rq, int busiest_cpu)
+static int active_load_balance_cpu_stop(void *data)
 {
+	struct rq *busiest_rq = data;
+	int busiest_cpu = cpu_of(busiest_rq);
 	int target_cpu = busiest_rq->push_cpu;
+	struct rq *target_rq = cpu_rq(target_cpu);
 	struct sched_domain *sd;
-	struct rq *target_rq;
+
+	raw_spin_lock_irq(&busiest_rq->lock);
+
+	/* make sure the requested cpu hasn't gone down in the meantime */
+	if (unlikely(busiest_cpu != smp_processor_id() ||
+		     !busiest_rq->active_balance))
+		goto out_unlock;
 
 	/* Is there any task to move? */
 	if (busiest_rq->nr_running <= 1)
-		return;
-
-	target_rq = cpu_rq(target_cpu);
+		goto out_unlock;
 
 	/*
 	 * This condition is "impossible", if it occurs
@@ -3112,8 +3056,6 @@ static void active_load_balance(struct rq *busiest_rq, int busiest_cpu)
 
 	/* move a task from busiest_rq to target_rq */
 	double_lock_balance(busiest_rq, target_rq);
-	update_rq_clock(busiest_rq);
-	update_rq_clock(target_rq);
 
 	/* Search for an sd spanning us and the target CPU. */
 	for_each_domain(target_cpu, sd) {
@@ -3132,6 +3074,10 @@ static void active_load_balance(struct rq *busiest_rq, int busiest_cpu)
 			schedstat_inc(sd, alb_failed);
 	}
 	double_unlock_balance(busiest_rq, target_rq);
+out_unlock:
+	busiest_rq->active_balance = 0;
+	raw_spin_unlock_irq(&busiest_rq->lock);
+	return 0;
 }
 
 #ifdef CONFIG_NO_HZ
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index d5059fd..83c66e8 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -1,11 +1,4 @@
 /*
- * Disregards a certain amount of sleep time (sched_latency_ns) and
- * considers the task to be running during that period. This gives it
- * a service deficit on wakeup, allowing it to run sooner.
- */
-SCHED_FEAT(FAIR_SLEEPERS, 1)
-
-/*
  * Only give sleepers 50% of their service deficit. This allows
  * them to run sooner, but does not allow tons of sleepers to
  * rip the spread apart.
@@ -13,13 +6,6 @@ SCHED_FEAT(FAIR_SLEEPERS, 1)
 SCHED_FEAT(GENTLE_FAIR_SLEEPERS, 1)
 
 /*
- * By not normalizing the sleep time, heavy tasks get an effective
- * longer period, and lighter task an effective shorter period they
- * are considered running.
- */
-SCHED_FEAT(NORMALIZED_SLEEPER, 0)
-
-/*
  * Place new tasks ahead so that they do not starve already running
  * tasks
  */
@@ -31,37 +17,6 @@ SCHED_FEAT(START_DEBIT, 1)
 SCHED_FEAT(WAKEUP_PREEMPT, 1)
 
 /*
- * Compute wakeup_gran based on task behaviour, clipped to
- *  [0, sched_wakeup_gran_ns]
- */
-SCHED_FEAT(ADAPTIVE_GRAN, 1)
-
-/*
- * When converting the wakeup granularity to virtual time, do it such
- * that heavier tasks preempting a lighter task have an edge.
- */
-SCHED_FEAT(ASYM_GRAN, 1)
-
-/*
- * Always wakeup-preempt SYNC wakeups, see SYNC_WAKEUPS.
- */
-SCHED_FEAT(WAKEUP_SYNC, 0)
-
-/*
- * Wakeup preempt based on task behaviour. Tasks that do not overlap
- * don't get preempted.
- */
-SCHED_FEAT(WAKEUP_OVERLAP, 0)
-
-/*
- * Use the SYNC wakeup hint, pipes and the likes use this to indicate
- * the remote end is likely to consume the data we just wrote, and
- * therefore has cache benefit from being placed on the same cpu, see
- * also AFFINE_WAKEUPS.
- */
-SCHED_FEAT(SYNC_WAKEUPS, 1)
-
-/*
  * Based on load and program behaviour, see if it makes sense to place
  * a newly woken task on the same cpu as the task that woke it --
  * improve cache locality. Typically used with SYNC wakeups as
@@ -70,16 +25,6 @@ SCHED_FEAT(SYNC_WAKEUPS, 1)
 SCHED_FEAT(AFFINE_WAKEUPS, 1)
 
 /*
- * Weaken SYNC hint based on overlap
- */
-SCHED_FEAT(SYNC_LESS, 1)
-
-/*
- * Add SYNC hint based on overlap
- */
-SCHED_FEAT(SYNC_MORE, 0)
-
-/*
  * Prefer to schedule the task we woke last (assuming it failed
  * wakeup-preemption), since its likely going to consume data we
  * touched, increases cache locality.
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index a8a6d8a..9fa0f40 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -6,7 +6,8 @@
  */
 
 #ifdef CONFIG_SMP
-static int select_task_rq_idle(struct task_struct *p, int sd_flag, int flags)
+static int
+select_task_rq_idle(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
@@ -22,8 +23,7 @@ static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int fl
 static struct task_struct *pick_next_task_idle(struct rq *rq)
 {
 	schedstat_inc(rq, sched_goidle);
-	/* adjust the active tasks as we might go into a long sleep */
-	calc_load_account_active(rq);
+	calc_load_account_idle(rq);
 	return rq->idle;
 }
 
@@ -32,7 +32,7 @@ static struct task_struct *pick_next_task_idle(struct rq *rq)
  * message if some code attempts to do it:
  */
 static void
-dequeue_task_idle(struct rq *rq, struct task_struct *p, int sleep)
+dequeue_task_idle(struct rq *rq, struct task_struct *p, int flags)
 {
 	raw_spin_unlock_irq(&rq->lock);
 	printk(KERN_ERR "bad: scheduling from the idle thread!\n");
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index b5b920a..8afb953 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -613,7 +613,7 @@ static void update_curr_rt(struct rq *rq)
 	if (unlikely((s64)delta_exec < 0))
 		delta_exec = 0;
 
-	schedstat_set(curr->se.exec_max, max(curr->se.exec_max, delta_exec));
+	schedstat_set(curr->se.statistics.exec_max, max(curr->se.statistics.exec_max, delta_exec));
 
 	curr->se.sum_exec_runtime += delta_exec;
 	account_group_exec_runtime(curr, delta_exec);
@@ -888,20 +888,20 @@ static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
  * Adding/removing a task to/from a priority array:
  */
 static void
-enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup, bool head)
+enqueue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
 
-	if (wakeup)
+	if (flags & ENQUEUE_WAKEUP)
 		rt_se->timeout = 0;
 
-	enqueue_rt_entity(rt_se, head);
+	enqueue_rt_entity(rt_se, flags & ENQUEUE_HEAD);
 
 	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
 }
 
-static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
+static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
 
@@ -948,10 +948,9 @@ static void yield_task_rt(struct rq *rq)
 #ifdef CONFIG_SMP
 static int find_lowest_rq(struct task_struct *task);
 
-static int select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
+static int
+select_task_rq_rt(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
 {
-	struct rq *rq = task_rq(p);
-
 	if (sd_flag != SD_BALANCE_WAKE)
 		return smp_processor_id();
 
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 9bb9fb1..b4e7431 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -1,17 +1,384 @@
-/* Copyright 2008, 2005 Rusty Russell rusty@rustcorp.com.au IBM Corporation.
- * GPL v2 and any later version.
+/*
+ * kernel/stop_machine.c
+ *
+ * Copyright (C) 2008, 2005	IBM Corporation.
+ * Copyright (C) 2008, 2005	Rusty Russell rusty@rustcorp.com.au
+ * Copyright (C) 2010		SUSE Linux Products GmbH
+ * Copyright (C) 2010		Tejun Heo <tj@kernel.org>
+ *
+ * This file is released under the GPLv2 and any later version.
  */
+#include <linux/completion.h>
 #include <linux/cpu.h>
-#include <linux/err.h>
+#include <linux/init.h>
 #include <linux/kthread.h>
 #include <linux/module.h>
+#include <linux/percpu.h>
 #include <linux/sched.h>
 #include <linux/stop_machine.h>
-#include <linux/syscalls.h>
 #include <linux/interrupt.h>
+#include <linux/kallsyms.h>
 
 #include <asm/atomic.h>
-#include <asm/uaccess.h>
+
+/*
+ * Structure to determine completion condition and record errors.  May
+ * be shared by works on different cpus.
+ */
+struct cpu_stop_done {
+	atomic_t		nr_todo;	/* nr left to execute */
+	bool			executed;	/* actually executed? */
+	int			ret;		/* collected return value */
+	struct completion	completion;	/* fired if nr_todo reaches 0 */
+};
+
+/* the actual stopper, one per every possible cpu, enabled on online cpus */
+struct cpu_stopper {
+	spinlock_t		lock;
+	struct list_head	works;		/* list of pending works */
+	struct task_struct	*thread;	/* stopper thread */
+	bool			enabled;	/* is this stopper enabled? */
+};
+
+static DEFINE_PER_CPU(struct cpu_stopper, cpu_stopper);
+
+static void cpu_stop_init_done(struct cpu_stop_done *done, unsigned int nr_todo)
+{
+	memset(done, 0, sizeof(*done));
+	atomic_set(&done->nr_todo, nr_todo);
+	init_completion(&done->completion);
+}
+
+/* signal completion unless @done is NULL */
+static void cpu_stop_signal_done(struct cpu_stop_done *done, bool executed)
+{
+	if (done) {
+		if (executed)
+			done->executed = true;
+		if (atomic_dec_and_test(&done->nr_todo))
+			complete(&done->completion);
+	}
+}
+
+/* queue @work to @stopper.  if offline, @work is completed immediately */
+static void cpu_stop_queue_work(struct cpu_stopper *stopper,
+				struct cpu_stop_work *work)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&stopper->lock, flags);
+
+	if (stopper->enabled) {
+		list_add_tail(&work->list, &stopper->works);
+		wake_up_process(stopper->thread);
+	} else
+		cpu_stop_signal_done(work->done, false);
+
+	spin_unlock_irqrestore(&stopper->lock, flags);
+}
+
+/**
+ * stop_one_cpu - stop a cpu
+ * @cpu: cpu to stop
+ * @fn: function to execute
+ * @arg: argument to @fn
+ *
+ * Execute @fn(@arg) on @cpu.  @fn is run in a process context with
+ * the highest priority preempting any task on the cpu and
+ * monopolizing it.  This function returns after the execution is
+ * complete.
+ *
+ * This function doesn't guarantee @cpu stays online till @fn
+ * completes.  If @cpu goes down in the middle, execution may happen
+ * partially or fully on different cpus.  @fn should either be ready
+ * for that or the caller should ensure that @cpu stays online until
+ * this function completes.
+ *
+ * CONTEXT:
+ * Might sleep.
+ *
+ * RETURNS:
+ * -ENOENT if @fn(@arg) was not executed because @cpu was offline;
+ * otherwise, the return value of @fn.
+ */
+int stop_one_cpu(unsigned int cpu, cpu_stop_fn_t fn, void *arg)
+{
+	struct cpu_stop_done done;
+	struct cpu_stop_work work = { .fn = fn, .arg = arg, .done = &done };
+
+	cpu_stop_init_done(&done, 1);
+	cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu), &work);
+	wait_for_completion(&done.completion);
+	return done.executed ? done.ret : -ENOENT;
+}
+
+/**
+ * stop_one_cpu_nowait - stop a cpu but don't wait for completion
+ * @cpu: cpu to stop
+ * @fn: function to execute
+ * @arg: argument to @fn
+ *
+ * Similar to stop_one_cpu() but doesn't wait for completion.  The
+ * caller is responsible for ensuring @work_buf is currently unused
+ * and will remain untouched until stopper starts executing @fn.
+ *
+ * CONTEXT:
+ * Don't care.
+ */
+void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void *arg,
+			struct cpu_stop_work *work_buf)
+{
+	*work_buf = (struct cpu_stop_work){ .fn = fn, .arg = arg, };
+	cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu), work_buf);
+}
+
+/* static data for stop_cpus */
+static DEFINE_MUTEX(stop_cpus_mutex);
+static DEFINE_PER_CPU(struct cpu_stop_work, stop_cpus_work);
+
+int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
+{
+	struct cpu_stop_work *work;
+	struct cpu_stop_done done;
+	unsigned int cpu;
+
+	/* initialize works and done */
+	for_each_cpu(cpu, cpumask) {
+		work = &per_cpu(stop_cpus_work, cpu);
+		work->fn = fn;
+		work->arg = arg;
+		work->done = &done;
+	}
+	cpu_stop_init_done(&done, cpumask_weight(cpumask));
+
+	/*
+	 * Disable preemption while queueing to avoid getting
+	 * preempted by a stopper which might wait for other stoppers
+	 * to enter @fn which can lead to deadlock.
+	 */
+	preempt_disable();
+	for_each_cpu(cpu, cpumask)
+		cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu),
+				    &per_cpu(stop_cpus_work, cpu));
+	preempt_enable();
+
+	wait_for_completion(&done.completion);
+	return done.executed ? done.ret : -ENOENT;
+}
+
+/**
+ * stop_cpus - stop multiple cpus
+ * @cpumask: cpus to stop
+ * @fn: function to execute
+ * @arg: argument to @fn
+ *
+ * Execute @fn(@arg) on online cpus in @cpumask.  On each target cpu,
+ * @fn is run in a process context with the highest priority
+ * preempting any task on the cpu and monopolizing it.  This function
+ * returns after all executions are complete.
+ *
+ * This function doesn't guarantee the cpus in @cpumask stay online
+ * till @fn completes.  If some cpus go down in the middle, execution
+ * on the cpu may happen partially or fully on different cpus.  @fn
+ * should either be ready for that or the caller should ensure that
+ * the cpus stay online until this function completes.
+ *
+ * All stop_cpus() calls are serialized making it safe for @fn to wait
+ * for all cpus to start executing it.
+ *
+ * CONTEXT:
+ * Might sleep.
+ *
+ * RETURNS:
+ * -ENOENT if @fn(@arg) was not executed at all because all cpus in
+ * @cpumask were offline; otherwise, 0 if all executions of @fn
+ * returned 0, any non zero return value if any returned non zero.
+ */
+int stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
+{
+	int ret;
+
+	/* static works are used, process one request at a time */
+	mutex_lock(&stop_cpus_mutex);
+	ret = __stop_cpus(cpumask, fn, arg);
+	mutex_unlock(&stop_cpus_mutex);
+	return ret;
+}
+
+/**
+ * try_stop_cpus - try to stop multiple cpus
+ * @cpumask: cpus to stop
+ * @fn: function to execute
+ * @arg: argument to @fn
+ *
+ * Identical to stop_cpus() except that it fails with -EAGAIN if
+ * someone else is already using the facility.
+ *
+ * CONTEXT:
+ * Might sleep.
+ *
+ * RETURNS:
+ * -EAGAIN if someone else is already stopping cpus, -ENOENT if
+ * @fn(@arg) was not executed at all because all cpus in @cpumask were
+ * offline; otherwise, 0 if all executions of @fn returned 0, any non
+ * zero return value if any returned non zero.
+ */
+int try_stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
+{
+	int ret;
+
+	/* static works are used, process one request at a time */
+	if (!mutex_trylock(&stop_cpus_mutex))
+		return -EAGAIN;
+	ret = __stop_cpus(cpumask, fn, arg);
+	mutex_unlock(&stop_cpus_mutex);
+	return ret;
+}
+
+static int cpu_stopper_thread(void *data)
+{
+	struct cpu_stopper *stopper = data;
+	struct cpu_stop_work *work;
+	int ret;
+
+repeat:
+	set_current_state(TASK_INTERRUPTIBLE);	/* mb paired w/ kthread_stop */
+
+	if (kthread_should_stop()) {
+		__set_current_state(TASK_RUNNING);
+		return 0;
+	}
+
+	work = NULL;
+	spin_lock_irq(&stopper->lock);
+	if (!list_empty(&stopper->works)) {
+		work = list_first_entry(&stopper->works,
+					struct cpu_stop_work, list);
+		list_del_init(&work->list);
+	}
+	spin_unlock_irq(&stopper->lock);
+
+	if (work) {
+		cpu_stop_fn_t fn = work->fn;
+		void *arg = work->arg;
+		struct cpu_stop_done *done = work->done;
+		char ksym_buf[KSYM_NAME_LEN];
+
+		__set_current_state(TASK_RUNNING);
+
+		/* cpu stop callbacks are not allowed to sleep */
+		preempt_disable();
+
+		ret = fn(arg);
+		if (ret)
+			done->ret = ret;
+
+		/* restore preemption and check it's still balanced */
+		preempt_enable();
+		WARN_ONCE(preempt_count(),
+			  "cpu_stop: %s(%p) leaked preempt count\n",
+			  kallsyms_lookup((unsigned long)fn, NULL, NULL, NULL,
+					  ksym_buf), arg);
+
+		cpu_stop_signal_done(done, true);
+	} else
+		schedule();
+
+	goto repeat;
+}
+
+/* manage stopper for a cpu, mostly lifted from sched migration thread mgmt */
+static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
+					   unsigned long action, void *hcpu)
+{
+	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
+	unsigned int cpu = (unsigned long)hcpu;
+	struct cpu_stopper *stopper = &per_cpu(cpu_stopper, cpu);
+	struct task_struct *p;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_UP_PREPARE:
+		BUG_ON(stopper->thread || stopper->enabled ||
+		       !list_empty(&stopper->works));
+		p = kthread_create(cpu_stopper_thread, stopper, "migration/%d",
+				   cpu);
+		if (IS_ERR(p))
+			return NOTIFY_BAD;
+		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
+		get_task_struct(p);
+		stopper->thread = p;
+		break;
+
+	case CPU_ONLINE:
+		kthread_bind(stopper->thread, cpu);
+		/* strictly unnecessary, as first user will wake it */
+		wake_up_process(stopper->thread);
+		/* mark enabled */
+		spin_lock_irq(&stopper->lock);
+		stopper->enabled = true;
+		spin_unlock_irq(&stopper->lock);
+		break;
+
+#ifdef CONFIG_HOTPLUG_CPU
+	case CPU_UP_CANCELED:
+	case CPU_DEAD:
+	{
+		struct cpu_stop_work *work;
+
+		/* kill the stopper */
+		kthread_stop(stopper->thread);
+		/* drain remaining works */
+		spin_lock_irq(&stopper->lock);
+		list_for_each_entry(work, &stopper->works, list)
+			cpu_stop_signal_done(work->done, false);
+		stopper->enabled = false;
+		spin_unlock_irq(&stopper->lock);
+		/* release the stopper */
+		put_task_struct(stopper->thread);
+		stopper->thread = NULL;
+		break;
+	}
+#endif
+	}
+
+	return NOTIFY_OK;
+}
+
+/*
+ * Give it a higher priority so that cpu stopper is available to other
+ * cpu notifiers.  It currently shares the same priority as sched
+ * migration_notifier.
+ */
+static struct notifier_block __cpuinitdata cpu_stop_cpu_notifier = {
+	.notifier_call	= cpu_stop_cpu_callback,
+	.priority	= 10,
+};
+
+static int __init cpu_stop_init(void)
+{
+	void *bcpu = (void *)(long)smp_processor_id();
+	unsigned int cpu;
+	int err;
+
+	for_each_possible_cpu(cpu) {
+		struct cpu_stopper *stopper = &per_cpu(cpu_stopper, cpu);
+
+		spin_lock_init(&stopper->lock);
+		INIT_LIST_HEAD(&stopper->works);
+	}
+
+	/* start one for the boot cpu */
+	err = cpu_stop_cpu_callback(&cpu_stop_cpu_notifier, CPU_UP_PREPARE,
+				    bcpu);
+	BUG_ON(err == NOTIFY_BAD);
+	cpu_stop_cpu_callback(&cpu_stop_cpu_notifier, CPU_ONLINE, bcpu);
+	register_cpu_notifier(&cpu_stop_cpu_notifier);
+
+	return 0;
+}
+early_initcall(cpu_stop_init);
+
+#ifdef CONFIG_STOP_MACHINE
 
 /* This controls the threads on each CPU. */
 enum stopmachine_state {
@@ -26,174 +393,94 @@ enum stopmachine_state {
 	/* Exit */
 	STOPMACHINE_EXIT,
 };
-static enum stopmachine_state state;
 
 struct stop_machine_data {
-	int (*fn)(void *);
-	void *data;
-	int fnret;
+	int			(*fn)(void *);
+	void			*data;
+	/* Like num_online_cpus(), but hotplug cpu uses us, so we need this. */
+	unsigned int		num_threads;
+	const struct cpumask	*active_cpus;
+
+	enum stopmachine_state	state;
+	atomic_t		thread_ack;
 };
 
-/* Like num_online_cpus(), but hotplug cpu uses us, so we need this. */
-static unsigned int num_threads;
-static atomic_t thread_ack;
-static DEFINE_MUTEX(lock);
-/* setup_lock protects refcount, stop_machine_wq and stop_machine_work. */
-static DEFINE_MUTEX(setup_lock);
-/* Users of stop_machine. */
-static int refcount;
-static struct workqueue_struct *stop_machine_wq;
-static struct stop_machine_data active, idle;
-static const struct cpumask *active_cpus;
-static void __percpu *stop_machine_work;
-
-static void set_state(enum stopmachine_state newstate)
+static void set_state(struct stop_machine_data *smdata,
+		      enum stopmachine_state newstate)
 {
 	/* Reset ack counter. */
-	atomic_set(&thread_ack, num_threads);
+	atomic_set(&smdata->thread_ack, smdata->num_threads);
 	smp_wmb();
-	state = newstate;
+	smdata->state = newstate;
 }
 
 /* Last one to ack a state moves to the next state. */
-static void ack_state(void)
+static void ack_state(struct stop_machine_data *smdata)
 {
-	if (atomic_dec_and_test(&thread_ack))
-		set_state(state + 1);
+	if (atomic_dec_and_test(&smdata->thread_ack))
+		set_state(smdata, smdata->state + 1);
 }
 
-/* This is the actual function which stops the CPU. It runs
- * in the context of a dedicated stopmachine workqueue. */
-static void stop_cpu(struct work_struct *unused)
+/* This is the cpu_stop function which stops the CPU. */
+static int stop_machine_cpu_stop(void *data)
 {
+	struct stop_machine_data *smdata = data;
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
-	struct stop_machine_data *smdata = &idle;
-	int cpu = smp_processor_id();
-	int err;
+	int cpu = smp_processor_id(), err = 0;
+	bool is_active;
+
+	if (!smdata->active_cpus)
+		is_active = cpu == cpumask_first(cpu_online_mask);
+	else
+		is_active = cpumask_test_cpu(cpu, smdata->active_cpus);
 
-	if (!active_cpus) {
-		if (cpu == cpumask_first(cpu_online_mask))
-			smdata = &active;
-	} else {
-		if (cpumask_test_cpu(cpu, active_cpus))
-			smdata = &active;
-	}
 	/* Simple state machine */
 	do {
 		/* Chill out and ensure we re-read stopmachine_state. */
 		cpu_relax();
-		if (state != curstate) {
-			curstate = state;
+		if (smdata->state != curstate) {
+			curstate = smdata->state;
 			switch (curstate) {
 			case STOPMACHINE_DISABLE_IRQ:
 				local_irq_disable();
 				hard_irq_disable();
 				break;
 			case STOPMACHINE_RUN:
-				/* On multiple CPUs only a single error code
-				 * is needed to tell that something failed. */
-				err = smdata->fn(smdata->data);
-				if (err)
-					smdata->fnret = err;
+				if (is_active)
+					err = smdata->fn(smdata->data);
 				break;
 			default:
 				break;
 			}
-			ack_state();
+			ack_state(smdata);
 		}
 	} while (curstate != STOPMACHINE_EXIT);
 
 	local_irq_enable();
+	return err;
 }
 
-/* Callback for CPUs which aren't supposed to do anything. */
-static int chill(void *unused)
-{
-	return 0;
-}
-
-int stop_machine_create(void)
-{
-	mutex_lock(&setup_lock);
-	if (refcount)
-		goto done;
-	stop_machine_wq = create_rt_workqueue("kstop");
-	if (!stop_machine_wq)
-		goto err_out;
-	stop_machine_work = alloc_percpu(struct work_struct);
-	if (!stop_machine_work)
-		goto err_out;
-done:
-	refcount++;
-	mutex_unlock(&setup_lock);
-	return 0;
-
-err_out:
-	if (stop_machine_wq)
-		destroy_workqueue(stop_machine_wq);
-	mutex_unlock(&setup_lock);
-	return -ENOMEM;
-}
-EXPORT_SYMBOL_GPL(stop_machine_create);
-
-void stop_machine_destroy(void)
-{
-	mutex_lock(&setup_lock);
-	refcount--;
-	if (refcount)
-		goto done;
-	destroy_workqueue(stop_machine_wq);
-	free_percpu(stop_machine_work);
-done:
-	mutex_unlock(&setup_lock);
-}
-EXPORT_SYMBOL_GPL(stop_machine_destroy);
-
 int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 {
-	struct work_struct *sm_work;
-	int i, ret;
-
-	/* Set up initial state. */
-	mutex_lock(&lock);
-	num_threads = num_online_cpus();
-	active_cpus = cpus;
-	active.fn = fn;
-	active.data = data;
-	active.fnret = 0;
-	idle.fn = chill;
-	idle.data = NULL;
-
-	set_state(STOPMACHINE_PREPARE);
-
-	/* Schedule the stop_cpu work on all cpus: hold this CPU so one
-	 * doesn't hit this CPU until we're ready. */
-	get_cpu();
-	for_each_online_cpu(i) {
-		sm_work = per_cpu_ptr(stop_machine_work, i);
-		INIT_WORK(sm_work, stop_cpu);
-		queue_work_on(i, stop_machine_wq, sm_work);
-	}
-	/* This will release the thread on our CPU. */
-	put_cpu();
-	flush_workqueue(stop_machine_wq);
-	ret = active.fnret;
-	mutex_unlock(&lock);
-	return ret;
+	struct stop_machine_data smdata = { .fn = fn, .data = data,
+					    .num_threads = num_online_cpus(),
+					    .active_cpus = cpus };
+
+	/* Set the initial state and stop all online cpus. */
+	set_state(&smdata, STOPMACHINE_PREPARE);
+	return stop_cpus(cpu_online_mask, stop_machine_cpu_stop, &smdata);
 }
 
 int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 {
 	int ret;
 
-	ret = stop_machine_create();
-	if (ret)
-		return ret;
 	/* No CPUs can come up or down during this. */
 	get_online_cpus();
 	ret = __stop_machine(fn, data, cpus);
 	put_online_cpus();
-	stop_machine_destroy();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(stop_machine);
+
+#endif	/* CONFIG_STOP_MACHINE */
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index f992762..1d7b9bc 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -150,14 +150,32 @@ static void tick_nohz_update_jiffies(ktime_t now)
 	touch_softlockup_watchdog();
 }
 
+/*
+ * Updates the per cpu time idle statistics counters
+ */
+static void
+update_ts_time_stats(struct tick_sched *ts, ktime_t now, u64 *last_update_time)
+{
+	ktime_t delta;
+
+	if (ts->idle_active) {
+		delta = ktime_sub(now, ts->idle_entrytime);
+		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+		if (nr_iowait_cpu() > 0)
+			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
+		ts->idle_entrytime = now;
+	}
+
+	if (last_update_time)
+		*last_update_time = ktime_to_us(now);
+
+}
+
 static void tick_nohz_stop_idle(int cpu, ktime_t now)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-	ktime_t delta;
 
-	delta = ktime_sub(now, ts->idle_entrytime);
-	ts->idle_lastupdate = now;
-	ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+	update_ts_time_stats(ts, now, NULL);
 	ts->idle_active = 0;
 
 	sched_clock_idle_wakeup_event(0);
@@ -165,20 +183,32 @@ static void tick_nohz_stop_idle(int cpu, ktime_t now)
 
 static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 {
-	ktime_t now, delta;
+	ktime_t now;
 
 	now = ktime_get();
-	if (ts->idle_active) {
-		delta = ktime_sub(now, ts->idle_entrytime);
-		ts->idle_lastupdate = now;
-		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
-	}
+
+	update_ts_time_stats(ts, now, NULL);
+
 	ts->idle_entrytime = now;
 	ts->idle_active = 1;
 	sched_clock_idle_sleep_event();
 	return now;
 }
 
+/**
+ * get_cpu_idle_time_us - get the total idle time of a cpu
+ * @cpu: CPU number to query
+ * @last_update_time: variable to store update time in
+ *
+ * Return the cummulative idle time (since boot) for a given
+ * CPU, in microseconds. The idle time returned includes
+ * the iowait time (unlike what "top" and co report).
+ *
+ * This time is measured via accounting rather than sampling,
+ * and is as accurate as ktime_get() is.
+ *
+ * This function returns -1 if NOHZ is not enabled.
+ */
 u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
@@ -186,15 +216,38 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 	if (!tick_nohz_enabled)
 		return -1;
 
-	if (ts->idle_active)
-		*last_update_time = ktime_to_us(ts->idle_lastupdate);
-	else
-		*last_update_time = ktime_to_us(ktime_get());
+	update_ts_time_stats(ts, ktime_get(), last_update_time);
 
 	return ktime_to_us(ts->idle_sleeptime);
 }
 EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 
+/*
+ * get_cpu_iowait_time_us - get the total iowait time of a cpu
+ * @cpu: CPU number to query
+ * @last_update_time: variable to store update time in
+ *
+ * Return the cummulative iowait time (since boot) for a given
+ * CPU, in microseconds.
+ *
+ * This time is measured via accounting rather than sampling,
+ * and is as accurate as ktime_get() is.
+ *
+ * This function returns -1 if NOHZ is not enabled.
+ */
+u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+
+	if (!tick_nohz_enabled)
+		return -1;
+
+	update_ts_time_stats(ts, ktime_get(), last_update_time);
+
+	return ktime_to_us(ts->iowait_sleeptime);
+}
+EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
+
 /**
  * tick_nohz_stop_sched_tick - stop the idle tick from the idle task
  *
@@ -262,6 +315,9 @@ void tick_nohz_stop_sched_tick(int inidle)
 		goto end;
 	}
 
+	if (nohz_ratelimit(cpu))
+		goto end;
+
 	ts->idle_calls++;
 	/* Read jiffies and the time when jiffies were updated last */
 	do {
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 1a4a7dd..ab8f5e3 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -176,6 +176,7 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 		P_ns(idle_waketime);
 		P_ns(idle_exittime);
 		P_ns(idle_sleeptime);
+		P_ns(iowait_sleeptime);
 		P(last_jiffies);
 		P(next_jiffies);
 		P_ns(idle_expires);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2404b59..aa3a92b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3212,8 +3212,7 @@ free:
 }
 
 static void
-ftrace_graph_probe_sched_switch(struct rq *__rq, struct task_struct *prev,
-				struct task_struct *next)
+ftrace_graph_probe_sched_switch(struct task_struct *prev, struct task_struct *next)
 {
 	unsigned long long timestamp;
 	int index;
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 5fca0f5..a55fccf 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -50,8 +50,7 @@ tracing_sched_switch_trace(struct trace_array *tr,
 }
 
 static void
-probe_sched_switch(struct rq *__rq, struct task_struct *prev,
-			struct task_struct *next)
+probe_sched_switch(struct task_struct *prev, struct task_struct *next)
 {
 	struct trace_array_cpu *data;
 	unsigned long flags;
@@ -109,7 +108,7 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 }
 
 static void
-probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee, int success)
+probe_sched_wakeup(struct task_struct *wakee, int success)
 {
 	struct trace_array_cpu *data;
 	unsigned long flags;
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 0271742..8052446 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -107,8 +107,7 @@ static void probe_wakeup_migrate_task(struct task_struct *task, int cpu)
 }
 
 static void notrace
-probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
-	struct task_struct *next)
+probe_wakeup_sched_switch(struct task_struct *prev, struct task_struct *next)
 {
 	struct trace_array_cpu *data;
 	cycle_t T0, T1, delta;
@@ -200,7 +199,7 @@ static void wakeup_reset(struct trace_array *tr)
 }
 
 static void
-probe_wakeup(struct rq *rq, struct task_struct *p, int success)
+probe_wakeup(struct task_struct *p, int success)
 {
 	struct trace_array_cpu *data;
 	int cpu = smp_processor_id();
diff --git a/kernel/user.c b/kernel/user.c
index 766467b..7e72614 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -16,7 +16,6 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/user_namespace.h>
-#include "cred-internals.h"
 
 struct user_namespace init_user_ns = {
 	.kref = {
@@ -137,9 +136,6 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 	struct hlist_head *hashent = uidhashentry(ns, uid);
 	struct user_struct *up, *new;
 
-	/* Make uid_hash_find() + uids_user_create() + uid_hash_insert()
-	 * atomic.
-	 */
 	spin_lock_irq(&uidhash_lock);
 	up = uid_hash_find(uid, hashent);
 	spin_unlock_irq(&uidhash_lock);
@@ -161,11 +157,6 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 		spin_lock_irq(&uidhash_lock);
 		up = uid_hash_find(uid, hashent);
 		if (up) {
-			/* This case is not possible when CONFIG_USER_SCHED
-			 * is defined, since we serialize alloc_uid() using
-			 * uids_mutex. Hence no need to call
-			 * sched_destroy_user() or remove_user_sysfs_dir().
-			 */
 			key_put(new->uid_keyring);
 			key_put(new->session_keyring);
 			kmem_cache_free(uid_cachep, new);
@@ -178,8 +169,6 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 
 	return up;
 
-	put_user_ns(new->user_ns);
-	kmem_cache_free(uid_cachep, new);
 out_unlock:
 	return NULL;
 }
