Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab2AEOLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:11:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52901 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454Ab2AEOLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:11:14 -0500
Date: Thu, 5 Jan 2012 15:08:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler changes for v3.3
Message-ID: <20120105140846.GA32342@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-core-for-linus

 Thanks,

	Ingo

------------------>
Andrew Vagin (2):
      sched: Don't call task_group() too many times in set_task_rq()
      events, sched: Add tracepoint for accounting blocked time

Arun Sharma (1):
      sched/tracing: Add a new tracepoint for sleeptime

Daisuke Nishimura (3):
      sched: Fix cgroup movement of forking process
      sched: Fix cgroup movement of newly created process
      sched: Fix cgroup movement of waking process

Dave Jones (1):
      sched: Disable scheduler warnings during oopses

Glauber Costa (6):
      sched, trivial: Initialize root cgroup's sibling list
      sched/accounting: Change cpustat fields to an array
      sched/accounting, cgroups: Reuse cgroup's parent pointer
      sched/accounting: Re-use scheduler statistics for the root cgroup
      sched/accounting: Fix user/system tick double accounting
      sched/accounting: Fix parameter passing in task_group_account_field

Kamalesh Babulal (1):
      sched: Remove cfs bandwidth period check in tg_set_cfs_period()

Kees Cook (2):
      sched: Mark parent and real_parent as __rcu
      sched: Add missing rcu_dereference() around ->real_parent usage

Martin Schwidefsky (2):
      [S390] cputime: add sparse checking and cleanup
      [S390] fix cputime overflow in uptime_proc_show

Mike Galbraith (3):
      sched: Use rt.nr_cpus_allowed to recover select_task_rq() cycles
      sched: Set skip_clock_update in yield_task_fair()
      sched: Save some hrtick_start_fair cycles

Paul Turner (1):
      sched: Use jump labels to reduce overhead when bandwidth control is inactive

Peter Zijlstra (8):
      sched: Make separate sched*.c translation units
      sched: Move all scheduler bits into kernel/sched/
      sched: Fix compile error for UP,!NOHZ
      sched: Use jump_labels for sched_feat
      sched, nohz: Fix missing RCU read lock
      sched: Only queue remote wakeups when crossing cache boundaries
      sched: Replace all_pinned with a generic flags field
      sched: Fix load-balance lock-breaking

Richard Weinberger (1):
      sched: Fix comment for requeue_rt_entity

Shan Hai (1):
      sched/rt: Code cleanup, remove a redundant function call

Suresh Siddha (8):
      sched: Clean up domain traversal in select_idle_sibling()
      sched: Fix the sched group node allocation for SD_OVERLAP domains
      sched, nohz: Introduce nohz_flags in 'struct rq'
      sched, nohz: Track nr_busy_cpus in the sched_group_power
      sched, nohz: Implement sched group, domain aware nohz idle load balancing
      sched, nohz: Clean up the find_new_ilb() using sched groups nr_busy_cpus
      sched, nohz: Fix the idle cpu check in nohz_idle_balance
      sched, nohz: Set the NOHZ_BALANCE_KICK flag for idle load balancer


 arch/ia64/include/asm/cputime.h                  |   69 +-
 arch/powerpc/include/asm/cputime.h               |   70 +-
 arch/s390/appldata/appldata_os.c                 |   16 +-
 arch/s390/include/asm/cputime.h                  |  140 +-
 arch/x86/include/asm/i387.h                      |    2 +-
 drivers/cpufreq/cpufreq_conservative.c           |   50 +-
 drivers/cpufreq/cpufreq_ondemand.c               |   54 +-
 drivers/cpufreq/cpufreq_stats.c                  |    5 +-
 drivers/macintosh/rack-meter.c                   |   14 +-
 fs/proc/array.c                                  |    8 +-
 fs/proc/stat.c                                   |   63 +-
 fs/proc/uptime.c                                 |   11 +-
 include/asm-generic/cputime.h                    |   62 +-
 include/linux/kernel_stat.h                      |   36 +-
 include/linux/latencytop.h                       |    3 +-
 include/linux/sched.h                            |   23 +-
 include/trace/events/sched.h                     |   57 +
 kernel/Makefile                                  |   20 +-
 kernel/acct.c                                    |    4 +-
 kernel/cpu.c                                     |    3 +-
 kernel/exit.c                                    |   22 +-
 kernel/fork.c                                    |   14 +-
 kernel/itimer.c                                  |   15 +-
 kernel/posix-cpu-timers.c                        |  132 +-
 kernel/sched/Makefile                            |   20 +
 kernel/{sched_autogroup.c => sched/auto_group.c} |   33 +-
 kernel/{sched_autogroup.h => sched/auto_group.h} |   26 +-
 kernel/{sched_clock.c => sched/clock.c}          |    0
 kernel/{sched.c => sched/core.c}                 | 2247 +++-------------------
 kernel/{sched_cpupri.c => sched/cpupri.c}        |    4 +-
 kernel/{sched_cpupri.h => sched/cpupri.h}        |    0
 kernel/{sched_debug.c => sched/debug.c}          |    6 +-
 kernel/{sched_fair.c => sched/fair.c}            |  998 ++++++++---
 kernel/{sched_features.h => sched/features.h}    |   30 +-
 kernel/{sched_idletask.c => sched/idle_task.c}   |    4 +-
 kernel/{sched_rt.c => sched/rt.c}                |  218 ++-
 kernel/sched/sched.h                             | 1166 +++++++++++
 kernel/sched/stats.c                             |  111 ++
 kernel/{sched_stats.h => sched/stats.h}          |  109 +-
 kernel/{sched_stoptask.c => sched/stop_task.c}   |    4 +-
 kernel/signal.c                                  |    6 +-
 kernel/sys.c                                     |    6 +-
 kernel/time/tick-sched.c                         |    9 +
 kernel/tsacct.c                                  |    2 +-
 44 files changed, 3076 insertions(+), 2816 deletions(-)
 create mode 100644 kernel/sched/Makefile
 rename kernel/{sched_autogroup.c => sched/auto_group.c} (88%)
 rename kernel/{sched_autogroup.h => sched/auto_group.h} (66%)
 rename kernel/{sched_clock.c => sched/clock.c} (100%)
 rename kernel/{sched.c => sched/core.c} (79%)
 rename kernel/{sched_cpupri.c => sched/cpupri.c} (99%)
 rename kernel/{sched_cpupri.h => sched/cpupri.h} (100%)
 rename kernel/{sched_debug.c => sched/debug.c} (99%)
 rename kernel/{sched_fair.c => sched/fair.c} (87%)
 rename kernel/{sched_features.h => sched/features.h} (75%)
 rename kernel/{sched_idletask.c => sched/idle_task.c} (96%)
 rename kernel/{sched_rt.c => sched/rt.c} (90%)
 create mode 100644 kernel/sched/sched.h
 create mode 100644 kernel/sched/stats.c
 rename kernel/{sched_stats.h => sched/stats.h} (70%)
 rename kernel/{sched_stoptask.c => sched/stop_task.c} (97%)

diff --git a/arch/ia64/include/asm/cputime.h b/arch/ia64/include/asm/cputime.h
index 6073b18..461e52f 100644
--- a/arch/ia64/include/asm/cputime.h
+++ b/arch/ia64/include/asm/cputime.h
@@ -26,59 +26,51 @@
 #include <linux/jiffies.h>
 #include <asm/processor.h>
 
-typedef u64 cputime_t;
-typedef u64 cputime64_t;
+typedef u64 __nocast cputime_t;
+typedef u64 __nocast cputime64_t;
 
-#define cputime_zero			((cputime_t)0)
 #define cputime_one_jiffy		jiffies_to_cputime(1)
-#define cputime_max			((~((cputime_t)0) >> 1) - 1)
-#define cputime_add(__a, __b)		((__a) +  (__b))
-#define cputime_sub(__a, __b)		((__a) -  (__b))
-#define cputime_div(__a, __n)		((__a) /  (__n))
-#define cputime_halve(__a)		((__a) >> 1)
-#define cputime_eq(__a, __b)		((__a) == (__b))
-#define cputime_gt(__a, __b)		((__a) >  (__b))
-#define cputime_ge(__a, __b)		((__a) >= (__b))
-#define cputime_lt(__a, __b)		((__a) <  (__b))
-#define cputime_le(__a, __b)		((__a) <= (__b))
-
-#define cputime64_zero			((cputime64_t)0)
-#define cputime64_add(__a, __b)		((__a) + (__b))
-#define cputime64_sub(__a, __b)		((__a) - (__b))
-#define cputime_to_cputime64(__ct)	(__ct)
 
 /*
  * Convert cputime <-> jiffies (HZ)
  */
-#define cputime_to_jiffies(__ct)	((__ct) / (NSEC_PER_SEC / HZ))
-#define jiffies_to_cputime(__jif)	((__jif) * (NSEC_PER_SEC / HZ))
-#define cputime64_to_jiffies64(__ct)	((__ct) / (NSEC_PER_SEC / HZ))
-#define jiffies64_to_cputime64(__jif)	((__jif) * (NSEC_PER_SEC / HZ))
+#define cputime_to_jiffies(__ct)	\
+	((__force u64)(__ct) / (NSEC_PER_SEC / HZ))
+#define jiffies_to_cputime(__jif)	\
+	(__force cputime_t)((__jif) * (NSEC_PER_SEC / HZ))
+#define cputime64_to_jiffies64(__ct)	\
+	((__force u64)(__ct) / (NSEC_PER_SEC / HZ))
+#define jiffies64_to_cputime64(__jif)	\
+	(__force cputime64_t)((__jif) * (NSEC_PER_SEC / HZ))
 
 /*
  * Convert cputime <-> microseconds
  */
-#define cputime_to_usecs(__ct)		((__ct) / NSEC_PER_USEC)
-#define usecs_to_cputime(__usecs)	((__usecs) * NSEC_PER_USEC)
+#define cputime_to_usecs(__ct)		\
+	((__force u64)(__ct) / NSEC_PER_USEC)
+#define usecs_to_cputime(__usecs)	\
+	(__force cputime_t)((__usecs) * NSEC_PER_USEC)
 
 /*
  * Convert cputime <-> seconds
  */
-#define cputime_to_secs(__ct)		((__ct) / NSEC_PER_SEC)
-#define secs_to_cputime(__secs)		((__secs) * NSEC_PER_SEC)
+#define cputime_to_secs(__ct)		\
+	((__force u64)(__ct) / NSEC_PER_SEC)
+#define secs_to_cputime(__secs)		\
+	(__force cputime_t)((__secs) * NSEC_PER_SEC)
 
 /*
  * Convert cputime <-> timespec (nsec)
  */
 static inline cputime_t timespec_to_cputime(const struct timespec *val)
 {
-	cputime_t ret = val->tv_sec * NSEC_PER_SEC;
-	return (ret + val->tv_nsec);
+	u64 ret = val->tv_sec * NSEC_PER_SEC + val->tv_nsec;
+	return (__force cputime_t) ret;
 }
 static inline void cputime_to_timespec(const cputime_t ct, struct timespec *val)
 {
-	val->tv_sec  = ct / NSEC_PER_SEC;
-	val->tv_nsec = ct % NSEC_PER_SEC;
+	val->tv_sec  = (__force u64) ct / NSEC_PER_SEC;
+	val->tv_nsec = (__force u64) ct % NSEC_PER_SEC;
 }
 
 /*
@@ -86,25 +78,28 @@ static inline void cputime_to_timespec(const cputime_t ct, struct timespec *val)
  */
 static inline cputime_t timeval_to_cputime(struct timeval *val)
 {
-	cputime_t ret = val->tv_sec * NSEC_PER_SEC;
-	return (ret + val->tv_usec * NSEC_PER_USEC);
+	u64 ret = val->tv_sec * NSEC_PER_SEC + val->tv_usec * NSEC_PER_USEC;
+	return (__force cputime_t) ret;
 }
 static inline void cputime_to_timeval(const cputime_t ct, struct timeval *val)
 {
-	val->tv_sec = ct / NSEC_PER_SEC;
-	val->tv_usec = (ct % NSEC_PER_SEC) / NSEC_PER_USEC;
+	val->tv_sec = (__force u64) ct / NSEC_PER_SEC;
+	val->tv_usec = ((__force u64) ct % NSEC_PER_SEC) / NSEC_PER_USEC;
 }
 
 /*
  * Convert cputime <-> clock (USER_HZ)
  */
-#define cputime_to_clock_t(__ct)	((__ct) / (NSEC_PER_SEC / USER_HZ))
-#define clock_t_to_cputime(__x)		((__x) * (NSEC_PER_SEC / USER_HZ))
+#define cputime_to_clock_t(__ct)	\
+	((__force u64)(__ct) / (NSEC_PER_SEC / USER_HZ))
+#define clock_t_to_cputime(__x)		\
+	(__force cputime_t)((__x) * (NSEC_PER_SEC / USER_HZ))
 
 /*
  * Convert cputime64 to clock.
  */
-#define cputime64_to_clock_t(__ct)      cputime_to_clock_t((cputime_t)__ct)
+#define cputime64_to_clock_t(__ct)	\
+	cputime_to_clock_t((__force cputime_t)__ct)
 
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING */
 #endif /* __IA64_CPUTIME_H */
diff --git a/arch/powerpc/include/asm/cputime.h b/arch/powerpc/include/asm/cputime.h
index 1cf20bd..e94935c 100644
--- a/arch/powerpc/include/asm/cputime.h
+++ b/arch/powerpc/include/asm/cputime.h
@@ -29,25 +29,8 @@ static inline void setup_cputime_one_jiffy(void) { }
 #include <asm/time.h>
 #include <asm/param.h>
 
-typedef u64 cputime_t;
-typedef u64 cputime64_t;
-
-#define cputime_zero			((cputime_t)0)
-#define cputime_max			((~((cputime_t)0) >> 1) - 1)
-#define cputime_add(__a, __b)		((__a) +  (__b))
-#define cputime_sub(__a, __b)		((__a) -  (__b))
-#define cputime_div(__a, __n)		((__a) /  (__n))
-#define cputime_halve(__a)		((__a) >> 1)
-#define cputime_eq(__a, __b)		((__a) == (__b))
-#define cputime_gt(__a, __b)		((__a) >  (__b))
-#define cputime_ge(__a, __b)		((__a) >= (__b))
-#define cputime_lt(__a, __b)		((__a) <  (__b))
-#define cputime_le(__a, __b)		((__a) <= (__b))
-
-#define cputime64_zero			((cputime64_t)0)
-#define cputime64_add(__a, __b)		((__a) + (__b))
-#define cputime64_sub(__a, __b)		((__a) - (__b))
-#define cputime_to_cputime64(__ct)	(__ct)
+typedef u64 __nocast cputime_t;
+typedef u64 __nocast cputime64_t;
 
 #ifdef __KERNEL__
 
@@ -65,7 +48,7 @@ DECLARE_PER_CPU(unsigned long, cputime_scaled_last_delta);
 
 static inline unsigned long cputime_to_jiffies(const cputime_t ct)
 {
-	return mulhdu(ct, __cputime_jiffies_factor);
+	return mulhdu((__force u64) ct, __cputime_jiffies_factor);
 }
 
 /* Estimate the scaled cputime by scaling the real cputime based on
@@ -74,14 +57,15 @@ static inline cputime_t cputime_to_scaled(const cputime_t ct)
 {
 	if (cpu_has_feature(CPU_FTR_SPURR) &&
 	    __get_cpu_var(cputime_last_delta))
-		return ct * __get_cpu_var(cputime_scaled_last_delta) /
-			    __get_cpu_var(cputime_last_delta);
+		return (__force u64) ct *
+			__get_cpu_var(cputime_scaled_last_delta) /
+			__get_cpu_var(cputime_last_delta);
 	return ct;
 }
 
 static inline cputime_t jiffies_to_cputime(const unsigned long jif)
 {
-	cputime_t ct;
+	u64 ct;
 	unsigned long sec;
 
 	/* have to be a little careful about overflow */
@@ -93,7 +77,7 @@ static inline cputime_t jiffies_to_cputime(const unsigned long jif)
 	}
 	if (sec)
 		ct += (cputime_t) sec * tb_ticks_per_sec;
-	return ct;
+	return (__force cputime_t) ct;
 }
 
 static inline void setup_cputime_one_jiffy(void)
@@ -103,7 +87,7 @@ static inline void setup_cputime_one_jiffy(void)
 
 static inline cputime64_t jiffies64_to_cputime64(const u64 jif)
 {
-	cputime_t ct;
+	u64 ct;
 	u64 sec;
 
 	/* have to be a little careful about overflow */
@@ -114,13 +98,13 @@ static inline cputime64_t jiffies64_to_cputime64(const u64 jif)
 		do_div(ct, HZ);
 	}
 	if (sec)
-		ct += (cputime_t) sec * tb_ticks_per_sec;
-	return ct;
+		ct += (u64) sec * tb_ticks_per_sec;
+	return (__force cputime64_t) ct;
 }
 
 static inline u64 cputime64_to_jiffies64(const cputime_t ct)
 {
-	return mulhdu(ct, __cputime_jiffies_factor);
+	return mulhdu((__force u64) ct, __cputime_jiffies_factor);
 }
 
 /*
@@ -130,12 +114,12 @@ extern u64 __cputime_msec_factor;
 
 static inline unsigned long cputime_to_usecs(const cputime_t ct)
 {
-	return mulhdu(ct, __cputime_msec_factor) * USEC_PER_MSEC;
+	return mulhdu((__force u64) ct, __cputime_msec_factor) * USEC_PER_MSEC;
 }
 
 static inline cputime_t usecs_to_cputime(const unsigned long us)
 {
-	cputime_t ct;
+	u64 ct;
 	unsigned long sec;
 
 	/* have to be a little careful about overflow */
@@ -147,7 +131,7 @@ static inline cputime_t usecs_to_cputime(const unsigned long us)
 	}
 	if (sec)
 		ct += (cputime_t) sec * tb_ticks_per_sec;
-	return ct;
+	return (__force cputime_t) ct;
 }
 
 /*
@@ -157,12 +141,12 @@ extern u64 __cputime_sec_factor;
 
 static inline unsigned long cputime_to_secs(const cputime_t ct)
 {
-	return mulhdu(ct, __cputime_sec_factor);
+	return mulhdu((__force u64) ct, __cputime_sec_factor);
 }
 
 static inline cputime_t secs_to_cputime(const unsigned long sec)
 {
-	return (cputime_t) sec * tb_ticks_per_sec;
+	return (__force cputime_t)((u64) sec * tb_ticks_per_sec);
 }
 
 /*
@@ -170,7 +154,7 @@ static inline cputime_t secs_to_cputime(const unsigned long sec)
  */
 static inline void cputime_to_timespec(const cputime_t ct, struct timespec *p)
 {
-	u64 x = ct;
+	u64 x = (__force u64) ct;
 	unsigned int frac;
 
 	frac = do_div(x, tb_ticks_per_sec);
@@ -182,11 +166,11 @@ static inline void cputime_to_timespec(const cputime_t ct, struct timespec *p)
 
 static inline cputime_t timespec_to_cputime(const struct timespec *p)
 {
-	cputime_t ct;
+	u64 ct;
 
 	ct = (u64) p->tv_nsec * tb_ticks_per_sec;
 	do_div(ct, 1000000000);
-	return ct + (u64) p->tv_sec * tb_ticks_per_sec;
+	return (__force cputime_t)(ct + (u64) p->tv_sec * tb_ticks_per_sec);
 }
 
 /*
@@ -194,7 +178,7 @@ static inline cputime_t timespec_to_cputime(const struct timespec *p)
  */
 static inline void cputime_to_timeval(const cputime_t ct, struct timeval *p)
 {
-	u64 x = ct;
+	u64 x = (__force u64) ct;
 	unsigned int frac;
 
 	frac = do_div(x, tb_ticks_per_sec);
@@ -206,11 +190,11 @@ static inline void cputime_to_timeval(const cputime_t ct, struct timeval *p)
 
 static inline cputime_t timeval_to_cputime(const struct timeval *p)
 {
-	cputime_t ct;
+	u64 ct;
 
 	ct = (u64) p->tv_usec * tb_ticks_per_sec;
 	do_div(ct, 1000000);
-	return ct + (u64) p->tv_sec * tb_ticks_per_sec;
+	return (__force cputime_t)(ct + (u64) p->tv_sec * tb_ticks_per_sec);
 }
 
 /*
@@ -220,12 +204,12 @@ extern u64 __cputime_clockt_factor;
 
 static inline unsigned long cputime_to_clock_t(const cputime_t ct)
 {
-	return mulhdu(ct, __cputime_clockt_factor);
+	return mulhdu((__force u64) ct, __cputime_clockt_factor);
 }
 
 static inline cputime_t clock_t_to_cputime(const unsigned long clk)
 {
-	cputime_t ct;
+	u64 ct;
 	unsigned long sec;
 
 	/* have to be a little careful about overflow */
@@ -236,8 +220,8 @@ static inline cputime_t clock_t_to_cputime(const unsigned long clk)
 		do_div(ct, USER_HZ);
 	}
 	if (sec)
-		ct += (cputime_t) sec * tb_ticks_per_sec;
-	return ct;
+		ct += (u64) sec * tb_ticks_per_sec;
+	return (__force cputime_t) ct;
 }
 
 #define cputime64_to_clock_t(ct)	cputime_to_clock_t((cputime_t)(ct))
diff --git a/arch/s390/appldata/appldata_os.c b/arch/s390/appldata/appldata_os.c
index 92f1cb7..4de031d 100644
--- a/arch/s390/appldata/appldata_os.c
+++ b/arch/s390/appldata/appldata_os.c
@@ -115,21 +115,21 @@ static void appldata_get_os_data(void *data)
 	j = 0;
 	for_each_online_cpu(i) {
 		os_data->os_cpu[j].per_cpu_user =
-			cputime_to_jiffies(kstat_cpu(i).cpustat.user);
+			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_USER]);
 		os_data->os_cpu[j].per_cpu_nice =
-			cputime_to_jiffies(kstat_cpu(i).cpustat.nice);
+			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_NICE]);
 		os_data->os_cpu[j].per_cpu_system =
-			cputime_to_jiffies(kstat_cpu(i).cpustat.system);
+			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM]);
 		os_data->os_cpu[j].per_cpu_idle =
-			cputime_to_jiffies(kstat_cpu(i).cpustat.idle);
+			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_IDLE]);
 		os_data->os_cpu[j].per_cpu_irq =
-			cputime_to_jiffies(kstat_cpu(i).cpustat.irq);
+			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_IRQ]);
 		os_data->os_cpu[j].per_cpu_softirq =
-			cputime_to_jiffies(kstat_cpu(i).cpustat.softirq);
+			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ]);
 		os_data->os_cpu[j].per_cpu_iowait =
-			cputime_to_jiffies(kstat_cpu(i).cpustat.iowait);
+			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_IOWAIT]);
 		os_data->os_cpu[j].per_cpu_steal =
-			cputime_to_jiffies(kstat_cpu(i).cpustat.steal);
+			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_STEAL]);
 		os_data->os_cpu[j].cpu_id = i;
 		j++;
 	}
diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
index 0814348..0887a04 100644
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -16,114 +16,98 @@
 
 /* We want to use full resolution of the CPU timer: 2**-12 micro-seconds. */
 
-typedef unsigned long long cputime_t;
-typedef unsigned long long cputime64_t;
+typedef unsigned long long __nocast cputime_t;
+typedef unsigned long long __nocast cputime64_t;
 
-#ifndef __s390x__
-
-static inline unsigned int
-__div(unsigned long long n, unsigned int base)
+static inline unsigned long __div(unsigned long long n, unsigned long base)
 {
+#ifndef __s390x__
 	register_pair rp;
 
 	rp.pair = n >> 1;
 	asm ("dr %0,%1" : "+d" (rp) : "d" (base >> 1));
 	return rp.subreg.odd;
+#else /* __s390x__ */
+	return n / base;
+#endif /* __s390x__ */
 }
 
-#else /* __s390x__ */
+#define cputime_one_jiffy		jiffies_to_cputime(1)
 
-static inline unsigned int
-__div(unsigned long long n, unsigned int base)
+/*
+ * Convert cputime to jiffies and back.
+ */
+static inline unsigned long cputime_to_jiffies(const cputime_t cputime)
 {
-	return n / base;
+	return __div((__force unsigned long long) cputime, 4096000000ULL / HZ);
 }
 
-#endif /* __s390x__ */
+static inline cputime_t jiffies_to_cputime(const unsigned int jif)
+{
+	return (__force cputime_t)(jif * (4096000000ULL / HZ));
+}
 
-#define cputime_zero			(0ULL)
-#define cputime_one_jiffy		jiffies_to_cputime(1)
-#define cputime_max			((~0UL >> 1) - 1)
-#define cputime_add(__a, __b)		((__a) +  (__b))
-#define cputime_sub(__a, __b)		((__a) -  (__b))
-#define cputime_div(__a, __n) ({		\
-	unsigned long long __div = (__a);	\
-	do_div(__div,__n);			\
-	__div;					\
-})
-#define cputime_halve(__a)		((__a) >> 1)
-#define cputime_eq(__a, __b)		((__a) == (__b))
-#define cputime_gt(__a, __b)		((__a) >  (__b))
-#define cputime_ge(__a, __b)		((__a) >= (__b))
-#define cputime_lt(__a, __b)		((__a) <  (__b))
-#define cputime_le(__a, __b)		((__a) <= (__b))
-#define cputime_to_jiffies(__ct)	(__div((__ct), 4096000000ULL / HZ))
-#define cputime_to_scaled(__ct)		(__ct)
-#define jiffies_to_cputime(__hz)	((cputime_t)(__hz) * (4096000000ULL / HZ))
-
-#define cputime64_zero			(0ULL)
-#define cputime64_add(__a, __b)		((__a) + (__b))
-#define cputime_to_cputime64(__ct)	(__ct)
-
-static inline u64
-cputime64_to_jiffies64(cputime64_t cputime)
-{
-	do_div(cputime, 4096000000ULL / HZ);
-	return cputime;
+static inline u64 cputime64_to_jiffies64(cputime64_t cputime)
+{
+	unsigned long long jif = (__force unsigned long long) cputime;
+	do_div(jif, 4096000000ULL / HZ);
+	return jif;
+}
+
+static inline cputime64_t jiffies64_to_cputime64(const u64 jif)
+{
+	return (__force cputime64_t)(jif * (4096000000ULL / HZ));
 }
 
 /*
  * Convert cputime to microseconds and back.
  */
-static inline unsigned int
-cputime_to_usecs(const cputime_t cputime)
+static inline unsigned int cputime_to_usecs(const cputime_t cputime)
 {
-	return cputime_div(cputime, 4096);
+	return (__force unsigned long long) cputime >> 12;
 }
 
-static inline cputime_t
-usecs_to_cputime(const unsigned int m)
+static inline cputime_t usecs_to_cputime(const unsigned int m)
 {
-	return (cputime_t) m * 4096;
+	return (__force cputime_t)(m * 4096ULL);
 }
 
 /*
  * Convert cputime to milliseconds and back.
  */
-static inline unsigned int
-cputime_to_secs(const cputime_t cputime)
+static inline unsigned int cputime_to_secs(const cputime_t cputime)
 {
-	return __div(cputime, 2048000000) >> 1;
+	return __div((__force unsigned long long) cputime, 2048000000) >> 1;
 }
 
-static inline cputime_t
-secs_to_cputime(const unsigned int s)
+static inline cputime_t secs_to_cputime(const unsigned int s)
 {
-	return (cputime_t) s * 4096000000ULL;
+	return (__force cputime_t)(s * 4096000000ULL);
 }
 
 /*
  * Convert cputime to timespec and back.
  */
-static inline cputime_t
-timespec_to_cputime(const struct timespec *value)
+static inline cputime_t timespec_to_cputime(const struct timespec *value)
 {
-	return value->tv_nsec * 4096 / 1000 + (u64) value->tv_sec * 4096000000ULL;
+	unsigned long long ret = value->tv_sec * 4096000000ULL;
+	return (__force cputime_t)(ret + value->tv_nsec * 4096 / 1000);
 }
 
-static inline void
-cputime_to_timespec(const cputime_t cputime, struct timespec *value)
+static inline void cputime_to_timespec(const cputime_t cputime,
+				       struct timespec *value)
 {
+	unsigned long long __cputime = (__force unsigned long long) cputime;
 #ifndef __s390x__
 	register_pair rp;
 
-	rp.pair = cputime >> 1;
+	rp.pair = __cputime >> 1;
 	asm ("dr %0,%1" : "+d" (rp) : "d" (2048000000UL));
 	value->tv_nsec = rp.subreg.even * 1000 / 4096;
 	value->tv_sec = rp.subreg.odd;
 #else
-	value->tv_nsec = (cputime % 4096000000ULL) * 1000 / 4096;
-	value->tv_sec = cputime / 4096000000ULL;
+	value->tv_nsec = (__cputime % 4096000000ULL) * 1000 / 4096;
+	value->tv_sec = __cputime / 4096000000ULL;
 #endif
 }
 
@@ -132,50 +116,52 @@ cputime_to_timespec(const cputime_t cputime, struct timespec *value)
  * Since cputime and timeval have the same resolution (microseconds)
  * this is easy.
  */
-static inline cputime_t
-timeval_to_cputime(const struct timeval *value)
+static inline cputime_t timeval_to_cputime(const struct timeval *value)
 {
-	return value->tv_usec * 4096 + (u64) value->tv_sec * 4096000000ULL;
+	unsigned long long ret = value->tv_sec * 4096000000ULL;
+	return (__force cputime_t)(ret + value->tv_usec * 4096ULL);
 }
 
-static inline void
-cputime_to_timeval(const cputime_t cputime, struct timeval *value)
+static inline void cputime_to_timeval(const cputime_t cputime,
+				      struct timeval *value)
 {
+	unsigned long long __cputime = (__force unsigned long long) cputime;
 #ifndef __s390x__
 	register_pair rp;
 
-	rp.pair = cputime >> 1;
+	rp.pair = __cputime >> 1;
 	asm ("dr %0,%1" : "+d" (rp) : "d" (2048000000UL));
 	value->tv_usec = rp.subreg.even / 4096;
 	value->tv_sec = rp.subreg.odd;
 #else
-	value->tv_usec = (cputime % 4096000000ULL) / 4096;
-	value->tv_sec = cputime / 4096000000ULL;
+	value->tv_usec = (__cputime % 4096000000ULL) / 4096;
+	value->tv_sec = __cputime / 4096000000ULL;
 #endif
 }
 
 /*
  * Convert cputime to clock and back.
  */
-static inline clock_t
-cputime_to_clock_t(cputime_t cputime)
+static inline clock_t cputime_to_clock_t(cputime_t cputime)
 {
-	return cputime_div(cputime, 4096000000ULL / USER_HZ);
+	unsigned long long clock = (__force unsigned long long) cputime;
+	do_div(clock, 4096000000ULL / USER_HZ);
+	return clock;
 }
 
-static inline cputime_t
-clock_t_to_cputime(unsigned long x)
+static inline cputime_t clock_t_to_cputime(unsigned long x)
 {
-	return (cputime_t) x * (4096000000ULL / USER_HZ);
+	return (__force cputime_t)(x * (4096000000ULL / USER_HZ));
 }
 
 /*
  * Convert cputime64 to clock.
  */
-static inline clock_t
-cputime64_to_clock_t(cputime64_t cputime)
+static inline clock_t cputime64_to_clock_t(cputime64_t cputime)
 {
-       return cputime_div(cputime, 4096000000ULL / USER_HZ);
+	unsigned long long clock = (__force unsigned long long) cputime;
+	do_div(clock, 4096000000ULL / USER_HZ);
+	return clock;
 }
 
 struct s390_idle_data {
diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index c9e09ea..6919e93 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -218,7 +218,7 @@ static inline void fpu_fxsave(struct fpu *fpu)
 #ifdef CONFIG_SMP
 #define safe_address (__per_cpu_offset[0])
 #else
-#define safe_address (kstat_cpu(0).cpustat.user)
+#define safe_address (__get_cpu_var(kernel_cpustat).cpustat[CPUTIME_USER])
 #endif
 
 /*
diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index c97b468..235a340 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -95,27 +95,26 @@ static struct dbs_tuners {
 	.freq_step = 5,
 };
 
-static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
-							cputime64_t *wall)
+static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
 {
-	cputime64_t idle_time;
-	cputime64_t cur_wall_time;
-	cputime64_t busy_time;
+	u64 idle_time;
+	u64 cur_wall_time;
+	u64 busy_time;
 
 	cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
-	busy_time = cputime64_add(kstat_cpu(cpu).cpustat.user,
-			kstat_cpu(cpu).cpustat.system);
 
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.irq);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.softirq);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.steal);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.nice);
+	busy_time  = kcpustat_cpu(cpu).cpustat[CPUTIME_USER];
+	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SYSTEM];
+	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_IRQ];
+	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SOFTIRQ];
+	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_STEAL];
+	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_NICE];
 
-	idle_time = cputime64_sub(cur_wall_time, busy_time);
+	idle_time = cur_wall_time - busy_time;
 	if (wall)
-		*wall = (cputime64_t)jiffies_to_usecs(cur_wall_time);
+		*wall = jiffies_to_usecs(cur_wall_time);
 
-	return (cputime64_t)jiffies_to_usecs(idle_time);
+	return jiffies_to_usecs(idle_time);
 }
 
 static inline cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t *wall)
@@ -272,7 +271,7 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
 		dbs_info->prev_cpu_idle = get_cpu_idle_time(j,
 						&dbs_info->prev_cpu_wall);
 		if (dbs_tuners_ins.ignore_nice)
-			dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
+			dbs_info->prev_cpu_nice = kcpustat_cpu(j).cpustat[CPUTIME_NICE];
 	}
 	return count;
 }
@@ -353,20 +352,20 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 
 		cur_idle_time = get_cpu_idle_time(j, &cur_wall_time);
 
-		wall_time = (unsigned int) cputime64_sub(cur_wall_time,
-				j_dbs_info->prev_cpu_wall);
+		wall_time = (unsigned int)
+			(cur_wall_time - j_dbs_info->prev_cpu_wall);
 		j_dbs_info->prev_cpu_wall = cur_wall_time;
 
-		idle_time = (unsigned int) cputime64_sub(cur_idle_time,
-				j_dbs_info->prev_cpu_idle);
+		idle_time = (unsigned int)
+			(cur_idle_time - j_dbs_info->prev_cpu_idle);
 		j_dbs_info->prev_cpu_idle = cur_idle_time;
 
 		if (dbs_tuners_ins.ignore_nice) {
-			cputime64_t cur_nice;
+			u64 cur_nice;
 			unsigned long cur_nice_jiffies;
 
-			cur_nice = cputime64_sub(kstat_cpu(j).cpustat.nice,
-					 j_dbs_info->prev_cpu_nice);
+			cur_nice = kcpustat_cpu(j).cpustat[CPUTIME_NICE] -
+					 j_dbs_info->prev_cpu_nice;
 			/*
 			 * Assumption: nice time between sampling periods will
 			 * be less than 2^32 jiffies for 32 bit sys
@@ -374,7 +373,7 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 			cur_nice_jiffies = (unsigned long)
 					cputime64_to_jiffies64(cur_nice);
 
-			j_dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
+			j_dbs_info->prev_cpu_nice = kcpustat_cpu(j).cpustat[CPUTIME_NICE];
 			idle_time += jiffies_to_usecs(cur_nice_jiffies);
 		}
 
@@ -501,10 +500,9 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 
 			j_dbs_info->prev_cpu_idle = get_cpu_idle_time(j,
 						&j_dbs_info->prev_cpu_wall);
-			if (dbs_tuners_ins.ignore_nice) {
+			if (dbs_tuners_ins.ignore_nice)
 				j_dbs_info->prev_cpu_nice =
-						kstat_cpu(j).cpustat.nice;
-			}
+						kcpustat_cpu(j).cpustat[CPUTIME_NICE];
 		}
 		this_dbs_info->down_skip = 0;
 		this_dbs_info->requested_freq = policy->cur;
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index fa8af4e..3d679ee 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -119,27 +119,26 @@ static struct dbs_tuners {
 	.powersave_bias = 0,
 };
 
-static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
-							cputime64_t *wall)
+static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
 {
-	cputime64_t idle_time;
-	cputime64_t cur_wall_time;
-	cputime64_t busy_time;
+	u64 idle_time;
+	u64 cur_wall_time;
+	u64 busy_time;
 
 	cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
-	busy_time = cputime64_add(kstat_cpu(cpu).cpustat.user,
-			kstat_cpu(cpu).cpustat.system);
 
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.irq);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.softirq);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.steal);
-	busy_time = cputime64_add(busy_time, kstat_cpu(cpu).cpustat.nice);
+	busy_time  = kcpustat_cpu(cpu).cpustat[CPUTIME_USER];
+	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SYSTEM];
+	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_IRQ];
+	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SOFTIRQ];
+	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_STEAL];
+	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_NICE];
 
-	idle_time = cputime64_sub(cur_wall_time, busy_time);
+	idle_time = cur_wall_time - busy_time;
 	if (wall)
-		*wall = (cputime64_t)jiffies_to_usecs(cur_wall_time);
+		*wall = jiffies_to_usecs(cur_wall_time);
 
-	return (cputime64_t)jiffies_to_usecs(idle_time);
+	return jiffies_to_usecs(idle_time);
 }
 
 static inline cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t *wall)
@@ -345,7 +344,7 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
 		dbs_info->prev_cpu_idle = get_cpu_idle_time(j,
 						&dbs_info->prev_cpu_wall);
 		if (dbs_tuners_ins.ignore_nice)
-			dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
+			dbs_info->prev_cpu_nice = kcpustat_cpu(j).cpustat[CPUTIME_NICE];
 
 	}
 	return count;
@@ -442,24 +441,24 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 		cur_idle_time = get_cpu_idle_time(j, &cur_wall_time);
 		cur_iowait_time = get_cpu_iowait_time(j, &cur_wall_time);
 
-		wall_time = (unsigned int) cputime64_sub(cur_wall_time,
-				j_dbs_info->prev_cpu_wall);
+		wall_time = (unsigned int)
+			(cur_wall_time - j_dbs_info->prev_cpu_wall);
 		j_dbs_info->prev_cpu_wall = cur_wall_time;
 
-		idle_time = (unsigned int) cputime64_sub(cur_idle_time,
-				j_dbs_info->prev_cpu_idle);
+		idle_time = (unsigned int)
+			(cur_idle_time - j_dbs_info->prev_cpu_idle);
 		j_dbs_info->prev_cpu_idle = cur_idle_time;
 
-		iowait_time = (unsigned int) cputime64_sub(cur_iowait_time,
-				j_dbs_info->prev_cpu_iowait);
+		iowait_time = (unsigned int)
+			(cur_iowait_time - j_dbs_info->prev_cpu_iowait);
 		j_dbs_info->prev_cpu_iowait = cur_iowait_time;
 
 		if (dbs_tuners_ins.ignore_nice) {
-			cputime64_t cur_nice;
+			u64 cur_nice;
 			unsigned long cur_nice_jiffies;
 
-			cur_nice = cputime64_sub(kstat_cpu(j).cpustat.nice,
-					 j_dbs_info->prev_cpu_nice);
+			cur_nice = kcpustat_cpu(j).cpustat[CPUTIME_NICE] -
+					 j_dbs_info->prev_cpu_nice;
 			/*
 			 * Assumption: nice time between sampling periods will
 			 * be less than 2^32 jiffies for 32 bit sys
@@ -467,7 +466,7 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 			cur_nice_jiffies = (unsigned long)
 					cputime64_to_jiffies64(cur_nice);
 
-			j_dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
+			j_dbs_info->prev_cpu_nice = kcpustat_cpu(j).cpustat[CPUTIME_NICE];
 			idle_time += jiffies_to_usecs(cur_nice_jiffies);
 		}
 
@@ -646,10 +645,9 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 
 			j_dbs_info->prev_cpu_idle = get_cpu_idle_time(j,
 						&j_dbs_info->prev_cpu_wall);
-			if (dbs_tuners_ins.ignore_nice) {
+			if (dbs_tuners_ins.ignore_nice)
 				j_dbs_info->prev_cpu_nice =
-						kstat_cpu(j).cpustat.nice;
-			}
+						kcpustat_cpu(j).cpustat[CPUTIME_NICE];
 		}
 		this_dbs_info->cpu = cpu;
 		this_dbs_info->rate_mult = 1;
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index c5072a9..2a508ed 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -61,9 +61,8 @@ static int cpufreq_stats_update(unsigned int cpu)
 	spin_lock(&cpufreq_stats_lock);
 	stat = per_cpu(cpufreq_stats_table, cpu);
 	if (stat->time_in_state)
-		stat->time_in_state[stat->last_index] =
-			cputime64_add(stat->time_in_state[stat->last_index],
-				      cputime_sub(cur_time, stat->last_time));
+		stat->time_in_state[stat->last_index] +=
+			cur_time - stat->last_time;
 	stat->last_time = cur_time;
 	spin_unlock(&cpufreq_stats_lock);
 	return 0;
diff --git a/drivers/macintosh/rack-meter.c b/drivers/macintosh/rack-meter.c
index 2637c13..6dc26b6 100644
--- a/drivers/macintosh/rack-meter.c
+++ b/drivers/macintosh/rack-meter.c
@@ -81,13 +81,13 @@ static int rackmeter_ignore_nice;
  */
 static inline cputime64_t get_cpu_idle_time(unsigned int cpu)
 {
-	cputime64_t retval;
+	u64 retval;
 
-	retval = cputime64_add(kstat_cpu(cpu).cpustat.idle,
-			kstat_cpu(cpu).cpustat.iowait);
+	retval = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE] +
+		 kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
 
 	if (rackmeter_ignore_nice)
-		retval = cputime64_add(retval, kstat_cpu(cpu).cpustat.nice);
+		retval += kcpustat_cpu(cpu).cpustat[CPUTIME_NICE];
 
 	return retval;
 }
@@ -220,13 +220,11 @@ static void rackmeter_do_timer(struct work_struct *work)
 	int i, offset, load, cumm, pause;
 
 	cur_jiffies = jiffies64_to_cputime64(get_jiffies_64());
-	total_ticks = (unsigned int)cputime64_sub(cur_jiffies,
-						  rcpu->prev_wall);
+	total_ticks = (unsigned int) (cur_jiffies - rcpu->prev_wall);
 	rcpu->prev_wall = cur_jiffies;
 
 	total_idle_ticks = get_cpu_idle_time(cpu);
-	idle_ticks = (unsigned int) cputime64_sub(total_idle_ticks,
-				rcpu->prev_idle);
+	idle_ticks = (unsigned int) (total_idle_ticks - rcpu->prev_idle);
 	rcpu->prev_idle = total_idle_ticks;
 
 	/* We do a very dumb calculation to update the LEDs for now,
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 3a1dafd..8c344f0 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -394,8 +394,8 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 
 	sigemptyset(&sigign);
 	sigemptyset(&sigcatch);
-	cutime = cstime = utime = stime = cputime_zero;
-	cgtime = gtime = cputime_zero;
+	cutime = cstime = utime = stime = 0;
+	cgtime = gtime = 0;
 
 	if (lock_task_sighand(task, &flags)) {
 		struct signal_struct *sig = task->signal;
@@ -423,14 +423,14 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 			do {
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
-				gtime = cputime_add(gtime, t->gtime);
+				gtime += t->gtime;
 				t = next_thread(t);
 			} while (t != task);
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
 			thread_group_times(task, &utime, &stime);
-			gtime = cputime_add(gtime, sig->gtime);
+			gtime += sig->gtime;
 		}
 
 		sid = task_session_nr_ns(task, ns);
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 2a30d67..2527a68 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -22,29 +22,27 @@
 #define arch_idle_time(cpu) 0
 #endif
 
-static cputime64_t get_idle_time(int cpu)
+static u64 get_idle_time(int cpu)
 {
-	u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
-	cputime64_t idle;
+	u64 idle, idle_time = get_cpu_idle_time_us(cpu, NULL);
 
 	if (idle_time == -1ULL) {
 		/* !NO_HZ so we can rely on cpustat.idle */
-		idle = kstat_cpu(cpu).cpustat.idle;
-		idle = cputime64_add(idle, arch_idle_time(cpu));
+		idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
+		idle += arch_idle_time(cpu);
 	} else
 		idle = nsecs_to_jiffies64(1000 * idle_time);
 
 	return idle;
 }
 
