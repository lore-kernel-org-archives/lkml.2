Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab1COUJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:09:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46930 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757474Ab1COUI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:08:59 -0400
Date: Tue, 15 Mar 2011 21:08:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer changes for v2.6.39
Message-ID: <20110315200841.GA16333@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-core-for-linus

 Thanks,

	Ingo

------------------>
John Stultz (6):
      time: Introduce timekeeping_inject_offset
      hrtimers: extend hrtimer base code to handle more then 2 clockids
      time: Introduce get_monotonic_boottime and ktime_get_boottime
      time: Extend get_xtime_and_monotonic_offset() to also return sleep
      timers: Add CLOCK_BOOTTIME hrtimer base
      timers: Export CLOCK_BOOTTIME via the posix timers interface

Richard Cochran (9):
      time: Correct the *settime* parameters
      posix-timer: Update comment
      ntp: Add ADJ_SETOFFSET mode bit
      time: Splitout compat timex accessors
      posix-timers: Introduce a syscall for clock tuning.
      x86: Add clock_adjtime for x86
      posix-timers: Add support for fd based clocks
      posix clocks: Introduce dynamic clocks
      ntp: Remove redundant and incorrect parameter check

Thomas Gleixner (26):
      time: Remove unused __get_wall_to_monotonic()
      time: Fix legacy arch fallout
      posix-timers: Define nanosleep not supported error separate
      posix-timers: Cleanup struct initializers
      posix-timers: Introduce clock_posix_cpu
      posix-timers: Introduce clockid_to_kclock()
      posix-timers: Convert clock_nanosleep to clockid_to_kclock()
      posix-timers: Convert clock_nanosleep_restart to clockid_to_kclock()
      posix-timers: Cleanup restart_block usage
      thread_info: Remove legacy arg0-3 from restart_block
      posix-cpu-timers: Remove the stub nanosleep functions
      posix-timers: Convert clock_settime to clockid_to_kclock()
      posix-timers: Convert clock_gettime() to clockid_to_kclock()
      posix-timers: Make clock_getres and clock_get mandatory
      posix-timers: Convert clock_getres() to clockid_to_kclock()
      posix-timers: Remove useless res field from k_clock
      posix-timers: Convert timer_create() to clockid_to_kclock()
      posix-timers: Convert timer_settime() to clockid_to_kclock()
      posix-timers: Convert timer_gettime() to clockid_to_kclock()
      posix-timers: Convert timer_delete() to clockid_to_kclock()
      posix-timers: Remove CLOCK_DISPATCH leftovers
      posix-timers: Make posix-cpu-timers functions static
      posix-timers: Cleanup namespace
      hrtimer: Update base[CLOCK_BOOTTIME].offset correctly
      hrtimer: Update hrtimer->state documentation
      hrtimer: Remove empty hrtimer_init_hres_timer()

Torben Hohn (21):
      time: Move do_timer() to kernel/time/timekeeping.c
      time: Move get_jiffies_64 to kernel/time/jiffies.c
      time: Provide get_xtime_and_monotonic_offset()
      time: Provide xtime_update()
      alpha: Change do_timer() to xtime_update()
      arm: Switch from do_timer() to xtime_update()
      arm/mach-clps711x: Switch do_timer() to xtime_update()
      blackfin: Switch from do_timer() to xtime_update()
      cris: arch-v10: Switch do_timer() to xtime_update()
      cris: arch-v32: Switch do_timer() to xtime_update()
      frv: Switch do_timer() to xtime_update()
      h8300: Switch do_timer() to xtime_update()
      ia64: Switch do_timer() to xtime_update()
      m32r: Switch from do_timer() to xtime_update()
      m68k: Switch do_timer() to xtime_update()
      parisc: Switch do_timer() to xtime_update()
      sparc: Switch do_timer() to xtime_update()
      xtensa: Switch do_timer() to xtime_update()
      time: Make do_timer() and xtime_lock local to kernel/time/
      mn10300: Switch do_timer() to xtimer_update()
      posix-clocks: Check write permissions in posix syscalls


 arch/alpha/kernel/time.c                   |    8 +-
 arch/arm/kernel/time.c                     |    4 +-
 arch/arm/mach-clps711x/include/mach/time.h |    2 +-
 arch/blackfin/kernel/time.c                |    6 +-
 arch/cris/arch-v10/kernel/time.c           |    4 +-
 arch/cris/arch-v32/kernel/time.c           |    6 +-
 arch/frv/kernel/time.c                     |   14 +-
 arch/h8300/kernel/time.c                   |    4 +-
 arch/h8300/kernel/timer/timer8.c           |    2 +-
 arch/ia64/kernel/time.c                    |   19 +-
 arch/ia64/xen/time.c                       |   13 +-
 arch/m32r/kernel/time.c                    |    5 +-
 arch/m68k/bvme6000/config.c                |    4 +-
 arch/m68k/kernel/time.c                    |    4 +-
 arch/m68k/mvme147/config.c                 |    4 +-
 arch/m68k/mvme16x/config.c                 |    4 +-
 arch/m68k/sun3/sun3ints.c                  |    2 +-
 arch/m68knommu/kernel/time.c               |    8 +-
 arch/mn10300/kernel/time.c                 |    6 +-
 arch/parisc/kernel/time.c                  |    7 +-
 arch/sparc/kernel/pcic.c                   |    4 +-
 arch/sparc/kernel/time_32.c                |    9 +-
 arch/x86/ia32/ia32entry.S                  |    1 +
 arch/x86/include/asm/unistd_32.h           |    3 +-
 arch/x86/include/asm/unistd_64.h           |    2 +
 arch/x86/kernel/syscall_table_32.S         |    1 +
 arch/xtensa/kernel/time.c                  |    6 +-
 drivers/char/mmtimer.c                     |   30 ++-
 include/linux/hrtimer.h                    |   24 ++-
 include/linux/posix-clock.h                |  150 +++++++++
 include/linux/posix-timers.h               |   44 ++--
 include/linux/sched.h                      |    2 +-
 include/linux/security.h                   |    9 +-
 include/linux/syscalls.h                   |    2 +
 include/linux/thread_info.h                |    3 -
 include/linux/time.h                       |   14 +-
 include/linux/timex.h                      |    3 +-
 kernel/compat.c                            |  136 ++++++---
 kernel/hrtimer.c                           |   84 +++---
 kernel/posix-cpu-timers.c                  |  110 ++++----
 kernel/posix-timers.c                      |  342 +++++++++++----------
 kernel/time.c                              |   19 +--
 kernel/time/Makefile                       |    3 +-
 kernel/time/clockevents.c                  |    1 -
 kernel/time/jiffies.c                      |   20 ++
 kernel/time/ntp.c                          |   13 +
 kernel/time/posix-clock.c                  |  451 ++++++++++++++++++++++++++++
 kernel/time/tick-broadcast.c               |    1 -
 kernel/time/tick-common.c                  |    1 -
 kernel/time/tick-internal.h                |    9 +
 kernel/time/tick-oneshot.c                 |    1 -
 kernel/time/tick-sched.c                   |    1 -
 kernel/time/timekeeping.c                  |  141 ++++++++-
 kernel/timer.c                             |   13 -
 security/commoncap.c                       |    2 +-
 security/security.c                        |    2 +-
 56 files changed, 1276 insertions(+), 507 deletions(-)
 create mode 100644 include/linux/posix-clock.h
 create mode 100644 kernel/time/posix-clock.c

diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index c1f3e7c..a58e84f 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -159,7 +159,7 @@ void read_persistent_clock(struct timespec *ts)
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 irqreturn_t timer_interrupt(int irq, void *dev)
 {
@@ -172,8 +172,6 @@ irqreturn_t timer_interrupt(int irq, void *dev)
 	profile_tick(CPU_PROFILING);
 #endif
 
-	write_seqlock(&xtime_lock);
-
 	/*
 	 * Calculate how many ticks have passed since the last update,
 	 * including any previous partial leftover.  Save any resulting
@@ -187,9 +185,7 @@ irqreturn_t timer_interrupt(int irq, void *dev)
 	nticks = delta >> FIX_SHIFT;
 
 	if (nticks)
-		do_timer(nticks);
-
-	write_sequnlock(&xtime_lock);
+		xtime_update(nticks);
 
 	if (test_irq_work_pending()) {
 		clear_irq_work_pending();
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index 3d76bf2..1ff46ca 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -107,9 +107,7 @@ void timer_tick(void)
 {
 	profile_tick(CPU_PROFILING);
 	do_leds();
-	write_seqlock(&xtime_lock);
-	do_timer(1);
-	write_sequnlock(&xtime_lock);
+	xtime_update(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
diff --git a/arch/arm/mach-clps711x/include/mach/time.h b/arch/arm/mach-clps711x/include/mach/time.h
index 8fe283c..61fef91 100644
--- a/arch/arm/mach-clps711x/include/mach/time.h
+++ b/arch/arm/mach-clps711x/include/mach/time.h
@@ -30,7 +30,7 @@ p720t_timer_interrupt(int irq, void *dev_id)
 {
 	struct pt_regs *regs = get_irq_regs();
 	do_leds();
-	do_timer(1);
+	xtime_update(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(regs));
 #endif
diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
index c911361..8d73724 100644
--- a/arch/blackfin/kernel/time.c
+++ b/arch/blackfin/kernel/time.c
@@ -114,16 +114,14 @@ u32 arch_gettimeoffset(void)
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 #ifdef CONFIG_CORE_TIMER_IRQ_L1
 __attribute__((l1_text))
 #endif
 irqreturn_t timer_interrupt(int irq, void *dummy)
 {
-	write_seqlock(&xtime_lock);
-	do_timer(1);
-	write_sequnlock(&xtime_lock);
+	xtime_update(1);
 
 #ifdef CONFIG_IPIPE
 	update_root_process_times(get_irq_regs());
diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
index 00eb36f..20c85b5 100644
--- a/arch/cris/arch-v10/kernel/time.c
+++ b/arch/cris/arch-v10/kernel/time.c
@@ -140,7 +140,7 @@ stop_watchdog(void)
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 
 //static unsigned short myjiff; /* used by our debug routine print_timestamp */
@@ -176,7 +176,7 @@ timer_interrupt(int irq, void *dev_id)
 
 	/* call the real timer interrupt handler */
 
-	do_timer(1);
+	xtime_update(1);
 	
         cris_do_profile(regs); /* Save profiling information */
         return IRQ_HANDLED;
diff --git a/arch/cris/arch-v32/kernel/time.c b/arch/cris/arch-v32/kernel/time.c
index a545211..bb978ed 100644
--- a/arch/cris/arch-v32/kernel/time.c
+++ b/arch/cris/arch-v32/kernel/time.c
@@ -183,7 +183,7 @@ void handle_watchdog_bite(struct pt_regs *regs)
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick.
+ * as well as call the "xtime_update()" routine every clocktick.
  */
 extern void cris_do_profile(struct pt_regs *regs);
 
@@ -216,9 +216,7 @@ static inline irqreturn_t timer_interrupt(int irq, void *dev_id)
 		return IRQ_HANDLED;
 
 	/* Call the real timer interrupt handler */
-	write_seqlock(&xtime_lock);
-	do_timer(1);
-	write_sequnlock(&xtime_lock);
+	xtime_update(1);
         return IRQ_HANDLED;
 }
 
