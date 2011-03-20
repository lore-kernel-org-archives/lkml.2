Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab1CTXai (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 19:30:38 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59586 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1CTXag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 19:30:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=wXDLPEV8+yVA5R0dgwszXNFYuRfN9RYT843ZNLU3WXtZwedJOD2cbfId5B3KefmgYj
         9o5BCHWseVq88ATxXy9oKTm8a5j3aLLQU0xOOdN8T4O8dwJxVZjQWf6oM+ERSH6oZSfm
         AeQ4GPfcQlS5CziYDl86SapK6FbQwMFfcpVs4=
MIME-Version: 1.0
From: Rafael Fernandez <rafaelefernandez@gmail.com>
Date: Sun, 20 Mar 2011 18:30:15 -0500
Message-ID: <AANLkTi=06qycG-o7vsT18ebDXxR3M37bFK=kVK=Hp5ox@mail.gmail.com>
Subject: [PATCH] tip: Fix code styling issues in kernel/timer.c and kernel/time/*
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed code styling issues as reported by checkpatch.pl.

Rafael

>From 69e1b961970adfb14927a71017c8b136dcafbac4 Mon Sep 17 00:00:00 2001
From: Rafael Fernandez <rafaelefernandez@gmail.com>
Date: Sun, 20 Mar 2011 17:05:54 -0400
Subject: [PATCH] Code style issues fixed.

---
 kernel/time/clocksource.c |   10 +++++-----
 kernel/time/timekeeping.c |   10 ++++------
 kernel/time/timer_stats.c |    4 ++--
 kernel/timer.c            |   21 +++++++++++----------
 4 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 6519cf6..d453c40 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -134,7 +134,7 @@ void
 clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 maxsec)
 {
 	u64 tmp;
-	u32 sft, sftacc= 32;
+	u32 sft, sftacc = 32;

 	/*
 	 * Calculate the shift factor which is limiting the conversion
@@ -142,7 +142,7 @@ clocks_calc_mult_shift(u32 *mult, u32 *shift, u32
from, u32 to, u32 maxsec)
 	 */
 	tmp = ((u64)maxsec * from) >> 32;
 	while (tmp) {
-		tmp >>=1;
+		tmp >>= 1;
 		sftacc--;
 	}

@@ -216,7 +216,7 @@ static void __clocksource_unstable(struct clocksource *cs)

 static void clocksource_unstable(struct clocksource *cs, int64_t delta)
 {
-	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)\n",
+	printk(KERN_WARNING "Clocksource %s unstable (delta = %lld ns)\n",
 	       cs->name, delta);
 	__clocksource_unstable(cs);
 }