-static cputime64_t get_iowait_time(int cpu)
+static u64 get_iowait_time(int cpu)
 {
-	u64 iowait_time = get_cpu_iowait_time_us(cpu, NULL);
-	cputime64_t iowait;
+	u64 iowait, iowait_time = get_cpu_iowait_time_us(cpu, NULL);
 
 	if (iowait_time == -1ULL)
 		/* !NO_HZ so we can rely on cpustat.iowait */
-		iowait = kstat_cpu(cpu).cpustat.iowait;
+		iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
 	else
 		iowait = nsecs_to_jiffies64(1000 * iowait_time);
 
@@ -55,33 +53,30 @@ static int show_stat(struct seq_file *p, void *v)
 {
 	int i, j;
 	unsigned long jif;
-	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
-	cputime64_t guest, guest_nice;
+	u64 user, nice, system, idle, iowait, irq, softirq, steal;
+	u64 guest, guest_nice;
 	u64 sum = 0;
 	u64 sum_softirq = 0;
 	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
 	struct timespec boottime;
 
 	user = nice = system = idle = iowait =
-		irq = softirq = steal = cputime64_zero;
-	guest = guest_nice = cputime64_zero;
+		irq = softirq = steal = 0;
+	guest = guest_nice = 0;
 	getboottime(&boottime);
 	jif = boottime.tv_sec;
 
 	for_each_possible_cpu(i) {
-		user = cputime64_add(user, kstat_cpu(i).cpustat.user);
-		nice = cputime64_add(nice, kstat_cpu(i).cpustat.nice);
-		system = cputime64_add(system, kstat_cpu(i).cpustat.system);
-		idle = cputime64_add(idle, get_idle_time(i));
-		iowait = cputime64_add(iowait, get_iowait_time(i));
-		irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
-		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
-		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
-		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
-		guest_nice = cputime64_add(guest_nice,
-			kstat_cpu(i).cpustat.guest_nice);
-		sum += kstat_cpu_irqs_sum(i);
-		sum += arch_irq_stat_cpu(i);
+		user += kcpustat_cpu(i).cpustat[CPUTIME_USER];
+		nice += kcpustat_cpu(i).cpustat[CPUTIME_NICE];
+		system += kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM];
+		idle += get_idle_time(i);
+		iowait += get_iowait_time(i);
+		irq += kcpustat_cpu(i).cpustat[CPUTIME_IRQ];
+		softirq += kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ];
+		steal += kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
+		guest += kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
+		guest_nice += kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
 
 		for (j = 0; j < NR_SOFTIRQS; j++) {
 			unsigned int softirq_stat = kstat_softirqs_cpu(j, i);
@@ -106,16 +101,16 @@ static int show_stat(struct seq_file *p, void *v)
 		(unsigned long long)cputime64_to_clock_t(guest_nice));
 	for_each_online_cpu(i) {
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
-		user = kstat_cpu(i).cpustat.user;
-		nice = kstat_cpu(i).cpustat.nice;
-		system = kstat_cpu(i).cpustat.system;
+		user = kcpustat_cpu(i).cpustat[CPUTIME_USER];
+		nice = kcpustat_cpu(i).cpustat[CPUTIME_NICE];
+		system = kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM];
 		idle = get_idle_time(i);
 		iowait = get_iowait_time(i);
-		irq = kstat_cpu(i).cpustat.irq;
-		softirq = kstat_cpu(i).cpustat.softirq;
-		steal = kstat_cpu(i).cpustat.steal;
-		guest = kstat_cpu(i).cpustat.guest;
-		guest_nice = kstat_cpu(i).cpustat.guest_nice;
+		irq = kcpustat_cpu(i).cpustat[CPUTIME_IRQ];
+		softirq = kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ];
+		steal = kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
+		guest = kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
+		guest_nice = kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
 		seq_printf(p,
 			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu "
 			"%llu\n",
diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
index 766b1d4..9610ac7 100644
--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@ -11,15 +11,20 @@ static int uptime_proc_show(struct seq_file *m, void *v)
 {
 	struct timespec uptime;
 	struct timespec idle;
+	u64 idletime;
+	u64 nsec;
+	u32 rem;
 	int i;
-	cputime_t idletime = cputime_zero;
 
+	idletime = 0;
 	for_each_possible_cpu(i)
-		idletime = cputime64_add(idletime, kstat_cpu(i).cpustat.idle);
+		idletime += (__force u64) kcpustat_cpu(i).cpustat[CPUTIME_IDLE];
 
 	do_posix_clock_monotonic_gettime(&uptime);
 	monotonic_to_bootbased(&uptime);
-	cputime_to_timespec(idletime, &idle);
+	nsec = cputime64_to_jiffies64(idletime) * TICK_NSEC;
+	idle.tv_sec = div_u64_rem(nsec, NSEC_PER_SEC, &rem);
+	idle.tv_nsec = rem;
 	seq_printf(m, "%lu.%02lu %lu.%02lu\n",
 			(unsigned long) uptime.tv_sec,
 			(uptime.tv_nsec / (NSEC_PER_SEC / 100)),
diff --git a/include/asm-generic/cputime.h b/include/asm-generic/cputime.h
index 62ce682..77202e2 100644
--- a/include/asm-generic/cputime.h
+++ b/include/asm-generic/cputime.h
@@ -4,70 +4,64 @@
 #include <linux/time.h>
 #include <linux/jiffies.h>
 
-typedef unsigned long cputime_t;
+typedef unsigned long __nocast cputime_t;
 
-#define cputime_zero			(0UL)
 #define cputime_one_jiffy		jiffies_to_cputime(1)
-#define cputime_max			((~0UL >> 1) - 1)
-#define cputime_add(__a, __b)		((__a) +  (__b))
-#define cputime_sub(__a, __b)		((__a) -  (__b))
-#define cputime_div(__a, __n)		((__a) /  (__n))
-#define cputime_halve(__a)		((__a) >> 1)
-#define cputime_eq(__a, __b)		((__a) == (__b))
-#define cputime_gt(__a, __b)		((__a) >  (__b))
-#define cputime_ge(__a, __b)		((__a) >= (__b))
-#define cputime_lt(__a, __b)		((__a) <  (__b))
-#define cputime_le(__a, __b)		((__a) <= (__b))
-#define cputime_to_jiffies(__ct)	(__ct)
+#define cputime_to_jiffies(__ct)	(__force unsigned long)(__ct)
 #define cputime_to_scaled(__ct)		(__ct)
-#define jiffies_to_cputime(__hz)	(__hz)
+#define jiffies_to_cputime(__hz)	(__force cputime_t)(__hz)
 
-typedef u64 cputime64_t;
+typedef u64 __nocast cputime64_t;
 
-#define cputime64_zero (0ULL)
-#define cputime64_add(__a, __b)		((__a) + (__b))
-#define cputime64_sub(__a, __b)		((__a) - (__b))
-#define cputime64_to_jiffies64(__ct)	(__ct)
-#define jiffies64_to_cputime64(__jif)	(__jif)
-#define cputime_to_cputime64(__ct)	((u64) __ct)
-#define cputime64_gt(__a, __b)		((__a) >  (__b))
+#define cputime64_to_jiffies64(__ct)	(__force u64)(__ct)
+#define jiffies64_to_cputime64(__jif)	(__force cputime64_t)(__jif)
 
-#define nsecs_to_cputime64(__ct)	nsecs_to_jiffies64(__ct)
+#define nsecs_to_cputime64(__ct)	\
+	jiffies64_to_cputime64(nsecs_to_jiffies64(__ct))
 
 
 /*
  * Convert cputime to microseconds and back.
  */
-#define cputime_to_usecs(__ct)		jiffies_to_usecs(__ct)
-#define usecs_to_cputime(__msecs)	usecs_to_jiffies(__msecs)
+#define cputime_to_usecs(__ct)		\
+	jiffies_to_usecs(cputime_to_jiffies(__ct));
+#define usecs_to_cputime(__msecs)	\
+	jiffies_to_cputime(usecs_to_jiffies(__msecs));
 
 /*
  * Convert cputime to seconds and back.
  */
-#define cputime_to_secs(jif)		((jif) / HZ)
-#define secs_to_cputime(sec)		((sec) * HZ)
+#define cputime_to_secs(jif)		(cputime_to_jiffies(jif) / HZ)
+#define secs_to_cputime(sec)		jiffies_to_cputime((sec) * HZ)
 
 /*
  * Convert cputime to timespec and back.
  */
-#define timespec_to_cputime(__val)	timespec_to_jiffies(__val)
-#define cputime_to_timespec(__ct,__val)	jiffies_to_timespec(__ct,__val)
+#define timespec_to_cputime(__val)	\
+	jiffies_to_cputime(timespec_to_jiffies(__val))
+#define cputime_to_timespec(__ct,__val)	\
+	jiffies_to_timespec(cputime_to_jiffies(__ct),__val)
 
 /*
  * Convert cputime to timeval and back.
  */
-#define timeval_to_cputime(__val)	timeval_to_jiffies(__val)
-#define cputime_to_timeval(__ct,__val)	jiffies_to_timeval(__ct,__val)
+#define timeval_to_cputime(__val)	\
+	jiffies_to_cputime(timeval_to_jiffies(__val))
+#define cputime_to_timeval(__ct,__val)	\
+	jiffies_to_timeval(cputime_to_jiffies(__ct),__val)
 
 /*
  * Convert cputime to clock and back.
  */
-#define cputime_to_clock_t(__ct)	jiffies_to_clock_t(__ct)
-#define clock_t_to_cputime(__x)		clock_t_to_jiffies(__x)
+#define cputime_to_clock_t(__ct)	\
+	jiffies_to_clock_t(cputime_to_jiffies(__ct))
+#define clock_t_to_cputime(__x)		\
+	jiffies_to_cputime(clock_t_to_jiffies(__x))
 
 /*
  * Convert cputime64 to clock.
  */
-#define cputime64_to_clock_t(__ct)	jiffies_64_to_clock_t(__ct)
+#define cputime64_to_clock_t(__ct)	\
+	jiffies_64_to_clock_t(cputime64_to_jiffies64(__ct))
 
 #endif
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 0cce2db..2fbd905 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -6,6 +6,7 @@
 #include <linux/percpu.h>
 #include <linux/cpumask.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <asm/irq.h>
 #include <asm/cputime.h>
 
@@ -15,21 +16,25 @@
  * used by rstatd/perfmeter
  */
 
-struct cpu_usage_stat {
-	cputime64_t user;
-	cputime64_t nice;
-	cputime64_t system;
-	cputime64_t softirq;
-	cputime64_t irq;
-	cputime64_t idle;
-	cputime64_t iowait;
-	cputime64_t steal;
-	cputime64_t guest;
-	cputime64_t guest_nice;
+enum cpu_usage_stat {
+	CPUTIME_USER,
+	CPUTIME_NICE,
+	CPUTIME_SYSTEM,
+	CPUTIME_SOFTIRQ,
+	CPUTIME_IRQ,
+	CPUTIME_IDLE,
+	CPUTIME_IOWAIT,
+	CPUTIME_STEAL,
+	CPUTIME_GUEST,
+	CPUTIME_GUEST_NICE,
+	NR_STATS,
+};
+
+struct kernel_cpustat {
+	u64 cpustat[NR_STATS];
 };
 
 struct kernel_stat {
-	struct cpu_usage_stat	cpustat;
 #ifndef CONFIG_GENERIC_HARDIRQS
        unsigned int irqs[NR_IRQS];
 #endif
@@ -38,10 +43,13 @@ struct kernel_stat {
 };
 
 DECLARE_PER_CPU(struct kernel_stat, kstat);
+DECLARE_PER_CPU(struct kernel_cpustat, kernel_cpustat);
 
-#define kstat_cpu(cpu)	per_cpu(kstat, cpu)
 /* Must have preemption disabled for this to be meaningful. */
-#define kstat_this_cpu	__get_cpu_var(kstat)
+#define kstat_this_cpu (&__get_cpu_var(kstat))
+#define kcpustat_this_cpu (&__get_cpu_var(kernel_cpustat))
+#define kstat_cpu(cpu) per_cpu(kstat, cpu)
+#define kcpustat_cpu(cpu) per_cpu(kernel_cpustat, cpu)
 
 extern unsigned long long nr_context_switches(void);
 
diff --git a/include/linux/latencytop.h b/include/linux/latencytop.h
index b0e9989..e23121f 100644
--- a/include/linux/latencytop.h
+++ b/include/linux/latencytop.h
@@ -10,6 +10,8 @@
 #define _INCLUDE_GUARD_LATENCYTOP_H_
 
 #include <linux/compiler.h>
+struct task_struct;
+
 #ifdef CONFIG_LATENCYTOP
 
 #define LT_SAVECOUNT		32
@@ -23,7 +25,6 @@ struct latency_record {
 };
 
 
-struct task_struct;
 
 extern int latencytop_enabled;
 void __account_scheduler_latency(struct task_struct *task, int usecs, int inter);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1c4f3e9..5a2ab3c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -273,9 +273,11 @@ extern int runqueue_is_locked(int cpu);
 
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
 extern void select_nohz_load_balancer(int stop_tick);
+extern void set_cpu_sd_state_idle(void);
 extern int get_nohz_timer_target(void);
 #else
 static inline void select_nohz_load_balancer(int stop_tick) { }
+static inline void set_cpu_sd_state_idle(void) { }
 #endif
 
 /*
@@ -483,8 +485,8 @@ struct task_cputime {
 
 #define INIT_CPUTIME	\
 	(struct task_cputime) {					\
-		.utime = cputime_zero,				\
-		.stime = cputime_zero,				\
+		.utime = 0,					\
+		.stime = 0,					\
 		.sum_exec_runtime = 0,				\
 	}
 
@@ -901,6 +903,10 @@ struct sched_group_power {
 	 * single CPU.
 	 */
 	unsigned int power, power_orig;
+	/*
+	 * Number of busy cpus in this group.
+	 */
+	atomic_t nr_busy_cpus;
 };
 
 struct sched_group {
@@ -925,6 +931,15 @@ static inline struct cpumask *sched_group_cpus(struct sched_group *sg)
 	return to_cpumask(sg->cpumask);
 }
 
+/**
+ * group_first_cpu - Returns the first cpu in the cpumask of a sched_group.
+ * @group: The group whose first cpu is to be returned.
+ */
+static inline unsigned int group_first_cpu(struct sched_group *group)
+{
+	return cpumask_first(sched_group_cpus(group));
+}
+
 struct sched_domain_attr {
 	int relax_domain_level;
 };
@@ -1315,8 +1330,8 @@ struct task_struct {
 	 * older sibling, respectively.  (p->father can be replaced with 
 	 * p->real_parent->pid)
 	 */
-	struct task_struct *real_parent; /* real parent process */
-	struct task_struct *parent; /* recipient of SIGCHLD, wait4() reports */
+	struct task_struct __rcu *real_parent; /* real parent process */
+	struct task_struct __rcu *parent; /* recipient of SIGCHLD, wait4() reports */
 	/*
 	 * children/sibling forms the list of my natural children
 	 */
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 959ff18..6ba596b 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -331,6 +331,13 @@ DEFINE_EVENT(sched_stat_template, sched_stat_iowait,
 	     TP_ARGS(tsk, delay));
 
 /*
+ * Tracepoint for accounting blocked time (time the task is in uninterruptible).
+ */
+DEFINE_EVENT(sched_stat_template, sched_stat_blocked,
+	     TP_PROTO(struct task_struct *tsk, u64 delay),
+	     TP_ARGS(tsk, delay));
+
+/*
  * Tracepoint for accounting runtime (time the task is executing
  * on a CPU).
  */
@@ -363,6 +370,56 @@ TRACE_EVENT(sched_stat_runtime,
 			(unsigned long long)__entry->vruntime)
 );
 
+#ifdef CREATE_TRACE_POINTS
+static inline u64 trace_get_sleeptime(struct task_struct *tsk)
+{
+#ifdef CONFIG_SCHEDSTATS
+	u64 block, sleep;
+
+	block = tsk->se.statistics.block_start;
+	sleep = tsk->se.statistics.sleep_start;
+	tsk->se.statistics.block_start = 0;
+	tsk->se.statistics.sleep_start = 0;
+
+	return block ? block : sleep ? sleep : 0;
+#else
+	return 0;
+#endif
+}
+#endif
+
+/*
+ * Tracepoint for accounting sleeptime (time the task is sleeping
+ * or waiting for I/O).
+ */
+TRACE_EVENT(sched_stat_sleeptime,
+
+	TP_PROTO(struct task_struct *tsk, u64 now),
+
+	TP_ARGS(tsk, now),
+
+	TP_STRUCT__entry(
+		__array( char,	comm,	TASK_COMM_LEN	)
+		__field( pid_t,	pid			)
+		__field( u64,	sleeptime		)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid		= tsk->pid;
+		__entry->sleeptime = trace_get_sleeptime(tsk);
+		__entry->sleeptime = __entry->sleeptime ?
+				now - __entry->sleeptime : 0;
+	)
+	TP_perf_assign(
+		__perf_count(__entry->sleeptime);
+	),
+
+	TP_printk("comm=%s pid=%d sleeptime=%Lu [ns]",
+			__entry->comm, __entry->pid,
+			(unsigned long long)__entry->sleeptime)
+);
+
 /*
  * Tracepoint for showing priority inheritance modifying a tasks
  * priority.
diff --git a/kernel/Makefile b/kernel/Makefile
index e898c5b..f70396e 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -2,16 +2,15 @@
 # Makefile for the linux kernel.
 #
 
-obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
+obj-y     = fork.o exec_domain.o panic.o printk.o \
 	    cpu.o exit.o itimer.o time.o softirq.o resource.o \
 	    sysctl.o sysctl_binary.o capability.o ptrace.o timer.o user.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
-	    notifier.o ksysfs.o sched_clock.o cred.o \
-	    async.o range.o
-obj-y += groups.o
+	    notifier.o ksysfs.o cred.o \
+	    async.o range.o groups.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
@@ -20,10 +19,11 @@ CFLAGS_REMOVE_lockdep_proc.o = -pg
 CFLAGS_REMOVE_mutex-debug.o = -pg
 CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
-CFLAGS_REMOVE_sched_clock.o = -pg
 CFLAGS_REMOVE_irq_work.o = -pg
 endif
 
+obj-y += sched/
+
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_SYSCTL_SYSCALL_CHECK) += sysctl_check.o
@@ -99,7 +99,6 @@ obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_X86_DS) += trace/
 obj-$(CONFIG_RING_BUFFER) += trace/
 obj-$(CONFIG_TRACEPOINTS) += trace/
-obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_IRQ_WORK) += irq_work.o
 obj-$(CONFIG_CPU_PM) += cpu_pm.o
 
@@ -110,15 +109,6 @@ obj-$(CONFIG_PADATA) += padata.o
 obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
 
-ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
-# According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
-# needed for x86 only.  Why this used to be enabled for all architectures is beyond
-# me.  I suspect most platforms don't need this, but until we know that for sure
-# I turn this off for IA-64 only.  Andreas Schwab says it's also needed on m68k
-# to get a correct value for the wait-channel (WCHAN in ps). --davidm
-CFLAGS_sched.o := $(PROFILING) -fno-omit-frame-pointer
-endif
-
 $(obj)/configs.o: $(obj)/config_data.h
 
 # config_data.h contains the same information as ikconfig.h but gzipped.
diff --git a/kernel/acct.c b/kernel/acct.c
index fa7eb3d..203dfea 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -613,8 +613,8 @@ void acct_collect(long exitcode, int group_dead)
 		pacct->ac_flag |= ACORE;
 	if (current->flags & PF_SIGNALED)
 		pacct->ac_flag |= AXSIG;
-	pacct->ac_utime = cputime_add(pacct->ac_utime, current->utime);
-	pacct->ac_stime = cputime_add(pacct->ac_stime, current->stime);
+	pacct->ac_utime += current->utime;
+	pacct->ac_stime += current->stime;
 	pacct->ac_minflt += current->min_flt;
 	pacct->ac_majflt += current->maj_flt;
 	spin_unlock_irq(&current->sighand->siglock);
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 563f136..3f8ee8a 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -178,8 +178,7 @@ static inline void check_for_tasks(int cpu)
 	write_lock_irq(&tasklist_lock);
 	for_each_process(p) {
 		if (task_cpu(p) == cpu && p->state == TASK_RUNNING &&
-		    (!cputime_eq(p->utime, cputime_zero) ||
-		     !cputime_eq(p->stime, cputime_zero)))
+		    (p->utime || p->stime))
 			printk(KERN_WARNING "Task %s (pid = %d) is on cpu %d "
 				"(state = %ld, flags = %x)\n",
 				p->comm, task_pid_nr(p), cpu,
diff --git a/kernel/exit.c b/kernel/exit.c
index d0b7d98..5e0d1f4 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -121,9 +121,9 @@ static void __exit_signal(struct task_struct *tsk)
 		 * We won't ever get here for the group leader, since it
 		 * will have been the last reference on the signal_struct.
 		 */
-		sig->utime = cputime_add(sig->utime, tsk->utime);
-		sig->stime = cputime_add(sig->stime, tsk->stime);
-		sig->gtime = cputime_add(sig->gtime, tsk->gtime);
+		sig->utime += tsk->utime;
+		sig->stime += tsk->stime;
+		sig->gtime += tsk->gtime;
 		sig->min_flt += tsk->min_flt;
 		sig->maj_flt += tsk->maj_flt;
 		sig->nvcsw += tsk->nvcsw;
@@ -1255,19 +1255,9 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		spin_lock_irq(&p->real_parent->sighand->siglock);
 		psig = p->real_parent->signal;
 		sig = p->signal;
-		psig->cutime =
-			cputime_add(psig->cutime,
-			cputime_add(tgutime,
-				    sig->cutime));
-		psig->cstime =
-			cputime_add(psig->cstime,
-			cputime_add(tgstime,
-				    sig->cstime));
-		psig->cgtime =
-			cputime_add(psig->cgtime,
-			cputime_add(p->gtime,
-			cputime_add(sig->gtime,
-				    sig->cgtime)));
+		psig->cutime += tgutime + sig->cutime;
+		psig->cstime += tgstime + sig->cstime;
+		psig->cgtime += p->gtime + sig->gtime + sig->cgtime;
 		psig->cmin_flt +=
 			p->min_flt + sig->min_flt + sig->cmin_flt;
 		psig->cmaj_flt +=
diff --git a/kernel/fork.c b/kernel/fork.c
index da4a6a1..b058c58 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1023,8 +1023,8 @@ void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
  */
 static void posix_cpu_timers_init(struct task_struct *tsk)
 {
-	tsk->cputime_expires.prof_exp = cputime_zero;
-	tsk->cputime_expires.virt_exp = cputime_zero;
+	tsk->cputime_expires.prof_exp = 0;
+	tsk->cputime_expires.virt_exp = 0;
 	tsk->cputime_expires.sched_exp = 0;
 	INIT_LIST_HEAD(&tsk->cpu_timers[0]);
 	INIT_LIST_HEAD(&tsk->cpu_timers[1]);
@@ -1132,14 +1132,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	init_sigpending(&p->pending);
 
-	p->utime = cputime_zero;
-	p->stime = cputime_zero;
-	p->gtime = cputime_zero;
-	p->utimescaled = cputime_zero;
-	p->stimescaled = cputime_zero;
+	p->utime = p->stime = p->gtime = 0;
+	p->utimescaled = p->stimescaled = 0;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
-	p->prev_utime = cputime_zero;
-	p->prev_stime = cputime_zero;
+	p->prev_utime = p->prev_stime = 0;
 #endif
 #if defined(SPLIT_RSS_COUNTING)
 	memset(&p->rss_stat, 0, sizeof(p->rss_stat));
diff --git a/kernel/itimer.c b/kernel/itimer.c
index d802883..22000c3 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -52,22 +52,22 @@ static void get_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 
 	cval = it->expires;
 	cinterval = it->incr;
-	if (!cputime_eq(cval, cputime_zero)) {
+	if (cval) {
 		struct task_cputime cputime;
 		cputime_t t;
 
 		thread_group_cputimer(tsk, &cputime);
 		if (clock_id == CPUCLOCK_PROF)
-			t = cputime_add(cputime.utime, cputime.stime);
+			t = cputime.utime + cputime.stime;
 		else
 			/* CPUCLOCK_VIRT */
 			t = cputime.utime;
 
-		if (cputime_le(cval, t))
+		if (cval < t)
 			/* about to fire */
 			cval = cputime_one_jiffy;
 		else
-			cval = cputime_sub(cval, t);
+			cval = cval - t;
 	}
 
 	spin_unlock_irq(&tsk->sighand->siglock);
@@ -161,10 +161,9 @@ static void set_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 
 	cval = it->expires;
 	cinterval = it->incr;
-	if (!cputime_eq(cval, cputime_zero) ||
-	    !cputime_eq(nval, cputime_zero)) {
-		if (cputime_gt(nval, cputime_zero))
-			nval = cputime_add(nval, cputime_one_jiffy);
+	if (cval || nval) {
+		if (nval > 0)
+			nval += cputime_one_jiffy;
 		set_process_cpu_timer(tsk, clock_id, &nval, &cval);
 	}
 	it->expires = nval;
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index e7cb76d..125cb67 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -78,7 +78,7 @@ static inline int cpu_time_before(const clockid_t which_clock,
 	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED) {
 		return now.sched < then.sched;
 	}  else {
-		return cputime_lt(now.cpu, then.cpu);
+		return now.cpu < then.cpu;
 	}
 }
 static inline void cpu_time_add(const clockid_t which_clock,
@@ -88,7 +88,7 @@ static inline void cpu_time_add(const clockid_t which_clock,
 	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED) {
 		acc->sched += val.sched;
 	}  else {
-		acc->cpu = cputime_add(acc->cpu, val.cpu);
+		acc->cpu += val.cpu;
 	}
 }
 static inline union cpu_time_count cpu_time_sub(const clockid_t which_clock,
@@ -98,25 +98,12 @@ static inline union cpu_time_count cpu_time_sub(const clockid_t which_clock,
 	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED) {
 		a.sched -= b.sched;
 	}  else {
-		a.cpu = cputime_sub(a.cpu, b.cpu);
+		a.cpu -= b.cpu;
 	}
 	return a;
 }
 
 /*
- * Divide and limit the result to res >= 1
- *
- * This is necessary to prevent signal delivery starvation, when the result of
- * the division would be rounded down to 0.
- */
-static inline cputime_t cputime_div_non_zero(cputime_t time, unsigned long div)
-{
-	cputime_t res = cputime_div(time, div);
-
-	return max_t(cputime_t, res, 1);
-}
-
-/*
  * Update expiry time from increment, and increase overrun count,
  * given the current clock sample.
  */
@@ -148,28 +135,26 @@ static void bump_cpu_timer(struct k_itimer *timer,
 	} else {
 		cputime_t delta, incr;
 
-		if (cputime_lt(now.cpu, timer->it.cpu.expires.cpu))
+		if (now.cpu < timer->it.cpu.expires.cpu)
 			return;
 		incr = timer->it.cpu.incr.cpu;
-		delta = cputime_sub(cputime_add(now.cpu, incr),
-				    timer->it.cpu.expires.cpu);
+		delta = now.cpu + incr - timer->it.cpu.expires.cpu;
 		/* Don't use (incr*2 < delta), incr*2 might overflow. */
-		for (i = 0; cputime_lt(incr, cputime_sub(delta, incr)); i++)
-			     incr = cputime_add(incr, incr);
-		for (; i >= 0; incr = cputime_halve(incr), i--) {
-			if (cputime_lt(delta, incr))
+		for (i = 0; incr < delta - incr; i++)
+			     incr += incr;
+		for (; i >= 0; incr = incr >> 1, i--) {
+			if (delta < incr)
 				continue;
-			timer->it.cpu.expires.cpu =
-				cputime_add(timer->it.cpu.expires.cpu, incr);
+			timer->it.cpu.expires.cpu += incr;
 			timer->it_overrun += 1 << i;
-			delta = cputime_sub(delta, incr);
+			delta -= incr;
 		}
 	}
 }
 
 static inline cputime_t prof_ticks(struct task_struct *p)
 {
-	return cputime_add(p->utime, p->stime);
+	return p->utime + p->stime;
 }
 static inline cputime_t virt_ticks(struct task_struct *p)
 {
@@ -248,8 +233,8 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 
 	t = tsk;
 	do {
-		times->utime = cputime_add(times->utime, t->utime);
-		times->stime = cputime_add(times->stime, t->stime);
+		times->utime += t->utime;
+		times->stime += t->stime;
 		times->sum_exec_runtime += task_sched_runtime(t);
 	} while_each_thread(tsk, t);
 out:
@@ -258,10 +243,10 @@ out:
 
 static void update_gt_cputime(struct task_cputime *a, struct task_cputime *b)
 {
-	if (cputime_gt(b->utime, a->utime))
+	if (b->utime > a->utime)
 		a->utime = b->utime;
 
-	if (cputime_gt(b->stime, a->stime))
+	if (b->stime > a->stime)
 		a->stime = b->stime;
 
 	if (b->sum_exec_runtime > a->sum_exec_runtime)
@@ -306,7 +291,7 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 		return -EINVAL;
 	case CPUCLOCK_PROF:
 		thread_group_cputime(p, &cputime);
-		cpu->cpu = cputime_add(cputime.utime, cputime.stime);
+		cpu->cpu = cputime.utime + cputime.stime;
 		break;
 	case CPUCLOCK_VIRT:
 		thread_group_cputime(p, &cputime);
@@ -470,26 +455,24 @@ static void cleanup_timers(struct list_head *head,
 			   unsigned long long sum_exec_runtime)
 {
 	struct cpu_timer_list *timer, *next;
-	cputime_t ptime = cputime_add(utime, stime);
+	cputime_t ptime = utime + stime;
 
 	list_for_each_entry_safe(timer, next, head, entry) {
 		list_del_init(&timer->entry);
-		if (cputime_lt(timer->expires.cpu, ptime)) {
-			timer->expires.cpu = cputime_zero;
+		if (timer->expires.cpu < ptime) {
+			timer->expires.cpu = 0;
 		} else {
-			timer->expires.cpu = cputime_sub(timer->expires.cpu,
-							 ptime);
+			timer->expires.cpu -= ptime;
 		}
 	}
 
 	++head;
 	list_for_each_entry_safe(timer, next, head, entry) {
 		list_del_init(&timer->entry);
-		if (cputime_lt(timer->expires.cpu, utime)) {
-			timer->expires.cpu = cputime_zero;
+		if (timer->expires.cpu < utime) {
+			timer->expires.cpu = 0;
 		} else {
-			timer->expires.cpu = cputime_sub(timer->expires.cpu,
-							 utime);
+			timer->expires.cpu -= utime;
 		}
 	}
 
@@ -520,8 +503,7 @@ void posix_cpu_timers_exit_group(struct task_struct *tsk)
 	struct signal_struct *const sig = tsk->signal;
 
 	cleanup_timers(tsk->signal->cpu_timers,
-		       cputime_add(tsk->utime, sig->utime),
-		       cputime_add(tsk->stime, sig->stime),
+		       tsk->utime + sig->utime, tsk->stime + sig->stime,
 		       tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
 }
 
@@ -540,8 +522,7 @@ static void clear_dead_task(struct k_itimer *timer, union cpu_time_count now)
 
 static inline int expires_gt(cputime_t expires, cputime_t new_exp)
 {
-	return cputime_eq(expires, cputime_zero) ||
-	       cputime_gt(expires, new_exp);
+	return expires == 0 || expires > new_exp;
 }
 
 /*
@@ -651,7 +632,7 @@ static int cpu_timer_sample_group(const clockid_t which_clock,
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
-		cpu->cpu = cputime_add(cputime.utime, cputime.stime);
+		cpu->cpu = cputime.utime + cputime.stime;
 		break;
 	case CPUCLOCK_VIRT:
 		cpu->cpu = cputime.utime;
@@ -918,12 +899,12 @@ static void check_thread_timers(struct task_struct *tsk,
 	unsigned long soft;
 
 	maxfire = 20;
-	tsk->cputime_expires.prof_exp = cputime_zero;
+	tsk->cputime_expires.prof_exp = 0;
 	while (!list_empty(timers)) {
 		struct cpu_timer_list *t = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || cputime_lt(prof_ticks(tsk), t->expires.cpu)) {
+		if (!--maxfire || prof_ticks(tsk) < t->expires.cpu) {
 			tsk->cputime_expires.prof_exp = t->expires.cpu;
 			break;
 		}
@@ -933,12 +914,12 @@ static void check_thread_timers(struct task_struct *tsk,
 
 	++timers;
 	maxfire = 20;
-	tsk->cputime_expires.virt_exp = cputime_zero;
+	tsk->cputime_expires.virt_exp = 0;
 	while (!list_empty(timers)) {
 		struct cpu_timer_list *t = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || cputime_lt(virt_ticks(tsk), t->expires.cpu)) {
+		if (!--maxfire || virt_ticks(tsk) < t->expires.cpu) {
 			tsk->cputime_expires.virt_exp = t->expires.cpu;
 			break;
 		}
@@ -1009,20 +990,19 @@ static u32 onecputick;
 static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
 			     cputime_t *expires, cputime_t cur_time, int signo)
 {
-	if (cputime_eq(it->expires, cputime_zero))
+	if (!it->expires)
 		return;
 
-	if (cputime_ge(cur_time, it->expires)) {
-		if (!cputime_eq(it->incr, cputime_zero)) {
-			it->expires = cputime_add(it->expires, it->incr);
+	if (cur_time >= it->expires) {
+		if (it->incr) {
+			it->expires += it->incr;
 			it->error += it->incr_error;
 			if (it->error >= onecputick) {
-				it->expires = cputime_sub(it->expires,
-							  cputime_one_jiffy);
+				it->expires -= cputime_one_jiffy;
 				it->error -= onecputick;
 			}
 		} else {
-			it->expires = cputime_zero;
+			it->expires = 0;
 		}
 
 		trace_itimer_expire(signo == SIGPROF ?
@@ -1031,9 +1011,7 @@ static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
 		__group_send_sig_info(signo, SEND_SIG_PRIV, tsk);
 	}
 
-	if (!cputime_eq(it->expires, cputime_zero) &&
-	    (cputime_eq(*expires, cputime_zero) ||
-	     cputime_lt(it->expires, *expires))) {
+	if (it->expires && (!*expires || it->expires < *expires)) {
 		*expires = it->expires;
 	}
 }
@@ -1048,9 +1026,7 @@ static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
  */
 static inline int task_cputime_zero(const struct task_cputime *cputime)
 {
-	if (cputime_eq(cputime->utime, cputime_zero) &&
-	    cputime_eq(cputime->stime, cputime_zero) &&
-	    cputime->sum_exec_runtime == 0)
+	if (!cputime->utime && !cputime->stime && !cputime->sum_exec_runtime)
 		return 1;
 	return 0;
 }
@@ -1076,15 +1052,15 @@ static void check_process_timers(struct task_struct *tsk,
 	 */
 	thread_group_cputimer(tsk, &cputime);
 	utime = cputime.utime;
-	ptime = cputime_add(utime, cputime.stime);
+	ptime = utime + cputime.stime;
 	sum_sched_runtime = cputime.sum_exec_runtime;
 	maxfire = 20;
-	prof_expires = cputime_zero;
+	prof_expires = 0;
 	while (!list_empty(timers)) {
 		struct cpu_timer_list *tl = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || cputime_lt(ptime, tl->expires.cpu)) {
+		if (!--maxfire || ptime < tl->expires.cpu) {
 			prof_expires = tl->expires.cpu;
 			break;
 		}
@@ -1094,12 +1070,12 @@ static void check_process_timers(struct task_struct *tsk,
 
 	++timers;
 	maxfire = 20;
-	virt_expires = cputime_zero;
+	virt_expires = 0;
 	while (!list_empty(timers)) {
 		struct cpu_timer_list *tl = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || cputime_lt(utime, tl->expires.cpu)) {
+		if (!--maxfire || utime < tl->expires.cpu) {
 			virt_expires = tl->expires.cpu;
 			break;
 		}
@@ -1154,8 +1130,7 @@ static void check_process_timers(struct task_struct *tsk,
 			}
 		}
 		x = secs_to_cputime(soft);
-		if (cputime_eq(prof_expires, cputime_zero) ||
-		    cputime_lt(x, prof_expires)) {
+		if (!prof_expires || x < prof_expires) {
 			prof_expires = x;
 		}
 	}
@@ -1249,12 +1224,9 @@ out:
 static inline int task_cputime_expired(const struct task_cputime *sample,
 					const struct task_cputime *expires)
 {
-	if (!cputime_eq(expires->utime, cputime_zero) &&
-	    cputime_ge(sample->utime, expires->utime))
+	if (expires->utime && sample->utime >= expires->utime)
 		return 1;
-	if (!cputime_eq(expires->stime, cputime_zero) &&
-	    cputime_ge(cputime_add(sample->utime, sample->stime),
-		       expires->stime))
+	if (expires->stime && sample->utime + sample->stime >= expires->stime)
 		return 1;
 	if (expires->sum_exec_runtime != 0 &&
 	    sample->sum_exec_runtime >= expires->sum_exec_runtime)
@@ -1389,18 +1361,18 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 		 * it to be relative, *newval argument is relative and we update
 		 * it to be absolute.
 		 */
-		if (!cputime_eq(*oldval, cputime_zero)) {
-			if (cputime_le(*oldval, now.cpu)) {
+		if (*oldval) {
+			if (*oldval <= now.cpu) {
 				/* Just about to fire. */
 				*oldval = cputime_one_jiffy;
 			} else {
-				*oldval = cputime_sub(*oldval, now.cpu);
+				*oldval -= now.cpu;
 			}
 		}
 
-		if (cputime_eq(*newval, cputime_zero))
+		if (!*newval)
 			return;
-		*newval = cputime_add(*newval, now.cpu);
+		*newval += now.cpu;
 	}
 
 	/*
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
new file mode 100644
index 0000000..9a7dd35
--- /dev/null
+++ b/kernel/sched/Makefile
@@ -0,0 +1,20 @@
+ifdef CONFIG_FUNCTION_TRACER
+CFLAGS_REMOVE_clock.o = -pg
+endif
+
+ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
+# According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
+# needed for x86 only.  Why this used to be enabled for all architectures is beyond
+# me.  I suspect most platforms don't need this, but until we know that for sure
+# I turn this off for IA-64 only.  Andreas Schwab says it's also needed on m68k
+# to get a correct value for the wait-channel (WCHAN in ps). --davidm
+CFLAGS_core.o := $(PROFILING) -fno-omit-frame-pointer
+endif
+
+obj-y += core.o clock.o idle_task.o fair.o rt.o stop_task.o
+obj-$(CONFIG_SMP) += cpupri.o
+obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
+obj-$(CONFIG_SCHEDSTATS) += stats.o
+obj-$(CONFIG_SCHED_DEBUG) += debug.o
+
+
diff --git a/kernel/sched_autogroup.c b/kernel/sched/auto_group.c
similarity index 88%
rename from kernel/sched_autogroup.c
rename to kernel/sched/auto_group.c
index 429242f..e8a1f83 100644
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched/auto_group.c
@@ -1,15 +1,19 @@
 #ifdef CONFIG_SCHED_AUTOGROUP
 
+#include "sched.h"
+
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/kallsyms.h>
 #include <linux/utsname.h>
+#include <linux/security.h>
+#include <linux/export.h>
 
 unsigned int __read_mostly sysctl_sched_autogroup_enabled = 1;
 static struct autogroup autogroup_default;
 static atomic_t autogroup_seq_nr;
 
-static void __init autogroup_init(struct task_struct *init_task)
+void __init autogroup_init(struct task_struct *init_task)
 {
 	autogroup_default.tg = &root_task_group;
 	kref_init(&autogroup_default.kref);
@@ -17,7 +21,7 @@ static void __init autogroup_init(struct task_struct *init_task)
 	init_task->signal->autogroup = &autogroup_default;
 }
 
-static inline void autogroup_free(struct task_group *tg)
+void autogroup_free(struct task_group *tg)
 {
 	kfree(tg->autogroup);
 }
@@ -59,10 +63,6 @@ static inline struct autogroup *autogroup_task_get(struct task_struct *p)
 	return ag;
 }
 
-#ifdef CONFIG_RT_GROUP_SCHED
-static void free_rt_sched_group(struct task_group *tg);
-#endif
-
 static inline struct autogroup *autogroup_create(void)
 {
 	struct autogroup *ag = kzalloc(sizeof(*ag), GFP_KERNEL);
@@ -108,8 +108,7 @@ out_fail:
 	return autogroup_kref_get(&autogroup_default);
 }
 
-static inline bool
-task_wants_autogroup(struct task_struct *p, struct task_group *tg)
+bool task_wants_autogroup(struct task_struct *p, struct task_group *tg)
 {
 	if (tg != &root_task_group)
 		return false;
@@ -127,22 +126,6 @@ task_wants_autogroup(struct task_struct *p, struct task_group *tg)
 	return true;
 }
 
-static inline bool task_group_is_autogroup(struct task_group *tg)
-{
-	return !!tg->autogroup;
-}
-
-static inline struct task_group *
-autogroup_task_group(struct task_struct *p, struct task_group *tg)
-{
-	int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);
-
-	if (enabled && task_wants_autogroup(p, tg))
-		return p->signal->autogroup->tg;
-
-	return tg;
-}
-
 static void
 autogroup_move_group(struct task_struct *p, struct autogroup *ag)
 {
@@ -263,7 +246,7 @@ out:
 #endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_SCHED_DEBUG
-static inline int autogroup_path(struct task_group *tg, char *buf, int buflen)
+int autogroup_path(struct task_group *tg, char *buf, int buflen)
 {
 	if (!task_group_is_autogroup(tg))
 		return 0;
diff --git a/kernel/sched_autogroup.h b/kernel/sched/auto_group.h
similarity index 66%
rename from kernel/sched_autogroup.h
rename to kernel/sched/auto_group.h
index c2f0e72..8bd0471 100644
--- a/kernel/sched_autogroup.h
+++ b/kernel/sched/auto_group.h
@@ -1,5 +1,8 @@
 #ifdef CONFIG_SCHED_AUTOGROUP
 
+#include <linux/kref.h>
+#include <linux/rwsem.h>
+
 struct autogroup {
 	/*
 	 * reference doesn't mean how many thread attach to this
@@ -13,9 +16,28 @@ struct autogroup {
 	int			nice;
 };
 
-static inline bool task_group_is_autogroup(struct task_group *tg);
+extern void autogroup_init(struct task_struct *init_task);
+extern void autogroup_free(struct task_group *tg);
+
+static inline bool task_group_is_autogroup(struct task_group *tg)
+{
+	return !!tg->autogroup;
+}
+
+extern bool task_wants_autogroup(struct task_struct *p, struct task_group *tg);
+
 static inline struct task_group *
-autogroup_task_group(struct task_struct *p, struct task_group *tg);
+autogroup_task_group(struct task_struct *p, struct task_group *tg)
+{
+	int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);
+
+	if (enabled && task_wants_autogroup(p, tg))
+		return p->signal->autogroup->tg;
+
+	return tg;
+}
+
+extern int autogroup_path(struct task_group *tg, char *buf, int buflen);
 
 #else /* !CONFIG_SCHED_AUTOGROUP */
 
diff --git a/kernel/sched_clock.c b/kernel/sched/clock.c
similarity index 100%
rename from kernel/sched_clock.c
rename to kernel/sched/clock.c
diff --git a/kernel/sched.c b/kernel/sched/core.c
similarity index 79%
rename from kernel/sched.c
rename to kernel/sched/core.c
index d6b149c..4dbfd04 100644
--- a/kernel/sched.c
+++ b/kernel/sched/core.c
@@ -1,5 +1,5 @@
 /*
- *  kernel/sched.c
+ *  kernel/sched/core.c
  *
  *  Kernel scheduler and related syscalls
  *
@@ -56,7 +56,6 @@
 #include <linux/percpu.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-#include <linux/stop_machine.h>
 #include <linux/sysctl.h>
 #include <linux/syscalls.h>
 #include <linux/times.h>
@@ -75,129 +74,17 @@
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
-#include <asm/mutex.h>
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #endif
 
-#include "sched_cpupri.h"
-#include "workqueue_sched.h"
-#include "sched_autogroup.h"
+#include "sched.h"
+#include "../workqueue_sched.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
 
-/*
- * Convert user-nice values [ -20 ... 0 ... 19 ]
- * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
- * and back.
- */
-#define NICE_TO_PRIO(nice)	(MAX_RT_PRIO + (nice) + 20)
-#define PRIO_TO_NICE(prio)	((prio) - MAX_RT_PRIO - 20)
-#define TASK_NICE(p)		PRIO_TO_NICE((p)->static_prio)
-
-/*
- * 'User priority' is the nice value converted to something we
- * can work with better when scaling various scheduler parameters,
- * it's a [ 0 ... 39 ] range.
- */
-#define USER_PRIO(p)		((p)-MAX_RT_PRIO)
-#define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
-#define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
-
-/*
- * Helpers for converting nanosecond timing to jiffy resolution
- */
-#define NS_TO_JIFFIES(TIME)	((unsigned long)(TIME) / (NSEC_PER_SEC / HZ))
-
-#define NICE_0_LOAD		SCHED_LOAD_SCALE
-#define NICE_0_SHIFT		SCHED_LOAD_SHIFT
-
-/*
- * These are the 'tuning knobs' of the scheduler:
- *
- * default timeslice is 100 msecs (used only for SCHED_RR tasks).
- * Timeslices get refilled after they expire.
- */
-#define DEF_TIMESLICE		(100 * HZ / 1000)
-
-/*
- * single value that denotes runtime == period, ie unlimited time.
- */
-#define RUNTIME_INF	((u64)~0ULL)
-
-static inline int rt_policy(int policy)
-{
-	if (policy == SCHED_FIFO || policy == SCHED_RR)
-		return 1;
-	return 0;
-}
-
-static inline int task_has_rt_policy(struct task_struct *p)
-{
-	return rt_policy(p->policy);
-}
-
-/*
- * This is the priority-queue data structure of the RT scheduling class:
- */
-struct rt_prio_array {
-	DECLARE_BITMAP(bitmap, MAX_RT_PRIO+1); /* include 1 bit for delimiter */
-	struct list_head queue[MAX_RT_PRIO];
-};
-
-struct rt_bandwidth {
-	/* nests inside the rq lock: */
-	raw_spinlock_t		rt_runtime_lock;
-	ktime_t			rt_period;
-	u64			rt_runtime;
-	struct hrtimer		rt_period_timer;
-};
-
-static struct rt_bandwidth def_rt_bandwidth;
-
-static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
-
-static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
-{
-	struct rt_bandwidth *rt_b =
-		container_of(timer, struct rt_bandwidth, rt_period_timer);
-	ktime_t now;
-	int overrun;
-	int idle = 0;
-
-	for (;;) {
-		now = hrtimer_cb_get_time(timer);
-		overrun = hrtimer_forward(timer, now, rt_b->rt_period);
-
-		if (!overrun)
-			break;
-
-		idle = do_sched_rt_period_timer(rt_b, overrun);
-	}
-
-	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
-}
-
-static
-void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime)
-{
-	rt_b->rt_period = ns_to_ktime(period);
-	rt_b->rt_runtime = runtime;
-
-	raw_spin_lock_init(&rt_b->rt_runtime_lock);
-
-	hrtimer_init(&rt_b->rt_period_timer,
-			CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	rt_b->rt_period_timer.function = sched_rt_period_timer;
-}
-
-static inline int rt_bandwidth_enabled(void)
-{
-	return sysctl_sched_rt_runtime >= 0;
-}
-
-static void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
+void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
 {
 	unsigned long delta;
 	ktime_t soft, hard, now;
@@ -217,580 +104,12 @@ static void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
 	}
 }
 
-static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
-{
-	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
-		return;
-
-	if (hrtimer_active(&rt_b->rt_period_timer))
-		return;
-
-	raw_spin_lock(&rt_b->rt_runtime_lock);
-	start_bandwidth_timer(&rt_b->rt_period_timer, rt_b->rt_period);
-	raw_spin_unlock(&rt_b->rt_runtime_lock);
-}
-
-#ifdef CONFIG_RT_GROUP_SCHED
-static void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
-{
-	hrtimer_cancel(&rt_b->rt_period_timer);
-}
-#endif
-
-/*
- * sched_domains_mutex serializes calls to init_sched_domains,
- * detach_destroy_domains and partition_sched_domains.
- */
-static DEFINE_MUTEX(sched_domains_mutex);
-
-#ifdef CONFIG_CGROUP_SCHED
-
-#include <linux/cgroup.h>
-
-struct cfs_rq;
-
-static LIST_HEAD(task_groups);
-
-struct cfs_bandwidth {
-#ifdef CONFIG_CFS_BANDWIDTH
-	raw_spinlock_t lock;
-	ktime_t period;
-	u64 quota, runtime;
-	s64 hierarchal_quota;
-	u64 runtime_expires;
-
-	int idle, timer_active;
-	struct hrtimer period_timer, slack_timer;
-	struct list_head throttled_cfs_rq;
-
-	/* statistics */
-	int nr_periods, nr_throttled;
-	u64 throttled_time;
-#endif
-};
-
-/* task group related information */
-struct task_group {
-	struct cgroup_subsys_state css;
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	/* schedulable entities of this group on each cpu */
-	struct sched_entity **se;
-	/* runqueue "owned" by this group on each cpu */
-	struct cfs_rq **cfs_rq;
-	unsigned long shares;
-
-	atomic_t load_weight;
-#endif
-
-#ifdef CONFIG_RT_GROUP_SCHED
-	struct sched_rt_entity **rt_se;
-	struct rt_rq **rt_rq;
-
-	struct rt_bandwidth rt_bandwidth;
-#endif
-
-	struct rcu_head rcu;
-	struct list_head list;
-
-	struct task_group *parent;
-	struct list_head siblings;
-	struct list_head children;
-
-#ifdef CONFIG_SCHED_AUTOGROUP
-	struct autogroup *autogroup;
-#endif
-
-	struct cfs_bandwidth cfs_bandwidth;
-};
-
-/* task_group_lock serializes the addition/removal of task groups */
-static DEFINE_SPINLOCK(task_group_lock);
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-
-# define ROOT_TASK_GROUP_LOAD	NICE_0_LOAD
-
-/*
- * A weight of 0 or 1 can cause arithmetics problems.
- * A weight of a cfs_rq is the sum of weights of which entities
- * are queued on this cfs_rq, so a weight of a entity should not be
- * too large, so as the shares value of a task group.
- * (The default weight is 1024 - so there's no practical
- *  limitation from this.)
- */
-#define MIN_SHARES	(1UL <<  1)
-#define MAX_SHARES	(1UL << 18)
-
-static int root_task_group_load = ROOT_TASK_GROUP_LOAD;
-#endif
-
-/* Default task group.
- *	Every task in system belong to this group at bootup.
- */
-struct task_group root_task_group;
-
-#endif	/* CONFIG_CGROUP_SCHED */
-
-/* CFS-related fields in a runqueue */
-struct cfs_rq {
-	struct load_weight load;
-	unsigned long nr_running, h_nr_running;
-
-	u64 exec_clock;
-	u64 min_vruntime;
-#ifndef CONFIG_64BIT
-	u64 min_vruntime_copy;
-#endif
-
-	struct rb_root tasks_timeline;
-	struct rb_node *rb_leftmost;
-
-	struct list_head tasks;
-	struct list_head *balance_iterator;
-
-	/*
-	 * 'curr' points to currently running entity on this cfs_rq.
-	 * It is set to NULL otherwise (i.e when none are currently running).
-	 */
-	struct sched_entity *curr, *next, *last, *skip;
-
-#ifdef	CONFIG_SCHED_DEBUG
-	unsigned int nr_spread_over;
-#endif
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */
-
-	/*
-	 * leaf cfs_rqs are those that hold tasks (lowest schedulable entity in
-	 * a hierarchy). Non-leaf lrqs hold other higher schedulable entities
-	 * (like users, containers etc.)
-	 *
-	 * leaf_cfs_rq_list ties together list of leaf cfs_rq's in a cpu. This
-	 * list is used during load balance.
-	 */
-	int on_list;
-	struct list_head leaf_cfs_rq_list;
-	struct task_group *tg;	/* group that "owns" this runqueue */
-
-#ifdef CONFIG_SMP
-	/*
-	 * the part of load.weight contributed by tasks
-	 */
-	unsigned long task_weight;
-
-	/*
-	 *   h_load = weight * f(tg)
-	 *
-	 * Where f(tg) is the recursive weight fraction assigned to
-	 * this group.
-	 */
-	unsigned long h_load;
-
-	/*
-	 * Maintaining per-cpu shares distribution for group scheduling
-	 *
-	 * load_stamp is the last time we updated the load average
-	 * load_last is the last time we updated the load average and saw load
-	 * load_unacc_exec_time is currently unaccounted execution time
-	 */
-	u64 load_avg;
-	u64 load_period;
-	u64 load_stamp, load_last, load_unacc_exec_time;
-
-	unsigned long load_contribution;
-#endif
-#ifdef CONFIG_CFS_BANDWIDTH
-	int runtime_enabled;
-	u64 runtime_expires;
-	s64 runtime_remaining;
-
-	u64 throttled_timestamp;
-	int throttled, throttle_count;
-	struct list_head throttled_list;
-#endif
-#endif
-};
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-#ifdef CONFIG_CFS_BANDWIDTH
-static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
-{
-	return &tg->cfs_bandwidth;
-}
-
-static inline u64 default_cfs_period(void);
-static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun);
-static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b);
-
-static enum hrtimer_restart sched_cfs_slack_timer(struct hrtimer *timer)
-{
-	struct cfs_bandwidth *cfs_b =
-		container_of(timer, struct cfs_bandwidth, slack_timer);
-	do_sched_cfs_slack_timer(cfs_b);
-
-	return HRTIMER_NORESTART;
-}
-
-static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
-{
-	struct cfs_bandwidth *cfs_b =
-		container_of(timer, struct cfs_bandwidth, period_timer);
-	ktime_t now;
-	int overrun;
-	int idle = 0;
-
-	for (;;) {
-		now = hrtimer_cb_get_time(timer);
-		overrun = hrtimer_forward(timer, now, cfs_b->period);
-
-		if (!overrun)
-			break;
-
-		idle = do_sched_cfs_period_timer(cfs_b, overrun);
-	}
-
-	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
-}
-
-static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
-{
-	raw_spin_lock_init(&cfs_b->lock);
-	cfs_b->runtime = 0;
-	cfs_b->quota = RUNTIME_INF;
-	cfs_b->period = ns_to_ktime(default_cfs_period());
-
-	INIT_LIST_HEAD(&cfs_b->throttled_cfs_rq);
-	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	cfs_b->period_timer.function = sched_cfs_period_timer;
-	hrtimer_init(&cfs_b->slack_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	cfs_b->slack_timer.function = sched_cfs_slack_timer;
-}
-
-static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
-{
-	cfs_rq->runtime_enabled = 0;
-	INIT_LIST_HEAD(&cfs_rq->throttled_list);
-}
-
-/* requires cfs_b->lock, may release to reprogram timer */
-static void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
-{
-	/*
-	 * The timer may be active because we're trying to set a new bandwidth
-	 * period or because we're racing with the tear-down path
-	 * (timer_active==0 becomes visible before the hrtimer call-back
-	 * terminates).  In either case we ensure that it's re-programmed
-	 */
-	while (unlikely(hrtimer_active(&cfs_b->period_timer))) {
-		raw_spin_unlock(&cfs_b->lock);
-		/* ensure cfs_b->lock is available while we wait */
-		hrtimer_cancel(&cfs_b->period_timer);
-
-		raw_spin_lock(&cfs_b->lock);
-		/* if someone else restarted the timer then we're done */
-		if (cfs_b->timer_active)
-			return;
-	}
-
-	cfs_b->timer_active = 1;
-	start_bandwidth_timer(&cfs_b->period_timer, cfs_b->period);
-}
-
-static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
-{
-	hrtimer_cancel(&cfs_b->period_timer);
-	hrtimer_cancel(&cfs_b->slack_timer);
-}
-#else
-static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
-static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
-static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
-
-static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
-{
-	return NULL;
-}
-#endif /* CONFIG_CFS_BANDWIDTH */
-#endif /* CONFIG_FAIR_GROUP_SCHED */
-
-/* Real-Time classes' related field in a runqueue: */
-struct rt_rq {
-	struct rt_prio_array active;
-	unsigned long rt_nr_running;
-#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
-	struct {
-		int curr; /* highest queued rt task prio */
-#ifdef CONFIG_SMP
-		int next; /* next highest */
-#endif
-	} highest_prio;
-#endif
-#ifdef CONFIG_SMP
-	unsigned long rt_nr_migratory;
-	unsigned long rt_nr_total;
-	int overloaded;
-	struct plist_head pushable_tasks;
-#endif
-	int rt_throttled;
-	u64 rt_time;
-	u64 rt_runtime;
-	/* Nests inside the rq lock: */
-	raw_spinlock_t rt_runtime_lock;
-
-#ifdef CONFIG_RT_GROUP_SCHED
-	unsigned long rt_nr_boosted;
-
-	struct rq *rq;
-	struct list_head leaf_rt_rq_list;
-	struct task_group *tg;
-#endif
-};
-
-#ifdef CONFIG_SMP
-
-/*
- * We add the notion of a root-domain which will be used to define per-domain
- * variables. Each exclusive cpuset essentially defines an island domain by
- * fully partitioning the member cpus from any other cpuset. Whenever a new
- * exclusive cpuset is created, we also create and attach a new root-domain
- * object.
- *
- */
-struct root_domain {
-	atomic_t refcount;
-	atomic_t rto_count;
-	struct rcu_head rcu;
-	cpumask_var_t span;
-	cpumask_var_t online;
-
-	/*
-	 * The "RT overload" flag: it gets set if a CPU has more than
-	 * one runnable RT task.
-	 */
-	cpumask_var_t rto_mask;
-	struct cpupri cpupri;
-};
-
-/*
- * By default the system creates a single root-domain with all cpus as
- * members (mimicking the global state we have today).
- */
-static struct root_domain def_root_domain;
-
-#endif /* CONFIG_SMP */
-
-/*
- * This is the main, per-CPU runqueue data structure.
- *
- * Locking rule: those places that want to lock multiple runqueues
- * (such as the load balancing or the thread migration code), lock
- * acquire operations must be ordered by ascending &runqueue.
- */
-struct rq {
-	/* runqueue lock: */
-	raw_spinlock_t lock;
-
-	/*
-	 * nr_running and cpu_load should be in the same cacheline because
-	 * remote CPUs use both these fields when doing load calculation.
-	 */
-	unsigned long nr_running;
-	#define CPU_LOAD_IDX_MAX 5
-	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
-	unsigned long last_load_update_tick;
-#ifdef CONFIG_NO_HZ
-	u64 nohz_stamp;
-	unsigned char nohz_balance_kick;
-#endif
-	int skip_clock_update;
-
-	/* capture load from *all* tasks on this cpu: */
-	struct load_weight load;
-	unsigned long nr_load_updates;
-	u64 nr_switches;
-
-	struct cfs_rq cfs;
-	struct rt_rq rt;
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	/* list of leaf cfs_rq on this cpu: */
-	struct list_head leaf_cfs_rq_list;
-#endif
-#ifdef CONFIG_RT_GROUP_SCHED
-	struct list_head leaf_rt_rq_list;
-#endif
-
-	/*
-	 * This is part of a global counter where only the total sum
-	 * over all CPUs matters. A task can increase this counter on
-	 * one CPU and if it got migrated afterwards it may decrease
-	 * it on another CPU. Always updated under the runqueue lock:
-	 */
-	unsigned long nr_uninterruptible;
-
-	struct task_struct *curr, *idle, *stop;
-	unsigned long next_balance;
-	struct mm_struct *prev_mm;
-
-	u64 clock;
-	u64 clock_task;
-
-	atomic_t nr_iowait;
-
-#ifdef CONFIG_SMP
-	struct root_domain *rd;
-	struct sched_domain *sd;
-
-	unsigned long cpu_power;
-
-	unsigned char idle_balance;
-	/* For active balancing */
-	int post_schedule;
-	int active_balance;
-	int push_cpu;
-	struct cpu_stop_work active_balance_work;
-	/* cpu of this runqueue: */
-	int cpu;
-	int online;
-
-	u64 rt_avg;
-	u64 age_stamp;
-	u64 idle_stamp;
-	u64 avg_idle;
-#endif
-
-#ifdef CONFIG_IRQ_TIME_ACCOUNTING
-	u64 prev_irq_time;
-#endif
-#ifdef CONFIG_PARAVIRT
-	u64 prev_steal_time;
-#endif
-#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
-	u64 prev_steal_time_rq;
-#endif
-
-	/* calc_load related fields */
-	unsigned long calc_load_update;
-	long calc_load_active;
-
-#ifdef CONFIG_SCHED_HRTICK
-#ifdef CONFIG_SMP
-	int hrtick_csd_pending;
-	struct call_single_data hrtick_csd;
-#endif
-	struct hrtimer hrtick_timer;
-#endif
-
-#ifdef CONFIG_SCHEDSTATS
-	/* latency stats */
-	struct sched_info rq_sched_info;
-	unsigned long long rq_cpu_time;
-	/* could above be rq->cfs_rq.exec_clock + rq->rt_rq.rt_runtime ? */
-
-	/* sys_sched_yield() stats */
-	unsigned int yld_count;
-
-	/* schedule() stats */
-	unsigned int sched_switch;
-	unsigned int sched_count;
-	unsigned int sched_goidle;
-
-	/* try_to_wake_up() stats */
-	unsigned int ttwu_count;
-	unsigned int ttwu_local;
-#endif
-
-#ifdef CONFIG_SMP
-	struct llist_head wake_list;
-#endif
-};
-
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
-
-
-static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags);
-
-static inline int cpu_of(struct rq *rq)
-{
-#ifdef CONFIG_SMP
-	return rq->cpu;
-#else
-	return 0;
-#endif
-}
-
-#define rcu_dereference_check_sched_domain(p) \
-	rcu_dereference_check((p), \
-			      lockdep_is_held(&sched_domains_mutex))
-
-/*
- * The domain tree (rq->sd) is protected by RCU's quiescent state transition.
- * See detach_destroy_domains: synchronize_sched for details.
- *
- * The domain tree of any CPU may only be accessed from within
- * preempt-disabled sections.
- */
-#define for_each_domain(cpu, __sd) \
-	for (__sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)
-
-#define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
-#define this_rq()		(&__get_cpu_var(runqueues))
-#define task_rq(p)		cpu_rq(task_cpu(p))
-#define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
-#define raw_rq()		(&__raw_get_cpu_var(runqueues))
-
-#ifdef CONFIG_CGROUP_SCHED
-
-/*
- * Return the group to which this tasks belongs.
- *
- * We use task_subsys_state_check() and extend the RCU verification with
- * pi->lock and rq->lock because cpu_cgroup_attach() holds those locks for each
- * task it moves into the cgroup. Therefore by holding either of those locks,
- * we pin the task to the current cgroup.
- */
-static inline struct task_group *task_group(struct task_struct *p)
-{
-	struct task_group *tg;
-	struct cgroup_subsys_state *css;
-
-	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
-			lockdep_is_held(&p->pi_lock) ||
-			lockdep_is_held(&task_rq(p)->lock));
-	tg = container_of(css, struct task_group, css);
-
-	return autogroup_task_group(p, tg);
-}
-
-/* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
-static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
-{
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
-	p->se.parent = task_group(p)->se[cpu];
-#endif
-
-#ifdef CONFIG_RT_GROUP_SCHED
-	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
-	p->rt.parent = task_group(p)->rt_se[cpu];
-#endif
-}
-
-#else /* CONFIG_CGROUP_SCHED */
-
-static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
-static inline struct task_group *task_group(struct task_struct *p)
-{
-	return NULL;
-}
-
-#endif /* CONFIG_CGROUP_SCHED */
+DEFINE_MUTEX(sched_domains_mutex);
+DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
 static void update_rq_clock_task(struct rq *rq, s64 delta);
 
-static void update_rq_clock(struct rq *rq)
+void update_rq_clock(struct rq *rq)
 {
 	s64 delta;
 
@@ -803,44 +122,14 @@ static void update_rq_clock(struct rq *rq)
 }
 
 /*
- * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
- */
-#ifdef CONFIG_SCHED_DEBUG
-# define const_debug __read_mostly
-#else
-# define const_debug static const
-#endif
-
-/**
- * runqueue_is_locked - Returns true if the current cpu runqueue is locked
- * @cpu: the processor in question.
- *
- * This interface allows printk to be called with the runqueue lock
- * held and know whether or not it is OK to wake up the klogd.
- */
-int runqueue_is_locked(int cpu)
-{
-	return raw_spin_is_locked(&cpu_rq(cpu)->lock);
-}
-
-/*
  * Debugging: various feature bits
  */
 
 #define SCHED_FEAT(name, enabled)	\
-	__SCHED_FEAT_##name ,
-
-enum {
-#include "sched_features.h"
-};
-
-#undef SCHED_FEAT
-
-#define SCHED_FEAT(name, enabled)	\
 	(1UL << __SCHED_FEAT_##name) * enabled |
 
 const_debug unsigned int sysctl_sched_features =
-#include "sched_features.h"
+#include "features.h"
 	0;
 
 #undef SCHED_FEAT
@@ -850,7 +139,7 @@ const_debug unsigned int sysctl_sched_features =
 	#name ,
 
 static __read_mostly char *sched_feat_names[] = {
-#include "sched_features.h"
+#include "features.h"
 	NULL
 };
 
@@ -860,7 +149,7 @@ static int sched_feat_show(struct seq_file *m, void *v)
 {
 	int i;
 
-	for (i = 0; sched_feat_names[i]; i++) {
+	for (i = 0; i < __SCHED_FEAT_NR; i++) {
 		if (!(sysctl_sched_features & (1UL << i)))
 			seq_puts(m, "NO_");
 		seq_printf(m, "%s ", sched_feat_names[i]);
@@ -870,6 +159,36 @@ static int sched_feat_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+#ifdef HAVE_JUMP_LABEL
+
+#define jump_label_key__true  jump_label_key_enabled
+#define jump_label_key__false jump_label_key_disabled
+
+#define SCHED_FEAT(name, enabled)	\
+	jump_label_key__##enabled ,
+
+struct jump_label_key sched_feat_keys[__SCHED_FEAT_NR] = {
+#include "features.h"
+};
+
+#undef SCHED_FEAT
+
+static void sched_feat_disable(int i)
+{
+	if (jump_label_enabled(&sched_feat_keys[i]))
+		jump_label_dec(&sched_feat_keys[i]);
+}
+
+static void sched_feat_enable(int i)
+{
+	if (!jump_label_enabled(&sched_feat_keys[i]))
+		jump_label_inc(&sched_feat_keys[i]);
+}
+#else
+static void sched_feat_disable(int i) { };
+static void sched_feat_enable(int i) { };
+#endif /* HAVE_JUMP_LABEL */
+
 static ssize_t
 sched_feat_write(struct file *filp, const char __user *ubuf,
 		size_t cnt, loff_t *ppos)
@@ -893,17 +212,20 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 		cmp += 3;
 	}
 
-	for (i = 0; sched_feat_names[i]; i++) {
+	for (i = 0; i < __SCHED_FEAT_NR; i++) {
 		if (strcmp(cmp, sched_feat_names[i]) == 0) {
-			if (neg)
+			if (neg) {
 				sysctl_sched_features &= ~(1UL << i);
-			else
+				sched_feat_disable(i);
+			} else {
 				sysctl_sched_features |= (1UL << i);
+				sched_feat_enable(i);
+			}
 			break;
 		}
 	}
 
-	if (!sched_feat_names[i])
+	if (i == __SCHED_FEAT_NR)
 		return -EINVAL;
 
 	*ppos += cnt;
@@ -932,10 +254,7 @@ static __init int sched_init_debug(void)
 	return 0;
 }
 late_initcall(sched_init_debug);
-
-#endif
-
-#define sched_feat(x) (sysctl_sched_features & (1UL << __SCHED_FEAT_##x))
+#endif /* CONFIG_SCHED_DEBUG */
 
 /*
  * Number of tasks to iterate in a single balance run.
@@ -957,7 +276,7 @@ const_debug unsigned int sysctl_sched_time_avg = MSEC_PER_SEC;
  */
 unsigned int sysctl_sched_rt_period = 1000000;
 
-static __read_mostly int scheduler_running;
+__read_mostly int scheduler_running;
 
 /*
  * part of the period that we allow rt tasks to run in us.
@@ -965,112 +284,7 @@ static __read_mostly int scheduler_running;
  */
 int sysctl_sched_rt_runtime = 950000;
 
-static inline u64 global_rt_period(void)
-{
-	return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
-}
-
-static inline u64 global_rt_runtime(void)
-{
-	if (sysctl_sched_rt_runtime < 0)
-		return RUNTIME_INF;
 
-	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
-}
-
-#ifndef prepare_arch_switch
-# define prepare_arch_switch(next)	do { } while (0)
-#endif
-#ifndef finish_arch_switch
-# define finish_arch_switch(prev)	do { } while (0)
-#endif
-
-static inline int task_current(struct rq *rq, struct task_struct *p)
-{
-	return rq->curr == p;
-}
-
-static inline int task_running(struct rq *rq, struct task_struct *p)
-{
-#ifdef CONFIG_SMP
-	return p->on_cpu;
-#else
-	return task_current(rq, p);
-#endif
-}
-
-#ifndef __ARCH_WANT_UNLOCKED_CTXSW
-static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
-{
-#ifdef CONFIG_SMP
-	/*
-	 * We can optimise this out completely for !SMP, because the
-	 * SMP rebalancing from interrupt is the only thing that cares
-	 * here.
-	 */
-	next->on_cpu = 1;
-#endif
-}
-
-static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
-{
-#ifdef CONFIG_SMP
-	/*
-	 * After ->on_cpu is cleared, the task can be moved to a different CPU.
-	 * We must ensure this doesn't happen until the switch is completely
-	 * finished.
-	 */
-	smp_wmb();
-	prev->on_cpu = 0;
-#endif
-#ifdef CONFIG_DEBUG_SPINLOCK
-	/* this is a valid case when another task releases the spinlock */
-	rq->lock.owner = current;
-#endif
-	/*
-	 * If we are tracking spinlock dependencies then we have to
-	 * fix up the runqueue lock - which gets 'carried over' from
-	 * prev into current:
-	 */
-	spin_acquire(&rq->lock.dep_map, 0, 0, _THIS_IP_);
-
-	raw_spin_unlock_irq(&rq->lock);
-}
-
-#else /* __ARCH_WANT_UNLOCKED_CTXSW */
-static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
-{
-#ifdef CONFIG_SMP
-	/*
-	 * We can optimise this out completely for !SMP, because the
-	 * SMP rebalancing from interrupt is the only thing that cares
-	 * here.
-	 */
-	next->on_cpu = 1;
-#endif
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-	raw_spin_unlock_irq(&rq->lock);
-#else
-	raw_spin_unlock(&rq->lock);
-#endif
-}
-
-static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
-{
-#ifdef CONFIG_SMP
-	/*
-	 * After ->on_cpu is cleared, the task can be moved to a different CPU.
-	 * We must ensure this doesn't happen until the switch is completely
-	 * finished.
-	 */
-	smp_wmb();
-	prev->on_cpu = 0;
-#endif
-#ifndef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-	local_irq_enable();
-#endif
-}
-#endif /* __ARCH_WANT_UNLOCKED_CTXSW */
 
 /*
  * __task_rq_lock - lock the rq @p resides on.
@@ -1153,20 +367,6 @@ static struct rq *this_rq_lock(void)
  * rq->lock.
  */
 
-/*
- * Use hrtick when:
- *  - enabled by features
- *  - hrtimer is actually high res
- */
-static inline int hrtick_enabled(struct rq *rq)
-{
-	if (!sched_feat(HRTICK))
-		return 0;
-	if (!cpu_active(cpu_of(rq)))
-		return 0;
-	return hrtimer_is_hres_active(&rq->hrtick_timer);
-}
-
 static void hrtick_clear(struct rq *rq)
 {
 	if (hrtimer_active(&rq->hrtick_timer))
@@ -1210,7 +410,7 @@ static void __hrtick_start(void *arg)
  *
  * called with rq->lock held and irqs disabled
  */
-static void hrtick_start(struct rq *rq, u64 delay)
+void hrtick_start(struct rq *rq, u64 delay)
 {
 	struct hrtimer *timer = &rq->hrtick_timer;
 	ktime_t time = ktime_add_ns(timer->base->get_time(), delay);
@@ -1254,7 +454,7 @@ static __init void init_hrtick(void)
  *
  * called with rq->lock held and irqs disabled
  */
-static void hrtick_start(struct rq *rq, u64 delay)
+void hrtick_start(struct rq *rq, u64 delay)
 {
 	__hrtimer_start_range_ns(&rq->hrtick_timer, ns_to_ktime(delay), 0,
 			HRTIMER_MODE_REL_PINNED, 0);
@@ -1305,7 +505,7 @@ static inline void init_hrtick(void)
 #define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
 #endif
 
-static void resched_task(struct task_struct *p)
+void resched_task(struct task_struct *p)
 {
 	int cpu;
 
@@ -1326,7 +526,7 @@ static void resched_task(struct task_struct *p)
 		smp_send_reschedule(cpu);
 }
 
-static void resched_cpu(int cpu)
+void resched_cpu(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
@@ -1405,228 +605,54 @@ void wake_up_idle_cpu(int cpu)
 		smp_send_reschedule(cpu);
 }
 
-static inline bool got_nohz_idle_kick(void)
-{
-	return idle_cpu(smp_processor_id()) && this_rq()->nohz_balance_kick;
-}
-
-#else /* CONFIG_NO_HZ */
-
-static inline bool got_nohz_idle_kick(void)
-{
-	return false;
-}
-
-#endif /* CONFIG_NO_HZ */
-
-static u64 sched_avg_period(void)
-{
-	return (u64)sysctl_sched_time_avg * NSEC_PER_MSEC / 2;
-}
-
-static void sched_avg_update(struct rq *rq)
-{
-	s64 period = sched_avg_period();
-
-	while ((s64)(rq->clock - rq->age_stamp) > period) {
-		/*
-		 * Inline assembly required to prevent the compiler
-		 * optimising this loop into a divmod call.
-		 * See __iter_div_u64_rem() for another example of this.
-		 */
-		asm("" : "+rm" (rq->age_stamp));
-		rq->age_stamp += period;
-		rq->rt_avg /= 2;
-	}
-}
-
-static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
-{
-	rq->rt_avg += rt_delta;
-	sched_avg_update(rq);
-}
-
-#else /* !CONFIG_SMP */
-static void resched_task(struct task_struct *p)
-{
-	assert_raw_spin_locked(&task_rq(p)->lock);
-	set_tsk_need_resched(p);
-}
-
-static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
-{
-}
-
-static void sched_avg_update(struct rq *rq)
-{
-}
-#endif /* CONFIG_SMP */
-
-#if BITS_PER_LONG == 32
-# define WMULT_CONST	(~0UL)
-#else
-# define WMULT_CONST	(1UL << 32)
-#endif
-
-#define WMULT_SHIFT	32
-
-/*
- * Shift right and round:
- */
-#define SRR(x, y) (((x) + (1UL << ((y) - 1))) >> (y))
-
-/*
- * delta *= weight / lw
- */
-static unsigned long
-calc_delta_mine(unsigned long delta_exec, unsigned long weight,
-		struct load_weight *lw)
-{
-	u64 tmp;
-
-	/*
-	 * weight can be less than 2^SCHED_LOAD_RESOLUTION for task group sched
-	 * entities since MIN_SHARES = 2. Treat weight as 1 if less than
-	 * 2^SCHED_LOAD_RESOLUTION.
-	 */
-	if (likely(weight > (1UL << SCHED_LOAD_RESOLUTION)))
-		tmp = (u64)delta_exec * scale_load_down(weight);
-	else
-		tmp = (u64)delta_exec;
-
-	if (!lw->inv_weight) {
-		unsigned long w = scale_load_down(lw->weight);
-
-		if (BITS_PER_LONG > 32 && unlikely(w >= WMULT_CONST))
-			lw->inv_weight = 1;
-		else if (unlikely(!w))
-			lw->inv_weight = WMULT_CONST;
-		else
-			lw->inv_weight = WMULT_CONST / w;
-	}
-
-	/*
-	 * Check whether we'd overflow the 64-bit multiplication:
-	 */
-	if (unlikely(tmp > WMULT_CONST))
-		tmp = SRR(SRR(tmp, WMULT_SHIFT/2) * lw->inv_weight,
-			WMULT_SHIFT/2);
-	else
-		tmp = SRR(tmp * lw->inv_weight, WMULT_SHIFT);
-
-	return (unsigned long)min(tmp, (u64)(unsigned long)LONG_MAX);
-}
-
-static inline void update_load_add(struct load_weight *lw, unsigned long inc)
-{
-	lw->weight += inc;
-	lw->inv_weight = 0;
-}
-
-static inline void update_load_sub(struct load_weight *lw, unsigned long dec)
-{
-	lw->weight -= dec;
-	lw->inv_weight = 0;
-}
-
-static inline void update_load_set(struct load_weight *lw, unsigned long w)
+static inline bool got_nohz_idle_kick(void)
 {
-	lw->weight = w;
-	lw->inv_weight = 0;
+	int cpu = smp_processor_id();
+	return idle_cpu(cpu) && test_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu));
 }
 
-/*
- * To aid in avoiding the subversion of "niceness" due to uneven distribution
- * of tasks with abnormal "nice" values across CPUs the contribution that
- * each task makes to its run queue's load is weighted according to its
- * scheduling class and "nice" value. For SCHED_NORMAL tasks this is just a
- * scaled version of the new time slice allocation that they receive on time
- * slice expiry etc.
- */
-
-#define WEIGHT_IDLEPRIO                3
-#define WMULT_IDLEPRIO         1431655765
-
-/*
- * Nice levels are multiplicative, with a gentle 10% change for every
- * nice level changed. I.e. when a CPU-bound task goes from nice 0 to
- * nice 1, it will get ~10% less CPU time than another CPU-bound task
- * that remained on nice 0.
- *
- * The "10% effect" is relative and cumulative: from _any_ nice level,
- * if you go up 1 level, it's -10% CPU usage, if you go down 1 level
- * it's +10% CPU usage. (to achieve that we use a multiplier of 1.25.
- * If a task goes up by ~10% and another task goes down by ~10% then
- * the relative distance between them is ~25%.)
- */
-static const int prio_to_weight[40] = {
- /* -20 */     88761,     71755,     56483,     46273,     36291,
- /* -15 */     29154,     23254,     18705,     14949,     11916,
- /* -10 */      9548,      7620,      6100,      4904,      3906,
- /*  -5 */      3121,      2501,      1991,      1586,      1277,
- /*   0 */      1024,       820,       655,       526,       423,
- /*   5 */       335,       272,       215,       172,       137,
- /*  10 */       110,        87,        70,        56,        45,
- /*  15 */        36,        29,        23,        18,        15,
-};
-
-/*
- * Inverse (2^32/x) values of the prio_to_weight[] array, precalculated.
- *
- * In cases where the weight does not change often, we can use the
- * precalculated inverse to speed up arithmetics by turning divisions
- * into multiplications:
- */
-static const u32 prio_to_wmult[40] = {
- /* -20 */     48388,     59856,     76040,     92818,    118348,
- /* -15 */    147320,    184698,    229616,    287308,    360437,
- /* -10 */    449829,    563644,    704093,    875809,   1099582,
- /*  -5 */   1376151,   1717300,   2157191,   2708050,   3363326,
- /*   0 */   4194304,   5237765,   6557202,   8165337,  10153587,
- /*   5 */  12820798,  15790321,  19976592,  24970740,  31350126,
- /*  10 */  39045157,  49367440,  61356676,  76695844,  95443717,
- /*  15 */ 119304647, 148102320, 186737708, 238609294, 286331153,
-};
-
-/* Time spent by the tasks of the cpu accounting group executing in ... */
-enum cpuacct_stat_index {
-	CPUACCT_STAT_USER,	/* ... user mode */
-	CPUACCT_STAT_SYSTEM,	/* ... kernel mode */
+#else /* CONFIG_NO_HZ */
 
-	CPUACCT_STAT_NSTATS,
-};
+static inline bool got_nohz_idle_kick(void)
+{
+	return false;
+}
 
-#ifdef CONFIG_CGROUP_CPUACCT
-static void cpuacct_charge(struct task_struct *tsk, u64 cputime);
-static void cpuacct_update_stats(struct task_struct *tsk,
-		enum cpuacct_stat_index idx, cputime_t val);
-#else
-static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
-static inline void cpuacct_update_stats(struct task_struct *tsk,
-		enum cpuacct_stat_index idx, cputime_t val) {}
-#endif
+#endif /* CONFIG_NO_HZ */
 
-static inline void inc_cpu_load(struct rq *rq, unsigned long load)
+void sched_avg_update(struct rq *rq)
 {
-	update_load_add(&rq->load, load);
+	s64 period = sched_avg_period();
+
+	while ((s64)(rq->clock - rq->age_stamp) > period) {
+		/*
+		 * Inline assembly required to prevent the compiler
+		 * optimising this loop into a divmod call.
+		 * See __iter_div_u64_rem() for another example of this.
+		 */
+		asm("" : "+rm" (rq->age_stamp));
+		rq->age_stamp += period;
+		rq->rt_avg /= 2;
+	}
 }
 
-static inline void dec_cpu_load(struct rq *rq, unsigned long load)
+#else /* !CONFIG_SMP */
+void resched_task(struct task_struct *p)
 {
-	update_load_sub(&rq->load, load);
+	assert_raw_spin_locked(&task_rq(p)->lock);
+	set_tsk_need_resched(p);
 }
+#endif /* CONFIG_SMP */
 
 #if defined(CONFIG_RT_GROUP_SCHED) || (defined(CONFIG_FAIR_GROUP_SCHED) && \
 			(defined(CONFIG_SMP) || defined(CONFIG_CFS_BANDWIDTH)))
-typedef int (*tg_visitor)(struct task_group *, void *);
-
 /*
  * Iterate task_group tree rooted at *from, calling @down when first entering a
  * node and @up when leaving it for the final time.
  *
  * Caller must hold rcu_lock or sufficient equivalent.
  */
-static int walk_tg_tree_from(struct task_group *from,
+int walk_tg_tree_from(struct task_group *from,
 			     tg_visitor down, tg_visitor up, void *data)
 {
 	struct task_group *parent, *child;
@@ -1657,270 +683,13 @@ out:
 	return ret;
 }
 
-/*
- * Iterate the full tree, calling @down when first entering a node and @up when
- * leaving it for the final time.
- *
- * Caller must hold rcu_lock or sufficient equivalent.
- */
-
-static inline int walk_tg_tree(tg_visitor down, tg_visitor up, void *data)
-{
-	return walk_tg_tree_from(&root_task_group, down, up, data);
-}
-
-static int tg_nop(struct task_group *tg, void *data)
-{
-	return 0;
-}
-#endif
-
-#ifdef CONFIG_SMP
-/* Used instead of source_load when we know the type == 0 */
-static unsigned long weighted_cpuload(const int cpu)
-{
-	return cpu_rq(cpu)->load.weight;
-}
-
-/*
- * Return a low guess at the load of a migration-source cpu weighted
- * according to the scheduling class and "nice" value.
- *
- * We want to under-estimate the load of migration sources, to
- * balance conservatively.
- */
-static unsigned long source_load(int cpu, int type)
-{
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = weighted_cpuload(cpu);
-
-	if (type == 0 || !sched_feat(LB_BIAS))
-		return total;
-
-	return min(rq->cpu_load[type-1], total);
-}
-
-/*
- * Return a high guess at the load of a migration-target cpu weighted
- * according to the scheduling class and "nice" value.
- */
-static unsigned long target_load(int cpu, int type)
-{
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = weighted_cpuload(cpu);
-
-	if (type == 0 || !sched_feat(LB_BIAS))
-		return total;
-
-	return max(rq->cpu_load[type-1], total);
-}
-
-static unsigned long power_of(int cpu)
-{
-	return cpu_rq(cpu)->cpu_power;
-}
-
-static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
-
-static unsigned long cpu_avg_load_per_task(int cpu)
+int tg_nop(struct task_group *tg, void *data)
 {
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
-
-	if (nr_running)
-		return rq->load.weight / nr_running;
-
 	return 0;
 }
-
-#ifdef CONFIG_PREEMPT
-
-static void double_rq_lock(struct rq *rq1, struct rq *rq2);
-
-/*
- * fair double_lock_balance: Safely acquires both rq->locks in a fair
- * way at the expense of forcing extra atomic operations in all
- * invocations.  This assures that the double_lock is acquired using the
- * same underlying policy as the spinlock_t on this architecture, which
- * reduces latency compared to the unfair variant below.  However, it
- * also adds more overhead and therefore may reduce throughput.
- */
-static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
-	__releases(this_rq->lock)
-	__acquires(busiest->lock)
-	__acquires(this_rq->lock)
-{
-	raw_spin_unlock(&this_rq->lock);
-	double_rq_lock(this_rq, busiest);
-
-	return 1;
-}
-
-#else
-/*
- * Unfair double_lock_balance: Optimizes throughput at the expense of
- * latency by eliminating extra atomic operations when the locks are
- * already in proper order on entry.  This favors lower cpu-ids and will
- * grant the double lock to lower cpus over higher ids under contention,
- * regardless of entry order into the function.
- */
-static int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
-	__releases(this_rq->lock)
-	__acquires(busiest->lock)
-	__acquires(this_rq->lock)
-{
-	int ret = 0;
-
-	if (unlikely(!raw_spin_trylock(&busiest->lock))) {
-		if (busiest < this_rq) {
-			raw_spin_unlock(&this_rq->lock);
-			raw_spin_lock(&busiest->lock);
-			raw_spin_lock_nested(&this_rq->lock,
-					      SINGLE_DEPTH_NESTING);
-			ret = 1;
-		} else
-			raw_spin_lock_nested(&busiest->lock,
-					      SINGLE_DEPTH_NESTING);
-	}
-	return ret;
-}
-
-#endif /* CONFIG_PREEMPT */
-
-/*
- * double_lock_balance - lock the busiest runqueue, this_rq is locked already.
- */
-static int double_lock_balance(struct rq *this_rq, struct rq *busiest)
-{
-	if (unlikely(!irqs_disabled())) {
-		/* printk() doesn't work good under rq->lock */
-		raw_spin_unlock(&this_rq->lock);
-		BUG_ON(1);
-	}
-
-	return _double_lock_balance(this_rq, busiest);
-}
-
-static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
-	__releases(busiest->lock)
-{
-	raw_spin_unlock(&busiest->lock);
-	lock_set_subclass(&this_rq->lock.dep_map, 0, _RET_IP_);
-}
-
-/*
- * double_rq_lock - safely lock two runqueues
- *
- * Note this does not disable interrupts like task_rq_lock,
- * you need to do so manually before calling.
- */
-static void double_rq_lock(struct rq *rq1, struct rq *rq2)
-	__acquires(rq1->lock)
-	__acquires(rq2->lock)
-{
-	BUG_ON(!irqs_disabled());
-	if (rq1 == rq2) {
-		raw_spin_lock(&rq1->lock);
-		__acquire(rq2->lock);	/* Fake it out ;) */
-	} else {
-		if (rq1 < rq2) {
-			raw_spin_lock(&rq1->lock);
-			raw_spin_lock_nested(&rq2->lock, SINGLE_DEPTH_NESTING);
-		} else {
-			raw_spin_lock(&rq2->lock);
-			raw_spin_lock_nested(&rq1->lock, SINGLE_DEPTH_NESTING);
-		}
-	}
-}
-
-/*
- * double_rq_unlock - safely unlock two runqueues
- *
- * Note this does not restore interrupts like task_rq_unlock,
- * you need to do so manually after calling.
- */
-static void double_rq_unlock(struct rq *rq1, struct rq *rq2)
-	__releases(rq1->lock)
-	__releases(rq2->lock)
-{
-	raw_spin_unlock(&rq1->lock);
-	if (rq1 != rq2)
-		raw_spin_unlock(&rq2->lock);
-	else
-		__release(rq2->lock);
-}
-
-#else /* CONFIG_SMP */
-
-/*
- * double_rq_lock - safely lock two runqueues
- *
- * Note this does not disable interrupts like task_rq_lock,
- * you need to do so manually before calling.
- */
-static void double_rq_lock(struct rq *rq1, struct rq *rq2)
-	__acquires(rq1->lock)
-	__acquires(rq2->lock)
-{
-	BUG_ON(!irqs_disabled());
-	BUG_ON(rq1 != rq2);
-	raw_spin_lock(&rq1->lock);
-	__acquire(rq2->lock);	/* Fake it out ;) */
-}
-
-/*
- * double_rq_unlock - safely unlock two runqueues
- *
- * Note this does not restore interrupts like task_rq_unlock,
- * you need to do so manually after calling.
- */
-static void double_rq_unlock(struct rq *rq1, struct rq *rq2)
-	__releases(rq1->lock)
-	__releases(rq2->lock)
-{
-	BUG_ON(rq1 != rq2);
-	raw_spin_unlock(&rq1->lock);
-	__release(rq2->lock);
-}
-
-#endif
-
-static void calc_load_account_idle(struct rq *this_rq);
-static void update_sysctl(void);
-static int get_update_sysctl_factor(void);
-static void update_cpu_load(struct rq *this_rq);
-
-static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
-{
-	set_task_rq(p, cpu);
-#ifdef CONFIG_SMP
-	/*
-	 * After ->cpu is set up to a new value, task_rq_lock(p, ...) can be
-	 * successfully executed on another CPU. We must ensure that updates of
-	 * per-task data have been completed by this moment.
-	 */
-	smp_wmb();
-	task_thread_info(p)->cpu = cpu;
 #endif
-}
-
-static const struct sched_class rt_sched_class;
-
-#define sched_class_highest (&stop_sched_class)
-#define for_each_class(class) \
-   for (class = sched_class_highest; class; class = class->next)
-
-#include "sched_stats.h"
-
-static void inc_nr_running(struct rq *rq)
-{
-	rq->nr_running++;
-}
 
-static void dec_nr_running(struct rq *rq)
-{
-	rq->nr_running--;
-}
+void update_cpu_load(struct rq *this_rq);
 
 static void set_load_weight(struct task_struct *p)
 {
@@ -1957,7 +726,7 @@ static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
 /*
  * activate_task - move a task to the runqueue.
  */
-static void activate_task(struct rq *rq, struct task_struct *p, int flags)
+void activate_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
@@ -1968,7 +737,7 @@ static void activate_task(struct rq *rq, struct task_struct *p, int flags)
 /*
  * deactivate_task - remove a task from the runqueue.
  */
-static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
+void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible++;
@@ -2159,14 +928,14 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 static int irqtime_account_hi_update(void)
 {
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	unsigned long flags;
 	u64 latest_ns;
 	int ret = 0;
 
 	local_irq_save(flags);
 	latest_ns = this_cpu_read(cpu_hardirq_time);
-	if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat->irq))
+	if (nsecs_to_cputime64(latest_ns) > cpustat[CPUTIME_IRQ])
 		ret = 1;
 	local_irq_restore(flags);
 	return ret;
@@ -2174,14 +943,14 @@ static int irqtime_account_hi_update(void)
 
 static int irqtime_account_si_update(void)
 {
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	unsigned long flags;
 	u64 latest_ns;
 	int ret = 0;
 
 	local_irq_save(flags);
 	latest_ns = this_cpu_read(cpu_softirq_time);
-	if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat->softirq))
+	if (nsecs_to_cputime64(latest_ns) > cpustat[CPUTIME_SOFTIRQ])
 		ret = 1;
 	local_irq_restore(flags);
 	return ret;
@@ -2193,15 +962,6 @@ static int irqtime_account_si_update(void)
 
 #endif
 
-#include "sched_idletask.c"
-#include "sched_fair.c"
-#include "sched_rt.c"
-#include "sched_autogroup.c"
-#include "sched_stoptask.c"
-#ifdef CONFIG_SCHED_DEBUG
-# include "sched_debug.c"
-#endif
-
 void sched_set_stop_task(int cpu, struct task_struct *stop)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
@@ -2299,7 +1059,7 @@ static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 		p->sched_class->prio_changed(rq, p, oldprio);
 }
 
-static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
+void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
 {
 	const struct sched_class *class;
 
@@ -2325,38 +1085,6 @@ static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
 }
 
 #ifdef CONFIG_SMP
-/*
- * Is this task likely cache-hot:
- */
-static int
-task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
-{
-	s64 delta;
-
-	if (p->sched_class != &fair_sched_class)
-		return 0;
-
-	if (unlikely(p->policy == SCHED_IDLE))
-		return 0;
-
-	/*
-	 * Buddy candidates are cache hot:
-	 */
-	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
-			(&p->se == cfs_rq_of(&p->se)->next ||
-			 &p->se == cfs_rq_of(&p->se)->last))
-		return 1;
-
-	if (sysctl_sched_migration_cost == -1)
-		return 1;
-	if (sysctl_sched_migration_cost == 0)
-		return 0;
-
-	delta = now - p->se.exec_start;
-
-	return delta < (s64)sysctl_sched_migration_cost;
-}
-
 void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 {
 #ifdef CONFIG_SCHED_DEBUG
@@ -2783,6 +1511,11 @@ static int ttwu_activate_remote(struct task_struct *p, int wake_flags)
 
 }
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
+
+static inline int ttwu_share_cache(int this_cpu, int that_cpu)
+{
+	return per_cpu(sd_llc_id, this_cpu) == per_cpu(sd_llc_id, that_cpu);
+}
 #endif /* CONFIG_SMP */
 
 static void ttwu_queue(struct task_struct *p, int cpu)
@@ -2790,7 +1523,7 @@ static void ttwu_queue(struct task_struct *p, int cpu)
 	struct rq *rq = cpu_rq(cpu);
 
 #if defined(CONFIG_SMP)
-	if (sched_feat(TTWU_QUEUE) && cpu != smp_processor_id()) {
+	if (sched_feat(TTWU_QUEUE) && !ttwu_share_cache(smp_processor_id(), cpu)) {
 		sched_clock_cpu(cpu); /* sync clocks x-cpu */
 		ttwu_queue_remote(p, cpu);
 		return;
@@ -3204,6 +1937,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	local_irq_enable();
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	finish_lock_switch(rq, prev);
+	trace_sched_stat_sleeptime(current, rq->clock);
 
 	fire_sched_in_preempt_notifiers(current);
 	if (mm)
@@ -3439,7 +2173,7 @@ calc_load(unsigned long load, unsigned long exp, unsigned long active)
  */
 static atomic_long_t calc_load_tasks_idle;
 
-static void calc_load_account_idle(struct rq *this_rq)
+void calc_load_account_idle(struct rq *this_rq)
 {
 	long delta;
 
@@ -3583,7 +2317,7 @@ static void calc_global_nohz(unsigned long ticks)
 	 */
 }
 #else
-static void calc_load_account_idle(struct rq *this_rq)
+void calc_load_account_idle(struct rq *this_rq)
 {
 }
 
@@ -3726,7 +2460,7 @@ decay_load_missed(unsigned long load, unsigned long missed_updates, int idx)
  * scheduler tick (TICK_NSEC). With tickless idle this will not be called
  * every tick. We fix it up based on jiffies.
  */
-static void update_cpu_load(struct rq *this_rq)
+void update_cpu_load(struct rq *this_rq)
 {
 	unsigned long this_load = this_rq->load.weight;
 	unsigned long curr_jiffies = jiffies;
@@ -3804,8 +2538,10 @@ unlock:
 #endif
 
 DEFINE_PER_CPU(struct kernel_stat, kstat);
+DEFINE_PER_CPU(struct kernel_cpustat, kernel_cpustat);
 
 EXPORT_PER_CPU_SYMBOL(kstat);
+EXPORT_PER_CPU_SYMBOL(kernel_cpustat);
 
 /*
  * Return any ns on the sched_clock that have not yet been accounted in
@@ -3858,6 +2594,42 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 	return ns;
 }
 
+#ifdef CONFIG_CGROUP_CPUACCT
+struct cgroup_subsys cpuacct_subsys;
+struct cpuacct root_cpuacct;
+#endif
+
+static inline void task_group_account_field(struct task_struct *p, int index,
+					    u64 tmp)
+{
+#ifdef CONFIG_CGROUP_CPUACCT
+	struct kernel_cpustat *kcpustat;
+	struct cpuacct *ca;
+#endif
+	/*
+	 * Since all updates are sure to touch the root cgroup, we
+	 * get ourselves ahead and touch it first. If the root cgroup
+	 * is the only cgroup, then nothing else should be necessary.
+	 *
+	 */
+	__get_cpu_var(kernel_cpustat).cpustat[index] += tmp;
+
+#ifdef CONFIG_CGROUP_CPUACCT
+	if (unlikely(!cpuacct_subsys.active))
+		return;
+
+	rcu_read_lock();
+	ca = task_ca(p);
+	while (ca && (ca != &root_cpuacct)) {
+		kcpustat = this_cpu_ptr(ca->cpustat);
+		kcpustat->cpustat[index] += tmp;
+		ca = parent_ca(ca);
+	}
+	rcu_read_unlock();
+#endif
+}
+
+
 /*
  * Account user cpu time to a process.
  * @p: the process that the cpu time gets accounted to
@@ -3867,22 +2639,18 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 void account_user_time(struct task_struct *p, cputime_t cputime,
 		       cputime_t cputime_scaled)
 {
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
-	cputime64_t tmp;
+	int index;
 
 	/* Add user time to process. */
-	p->utime = cputime_add(p->utime, cputime);
-	p->utimescaled = cputime_add(p->utimescaled, cputime_scaled);
+	p->utime += cputime;
+	p->utimescaled += cputime_scaled;
 	account_group_user_time(p, cputime);
 
+	index = (TASK_NICE(p) > 0) ? CPUTIME_NICE : CPUTIME_USER;
+
 	/* Add user time to cpustat. */
-	tmp = cputime_to_cputime64(cputime);
-	if (TASK_NICE(p) > 0)
-		cpustat->nice = cputime64_add(cpustat->nice, tmp);
-	else
-		cpustat->user = cputime64_add(cpustat->user, tmp);
+	task_group_account_field(p, index, (__force u64) cputime);
 
-	cpuacct_update_stats(p, CPUACCT_STAT_USER, cputime);
 	/* Account for user time used */
 	acct_update_integrals(p);
 }
@@ -3896,24 +2664,21 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 static void account_guest_time(struct task_struct *p, cputime_t cputime,
 			       cputime_t cputime_scaled)
 {
-	cputime64_t tmp;
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
-
-	tmp = cputime_to_cputime64(cputime);
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
 
 	/* Add guest time to process. */
-	p->utime = cputime_add(p->utime, cputime);
-	p->utimescaled = cputime_add(p->utimescaled, cputime_scaled);
+	p->utime += cputime;
+	p->utimescaled += cputime_scaled;
 	account_group_user_time(p, cputime);
-	p->gtime = cputime_add(p->gtime, cputime);
+	p->gtime += cputime;
 
 	/* Add guest time to cpustat. */
 	if (TASK_NICE(p) > 0) {
-		cpustat->nice = cputime64_add(cpustat->nice, tmp);
-		cpustat->guest_nice = cputime64_add(cpustat->guest_nice, tmp);
+		cpustat[CPUTIME_NICE] += (__force u64) cputime;
+		cpustat[CPUTIME_GUEST_NICE] += (__force u64) cputime;
 	} else {
-		cpustat->user = cputime64_add(cpustat->user, tmp);
-		cpustat->guest = cputime64_add(cpustat->guest, tmp);
+		cpustat[CPUTIME_USER] += (__force u64) cputime;
+		cpustat[CPUTIME_GUEST] += (__force u64) cputime;
 	}
 }
 
@@ -3926,18 +2691,15 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
  */
 static inline
 void __account_system_time(struct task_struct *p, cputime_t cputime,
-			cputime_t cputime_scaled, cputime64_t *target_cputime64)
+			cputime_t cputime_scaled, int index)
 {
-	cputime64_t tmp = cputime_to_cputime64(cputime);
-
 	/* Add system time to process. */
-	p->stime = cputime_add(p->stime, cputime);
-	p->stimescaled = cputime_add(p->stimescaled, cputime_scaled);
+	p->stime += cputime;
+	p->stimescaled += cputime_scaled;
 	account_group_system_time(p, cputime);
 
 	/* Add system time to cpustat. */
-	*target_cputime64 = cputime64_add(*target_cputime64, tmp);
-	cpuacct_update_stats(p, CPUACCT_STAT_SYSTEM, cputime);
+	task_group_account_field(p, index, (__force u64) cputime);
 
 	/* Account for system time used */
 	acct_update_integrals(p);
@@ -3953,8 +2715,7 @@ void __account_system_time(struct task_struct *p, cputime_t cputime,
 void account_system_time(struct task_struct *p, int hardirq_offset,
 			 cputime_t cputime, cputime_t cputime_scaled)
 {
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
-	cputime64_t *target_cputime64;
+	int index;
 
 	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
 		account_guest_time(p, cputime, cputime_scaled);
@@ -3962,13 +2723,13 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	}
 
 	if (hardirq_count() - hardirq_offset)
-		target_cputime64 = &cpustat->irq;
+		index = CPUTIME_IRQ;
 	else if (in_serving_softirq())
-		target_cputime64 = &cpustat->softirq;
+		index = CPUTIME_SOFTIRQ;
 	else
-		target_cputime64 = &cpustat->system;
+		index = CPUTIME_SYSTEM;
 
-	__account_system_time(p, cputime, cputime_scaled, target_cputime64);
+	__account_system_time(p, cputime, cputime_scaled, index);
 }
 
 /*
@@ -3977,10 +2738,9 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
  */
 void account_steal_time(cputime_t cputime)
 {
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
-	cputime64_t cputime64 = cputime_to_cputime64(cputime);
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
 
-	cpustat->steal = cputime64_add(cpustat->steal, cputime64);
+	cpustat[CPUTIME_STEAL] += (__force u64) cputime;
 }
 
 /*
@@ -3989,14 +2749,13 @@ void account_steal_time(cputime_t cputime)
  */
 void account_idle_time(cputime_t cputime)
 {
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
-	cputime64_t cputime64 = cputime_to_cputime64(cputime);
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	struct rq *rq = this_rq();
 
 	if (atomic_read(&rq->nr_iowait) > 0)
-		cpustat->iowait = cputime64_add(cpustat->iowait, cputime64);
+		cpustat[CPUTIME_IOWAIT] += (__force u64) cputime;
 	else
-		cpustat->idle = cputime64_add(cpustat->idle, cputime64);
+		cpustat[CPUTIME_IDLE] += (__force u64) cputime;
 }
 
 static __always_inline bool steal_account_process_tick(void)
@@ -4046,16 +2805,15 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 						struct rq *rq)
 {
 	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
-	cputime64_t tmp = cputime_to_cputime64(cputime_one_jiffy);
-	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
 
 	if (steal_account_process_tick())
 		return;
 
 	if (irqtime_account_hi_update()) {
-		cpustat->irq = cputime64_add(cpustat->irq, tmp);
+		cpustat[CPUTIME_IRQ] += (__force u64) cputime_one_jiffy;
 	} else if (irqtime_account_si_update()) {
-		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
+		cpustat[CPUTIME_SOFTIRQ] += (__force u64) cputime_one_jiffy;
 	} else if (this_cpu_ksoftirqd() == p) {
 		/*
 		 * ksoftirqd time do not get accounted in cpu_softirq_time.
@@ -4063,7 +2821,7 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 		 * Also, p->stime needs to be updated for ksoftirqd.
 		 */
 		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
-					&cpustat->softirq);
+					CPUTIME_SOFTIRQ);
 	} else if (user_tick) {
 		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
 	} else if (p == rq->idle) {
@@ -4072,7 +2830,7 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 		account_guest_time(p, cputime_one_jiffy, one_jiffy_scaled);
 	} else {
 		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
-					&cpustat->system);
+					CPUTIME_SYSTEM);
 	}
 }
 
@@ -4171,7 +2929,7 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 
 void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
-	cputime_t rtime, utime = p->utime, total = cputime_add(utime, p->stime);
+	cputime_t rtime, utime = p->utime, total = utime + p->stime;
 
 	/*
 	 * Use CFS's precise accounting:
@@ -4179,11 +2937,11 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	rtime = nsecs_to_cputime(p->se.sum_exec_runtime);
 
 	if (total) {
-		u64 temp = rtime;
+		u64 temp = (__force u64) rtime;
 
-		temp *= utime;
-		do_div(temp, total);
-		utime = (cputime_t)temp;
+		temp *= (__force u64) utime;
+		do_div(temp, (__force u32) total);
+		utime = (__force cputime_t) temp;
 	} else
 		utime = rtime;
 
@@ -4191,7 +2949,7 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	 * Compare with previous values, to keep monotonicity:
 	 */
 	p->prev_utime = max(p->prev_utime, utime);
-	p->prev_stime = max(p->prev_stime, cputime_sub(rtime, p->prev_utime));
+	p->prev_stime = max(p->prev_stime, rtime - p->prev_utime);
 
 	*ut = p->prev_utime;
 	*st = p->prev_stime;
@@ -4208,21 +2966,20 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 
 	thread_group_cputime(p, &cputime);
 
-	total = cputime_add(cputime.utime, cputime.stime);
+	total = cputime.utime + cputime.stime;
 	rtime = nsecs_to_cputime(cputime.sum_exec_runtime);
 
 	if (total) {
-		u64 temp = rtime;
+		u64 temp = (__force u64) rtime;
 
-		temp *= cputime.utime;
-		do_div(temp, total);
-		utime = (cputime_t)temp;
+		temp *= (__force u64) cputime.utime;
+		do_div(temp, (__force u32) total);
+		utime = (__force cputime_t) temp;
 	} else
 		utime = rtime;
 
 	sig->prev_utime = max(sig->prev_utime, utime);
-	sig->prev_stime = max(sig->prev_stime,
-			      cputime_sub(rtime, sig->prev_utime));
+	sig->prev_stime = max(sig->prev_stime, rtime - sig->prev_utime);
 
 	*ut = sig->prev_utime;
 	*st = sig->prev_stime;
@@ -4321,6 +3078,9 @@ static noinline void __schedule_bug(struct task_struct *prev)
 {
 	struct pt_regs *regs = get_irq_regs();
 
+	if (oops_in_progress)
+		return;
+
 	printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
 		prev->comm, prev->pid, preempt_count());
 
@@ -5852,6 +4612,13 @@ again:
 		 */
 		if (preempt && rq != p_rq)
 			resched_task(p_rq->curr);
+	} else {
+		/*
+		 * We might have set it in task_yield_fair(), but are
+		 * not going to schedule(), so don't want to skip
+		 * the next update.
+		 */
+		rq->skip_clock_update = 0;
 	}
 
 out:
@@ -6019,7 +4786,7 @@ void sched_show_task(struct task_struct *p)
 	free = stack_not_used(p);
 #endif
 	printk(KERN_CONT "%5lu %5d %6d 0x%08lx\n", free,
-		task_pid_nr(p), task_pid_nr(p->real_parent),
+		task_pid_nr(p), task_pid_nr(rcu_dereference(p->real_parent)),
 		(unsigned long)task_thread_info(p)->flags);
 
 	show_stack(p, NULL);
@@ -6118,53 +4885,6 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 #endif
 }
 
-/*
- * Increase the granularity value when there are more CPUs,
- * because with more CPUs the 'effective latency' as visible
- * to users decreases. But the relationship is not linear,
- * so pick a second-best guess by going with the log2 of the
- * number of CPUs.
- *
- * This idea comes from the SD scheduler of Con Kolivas:
- */
-static int get_update_sysctl_factor(void)
-{
-	unsigned int cpus = min_t(int, num_online_cpus(), 8);
-	unsigned int factor;
-
-	switch (sysctl_sched_tunable_scaling) {
-	case SCHED_TUNABLESCALING_NONE:
-		factor = 1;
-		break;
-	case SCHED_TUNABLESCALING_LINEAR:
-		factor = cpus;
-		break;
-	case SCHED_TUNABLESCALING_LOG:
-	default:
-		factor = 1 + ilog2(cpus);
-		break;
-	}
-
-	return factor;
-}
-
-static void update_sysctl(void)
-{
-	unsigned int factor = get_update_sysctl_factor();
-
-#define SET_SYSCTL(name) \
-	(sysctl_##name = (factor) * normalized_sysctl_##name)
-	SET_SYSCTL(sched_min_granularity);
-	SET_SYSCTL(sched_latency);
-	SET_SYSCTL(sched_wakeup_granularity);
-#undef SET_SYSCTL
-}
-
-static inline void sched_init_granularity(void)
-{
-	update_sysctl();
-}
-
 #ifdef CONFIG_SMP
 void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
 {
@@ -6342,38 +5062,14 @@ static void migrate_nr_uninterruptible(struct rq *rq_src)
 	rq_src->nr_uninterruptible = 0;
 }
 
-/*
- * remove the tasks which were accounted by rq from calc_load_tasks.
- */
-static void calc_global_load_remove(struct rq *rq)
-{
-	atomic_long_sub(rq->calc_load_active, &calc_load_tasks);
-	rq->calc_load_active = 0;
-}
-
-#ifdef CONFIG_CFS_BANDWIDTH
-static void unthrottle_offline_cfs_rqs(struct rq *rq)
-{
-	struct cfs_rq *cfs_rq;
-
-	for_each_leaf_cfs_rq(rq, cfs_rq) {
-		struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
-
-		if (!cfs_rq->runtime_enabled)
-			continue;
-
-		/*
-		 * clock_task is not advancing so we just need to make sure
-		 * there's some valid quota amount
-		 */
-		cfs_rq->runtime_remaining = cfs_b->quota;
-		if (cfs_rq_throttled(cfs_rq))
-			unthrottle_cfs_rq(cfs_rq);
-	}
+/*
+ * remove the tasks which were accounted by rq from calc_load_tasks.
+ */
+static void calc_global_load_remove(struct rq *rq)
+{
+	atomic_long_sub(rq->calc_load_active, &calc_load_tasks);
+	rq->calc_load_active = 0;
 }
-#else
-static void unthrottle_offline_cfs_rqs(struct rq *rq) {}
-#endif
 
 /*
  * Migrate all tasks from the rq, sleeping tasks will be migrated by
@@ -6980,6 +5676,12 @@ out:
 	return -ENOMEM;
 }
 
+/*
+ * By default the system creates a single root-domain with all cpus as
+ * members (mimicking the global state we have today).
+ */
+struct root_domain def_root_domain;
+
 static void init_defrootdomain(void)
 {
 	init_rootdomain(&def_root_domain);
@@ -7051,6 +5753,31 @@ static void destroy_sched_domains(struct sched_domain *sd, int cpu)
 }
 
 /*
+ * Keep a special pointer to the highest sched_domain that has
+ * SD_SHARE_PKG_RESOURCE set (Last Level Cache Domain) for this
+ * allows us to avoid some pointer chasing select_idle_sibling().
+ *
+ * Also keep a unique ID per domain (we use the first cpu number in
+ * the cpumask of the domain), this allows us to quickly tell if
+ * two cpus are in the same cache domain, see ttwu_share_cache().
+ */
+DEFINE_PER_CPU(struct sched_domain *, sd_llc);
+DEFINE_PER_CPU(int, sd_llc_id);
+
+static void update_top_cache_domain(int cpu)
+{
+	struct sched_domain *sd;
+	int id = cpu;
+
+	sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES);
+	if (sd)
+		id = cpumask_first(sched_domain_span(sd));
+
+	rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
+	per_cpu(sd_llc_id, cpu) = id;
+}
+
+/*
  * Attach the domain 'sd' to 'cpu' as its base domain. Callers must
  * hold the hotplug lock.
  */
@@ -7089,6 +5816,8 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	tmp = rq->sd;
 	rcu_assign_pointer(rq->sd, sd);
 	destroy_sched_domains(tmp, cpu);
+
+	update_top_cache_domain(cpu);
 }
 
 /* cpus with isolated domains */
@@ -7248,7 +5977,7 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 			continue;
 
 		sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
-				GFP_KERNEL, cpu_to_node(i));
+				GFP_KERNEL, cpu_to_node(cpu));
 
 		if (!sg)
 			goto fail;
@@ -7386,6 +6115,12 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 		return;
 
 	update_group_power(sd, cpu);
+	atomic_set(&sg->sgp->nr_busy_cpus, sg->group_weight);
+}
+
+int __weak arch_sd_sibling_asym_packing(void)
+{
+       return 0*SD_ASYM_PACKING;
 }
 
 /*
@@ -8023,29 +6758,6 @@ static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
 	}
 }
 
-static int update_runtime(struct notifier_block *nfb,
-				unsigned long action, void *hcpu)
-{
-	int cpu = (int)(long)hcpu;
-
-	switch (action) {
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
-		disable_runtime(cpu_rq(cpu));
-		return NOTIFY_OK;
-
-	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		enable_runtime(cpu_rq(cpu));
-		return NOTIFY_OK;
-
-	default:
-		return NOTIFY_DONE;
-	}
-}
-
 void __init sched_init_smp(void)
 {
 	cpumask_var_t non_isolated_cpus;
@@ -8094,104 +6806,11 @@ int in_sched_functions(unsigned long addr)
 		&& addr < (unsigned long)__sched_text_end);
 }
 
-static void init_cfs_rq(struct cfs_rq *cfs_rq)
-{
-	cfs_rq->tasks_timeline = RB_ROOT;
-	INIT_LIST_HEAD(&cfs_rq->tasks);
-	cfs_rq->min_vruntime = (u64)(-(1LL << 20));
-#ifndef CONFIG_64BIT
-	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
-#endif
-}
-
-static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
-{
-	struct rt_prio_array *array;
-	int i;
-
-	array = &rt_rq->active;
-	for (i = 0; i < MAX_RT_PRIO; i++) {
-		INIT_LIST_HEAD(array->queue + i);
-		__clear_bit(i, array->bitmap);
-	}
-	/* delimiter for bitsearch: */
-	__set_bit(MAX_RT_PRIO, array->bitmap);
-
-#if defined CONFIG_SMP
-	rt_rq->highest_prio.curr = MAX_RT_PRIO;
-	rt_rq->highest_prio.next = MAX_RT_PRIO;
-	rt_rq->rt_nr_migratory = 0;
-	rt_rq->overloaded = 0;
-	plist_head_init(&rt_rq->pushable_tasks);
-#endif
-
-	rt_rq->rt_time = 0;
-	rt_rq->rt_throttled = 0;
-	rt_rq->rt_runtime = 0;
-	raw_spin_lock_init(&rt_rq->rt_runtime_lock);
-}
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
-				struct sched_entity *se, int cpu,
-				struct sched_entity *parent)
-{
-	struct rq *rq = cpu_rq(cpu);
-
-	cfs_rq->tg = tg;
-	cfs_rq->rq = rq;
-#ifdef CONFIG_SMP
-	/* allow initial update_cfs_load() to truncate */
-	cfs_rq->load_stamp = 1;
-#endif
-	init_cfs_rq_runtime(cfs_rq);
-
-	tg->cfs_rq[cpu] = cfs_rq;
-	tg->se[cpu] = se;
-
-	/* se could be NULL for root_task_group */
-	if (!se)
-		return;
-
-	if (!parent)
-		se->cfs_rq = &rq->cfs;
-	else
-		se->cfs_rq = parent->my_q;
-
-	se->my_q = cfs_rq;
-	update_load_set(&se->load, 0);
-	se->parent = parent;
-}
+#ifdef CONFIG_CGROUP_SCHED
+struct task_group root_task_group;
 #endif
 
-#ifdef CONFIG_RT_GROUP_SCHED
-static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
-		struct sched_rt_entity *rt_se, int cpu,
-		struct sched_rt_entity *parent)
-{
-	struct rq *rq = cpu_rq(cpu);
-
-	rt_rq->highest_prio.curr = MAX_RT_PRIO;
-	rt_rq->rt_nr_boosted = 0;
-	rt_rq->rq = rq;
-	rt_rq->tg = tg;
-
-	tg->rt_rq[cpu] = rt_rq;
-	tg->rt_se[cpu] = rt_se;
-
-	if (!rt_se)
-		return;
-
-	if (!parent)
-		rt_se->rt_rq = &rq->rt;
-	else
-		rt_se->rt_rq = parent->my_q;
-
-	rt_se->my_q = rt_rq;
-	rt_se->parent = parent;
-	INIT_LIST_HEAD(&rt_se->run_list);
-}
-#endif
+DECLARE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
 
 void __init sched_init(void)
 {
@@ -8249,9 +6868,17 @@ void __init sched_init(void)
 #ifdef CONFIG_CGROUP_SCHED
 	list_add(&root_task_group.list, &task_groups);
 	INIT_LIST_HEAD(&root_task_group.children);
+	INIT_LIST_HEAD(&root_task_group.siblings);
 	autogroup_init(&init_task);
+
 #endif /* CONFIG_CGROUP_SCHED */
 
+#ifdef CONFIG_CGROUP_CPUACCT
+	root_cpuacct.cpustat = &kernel_cpustat;
+	root_cpuacct.cpuusage = alloc_percpu(u64);
+	/* Too early, not expected to fail */
+	BUG_ON(!root_cpuacct.cpuusage);
+#endif
 	for_each_possible_cpu(i) {
 		struct rq *rq;
 
@@ -8263,7 +6890,7 @@ void __init sched_init(void)
 		init_cfs_rq(&rq->cfs);
 		init_rt_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
-		root_task_group.shares = root_task_group_load;
+		root_task_group.shares = ROOT_TASK_GROUP_LOAD;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
 		/*
 		 * How much cpu bandwidth does root_task_group get?
@@ -8313,7 +6940,7 @@ void __init sched_init(void)
 		rq->avg_idle = 2*sysctl_sched_migration_cost;
 		rq_attach_root(rq, &def_root_domain);
 #ifdef CONFIG_NO_HZ
-		rq->nohz_balance_kick = 0;
+		rq->nohz_flags = 0;
 #endif
 #endif
 		init_rq_hrtick(rq);
@@ -8326,10 +6953,6 @@ void __init sched_init(void)
 	INIT_HLIST_HEAD(&init_task.preempt_notifiers);
 #endif
 
-#ifdef CONFIG_SMP
-	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
-#endif
-
 #ifdef CONFIG_RT_MUTEXES
 	plist_head_init(&init_task.pi_waiters);
 #endif
@@ -8357,17 +6980,11 @@ void __init sched_init(void)
 
 #ifdef CONFIG_SMP
 	zalloc_cpumask_var(&sched_domains_tmpmask, GFP_NOWAIT);
-#ifdef CONFIG_NO_HZ
-	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
-	alloc_cpumask_var(&nohz.grp_idle_mask, GFP_NOWAIT);
-	atomic_set(&nohz.load_balancer, nr_cpu_ids);
-	atomic_set(&nohz.first_pick_cpu, nr_cpu_ids);
-	atomic_set(&nohz.second_pick_cpu, nr_cpu_ids);
-#endif
 	/* May be allocated at isolcpus cmdline parse time */
 	if (cpu_isolated_map == NULL)
 		zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
-#endif /* SMP */
+#endif
+	init_sched_fair_class();
 
 	scheduler_running = 1;
 }
@@ -8519,169 +7136,14 @@ void set_curr_task(int cpu, struct task_struct *p)
 
 #endif
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
-static void free_fair_sched_group(struct task_group *tg)
-{
-	int i;
-
-	destroy_cfs_bandwidth(tg_cfs_bandwidth(tg));
-
-	for_each_possible_cpu(i) {
-		if (tg->cfs_rq)
-			kfree(tg->cfs_rq[i]);
-		if (tg->se)
-			kfree(tg->se[i]);
-	}
-
-	kfree(tg->cfs_rq);
-	kfree(tg->se);
-}
-
-static
-int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
-{
-	struct cfs_rq *cfs_rq;
-	struct sched_entity *se;
-	int i;
-
-	tg->cfs_rq = kzalloc(sizeof(cfs_rq) * nr_cpu_ids, GFP_KERNEL);
-	if (!tg->cfs_rq)
-		goto err;
-	tg->se = kzalloc(sizeof(se) * nr_cpu_ids, GFP_KERNEL);
-	if (!tg->se)
-		goto err;
-
-	tg->shares = NICE_0_LOAD;
-
-	init_cfs_bandwidth(tg_cfs_bandwidth(tg));
-
-	for_each_possible_cpu(i) {
-		cfs_rq = kzalloc_node(sizeof(struct cfs_rq),
-				      GFP_KERNEL, cpu_to_node(i));
-		if (!cfs_rq)
-			goto err;
-
-		se = kzalloc_node(sizeof(struct sched_entity),
-				  GFP_KERNEL, cpu_to_node(i));
-		if (!se)
-			goto err_free_rq;
-
-		init_cfs_rq(cfs_rq);
-		init_tg_cfs_entry(tg, cfs_rq, se, i, parent->se[i]);
-	}
-
-	return 1;
-
-err_free_rq:
-	kfree(cfs_rq);
-err:
-	return 0;
-}
-
-static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long flags;
-
-	/*
-	* Only empty task groups can be destroyed; so we can speculatively
-	* check on_list without danger of it being re-added.
-	*/
-	if (!tg->cfs_rq[cpu]->on_list)
-		return;
-
-	raw_spin_lock_irqsave(&rq->lock, flags);
-	list_del_leaf_cfs_rq(tg->cfs_rq[cpu]);
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
-}
-#else /* !CONFIG_FAIR_GROUP_SCHED */
-static inline void free_fair_sched_group(struct task_group *tg)
-{
-}
-
-static inline
-int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
-{
-	return 1;
-}
-
-static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
-{
-}
-#endif /* CONFIG_FAIR_GROUP_SCHED */
-
 #ifdef CONFIG_RT_GROUP_SCHED
-static void free_rt_sched_group(struct task_group *tg)
-{
-	int i;
-
-	if (tg->rt_se)
-		destroy_rt_bandwidth(&tg->rt_bandwidth);
-
-	for_each_possible_cpu(i) {
-		if (tg->rt_rq)
-			kfree(tg->rt_rq[i]);
-		if (tg->rt_se)
-			kfree(tg->rt_se[i]);
-	}
-
-	kfree(tg->rt_rq);
-	kfree(tg->rt_se);
-}
-
-static
-int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
-{
-	struct rt_rq *rt_rq;
-	struct sched_rt_entity *rt_se;
-	int i;
-
-	tg->rt_rq = kzalloc(sizeof(rt_rq) * nr_cpu_ids, GFP_KERNEL);
-	if (!tg->rt_rq)
-		goto err;
-	tg->rt_se = kzalloc(sizeof(rt_se) * nr_cpu_ids, GFP_KERNEL);
-	if (!tg->rt_se)
-		goto err;
-
-	init_rt_bandwidth(&tg->rt_bandwidth,
-			ktime_to_ns(def_rt_bandwidth.rt_period), 0);
-
-	for_each_possible_cpu(i) {
-		rt_rq = kzalloc_node(sizeof(struct rt_rq),
-				     GFP_KERNEL, cpu_to_node(i));
-		if (!rt_rq)
-			goto err;
-
-		rt_se = kzalloc_node(sizeof(struct sched_rt_entity),
-				     GFP_KERNEL, cpu_to_node(i));
-		if (!rt_se)
-			goto err_free_rq;
-
-		init_rt_rq(rt_rq, cpu_rq(i));
-		rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
-		init_tg_rt_entry(tg, rt_rq, rt_se, i, parent->rt_se[i]);
-	}
-
-	return 1;
-
-err_free_rq:
-	kfree(rt_rq);
-err:
-	return 0;
-}
 #else /* !CONFIG_RT_GROUP_SCHED */
-static inline void free_rt_sched_group(struct task_group *tg)
-{
-}
-
-static inline
-int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
-{
-	return 1;
-}
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_CGROUP_SCHED
+/* task_group_lock serializes the addition/removal of task groups */
+static DEFINE_SPINLOCK(task_group_lock);
+
 static void free_sched_group(struct task_group *tg)
 {
 	free_fair_sched_group(tg);
@@ -8787,47 +7249,6 @@ void sched_move_task(struct task_struct *tsk)
 #endif /* CONFIG_CGROUP_SCHED */
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static DEFINE_MUTEX(shares_mutex);
-
-int sched_group_set_shares(struct task_group *tg, unsigned long shares)
-{
-	int i;
-	unsigned long flags;
-
-	/*
-	 * We can't change the weight of the root cgroup.
-	 */
-	if (!tg->se[0])
-		return -EINVAL;
-
-	shares = clamp(shares, scale_load(MIN_SHARES), scale_load(MAX_SHARES));
-
-	mutex_lock(&shares_mutex);
-	if (tg->shares == shares)
-		goto done;
-
-	tg->shares = shares;
-	for_each_possible_cpu(i) {
-		struct rq *rq = cpu_rq(i);
-		struct sched_entity *se;
-
-		se = tg->se[i];
-		/* Propagate contribution to hierarchy */
-		raw_spin_lock_irqsave(&rq->lock, flags);
-		for_each_sched_entity(se)
-			update_cfs_shares(group_cfs_rq(se));
-		raw_spin_unlock_irqrestore(&rq->lock, flags);
-	}
-
-done:
-	mutex_unlock(&shares_mutex);
-	return 0;
-}
-
-unsigned long sched_group_shares(struct task_group *tg)
-{
-	return tg->shares;
-}
 #endif
 
 #if defined(CONFIG_RT_GROUP_SCHED) || defined(CONFIG_CFS_BANDWIDTH)
@@ -8852,7 +7273,7 @@ static inline int tg_has_rt_tasks(struct task_group *tg)
 	struct task_struct *g, *p;
 
 	do_each_thread(g, p) {
-		if (rt_task(p) && rt_rq_of_se(&p->rt)->tg == tg)
+		if (rt_task(p) && task_rq(p)->rt.tg == tg)
 			return 1;
 	} while_each_thread(g, p);
 
@@ -9203,8 +7624,8 @@ static int __cfs_schedulable(struct task_group *tg, u64 period, u64 runtime);
 
 static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 {
-	int i, ret = 0, runtime_enabled;
-	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+	int i, ret = 0, runtime_enabled, runtime_was_enabled;
+	struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
 
 	if (tg == &root_task_group)
 		return -EINVAL;
@@ -9231,6 +7652,8 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 		goto out_unlock;
 
 	runtime_enabled = quota != RUNTIME_INF;
+	runtime_was_enabled = cfs_b->quota != RUNTIME_INF;
+	account_cfs_bandwidth_used(runtime_enabled, runtime_was_enabled);
 	raw_spin_lock_irq(&cfs_b->lock);
 	cfs_b->period = ns_to_ktime(period);
 	cfs_b->quota = quota;
@@ -9246,13 +7669,13 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 
 	for_each_possible_cpu(i) {
 		struct cfs_rq *cfs_rq = tg->cfs_rq[i];
-		struct rq *rq = rq_of(cfs_rq);
+		struct rq *rq = cfs_rq->rq;
 
 		raw_spin_lock_irq(&rq->lock);
 		cfs_rq->runtime_enabled = runtime_enabled;
 		cfs_rq->runtime_remaining = 0;
 
-		if (cfs_rq_throttled(cfs_rq))
+		if (cfs_rq->throttled)
 			unthrottle_cfs_rq(cfs_rq);
 		raw_spin_unlock_irq(&rq->lock);
 	}
@@ -9266,7 +7689,7 @@ int tg_set_cfs_quota(struct task_group *tg, long cfs_quota_us)
 {
 	u64 quota, period;
 
-	period = ktime_to_ns(tg_cfs_bandwidth(tg)->period);
+	period = ktime_to_ns(tg->cfs_bandwidth.period);
 	if (cfs_quota_us < 0)
 		quota = RUNTIME_INF;
 	else
@@ -9279,10 +7702,10 @@ long tg_get_cfs_quota(struct task_group *tg)
 {
 	u64 quota_us;
 
-	if (tg_cfs_bandwidth(tg)->quota == RUNTIME_INF)
+	if (tg->cfs_bandwidth.quota == RUNTIME_INF)
 		return -1;
 
-	quota_us = tg_cfs_bandwidth(tg)->quota;
+	quota_us = tg->cfs_bandwidth.quota;
 	do_div(quota_us, NSEC_PER_USEC);
 
 	return quota_us;
@@ -9293,10 +7716,7 @@ int tg_set_cfs_period(struct task_group *tg, long cfs_period_us)
 	u64 quota, period;
 
 	period = (u64)cfs_period_us * NSEC_PER_USEC;
-	quota = tg_cfs_bandwidth(tg)->quota;
-
-	if (period <= 0)
-		return -EINVAL;
+	quota = tg->cfs_bandwidth.quota;
 
 	return tg_set_cfs_bandwidth(tg, period, quota);
 }
@@ -9305,7 +7725,7 @@ long tg_get_cfs_period(struct task_group *tg)
 {
 	u64 cfs_period_us;
 
-	cfs_period_us = ktime_to_ns(tg_cfs_bandwidth(tg)->period);
+	cfs_period_us = ktime_to_ns(tg->cfs_bandwidth.period);
 	do_div(cfs_period_us, NSEC_PER_USEC);
 
 	return cfs_period_us;
@@ -9365,13 +7785,13 @@ static u64 normalize_cfs_quota(struct task_group *tg,
 static int tg_cfs_schedulable_down(struct task_group *tg, void *data)
 {
 	struct cfs_schedulable_data *d = data;
-	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+	struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
 	s64 quota = 0, parent_quota = -1;
 
 	if (!tg->parent) {
 		quota = RUNTIME_INF;
 	} else {
-		struct cfs_bandwidth *parent_b = tg_cfs_bandwidth(tg->parent);
+		struct cfs_bandwidth *parent_b = &tg->parent->cfs_bandwidth;
 
 		quota = normalize_cfs_quota(tg, d);
 		parent_quota = parent_b->hierarchal_quota;
@@ -9415,7 +7835,7 @@ static int cpu_stats_show(struct cgroup *cgrp, struct cftype *cft,
 		struct cgroup_map_cb *cb)
 {
 	struct task_group *tg = cgroup_tg(cgrp);
-	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
+	struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
 
 	cb->fill(cb, "nr_periods", cfs_b->nr_periods);
 	cb->fill(cb, "nr_throttled", cfs_b->nr_throttled);
@@ -9516,38 +7936,16 @@ struct cgroup_subsys cpu_cgroup_subsys = {
  * (balbir@in.ibm.com).
  */
 
-/* track cpu usage of a group of tasks and its child groups */
-struct cpuacct {
-	struct cgroup_subsys_state css;
-	/* cpuusage holds pointer to a u64-type object on every cpu */
-	u64 __percpu *cpuusage;
-	struct percpu_counter cpustat[CPUACCT_STAT_NSTATS];
-	struct cpuacct *parent;
-};
-
-struct cgroup_subsys cpuacct_subsys;
-
-/* return cpu accounting group corresponding to this container */
-static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
-{
-	return container_of(cgroup_subsys_state(cgrp, cpuacct_subsys_id),
-			    struct cpuacct, css);
-}
-
-/* return cpu accounting group to which this task belongs */
-static inline struct cpuacct *task_ca(struct task_struct *tsk)
-{
-	return container_of(task_subsys_state(tsk, cpuacct_subsys_id),
-			    struct cpuacct, css);
-}
-
 /* create a new cpu accounting group */
 static struct cgroup_subsys_state *cpuacct_create(
 	struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
-	struct cpuacct *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
-	int i;
+	struct cpuacct *ca;
 
+	if (!cgrp->parent)
+		return &root_cpuacct.css;
+
+	ca = kzalloc(sizeof(*ca), GFP_KERNEL);
 	if (!ca)
 		goto out;
 
@@ -9555,18 +7953,13 @@ static struct cgroup_subsys_state *cpuacct_create(
 	if (!ca->cpuusage)
 		goto out_free_ca;
 
-	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
-		if (percpu_counter_init(&ca->cpustat[i], 0))
-			goto out_free_counters;
-
-	if (cgrp->parent)
-		ca->parent = cgroup_ca(cgrp->parent);
+	ca->cpustat = alloc_percpu(struct kernel_cpustat);
+	if (!ca->cpustat)
+		goto out_free_cpuusage;
 
 	return &ca->css;
 
-out_free_counters:
-	while (--i >= 0)
-		percpu_counter_destroy(&ca->cpustat[i]);
+out_free_cpuusage:
 	free_percpu(ca->cpuusage);
 out_free_ca:
 	kfree(ca);
@@ -9579,10 +7972,8 @@ static void
 cpuacct_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
 	struct cpuacct *ca = cgroup_ca(cgrp);
-	int i;
 
-	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
-		percpu_counter_destroy(&ca->cpustat[i]);
+	free_percpu(ca->cpustat);
 	free_percpu(ca->cpuusage);
 	kfree(ca);
 }
@@ -9675,16 +8066,31 @@ static const char *cpuacct_stat_desc[] = {
 };
 
 static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
-		struct cgroup_map_cb *cb)
+			      struct cgroup_map_cb *cb)
 {
 	struct cpuacct *ca = cgroup_ca(cgrp);
-	int i;
+	int cpu;
+	s64 val = 0;
+
+	for_each_online_cpu(cpu) {
+		struct kernel_cpustat *kcpustat = per_cpu_ptr(ca->cpustat, cpu);
+		val += kcpustat->cpustat[CPUTIME_USER];
+		val += kcpustat->cpustat[CPUTIME_NICE];
+	}
+	val = cputime64_to_clock_t(val);
+	cb->fill(cb, cpuacct_stat_desc[CPUACCT_STAT_USER], val);
 
-	for (i = 0; i < CPUACCT_STAT_NSTATS; i++) {
-		s64 val = percpu_counter_read(&ca->cpustat[i]);
-		val = cputime64_to_clock_t(val);
-		cb->fill(cb, cpuacct_stat_desc[i], val);
+	val = 0;
+	for_each_online_cpu(cpu) {
+		struct kernel_cpustat *kcpustat = per_cpu_ptr(ca->cpustat, cpu);
+		val += kcpustat->cpustat[CPUTIME_SYSTEM];
+		val += kcpustat->cpustat[CPUTIME_IRQ];
+		val += kcpustat->cpustat[CPUTIME_SOFTIRQ];
 	}
+
+	val = cputime64_to_clock_t(val);
+	cb->fill(cb, cpuacct_stat_desc[CPUACCT_STAT_SYSTEM], val);
+
 	return 0;
 }
 
@@ -9714,7 +8120,7 @@ static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
  *
  * called with rq->lock held.
  */
-static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
+void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 {
 	struct cpuacct *ca;
 	int cpu;
@@ -9728,7 +8134,7 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 
 	ca = task_ca(tsk);
 
-	for (; ca; ca = ca->parent) {
+	for (; ca; ca = parent_ca(ca)) {
 		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
 		*cpuusage += cputime;
 	}
@@ -9736,45 +8142,6 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 	rcu_read_unlock();
 }
 
-/*
- * When CONFIG_VIRT_CPU_ACCOUNTING is enabled one jiffy can be very large
- * in cputime_t units. As a result, cpuacct_update_stats calls
- * percpu_counter_add with values large enough to always overflow the
- * per cpu batch limit causing bad SMP scalability.
- *
- * To fix this we scale percpu_counter_batch by cputime_one_jiffy so we
- * batch the same amount of time with CONFIG_VIRT_CPU_ACCOUNTING disabled
- * and enabled. We cap it at INT_MAX which is the largest allowed batch value.
- */
-#ifdef CONFIG_SMP
-#define CPUACCT_BATCH	\
-	min_t(long, percpu_counter_batch * cputime_one_jiffy, INT_MAX)
-#else
-#define CPUACCT_BATCH	0
-#endif
-
-/*
- * Charge the system/user time to the task's accounting group.
- */
-static void cpuacct_update_stats(struct task_struct *tsk,
-		enum cpuacct_stat_index idx, cputime_t val)
-{
-	struct cpuacct *ca;
-	int batch = CPUACCT_BATCH;
-
-	if (unlikely(!cpuacct_subsys.active))
-		return;
-
-	rcu_read_lock();
-	ca = task_ca(tsk);
-
-	do {
-		__percpu_counter_add(&ca->cpustat[idx], val, batch);
-		ca = ca->parent;
-	} while (ca);
-	rcu_read_unlock();
-}
-
 struct cgroup_subsys cpuacct_subsys = {
 	.name = "cpuacct",
 	.create = cpuacct_create,
diff --git a/kernel/sched_cpupri.c b/kernel/sched/cpupri.c
similarity index 99%
rename from kernel/sched_cpupri.c
rename to kernel/sched/cpupri.c
index a86cf9d..b0d798e 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched/cpupri.c
@@ -1,5 +1,5 @@
 /*
- *  kernel/sched_cpupri.c
+ *  kernel/sched/cpupri.c
  *
  *  CPU priority management
  *
@@ -28,7 +28,7 @@
  */
 
 #include <linux/gfp.h>
-#include "sched_cpupri.h"
+#include "cpupri.h"
 
 /* Convert between a 140 based task->prio, and our 102 based cpupri */
 static int convert_prio(int prio)
diff --git a/kernel/sched_cpupri.h b/kernel/sched/cpupri.h
similarity index 100%
rename from kernel/sched_cpupri.h
rename to kernel/sched/cpupri.h
diff --git a/kernel/sched_debug.c b/kernel/sched/debug.c
similarity index 99%
rename from kernel/sched_debug.c
rename to kernel/sched/debug.c
index a6710a1..2a075e1 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched/debug.c
@@ -1,5 +1,5 @@
 /*
- * kernel/time/sched_debug.c
+ * kernel/sched/debug.c
  *
  * Print the CFS rbtree
  *
@@ -16,6 +16,8 @@
 #include <linux/kallsyms.h>
 #include <linux/utsname.h>
 
+#include "sched.h"
+
 static DEFINE_SPINLOCK(sched_debug_lock);
 
 /*
@@ -373,7 +375,7 @@ static int sched_debug_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static void sysrq_sched_debug_show(void)
+void sysrq_sched_debug_show(void)
 {
 	sched_debug_show(NULL, NULL);
 }
diff --git a/kernel/sched_fair.c b/kernel/sched/fair.c
similarity index 87%
rename from kernel/sched_fair.c
rename to kernel/sched/fair.c
index a78ed27..8e42de9 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched/fair.c
@@ -23,6 +23,13 @@
 #include <linux/latencytop.h>
 #include <linux/sched.h>
 #include <linux/cpumask.h>
+#include <linux/slab.h>
+#include <linux/profile.h>
+#include <linux/interrupt.h>
+
+#include <trace/events/sched.h>
+
+#include "sched.h"
 
 /*
  * Targeted preemption latency for CPU-bound tasks:
@@ -103,7 +110,110 @@ unsigned int __read_mostly sysctl_sched_shares_window = 10000000UL;
 unsigned int sysctl_sched_cfs_bandwidth_slice = 5000UL;
 #endif
 
-static const struct sched_class fair_sched_class;
+/*
+ * Increase the granularity value when there are more CPUs,
+ * because with more CPUs the 'effective latency' as visible
+ * to users decreases. But the relationship is not linear,
+ * so pick a second-best guess by going with the log2 of the
+ * number of CPUs.
+ *
+ * This idea comes from the SD scheduler of Con Kolivas:
+ */
+static int get_update_sysctl_factor(void)
+{
+	unsigned int cpus = min_t(int, num_online_cpus(), 8);
+	unsigned int factor;
+
+	switch (sysctl_sched_tunable_scaling) {
+	case SCHED_TUNABLESCALING_NONE:
+		factor = 1;
+		break;
+	case SCHED_TUNABLESCALING_LINEAR:
+		factor = cpus;
+		break;
+	case SCHED_TUNABLESCALING_LOG:
+	default:
+		factor = 1 + ilog2(cpus);
+		break;
+	}
+
+	return factor;
+}
+
+static void update_sysctl(void)
+{
+	unsigned int factor = get_update_sysctl_factor();
+
+#define SET_SYSCTL(name) \
+	(sysctl_##name = (factor) * normalized_sysctl_##name)
+	SET_SYSCTL(sched_min_granularity);
+	SET_SYSCTL(sched_latency);
+	SET_SYSCTL(sched_wakeup_granularity);
+#undef SET_SYSCTL
+}
+
+void sched_init_granularity(void)
+{
+	update_sysctl();
+}
+
+#if BITS_PER_LONG == 32
+# define WMULT_CONST	(~0UL)
+#else
+# define WMULT_CONST	(1UL << 32)
+#endif
+
+#define WMULT_SHIFT	32
+
+/*
+ * Shift right and round:
+ */
+#define SRR(x, y) (((x) + (1UL << ((y) - 1))) >> (y))
+
+/*
+ * delta *= weight / lw
+ */
+static unsigned long
+calc_delta_mine(unsigned long delta_exec, unsigned long weight,
+		struct load_weight *lw)
+{
+	u64 tmp;
+
+	/*
+	 * weight can be less than 2^SCHED_LOAD_RESOLUTION for task group sched
+	 * entities since MIN_SHARES = 2. Treat weight as 1 if less than
+	 * 2^SCHED_LOAD_RESOLUTION.
+	 */
+	if (likely(weight > (1UL << SCHED_LOAD_RESOLUTION)))
+		tmp = (u64)delta_exec * scale_load_down(weight);
+	else
+		tmp = (u64)delta_exec;
+
+	if (!lw->inv_weight) {
+		unsigned long w = scale_load_down(lw->weight);
+
+		if (BITS_PER_LONG > 32 && unlikely(w >= WMULT_CONST))
+			lw->inv_weight = 1;
+		else if (unlikely(!w))
+			lw->inv_weight = WMULT_CONST;
+		else
+			lw->inv_weight = WMULT_CONST / w;
+	}
+
+	/*
+	 * Check whether we'd overflow the 64-bit multiplication:
+	 */
+	if (unlikely(tmp > WMULT_CONST))
+		tmp = SRR(SRR(tmp, WMULT_SHIFT/2) * lw->inv_weight,
+			WMULT_SHIFT/2);
+	else
+		tmp = SRR(tmp * lw->inv_weight, WMULT_SHIFT);
+
+	return (unsigned long)min(tmp, (u64)(unsigned long)LONG_MAX);
+}
+
+
+const struct sched_class fair_sched_class;
 
 /**************************************************************
  * CFS operations on generic schedulable entities:
@@ -413,7 +523,7 @@ static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
 }
 
-static struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq)
+struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *left = cfs_rq->rb_leftmost;
 
@@ -434,7 +544,7 @@ static struct sched_entity *__pick_next_entity(struct sched_entity *se)
 }
 
 #ifdef CONFIG_SCHED_DEBUG
-static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
+struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *last = rb_last(&cfs_rq->tasks_timeline);
 
@@ -684,7 +794,7 @@ account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	update_load_add(&cfs_rq->load, se->load.weight);
 	if (!parent_entity(se))
-		inc_cpu_load(rq_of(cfs_rq), se->load.weight);
+		update_load_add(&rq_of(cfs_rq)->load, se->load.weight);
 	if (entity_is_task(se)) {
 		add_cfs_task_weight(cfs_rq, se->load.weight);
 		list_add(&se->group_node, &cfs_rq->tasks);
@@ -697,7 +807,7 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	update_load_sub(&cfs_rq->load, se->load.weight);
 	if (!parent_entity(se))
-		dec_cpu_load(rq_of(cfs_rq), se->load.weight);
+		update_load_sub(&rq_of(cfs_rq)->load, se->load.weight);
 	if (entity_is_task(se)) {
 		add_cfs_task_weight(cfs_rq, -se->load.weight);
 		list_del_init(&se->group_node);
@@ -893,7 +1003,6 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		if (unlikely(delta > se->statistics.sleep_max))
 			se->statistics.sleep_max = delta;
 
-		se->statistics.sleep_start = 0;
 		se->statistics.sum_sleep_runtime += delta;
 
 		if (tsk) {
@@ -910,7 +1019,6 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		if (unlikely(delta > se->statistics.block_max))
 			se->statistics.block_max = delta;
 
-		se->statistics.block_start = 0;
 		se->statistics.sum_sleep_runtime += delta;
 
 		if (tsk) {
@@ -920,6 +1028,8 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 				trace_sched_stat_iowait(tsk, delta);
 			}
 
+			trace_sched_stat_blocked(tsk, delta);
+
 			/*
 			 * Blocking time is in units of nanosecs, so shift by
 			 * 20 to get a milliseconds-range estimation of the
@@ -1287,6 +1397,32 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
  */
 
 #ifdef CONFIG_CFS_BANDWIDTH
+
+#ifdef HAVE_JUMP_LABEL
+static struct jump_label_key __cfs_bandwidth_used;
+
+static inline bool cfs_bandwidth_used(void)
+{
+	return static_branch(&__cfs_bandwidth_used);
+}
+
+void account_cfs_bandwidth_used(int enabled, int was_enabled)
+{
+	/* only need to count groups transitioning between enabled/!enabled */
+	if (enabled && !was_enabled)
+		jump_label_inc(&__cfs_bandwidth_used);
+	else if (!enabled && was_enabled)
+		jump_label_dec(&__cfs_bandwidth_used);
+}
+#else /* HAVE_JUMP_LABEL */
+static bool cfs_bandwidth_used(void)
+{
+	return true;
+}
+
+void account_cfs_bandwidth_used(int enabled, int was_enabled) {}
+#endif /* HAVE_JUMP_LABEL */
+
 /*
  * default period for cfs group bandwidth.
  * default: 0.1s, units: nanoseconds
@@ -1308,7 +1444,7 @@ static inline u64 sched_cfs_bandwidth_slice(void)
  *
  * requires cfs_b->lock
  */
-static void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
+void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
 {
 	u64 now;
 
@@ -1320,6 +1456,11 @@ static void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
 	cfs_b->runtime_expires = now + ktime_to_ns(cfs_b->period);
 }
 
+static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
+{
+	return &tg->cfs_bandwidth;
+}
+
 /* returns 0 on failure to allocate runtime */
 static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
@@ -1421,7 +1562,7 @@ static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 						   unsigned long delta_exec)
 {
-	if (!cfs_rq->runtime_enabled)
+	if (!cfs_bandwidth_used() || !cfs_rq->runtime_enabled)
 		return;
 
 	__account_cfs_rq_runtime(cfs_rq, delta_exec);
@@ -1429,13 +1570,13 @@ static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 
 static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 {
-	return cfs_rq->throttled;
+	return cfs_bandwidth_used() && cfs_rq->throttled;
 }
 
 /* check whether cfs_rq, or any parent, is throttled */
 static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
 {
-	return cfs_rq->throttle_count;
+	return cfs_bandwidth_used() && cfs_rq->throttle_count;
 }
 
 /*
@@ -1530,7 +1671,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	raw_spin_unlock(&cfs_b->lock);
 }
 
-static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
+void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	struct rq *rq = rq_of(cfs_rq);
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
@@ -1756,6 +1897,9 @@ static void __return_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 
 static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
+	if (!cfs_bandwidth_used())
+		return;
+
 	if (!cfs_rq->runtime_enabled || cfs_rq->nr_running)
 		return;
 
@@ -1801,6 +1945,9 @@ static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b)
  */
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq)
 {
+	if (!cfs_bandwidth_used())
+		return;
+
 	/* an active group must be handled by the update_curr()->put() path */
 	if (!cfs_rq->runtime_enabled || cfs_rq->curr)
 		return;
@@ -1818,6 +1965,9 @@ static void check_enqueue_throttle(struct cfs_rq *cfs_rq)
 /* conditionally throttle active cfs_rq's from put_prev_entity() */
 static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
+	if (!cfs_bandwidth_used())
+		return;
+
 	if (likely(!cfs_rq->runtime_enabled || cfs_rq->runtime_remaining > 0))
 		return;
 
@@ -1830,7 +1980,112 @@ static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 
 	throttle_cfs_rq(cfs_rq);
 }
-#else
+
+static inline u64 default_cfs_period(void);
+static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun);
+static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b);
+
+static enum hrtimer_restart sched_cfs_slack_timer(struct hrtimer *timer)
+{
+	struct cfs_bandwidth *cfs_b =
+		container_of(timer, struct cfs_bandwidth, slack_timer);
+	do_sched_cfs_slack_timer(cfs_b);
+
+	return HRTIMER_NORESTART;
+}
+
+static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
+{
+	struct cfs_bandwidth *cfs_b =
+		container_of(timer, struct cfs_bandwidth, period_timer);
+	ktime_t now;
+	int overrun;
+	int idle = 0;
+
+	for (;;) {
+		now = hrtimer_cb_get_time(timer);
+		overrun = hrtimer_forward(timer, now, cfs_b->period);
+
+		if (!overrun)
+			break;
+
+		idle = do_sched_cfs_period_timer(cfs_b, overrun);
+	}
+
+	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
+}
+
+void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+	raw_spin_lock_init(&cfs_b->lock);
+	cfs_b->runtime = 0;
+	cfs_b->quota = RUNTIME_INF;
+	cfs_b->period = ns_to_ktime(default_cfs_period());
+
+	INIT_LIST_HEAD(&cfs_b->throttled_cfs_rq);
+	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	cfs_b->period_timer.function = sched_cfs_period_timer;
+	hrtimer_init(&cfs_b->slack_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	cfs_b->slack_timer.function = sched_cfs_slack_timer;
+}
+
+static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+{
+	cfs_rq->runtime_enabled = 0;
+	INIT_LIST_HEAD(&cfs_rq->throttled_list);
+}
+
+/* requires cfs_b->lock, may release to reprogram timer */
+void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+	/*
+	 * The timer may be active because we're trying to set a new bandwidth
+	 * period or because we're racing with the tear-down path
+	 * (timer_active==0 becomes visible before the hrtimer call-back
+	 * terminates).  In either case we ensure that it's re-programmed
+	 */
+	while (unlikely(hrtimer_active(&cfs_b->period_timer))) {
+		raw_spin_unlock(&cfs_b->lock);
+		/* ensure cfs_b->lock is available while we wait */
+		hrtimer_cancel(&cfs_b->period_timer);
+
+		raw_spin_lock(&cfs_b->lock);
+		/* if someone else restarted the timer then we're done */
+		if (cfs_b->timer_active)
+			return;
+	}
+
+	cfs_b->timer_active = 1;
+	start_bandwidth_timer(&cfs_b->period_timer, cfs_b->period);
+}
+
+static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+	hrtimer_cancel(&cfs_b->period_timer);
+	hrtimer_cancel(&cfs_b->slack_timer);
+}
+
+void unthrottle_offline_cfs_rqs(struct rq *rq)
+{
+	struct cfs_rq *cfs_rq;
+
+	for_each_leaf_cfs_rq(rq, cfs_rq) {
+		struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
+
+		if (!cfs_rq->runtime_enabled)
+			continue;
+
+		/*
+		 * clock_task is not advancing so we just need to make sure
+		 * there's some valid quota amount
+		 */
+		cfs_rq->runtime_remaining = cfs_b->quota;
+		if (cfs_rq_throttled(cfs_rq))
+			unthrottle_cfs_rq(cfs_rq);
+	}
+}
+
+#else /* CONFIG_CFS_BANDWIDTH */
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 				     unsigned long delta_exec) {}
 static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
@@ -1852,8 +2107,22 @@ static inline int throttled_lb_pair(struct task_group *tg,
 {
 	return 0;
 }
+
+void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 #endif
 
+static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
+{
+	return NULL;
+}
+static inline void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
+void unthrottle_offline_cfs_rqs(struct rq *rq) {}
+
+#endif /* CONFIG_CFS_BANDWIDTH */
+
 /**************************************************
  * CFS operations on tasks:
  */
@@ -1866,7 +2135,7 @@ static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 
 	WARN_ON(task_rq(p) != rq);
 
-	if (hrtick_enabled(rq) && cfs_rq->nr_running > 1) {
+	if (cfs_rq->nr_running > 1) {
 		u64 slice = sched_slice(cfs_rq, se);
 		u64 ran = se->sum_exec_runtime - se->prev_sum_exec_runtime;
 		s64 delta = slice - ran;
@@ -1897,7 +2166,7 @@ static void hrtick_update(struct rq *rq)
 {
 	struct task_struct *curr = rq->curr;
 
-	if (curr->sched_class != &fair_sched_class)
+	if (!hrtick_enabled(rq) || curr->sched_class != &fair_sched_class)
 		return;
 
 	if (cfs_rq_of(&curr->se)->nr_running < sched_nr_latency)
@@ -2020,6 +2289,61 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 }
 
 #ifdef CONFIG_SMP
+/* Used instead of source_load when we know the type == 0 */
+static unsigned long weighted_cpuload(const int cpu)
+{
+	return cpu_rq(cpu)->load.weight;
+}
+
+/*
+ * Return a low guess at the load of a migration-source cpu weighted
+ * according to the scheduling class and "nice" value.
+ *
+ * We want to under-estimate the load of migration sources, to
+ * balance conservatively.
+ */
+static unsigned long source_load(int cpu, int type)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long total = weighted_cpuload(cpu);
+
+	if (type == 0 || !sched_feat(LB_BIAS))
+		return total;
+
+	return min(rq->cpu_load[type-1], total);
+}
+
+/*
+ * Return a high guess at the load of a migration-target cpu weighted
+ * according to the scheduling class and "nice" value.
+ */
+static unsigned long target_load(int cpu, int type)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long total = weighted_cpuload(cpu);
+
+	if (type == 0 || !sched_feat(LB_BIAS))
+		return total;
+
+	return max(rq->cpu_load[type-1], total);
+}
+
+static unsigned long power_of(int cpu)
+{
+	return cpu_rq(cpu)->cpu_power;
+}
+
+static unsigned long cpu_avg_load_per_task(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
+
+	if (nr_running)
+		return rq->load.weight / nr_running;
+
+	return 0;
+}
+
 
 static void task_waking_fair(struct task_struct *p)
 {
@@ -2327,7 +2651,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	int prev_cpu = task_cpu(p);
 	struct sched_domain *sd;
 	struct sched_group *sg;
-	int i, smt = 0;
+	int i;
 
 	/*
 	 * If the task is going to be woken-up on this cpu and if it is
@@ -2347,19 +2671,9 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
 	 */
 	rcu_read_lock();
-again:
-	for_each_domain(target, sd) {
-		if (!smt && (sd->flags & SD_SHARE_CPUPOWER))
-			continue;
-
-		if (!(sd->flags & SD_SHARE_PKG_RESOURCES)) {
-			if (!smt) {
-				smt = 1;
-				goto again;
-			}
-			break;
-		}
 
+	sd = rcu_dereference(per_cpu(sd_llc, target));
+	for_each_lower_domain(sd) {
 		sg = sd->groups;
 		do {
 			if (!cpumask_intersects(sched_group_cpus(sg),
@@ -2406,6 +2720,9 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	int want_sd = 1;
 	int sync = wake_flags & WF_SYNC;
 
+	if (p->rt.nr_cpus_allowed == 1)
+		return prev_cpu;
+
 	if (sd_flag & SD_BALANCE_WAKE) {
 		if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
 			want_affine = 1;
@@ -2690,7 +3007,8 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
 	} while (cfs_rq);
 
 	p = task_of(se);
-	hrtick_start_fair(rq, p);
+	if (hrtick_enabled(rq))
+		hrtick_start_fair(rq, p);
 
 	return p;
 }
@@ -2734,6 +3052,12 @@ static void yield_task_fair(struct rq *rq)
 		 * Update run-time statistics of the 'current'.
 		 */
 		update_curr(cfs_rq);
+		/*
+		 * Tell update_rq_clock() that we've just updated,
+		 * so we don't do microscopic update in schedule()
+		 * and double the fastpath cost.
+		 */
+		 rq->skip_clock_update = 1;
 	}
 
 	set_skip_buddy(se);
@@ -2774,12 +3098,48 @@ static void pull_task(struct rq *src_rq, struct task_struct *p,
 }
 
 /*
+ * Is this task likely cache-hot:
+ */
+static int
+task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
+{
+	s64 delta;
+
+	if (p->sched_class != &fair_sched_class)
+		return 0;
+
+	if (unlikely(p->policy == SCHED_IDLE))
+		return 0;
+
+	/*
+	 * Buddy candidates are cache hot:
+	 */
+	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
+			(&p->se == cfs_rq_of(&p->se)->next ||
+			 &p->se == cfs_rq_of(&p->se)->last))
+		return 1;
+
+	if (sysctl_sched_migration_cost == -1)
+		return 1;
+	if (sysctl_sched_migration_cost == 0)
+		return 0;
+
+	delta = now - p->se.exec_start;
+
+	return delta < (s64)sysctl_sched_migration_cost;
+}
+
+#define LBF_ALL_PINNED	0x01
+#define LBF_NEED_BREAK	0x02
+#define LBF_ABORT	0x04
+
+/*
  * can_migrate_task - may task p from runqueue rq be migrated to this_cpu?
  */
 static
 int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 		     struct sched_domain *sd, enum cpu_idle_type idle,
-		     int *all_pinned)
+		     int *lb_flags)
 {
 	int tsk_cache_hot = 0;
 	/*
@@ -2792,7 +3152,7 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 		schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
 		return 0;
 	}
-	*all_pinned = 0;
+	*lb_flags &= ~LBF_ALL_PINNED;
 
 	if (task_running(rq, p)) {
 		schedstat_inc(p, se.statistics.nr_failed_migrations_running);
@@ -2866,7 +3226,7 @@ move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 static unsigned long
 balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	      unsigned long max_load_move, struct sched_domain *sd,
-	      enum cpu_idle_type idle, int *all_pinned,
+	      enum cpu_idle_type idle, int *lb_flags,
 	      struct cfs_rq *busiest_cfs_rq)
 {
 	int loops = 0, pulled = 0;
@@ -2877,12 +3237,14 @@ balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		goto out;
 
 	list_for_each_entry_safe(p, n, &busiest_cfs_rq->tasks, se.group_node) {
-		if (loops++ > sysctl_sched_nr_migrate)
+		if (loops++ > sysctl_sched_nr_migrate) {
+			*lb_flags |= LBF_NEED_BREAK;
 			break;
+		}
 
 		if ((p->se.load.weight >> 1) > rem_load_move ||
 		    !can_migrate_task(p, busiest, this_cpu, sd, idle,
-				      all_pinned))
+				      lb_flags))
 			continue;
 
 		pull_task(busiest, p, this_rq, this_cpu);
@@ -2895,8 +3257,10 @@ balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		 * kernels will stop after the first task is pulled to minimize
 		 * the critical section.
 		 */
-		if (idle == CPU_NEWLY_IDLE)
+		if (idle == CPU_NEWLY_IDLE) {
+			*lb_flags |= LBF_ABORT;
 			break;
+		}
 #endif
 
 		/*
@@ -3001,7 +3365,7 @@ static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned)
+		  int *lb_flags)
 {
 	long rem_load_move = max_load_move;
 	struct cfs_rq *busiest_cfs_rq;
@@ -3014,6 +3378,9 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		unsigned long busiest_weight = busiest_cfs_rq->load.weight;
 		u64 rem_load, moved_load;
 
+		if (*lb_flags & (LBF_NEED_BREAK|LBF_ABORT))
+			break;
+
 		/*
 		 * empty group or part of a throttled hierarchy
 		 */
@@ -3025,7 +3392,7 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		rem_load = div_u64(rem_load, busiest_h_load + 1);
 
 		moved_load = balance_tasks(this_rq, this_cpu, busiest,
-				rem_load, sd, idle, all_pinned,
+				rem_load, sd, idle, lb_flags,
 				busiest_cfs_rq);
 
 		if (!moved_load)
@@ -3051,10 +3418,10 @@ static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned)
+		  int *lb_flags)
 {
 	return balance_tasks(this_rq, this_cpu, busiest,
-			max_load_move, sd, idle, all_pinned,
+			max_load_move, sd, idle, lb_flags,
 			&busiest->cfs);
 }
 #endif
@@ -3069,29 +3436,30 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		      unsigned long max_load_move,
 		      struct sched_domain *sd, enum cpu_idle_type idle,
-		      int *all_pinned)
+		      int *lb_flags)
 {
 	unsigned long total_load_moved = 0, load_moved;
 
 	do {
 		load_moved = load_balance_fair(this_rq, this_cpu, busiest,
 				max_load_move - total_load_moved,
-				sd, idle, all_pinned);
+				sd, idle, lb_flags);
 
 		total_load_moved += load_moved;
 
+		if (*lb_flags & (LBF_NEED_BREAK|LBF_ABORT))
+			break;
+
 #ifdef CONFIG_PREEMPT
 		/*
 		 * NEWIDLE balancing is a source of latency, so preemptible
 		 * kernels will stop after the first task is pulled to minimize
 		 * the critical section.
 		 */
-		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running)
-			break;
-
-		if (raw_spin_is_contended(&this_rq->lock) ||
-				raw_spin_is_contended(&busiest->lock))
+		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running) {
+			*lb_flags |= LBF_ABORT;
 			break;
+		}
 #endif
 	} while (load_moved && max_load_move > total_load_moved);
 
@@ -3153,15 +3521,6 @@ struct sg_lb_stats {
 };
 
 /**
- * group_first_cpu - Returns the first cpu in the cpumask of a sched_group.
- * @group: The group whose first cpu is to be returned.
- */
-static inline unsigned int group_first_cpu(struct sched_group *group)
-{
-	return cpumask_first(sched_group_cpus(group));
-}
-
-/**
  * get_sd_load_idx - Obtain the load index for a given sched domain.
  * @sd: The sched_domain whose load_idx is to be obtained.
  * @idle: The Idle status of the CPU for whose sd load_icx is obtained.
@@ -3410,7 +3769,7 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 	sdg->sgp->power = power;
 }
 
-static void update_group_power(struct sched_domain *sd, int cpu)
+void update_group_power(struct sched_domain *sd, int cpu)
 {
 	struct sched_domain *child = sd->child;
 	struct sched_group *group, *sdg = sd->groups;
@@ -3676,11 +4035,6 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 	} while (sg != sd->groups);
 }
 
-int __weak arch_sd_sibling_asym_packing(void)
-{
-       return 0*SD_ASYM_PACKING;
-}
-
 /**
  * check_asym_packing - Check to see if the group is packed into the
  *			sched doman.
@@ -4044,7 +4398,7 @@ find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
 #define MAX_PINNED_INTERVAL	512
 
 /* Working cpumask for load_balance and load_balance_newidle. */
-static DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
+DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
 
 static int need_active_balance(struct sched_domain *sd, int idle,
 			       int busiest_cpu, int this_cpu)
@@ -4095,7 +4449,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 			struct sched_domain *sd, enum cpu_idle_type idle,
 			int *balance)
 {
-	int ld_moved, all_pinned = 0, active_balance = 0;
+	int ld_moved, lb_flags = 0, active_balance = 0;
 	struct sched_group *group;
 	unsigned long imbalance;
 	struct rq *busiest;
@@ -4136,11 +4490,11 @@ redo:
 		 * still unbalanced. ld_moved simply stays zero, so it is
 		 * correctly treated as an imbalance.
 		 */
-		all_pinned = 1;
+		lb_flags |= LBF_ALL_PINNED;
 		local_irq_save(flags);
 		double_rq_lock(this_rq, busiest);
 		ld_moved = move_tasks(this_rq, this_cpu, busiest,
-				      imbalance, sd, idle, &all_pinned);
+				      imbalance, sd, idle, &lb_flags);
 		double_rq_unlock(this_rq, busiest);
 		local_irq_restore(flags);
 
@@ -4150,8 +4504,16 @@ redo:
 		if (ld_moved && this_cpu != smp_processor_id())
 			resched_cpu(this_cpu);
 
+		if (lb_flags & LBF_ABORT)
+			goto out_balanced;
+
+		if (lb_flags & LBF_NEED_BREAK) {
+			lb_flags &= ~LBF_NEED_BREAK;
+			goto redo;
+		}
+
 		/* All tasks on this runqueue were pinned by CPU affinity */
-		if (unlikely(all_pinned)) {
+		if (unlikely(lb_flags & LBF_ALL_PINNED)) {
 			cpumask_clear_cpu(cpu_of(busiest), cpus);
 			if (!cpumask_empty(cpus))
 				goto redo;
@@ -4181,7 +4543,7 @@ redo:
 					tsk_cpus_allowed(busiest->curr))) {
 				raw_spin_unlock_irqrestore(&busiest->lock,
 							    flags);
-				all_pinned = 1;
+				lb_flags |= LBF_ALL_PINNED;
 				goto out_one_pinned;
 			}
 
@@ -4234,7 +4596,8 @@ out_balanced:
 
 out_one_pinned:
 	/* tune up the balancing interval */
-	if ((all_pinned && sd->balance_interval < MAX_PINNED_INTERVAL) ||
+	if (((lb_flags & LBF_ALL_PINNED) &&
+			sd->balance_interval < MAX_PINNED_INTERVAL) ||
 			(sd->balance_interval < sd->max_interval))
 		sd->balance_interval *= 2;
 
@@ -4247,7 +4610,7 @@ out:
  * idle_balance is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
  */
-static void idle_balance(int this_cpu, struct rq *this_rq)
+void idle_balance(int this_cpu, struct rq *this_rq)
 {
 	struct sched_domain *sd;
 	int pulled_task = 0;
@@ -4362,28 +4725,16 @@ out_unlock:
 #ifdef CONFIG_NO_HZ
 /*
  * idle load balancing details
- * - One of the idle CPUs nominates itself as idle load_balancer, while
- *   entering idle.
- * - This idle load balancer CPU will also go into tickless mode when
- *   it is idle, just like all other idle CPUs
  * - When one of the busy CPUs notice that there may be an idle rebalancing
  *   needed, they will kick the idle load balancer, which then does idle
  *   load balancing for all the idle CPUs.
  */
 static struct {
-	atomic_t load_balancer;
-	atomic_t first_pick_cpu;
-	atomic_t second_pick_cpu;
 	cpumask_var_t idle_cpus_mask;
-	cpumask_var_t grp_idle_mask;
+	atomic_t nr_cpus;
 	unsigned long next_balance;     /* in jiffy units */
 } nohz ____cacheline_aligned;
 
-int get_nohz_load_balancer(void)
-{
-	return atomic_read(&nohz.load_balancer);
-}
-
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 /**
  * lowest_flag_domain - Return lowest sched_domain containing flag.
@@ -4420,33 +4771,6 @@ static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
 		(sd && (sd->flags & flag)); sd = sd->parent)
 
 /**
- * is_semi_idle_group - Checks if the given sched_group is semi-idle.
- * @ilb_group:	group to be checked for semi-idleness
- *
- * Returns:	1 if the group is semi-idle. 0 otherwise.
- *
- * We define a sched_group to be semi idle if it has atleast one idle-CPU
- * and atleast one non-idle CPU. This helper function checks if the given
- * sched_group is semi-idle or not.
- */
-static inline int is_semi_idle_group(struct sched_group *ilb_group)
-{
-	cpumask_and(nohz.grp_idle_mask, nohz.idle_cpus_mask,
-					sched_group_cpus(ilb_group));
-
-	/*
-	 * A sched_group is semi-idle when it has atleast one busy cpu
-	 * and atleast one idle cpu.
-	 */
-	if (cpumask_empty(nohz.grp_idle_mask))
-		return 0;
-
-	if (cpumask_equal(nohz.grp_idle_mask, sched_group_cpus(ilb_group)))
-		return 0;
-
-	return 1;
-}
-/**
  * find_new_ilb - Finds the optimum idle load balancer for nomination.
  * @cpu:	The cpu which is nominating a new idle_load_balancer.
  *
@@ -4460,9 +4784,9 @@ static inline int is_semi_idle_group(struct sched_group *ilb_group)
  */
 static int find_new_ilb(int cpu)
 {
+	int ilb = cpumask_first(nohz.idle_cpus_mask);
+	struct sched_group *ilbg;
 	struct sched_domain *sd;
-	struct sched_group *ilb_group;
-	int ilb = nr_cpu_ids;
 
 	/*
 	 * Have idle load balancer selection from semi-idle packages only
@@ -4480,23 +4804,28 @@ static int find_new_ilb(int cpu)
 
 	rcu_read_lock();
 	for_each_flag_domain(cpu, sd, SD_POWERSAVINGS_BALANCE) {
-		ilb_group = sd->groups;
+		ilbg = sd->groups;
 
 		do {
-			if (is_semi_idle_group(ilb_group)) {
-				ilb = cpumask_first(nohz.grp_idle_mask);
+			if (ilbg->group_weight !=
+				atomic_read(&ilbg->sgp->nr_busy_cpus)) {
+				ilb = cpumask_first_and(nohz.idle_cpus_mask,
+							sched_group_cpus(ilbg));
 				goto unlock;
 			}
 
-			ilb_group = ilb_group->next;
+			ilbg = ilbg->next;
 
-		} while (ilb_group != sd->groups);
+		} while (ilbg != sd->groups);
 	}
 unlock:
 	rcu_read_unlock();
 
 out_done:
-	return ilb;
+	if (ilb < nr_cpu_ids && idle_cpu(ilb))
+		return ilb;
+
+	return nr_cpu_ids;
 }
 #else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
 static inline int find_new_ilb(int call_cpu)
@@ -4516,99 +4845,68 @@ static void nohz_balancer_kick(int cpu)
 
 	nohz.next_balance++;
 
-	ilb_cpu = get_nohz_load_balancer();
-
-	if (ilb_cpu >= nr_cpu_ids) {
-		ilb_cpu = cpumask_first(nohz.idle_cpus_mask);
-		if (ilb_cpu >= nr_cpu_ids)
-			return;
-	}
+	ilb_cpu = find_new_ilb(cpu);
 
-	if (!cpu_rq(ilb_cpu)->nohz_balance_kick) {
-		cpu_rq(ilb_cpu)->nohz_balance_kick = 1;
+	if (ilb_cpu >= nr_cpu_ids)
+		return;
 
-		smp_mb();
-		/*
-		 * Use smp_send_reschedule() instead of resched_cpu().
-		 * This way we generate a sched IPI on the target cpu which
-		 * is idle. And the softirq performing nohz idle load balance
-		 * will be run before returning from the IPI.
-		 */
-		smp_send_reschedule(ilb_cpu);
-	}
+	if (test_and_set_bit(NOHZ_BALANCE_KICK, nohz_flags(ilb_cpu)))
+		return;
+	/*
+	 * Use smp_send_reschedule() instead of resched_cpu().
+	 * This way we generate a sched IPI on the target cpu which
+	 * is idle. And the softirq performing nohz idle load balance
+	 * will be run before returning from the IPI.
+	 */
+	smp_send_reschedule(ilb_cpu);
 	return;
 }
 
-/*
- * This routine will try to nominate the ilb (idle load balancing)
- * owner among the cpus whose ticks are stopped. ilb owner will do the idle
- * load balancing on behalf of all those cpus.
- *
- * When the ilb owner becomes busy, we will not have new ilb owner until some
- * idle CPU wakes up and goes back to idle or some busy CPU tries to kick
- * idle load balancing by kicking one of the idle CPUs.
- *
- * Ticks are stopped for the ilb owner as well, with busy CPU kicking this
- * ilb owner CPU in future (when there is a need for idle load balancing on
- * behalf of all idle CPUs).
- */
-void select_nohz_load_balancer(int stop_tick)
+static inline void set_cpu_sd_state_busy(void)
 {
+	struct sched_domain *sd;
 	int cpu = smp_processor_id();
 
-	if (stop_tick) {
-		if (!cpu_active(cpu)) {
-			if (atomic_read(&nohz.load_balancer) != cpu)
-				return;
-
-			/*
-			 * If we are going offline and still the leader,
-			 * give up!
-			 */
-			if (atomic_cmpxchg(&nohz.load_balancer, cpu,
-					   nr_cpu_ids) != cpu)
-				BUG();
+	if (!test_bit(NOHZ_IDLE, nohz_flags(cpu)))
+		return;
+	clear_bit(NOHZ_IDLE, nohz_flags(cpu));
 
-			return;
-		}
+	rcu_read_lock();
+	for_each_domain(cpu, sd)
+		atomic_inc(&sd->groups->sgp->nr_busy_cpus);
+	rcu_read_unlock();
+}
 
-		cpumask_set_cpu(cpu, nohz.idle_cpus_mask);
+void set_cpu_sd_state_idle(void)
+{
+	struct sched_domain *sd;
+	int cpu = smp_processor_id();
 
-		if (atomic_read(&nohz.first_pick_cpu) == cpu)
-			atomic_cmpxchg(&nohz.first_pick_cpu, cpu, nr_cpu_ids);
-		if (atomic_read(&nohz.second_pick_cpu) == cpu)
-			atomic_cmpxchg(&nohz.second_pick_cpu, cpu, nr_cpu_ids);
+	if (test_bit(NOHZ_IDLE, nohz_flags(cpu)))
+		return;
+	set_bit(NOHZ_IDLE, nohz_flags(cpu));
 
-		if (atomic_read(&nohz.load_balancer) >= nr_cpu_ids) {
-			int new_ilb;
+	rcu_read_lock();
+	for_each_domain(cpu, sd)
+		atomic_dec(&sd->groups->sgp->nr_busy_cpus);
+	rcu_read_unlock();
+}
 
-			/* make me the ilb owner */
-			if (atomic_cmpxchg(&nohz.load_balancer, nr_cpu_ids,
-					   cpu) != nr_cpu_ids)
-				return;
+/*
+ * This routine will record that this cpu is going idle with tick stopped.
+ * This info will be used in performing idle load balancing in the future.
+ */
+void select_nohz_load_balancer(int stop_tick)
+{
+	int cpu = smp_processor_id();
 
-			/*
-			 * Check to see if there is a more power-efficient
-			 * ilb.
-			 */
-			new_ilb = find_new_ilb(cpu);
-			if (new_ilb < nr_cpu_ids && new_ilb != cpu) {
-				atomic_set(&nohz.load_balancer, nr_cpu_ids);
-				resched_cpu(new_ilb);
-				return;
-			}
-			return;
-		}
-	} else {
-		if (!cpumask_test_cpu(cpu, nohz.idle_cpus_mask))
+	if (stop_tick) {
+		if (test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))
 			return;
 
-		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
-
-		if (atomic_read(&nohz.load_balancer) == cpu)
-			if (atomic_cmpxchg(&nohz.load_balancer, cpu,
-					   nr_cpu_ids) != cpu)
-				BUG();
+		cpumask_set_cpu(cpu, nohz.idle_cpus_mask);
+		atomic_inc(&nohz.nr_cpus);
+		set_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
 	}
 	return;
 }
@@ -4622,7 +4920,7 @@ static unsigned long __read_mostly max_load_balance_interval = HZ/10;
  * Scale the max load_balance interval with the number of CPUs in the system.
  * This trades load-balance latency on larger machines for less cross talk.
  */
-static void update_max_interval(void)
+void update_max_interval(void)
 {
 	max_load_balance_interval = HZ*num_online_cpus()/10;
 }
@@ -4714,11 +5012,12 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 	struct rq *rq;
 	int balance_cpu;
 
-	if (idle != CPU_IDLE || !this_rq->nohz_balance_kick)
-		return;
+	if (idle != CPU_IDLE ||
+	    !test_bit(NOHZ_BALANCE_KICK, nohz_flags(this_cpu)))
+		goto end;
 
 	for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {
-		if (balance_cpu == this_cpu)
+		if (balance_cpu == this_cpu || !idle_cpu(balance_cpu))
 			continue;
 
 		/*
@@ -4726,10 +5025,8 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 		 * work being done for other cpus. Next load
 		 * balancing owner will pick it up.
 		 */
-		if (need_resched()) {
-			this_rq->nohz_balance_kick = 0;
+		if (need_resched())
 			break;
-		}
 
 		raw_spin_lock_irq(&this_rq->lock);
 		update_rq_clock(this_rq);
@@ -4743,53 +5040,75 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 			this_rq->next_balance = rq->next_balance;
 	}
 	nohz.next_balance = this_rq->next_balance;
-	this_rq->nohz_balance_kick = 0;
+end:
+	clear_bit(NOHZ_BALANCE_KICK, nohz_flags(this_cpu));
 }
 
 /*
- * Current heuristic for kicking the idle load balancer
- * - first_pick_cpu is the one of the busy CPUs. It will kick
- *   idle load balancer when it has more than one process active. This
- *   eliminates the need for idle load balancing altogether when we have
- *   only one running process in the system (common case).
- * - If there are more than one busy CPU, idle load balancer may have
- *   to run for active_load_balance to happen (i.e., two busy CPUs are
- *   SMT or core siblings and can run better if they move to different
- *   physical CPUs). So, second_pick_cpu is the second of the busy CPUs
- *   which will kick idle load balancer as soon as it has any load.
+ * Current heuristic for kicking the idle load balancer in the presence
+ * of an idle cpu is the system.
+ *   - This rq has more than one task.
+ *   - At any scheduler domain level, this cpu's scheduler group has multiple
+ *     busy cpu's exceeding the group's power.
+ *   - For SD_ASYM_PACKING, if the lower numbered cpu's in the scheduler
+ *     domain span are idle.
  */
 static inline int nohz_kick_needed(struct rq *rq, int cpu)
 {
 	unsigned long now = jiffies;
-	int ret;
-	int first_pick_cpu, second_pick_cpu;
+	struct sched_domain *sd;
 
-	if (time_before(now, nohz.next_balance))
+	if (unlikely(idle_cpu(cpu)))
 		return 0;
 
-	if (idle_cpu(cpu))
-		return 0;
+       /*
+	* We may be recently in ticked or tickless idle mode. At the first
+	* busy tick after returning from idle, we will update the busy stats.
+	*/
+	set_cpu_sd_state_busy();
+	if (unlikely(test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))) {
+		clear_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
+		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
+		atomic_dec(&nohz.nr_cpus);
+	}
 
-	first_pick_cpu = atomic_read(&nohz.first_pick_cpu);
-	second_pick_cpu = atomic_read(&nohz.second_pick_cpu);
+	/*
+	 * None are in tickless mode and hence no need for NOHZ idle load
+	 * balancing.
+	 */
+	if (likely(!atomic_read(&nohz.nr_cpus)))
+		return 0;
 
-	if (first_pick_cpu < nr_cpu_ids && first_pick_cpu != cpu &&
-	    second_pick_cpu < nr_cpu_ids && second_pick_cpu != cpu)
+	if (time_before(now, nohz.next_balance))
 		return 0;
 
-	ret = atomic_cmpxchg(&nohz.first_pick_cpu, nr_cpu_ids, cpu);
-	if (ret == nr_cpu_ids || ret == cpu) {
-		atomic_cmpxchg(&nohz.second_pick_cpu, cpu, nr_cpu_ids);
-		if (rq->nr_running > 1)
-			return 1;
-	} else {
-		ret = atomic_cmpxchg(&nohz.second_pick_cpu, nr_cpu_ids, cpu);
-		if (ret == nr_cpu_ids || ret == cpu) {
-			if (rq->nr_running)
-				return 1;
-		}
+	if (rq->nr_running >= 2)
+		goto need_kick;
+
+	rcu_read_lock();
+	for_each_domain(cpu, sd) {
+		struct sched_group *sg = sd->groups;
+		struct sched_group_power *sgp = sg->sgp;
+		int nr_busy = atomic_read(&sgp->nr_busy_cpus);
+
+		if (sd->flags & SD_SHARE_PKG_RESOURCES && nr_busy > 1)
+			goto need_kick_unlock;
+
+		if (sd->flags & SD_ASYM_PACKING && nr_busy != sg->group_weight
+		    && (cpumask_first_and(nohz.idle_cpus_mask,
+					  sched_domain_span(sd)) < cpu))
+			goto need_kick_unlock;
+
+		if (!(sd->flags & (SD_SHARE_PKG_RESOURCES | SD_ASYM_PACKING)))
+			break;
 	}
+	rcu_read_unlock();
 	return 0;
+
+need_kick_unlock:
+	rcu_read_unlock();
+need_kick:
+	return 1;
 }
 #else
 static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle) { }
@@ -4824,14 +5143,14 @@ static inline int on_null_domain(int cpu)
 /*
  * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
  */
-static inline void trigger_load_balance(struct rq *rq, int cpu)
+void trigger_load_balance(struct rq *rq, int cpu)
 {
 	/* Don't need to rebalance while attached to NULL domain */
 	if (time_after_eq(jiffies, rq->next_balance) &&
 	    likely(!on_null_domain(cpu)))
 		raise_softirq(SCHED_SOFTIRQ);
 #ifdef CONFIG_NO_HZ
-	else if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
+	if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
 		nohz_balancer_kick(cpu);
 #endif
 }
@@ -4846,15 +5165,6 @@ static void rq_offline_fair(struct rq *rq)
 	update_sysctl();
 }
 
-#else	/* CONFIG_SMP */
-
-/*
- * on UP we do not need to balance between CPUs:
- */
-static inline void idle_balance(int cpu, struct rq *rq)
-{
-}
-
 #endif /* CONFIG_SMP */
 
 /*
@@ -4878,8 +5188,8 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
  */
 static void task_fork_fair(struct task_struct *p)
 {
-	struct cfs_rq *cfs_rq = task_cfs_rq(current);
-	struct sched_entity *se = &p->se, *curr = cfs_rq->curr;
+	struct cfs_rq *cfs_rq;
+	struct sched_entity *se = &p->se, *curr;
 	int this_cpu = smp_processor_id();
 	struct rq *rq = this_rq();
 	unsigned long flags;
@@ -4888,6 +5198,9 @@ static void task_fork_fair(struct task_struct *p)
 
 	update_rq_clock(rq);
 
+	cfs_rq = task_cfs_rq(current);
+	curr = cfs_rq->curr;
+
 	if (unlikely(task_cpu(p) != this_cpu)) {
 		rcu_read_lock();
 		__set_task_cpu(p, this_cpu);
@@ -4997,6 +5310,16 @@ static void set_curr_task_fair(struct rq *rq)
 	}
 }
 
+void init_cfs_rq(struct cfs_rq *cfs_rq)
+{
+	cfs_rq->tasks_timeline = RB_ROOT;
+	INIT_LIST_HEAD(&cfs_rq->tasks);
+	cfs_rq->min_vruntime = (u64)(-(1LL << 20));
+#ifndef CONFIG_64BIT
+	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
+#endif
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void task_move_group_fair(struct task_struct *p, int on_rq)
 {
@@ -5013,13 +5336,182 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
 	 * to another cgroup's rq. This does somewhat interfere with the
 	 * fair sleeper stuff for the first placement, but who cares.
 	 */
+	/*
+	 * When !on_rq, vruntime of the task has usually NOT been normalized.
+	 * But there are some cases where it has already been normalized:
+	 *
+	 * - Moving a forked child which is waiting for being woken up by
+	 *   wake_up_new_task().
+	 * - Moving a task which has been woken up by try_to_wake_up() and
+	 *   waiting for actually being woken up by sched_ttwu_pending().
+	 *
+	 * To prevent boost or penalty in the new cfs_rq caused by delta
+	 * min_vruntime between the two cfs_rqs, we skip vruntime adjustment.
+	 */
+	if (!on_rq && (!p->se.sum_exec_runtime || p->state == TASK_WAKING))
+		on_rq = 1;
+
 	if (!on_rq)
 		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
 	set_task_rq(p, task_cpu(p));
 	if (!on_rq)
 		p->se.vruntime += cfs_rq_of(&p->se)->min_vruntime;
 }
+
+void free_fair_sched_group(struct task_group *tg)
+{
+	int i;
+
+	destroy_cfs_bandwidth(tg_cfs_bandwidth(tg));
+
+	for_each_possible_cpu(i) {
+		if (tg->cfs_rq)
+			kfree(tg->cfs_rq[i]);
+		if (tg->se)
+			kfree(tg->se[i]);
+	}
+
+	kfree(tg->cfs_rq);
+	kfree(tg->se);
+}
+
+int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
+{
+	struct cfs_rq *cfs_rq;
+	struct sched_entity *se;
+	int i;
+
+	tg->cfs_rq = kzalloc(sizeof(cfs_rq) * nr_cpu_ids, GFP_KERNEL);
+	if (!tg->cfs_rq)
+		goto err;
+	tg->se = kzalloc(sizeof(se) * nr_cpu_ids, GFP_KERNEL);
+	if (!tg->se)
+		goto err;
+
+	tg->shares = NICE_0_LOAD;
+
+	init_cfs_bandwidth(tg_cfs_bandwidth(tg));
+
+	for_each_possible_cpu(i) {
+		cfs_rq = kzalloc_node(sizeof(struct cfs_rq),
+				      GFP_KERNEL, cpu_to_node(i));
+		if (!cfs_rq)
+			goto err;
+
+		se = kzalloc_node(sizeof(struct sched_entity),
+				  GFP_KERNEL, cpu_to_node(i));
+		if (!se)
+			goto err_free_rq;
+
+		init_cfs_rq(cfs_rq);
+		init_tg_cfs_entry(tg, cfs_rq, se, i, parent->se[i]);
+	}
+
+	return 1;
+
+err_free_rq:
+	kfree(cfs_rq);
+err:
+	return 0;
+}
+
+void unregister_fair_sched_group(struct task_group *tg, int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
+
+	/*
+	* Only empty task groups can be destroyed; so we can speculatively
+	* check on_list without danger of it being re-added.
+	*/
+	if (!tg->cfs_rq[cpu]->on_list)
+		return;
+
+	raw_spin_lock_irqsave(&rq->lock, flags);
+	list_del_leaf_cfs_rq(tg->cfs_rq[cpu]);
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
+}
+
+void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
+			struct sched_entity *se, int cpu,
+			struct sched_entity *parent)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+	cfs_rq->tg = tg;
+	cfs_rq->rq = rq;
+#ifdef CONFIG_SMP
+	/* allow initial update_cfs_load() to truncate */
+	cfs_rq->load_stamp = 1;
 #endif
+	init_cfs_rq_runtime(cfs_rq);
+
+	tg->cfs_rq[cpu] = cfs_rq;
+	tg->se[cpu] = se;
+
+	/* se could be NULL for root_task_group */
+	if (!se)
+		return;
+
+	if (!parent)
+		se->cfs_rq = &rq->cfs;
+	else
+		se->cfs_rq = parent->my_q;
+
+	se->my_q = cfs_rq;
+	update_load_set(&se->load, 0);
+	se->parent = parent;
+}
+
+static DEFINE_MUTEX(shares_mutex);
+
+int sched_group_set_shares(struct task_group *tg, unsigned long shares)
+{
+	int i;
+	unsigned long flags;
+
+	/*
+	 * We can't change the weight of the root cgroup.
+	 */
+	if (!tg->se[0])
+		return -EINVAL;
+
+	shares = clamp(shares, scale_load(MIN_SHARES), scale_load(MAX_SHARES));
+
+	mutex_lock(&shares_mutex);
+	if (tg->shares == shares)
+		goto done;
+
+	tg->shares = shares;
+	for_each_possible_cpu(i) {
+		struct rq *rq = cpu_rq(i);
+		struct sched_entity *se;
+
+		se = tg->se[i];
+		/* Propagate contribution to hierarchy */
+		raw_spin_lock_irqsave(&rq->lock, flags);
+		for_each_sched_entity(se)
+			update_cfs_shares(group_cfs_rq(se));
+		raw_spin_unlock_irqrestore(&rq->lock, flags);
+	}
+
+done:
+	mutex_unlock(&shares_mutex);
+	return 0;
+}
+#else /* CONFIG_FAIR_GROUP_SCHED */
+
+void free_fair_sched_group(struct task_group *tg) { }
+
+int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
+{
+	return 1;
+}
+
+void unregister_fair_sched_group(struct task_group *tg, int cpu) { }
+
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+
 
 static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task)
 {
@@ -5039,7 +5531,7 @@ static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task
 /*
  * All the scheduling class methods:
  */
-static const struct sched_class fair_sched_class = {
+const struct sched_class fair_sched_class = {
 	.next			= &idle_sched_class,
 	.enqueue_task		= enqueue_task_fair,
 	.dequeue_task		= dequeue_task_fair,
@@ -5076,7 +5568,7 @@ static const struct sched_class fair_sched_class = {
 };
 
 #ifdef CONFIG_SCHED_DEBUG
-static void print_cfs_stats(struct seq_file *m, int cpu)
+void print_cfs_stats(struct seq_file *m, int cpu)
 {
 	struct cfs_rq *cfs_rq;
 
@@ -5086,3 +5578,15 @@ static void print_cfs_stats(struct seq_file *m, int cpu)
 	rcu_read_unlock();
 }
 #endif
+
+__init void init_sched_fair_class(void)
+{
+#ifdef CONFIG_SMP
+	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
+
+#ifdef CONFIG_NO_HZ
+	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
+#endif
+#endif /* SMP */
+
+}
diff --git a/kernel/sched_features.h b/kernel/sched/features.h
similarity index 75%
rename from kernel/sched_features.h
rename to kernel/sched/features.h
index 8480224..e61fd73 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched/features.h
@@ -3,13 +3,13 @@
  * them to run sooner, but does not allow tons of sleepers to
  * rip the spread apart.
  */
-SCHED_FEAT(GENTLE_FAIR_SLEEPERS, 1)
+SCHED_FEAT(GENTLE_FAIR_SLEEPERS, true)
 
 /*
  * Place new tasks ahead so that they do not starve already running
  * tasks
  */
-SCHED_FEAT(START_DEBIT, 1)
+SCHED_FEAT(START_DEBIT, true)
 
 /*
  * Based on load and program behaviour, see if it makes sense to place
@@ -17,54 +17,54 @@ SCHED_FEAT(START_DEBIT, 1)
  * improve cache locality. Typically used with SYNC wakeups as
  * generated by pipes and the like, see also SYNC_WAKEUPS.
  */
-SCHED_FEAT(AFFINE_WAKEUPS, 1)
+SCHED_FEAT(AFFINE_WAKEUPS, true)
 
 /*
  * Prefer to schedule the task we woke last (assuming it failed
  * wakeup-preemption), since its likely going to consume data we
  * touched, increases cache locality.
  */
-SCHED_FEAT(NEXT_BUDDY, 0)
+SCHED_FEAT(NEXT_BUDDY, false)
 
 /*
  * Prefer to schedule the task that ran last (when we did
  * wake-preempt) as that likely will touch the same data, increases
  * cache locality.
  */
-SCHED_FEAT(LAST_BUDDY, 1)
+SCHED_FEAT(LAST_BUDDY, true)
 
 /*
  * Consider buddies to be cache hot, decreases the likelyness of a
  * cache buddy being migrated away, increases cache locality.
  */
-SCHED_FEAT(CACHE_HOT_BUDDY, 1)
+SCHED_FEAT(CACHE_HOT_BUDDY, true)
 
 /*
  * Use arch dependent cpu power functions
  */
-SCHED_FEAT(ARCH_POWER, 0)
+SCHED_FEAT(ARCH_POWER, false)
 
-SCHED_FEAT(HRTICK, 0)
-SCHED_FEAT(DOUBLE_TICK, 0)
-SCHED_FEAT(LB_BIAS, 1)
+SCHED_FEAT(HRTICK, false)
+SCHED_FEAT(DOUBLE_TICK, false)
+SCHED_FEAT(LB_BIAS, true)
 
 /*
  * Spin-wait on mutex acquisition when the mutex owner is running on
  * another cpu -- assumes that when the owner is running, it will soon
  * release the lock. Decreases scheduling overhead.
  */
-SCHED_FEAT(OWNER_SPIN, 1)
+SCHED_FEAT(OWNER_SPIN, true)
 
 /*
  * Decrement CPU power based on time not spent running tasks
  */
-SCHED_FEAT(NONTASK_POWER, 1)
+SCHED_FEAT(NONTASK_POWER, true)
 
 /*
  * Queue remote wakeups on the target CPU and process them
  * using the scheduler IPI. Reduces rq->lock contention/bounces.
  */
-SCHED_FEAT(TTWU_QUEUE, 1)
+SCHED_FEAT(TTWU_QUEUE, true)
 
-SCHED_FEAT(FORCE_SD_OVERLAP, 0)
-SCHED_FEAT(RT_RUNTIME_SHARE, 1)
+SCHED_FEAT(FORCE_SD_OVERLAP, false)
+SCHED_FEAT(RT_RUNTIME_SHARE, true)
diff --git a/kernel/sched_idletask.c b/kernel/sched/idle_task.c
similarity index 96%
rename from kernel/sched_idletask.c
rename to kernel/sched/idle_task.c
index 0a51882..91b4c95 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched/idle_task.c
@@ -1,3 +1,5 @@
+#include "sched.h"
+
 /*
  * idle-task scheduling class.
  *
@@ -71,7 +73,7 @@ static unsigned int get_rr_interval_idle(struct rq *rq, struct task_struct *task
 /*
  * Simple, special scheduling class for the per-CPU idle tasks:
  */
-static const struct sched_class idle_sched_class = {
+const struct sched_class idle_sched_class = {
 	/* .next is NULL */
 	/* no enqueue/yield_task for idle tasks */
 
diff --git a/kernel/sched_rt.c b/kernel/sched/rt.c
similarity index 90%
rename from kernel/sched_rt.c
rename to kernel/sched/rt.c
index 583a136..3640ebb 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched/rt.c
@@ -3,7 +3,92 @@
  * policies)
  */
 
+#include "sched.h"
+
+#include <linux/slab.h>
+
+static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
+
+struct rt_bandwidth def_rt_bandwidth;
+
+static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
+{
+	struct rt_bandwidth *rt_b =
+		container_of(timer, struct rt_bandwidth, rt_period_timer);
+	ktime_t now;
+	int overrun;
+	int idle = 0;
+
+	for (;;) {
+		now = hrtimer_cb_get_time(timer);
+		overrun = hrtimer_forward(timer, now, rt_b->rt_period);
+
+		if (!overrun)
+			break;
+
+		idle = do_sched_rt_period_timer(rt_b, overrun);
+	}
+
+	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
+}
+
+void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime)
+{
+	rt_b->rt_period = ns_to_ktime(period);
+	rt_b->rt_runtime = runtime;
+
+	raw_spin_lock_init(&rt_b->rt_runtime_lock);
+
+	hrtimer_init(&rt_b->rt_period_timer,
+			CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	rt_b->rt_period_timer.function = sched_rt_period_timer;
+}
+
+static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
+{
+	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
+		return;
+
+	if (hrtimer_active(&rt_b->rt_period_timer))
+		return;
+
+	raw_spin_lock(&rt_b->rt_runtime_lock);
+	start_bandwidth_timer(&rt_b->rt_period_timer, rt_b->rt_period);
+	raw_spin_unlock(&rt_b->rt_runtime_lock);
+}
+
+void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
+{
+	struct rt_prio_array *array;
+	int i;
+
+	array = &rt_rq->active;
+	for (i = 0; i < MAX_RT_PRIO; i++) {
+		INIT_LIST_HEAD(array->queue + i);
+		__clear_bit(i, array->bitmap);
+	}
+	/* delimiter for bitsearch: */
+	__set_bit(MAX_RT_PRIO, array->bitmap);
+
+#if defined CONFIG_SMP
+	rt_rq->highest_prio.curr = MAX_RT_PRIO;
+	rt_rq->highest_prio.next = MAX_RT_PRIO;
+	rt_rq->rt_nr_migratory = 0;
+	rt_rq->overloaded = 0;
+	plist_head_init(&rt_rq->pushable_tasks);
+#endif
+
+	rt_rq->rt_time = 0;
+	rt_rq->rt_throttled = 0;
+	rt_rq->rt_runtime = 0;
+	raw_spin_lock_init(&rt_rq->rt_runtime_lock);
+}
+
 #ifdef CONFIG_RT_GROUP_SCHED
+static void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
+{
+	hrtimer_cancel(&rt_b->rt_period_timer);
+}
 
 #define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
 
@@ -25,6 +110,91 @@ static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
 	return rt_se->rt_rq;
 }
 
+void free_rt_sched_group(struct task_group *tg)
+{
+	int i;
+
+	if (tg->rt_se)
+		destroy_rt_bandwidth(&tg->rt_bandwidth);
+
+	for_each_possible_cpu(i) {
+		if (tg->rt_rq)
+			kfree(tg->rt_rq[i]);
+		if (tg->rt_se)
+			kfree(tg->rt_se[i]);
+	}
+
+	kfree(tg->rt_rq);
+	kfree(tg->rt_se);
+}
+
+void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
+		struct sched_rt_entity *rt_se, int cpu,
+		struct sched_rt_entity *parent)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+	rt_rq->highest_prio.curr = MAX_RT_PRIO;
+	rt_rq->rt_nr_boosted = 0;
+	rt_rq->rq = rq;
+	rt_rq->tg = tg;
+
+	tg->rt_rq[cpu] = rt_rq;
+	tg->rt_se[cpu] = rt_se;
+
+	if (!rt_se)
+		return;
+
+	if (!parent)
+		rt_se->rt_rq = &rq->rt;
+	else
+		rt_se->rt_rq = parent->my_q;
+
+	rt_se->my_q = rt_rq;
+	rt_se->parent = parent;
+	INIT_LIST_HEAD(&rt_se->run_list);
+}
+
+int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
+{
+	struct rt_rq *rt_rq;
+	struct sched_rt_entity *rt_se;
+	int i;
+
+	tg->rt_rq = kzalloc(sizeof(rt_rq) * nr_cpu_ids, GFP_KERNEL);
+	if (!tg->rt_rq)
+		goto err;
+	tg->rt_se = kzalloc(sizeof(rt_se) * nr_cpu_ids, GFP_KERNEL);
+	if (!tg->rt_se)
+		goto err;
+
+	init_rt_bandwidth(&tg->rt_bandwidth,
+			ktime_to_ns(def_rt_bandwidth.rt_period), 0);
+
+	for_each_possible_cpu(i) {
+		rt_rq = kzalloc_node(sizeof(struct rt_rq),
+				     GFP_KERNEL, cpu_to_node(i));
+		if (!rt_rq)
+			goto err;
+
+		rt_se = kzalloc_node(sizeof(struct sched_rt_entity),
+				     GFP_KERNEL, cpu_to_node(i));
+		if (!rt_se)
+			goto err_free_rq;
+
+		init_rt_rq(rt_rq, cpu_rq(i));
+		rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
+		init_tg_rt_entry(tg, rt_rq, rt_se, i, parent->rt_se[i]);
+	}
+
+	return 1;
+
+err_free_rq:
+	kfree(rt_rq);
+err:
+	return 0;
+}
+
 #else /* CONFIG_RT_GROUP_SCHED */
 
 #define rt_entity_is_task(rt_se) (1)
@@ -47,6 +217,12 @@ static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
 	return &rq->rt;
 }
 