diff --git a/arch/frv/kernel/time.c b/arch/frv/kernel/time.c
index 0ddbbae..b457de4 100644
--- a/arch/frv/kernel/time.c
+++ b/arch/frv/kernel/time.c
@@ -50,21 +50,13 @@ static struct irqaction timer_irq  = {
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 static irqreturn_t timer_interrupt(int irq, void *dummy)
 {
 	profile_tick(CPU_PROFILING);
-	/*
-	 * Here we are in the timer irq handler. We just have irqs locally
-	 * disabled but we don't know if the timer_bh is running on the other
-	 * CPU. We need to avoid to SMP race with it. NOTE: we don't need
-	 * the irq version of write_lock because as just said we have irq
-	 * locally disabled. -arca
-	 */
-	write_seqlock(&xtime_lock);
 
-	do_timer(1);
+	xtime_update(1);
 
 #ifdef CONFIG_HEARTBEAT
 	static unsigned short n;
@@ -72,8 +64,6 @@ static irqreturn_t timer_interrupt(int irq, void *dummy)
 	__set_LEDS(n);
 #endif /* CONFIG_HEARTBEAT */
 
-	write_sequnlock(&xtime_lock);
-
 	update_process_times(user_mode(get_irq_regs()));
 
 	return IRQ_HANDLED;
diff --git a/arch/h8300/kernel/time.c b/arch/h8300/kernel/time.c
index 165005a..32263a1 100644
--- a/arch/h8300/kernel/time.c
+++ b/arch/h8300/kernel/time.c
@@ -35,9 +35,7 @@ void h8300_timer_tick(void)
 {
 	if (current->pid)
 		profile_tick(CPU_PROFILING);
-	write_seqlock(&xtime_lock);
-	do_timer(1);
-	write_sequnlock(&xtime_lock);
+	xtime_update(1);
 	update_process_times(user_mode(get_irq_regs()));
 }
 
diff --git a/arch/h8300/kernel/timer/timer8.c b/arch/h8300/kernel/timer/timer8.c
index 3946c0f..7a1533f 100644
--- a/arch/h8300/kernel/timer/timer8.c
+++ b/arch/h8300/kernel/timer/timer8.c
@@ -61,7 +61,7 @@
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 
 static irqreturn_t timer_interrupt(int irq, void *dev_id)
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 9702fa9..156ad80 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -190,19 +190,10 @@ timer_interrupt (int irq, void *dev_id)
 
 		new_itm += local_cpu_data->itm_delta;
 
-		if (smp_processor_id() == time_keeper_id) {
-			/*
-			 * Here we are in the timer irq handler. We have irqs locally
-			 * disabled, but we don't know if the timer_bh is running on
-			 * another CPU. We need to avoid to SMP race by acquiring the
-			 * xtime_lock.
-			 */
-			write_seqlock(&xtime_lock);
-			do_timer(1);
-			local_cpu_data->itm_next = new_itm;
-			write_sequnlock(&xtime_lock);
-		} else
-			local_cpu_data->itm_next = new_itm;
+		if (smp_processor_id() == time_keeper_id)
+			xtime_update(1);
+
+		local_cpu_data->itm_next = new_itm;
 
 		if (time_after(new_itm, ia64_get_itc()))
 			break;
@@ -222,7 +213,7 @@ skip_process_time_accounting:
 		 * comfort, we increase the safety margin by
 		 * intentionally dropping the next tick(s).  We do NOT
 		 * update itm.next because that would force us to call
-		 * do_timer() which in turn would let our clock run
+		 * xtime_update() which in turn would let our clock run
 		 * too fast (with the potentially devastating effect
 		 * of losing monotony of time).
 		 */
diff --git a/arch/ia64/xen/time.c b/arch/ia64/xen/time.c
index c1c5445..1f8244a 100644
--- a/arch/ia64/xen/time.c
+++ b/arch/ia64/xen/time.c
@@ -139,14 +139,11 @@ consider_steal_time(unsigned long new_itm)
 		run_posix_cpu_timers(p);
 		delta_itm += local_cpu_data->itm_delta * (stolen + blocked);
 
-		if (cpu == time_keeper_id) {
-			write_seqlock(&xtime_lock);
-			do_timer(stolen + blocked);
-			local_cpu_data->itm_next = delta_itm + new_itm;
-			write_sequnlock(&xtime_lock);
-		} else {
-			local_cpu_data->itm_next = delta_itm + new_itm;
-		}
+		if (cpu == time_keeper_id)
+			xtime_update(stolen + blocked);
+
+		local_cpu_data->itm_next = delta_itm + new_itm;
+
 		per_cpu(xen_stolen_time, cpu) += NS_PER_TICK * stolen;
 		per_cpu(xen_blocked_time, cpu) += NS_PER_TICK * blocked;
 	}
diff --git a/arch/m32r/kernel/time.c b/arch/m32r/kernel/time.c
index bda8682..84dd040 100644
--- a/arch/m32r/kernel/time.c
+++ b/arch/m32r/kernel/time.c
@@ -107,15 +107,14 @@ u32 arch_gettimeoffset(void)
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
 #ifndef CONFIG_SMP
 	profile_tick(CPU_PROFILING);
 #endif
-	/* XXX FIXME. Uh, the xtime_lock should be held here, no? */
-	do_timer(1);
+	xtime_update(1);
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
diff --git a/arch/m68k/bvme6000/config.c b/arch/m68k/bvme6000/config.c
index 9fe6fef..1edd950 100644
--- a/arch/m68k/bvme6000/config.c
+++ b/arch/m68k/bvme6000/config.c
@@ -45,8 +45,8 @@ extern int bvme6000_set_clock_mmss (unsigned long);
 extern void bvme6000_reset (void);
 void bvme6000_set_vectors (void);
 
-/* Save tick handler routine pointer, will point to do_timer() in
- * kernel/sched.c, called via bvme6000_process_int() */
+/* Save tick handler routine pointer, will point to xtime_update() in
+ * kernel/timer/timekeeping.c, called via bvme6000_process_int() */
 
 static irq_handler_t tick_handler;
 
diff --git a/arch/m68k/kernel/time.c b/arch/m68k/kernel/time.c
index 06438da..18b34ee 100644
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -37,11 +37,11 @@ static inline int set_rtc_mmss(unsigned long nowtime)
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 static irqreturn_t timer_interrupt(int irq, void *dummy)
 {
-	do_timer(1);
+	xtime_update(1);
 	update_process_times(user_mode(get_irq_regs()));
 	profile_tick(CPU_PROFILING);
 
diff --git a/arch/m68k/mvme147/config.c b/arch/m68k/mvme147/config.c
index 100baaa..6cb9c3a 100644
--- a/arch/m68k/mvme147/config.c
+++ b/arch/m68k/mvme147/config.c
@@ -46,8 +46,8 @@ extern void mvme147_reset (void);
 
 static int bcd2int (unsigned char b);
 
-/* Save tick handler routine pointer, will point to do_timer() in
- * kernel/sched.c, called via mvme147_process_int() */
+/* Save tick handler routine pointer, will point to xtime_update() in
+ * kernel/time/timekeeping.c, called via mvme147_process_int() */
 
 irq_handler_t tick_handler;
 
diff --git a/arch/m68k/mvme16x/config.c b/arch/m68k/mvme16x/config.c
index 11edf61..0b28e26 100644
--- a/arch/m68k/mvme16x/config.c
+++ b/arch/m68k/mvme16x/config.c
@@ -51,8 +51,8 @@ extern void mvme16x_reset (void);
 
 int bcd2int (unsigned char b);
 
-/* Save tick handler routine pointer, will point to do_timer() in
- * kernel/sched.c, called via mvme16x_process_int() */
+/* Save tick handler routine pointer, will point to xtime_update() in
+ * kernel/time/timekeeping.c, called via mvme16x_process_int() */
 
 static irq_handler_t tick_handler;
 
diff --git a/arch/m68k/sun3/sun3ints.c b/arch/m68k/sun3/sun3ints.c
index 2d9e21b..6464ad3 100644
--- a/arch/m68k/sun3/sun3ints.c
+++ b/arch/m68k/sun3/sun3ints.c
@@ -66,7 +66,7 @@ static irqreturn_t sun3_int5(int irq, void *dev_id)
 #ifdef CONFIG_SUN3
 	intersil_clear();
 #endif
-        do_timer(1);
+	xtime_update(1);
 	update_process_times(user_mode(get_irq_regs()));
         if (!(kstat_cpu(0).irqs[irq] % 20))
                 sun3_leds(led_pattern[(kstat_cpu(0).irqs[irq] % 160) / 20]);
diff --git a/arch/m68knommu/kernel/time.c b/arch/m68knommu/kernel/time.c
index d6ac2a4..6623909 100644
--- a/arch/m68knommu/kernel/time.c
+++ b/arch/m68knommu/kernel/time.c
@@ -36,7 +36,7 @@ static inline int set_rtc_mmss(unsigned long nowtime)
 #ifndef CONFIG_GENERIC_CLOCKEVENTS
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 irqreturn_t arch_timer_interrupt(int irq, void *dummy)
 {
@@ -44,11 +44,7 @@ irqreturn_t arch_timer_interrupt(int irq, void *dummy)
 	if (current->pid)
 		profile_tick(CPU_PROFILING);
 
-	write_seqlock(&xtime_lock);
-
-	do_timer(1);
-
-	write_sequnlock(&xtime_lock);
+	xtime_update(1);
 
 	update_process_times(user_mode(get_irq_regs()));
 
diff --git a/arch/mn10300/kernel/time.c b/arch/mn10300/kernel/time.c
index 75da468..5b95500 100644
--- a/arch/mn10300/kernel/time.c
+++ b/arch/mn10300/kernel/time.c
@@ -104,8 +104,6 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 	unsigned tsc, elapse;
 	irqreturn_t ret;
 
-	write_seqlock(&xtime_lock);
-
 	while (tsc = get_cycles(),
 	       elapse = tsc - mn10300_last_tsc, /* time elapsed since last
 						 * tick */
@@ -114,11 +112,9 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 		mn10300_last_tsc += MN10300_TSC_PER_HZ;
 
 		/* advance the kernel's time tracking system */
-		do_timer(1);
+		xtime_update(1);
 	}
 
-	write_sequnlock(&xtime_lock);
-
 	ret = local_timer_interrupt();
 #ifdef CONFIG_SMP
 	send_IPI_allbutself(LOCAL_TIMER_IPI);
diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
index 05511cc..45b7389 100644
--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -162,11 +162,8 @@ irqreturn_t __irq_entry timer_interrupt(int irq, void *dev_id)
 		update_process_times(user_mode(get_irq_regs()));
 	}
 
-	if (cpu == 0) {
-		write_seqlock(&xtime_lock);
-		do_timer(ticks_elapsed);
-		write_sequnlock(&xtime_lock);
-	}
+	if (cpu == 0)
+		xtime_update(ticks_elapsed);
 
 	return IRQ_HANDLED;
 }
diff --git a/arch/sparc/kernel/pcic.c b/arch/sparc/kernel/pcic.c
index aeaa09a..2cdc131 100644
--- a/arch/sparc/kernel/pcic.c
+++ b/arch/sparc/kernel/pcic.c
@@ -700,10 +700,8 @@ static void pcic_clear_clock_irq(void)
 
 static irqreturn_t pcic_timer_handler (int irq, void *h)
 {
-	write_seqlock(&xtime_lock);	/* Dummy, to show that we remember */
 	pcic_clear_clock_irq();
-	do_timer(1);
-	write_sequnlock(&xtime_lock);
+	xtime_update(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
diff --git a/arch/sparc/kernel/time_32.c b/arch/sparc/kernel/time_32.c
index 9c743b1..4211bfc 100644
--- a/arch/sparc/kernel/time_32.c
+++ b/arch/sparc/kernel/time_32.c
@@ -85,7 +85,7 @@ int update_persistent_clock(struct timespec now)
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 
 #define TICK_SIZE (tick_nsec / 1000)
@@ -96,14 +96,9 @@ static irqreturn_t timer_interrupt(int dummy, void *dev_id)
 	profile_tick(CPU_PROFILING);
 #endif
 
-	/* Protect counter clear so that do_gettimeoffset works */
-	write_seqlock(&xtime_lock);
-
 	clear_clock_irq();
 
-	do_timer(1);
-
-	write_sequnlock(&xtime_lock);
+	xtime_update(1);
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 518bb99..0ed7896 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -851,4 +851,5 @@ ia32_sys_call_table:
 	.quad sys_fanotify_init
 	.quad sys32_fanotify_mark
 	.quad sys_prlimit64		/* 340 */
+	.quad compat_sys_clock_adjtime
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index b766a5e..b6f73f1 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -346,10 +346,11 @@
 #define __NR_fanotify_init	338
 #define __NR_fanotify_mark	339
 #define __NR_prlimit64		340
+#define __NR_clock_adjtime	341
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 341
+#define NR_syscalls 342
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 363e9b8..5ee3085 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -669,6 +669,8 @@ __SYSCALL(__NR_fanotify_init, sys_fanotify_init)
 __SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
 #define __NR_prlimit64				302
 __SYSCALL(__NR_prlimit64, sys_prlimit64)
+#define __NR_clock_adjtime			303
+__SYSCALL(__NR_clock_adjtime, sys_clock_adjtime)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index b35786d..68c7b9a 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -340,3 +340,4 @@ ENTRY(sys_call_table)
 	.long sys_fanotify_init
 	.long sys_fanotify_mark
 	.long sys_prlimit64		/* 340 */
+	.long sys_clock_adjtime
diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index 19df764..f3e5eb4 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -96,16 +96,12 @@ again:
 		update_process_times(user_mode(get_irq_regs()));
 #endif
 
-		write_seqlock(&xtime_lock);
-
-		do_timer(1); /* Linux handler in kernel/timer.c */
+		xtime_update(1); /* Linux handler in kernel/time/timekeeping */
 
 		/* Note that writing CCOMPARE clears the interrupt. */
 
 		next += CCOUNT_PER_JIFFY;
 		set_linux_timer(next);
-
-		write_sequnlock(&xtime_lock);
 	}
 
 	/* Allow platform to do something useful (Wdog). */
diff --git a/drivers/char/mmtimer.c b/drivers/char/mmtimer.c
index e6d7562..33dc229 100644
--- a/drivers/char/mmtimer.c
+++ b/drivers/char/mmtimer.c
@@ -53,6 +53,8 @@ MODULE_LICENSE("GPL");
 
 #define RTC_BITS 55 /* 55 bits for this implementation */
 
+static struct k_clock sgi_clock;
+
 extern unsigned long sn_rtc_cycles_per_second;
 
 #define RTC_COUNTER_ADDR        ((long *)LOCAL_MMR_ADDR(SH_RTC))
@@ -487,7 +489,7 @@ static int sgi_clock_get(clockid_t clockid, struct timespec *tp)
 	return 0;
 };
 
-static int sgi_clock_set(clockid_t clockid, struct timespec *tp)
+static int sgi_clock_set(const clockid_t clockid, const struct timespec *tp)
 {
 
 	u64 nsec;
@@ -763,15 +765,21 @@ static int sgi_timer_set(struct k_itimer *timr, int flags,
 	return err;
 }
 
+static int sgi_clock_getres(const clockid_t which_clock, struct timespec *tp)
+{
+	tp->tv_sec = 0;
+	tp->tv_nsec = sgi_clock_period;
+	return 0;
+}
+
 static struct k_clock sgi_clock = {
-	.res = 0,
-	.clock_set = sgi_clock_set,
-	.clock_get = sgi_clock_get,
-	.timer_create = sgi_timer_create,
-	.nsleep = do_posix_clock_nonanosleep,
-	.timer_set = sgi_timer_set,
-	.timer_del = sgi_timer_del,
-	.timer_get = sgi_timer_get
+	.clock_set	= sgi_clock_set,
+	.clock_get	= sgi_clock_get,
+	.clock_getres	= sgi_clock_getres,
+	.timer_create	= sgi_timer_create,
+	.timer_set	= sgi_timer_set,
+	.timer_del	= sgi_timer_del,
+	.timer_get	= sgi_timer_get
 };
 
 /**
@@ -831,8 +839,8 @@ static int __init mmtimer_init(void)
 			(unsigned long) node);
 	}
 
-	sgi_clock_period = sgi_clock.res = NSEC_PER_SEC / sn_rtc_cycles_per_second;
-	register_posix_clock(CLOCK_SGI_CYCLE, &sgi_clock);
+	sgi_clock_period = NSEC_PER_SEC / sn_rtc_cycles_per_second;
+	posix_timers_register_clock(CLOCK_SGI_CYCLE, &sgi_clock);
 
 	printk(KERN_INFO "%s: v%s, %ld MHz\n", MMTIMER_DESC, MMTIMER_VERSION,
 	       sn_rtc_cycles_per_second/(unsigned long)1E6);
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index f376ddc..62f500c 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -54,11 +54,13 @@ enum hrtimer_restart {
  * 0x00		inactive
  * 0x01		enqueued into rbtree
  * 0x02		callback function running
+ * 0x04		timer is migrated to another cpu
  *
  * Special cases:
  * 0x03		callback function running and enqueued
  *		(was requeued on another CPU)
- * 0x09		timer was migrated on CPU hotunplug
+ * 0x05		timer was migrated on CPU hotunplug
+ *
  * The "callback function running and enqueued" status is only possible on
  * SMP. It happens for example when a posix timer expired and the callback
  * queued a signal. Between dropping the lock which protects the posix timer
@@ -67,8 +69,11 @@ enum hrtimer_restart {
  * as otherwise the timer could be removed before the softirq code finishes the
  * the handling of the timer.
  *
- * The HRTIMER_STATE_ENQUEUED bit is always or'ed to the current state to
- * preserve the HRTIMER_STATE_CALLBACK bit in the above scenario.
+ * The HRTIMER_STATE_ENQUEUED bit is always or'ed to the current state
+ * to preserve the HRTIMER_STATE_CALLBACK in the above scenario. This
+ * also affects HRTIMER_STATE_MIGRATE where the preservation is not
+ * necessary. HRTIMER_STATE_MIGRATE is cleared after the timer is
+ * enqueued on the new cpu.
  *
  * All state transitions are protected by cpu_base->lock.
  */
@@ -148,7 +153,12 @@ struct hrtimer_clock_base {
 #endif
 };
 
-#define HRTIMER_MAX_CLOCK_BASES 2
+enum  hrtimer_base_type {
+	HRTIMER_BASE_REALTIME,
+	HRTIMER_BASE_MONOTONIC,
+	HRTIMER_BASE_BOOTTIME,
+	HRTIMER_MAX_CLOCK_BASES,
+};
 
 /*
  * struct hrtimer_cpu_base - the per cpu clock bases
@@ -308,6 +318,7 @@ static inline int hrtimer_is_hres_active(struct hrtimer *timer)
 
 extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_real(void);
+extern ktime_t ktime_get_boottime(void);
 
 
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
@@ -370,8 +381,9 @@ extern int hrtimer_get_res(const clockid_t which_clock, struct timespec *tp);
 extern ktime_t hrtimer_get_next_event(void);
 
 /*
- * A timer is active, when it is enqueued into the rbtree or the callback
- * function is running.
+ * A timer is active, when it is enqueued into the rbtree or the
+ * callback function is running or it's in the state of being migrated
+ * to another cpu.
  */
 static inline int hrtimer_active(const struct hrtimer *timer)
 {
diff --git a/include/linux/posix-clock.h b/include/linux/posix-clock.h
new file mode 100644
index 0000000..369e19d
--- /dev/null
+++ b/include/linux/posix-clock.h
@@ -0,0 +1,150 @@
+/*
+ * posix-clock.h - support for dynamic clock devices
+ *
+ * Copyright (C) 2010 OMICRON electronics GmbH
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#ifndef _LINUX_POSIX_CLOCK_H_
+#define _LINUX_POSIX_CLOCK_H_
+
+#include <linux/cdev.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/posix-timers.h>
+
+struct posix_clock;
+
+/**
+ * struct posix_clock_operations - functional interface to the clock
+ *
+ * Every posix clock is represented by a character device. Drivers may
+ * optionally offer extended capabilities by implementing the
+ * character device methods. The character device file operations are
+ * first handled by the clock device layer, then passed on to the
+ * driver by calling these functions.
+ *
+ * @owner:          The clock driver should set to THIS_MODULE
+ * @clock_adjtime:  Adjust the clock
+ * @clock_gettime:  Read the current time
+ * @clock_getres:   Get the clock resolution
+ * @clock_settime:  Set the current time value
+ * @timer_create:   Create a new timer
+ * @timer_delete:   Remove a previously created timer
+ * @timer_gettime:  Get remaining time and interval of a timer
+ * @timer_setttime: Set a timer's initial expiration and interval
+ * @fasync:         Optional character device fasync method
+ * @mmap:           Optional character device mmap method
+ * @open:           Optional character device open method
+ * @release:        Optional character device release method
+ * @ioctl:          Optional character device ioctl method
+ * @read:           Optional character device read method
+ * @poll:           Optional character device poll method
+ */
+struct posix_clock_operations {
+	struct module *owner;
+
+	int  (*clock_adjtime)(struct posix_clock *pc, struct timex *tx);
+
+	int  (*clock_gettime)(struct posix_clock *pc, struct timespec *ts);
+
+	int  (*clock_getres) (struct posix_clock *pc, struct timespec *ts);
+
+	int  (*clock_settime)(struct posix_clock *pc,
+			      const struct timespec *ts);
+
+	int  (*timer_create) (struct posix_clock *pc, struct k_itimer *kit);
+
+	int  (*timer_delete) (struct posix_clock *pc, struct k_itimer *kit);
+
+	void (*timer_gettime)(struct posix_clock *pc,
+			      struct k_itimer *kit, struct itimerspec *tsp);
+
+	int  (*timer_settime)(struct posix_clock *pc,
+			      struct k_itimer *kit, int flags,
+			      struct itimerspec *tsp, struct itimerspec *old);
+	/*
+	 * Optional character device methods:
+	 */
+	int     (*fasync)  (struct posix_clock *pc,
+			    int fd, struct file *file, int on);
+
+	long    (*ioctl)   (struct posix_clock *pc,
+			    unsigned int cmd, unsigned long arg);
+
+	int     (*mmap)    (struct posix_clock *pc,
+			    struct vm_area_struct *vma);
+
+	int     (*open)    (struct posix_clock *pc, fmode_t f_mode);
+
+	uint    (*poll)    (struct posix_clock *pc,
+			    struct file *file, poll_table *wait);
+
+	int     (*release) (struct posix_clock *pc);
+
+	ssize_t (*read)    (struct posix_clock *pc,
+			    uint flags, char __user *buf, size_t cnt);
+};
+
+/**
+ * struct posix_clock - represents a dynamic posix clock
+ *
+ * @ops:     Functional interface to the clock
+ * @cdev:    Character device instance for this clock
+ * @kref:    Reference count.
+ * @mutex:   Protects the 'zombie' field from concurrent access.
+ * @zombie:  If 'zombie' is true, then the hardware has disappeared.
+ * @release: A function to free the structure when the reference count reaches
+ *           zero. May be NULL if structure is statically allocated.
+ *
+ * Drivers should embed their struct posix_clock within a private
+ * structure, obtaining a reference to it during callbacks using
+ * container_of().
+ */
+struct posix_clock {
+	struct posix_clock_operations ops;
+	struct cdev cdev;
+	struct kref kref;
+	struct mutex mutex;
+	bool zombie;
+	void (*release)(struct posix_clock *clk);
+};
+
+/**
+ * posix_clock_register() - register a new clock
+ * @clk:   Pointer to the clock. Caller must provide 'ops' and 'release'
+ * @devid: Allocated device id
+ *
+ * A clock driver calls this function to register itself with the
+ * clock device subsystem. If 'clk' points to dynamically allocated
+ * memory, then the caller must provide a 'release' function to free
+ * that memory.
+ *
+ * Returns zero on success, non-zero otherwise.
+ */
+int posix_clock_register(struct posix_clock *clk, dev_t devid);
+
+/**
+ * posix_clock_unregister() - unregister a clock
+ * @clk: Clock instance previously registered via posix_clock_register()
+ *
+ * A clock driver calls this function to remove itself from the clock
+ * device subsystem. The posix_clock itself will remain (in an
+ * inactive state) until its reference count drops to zero, at which
+ * point it will be deallocated with its 'release' method.
+ */
+void posix_clock_unregister(struct posix_clock *clk);
+
+#endif
diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 3e23844a..d51243a 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -4,6 +4,7 @@
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/sched.h>
+#include <linux/timex.h>
 
 union cpu_time_count {
 	cputime_t cpu;
@@ -17,10 +18,21 @@ struct cpu_timer_list {
 	int firing;
 };
 
+/*
+ * Bit fields within a clockid:
+ *
+ * The most significant 29 bits hold either a pid or a file descriptor.
+ *
+ * Bit 2 indicates whether a cpu clock refers to a thread or a process.
+ *
+ * Bits 1 and 0 give the type: PROF=0, VIRT=1, SCHED=2, or FD=3.
+ *
+ * A clockid is invalid if bits 2, 1, and 0 are all set.
+ */
 #define CPUCLOCK_PID(clock)		((pid_t) ~((clock) >> 3))
 #define CPUCLOCK_PERTHREAD(clock) \
 	(((clock) & (clockid_t) CPUCLOCK_PERTHREAD_MASK) != 0)
-#define CPUCLOCK_PID_MASK	7
+
 #define CPUCLOCK_PERTHREAD_MASK	4
 #define CPUCLOCK_WHICH(clock)	((clock) & (clockid_t) CPUCLOCK_CLOCK_MASK)
 #define CPUCLOCK_CLOCK_MASK	3
@@ -28,12 +40,17 @@ struct cpu_timer_list {
 #define CPUCLOCK_VIRT		1
 #define CPUCLOCK_SCHED		2
 #define CPUCLOCK_MAX		3
+#define CLOCKFD			CPUCLOCK_MAX
+#define CLOCKFD_MASK		(CPUCLOCK_PERTHREAD_MASK|CPUCLOCK_CLOCK_MASK)
 
 #define MAKE_PROCESS_CPUCLOCK(pid, clock) \
 	((~(clockid_t) (pid) << 3) | (clockid_t) (clock))
 #define MAKE_THREAD_CPUCLOCK(tid, clock) \
 	MAKE_PROCESS_CPUCLOCK((tid), (clock) | CPUCLOCK_PERTHREAD_MASK)
 
+#define FD_TO_CLOCKID(fd)	((~(clockid_t) (fd) << 3) | CLOCKFD)
+#define CLOCKID_TO_FD(clk)	((unsigned int) ~((clk) >> 3))
+
 /* POSIX.1b interval timer structure. */
 struct k_itimer {
 	struct list_head list;		/* free/ allocate list */
@@ -67,10 +84,11 @@ struct k_itimer {
 };
 
 struct k_clock {
-	int res;		/* in nanoseconds */
 	int (*clock_getres) (const clockid_t which_clock, struct timespec *tp);
-	int (*clock_set) (const clockid_t which_clock, struct timespec * tp);
+	int (*clock_set) (const clockid_t which_clock,
+			  const struct timespec *tp);
 	int (*clock_get) (const clockid_t which_clock, struct timespec * tp);
+	int (*clock_adj) (const clockid_t which_clock, struct timex *tx);
 	int (*timer_create) (struct k_itimer *timer);
 	int (*nsleep) (const clockid_t which_clock, int flags,
 		       struct timespec *, struct timespec __user *);
@@ -84,28 +102,14 @@ struct k_clock {
 			   struct itimerspec * cur_setting);
 };
 
-void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock);
+extern struct k_clock clock_posix_cpu;
+extern struct k_clock clock_posix_dynamic;
 
-/* error handlers for timer_create, nanosleep and settime */
-int do_posix_clock_nonanosleep(const clockid_t, int flags, struct timespec *,
-			       struct timespec __user *);
-int do_posix_clock_nosettime(const clockid_t, struct timespec *tp);
+void posix_timers_register_clock(const clockid_t clock_id, struct k_clock *new_clock);
 
 /* function to call to trigger timer event */
 int posix_timer_event(struct k_itimer *timr, int si_private);
 
-int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *ts);
-int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *ts);
-int posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *ts);
-int posix_cpu_timer_create(struct k_itimer *timer);
-int posix_cpu_nsleep(const clockid_t which_clock, int flags,
-		     struct timespec *rqtp, struct timespec __user *rmtp);
-long posix_cpu_nsleep_restart(struct restart_block *restart_block);
-int posix_cpu_timer_set(struct k_itimer *timer, int flags,
-			struct itimerspec *new, struct itimerspec *old);
-int posix_cpu_timer_del(struct k_itimer *timer);
-void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp);
-
 void posix_cpu_timer_schedule(struct k_itimer *timer);
 
 void run_posix_cpu_timers(struct task_struct *task);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d747f94..cdef640 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2049,7 +2049,7 @@ extern void release_uids(struct user_namespace *ns);
 
 #include <asm/current.h>
 
-extern void do_timer(unsigned long ticks);
+extern void xtime_update(unsigned long ticks);
 
 extern int wake_up_state(struct task_struct *tsk, unsigned int state);
 extern int wake_up_process(struct task_struct *tsk);
diff --git a/include/linux/security.h b/include/linux/security.h
index c642bb8..c096aa6 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -53,7 +53,7 @@ struct audit_krule;
  */
 extern int cap_capable(struct task_struct *tsk, const struct cred *cred,
 		       int cap, int audit);
-extern int cap_settime(struct timespec *ts, struct timezone *tz);
+extern int cap_settime(const struct timespec *ts, const struct timezone *tz);
 extern int cap_ptrace_access_check(struct task_struct *child, unsigned int mode);
 extern int cap_ptrace_traceme(struct task_struct *parent);
 extern int cap_capget(struct task_struct *target, kernel_cap_t *effective, kernel_cap_t *inheritable, kernel_cap_t *permitted);
@@ -1387,7 +1387,7 @@ struct security_operations {
 	int (*quotactl) (int cmds, int type, int id, struct super_block *sb);
 	int (*quota_on) (struct dentry *dentry);
 	int (*syslog) (int type);
-	int (*settime) (struct timespec *ts, struct timezone *tz);
+	int (*settime) (const struct timespec *ts, const struct timezone *tz);
 	int (*vm_enough_memory) (struct mm_struct *mm, long pages);
 
 	int (*bprm_set_creds) (struct linux_binprm *bprm);
@@ -1669,7 +1669,7 @@ int security_sysctl(struct ctl_table *table, int op);
 int security_quotactl(int cmds, int type, int id, struct super_block *sb);
 int security_quota_on(struct dentry *dentry);
 int security_syslog(int type);
-int security_settime(struct timespec *ts, struct timezone *tz);
+int security_settime(const struct timespec *ts, const struct timezone *tz);
 int security_vm_enough_memory(long pages);
 int security_vm_enough_memory_mm(struct mm_struct *mm, long pages);
 int security_vm_enough_memory_kern(long pages);
@@ -1904,7 +1904,8 @@ static inline int security_syslog(int type)
 	return 0;
 }
 
-static inline int security_settime(struct timespec *ts, struct timezone *tz)
+static inline int security_settime(const struct timespec *ts,
+				   const struct timezone *tz)
 {
 	return cap_settime(ts, tz);
 }
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 18cd068..bfacab9 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -311,6 +311,8 @@ asmlinkage long sys_clock_settime(clockid_t which_clock,
 				const struct timespec __user *tp);
 asmlinkage long sys_clock_gettime(clockid_t which_clock,
 				struct timespec __user *tp);
+asmlinkage long sys_clock_adjtime(clockid_t which_clock,
+				struct timex __user *tx);
 asmlinkage long sys_clock_getres(clockid_t which_clock,
 				struct timespec __user *tp);
 asmlinkage long sys_clock_nanosleep(clockid_t which_clock, int flags,
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index c906965..20fc303 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -18,9 +18,6 @@ struct compat_timespec;
 struct restart_block {
 	long (*fn)(struct restart_block *);
 	union {
-		struct {
-			unsigned long arg0, arg1, arg2, arg3;
-		};
 		/* For futex_wait and futex_wait_requeue_pi */
 		struct {
 			u32 __user *uaddr;
diff --git a/include/linux/time.h b/include/linux/time.h
index 1e6d3b5..454a262 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -113,8 +113,6 @@ static inline struct timespec timespec_sub(struct timespec lhs,
 #define timespec_valid(ts) \
 	(((ts)->tv_sec >= 0) && (((unsigned long) (ts)->tv_nsec) < NSEC_PER_SEC))
 
-extern seqlock_t xtime_lock;
-
 extern void read_persistent_clock(struct timespec *ts);
 extern void read_boot_clock(struct timespec *ts);
 extern int update_persistent_clock(struct timespec now);
@@ -125,8 +123,9 @@ extern int timekeeping_suspended;
 unsigned long get_seconds(void);
 struct timespec current_kernel_time(void);
 struct timespec __current_kernel_time(void); /* does not take xtime_lock */
-struct timespec __get_wall_to_monotonic(void); /* does not take xtime_lock */
 struct timespec get_monotonic_coarse(void);
+void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
+				struct timespec *wtom, struct timespec *sleep);
 
 #define CURRENT_TIME		(current_kernel_time())
 #define CURRENT_TIME_SEC	((struct timespec) { get_seconds(), 0 })
@@ -147,8 +146,9 @@ static inline u32 arch_gettimeoffset(void) { return 0; }
 #endif
 
 extern void do_gettimeofday(struct timeval *tv);
-extern int do_settimeofday(struct timespec *tv);
-extern int do_sys_settimeofday(struct timespec *tv, struct timezone *tz);
+extern int do_settimeofday(const struct timespec *tv);
+extern int do_sys_settimeofday(const struct timespec *tv,
+			       const struct timezone *tz);
 #define do_posix_clock_monotonic_gettime(ts) ktime_get_ts(ts)
 extern long do_utimes(int dfd, const char __user *filename, struct timespec *times, int flags);
 struct itimerval;
@@ -162,12 +162,13 @@ extern void getnstime_raw_and_real(struct timespec *ts_raw,
 		struct timespec *ts_real);
 extern void getboottime(struct timespec *ts);
 extern void monotonic_to_bootbased(struct timespec *ts);
+extern void get_monotonic_boottime(struct timespec *ts);
 
 extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_valid_for_hres(void);
 extern u64 timekeeping_max_deferment(void);
-extern void update_wall_time(void);
 extern void timekeeping_leap_insert(int leapsecond);
+extern int timekeeping_inject_offset(struct timespec *ts);
 
 struct tms;
 extern void do_sys_times(struct tms *);
@@ -292,6 +293,7 @@ struct itimerval {
 #define CLOCK_MONOTONIC_RAW		4
 #define CLOCK_REALTIME_COARSE		5
 #define CLOCK_MONOTONIC_COARSE		6
+#define CLOCK_BOOTTIME			7
 
 /*
  * The IDs of various hardware clocks:
diff --git a/include/linux/timex.h b/include/linux/timex.h
index d23999f..aa60fe7 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -73,7 +73,7 @@ struct timex {
 	long tolerance;		/* clock frequency tolerance (ppm)
 				 * (read only)
 				 */
-	struct timeval time;	/* (read only) */
+	struct timeval time;	/* (read only, except for ADJ_SETOFFSET) */
 	long tick;		/* (modified) usecs between clock ticks */
 
 	long ppsfreq;           /* pps frequency (scaled ppm) (ro) */
@@ -102,6 +102,7 @@ struct timex {
 #define ADJ_STATUS		0x0010	/* clock status */
 #define ADJ_TIMECONST		0x0020	/* pll time constant */
 #define ADJ_TAI			0x0080	/* set TAI offset */
+#define ADJ_SETOFFSET		0x0100  /* add 'time' to current time */
 #define ADJ_MICRO		0x1000	/* select microsecond resolution */
 #define ADJ_NANO		0x2000	/* select nanosecond resolution */
 #define ADJ_TICK		0x4000	/* tick value */
diff --git a/kernel/compat.c b/kernel/compat.c
index c9e2ec0..38b1d2c 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -52,6 +52,64 @@ static int compat_put_timeval(struct compat_timeval __user *o,
 		put_user(i->tv_usec, &o->tv_usec)) ? -EFAULT : 0;
 }
 
+static int compat_get_timex(struct timex *txc, struct compat_timex __user *utp)
+{
+	memset(txc, 0, sizeof(struct timex));
+
+	if (!access_ok(VERIFY_READ, utp, sizeof(struct compat_timex)) ||
+			__get_user(txc->modes, &utp->modes) ||
+			__get_user(txc->offset, &utp->offset) ||
+			__get_user(txc->freq, &utp->freq) ||
+			__get_user(txc->maxerror, &utp->maxerror) ||
+			__get_user(txc->esterror, &utp->esterror) ||
+			__get_user(txc->status, &utp->status) ||
+			__get_user(txc->constant, &utp->constant) ||
+			__get_user(txc->precision, &utp->precision) ||
+			__get_user(txc->tolerance, &utp->tolerance) ||
+			__get_user(txc->time.tv_sec, &utp->time.tv_sec) ||
+			__get_user(txc->time.tv_usec, &utp->time.tv_usec) ||
+			__get_user(txc->tick, &utp->tick) ||
+			__get_user(txc->ppsfreq, &utp->ppsfreq) ||
+			__get_user(txc->jitter, &utp->jitter) ||
+			__get_user(txc->shift, &utp->shift) ||
+			__get_user(txc->stabil, &utp->stabil) ||
+			__get_user(txc->jitcnt, &utp->jitcnt) ||
+			__get_user(txc->calcnt, &utp->calcnt) ||
+			__get_user(txc->errcnt, &utp->errcnt) ||
+			__get_user(txc->stbcnt, &utp->stbcnt))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int compat_put_timex(struct compat_timex __user *utp, struct timex *txc)
+{
+	if (!access_ok(VERIFY_WRITE, utp, sizeof(struct compat_timex)) ||
+			__put_user(txc->modes, &utp->modes) ||
+			__put_user(txc->offset, &utp->offset) ||
+			__put_user(txc->freq, &utp->freq) ||
+			__put_user(txc->maxerror, &utp->maxerror) ||
+			__put_user(txc->esterror, &utp->esterror) ||
+			__put_user(txc->status, &utp->status) ||
+			__put_user(txc->constant, &utp->constant) ||
+			__put_user(txc->precision, &utp->precision) ||
+			__put_user(txc->tolerance, &utp->tolerance) ||
+			__put_user(txc->time.tv_sec, &utp->time.tv_sec) ||
+			__put_user(txc->time.tv_usec, &utp->time.tv_usec) ||
+			__put_user(txc->tick, &utp->tick) ||
+			__put_user(txc->ppsfreq, &utp->ppsfreq) ||
+			__put_user(txc->jitter, &utp->jitter) ||
+			__put_user(txc->shift, &utp->shift) ||
+			__put_user(txc->stabil, &utp->stabil) ||
+			__put_user(txc->jitcnt, &utp->jitcnt) ||
+			__put_user(txc->calcnt, &utp->calcnt) ||
+			__put_user(txc->errcnt, &utp->errcnt) ||
+			__put_user(txc->stbcnt, &utp->stbcnt) ||
+			__put_user(txc->tai, &utp->tai))
+		return -EFAULT;
+	return 0;
+}
+
 asmlinkage long compat_sys_gettimeofday(struct compat_timeval __user *tv,
 		struct timezone __user *tz)
 {
@@ -617,6 +675,29 @@ long compat_sys_clock_gettime(clockid_t which_clock,
 	return err;
 }
 
+long compat_sys_clock_adjtime(clockid_t which_clock,
+		struct compat_timex __user *utp)
+{
+	struct timex txc;
+	mm_segment_t oldfs;
+	int err, ret;
+
+	err = compat_get_timex(&txc, utp);
+	if (err)
+		return err;
+
+	oldfs = get_fs();
+	set_fs(KERNEL_DS);
+	ret = sys_clock_adjtime(which_clock, (struct timex __user *) &txc);
+	set_fs(oldfs);
+
+	err = compat_put_timex(utp, &txc);
+	if (err)
+		return err;
+
+	return ret;
+}
+
 long compat_sys_clock_getres(clockid_t which_clock,
 		struct compat_timespec __user *tp)
 {
@@ -951,58 +1032,17 @@ asmlinkage long compat_sys_rt_sigsuspend(compat_sigset_t __user *unewset, compat
 asmlinkage long compat_sys_adjtimex(struct compat_timex __user *utp)
 {
 	struct timex txc;
-	int ret;
-
-	memset(&txc, 0, sizeof(struct timex));
+	int err, ret;
 
-	if (!access_ok(VERIFY_READ, utp, sizeof(struct compat_timex)) ||
-			__get_user(txc.modes, &utp->modes) ||
-			__get_user(txc.offset, &utp->offset) ||
-			__get_user(txc.freq, &utp->freq) ||
-			__get_user(txc.maxerror, &utp->maxerror) ||
-			__get_user(txc.esterror, &utp->esterror) ||
-			__get_user(txc.status, &utp->status) ||
-			__get_user(txc.constant, &utp->constant) ||
-			__get_user(txc.precision, &utp->precision) ||
-			__get_user(txc.tolerance, &utp->tolerance) ||
-			__get_user(txc.time.tv_sec, &utp->time.tv_sec) ||
-			__get_user(txc.time.tv_usec, &utp->time.tv_usec) ||
-			__get_user(txc.tick, &utp->tick) ||
-			__get_user(txc.ppsfreq, &utp->ppsfreq) ||
-			__get_user(txc.jitter, &utp->jitter) ||
-			__get_user(txc.shift, &utp->shift) ||
-			__get_user(txc.stabil, &utp->stabil) ||
-			__get_user(txc.jitcnt, &utp->jitcnt) ||
-			__get_user(txc.calcnt, &utp->calcnt) ||
-			__get_user(txc.errcnt, &utp->errcnt) ||
-			__get_user(txc.stbcnt, &utp->stbcnt))
-		return -EFAULT;
+	err = compat_get_timex(&txc, utp);
+	if (err)
+		return err;
 
 	ret = do_adjtimex(&txc);
 
-	if (!access_ok(VERIFY_WRITE, utp, sizeof(struct compat_timex)) ||
-			__put_user(txc.modes, &utp->modes) ||
-			__put_user(txc.offset, &utp->offset) ||
-			__put_user(txc.freq, &utp->freq) ||
-			__put_user(txc.maxerror, &utp->maxerror) ||
-			__put_user(txc.esterror, &utp->esterror) ||
-			__put_user(txc.status, &utp->status) ||
-			__put_user(txc.constant, &utp->constant) ||
-			__put_user(txc.precision, &utp->precision) ||
-			__put_user(txc.tolerance, &utp->tolerance) ||
-			__put_user(txc.time.tv_sec, &utp->time.tv_sec) ||
-			__put_user(txc.time.tv_usec, &utp->time.tv_usec) ||
-			__put_user(txc.tick, &utp->tick) ||
-			__put_user(txc.ppsfreq, &utp->ppsfreq) ||
-			__put_user(txc.jitter, &utp->jitter) ||
-			__put_user(txc.shift, &utp->shift) ||
-			__put_user(txc.stabil, &utp->stabil) ||
-			__put_user(txc.jitcnt, &utp->jitcnt) ||
-			__put_user(txc.calcnt, &utp->calcnt) ||
-			__put_user(txc.errcnt, &utp->errcnt) ||
-			__put_user(txc.stbcnt, &utp->stbcnt) ||
-			__put_user(txc.tai, &utp->tai))
-		ret = -EFAULT;
+	err = compat_put_timex(utp, &txc);
+	if (err)
+		return err;
 
 	return ret;
 }
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0c8d7c0..63fb749 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -53,11 +53,10 @@
 /*
  * The timer bases:
  *
- * Note: If we want to add new timer bases, we have to skip the two
- * clock ids captured by the cpu-timers. We do this by holding empty
- * entries rather than doing math adjustment of the clock ids.
- * This ensures that we capture erroneous accesses to these clock ids
- * rather than moving them into the range of valid clock id's.
+ * There are more clockids then hrtimer bases. Thus, we index
+ * into the timer bases by the hrtimer_base_type enum. When trying
+ * to reach a base using a clockid, hrtimer_clockid_to_base()
+ * is used to convert from clockid to the proper hrtimer_base_type.
  */
 DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 {
@@ -74,30 +73,39 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 			.get_time = &ktime_get,
 			.resolution = KTIME_LOW_RES,
 		},
+		{
+			.index = CLOCK_BOOTTIME,
+			.get_time = &ktime_get_boottime,
+			.resolution = KTIME_LOW_RES,
+		},
 	}
 };
 
+static int hrtimer_clock_to_base_table[MAX_CLOCKS];
+
+static inline int hrtimer_clockid_to_base(clockid_t clock_id)
+{
+	return hrtimer_clock_to_base_table[clock_id];
+}
+
+
 /*
  * Get the coarse grained time at the softirq based on xtime and
  * wall_to_monotonic.
  */
 static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 {
-	ktime_t xtim, tomono;
-	struct timespec xts, tom;
-	unsigned long seq;
+	ktime_t xtim, mono, boot;
+	struct timespec xts, tom, slp;
 
-	do {
-		seq = read_seqbegin(&xtime_lock);
-		xts = __current_kernel_time();
-		tom = __get_wall_to_monotonic();
-	} while (read_seqretry(&xtime_lock, seq));
+	get_xtime_and_monotonic_and_sleep_offset(&xts, &tom, &slp);
 
 	xtim = timespec_to_ktime(xts);
-	tomono = timespec_to_ktime(tom);
-	base->clock_base[CLOCK_REALTIME].softirq_time = xtim;
-	base->clock_base[CLOCK_MONOTONIC].softirq_time =
-		ktime_add(xtim, tomono);
+	mono = ktime_add(xtim, timespec_to_ktime(tom));
+	boot = ktime_add(mono, timespec_to_ktime(slp));
+	base->clock_base[HRTIMER_BASE_REALTIME].softirq_time = xtim;
+	base->clock_base[HRTIMER_BASE_MONOTONIC].softirq_time = mono;
+	base->clock_base[HRTIMER_BASE_BOOTTIME].softirq_time = boot;
 }
 
 /*
@@ -184,10 +192,11 @@ switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base,
 	struct hrtimer_cpu_base *new_cpu_base;
 	int this_cpu = smp_processor_id();
 	int cpu = hrtimer_get_target(this_cpu, pinned);
+	int basenum = hrtimer_clockid_to_base(base->index);
 
 again:
 	new_cpu_base = &per_cpu(hrtimer_bases, cpu);
-	new_base = &new_cpu_base->clock_base[base->index];
+	new_base = &new_cpu_base->clock_base[basenum];
 
 	if (base != new_base) {
 		/*
@@ -611,24 +620,23 @@ static int hrtimer_reprogram(struct hrtimer *timer,
 static void retrigger_next_event(void *arg)
 {
 	struct hrtimer_cpu_base *base;
-	struct timespec realtime_offset, wtm;
-	unsigned long seq;
+	struct timespec realtime_offset, wtm, sleep;
 
 	if (!hrtimer_hres_active())
 		return;
 
-	do {
-		seq = read_seqbegin(&xtime_lock);
-		wtm = __get_wall_to_monotonic();
-	} while (read_seqretry(&xtime_lock, seq));
+	get_xtime_and_monotonic_and_sleep_offset(&realtime_offset, &wtm,
+							&sleep);
 	set_normalized_timespec(&realtime_offset, -wtm.tv_sec, -wtm.tv_nsec);
 
 	base = &__get_cpu_var(hrtimer_bases);
 
 	/* Adjust CLOCK_REALTIME offset */
 	raw_spin_lock(&base->lock);
-	base->clock_base[CLOCK_REALTIME].offset =
+	base->clock_base[HRTIMER_BASE_REALTIME].offset =
 		timespec_to_ktime(realtime_offset);
+	base->clock_base[HRTIMER_BASE_BOOTTIME].offset =
+		timespec_to_ktime(sleep);
 
 	hrtimer_force_reprogram(base, 0);
 	raw_spin_unlock(&base->lock);
@@ -673,14 +681,6 @@ static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base)
 }
 
 /*
- * Initialize the high resolution related parts of a hrtimer
- */
-static inline void hrtimer_init_timer_hres(struct hrtimer *timer)
-{
-}
-
-
-/*
  * When High resolution timers are active, try to reprogram. Note, that in case
  * the state has HRTIMER_STATE_CALLBACK set, no reprogramming and no expiry
  * check happens. The timer gets enqueued into the rbtree. The reprogramming
@@ -725,8 +725,9 @@ static int hrtimer_switch_to_hres(void)
 		return 0;
 	}
 	base->hres_active = 1;
-	base->clock_base[CLOCK_REALTIME].resolution = KTIME_HIGH_RES;
-	base->clock_base[CLOCK_MONOTONIC].resolution = KTIME_HIGH_RES;
+	base->clock_base[HRTIMER_BASE_REALTIME].resolution = KTIME_HIGH_RES;
+	base->clock_base[HRTIMER_BASE_MONOTONIC].resolution = KTIME_HIGH_RES;
+	base->clock_base[HRTIMER_BASE_BOOTTIME].resolution = KTIME_HIGH_RES;
 
 	tick_setup_sched_timer();
 
@@ -750,7 +751,6 @@ static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 	return 0;
 }
 static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base) { }
-static inline void hrtimer_init_timer_hres(struct hrtimer *timer) { }
 
 #endif /* CONFIG_HIGH_RES_TIMERS */
 
@@ -1121,6 +1121,7 @@ static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 			   enum hrtimer_mode mode)
 {
 	struct hrtimer_cpu_base *cpu_base;
+	int base;
 
 	memset(timer, 0, sizeof(struct hrtimer));
 
@@ -1129,8 +1130,8 @@ static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 	if (clock_id == CLOCK_REALTIME && mode != HRTIMER_MODE_ABS)
 		clock_id = CLOCK_MONOTONIC;
 
-	timer->base = &cpu_base->clock_base[clock_id];
-	hrtimer_init_timer_hres(timer);
+	base = hrtimer_clockid_to_base(clock_id);
+	timer->base = &cpu_base->clock_base[base];
 	timerqueue_init(&timer->node);
 
 #ifdef CONFIG_TIMER_STATS
@@ -1165,9 +1166,10 @@ EXPORT_SYMBOL_GPL(hrtimer_init);
 int hrtimer_get_res(const clockid_t which_clock, struct timespec *tp)
 {
 	struct hrtimer_cpu_base *cpu_base;
+	int base = hrtimer_clockid_to_base(which_clock);
 
 	cpu_base = &__raw_get_cpu_var(hrtimer_bases);
-	*tp = ktime_to_timespec(cpu_base->clock_base[which_clock].resolution);
+	*tp = ktime_to_timespec(cpu_base->clock_base[base].resolution);
 
 	return 0;
 }
@@ -1714,6 +1716,10 @@ static struct notifier_block __cpuinitdata hrtimers_nb = {
 
 void __init hrtimers_init(void)
 {
+	hrtimer_clock_to_base_table[CLOCK_REALTIME] = HRTIMER_BASE_REALTIME;
+	hrtimer_clock_to_base_table[CLOCK_MONOTONIC] = HRTIMER_BASE_MONOTONIC;
+	hrtimer_clock_to_base_table[CLOCK_BOOTTIME] = HRTIMER_BASE_BOOTTIME;
+
 	hrtimer_cpu_notify(&hrtimers_nb, (unsigned long)CPU_UP_PREPARE,
 			  (void *)(long)smp_processor_id());
 	register_cpu_notifier(&hrtimers_nb);
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 05bb717..67fea9d 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -176,7 +176,8 @@ static inline cputime_t virt_ticks(struct task_struct *p)
 	return p->utime;
 }
 
-int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *tp)
+static int
+posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *tp)
 {
 	int error = check_clock(which_clock);
 	if (!error) {
@@ -194,7 +195,8 @@ int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *tp)
 	return error;
 }
 
-int posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *tp)
+static int
+posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *tp)
 {
 	/*
 	 * You can never reset a CPU clock, but we check for other errors
@@ -317,7 +319,7 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 }
 
 
-int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
+static int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
 {
 	const pid_t pid = CPUCLOCK_PID(which_clock);
 	int error = -EINVAL;
@@ -379,7 +381,7 @@ int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
  * This is called from sys_timer_create() and do_cpu_nanosleep() with the
  * new timer already all-zeros initialized.
  */
-int posix_cpu_timer_create(struct k_itimer *new_timer)
+static int posix_cpu_timer_create(struct k_itimer *new_timer)
 {
 	int ret = 0;
 	const pid_t pid = CPUCLOCK_PID(new_timer->it_clock);
@@ -425,7 +427,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
  * If we return TIMER_RETRY, it's necessary to release the timer's lock
  * and try again.  (This happens when the timer is in the middle of firing.)
  */
-int posix_cpu_timer_del(struct k_itimer *timer)
+static int posix_cpu_timer_del(struct k_itimer *timer)
 {
 	struct task_struct *p = timer->it.cpu.task;
 	int ret = 0;
@@ -665,8 +667,8 @@ static int cpu_timer_sample_group(const clockid_t which_clock,
  * If we return TIMER_RETRY, it's necessary to release the timer's lock
  * and try again.  (This happens when the timer is in the middle of firing.)
  */
-int posix_cpu_timer_set(struct k_itimer *timer, int flags,
-			struct itimerspec *new, struct itimerspec *old)
+static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
+			       struct itimerspec *new, struct itimerspec *old)
 {
 	struct task_struct *p = timer->it.cpu.task;
 	union cpu_time_count old_expires, new_expires, old_incr, val;
@@ -820,7 +822,7 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	return ret;
 }
 
-void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
+static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 {
 	union cpu_time_count now;
 	struct task_struct *p = timer->it.cpu.task;
@@ -1481,11 +1483,13 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
 	return error;
 }
 
-int posix_cpu_nsleep(const clockid_t which_clock, int flags,
-		     struct timespec *rqtp, struct timespec __user *rmtp)
+static long posix_cpu_nsleep_restart(struct restart_block *restart_block);
+
+static int posix_cpu_nsleep(const clockid_t which_clock, int flags,
+			    struct timespec *rqtp, struct timespec __user *rmtp)
 {
 	struct restart_block *restart_block =
-	    &current_thread_info()->restart_block;
+		&current_thread_info()->restart_block;
 	struct itimerspec it;
 	int error;
 
@@ -1501,56 +1505,47 @@ int posix_cpu_nsleep(const clockid_t which_clock, int flags,
 
 	if (error == -ERESTART_RESTARTBLOCK) {
 
-	       	if (flags & TIMER_ABSTIME)
+		if (flags & TIMER_ABSTIME)
 			return -ERESTARTNOHAND;
 		/*
-	 	 * Report back to the user the time still remaining.
-	 	 */
-		if (rmtp != NULL && copy_to_user(rmtp, &it.it_value, sizeof *rmtp))
+		 * Report back to the user the time still remaining.
+		 */
+		if (rmtp && copy_to_user(rmtp, &it.it_value, sizeof *rmtp))
 			return -EFAULT;
 
 		restart_block->fn = posix_cpu_nsleep_restart;
-		restart_block->arg0 = which_clock;
-		restart_block->arg1 = (unsigned long) rmtp;
-		restart_block->arg2 = rqtp->tv_sec;
-		restart_block->arg3 = rqtp->tv_nsec;
+		restart_block->nanosleep.index = which_clock;
+		restart_block->nanosleep.rmtp = rmtp;
+		restart_block->nanosleep.expires = timespec_to_ns(rqtp);
 	}
 	return error;
 }
 
-long posix_cpu_nsleep_restart(struct restart_block *restart_block)
+static long posix_cpu_nsleep_restart(struct restart_block *restart_block)
 {
-	clockid_t which_clock = restart_block->arg0;
-	struct timespec __user *rmtp;
+	clockid_t which_clock = restart_block->nanosleep.index;
 	struct timespec t;
 	struct itimerspec it;
 	int error;
 
-	rmtp = (struct timespec __user *) restart_block->arg1;
-	t.tv_sec = restart_block->arg2;
-	t.tv_nsec = restart_block->arg3;
+	t = ns_to_timespec(restart_block->nanosleep.expires);
 
-	restart_block->fn = do_no_restart_syscall;
 	error = do_cpu_nanosleep(which_clock, TIMER_ABSTIME, &t, &it);
 
 	if (error == -ERESTART_RESTARTBLOCK) {
+		struct timespec __user *rmtp = restart_block->nanosleep.rmtp;
 		/*
-	 	 * Report back to the user the time still remaining.
-	 	 */
-		if (rmtp != NULL && copy_to_user(rmtp, &it.it_value, sizeof *rmtp))
+		 * Report back to the user the time still remaining.
+		 */
+		if (rmtp && copy_to_user(rmtp, &it.it_value, sizeof *rmtp))
 			return -EFAULT;
 
-		restart_block->fn = posix_cpu_nsleep_restart;
-		restart_block->arg0 = which_clock;
-		restart_block->arg1 = (unsigned long) rmtp;
-		restart_block->arg2 = t.tv_sec;
-		restart_block->arg3 = t.tv_nsec;
+		restart_block->nanosleep.expires = timespec_to_ns(&t);
 	}
 	return error;
 
 }
 
-
 #define PROCESS_CLOCK	MAKE_PROCESS_CPUCLOCK(0, CPUCLOCK_SCHED)
 #define THREAD_CLOCK	MAKE_THREAD_CPUCLOCK(0, CPUCLOCK_SCHED)
 
@@ -1594,38 +1589,37 @@ static int thread_cpu_timer_create(struct k_itimer *timer)
 	timer->it_clock = THREAD_CLOCK;
 	return posix_cpu_timer_create(timer);
 }
-static int thread_cpu_nsleep(const clockid_t which_clock, int flags,
-			      struct timespec *rqtp, struct timespec __user *rmtp)
-{
-	return -EINVAL;
-}
-static long thread_cpu_nsleep_restart(struct restart_block *restart_block)
-{
-	return -EINVAL;
-}
+
+struct k_clock clock_posix_cpu = {
+	.clock_getres	= posix_cpu_clock_getres,
+	.clock_set	= posix_cpu_clock_set,
+	.clock_get	= posix_cpu_clock_get,
+	.timer_create	= posix_cpu_timer_create,
+	.nsleep		= posix_cpu_nsleep,
+	.nsleep_restart	= posix_cpu_nsleep_restart,
+	.timer_set	= posix_cpu_timer_set,
+	.timer_del	= posix_cpu_timer_del,
+	.timer_get	= posix_cpu_timer_get,
+};
 
 static __init int init_posix_cpu_timers(void)
 {
 	struct k_clock process = {
-		.clock_getres = process_cpu_clock_getres,
-		.clock_get = process_cpu_clock_get,
-		.clock_set = do_posix_clock_nosettime,
-		.timer_create = process_cpu_timer_create,
-		.nsleep = process_cpu_nsleep,
-		.nsleep_restart = process_cpu_nsleep_restart,
+		.clock_getres	= process_cpu_clock_getres,
+		.clock_get	= process_cpu_clock_get,
+		.timer_create	= process_cpu_timer_create,
+		.nsleep		= process_cpu_nsleep,
+		.nsleep_restart	= process_cpu_nsleep_restart,
 	};
 	struct k_clock thread = {
-		.clock_getres = thread_cpu_clock_getres,
-		.clock_get = thread_cpu_clock_get,
-		.clock_set = do_posix_clock_nosettime,
-		.timer_create = thread_cpu_timer_create,
-		.nsleep = thread_cpu_nsleep,
-		.nsleep_restart = thread_cpu_nsleep_restart,
+		.clock_getres	= thread_cpu_clock_getres,
+		.clock_get	= thread_cpu_clock_get,
+		.timer_create	= thread_cpu_timer_create,
 	};
 	struct timespec ts;
 
-	register_posix_clock(CLOCK_PROCESS_CPUTIME_ID, &process);
-	register_posix_clock(CLOCK_THREAD_CPUTIME_ID, &thread);
+	posix_timers_register_clock(CLOCK_PROCESS_CPUTIME_ID, &process);
+	posix_timers_register_clock(CLOCK_THREAD_CPUTIME_ID, &thread);
 
 	cputime_to_timespec(cputime_one_jiffy, &ts);
 	onecputick = ts.tv_nsec;
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 93bd2eb..4c01249 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -41,6 +41,7 @@
 #include <linux/init.h>
 #include <linux/compiler.h>
 #include <linux/idr.h>
+#include <linux/posix-clock.h>
 #include <linux/posix-timers.h>
 #include <linux/syscalls.h>
 #include <linux/wait.h>
@@ -81,6 +82,14 @@ static DEFINE_SPINLOCK(idr_lock);
 #error "SIGEV_THREAD_ID must not share bit with other SIGEV values!"
 #endif
 
+/*
+ * parisc wants ENOTSUP instead of EOPNOTSUPP
+ */
+#ifndef ENOTSUP
+# define ENANOSLEEP_NOTSUP EOPNOTSUPP
+#else
+# define ENANOSLEEP_NOTSUP ENOTSUP
+#endif
 
 /*
  * The timer ID is turned into a timer address by idr_find().
@@ -94,11 +103,7 @@ static DEFINE_SPINLOCK(idr_lock);
 /*
  * CLOCKs: The POSIX standard calls for a couple of clocks and allows us
  *	    to implement others.  This structure defines the various
- *	    clocks and allows the possibility of adding others.	 We
- *	    provide an interface to add clocks to the table and expect
- *	    the "arch" code to add at least one clock that is high
- *	    resolution.	 Here we define the standard CLOCK_REALTIME as a
- *	    1/HZ resolution clock.
+ *	    clocks.
  *
  * RESOLUTION: Clock resolution is used to round up timer and interval
  *	    times, NOT to report clock times, which are reported with as
@@ -108,20 +113,13 @@ static DEFINE_SPINLOCK(idr_lock);
  *	    necessary code is written.	The standard says we should say
  *	    something about this issue in the documentation...
  *
- * FUNCTIONS: The CLOCKs structure defines possible functions to handle
- *	    various clock functions.  For clocks that use the standard
- *	    system timer code these entries should be NULL.  This will
- *	    allow dispatch without the overhead of indirect function
- *	    calls.  CLOCKS that depend on other sources (e.g. WWV or GPS)
- *	    must supply functions here, even if the function just returns
- *	    ENOSYS.  The standard POSIX timer management code assumes the
- *	    following: 1.) The k_itimer struct (sched.h) is used for the
- *	    timer.  2.) The list, it_lock, it_clock, it_id and it_pid
- *	    fields are not modified by timer code.
+ * FUNCTIONS: The CLOCKs structure defines possible functions to
+ *	    handle various clock functions.
  *
- *          At this time all functions EXCEPT clock_nanosleep can be
- *          redirected by the CLOCKS structure.  Clock_nanosleep is in
- *          there, but the code ignores it.
+ *	    The standard POSIX timer management code assumes the
+ *	    following: 1.) The k_itimer struct (sched.h) is used for
+ *	    the timer.  2.) The list, it_lock, it_clock, it_id and
+ *	    it_pid fields are not modified by timer code.
  *
  * Permissions: It is assumed that the clock_settime() function defined
  *	    for each clock will take care of permission checks.	 Some
@@ -138,6 +136,7 @@ static struct k_clock posix_clocks[MAX_CLOCKS];
  */
 static int common_nsleep(const clockid_t, int flags, struct timespec *t,
 			 struct timespec __user *rmtp);
+static int common_timer_create(struct k_itimer *new_timer);
 static void common_timer_get(struct k_itimer *, struct itimerspec *);
 static int common_timer_set(struct k_itimer *, int,
 			    struct itimerspec *, struct itimerspec *);
@@ -158,76 +157,24 @@ static inline void unlock_timer(struct k_itimer *timr, unsigned long flags)
 	spin_unlock_irqrestore(&timr->it_lock, flags);
 }
 
-/*
- * Call the k_clock hook function if non-null, or the default function.
- */
-#define CLOCK_DISPATCH(clock, call, arglist) \
- 	((clock) < 0 ? posix_cpu_##call arglist : \
- 	 (posix_clocks[clock].call != NULL \
- 	  ? (*posix_clocks[clock].call) arglist : common_##call arglist))
-
-/*
- * Default clock hook functions when the struct k_clock passed
- * to register_posix_clock leaves a function pointer null.
- *
- * The function common_CALL is the default implementation for
- * the function pointer CALL in struct k_clock.
- */
-
-static inline int common_clock_getres(const clockid_t which_clock,
-				      struct timespec *tp)
-{
-	tp->tv_sec = 0;
-	tp->tv_nsec = posix_clocks[which_clock].res;
-	return 0;
-}
-
-/*
- * Get real time for posix timers
- */
-static int common_clock_get(clockid_t which_clock, struct timespec *tp)
+/* Get clock_realtime */
+static int posix_clock_realtime_get(clockid_t which_clock, struct timespec *tp)
 {
 	ktime_get_real_ts(tp);
 	return 0;
 }
 
-static inline int common_clock_set(const clockid_t which_clock,
-				   struct timespec *tp)
+/* Set clock_realtime */
+static int posix_clock_realtime_set(const clockid_t which_clock,
+				    const struct timespec *tp)
 {
 	return do_sys_settimeofday(tp, NULL);
 }
 
-static int common_timer_create(struct k_itimer *new_timer)
-{
-	hrtimer_init(&new_timer->it.real.timer, new_timer->it_clock, 0);
-	return 0;
-}
-
-static int no_timer_create(struct k_itimer *new_timer)
-{
-	return -EOPNOTSUPP;
-}
-
-static int no_nsleep(const clockid_t which_clock, int flags,
-		     struct timespec *tsave, struct timespec __user *rmtp)
-{
-	return -EOPNOTSUPP;
-}
-
-/*
- * Return nonzero if we know a priori this clockid_t value is bogus.
- */
-static inline int invalid_clockid(const clockid_t which_clock)
+static int posix_clock_realtime_adj(const clockid_t which_clock,
+				    struct timex *t)
 {
-	if (which_clock < 0)	/* CPU clock, posix_cpu_* will check it */
-		return 0;
-	if ((unsigned) which_clock >= MAX_CLOCKS)
-		return 1;
-	if (posix_clocks[which_clock].clock_getres != NULL)
-		return 0;
-	if (posix_clocks[which_clock].res != 0)
-		return 0;
-	return 1;
+	return do_adjtimex(t);
 }
 
 /*
@@ -240,7 +187,7 @@ static int posix_ktime_get_ts(clockid_t which_clock, struct timespec *tp)
 }
 
 /*
- * Get monotonic time for posix timers
+ * Get monotonic-raw time for posix timers
  */
 static int posix_get_monotonic_raw(clockid_t which_clock, struct timespec *tp)
 {
@@ -267,46 +214,70 @@ static int posix_get_coarse_res(const clockid_t which_clock, struct timespec *tp
 	*tp = ktime_to_timespec(KTIME_LOW_RES);
 	return 0;
 }
+
+static int posix_get_boottime(const clockid_t which_clock, struct timespec *tp)
+{
+	get_monotonic_boottime(tp);
+	return 0;
+}
+
+
 /*
  * Initialize everything, well, just everything in Posix clocks/timers ;)
  */
 static __init int init_posix_timers(void)
 {
 	struct k_clock clock_realtime = {
-		.clock_getres = hrtimer_get_res,
+		.clock_getres	= hrtimer_get_res,
+		.clock_get	= posix_clock_realtime_get,
+		.clock_set	= posix_clock_realtime_set,
+		.clock_adj	= posix_clock_realtime_adj,
+		.nsleep		= common_nsleep,
+		.nsleep_restart	= hrtimer_nanosleep_restart,
+		.timer_create	= common_timer_create,
+		.timer_set	= common_timer_set,
+		.timer_get	= common_timer_get,
+		.timer_del	= common_timer_del,
 	};
 	struct k_clock clock_monotonic = {
-		.clock_getres = hrtimer_get_res,
-		.clock_get = posix_ktime_get_ts,
-		.clock_set = do_posix_clock_nosettime,
+		.clock_getres	= hrtimer_get_res,
+		.clock_get	= posix_ktime_get_ts,
+		.nsleep		= common_nsleep,
+		.nsleep_restart	= hrtimer_nanosleep_restart,
+		.timer_create	= common_timer_create,
+		.timer_set	= common_timer_set,
+		.timer_get	= common_timer_get,
+		.timer_del	= common_timer_del,
 	};
 	struct k_clock clock_monotonic_raw = {
-		.clock_getres = hrtimer_get_res,
-		.clock_get = posix_get_monotonic_raw,
-		.clock_set = do_posix_clock_nosettime,
-		.timer_create = no_timer_create,
-		.nsleep = no_nsleep,
+		.clock_getres	= hrtimer_get_res,
+		.clock_get	= posix_get_monotonic_raw,
 	};
 	struct k_clock clock_realtime_coarse = {
-		.clock_getres = posix_get_coarse_res,
-		.clock_get = posix_get_realtime_coarse,
-		.clock_set = do_posix_clock_nosettime,
-		.timer_create = no_timer_create,
-		.nsleep = no_nsleep,
+		.clock_getres	= posix_get_coarse_res,
+		.clock_get	= posix_get_realtime_coarse,
 	};
 	struct k_clock clock_monotonic_coarse = {
-		.clock_getres = posix_get_coarse_res,
-		.clock_get = posix_get_monotonic_coarse,
-		.clock_set = do_posix_clock_nosettime,
-		.timer_create = no_timer_create,
-		.nsleep = no_nsleep,
+		.clock_getres	= posix_get_coarse_res,
+		.clock_get	= posix_get_monotonic_coarse,
+	};
+	struct k_clock clock_boottime = {
+		.clock_getres	= hrtimer_get_res,
+		.clock_get	= posix_get_boottime,
+		.nsleep		= common_nsleep,
+		.nsleep_restart	= hrtimer_nanosleep_restart,
+		.timer_create	= common_timer_create,
+		.timer_set	= common_timer_set,
+		.timer_get	= common_timer_get,
+		.timer_del	= common_timer_del,
 	};
 
-	register_posix_clock(CLOCK_REALTIME, &clock_realtime);
-	register_posix_clock(CLOCK_MONOTONIC, &clock_monotonic);
-	register_posix_clock(CLOCK_MONOTONIC_RAW, &clock_monotonic_raw);
-	register_posix_clock(CLOCK_REALTIME_COARSE, &clock_realtime_coarse);
-	register_posix_clock(CLOCK_MONOTONIC_COARSE, &clock_monotonic_coarse);
+	posix_timers_register_clock(CLOCK_REALTIME, &clock_realtime);
+	posix_timers_register_clock(CLOCK_MONOTONIC, &clock_monotonic);
+	posix_timers_register_clock(CLOCK_MONOTONIC_RAW, &clock_monotonic_raw);
+	posix_timers_register_clock(CLOCK_REALTIME_COARSE, &clock_realtime_coarse);
+	posix_timers_register_clock(CLOCK_MONOTONIC_COARSE, &clock_monotonic_coarse);
+	posix_timers_register_clock(CLOCK_BOOTTIME, &clock_boottime);
 
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
 					sizeof (struct k_itimer), 0, SLAB_PANIC,
@@ -482,17 +453,29 @@ static struct pid *good_sigevent(sigevent_t * event)
 	return task_pid(rtn);
 }
 
-void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock)
+void posix_timers_register_clock(const clockid_t clock_id,
+				 struct k_clock *new_clock)
 {
 	if ((unsigned) clock_id >= MAX_CLOCKS) {
-		printk("POSIX clock register failed for clock_id %d\n",
+		printk(KERN_WARNING "POSIX clock register failed for clock_id %d\n",
+		       clock_id);
+		return;
+	}
+
+	if (!new_clock->clock_get) {
+		printk(KERN_WARNING "POSIX clock id %d lacks clock_get()\n",
+		       clock_id);
+		return;
+	}
+	if (!new_clock->clock_getres) {
+		printk(KERN_WARNING "POSIX clock id %d lacks clock_getres()\n",
 		       clock_id);
 		return;
 	}
 
 	posix_clocks[clock_id] = *new_clock;
 }
-EXPORT_SYMBOL_GPL(register_posix_clock);
+EXPORT_SYMBOL_GPL(posix_timers_register_clock);
 
 static struct k_itimer * alloc_posix_timer(void)
 {
@@ -523,19 +506,39 @@ static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 	kmem_cache_free(posix_timers_cache, tmr);
 }
 
+static struct k_clock *clockid_to_kclock(const clockid_t id)
+{
+	if (id < 0)
+		return (id & CLOCKFD_MASK) == CLOCKFD ?
+			&clock_posix_dynamic : &clock_posix_cpu;
+
+	if (id >= MAX_CLOCKS || !posix_clocks[id].clock_getres)
+		return NULL;
+	return &posix_clocks[id];
+}
+
+static int common_timer_create(struct k_itimer *new_timer)
+{
+	hrtimer_init(&new_timer->it.real.timer, new_timer->it_clock, 0);
+	return 0;
+}
+
 /* Create a POSIX.1b interval timer. */
 
 SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 		struct sigevent __user *, timer_event_spec,
 		timer_t __user *, created_timer_id)
 {
+	struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct k_itimer *new_timer;
 	int error, new_timer_id;
 	sigevent_t event;
 	int it_id_set = IT_ID_NOT_SET;
 
-	if (invalid_clockid(which_clock))
+	if (!kc)
 		return -EINVAL;
+	if (!kc->timer_create)
+		return -EOPNOTSUPP;
 
 	new_timer = alloc_posix_timer();
 	if (unlikely(!new_timer))
@@ -597,7 +600,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 		goto out;
 	}
 
-	error = CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
+	error = kc->timer_create(new_timer);
 	if (error)
 		goto out;
 
@@ -607,7 +610,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 	spin_unlock_irq(&current->sighand->siglock);
 
 	return 0;
- 	/*
+	/*
 	 * In the case of the timer belonging to another task, after
 	 * the task is unlocked, the timer is owned by the other task
 	 * and may cease to exist at any time.  Don't use or modify
@@ -709,22 +712,28 @@ common_timer_get(struct k_itimer *timr, struct itimerspec *cur_setting)
 SYSCALL_DEFINE2(timer_gettime, timer_t, timer_id,
 		struct itimerspec __user *, setting)
 {
-	struct k_itimer *timr;
 	struct itimerspec cur_setting;
+	struct k_itimer *timr;
+	struct k_clock *kc;
 	unsigned long flags;
+	int ret = 0;
 
 	timr = lock_timer(timer_id, &flags);
 	if (!timr)
 		return -EINVAL;
 
-	CLOCK_DISPATCH(timr->it_clock, timer_get, (timr, &cur_setting));
+	kc = clockid_to_kclock(timr->it_clock);
+	if (WARN_ON_ONCE(!kc || !kc->timer_get))
+		ret = -EINVAL;
+	else
+		kc->timer_get(timr, &cur_setting);
 
 	unlock_timer(timr, flags);
 
-	if (copy_to_user(setting, &cur_setting, sizeof (cur_setting)))
+	if (!ret && copy_to_user(setting, &cur_setting, sizeof (cur_setting)))
 		return -EFAULT;
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -813,6 +822,7 @@ SYSCALL_DEFINE4(timer_settime, timer_t, timer_id, int, flags,
 	int error = 0;
 	unsigned long flag;
 	struct itimerspec *rtn = old_setting ? &old_spec : NULL;
+	struct k_clock *kc;
 
 	if (!new_setting)
 		return -EINVAL;
@@ -828,8 +838,11 @@ retry:
 	if (!timr)
 		return -EINVAL;
 
-	error = CLOCK_DISPATCH(timr->it_clock, timer_set,
-			       (timr, flags, &new_spec, rtn));
+	kc = clockid_to_kclock(timr->it_clock);
+	if (WARN_ON_ONCE(!kc || !kc->timer_set))
+		error = -EINVAL;
+	else
+		error = kc->timer_set(timr, flags, &new_spec, rtn);
 
 	unlock_timer(timr, flag);
 	if (error == TIMER_RETRY) {
@@ -844,7 +857,7 @@ retry:
 	return error;
 }
 
-static inline int common_timer_del(struct k_itimer *timer)
+static int common_timer_del(struct k_itimer *timer)
 {
 	timer->it.real.interval.tv64 = 0;
 
@@ -855,7 +868,11 @@ static inline int common_timer_del(struct k_itimer *timer)
 
 static inline int timer_delete_hook(struct k_itimer *timer)
 {
-	return CLOCK_DISPATCH(timer->it_clock, timer_del, (timer));
+	struct k_clock *kc = clockid_to_kclock(timer->it_clock);
+
+	if (WARN_ON_ONCE(!kc || !kc->timer_del))
+		return -EINVAL;
+	return kc->timer_del(timer);
 }
 
 /* Delete a POSIX.1b interval timer. */
@@ -927,69 +944,76 @@ void exit_itimers(struct signal_struct *sig)
 	}
 }
 
-/* Not available / possible... functions */
-int do_posix_clock_nosettime(const clockid_t clockid, struct timespec *tp)
-{
-	return -EINVAL;
-}
-EXPORT_SYMBOL_GPL(do_posix_clock_nosettime);
-
-int do_posix_clock_nonanosleep(const clockid_t clock, int flags,
-			       struct timespec *t, struct timespec __user *r)
-{
-#ifndef ENOTSUP
-	return -EOPNOTSUPP;	/* aka ENOTSUP in userland for POSIX */
-#else  /*  parisc does define it separately.  */
-	return -ENOTSUP;
-#endif
-}
-EXPORT_SYMBOL_GPL(do_posix_clock_nonanosleep);
-
 SYSCALL_DEFINE2(clock_settime, const clockid_t, which_clock,
 		const struct timespec __user *, tp)
 {
+	struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec new_tp;
 
-	if (invalid_clockid(which_clock))
+	if (!kc || !kc->clock_set)
 		return -EINVAL;
+
 	if (copy_from_user(&new_tp, tp, sizeof (*tp)))
 		return -EFAULT;
 
-	return CLOCK_DISPATCH(which_clock, clock_set, (which_clock, &new_tp));
+	return kc->clock_set(which_clock, &new_tp);
 }
 
 SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
 		struct timespec __user *,tp)
 {
+	struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec kernel_tp;
 	int error;
 
-	if (invalid_clockid(which_clock))
+	if (!kc)
 		return -EINVAL;
-	error = CLOCK_DISPATCH(which_clock, clock_get,
-			       (which_clock, &kernel_tp));
+
+	error = kc->clock_get(which_clock, &kernel_tp);
+
 	if (!error && copy_to_user(tp, &kernel_tp, sizeof (kernel_tp)))
 		error = -EFAULT;
 
 	return error;
+}
+
+SYSCALL_DEFINE2(clock_adjtime, const clockid_t, which_clock,
+		struct timex __user *, utx)
+{
+	struct k_clock *kc = clockid_to_kclock(which_clock);
+	struct timex ktx;
+	int err;
+
+	if (!kc)
+		return -EINVAL;
+	if (!kc->clock_adj)
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&ktx, utx, sizeof(ktx)))
+		return -EFAULT;
+
+	err = kc->clock_adj(which_clock, &ktx);
+
+	if (!err && copy_to_user(utx, &ktx, sizeof(ktx)))
+		return -EFAULT;
 
+	return err;
 }
 
 SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock,
 		struct timespec __user *, tp)
 {
+	struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec rtn_tp;
 	int error;
 
-	if (invalid_clockid(which_clock))
+	if (!kc)
 		return -EINVAL;
 
-	error = CLOCK_DISPATCH(which_clock, clock_getres,
-			       (which_clock, &rtn_tp));
+	error = kc->clock_getres(which_clock, &rtn_tp);
 
-	if (!error && tp && copy_to_user(tp, &rtn_tp, sizeof (rtn_tp))) {
+	if (!error && tp && copy_to_user(tp, &rtn_tp, sizeof (rtn_tp)))
 		error = -EFAULT;
-	}
 
 	return error;
 }
@@ -1009,10 +1033,13 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 		const struct timespec __user *, rqtp,
 		struct timespec __user *, rmtp)
 {
+	struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec t;
 
-	if (invalid_clockid(which_clock))
+	if (!kc)
 		return -EINVAL;
+	if (!kc->nsleep)
+		return -ENANOSLEEP_NOTSUP;
 
 	if (copy_from_user(&t, rqtp, sizeof (struct timespec)))
 		return -EFAULT;
@@ -1020,27 +1047,20 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 	if (!timespec_valid(&t))
 		return -EINVAL;
 
-	return CLOCK_DISPATCH(which_clock, nsleep,
-			      (which_clock, flags, &t, rmtp));
-}
-
-/*
- * nanosleep_restart for monotonic and realtime clocks
- */
-static int common_nsleep_restart(struct restart_block *restart_block)
-{
-	return hrtimer_nanosleep_restart(restart_block);
+	return kc->nsleep(which_clock, flags, &t, rmtp);
 }
 
 /*
  * This will restart clock_nanosleep. This is required only by
  * compat_clock_nanosleep_restart for now.
  */
-long
-clock_nanosleep_restart(struct restart_block *restart_block)
+long clock_nanosleep_restart(struct restart_block *restart_block)
 {
-	clockid_t which_clock = restart_block->arg0;
+	clockid_t which_clock = restart_block->nanosleep.index;
+	struct k_clock *kc = clockid_to_kclock(which_clock);
+
+	if (WARN_ON_ONCE(!kc || !kc->nsleep_restart))
+		return -EINVAL;
 
-	return CLOCK_DISPATCH(which_clock, nsleep_restart,
-			      (restart_block));
+	return kc->nsleep_restart(restart_block);
 }
diff --git a/kernel/time.c b/kernel/time.c
index 3217435..5cb8053 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -150,7 +150,7 @@ static inline void warp_clock(void)
  * various programs will get confused when the clock gets warped.
  */
 
-int do_sys_settimeofday(struct timespec *tv, struct timezone *tz)
+int do_sys_settimeofday(const struct timespec *tv, const struct timezone *tz)
 {
 	static int firsttime = 1;
 	int error = 0;
@@ -674,23 +674,6 @@ unsigned long nsecs_to_jiffies(u64 n)
 #endif
 }
 
-#if (BITS_PER_LONG < 64)
-u64 get_jiffies_64(void)
-{
-	unsigned long seq;
-	u64 ret;
-
-	do {
-		seq = read_seqbegin(&xtime_lock);
-		ret = jiffies_64;
-	} while (read_seqretry(&xtime_lock, seq));
-	return ret;
-}
-EXPORT_SYMBOL(get_jiffies_64);
-#endif
-
-EXPORT_SYMBOL(jiffies);
-
 /*
  * Add two timespec values and do a safety check for overflow.
  * It's assumed that both values are valid (>= 0)
diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index ee26662..b042599 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -1,4 +1,5 @@
-obj-y += timekeeping.o ntp.o clocksource.o jiffies.o timer_list.o timecompare.o timeconv.o
+obj-y += timekeeping.o ntp.o clocksource.o jiffies.o timer_list.o timecompare.o
+obj-y += timeconv.o posix-clock.o
 
 obj-$(CONFIG_GENERIC_CLOCKEVENTS_BUILD)		+= clockevents.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= tick-common.o
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index d7395fd..0d74b9b 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -18,7 +18,6 @@
 #include <linux/notifier.h>
 #include <linux/smp.h>
 #include <linux/sysdev.h>
-#include <linux/tick.h>
 
 #include "tick-internal.h"
 
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index 5404a84..b2fa506 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -22,8 +22,11 @@
 ************************************************************************/
 #include <linux/clocksource.h>
 #include <linux/jiffies.h>
+#include <linux/module.h>
 #include <linux/init.h>
 
+#include "tick-internal.h"
+
 /* The Jiffies based clocksource is the lowest common
  * denominator clock source which should function on
  * all systems. It has the same coarse resolution as
@@ -64,6 +67,23 @@ struct clocksource clocksource_jiffies = {
 	.shift		= JIFFIES_SHIFT,
 };
 
+#if (BITS_PER_LONG < 64)
+u64 get_jiffies_64(void)
+{
+	unsigned long seq;
+	u64 ret;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		ret = jiffies_64;
+	} while (read_seqretry(&xtime_lock, seq));
+	return ret;
+}
+EXPORT_SYMBOL(get_jiffies_64);
+#endif
+
+EXPORT_SYMBOL(jiffies);
+
 static int __init init_jiffies_clocksource(void)
 {
 	return clocksource_register(&clocksource_jiffies);
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 5c00242..5f1bb8e 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -16,6 +16,8 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 
+#include "tick-internal.h"
+
 /*
  * NTP timekeeping variables:
  */
@@ -646,6 +648,17 @@ int do_adjtimex(struct timex *txc)
 			hrtimer_cancel(&leap_timer);
 	}
 