@@ -902,11 +902,11 @@ __setup("clocksource=", boot_override_clocksource);
 static int __init boot_override_clock(char* str)
 {
 	if (!strcmp(str, "pmtmr")) {
-		printk("Warning: clock=pmtmr is deprecated. "
+		printk(KERN_WARNING "Warning: clock=pmtmr is deprecated. "
 			"Use clocksource=acpi_pm.\n");
 		return boot_override_clocksource("acpi_pm");
 	}
-	printk("Warning! clock= boot option is deprecated. "
+	printk(KERN_WARNING "Warning! clock= boot option is deprecated. "
 		"Use clocksource=xyz\n");
 	return boot_override_clocksource(str);
 }
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 3bd7e3d..cbf07ff 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -157,8 +157,8 @@ __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
  * - wall_to_monotonic is no longer the boot time, getboottime must be
  * used instead.
  */
-static struct timespec xtime __attribute__ ((aligned (16)));
-static struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
+static struct timespec xtime __attribute__ ((aligned(16)));
+static struct timespec wall_to_monotonic __attribute__ ((aligned(16)));
 static struct timespec total_sleep_time;

 /*
@@ -234,7 +234,6 @@ void getnstimeofday(struct timespec *ts)

 	timespec_add_ns(ts, nsecs);
 }
-
 EXPORT_SYMBOL(getnstimeofday);

 ktime_t ktime_get(void)
@@ -345,8 +344,8 @@ void do_gettimeofday(struct timeval *tv)
 	tv->tv_sec = now.tv_sec;
 	tv->tv_usec = now.tv_nsec/1000;
 }
-
 EXPORT_SYMBOL(do_gettimeofday);
+
 /**
  * do_settimeofday - Sets the time of day
  * @tv:		pointer to the timespec variable containing the new time
@@ -384,7 +383,6 @@ int do_settimeofday(const struct timespec *tv)

 	return 0;
 }
-
 EXPORT_SYMBOL(do_settimeofday);


@@ -849,7 +847,7 @@ static void update_wall_time(void)
 	shift = min(shift, maxshift);
 	while (offset >= timekeeper.cycle_interval) {
 		offset = logarithmic_accumulation(offset, shift);
-		if(offset < timekeeper.cycle_interval<<shift)
+		if (offset < (timekeeper.cycle_interval << shift))
 			shift--;
 	}

diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index 2f3b585..8a52c63 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -129,7 +129,7 @@ static atomic_t overflow_count;
 	(((unsigned long)(entry)->timer       ^				\
 	  (unsigned long)(entry)->start_func  ^				\
 	  (unsigned long)(entry)->expire_func ^				\
-	  (unsigned long)(entry)->pid		) & TSTAT_HASH_MASK)
+	  (unsigned long)(entry)->pid) & TSTAT_HASH_MASK)

 #define tstat_hashentry(entry)	(tstat_hash_table + __tstat_hashfn(entry))

@@ -306,7 +306,7 @@ static int tstats_show(struct seq_file *m, void *v)

 	for (i = 0; i < nr_entries; i++) {
 		entry = entries + i;
- 		if (entry->timer_flag & TIMER_STATS_FLAG_DEFERRABLE) {
+		if (entry->timer_flag & TIMER_STATS_FLAG_DEFERRABLE) {
 			seq_printf(m, "%4luD, %5d %-16s ",
 				entry->count, entry->pid, entry->comm);
 		} else {
diff --git a/kernel/timer.c b/kernel/timer.c
index fd61986..cbbd639 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -91,12 +91,14 @@ static DEFINE_PER_CPU(struct tvec_base *,
tvec_bases) = &boot_tvec_bases;
 /* Functions below help us manage 'deferrable' flag */
 static inline unsigned int tbase_get_deferrable(struct tvec_base *base)
 {
-	return ((unsigned int)(unsigned long)base & TBASE_DEFERRABLE_FLAG);
+	return (unsigned int)((unsigned long)base &
+			      TBASE_DEFERRABLE_FLAG);
 }

 static inline struct tvec_base *tbase_get_base(struct tvec_base *base)
 {
-	return ((struct tvec_base *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG));
+	return (struct tvec_base *)((unsigned long)base &
+				    ~TBASE_DEFERRABLE_FLAG);
 }

 static inline void timer_set_deferrable(struct timer_list *timer)
@@ -1081,7 +1083,8 @@ static void call_timer_fn(struct timer_list
*timer, void (*fn)(unsigned l
ong),
 	}
 }

-#define INDEX(N) ((base->timer_jiffies >> (TVR_BITS + (N) *
TVN_BITS)) & TVN_MASK)
+#define INDEX(N) ((base->timer_jiffies >> (TVR_BITS + (N) * TVN_BITS)) \
+		  & TVN_MASK)

 /**
  * __run_timers - run all expired timers (if any) on this CPU.
@@ -1114,7 +1117,7 @@ static inline void __run_timers(struct tvec_base *base)
 			void (*fn)(unsigned long);
 			unsigned long data;

-			timer = list_first_entry(head, struct timer_list,entry);
+			timer = list_first_entry(head, struct timer_list, entry);
 			fn = timer->function;
 			data = timer->data;

@@ -1437,8 +1440,7 @@ signed long __sched schedule_timeout(signed long timeout)
 	struct timer_list timer;
 	unsigned long expire;

-	switch (timeout)
-	{
+	switch (timeout) {
 	case MAX_SCHEDULE_TIMEOUT:
 		/*
 		 * These two special cases are useful to be comfortable
@@ -1651,7 +1653,8 @@ static int __cpuinit init_timers_cpu(int cpu)
 }

 #ifdef CONFIG_HOTPLUG_CPU
-static void migrate_timer_list(struct tvec_base *new_base, struct
list_head *head)
+static void migrate_timer_list(struct tvec_base *new_base,
+			       struct list_head *head)
 {
 	struct timer_list *timer;

@@ -1705,7 +1708,7 @@ static int __cpuinit timer_cpu_notify(struct
notifier_block *self,
 	long cpu = (long)hcpu;
 	int err;

-	switch(action) {
+	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
 		err = init_timers_cpu(cpu);
@@ -1752,7 +1755,6 @@ void msleep(unsigned int msecs)
 	while (timeout)
 		timeout = schedule_timeout_uninterruptible(timeout);
 }
-
 EXPORT_SYMBOL(msleep);

 /**
@@ -1767,7 +1769,6 @@ unsigned long msleep_interruptible(unsigned int msecs)
 		timeout = schedule_timeout_interruptible(timeout);
 	return jiffies_to_msecs(timeout);
 }
-
 EXPORT_SYMBOL(msleep_interruptible);

 static int __sched do_usleep_range(unsigned long min, unsigned long max)
-- 
1.7.1