+void free_rt_sched_group(struct task_group *tg) { }
+
+int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
+{
+	return 1;
+}
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_SMP
@@ -556,6 +732,28 @@ static void enable_runtime(struct rq *rq)
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
+int update_runtime(struct notifier_block *nfb, unsigned long action, void *hcpu)
+{
+	int cpu = (int)(long)hcpu;
+
+	switch (action) {
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		disable_runtime(cpu_rq(cpu));
+		return NOTIFY_OK;
+
+	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		enable_runtime(cpu_rq(cpu));
+		return NOTIFY_OK;
+
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
 static int balance_runtime(struct rt_rq *rt_rq)
 {
 	int more = 0;
@@ -648,7 +846,7 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 	if (rt_rq->rt_throttled)
 		return rt_rq_throttled(rt_rq);
 
-	if (sched_rt_runtime(rt_rq) >= sched_rt_period(rt_rq))
+	if (runtime >= sched_rt_period(rt_rq))
 		return 0;
 
 	balance_runtime(rt_rq);
@@ -957,8 +1155,8 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 }
 
 /*
- * Put task to the end of the run list without the overhead of dequeue
- * followed by enqueue.
+ * Put task to the head or the end of the run list without the overhead of
+ * dequeue followed by enqueue.
  */
 static void
 requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se, int head)
@@ -1002,6 +1200,9 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 
 	cpu = task_cpu(p);
 
+	if (p->rt.nr_cpus_allowed == 1)
+		goto out;
+
 	/* For anything but wake ups, just return the task_cpu */
 	if (sd_flag != SD_BALANCE_WAKE && sd_flag != SD_BALANCE_FORK)
 		goto out;
@@ -1178,8 +1379,6 @@ static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 /* Only try algorithms three times */
 #define RT_MAX_TRIES 3
 
-static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep);
-
 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 {
 	if (!task_running(rq, p) &&
@@ -1653,13 +1852,14 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p)
 		pull_rt_task(rq);
 }
 