+	if (txc->modes & ADJ_SETOFFSET) {
+		struct timespec delta;
+		delta.tv_sec  = txc->time.tv_sec;
+		delta.tv_nsec = txc->time.tv_usec;
+		if (!(txc->modes & ADJ_NANO))
+			delta.tv_nsec *= 1000;
+		result = timekeeping_inject_offset(&delta);
+		if (result)
+			return result;
+	}
+
 	getnstimeofday(&ts);
 
 	write_seqlock_irq(&xtime_lock);
diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
new file mode 100644
index 0000000..25028dd
--- /dev/null
+++ b/kernel/time/posix-clock.c
@@ -0,0 +1,451 @@
+/*
+ * posix-clock.c - support for dynamic clock devices
+ *
+ * Copyright (C) 2010 OMICRON electronics GmbH
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/device.h>
+#include <linux/file.h>
+#include <linux/mutex.h>
+#include <linux/posix-clock.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+
+static void delete_clock(struct kref *kref);
+
+/*
+ * Returns NULL if the posix_clock instance attached to 'fp' is old and stale.
+ */
+static struct posix_clock *get_posix_clock(struct file *fp)
+{
+	struct posix_clock *clk = fp->private_data;
+
+	mutex_lock(&clk->mutex);
+
+	if (!clk->zombie)
+		return clk;
+
+	mutex_unlock(&clk->mutex);
+
+	return NULL;
+}
+
+static void put_posix_clock(struct posix_clock *clk)
+{
+	mutex_unlock(&clk->mutex);
+}
+
+static ssize_t posix_clock_read(struct file *fp, char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct posix_clock *clk = get_posix_clock(fp);
+	int err = -EINVAL;
+
+	if (!clk)
+		return -ENODEV;
+
+	if (clk->ops.read)
+		err = clk->ops.read(clk, fp->f_flags, buf, count);
+
+	put_posix_clock(clk);
+
+	return err;
+}
+
+static unsigned int posix_clock_poll(struct file *fp, poll_table *wait)
+{
+	struct posix_clock *clk = get_posix_clock(fp);
+	int result = 0;
+
+	if (!clk)
+		return -ENODEV;
+
+	if (clk->ops.poll)
+		result = clk->ops.poll(clk, fp, wait);
+
+	put_posix_clock(clk);
+
+	return result;
+}
+
+static int posix_clock_fasync(int fd, struct file *fp, int on)
+{
+	struct posix_clock *clk = get_posix_clock(fp);
+	int err = 0;
+
+	if (!clk)
+		return -ENODEV;
+
+	if (clk->ops.fasync)
+		err = clk->ops.fasync(clk, fd, fp, on);
+
+	put_posix_clock(clk);
+
+	return err;
+}
+
+static int posix_clock_mmap(struct file *fp, struct vm_area_struct *vma)
+{
+	struct posix_clock *clk = get_posix_clock(fp);
+	int err = -ENODEV;
+
+	if (!clk)
+		return -ENODEV;
+
+	if (clk->ops.mmap)
+		err = clk->ops.mmap(clk, vma);
+
+	put_posix_clock(clk);
+
+	return err;
+}
+
+static long posix_clock_ioctl(struct file *fp,
+			      unsigned int cmd, unsigned long arg)
+{
+	struct posix_clock *clk = get_posix_clock(fp);
+	int err = -ENOTTY;
+
+	if (!clk)
+		return -ENODEV;
+
+	if (clk->ops.ioctl)
+		err = clk->ops.ioctl(clk, cmd, arg);
+
+	put_posix_clock(clk);
+
+	return err;
+}
+
+#ifdef CONFIG_COMPAT
+static long posix_clock_compat_ioctl(struct file *fp,
+				     unsigned int cmd, unsigned long arg)
+{
+	struct posix_clock *clk = get_posix_clock(fp);
+	int err = -ENOTTY;
+
+	if (!clk)
+		return -ENODEV;
+
+	if (clk->ops.ioctl)
+		err = clk->ops.ioctl(clk, cmd, arg);
+
+	put_posix_clock(clk);
+
+	return err;
+}
+#endif
+
+static int posix_clock_open(struct inode *inode, struct file *fp)
+{
+	int err;
+	struct posix_clock *clk =
+		container_of(inode->i_cdev, struct posix_clock, cdev);
+
+	mutex_lock(&clk->mutex);
+
+	if (clk->zombie) {
+		err = -ENODEV;
+		goto out;
+	}
+	if (clk->ops.open)
+		err = clk->ops.open(clk, fp->f_mode);
+	else
+		err = 0;
+
+	if (!err) {
+		kref_get(&clk->kref);
+		fp->private_data = clk;
+	}
+out:
+	mutex_unlock(&clk->mutex);
+	return err;
+}
+
+static int posix_clock_release(struct inode *inode, struct file *fp)
+{
+	struct posix_clock *clk = fp->private_data;
+	int err = 0;
+
+	if (clk->ops.release)
+		err = clk->ops.release(clk);
+
+	kref_put(&clk->kref, delete_clock);
+
+	fp->private_data = NULL;
+
+	return err;
+}
+
+static const struct file_operations posix_clock_file_operations = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.read		= posix_clock_read,
+	.poll		= posix_clock_poll,
+	.unlocked_ioctl	= posix_clock_ioctl,
+	.open		= posix_clock_open,
+	.release	= posix_clock_release,
+	.fasync		= posix_clock_fasync,
+	.mmap		= posix_clock_mmap,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= posix_clock_compat_ioctl,
+#endif
+};
+
+int posix_clock_register(struct posix_clock *clk, dev_t devid)
+{
+	int err;
+
+	kref_init(&clk->kref);
+	mutex_init(&clk->mutex);
+
+	cdev_init(&clk->cdev, &posix_clock_file_operations);
+	clk->cdev.owner = clk->ops.owner;
+	err = cdev_add(&clk->cdev, devid, 1);
+	if (err)
+		goto no_cdev;
+
+	return err;
+no_cdev:
+	mutex_destroy(&clk->mutex);
+	return err;
+}
+EXPORT_SYMBOL_GPL(posix_clock_register);
+
+static void delete_clock(struct kref *kref)
+{
+	struct posix_clock *clk = container_of(kref, struct posix_clock, kref);
+	mutex_destroy(&clk->mutex);
+	if (clk->release)
+		clk->release(clk);
+}
+
+void posix_clock_unregister(struct posix_clock *clk)
+{
+	cdev_del(&clk->cdev);
+
+	mutex_lock(&clk->mutex);
+	clk->zombie = true;
+	mutex_unlock(&clk->mutex);
+
+	kref_put(&clk->kref, delete_clock);
+}
+EXPORT_SYMBOL_GPL(posix_clock_unregister);
+
+struct posix_clock_desc {
+	struct file *fp;
+	struct posix_clock *clk;
+};
+
+static int get_clock_desc(const clockid_t id, struct posix_clock_desc *cd)
+{
+	struct file *fp = fget(CLOCKID_TO_FD(id));
+	int err = -EINVAL;
+
+	if (!fp)
+		return err;
+
+	if (fp->f_op->open != posix_clock_open || !fp->private_data)
+		goto out;
+
+	cd->fp = fp;
+	cd->clk = get_posix_clock(fp);
+
+	err = cd->clk ? 0 : -ENODEV;
+out:
+	if (err)
+		fput(fp);
+	return err;
+}
+
+static void put_clock_desc(struct posix_clock_desc *cd)
+{
+	put_posix_clock(cd->clk);
+	fput(cd->fp);
+}
+
+static int pc_clock_adjtime(clockid_t id, struct timex *tx)
+{
+	struct posix_clock_desc cd;
+	int err;
+
+	err = get_clock_desc(id, &cd);
+	if (err)
+		return err;
+
+	if ((cd.fp->f_mode & FMODE_WRITE) == 0) {
+		err = -EACCES;
+		goto out;
+	}
+
+	if (cd.clk->ops.clock_adjtime)
+		err = cd.clk->ops.clock_adjtime(cd.clk, tx);
+	else
+		err = -EOPNOTSUPP;
+out:
+	put_clock_desc(&cd);
+
+	return err;
+}
+
+static int pc_clock_gettime(clockid_t id, struct timespec *ts)
+{
+	struct posix_clock_desc cd;
+	int err;
+
+	err = get_clock_desc(id, &cd);
+	if (err)
+		return err;
+
+	if (cd.clk->ops.clock_gettime)
+		err = cd.clk->ops.clock_gettime(cd.clk, ts);
+	else
+		err = -EOPNOTSUPP;
+
+	put_clock_desc(&cd);
+
+	return err;
+}
+
+static int pc_clock_getres(clockid_t id, struct timespec *ts)
+{
+	struct posix_clock_desc cd;
+	int err;
+
+	err = get_clock_desc(id, &cd);
+	if (err)
+		return err;
+
+	if (cd.clk->ops.clock_getres)
+		err = cd.clk->ops.clock_getres(cd.clk, ts);
+	else
+		err = -EOPNOTSUPP;
+
+	put_clock_desc(&cd);
+
+	return err;
+}
+
+static int pc_clock_settime(clockid_t id, const struct timespec *ts)
+{
+	struct posix_clock_desc cd;
+	int err;
+
+	err = get_clock_desc(id, &cd);
+	if (err)
+		return err;
+
+	if ((cd.fp->f_mode & FMODE_WRITE) == 0) {
+		err = -EACCES;
+		goto out;
+	}
+
+	if (cd.clk->ops.clock_settime)
+		err = cd.clk->ops.clock_settime(cd.clk, ts);
+	else
+		err = -EOPNOTSUPP;
+out:
+	put_clock_desc(&cd);
+
+	return err;
+}
+
+static int pc_timer_create(struct k_itimer *kit)
+{
+	clockid_t id = kit->it_clock;
+	struct posix_clock_desc cd;
+	int err;
+
+	err = get_clock_desc(id, &cd);
+	if (err)
+		return err;
+
+	if (cd.clk->ops.timer_create)
+		err = cd.clk->ops.timer_create(cd.clk, kit);
+	else
+		err = -EOPNOTSUPP;
+
+	put_clock_desc(&cd);
+
+	return err;
+}
+
+static int pc_timer_delete(struct k_itimer *kit)
+{
+	clockid_t id = kit->it_clock;
+	struct posix_clock_desc cd;
+	int err;
+
+	err = get_clock_desc(id, &cd);
+	if (err)
+		return err;
+
+	if (cd.clk->ops.timer_delete)
+		err = cd.clk->ops.timer_delete(cd.clk, kit);
+	else
+		err = -EOPNOTSUPP;
+
+	put_clock_desc(&cd);
+
+	return err;
+}
+
+static void pc_timer_gettime(struct k_itimer *kit, struct itimerspec *ts)
+{
+	clockid_t id = kit->it_clock;
+	struct posix_clock_desc cd;
+
+	if (get_clock_desc(id, &cd))
+		return;
+
+	if (cd.clk->ops.timer_gettime)
+		cd.clk->ops.timer_gettime(cd.clk, kit, ts);
+
+	put_clock_desc(&cd);
+}
+
+static int pc_timer_settime(struct k_itimer *kit, int flags,
+			    struct itimerspec *ts, struct itimerspec *old)
+{
+	clockid_t id = kit->it_clock;
+	struct posix_clock_desc cd;
+	int err;
+
+	err = get_clock_desc(id, &cd);
+	if (err)
+		return err;
+
+	if (cd.clk->ops.timer_settime)
+		err = cd.clk->ops.timer_settime(cd.clk, kit, flags, ts, old);
+	else
+		err = -EOPNOTSUPP;
+
+	put_clock_desc(&cd);
+
+	return err;
+}
+
+struct k_clock clock_posix_dynamic = {
+	.clock_getres	= pc_clock_getres,
+	.clock_set	= pc_clock_settime,
+	.clock_get	= pc_clock_gettime,
+	.clock_adj	= pc_clock_adjtime,
+	.timer_create	= pc_timer_create,
+	.timer_set	= pc_timer_settime,
+	.timer_del	= pc_timer_delete,
+	.timer_get	= pc_timer_gettime,
+};
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 48b2761..92ef9a5 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -18,7 +18,6 @@
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
-#include <linux/tick.h>
 
 #include "tick-internal.h"
 
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 051bc80..0e98fac 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -18,7 +18,6 @@
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
-#include <linux/tick.h>
 
 #include <asm/irq_regs.h>
 
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 290eefb..f77b93d 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -1,6 +1,10 @@
 /*
  * tick internal variable and functions used by low/high res code
  */