-static inline void init_sched_rt_class(void)
+void init_sched_rt_class(void)
 {
 	unsigned int i;
 
-	for_each_possible_cpu(i)
+	for_each_possible_cpu(i) {
 		zalloc_cpumask_var_node(&per_cpu(local_cpu_mask, i),
 					GFP_KERNEL, cpu_to_node(i));
+	}
 }
 #endif /* CONFIG_SMP */
 
@@ -1800,7 +2000,7 @@ static unsigned int get_rr_interval_rt(struct rq *rq, struct task_struct *task)
 		return 0;
 }
 
-static const struct sched_class rt_sched_class = {
+const struct sched_class rt_sched_class = {
 	.next			= &fair_sched_class,
 	.enqueue_task		= enqueue_task_rt,
 	.dequeue_task		= dequeue_task_rt,
@@ -1835,7 +2035,7 @@ static const struct sched_class rt_sched_class = {
 #ifdef CONFIG_SCHED_DEBUG
 extern void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq);
 
-static void print_rt_stats(struct seq_file *m, int cpu)
+void print_rt_stats(struct seq_file *m, int cpu)
 {
 	rt_rq_iter_t iter;
 	struct rt_rq *rt_rq;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
new file mode 100644
index 0000000..98c0c26
--- /dev/null
+++ b/kernel/sched/sched.h
@@ -0,0 +1,1166 @@
+
+#include <linux/sched.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/stop_machine.h>
+
+#include "cpupri.h"
+
+extern __read_mostly int scheduler_running;
+
+/*
+ * Convert user-nice values [ -20 ... 0 ... 19 ]
+ * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
+ * and back.
+ */
+#define NICE_TO_PRIO(nice)	(MAX_RT_PRIO + (nice) + 20)
+#define PRIO_TO_NICE(prio)	((prio) - MAX_RT_PRIO - 20)
+#define TASK_NICE(p)		PRIO_TO_NICE((p)->static_prio)
+
+/*
+ * 'User priority' is the nice value converted to something we
+ * can work with better when scaling various scheduler parameters,
+ * it's a [ 0 ... 39 ] range.
+ */
+#define USER_PRIO(p)		((p)-MAX_RT_PRIO)
+#define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
+#define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
+
+/*
+ * Helpers for converting nanosecond timing to jiffy resolution
+ */
+#define NS_TO_JIFFIES(TIME)	((unsigned long)(TIME) / (NSEC_PER_SEC / HZ))
+
+#define NICE_0_LOAD		SCHED_LOAD_SCALE
+#define NICE_0_SHIFT		SCHED_LOAD_SHIFT
+
+/*
+ * These are the 'tuning knobs' of the scheduler:
+ *
+ * default timeslice is 100 msecs (used only for SCHED_RR tasks).
+ * Timeslices get refilled after they expire.
+ */
+#define DEF_TIMESLICE		(100 * HZ / 1000)
+
+/*
+ * single value that denotes runtime == period, ie unlimited time.
+ */
+#define RUNTIME_INF	((u64)~0ULL)
+
+static inline int rt_policy(int policy)
+{
+	if (policy == SCHED_FIFO || policy == SCHED_RR)
+		return 1;
+	return 0;
+}
+
+static inline int task_has_rt_policy(struct task_struct *p)
+{
+	return rt_policy(p->policy);
+}
+
+/*
+ * This is the priority-queue data structure of the RT scheduling class:
+ */
+struct rt_prio_array {
+	DECLARE_BITMAP(bitmap, MAX_RT_PRIO+1); /* include 1 bit for delimiter */
+	struct list_head queue[MAX_RT_PRIO];
+};
+
+struct rt_bandwidth {
+	/* nests inside the rq lock: */
+	raw_spinlock_t		rt_runtime_lock;
+	ktime_t			rt_period;
+	u64			rt_runtime;
+	struct hrtimer		rt_period_timer;
+};
+
+extern struct mutex sched_domains_mutex;
+
+#ifdef CONFIG_CGROUP_SCHED
+
+#include <linux/cgroup.h>
+
+struct cfs_rq;
+struct rt_rq;
+
+static LIST_HEAD(task_groups);
+
+struct cfs_bandwidth {
+#ifdef CONFIG_CFS_BANDWIDTH
+	raw_spinlock_t lock;
+	ktime_t period;
+	u64 quota, runtime;
+	s64 hierarchal_quota;
+	u64 runtime_expires;
+
+	int idle, timer_active;
+	struct hrtimer period_timer, slack_timer;
+	struct list_head throttled_cfs_rq;
+
+	/* statistics */
+	int nr_periods, nr_throttled;
+	u64 throttled_time;
+#endif
+};
+
+/* task group related information */
+struct task_group {
+	struct cgroup_subsys_state css;
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	/* schedulable entities of this group on each cpu */
+	struct sched_entity **se;
+	/* runqueue "owned" by this group on each cpu */
+	struct cfs_rq **cfs_rq;
+	unsigned long shares;
+
+	atomic_t load_weight;
+#endif
+
+#ifdef CONFIG_RT_GROUP_SCHED
+	struct sched_rt_entity **rt_se;
+	struct rt_rq **rt_rq;
+
+	struct rt_bandwidth rt_bandwidth;
+#endif
+
+	struct rcu_head rcu;
+	struct list_head list;
+
+	struct task_group *parent;
+	struct list_head siblings;
+	struct list_head children;
+
+#ifdef CONFIG_SCHED_AUTOGROUP
+	struct autogroup *autogroup;
+#endif
+
+	struct cfs_bandwidth cfs_bandwidth;
+};
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+#define ROOT_TASK_GROUP_LOAD	NICE_0_LOAD
+
+/*
+ * A weight of 0 or 1 can cause arithmetics problems.
+ * A weight of a cfs_rq is the sum of weights of which entities
+ * are queued on this cfs_rq, so a weight of a entity should not be
+ * too large, so as the shares value of a task group.
+ * (The default weight is 1024 - so there's no practical
+ *  limitation from this.)
+ */
+#define MIN_SHARES	(1UL <<  1)
+#define MAX_SHARES	(1UL << 18)
+#endif
+
+/* Default task group.
+ *	Every task in system belong to this group at bootup.
+ */
+extern struct task_group root_task_group;
+
+typedef int (*tg_visitor)(struct task_group *, void *);
+
+extern int walk_tg_tree_from(struct task_group *from,
+			     tg_visitor down, tg_visitor up, void *data);
+
+/*
+ * Iterate the full tree, calling @down when first entering a node and @up when
+ * leaving it for the final time.
+ *
+ * Caller must hold rcu_lock or sufficient equivalent.
+ */
+static inline int walk_tg_tree(tg_visitor down, tg_visitor up, void *data)
+{
+	return walk_tg_tree_from(&root_task_group, down, up, data);
+}
+
+extern int tg_nop(struct task_group *tg, void *data);
+
+extern void free_fair_sched_group(struct task_group *tg);
+extern int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent);
+extern void unregister_fair_sched_group(struct task_group *tg, int cpu);
+extern void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
+			struct sched_entity *se, int cpu,
+			struct sched_entity *parent);
+extern void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b);
+extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
+
+extern void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b);
+extern void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b);
+extern void unthrottle_cfs_rq(struct cfs_rq *cfs_rq);
+
+extern void free_rt_sched_group(struct task_group *tg);
+extern int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent);
+extern void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
+		struct sched_rt_entity *rt_se, int cpu,
+		struct sched_rt_entity *parent);
+
+#else /* CONFIG_CGROUP_SCHED */
+
+struct cfs_bandwidth { };
+
+#endif	/* CONFIG_CGROUP_SCHED */
+
+/* CFS-related fields in a runqueue */
+struct cfs_rq {
+	struct load_weight load;
+	unsigned long nr_running, h_nr_running;
+
+	u64 exec_clock;
+	u64 min_vruntime;
+#ifndef CONFIG_64BIT
+	u64 min_vruntime_copy;
+#endif
+
+	struct rb_root tasks_timeline;
+	struct rb_node *rb_leftmost;
+
+	struct list_head tasks;
+	struct list_head *balance_iterator;
+
+	/*
+	 * 'curr' points to currently running entity on this cfs_rq.
+	 * It is set to NULL otherwise (i.e when none are currently running).
+	 */
+	struct sched_entity *curr, *next, *last, *skip;
+
+#ifdef	CONFIG_SCHED_DEBUG
+	unsigned int nr_spread_over;
+#endif
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */
+
+	/*
+	 * leaf cfs_rqs are those that hold tasks (lowest schedulable entity in
+	 * a hierarchy). Non-leaf lrqs hold other higher schedulable entities
+	 * (like users, containers etc.)
+	 *
+	 * leaf_cfs_rq_list ties together list of leaf cfs_rq's in a cpu. This
+	 * list is used during load balance.
+	 */
+	int on_list;
+	struct list_head leaf_cfs_rq_list;
+	struct task_group *tg;	/* group that "owns" this runqueue */
+
+#ifdef CONFIG_SMP
+	/*
+	 * the part of load.weight contributed by tasks
+	 */
+	unsigned long task_weight;
+
+	/*
+	 *   h_load = weight * f(tg)
+	 *
+	 * Where f(tg) is the recursive weight fraction assigned to
+	 * this group.
+	 */
+	unsigned long h_load;
+
+	/*
+	 * Maintaining per-cpu shares distribution for group scheduling
+	 *
+	 * load_stamp is the last time we updated the load average
+	 * load_last is the last time we updated the load average and saw load
+	 * load_unacc_exec_time is currently unaccounted execution time
+	 */
+	u64 load_avg;
+	u64 load_period;
+	u64 load_stamp, load_last, load_unacc_exec_time;
+
+	unsigned long load_contribution;
+#endif /* CONFIG_SMP */
+#ifdef CONFIG_CFS_BANDWIDTH
+	int runtime_enabled;
+	u64 runtime_expires;
+	s64 runtime_remaining;
+
+	u64 throttled_timestamp;
+	int throttled, throttle_count;
+	struct list_head throttled_list;
+#endif /* CONFIG_CFS_BANDWIDTH */
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+};
+
+static inline int rt_bandwidth_enabled(void)
+{
+	return sysctl_sched_rt_runtime >= 0;
+}
+
+/* Real-Time classes' related field in a runqueue: */
+struct rt_rq {
+	struct rt_prio_array active;
+	unsigned long rt_nr_running;
+#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
+	struct {
+		int curr; /* highest queued rt task prio */
+#ifdef CONFIG_SMP
+		int next; /* next highest */
+#endif
+	} highest_prio;
+#endif
+#ifdef CONFIG_SMP
+	unsigned long rt_nr_migratory;
+	unsigned long rt_nr_total;
+	int overloaded;
+	struct plist_head pushable_tasks;
+#endif
+	int rt_throttled;
+	u64 rt_time;
+	u64 rt_runtime;
+	/* Nests inside the rq lock: */
+	raw_spinlock_t rt_runtime_lock;
+
+#ifdef CONFIG_RT_GROUP_SCHED
+	unsigned long rt_nr_boosted;
+
+	struct rq *rq;
+	struct list_head leaf_rt_rq_list;
+	struct task_group *tg;
+#endif
+};
+
+#ifdef CONFIG_SMP
+
+/*
+ * We add the notion of a root-domain which will be used to define per-domain
+ * variables. Each exclusive cpuset essentially defines an island domain by
+ * fully partitioning the member cpus from any other cpuset. Whenever a new
+ * exclusive cpuset is created, we also create and attach a new root-domain
+ * object.
+ *
+ */
+struct root_domain {
+	atomic_t refcount;
+	atomic_t rto_count;
+	struct rcu_head rcu;
+	cpumask_var_t span;
+	cpumask_var_t online;
+
+	/*
+	 * The "RT overload" flag: it gets set if a CPU has more than
+	 * one runnable RT task.
+	 */
+	cpumask_var_t rto_mask;
+	struct cpupri cpupri;
+};
+
+extern struct root_domain def_root_domain;
+
+#endif /* CONFIG_SMP */
+
+/*
+ * This is the main, per-CPU runqueue data structure.
+ *
+ * Locking rule: those places that want to lock multiple runqueues
+ * (such as the load balancing or the thread migration code), lock
+ * acquire operations must be ordered by ascending &runqueue.
+ */
+struct rq {
+	/* runqueue lock: */
+	raw_spinlock_t lock;
+
+	/*
+	 * nr_running and cpu_load should be in the same cacheline because
+	 * remote CPUs use both these fields when doing load calculation.
+	 */
+	unsigned long nr_running;
+	#define CPU_LOAD_IDX_MAX 5
+	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
+	unsigned long last_load_update_tick;
+#ifdef CONFIG_NO_HZ
+	u64 nohz_stamp;
+	unsigned long nohz_flags;
+#endif
+	int skip_clock_update;
+
+	/* capture load from *all* tasks on this cpu: */
+	struct load_weight load;
+	unsigned long nr_load_updates;
+	u64 nr_switches;
+
+	struct cfs_rq cfs;
+	struct rt_rq rt;
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	/* list of leaf cfs_rq on this cpu: */
+	struct list_head leaf_cfs_rq_list;
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
+	struct list_head leaf_rt_rq_list;
+#endif
+
+	/*
+	 * This is part of a global counter where only the total sum
+	 * over all CPUs matters. A task can increase this counter on
+	 * one CPU and if it got migrated afterwards it may decrease
+	 * it on another CPU. Always updated under the runqueue lock:
+	 */
+	unsigned long nr_uninterruptible;
+
+	struct task_struct *curr, *idle, *stop;
+	unsigned long next_balance;
+	struct mm_struct *prev_mm;
+
+	u64 clock;
+	u64 clock_task;
+
+	atomic_t nr_iowait;
+
+#ifdef CONFIG_SMP
+	struct root_domain *rd;
+	struct sched_domain *sd;
+
+	unsigned long cpu_power;
+
+	unsigned char idle_balance;
+	/* For active balancing */
+	int post_schedule;
+	int active_balance;
+	int push_cpu;
+	struct cpu_stop_work active_balance_work;
+	/* cpu of this runqueue: */
+	int cpu;
+	int online;
+
+	u64 rt_avg;
+	u64 age_stamp;
+	u64 idle_stamp;
+	u64 avg_idle;
+#endif
+
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
+	u64 prev_irq_time;
+#endif
+#ifdef CONFIG_PARAVIRT
+	u64 prev_steal_time;
+#endif
+#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
+	u64 prev_steal_time_rq;
+#endif
+
+	/* calc_load related fields */
+	unsigned long calc_load_update;
+	long calc_load_active;
+
+#ifdef CONFIG_SCHED_HRTICK
+#ifdef CONFIG_SMP
+	int hrtick_csd_pending;
+	struct call_single_data hrtick_csd;
+#endif
+	struct hrtimer hrtick_timer;
+#endif
+
+#ifdef CONFIG_SCHEDSTATS
+	/* latency stats */
+	struct sched_info rq_sched_info;
+	unsigned long long rq_cpu_time;
+	/* could above be rq->cfs_rq.exec_clock + rq->rt_rq.rt_runtime ? */
+
+	/* sys_sched_yield() stats */
+	unsigned int yld_count;
+
+	/* schedule() stats */
+	unsigned int sched_switch;
+	unsigned int sched_count;
+	unsigned int sched_goidle;
+
+	/* try_to_wake_up() stats */
+	unsigned int ttwu_count;
+	unsigned int ttwu_local;
+#endif
+
+#ifdef CONFIG_SMP
+	struct llist_head wake_list;
+#endif
+};
+
+static inline int cpu_of(struct rq *rq)
+{
+#ifdef CONFIG_SMP
+	return rq->cpu;
+#else
+	return 0;
+#endif
+}
+
+DECLARE_PER_CPU(struct rq, runqueues);
+
+#define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
+#define this_rq()		(&__get_cpu_var(runqueues))
+#define task_rq(p)		cpu_rq(task_cpu(p))
+#define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
+#define raw_rq()		(&__raw_get_cpu_var(runqueues))
+
+#ifdef CONFIG_SMP
+
+#define rcu_dereference_check_sched_domain(p) \
+	rcu_dereference_check((p), \
+			      lockdep_is_held(&sched_domains_mutex))
+
+/*
+ * The domain tree (rq->sd) is protected by RCU's quiescent state transition.
+ * See detach_destroy_domains: synchronize_sched for details.
+ *
+ * The domain tree of any CPU may only be accessed from within
+ * preempt-disabled sections.
+ */
+#define for_each_domain(cpu, __sd) \
+	for (__sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd); \
+			__sd; __sd = __sd->parent)
+
+#define for_each_lower_domain(sd) for (; sd; sd = sd->child)
+
+/**
+ * highest_flag_domain - Return highest sched_domain containing flag.
+ * @cpu:	The cpu whose highest level of sched domain is to
+ *		be returned.
+ * @flag:	The flag to check for the highest sched_domain
+ *		for the given cpu.
+ *
+ * Returns the highest sched_domain of a cpu which contains the given flag.
+ */
+static inline struct sched_domain *highest_flag_domain(int cpu, int flag)
+{
+	struct sched_domain *sd, *hsd = NULL;
+
+	for_each_domain(cpu, sd) {
+		if (!(sd->flags & flag))
+			break;
+		hsd = sd;
+	}
+
+	return hsd;
+}
+
+DECLARE_PER_CPU(struct sched_domain *, sd_llc);
+DECLARE_PER_CPU(int, sd_llc_id);
+
+#endif /* CONFIG_SMP */
+
+#include "stats.h"
+#include "auto_group.h"
+
+#ifdef CONFIG_CGROUP_SCHED
+
+/*
+ * Return the group to which this tasks belongs.
+ *
+ * We use task_subsys_state_check() and extend the RCU verification with
+ * pi->lock and rq->lock because cpu_cgroup_attach() holds those locks for each
+ * task it moves into the cgroup. Therefore by holding either of those locks,
+ * we pin the task to the current cgroup.
+ */
+static inline struct task_group *task_group(struct task_struct *p)
+{
+	struct task_group *tg;
+	struct cgroup_subsys_state *css;
+
+	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
+			lockdep_is_held(&p->pi_lock) ||
+			lockdep_is_held(&task_rq(p)->lock));
+	tg = container_of(css, struct task_group, css);
+
+	return autogroup_task_group(p, tg);
+}
+
+/* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
+static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
+{
+#if defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED)
+	struct task_group *tg = task_group(p);
+#endif
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	p->se.cfs_rq = tg->cfs_rq[cpu];
+	p->se.parent = tg->se[cpu];
+#endif
+
+#ifdef CONFIG_RT_GROUP_SCHED
+	p->rt.rt_rq  = tg->rt_rq[cpu];
+	p->rt.parent = tg->rt_se[cpu];
+#endif
+}
+
+#else /* CONFIG_CGROUP_SCHED */
+
+static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
+static inline struct task_group *task_group(struct task_struct *p)
+{
+	return NULL;
+}
+
+#endif /* CONFIG_CGROUP_SCHED */
+
+static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
+{
+	set_task_rq(p, cpu);
+#ifdef CONFIG_SMP
+	/*
+	 * After ->cpu is set up to a new value, task_rq_lock(p, ...) can be
+	 * successfuly executed on another CPU. We must ensure that updates of
+	 * per-task data have been completed by this moment.
+	 */
+	smp_wmb();
+	task_thread_info(p)->cpu = cpu;
+#endif
+}
+
+/*
+ * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
+ */
+#ifdef CONFIG_SCHED_DEBUG
+# include <linux/jump_label.h>
+# define const_debug __read_mostly
+#else
+# define const_debug const
+#endif
+
+extern const_debug unsigned int sysctl_sched_features;
+
+#define SCHED_FEAT(name, enabled)	\
+	__SCHED_FEAT_##name ,
+
+enum {
+#include "features.h"
+	__SCHED_FEAT_NR,
+};
+
+#undef SCHED_FEAT
+
+#if defined(CONFIG_SCHED_DEBUG) && defined(HAVE_JUMP_LABEL)
+static __always_inline bool static_branch__true(struct jump_label_key *key)
+{
+	return likely(static_branch(key)); /* Not out of line branch. */
+}
+
+static __always_inline bool static_branch__false(struct jump_label_key *key)
+{
+	return unlikely(static_branch(key)); /* Out of line branch. */
+}
+
+#define SCHED_FEAT(name, enabled)					\
+static __always_inline bool static_branch_##name(struct jump_label_key *key) \
+{									\
+	return static_branch__##enabled(key);				\
+}
+
+#include "features.h"
+
+#undef SCHED_FEAT
+
+extern struct jump_label_key sched_feat_keys[__SCHED_FEAT_NR];
+#define sched_feat(x) (static_branch_##x(&sched_feat_keys[__SCHED_FEAT_##x]))
+#else /* !(SCHED_DEBUG && HAVE_JUMP_LABEL) */
+#define sched_feat(x) (sysctl_sched_features & (1UL << __SCHED_FEAT_##x))
+#endif /* SCHED_DEBUG && HAVE_JUMP_LABEL */
+
+static inline u64 global_rt_period(void)
+{
+	return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
+}
+
+static inline u64 global_rt_runtime(void)
+{
+	if (sysctl_sched_rt_runtime < 0)
+		return RUNTIME_INF;
+
+	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
+}
+
+
+
+static inline int task_current(struct rq *rq, struct task_struct *p)
+{
+	return rq->curr == p;
+}
+
+static inline int task_running(struct rq *rq, struct task_struct *p)
+{
+#ifdef CONFIG_SMP
+	return p->on_cpu;
+#else
+	return task_current(rq, p);
+#endif
+}
+
+
+#ifndef prepare_arch_switch
+# define prepare_arch_switch(next)	do { } while (0)
+#endif
+#ifndef finish_arch_switch
+# define finish_arch_switch(prev)	do { } while (0)
+#endif
+
+#ifndef __ARCH_WANT_UNLOCKED_CTXSW
+static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
+{
+#ifdef CONFIG_SMP
+	/*
+	 * We can optimise this out completely for !SMP, because the
+	 * SMP rebalancing from interrupt is the only thing that cares
+	 * here.
+	 */
+	next->on_cpu = 1;
+#endif
+}
+
+static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
+{
+#ifdef CONFIG_SMP
+	/*
+	 * After ->on_cpu is cleared, the task can be moved to a different CPU.
+	 * We must ensure this doesn't happen until the switch is completely
+	 * finished.
+	 */
+	smp_wmb();
+	prev->on_cpu = 0;
+#endif
+#ifdef CONFIG_DEBUG_SPINLOCK
+	/* this is a valid case when another task releases the spinlock */
+	rq->lock.owner = current;
+#endif
+	/*
+	 * If we are tracking spinlock dependencies then we have to
+	 * fix up the runqueue lock - which gets 'carried over' from
+	 * prev into current:
+	 */
+	spin_acquire(&rq->lock.dep_map, 0, 0, _THIS_IP_);
+
+	raw_spin_unlock_irq(&rq->lock);
+}
+
+#else /* __ARCH_WANT_UNLOCKED_CTXSW */
+static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
+{
+#ifdef CONFIG_SMP
+	/*
+	 * We can optimise this out completely for !SMP, because the
+	 * SMP rebalancing from interrupt is the only thing that cares
+	 * here.
+	 */
+	next->on_cpu = 1;
+#endif
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	raw_spin_unlock_irq(&rq->lock);
+#else
+	raw_spin_unlock(&rq->lock);
+#endif
+}
+
+static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
+{
+#ifdef CONFIG_SMP
+	/*
+	 * After ->on_cpu is cleared, the task can be moved to a different CPU.
+	 * We must ensure this doesn't happen until the switch is completely
+	 * finished.
+	 */
+	smp_wmb();
+	prev->on_cpu = 0;
+#endif
+#ifndef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	local_irq_enable();
+#endif
+}
+#endif /* __ARCH_WANT_UNLOCKED_CTXSW */
+
+
+static inline void update_load_add(struct load_weight *lw, unsigned long inc)
+{
+	lw->weight += inc;
+	lw->inv_weight = 0;
+}
+
+static inline void update_load_sub(struct load_weight *lw, unsigned long dec)
+{
+	lw->weight -= dec;
+	lw->inv_weight = 0;
+}
+
+static inline void update_load_set(struct load_weight *lw, unsigned long w)
+{
+	lw->weight = w;
+	lw->inv_weight = 0;
+}
+
+/*
+ * To aid in avoiding the subversion of "niceness" due to uneven distribution
+ * of tasks with abnormal "nice" values across CPUs the contribution that
+ * each task makes to its run queue's load is weighted according to its
+ * scheduling class and "nice" value. For SCHED_NORMAL tasks this is just a
+ * scaled version of the new time slice allocation that they receive on time
+ * slice expiry etc.
+ */
+
+#define WEIGHT_IDLEPRIO                3
+#define WMULT_IDLEPRIO         1431655765
+
+/*
+ * Nice levels are multiplicative, with a gentle 10% change for every
+ * nice level changed. I.e. when a CPU-bound task goes from nice 0 to
+ * nice 1, it will get ~10% less CPU time than another CPU-bound task
+ * that remained on nice 0.
+ *
+ * The "10% effect" is relative and cumulative: from _any_ nice level,
+ * if you go up 1 level, it's -10% CPU usage, if you go down 1 level
+ * it's +10% CPU usage. (to achieve that we use a multiplier of 1.25.
+ * If a task goes up by ~10% and another task goes down by ~10% then
+ * the relative distance between them is ~25%.)
+ */
+static const int prio_to_weight[40] = {
+ /* -20 */     88761,     71755,     56483,     46273,     36291,
+ /* -15 */     29154,     23254,     18705,     14949,     11916,
+ /* -10 */      9548,      7620,      6100,      4904,      3906,
+ /*  -5 */      3121,      2501,      1991,      1586,      1277,
+ /*   0 */      1024,       820,       655,       526,       423,
+ /*   5 */       335,       272,       215,       172,       137,
+ /*  10 */       110,        87,        70,        56,        45,
+ /*  15 */        36,        29,        23,        18,        15,
+};
+
+/*
+ * Inverse (2^32/x) values of the prio_to_weight[] array, precalculated.
+ *
+ * In cases where the weight does not change often, we can use the
+ * precalculated inverse to speed up arithmetics by turning divisions
+ * into multiplications:
+ */
+static const u32 prio_to_wmult[40] = {
+ /* -20 */     48388,     59856,     76040,     92818,    118348,
+ /* -15 */    147320,    184698,    229616,    287308,    360437,
+ /* -10 */    449829,    563644,    704093,    875809,   1099582,
+ /*  -5 */   1376151,   1717300,   2157191,   2708050,   3363326,
+ /*   0 */   4194304,   5237765,   6557202,   8165337,  10153587,
+ /*   5 */  12820798,  15790321,  19976592,  24970740,  31350126,
+ /*  10 */  39045157,  49367440,  61356676,  76695844,  95443717,
+ /*  15 */ 119304647, 148102320, 186737708, 238609294, 286331153,
+};
+
+/* Time spent by the tasks of the cpu accounting group executing in ... */
+enum cpuacct_stat_index {
+	CPUACCT_STAT_USER,	/* ... user mode */
+	CPUACCT_STAT_SYSTEM,	/* ... kernel mode */
+
+	CPUACCT_STAT_NSTATS,
+};
+
+
+#define sched_class_highest (&stop_sched_class)
+#define for_each_class(class) \
+   for (class = sched_class_highest; class; class = class->next)
+
+extern const struct sched_class stop_sched_class;
+extern const struct sched_class rt_sched_class;
+extern const struct sched_class fair_sched_class;
+extern const struct sched_class idle_sched_class;
+
+
+#ifdef CONFIG_SMP
+
+extern void trigger_load_balance(struct rq *rq, int cpu);
+extern void idle_balance(int this_cpu, struct rq *this_rq);
+
+#else	/* CONFIG_SMP */
+
+static inline void idle_balance(int cpu, struct rq *rq)
+{
+}
+
+#endif
+
+extern void sysrq_sched_debug_show(void);
+extern void sched_init_granularity(void);
+extern void update_max_interval(void);
+extern void update_group_power(struct sched_domain *sd, int cpu);
+extern int update_runtime(struct notifier_block *nfb, unsigned long action, void *hcpu);
+extern void init_sched_rt_class(void);
+extern void init_sched_fair_class(void);
+
+extern void resched_task(struct task_struct *p);
+extern void resched_cpu(int cpu);
+
+extern struct rt_bandwidth def_rt_bandwidth;
+extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime);
+
+extern void update_cpu_load(struct rq *this_rq);
+
+#ifdef CONFIG_CGROUP_CPUACCT
+#include <linux/cgroup.h>
+/* track cpu usage of a group of tasks and its child groups */
+struct cpuacct {
+	struct cgroup_subsys_state css;
+	/* cpuusage holds pointer to a u64-type object on every cpu */
+	u64 __percpu *cpuusage;
+	struct kernel_cpustat __percpu *cpustat;
+};
+
+/* return cpu accounting group corresponding to this container */
+static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
+{
+	return container_of(cgroup_subsys_state(cgrp, cpuacct_subsys_id),
+			    struct cpuacct, css);
+}
+
+/* return cpu accounting group to which this task belongs */
+static inline struct cpuacct *task_ca(struct task_struct *tsk)
+{
+	return container_of(task_subsys_state(tsk, cpuacct_subsys_id),
+			    struct cpuacct, css);
+}
+
+static inline struct cpuacct *parent_ca(struct cpuacct *ca)
+{
+	if (!ca || !ca->css.cgroup->parent)
+		return NULL;
+	return cgroup_ca(ca->css.cgroup->parent);
+}
+
+extern void cpuacct_charge(struct task_struct *tsk, u64 cputime);
+#else
+static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
+#endif
+
+static inline void inc_nr_running(struct rq *rq)
+{
+	rq->nr_running++;
+}
+
+static inline void dec_nr_running(struct rq *rq)
+{
+	rq->nr_running--;
+}
+
+extern void update_rq_clock(struct rq *rq);
+
+extern void activate_task(struct rq *rq, struct task_struct *p, int flags);
+extern void deactivate_task(struct rq *rq, struct task_struct *p, int flags);
+
+extern void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags);
+
+extern const_debug unsigned int sysctl_sched_time_avg;
+extern const_debug unsigned int sysctl_sched_nr_migrate;
+extern const_debug unsigned int sysctl_sched_migration_cost;
+
+static inline u64 sched_avg_period(void)
+{
+	return (u64)sysctl_sched_time_avg * NSEC_PER_MSEC / 2;
+}
+
+void calc_load_account_idle(struct rq *this_rq);
+
+#ifdef CONFIG_SCHED_HRTICK
+
+/*
+ * Use hrtick when:
+ *  - enabled by features
+ *  - hrtimer is actually high res
+ */
+static inline int hrtick_enabled(struct rq *rq)
+{
+	if (!sched_feat(HRTICK))
+		return 0;
+	if (!cpu_active(cpu_of(rq)))
+		return 0;
+	return hrtimer_is_hres_active(&rq->hrtick_timer);
+}
+
+void hrtick_start(struct rq *rq, u64 delay);
+
+#else
+
+static inline int hrtick_enabled(struct rq *rq)
+{
+	return 0;
+}
+
+#endif /* CONFIG_SCHED_HRTICK */
+
+#ifdef CONFIG_SMP
+extern void sched_avg_update(struct rq *rq);
+static inline void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
+{
+	rq->rt_avg += rt_delta;
+	sched_avg_update(rq);
+}
+#else
+static inline void sched_rt_avg_update(struct rq *rq, u64 rt_delta) { }
+static inline void sched_avg_update(struct rq *rq) { }
+#endif
+
+extern void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period);
+
+#ifdef CONFIG_SMP
+#ifdef CONFIG_PREEMPT
+
+static inline void double_rq_lock(struct rq *rq1, struct rq *rq2);
+
+/*
+ * fair double_lock_balance: Safely acquires both rq->locks in a fair
+ * way at the expense of forcing extra atomic operations in all
+ * invocations.  This assures that the double_lock is acquired using the
+ * same underlying policy as the spinlock_t on this architecture, which
+ * reduces latency compared to the unfair variant below.  However, it
+ * also adds more overhead and therefore may reduce throughput.
+ */
+static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
+	__releases(this_rq->lock)
+	__acquires(busiest->lock)
+	__acquires(this_rq->lock)
+{
+	raw_spin_unlock(&this_rq->lock);
+	double_rq_lock(this_rq, busiest);
+
+	return 1;
+}
+
+#else
+/*
+ * Unfair double_lock_balance: Optimizes throughput at the expense of
+ * latency by eliminating extra atomic operations when the locks are
+ * already in proper order on entry.  This favors lower cpu-ids and will
+ * grant the double lock to lower cpus over higher ids under contention,
+ * regardless of entry order into the function.
+ */
+static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
+	__releases(this_rq->lock)
+	__acquires(busiest->lock)
+	__acquires(this_rq->lock)
+{
+	int ret = 0;
+
+	if (unlikely(!raw_spin_trylock(&busiest->lock))) {
+		if (busiest < this_rq) {
+			raw_spin_unlock(&this_rq->lock);
+			raw_spin_lock(&busiest->lock);
+			raw_spin_lock_nested(&this_rq->lock,
+					      SINGLE_DEPTH_NESTING);
+			ret = 1;
+		} else
+			raw_spin_lock_nested(&busiest->lock,
+					      SINGLE_DEPTH_NESTING);
+	}
+	return ret;
+}
+
+#endif /* CONFIG_PREEMPT */
+
+/*
+ * double_lock_balance - lock the busiest runqueue, this_rq is locked already.
+ */
+static inline int double_lock_balance(struct rq *this_rq, struct rq *busiest)
+{
+	if (unlikely(!irqs_disabled())) {
+		/* printk() doesn't work good under rq->lock */
+		raw_spin_unlock(&this_rq->lock);
+		BUG_ON(1);
+	}
+
+	return _double_lock_balance(this_rq, busiest);
+}
+
+static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
+	__releases(busiest->lock)
+{
+	raw_spin_unlock(&busiest->lock);
+	lock_set_subclass(&this_rq->lock.dep_map, 0, _RET_IP_);
+}
+
+/*
+ * double_rq_lock - safely lock two runqueues
+ *
+ * Note this does not disable interrupts like task_rq_lock,
+ * you need to do so manually before calling.
+ */
+static inline void double_rq_lock(struct rq *rq1, struct rq *rq2)
+	__acquires(rq1->lock)
+	__acquires(rq2->lock)
+{
+	BUG_ON(!irqs_disabled());
+	if (rq1 == rq2) {
+		raw_spin_lock(&rq1->lock);
+		__acquire(rq2->lock);	/* Fake it out ;) */
+	} else {
+		if (rq1 < rq2) {
+			raw_spin_lock(&rq1->lock);
+			raw_spin_lock_nested(&rq2->lock, SINGLE_DEPTH_NESTING);
+		} else {
+			raw_spin_lock(&rq2->lock);
+			raw_spin_lock_nested(&rq1->lock, SINGLE_DEPTH_NESTING);
+		}
+	}
+}
+
+/*
+ * double_rq_unlock - safely unlock two runqueues
+ *
+ * Note this does not restore interrupts like task_rq_unlock,
+ * you need to do so manually after calling.
+ */
+static inline void double_rq_unlock(struct rq *rq1, struct rq *rq2)
+	__releases(rq1->lock)
+	__releases(rq2->lock)
+{
+	raw_spin_unlock(&rq1->lock);
+	if (rq1 != rq2)
+		raw_spin_unlock(&rq2->lock);
+	else
+		__release(rq2->lock);
+}
+
+#else /* CONFIG_SMP */
+
+/*
+ * double_rq_lock - safely lock two runqueues
+ *
+ * Note this does not disable interrupts like task_rq_lock,
+ * you need to do so manually before calling.
+ */
+static inline void double_rq_lock(struct rq *rq1, struct rq *rq2)
+	__acquires(rq1->lock)
+	__acquires(rq2->lock)
+{
+	BUG_ON(!irqs_disabled());
+	BUG_ON(rq1 != rq2);
+	raw_spin_lock(&rq1->lock);
+	__acquire(rq2->lock);	/* Fake it out ;) */
+}
+
+/*
+ * double_rq_unlock - safely unlock two runqueues
+ *
+ * Note this does not restore interrupts like task_rq_unlock,
+ * you need to do so manually after calling.
+ */
+static inline void double_rq_unlock(struct rq *rq1, struct rq *rq2)
+	__releases(rq1->lock)
+	__releases(rq2->lock)
+{
+	BUG_ON(rq1 != rq2);
+	raw_spin_unlock(&rq1->lock);
+	__release(rq2->lock);
+}
+
+#endif
+
+extern struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq);
+extern struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq);
+extern void print_cfs_stats(struct seq_file *m, int cpu);
+extern void print_rt_stats(struct seq_file *m, int cpu);
+
+extern void init_cfs_rq(struct cfs_rq *cfs_rq);
+extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
+extern void unthrottle_offline_cfs_rqs(struct rq *rq);
+
+extern void account_cfs_bandwidth_used(int enabled, int was_enabled);
+
+#ifdef CONFIG_NO_HZ
+enum rq_nohz_flag_bits {
+	NOHZ_TICK_STOPPED,
+	NOHZ_BALANCE_KICK,
+	NOHZ_IDLE,
+};
+
+#define nohz_flags(cpu)	(&cpu_rq(cpu)->nohz_flags)
+#endif
diff --git a/kernel/sched/stats.c b/kernel/sched/stats.c
new file mode 100644
index 0000000..2a581ba
--- /dev/null
+++ b/kernel/sched/stats.c
@@ -0,0 +1,111 @@
+
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/seq_file.h>
+#include <linux/proc_fs.h>
+
+#include "sched.h"
+
+/*
+ * bump this up when changing the output format or the meaning of an existing
+ * format, so that tools can adapt (or abort)
+ */
+#define SCHEDSTAT_VERSION 15
+
+static int show_schedstat(struct seq_file *seq, void *v)
+{
+	int cpu;
+	int mask_len = DIV_ROUND_UP(NR_CPUS, 32) * 9;
+	char *mask_str = kmalloc(mask_len, GFP_KERNEL);
+
+	if (mask_str == NULL)
+		return -ENOMEM;
+
+	seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
+	seq_printf(seq, "timestamp %lu\n", jiffies);
+	for_each_online_cpu(cpu) {
+		struct rq *rq = cpu_rq(cpu);
+#ifdef CONFIG_SMP
+		struct sched_domain *sd;
+		int dcount = 0;
+#endif
+
+		/* runqueue-specific stats */
+		seq_printf(seq,
+		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
+		    cpu, rq->yld_count,
+		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
+		    rq->ttwu_count, rq->ttwu_local,
+		    rq->rq_cpu_time,
+		    rq->rq_sched_info.run_delay, rq->rq_sched_info.pcount);
+
+		seq_printf(seq, "\n");
+
+#ifdef CONFIG_SMP
+		/* domain-specific stats */
+		rcu_read_lock();
+		for_each_domain(cpu, sd) {
+			enum cpu_idle_type itype;
+
+			cpumask_scnprintf(mask_str, mask_len,
+					  sched_domain_span(sd));
+			seq_printf(seq, "domain%d %s", dcount++, mask_str);
+			for (itype = CPU_IDLE; itype < CPU_MAX_IDLE_TYPES;
+					itype++) {
+				seq_printf(seq, " %u %u %u %u %u %u %u %u",
+				    sd->lb_count[itype],
+				    sd->lb_balanced[itype],
+				    sd->lb_failed[itype],
+				    sd->lb_imbalance[itype],
+				    sd->lb_gained[itype],
+				    sd->lb_hot_gained[itype],
+				    sd->lb_nobusyq[itype],
+				    sd->lb_nobusyg[itype]);
+			}
+			seq_printf(seq,
+				   " %u %u %u %u %u %u %u %u %u %u %u %u\n",
+			    sd->alb_count, sd->alb_failed, sd->alb_pushed,
+			    sd->sbe_count, sd->sbe_balanced, sd->sbe_pushed,
+			    sd->sbf_count, sd->sbf_balanced, sd->sbf_pushed,
+			    sd->ttwu_wake_remote, sd->ttwu_move_affine,
+			    sd->ttwu_move_balance);
+		}
+		rcu_read_unlock();
+#endif
+	}
+	kfree(mask_str);
+	return 0;
+}
+
+static int schedstat_open(struct inode *inode, struct file *file)
+{
+	unsigned int size = PAGE_SIZE * (1 + num_online_cpus() / 32);
+	char *buf = kmalloc(size, GFP_KERNEL);
+	struct seq_file *m;
+	int res;
+
+	if (!buf)
+		return -ENOMEM;
+	res = single_open(file, show_schedstat, NULL);
+	if (!res) {
+		m = file->private_data;
+		m->buf = buf;
+		m->size = size;
+	} else
+		kfree(buf);
+	return res;
+}
+
+static const struct file_operations proc_schedstat_operations = {
+	.open    = schedstat_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = single_release,
+};
+
+static int __init proc_schedstat_init(void)
+{
+	proc_create("schedstat", 0, NULL, &proc_schedstat_operations);
+	return 0;
+}
+module_init(proc_schedstat_init);
diff --git a/kernel/sched_stats.h b/kernel/sched/stats.h
similarity index 70%
rename from kernel/sched_stats.h
rename to kernel/sched/stats.h
index 87f9e36..2ef90a5 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched/stats.h
@@ -1,108 +1,5 @@
 
 #ifdef CONFIG_SCHEDSTATS
-/*
- * bump this up when changing the output format or the meaning of an existing
- * format, so that tools can adapt (or abort)
- */
-#define SCHEDSTAT_VERSION 15
-
-static int show_schedstat(struct seq_file *seq, void *v)
-{
-	int cpu;
-	int mask_len = DIV_ROUND_UP(NR_CPUS, 32) * 9;
-	char *mask_str = kmalloc(mask_len, GFP_KERNEL);
-
-	if (mask_str == NULL)
-		return -ENOMEM;
-
-	seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
-	seq_printf(seq, "timestamp %lu\n", jiffies);
-	for_each_online_cpu(cpu) {
-		struct rq *rq = cpu_rq(cpu);
-#ifdef CONFIG_SMP
-		struct sched_domain *sd;
-		int dcount = 0;
-#endif
-
-		/* runqueue-specific stats */
-		seq_printf(seq,
-		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
-		    cpu, rq->yld_count,
-		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
-		    rq->ttwu_count, rq->ttwu_local,
-		    rq->rq_cpu_time,
-		    rq->rq_sched_info.run_delay, rq->rq_sched_info.pcount);
-
-		seq_printf(seq, "\n");
-
-#ifdef CONFIG_SMP
-		/* domain-specific stats */
-		rcu_read_lock();
-		for_each_domain(cpu, sd) {
-			enum cpu_idle_type itype;
-
-			cpumask_scnprintf(mask_str, mask_len,
-					  sched_domain_span(sd));
-			seq_printf(seq, "domain%d %s", dcount++, mask_str);
-			for (itype = CPU_IDLE; itype < CPU_MAX_IDLE_TYPES;
-					itype++) {
-				seq_printf(seq, " %u %u %u %u %u %u %u %u",
-				    sd->lb_count[itype],
-				    sd->lb_balanced[itype],
-				    sd->lb_failed[itype],
-				    sd->lb_imbalance[itype],
-				    sd->lb_gained[itype],
-				    sd->lb_hot_gained[itype],
-				    sd->lb_nobusyq[itype],
-				    sd->lb_nobusyg[itype]);
-			}
-			seq_printf(seq,
-				   " %u %u %u %u %u %u %u %u %u %u %u %u\n",
-			    sd->alb_count, sd->alb_failed, sd->alb_pushed,
-			    sd->sbe_count, sd->sbe_balanced, sd->sbe_pushed,
-			    sd->sbf_count, sd->sbf_balanced, sd->sbf_pushed,
-			    sd->ttwu_wake_remote, sd->ttwu_move_affine,
-			    sd->ttwu_move_balance);
-		}
-		rcu_read_unlock();
-#endif
-	}
-	kfree(mask_str);
-	return 0;
-}
-
-static int schedstat_open(struct inode *inode, struct file *file)
-{
-	unsigned int size = PAGE_SIZE * (1 + num_online_cpus() / 32);
-	char *buf = kmalloc(size, GFP_KERNEL);
-	struct seq_file *m;
-	int res;
-
-	if (!buf)
-		return -ENOMEM;
-	res = single_open(file, show_schedstat, NULL);
-	if (!res) {
-		m = file->private_data;
-		m->buf = buf;
-		m->size = size;
-	} else
-		kfree(buf);
-	return res;
-}
-
-static const struct file_operations proc_schedstat_operations = {
-	.open    = schedstat_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = single_release,
-};
-
-static int __init proc_schedstat_init(void)
-{
-	proc_create("schedstat", 0, NULL, &proc_schedstat_operations);
-	return 0;
-}
-module_init(proc_schedstat_init);
 
 /*
  * Expects runqueue lock to be held for atomicity of update
@@ -283,8 +180,7 @@ static inline void account_group_user_time(struct task_struct *tsk,
 		return;
 
 	raw_spin_lock(&cputimer->lock);
-	cputimer->cputime.utime =
-		cputime_add(cputimer->cputime.utime, cputime);
+	cputimer->cputime.utime += cputime;
 	raw_spin_unlock(&cputimer->lock);
 }
 
@@ -307,8 +203,7 @@ static inline void account_group_system_time(struct task_struct *tsk,
 		return;
 
 	raw_spin_lock(&cputimer->lock);
-	cputimer->cputime.stime =
-		cputime_add(cputimer->cputime.stime, cputime);
+	cputimer->cputime.stime += cputime;
 	raw_spin_unlock(&cputimer->lock);
 }
 
diff --git a/kernel/sched_stoptask.c b/kernel/sched/stop_task.c
similarity index 97%
rename from kernel/sched_stoptask.c
rename to kernel/sched/stop_task.c
index 8b44e7f..7b386e8 100644
--- a/kernel/sched_stoptask.c
+++ b/kernel/sched/stop_task.c
@@ -1,3 +1,5 @@
+#include "sched.h"
+
 /*
  * stop-task scheduling class.
  *
@@ -80,7 +82,7 @@ get_rr_interval_stop(struct rq *rq, struct task_struct *task)
 /*
  * Simple, special scheduling class for the per-CPU stop tasks:
  */