+#include <linux/hrtimer.h>
+#include <linux/tick.h>
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS_BUILD
 
 #define TICK_DO_TIMER_NONE	-1
 #define TICK_DO_TIMER_BOOT	-2
@@ -132,3 +136,8 @@ static inline int tick_device_is_functional(struct clock_event_device *dev)
 {
 	return !(dev->features & CLOCK_EVT_FEAT_DUMMY);
 }
+
+#endif
+
+extern void do_timer(unsigned long ticks);
+extern seqlock_t xtime_lock;
diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index 5cbc101..2d04411 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -18,7 +18,6 @@
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
-#include <linux/tick.h>
 
 #include "tick-internal.h"
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index c55ea24..d5097c4 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -19,7 +19,6 @@
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
-#include <linux/tick.h>
 #include <linux/module.h>
 
 #include <asm/irq_regs.h>
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index d27c756..3bd7e3d 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -353,7 +353,7 @@ EXPORT_SYMBOL(do_gettimeofday);
  *
  * Sets the time of day to the new time and update NTP and notify hrtimers
  */
-int do_settimeofday(struct timespec *tv)
+int do_settimeofday(const struct timespec *tv)
 {
 	struct timespec ts_delta;
 	unsigned long flags;
@@ -387,6 +387,42 @@ int do_settimeofday(struct timespec *tv)
 
 EXPORT_SYMBOL(do_settimeofday);
 
+
+/**
+ * timekeeping_inject_offset - Adds or subtracts from the current time.
+ * @tv:		pointer to the timespec variable containing the offset
+ *
+ * Adds or subtracts an offset value from the current time.
+ */
+int timekeeping_inject_offset(struct timespec *ts)
+{
+	unsigned long flags;
+
+	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
+		return -EINVAL;
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+
+	timekeeping_forward_now();
+
+	xtime = timespec_add(xtime, *ts);
+	wall_to_monotonic = timespec_sub(wall_to_monotonic, *ts);
+
+	timekeeper.ntp_error = 0;
+	ntp_clear();
+
+	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
+				timekeeper.mult);
+
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	/* signal hrtimers about time change */
+	clock_was_set();
+
+	return 0;
+}
+EXPORT_SYMBOL(timekeeping_inject_offset);
+
 /**
  * change_clocksource - Swaps clocksources if a new one is available
  *
@@ -779,7 +815,7 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
  *
  * Called from the timer interrupt, must hold a write on xtime_lock.
  */