-static const struct sched_class stop_sched_class = {
+const struct sched_class stop_sched_class = {
 	.next			= &rt_sched_class,
 
 	.enqueue_task		= enqueue_task_stop,
diff --git a/kernel/signal.c b/kernel/signal.c
index b3f78d0..739ef2b 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1629,10 +1629,8 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	info.si_uid = __task_cred(tsk)->uid;
 	rcu_read_unlock();
 
-	info.si_utime = cputime_to_clock_t(cputime_add(tsk->utime,
-				tsk->signal->utime));
-	info.si_stime = cputime_to_clock_t(cputime_add(tsk->stime,
-				tsk->signal->stime));
+	info.si_utime = cputime_to_clock_t(tsk->utime + tsk->signal->utime);
+	info.si_stime = cputime_to_clock_t(tsk->stime + tsk->signal->stime);
 
 	info.si_status = tsk->exit_code & 0x7f;
 	if (tsk->exit_code & 0x80)
diff --git a/kernel/sys.c b/kernel/sys.c
index 481611f..ddf8155 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1605,7 +1605,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 	unsigned long maxrss = 0;
 
 	memset((char *) r, 0, sizeof *r);
-	utime = stime = cputime_zero;
+	utime = stime = 0;
 
 	if (who == RUSAGE_THREAD) {
 		task_times(current, &utime, &stime);
@@ -1635,8 +1635,8 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 
 		case RUSAGE_SELF:
 			thread_group_times(p, &tgutime, &tgstime);
-			utime = cputime_add(utime, tgutime);
-			stime = cputime_add(stime, tgstime);
+			utime += tgutime;
+			stime += tgstime;
 			r->ru_nvcsw += p->signal->nvcsw;
 			r->ru_nivcsw += p->signal->nivcsw;
 			r->ru_minflt += p->signal->min_flt;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 4042064..31cc061 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -297,6 +297,15 @@ void tick_nohz_stop_sched_tick(int inidle)
 	ts = &per_cpu(tick_cpu_sched, cpu);
 
 	/*
+ 	 * Update the idle state in the scheduler domain hierarchy
+ 	 * when tick_nohz_stop_sched_tick() is called from the idle loop.
+ 	 * State will be updated to busy during the first busy tick after
+ 	 * exiting idle.
+ 	 */
+	if (inidle)
+		set_cpu_sd_state_idle();
+
+	/*
 	 * Call to tick_nohz_start_idle stops the last_update_time from being
 	 * updated. Thus, it must not be called in the event we are called from
 	 * irq_exit() with the prior state different than idle.
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 5bbfac8..23b4d78 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -127,7 +127,7 @@ void acct_update_integrals(struct task_struct *tsk)
 
 		local_irq_save(flags);
 		time = tsk->stime + tsk->utime;
-		dtime = cputime_sub(time, tsk->acct_timexpd);
+		dtime = time - tsk->acct_timexpd;
 		jiffies_to_timeval(cputime_to_jiffies(dtime), &value);
 		delta = value.tv_sec;
 		delta = delta * USEC_PER_SEC + value.tv_usec;