-void update_wall_time(void)
+static void update_wall_time(void)
 {
 	struct clocksource *clock;
 	cycle_t offset;
@@ -871,7 +907,7 @@ void update_wall_time(void)
  * getboottime - Return the real time of system boot.
  * @ts:		pointer to the timespec to be set
  *
- * Returns the time of day in a timespec.
+ * Returns the wall-time of boot in a timespec.
  *
  * This is based on the wall_to_monotonic offset and the total suspend
  * time. Calls to settimeofday will affect the value returned (which
@@ -889,6 +925,55 @@ void getboottime(struct timespec *ts)
 }
 EXPORT_SYMBOL_GPL(getboottime);
 
+
+/**
+ * get_monotonic_boottime - Returns monotonic time since boot
+ * @ts:		pointer to the timespec to be set
+ *
+ * Returns the monotonic time since boot in a timespec.
+ *
+ * This is similar to CLOCK_MONTONIC/ktime_get_ts, but also
+ * includes the time spent in suspend.
+ */
+void get_monotonic_boottime(struct timespec *ts)
+{
+	struct timespec tomono, sleep;
+	unsigned int seq;
+	s64 nsecs;
+
+	WARN_ON(timekeeping_suspended);
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		*ts = xtime;
+		tomono = wall_to_monotonic;
+		sleep = total_sleep_time;
+		nsecs = timekeeping_get_ns();
+
+	} while (read_seqretry(&xtime_lock, seq));
+
+	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec + sleep.tv_sec,
+			ts->tv_nsec + tomono.tv_nsec + sleep.tv_nsec + nsecs);
+}
+EXPORT_SYMBOL_GPL(get_monotonic_boottime);
+
+/**
+ * ktime_get_boottime - Returns monotonic time since boot in a ktime
+ *
+ * Returns the monotonic time since boot in a ktime
+ *
+ * This is similar to CLOCK_MONTONIC/ktime_get, but also
+ * includes the time spent in suspend.
+ */
+ktime_t ktime_get_boottime(void)
+{
+	struct timespec ts;
+
+	get_monotonic_boottime(&ts);
+	return timespec_to_ktime(ts);
+}
+EXPORT_SYMBOL_GPL(ktime_get_boottime);
+
 /**
  * monotonic_to_bootbased - Convert the monotonic time to boot based.
  * @ts:		pointer to the timespec to be converted
@@ -910,11 +995,6 @@ struct timespec __current_kernel_time(void)
 	return xtime;
 }
 
-struct timespec __get_wall_to_monotonic(void)
-{
-	return wall_to_monotonic;
-}
-
 struct timespec current_kernel_time(void)
 {
 	struct timespec now;
@@ -946,3 +1026,48 @@ struct timespec get_monotonic_coarse(void)
 				now.tv_nsec + mono.tv_nsec);
 	return now;
 }
+
+/*
+ * The 64-bit jiffies value is not atomic - you MUST NOT read it
+ * without sampling the sequence number in xtime_lock.
+ * jiffies is defined in the linker script...
+ */
+void do_timer(unsigned long ticks)
+{
+	jiffies_64 += ticks;
+	update_wall_time();
+	calc_global_load(ticks);
+}
+
+/**
+ * get_xtime_and_monotonic_and_sleep_offset() - get xtime, wall_to_monotonic,
+ *    and sleep offsets.
+ * @xtim:	pointer to timespec to be set with xtime
+ * @wtom:	pointer to timespec to be set with wall_to_monotonic
+ * @sleep:	pointer to timespec to be set with time in suspend
+ */
+void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
+				struct timespec *wtom, struct timespec *sleep)
+{
+	unsigned long seq;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		*xtim = xtime;
+		*wtom = wall_to_monotonic;
+		*sleep = total_sleep_time;
+	} while (read_seqretry(&xtime_lock, seq));
+}
+
+/**
+ * xtime_update() - advances the timekeeping infrastructure
+ * @ticks:	number of ticks, that have elapsed since the last call.
+ *
+ * Must be called with interrupts disabled.
+ */
+void xtime_update(unsigned long ticks)
+{
+	write_seqlock(&xtime_lock);
+	do_timer(ticks);
+	write_sequnlock(&xtime_lock);
+}
diff --git a/kernel/timer.c b/kernel/timer.c
index 43ca993..87f656c 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1293,19 +1293,6 @@ void run_local_timers(void)
 	raise_softirq(TIMER_SOFTIRQ);
 }
 
-/*
- * The 64-bit jiffies value is not atomic - you MUST NOT read it
- * without sampling the sequence number in xtime_lock.
- * jiffies is defined in the linker script...
- */
-
-void do_timer(unsigned long ticks)
-{
-	jiffies_64 += ticks;
-	update_wall_time();
-	calc_global_load(ticks);
-}
-
 #ifdef __ARCH_WANT_SYS_ALARM
 
 /*
diff --git a/security/commoncap.c b/security/commoncap.c
index 64c2ed9..dbfdaed 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -93,7 +93,7 @@ int cap_capable(struct task_struct *tsk, const struct cred *cred, int cap,
  * Determine whether the current process may set the system clock and timezone
  * information, returning 0 if permission granted, -ve if denied.
  */
-int cap_settime(struct timespec *ts, struct timezone *tz)
+int cap_settime(const struct timespec *ts, const struct timezone *tz)
 {
 	if (!capable(CAP_SYS_TIME))
 		return -EPERM;
diff --git a/security/security.c b/security/security.c
index 739e403..b995428 100644
--- a/security/security.c
+++ b/security/security.c
@@ -202,7 +202,7 @@ int security_syslog(int type)
 	return security_ops->syslog(type);
 }
 
-int security_settime(struct timespec *ts, struct timezone *tz)
+int security_settime(const struct timespec *ts, const struct timezone *tz)
 {
 	return security_ops->settime(ts, tz);
 }
