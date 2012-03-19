Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965088Ab2CSQDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:03:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40430 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030530Ab2CSQDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:03:46 -0400
Date: Mon, 19 Mar 2012 17:03:40 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler changes for v3.4
Message-ID: <20120319160340.GA6352@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-core-for-linus

   HEAD: 600e145882802d6ccbfe2c4aea243d97caeb91a9 printk: Make it compile with !CONFIG_PRINTK

 Thanks,

	Ingo

------------------>
Anton Vorontsov (1):
      sched: Turn lock_task_sighand() into a static inline

Diwakar Tundlam (1):
      sched/nohz: Correctly initialize 'next_balance' in 'nohz' idle balancer

Hiroshi Shimamoto (3):
      sched: Move SMP-only variable into the SMP section
      sched: Make initial SCHED_RR timeslace DEF_TIMESLICE
      sched: Clean up parameter passing of proc_sched_autogroup_set_nice()

Nikunj A. Dadhania (1):
      sched: Remove rcu_read_lock/unlock() from select_idle_sibling()

Peter Zijlstra (12):
      sched, block: Unify cache detection
      sched/rt: Keep period timer ticking when rt throttling is active
      sched/rt: Do not throttle when PI boosting
      sched: Move load-balancing arguments into helper struct
      sched: Rename load-balancing fields
      sched: Ditch per cgroup task lists for load-balancing
      sched: Fix load-balance wreckage
      sched: Cleanup cpu_active madness
      printk/sched: Introduce special printk_sched() for those awkward moments
      sched: Update yield() docs
      sched: Fix nohz load accounting -- again!
      printk: Make it compile with !CONFIG_PRINTK

Rakib Mullick (1):
      sched: Remove sched_switch

Salman Qazi (1):
      sched/x86: Fix overflow in cyc2ns_offset

Thomas Gleixner (6):
      sched/rt: Add schedule_preempt_disabled()
      sched/rt: Use schedule_preempt_disabled()
      sched/rt: Document scheduler related skip-resched-check sites
      sched/wait: Add __wake_up_all_locked() API
      sched/rt: Prevent idle task boosting
      sched/rt: Do not submit new work when PI-blocked

Vincent Guittot (1):
      sched: Ensure cpu_power periodic update


 Documentation/scheduler/sched-stats.txt |    3 +-
 arch/arm/kernel/process.c               |    4 +-
 arch/arm/kernel/smp.c                   |    7 -
 arch/avr32/kernel/process.c             |    4 +-
 arch/blackfin/kernel/process.c          |    4 +-
 arch/cris/kernel/process.c              |    4 +-
 arch/frv/kernel/process.c               |    4 +-
 arch/h8300/kernel/process.c             |    4 +-
 arch/hexagon/kernel/smp.c               |    2 -
 arch/ia64/kernel/process.c              |    4 +-
 arch/m32r/kernel/process.c              |    4 +-
 arch/m68k/kernel/process_mm.c           |    4 +-
 arch/m68k/kernel/process_no.c           |    4 +-
 arch/microblaze/kernel/process.c        |    4 +-
 arch/mips/kernel/process.c              |    4 +-
 arch/mn10300/kernel/process.c           |    4 +-
 arch/parisc/kernel/process.c            |    4 +-
 arch/powerpc/kernel/idle.c              |    8 +-
 arch/powerpc/platforms/iseries/setup.c  |    8 +-
 arch/s390/kernel/process.c              |    4 +-
 arch/s390/kernel/smp.c                  |    6 -
 arch/score/kernel/process.c             |    4 +-
 arch/sh/kernel/idle.c                   |    4 +-
 arch/sparc/kernel/process_32.c          |    8 +-
 arch/sparc/kernel/process_64.c          |   10 +-
 arch/tile/kernel/process.c              |    4 +-
 arch/x86/include/asm/timer.h            |    8 +-
 arch/x86/kernel/process_32.c            |    4 +-
 arch/x86/kernel/process_64.c            |    4 +-
 arch/x86/kernel/smpboot.c               |   13 -
 arch/x86/kernel/tsc.c                   |    3 +-
 arch/xtensa/kernel/process.c            |    4 +-
 block/blk-softirq.c                     |   16 +-
 block/blk.h                             |   16 --
 fs/proc/base.c                          |    3 +-
 include/linux/init_task.h               |    2 +-
 include/linux/kernel.h                  |   13 +
 include/linux/preempt.h                 |    5 +-
 include/linux/printk.h                  |   10 +
 include/linux/sched.h                   |   41 +++-
 include/linux/wait.h                    |    5 +-
 init/main.c                             |    5 +-
 kernel/mutex.c                          |    4 +-
 kernel/printk.c                         |   40 +++-
 kernel/sched/auto_group.c               |   12 +-
 kernel/sched/core.c                     |  129 +++++++----
 kernel/sched/debug.c                    |    1 -
 kernel/sched/fair.c                     |  392 ++++++++++++++-----------------
 kernel/sched/rt.c                       |   43 +++-
 kernel/sched/sched.h                    |   15 +-
 kernel/sched/stats.c                    |    4 +-
 kernel/softirq.c                        |    8 +-
 52 files changed, 462 insertions(+), 462 deletions(-)

diff --git a/Documentation/scheduler/sched-stats.txt b/Documentation/scheduler/sched-stats.txt
index 1cd5d51..8259b34 100644
--- a/Documentation/scheduler/sched-stats.txt
+++ b/Documentation/scheduler/sched-stats.txt
@@ -38,7 +38,8 @@ First field is a sched_yield() statistic:
      1) # of times sched_yield() was called
 
 Next three are schedule() statistics:
-     2) # of times we switched to the expired queue and reused it
+     2) This field is a legacy array expiration count field used in the O(1)
+	scheduler. We kept it for ABI compatibility, but it is always set to zero.
      3) # of times schedule() was called
      4) # of times schedule() left the processor idle
 
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 971d65c..c2ae3cd 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -239,9 +239,7 @@ void cpu_idle(void)
 		leds_event(led_idle_end);
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index cdeb727..d616ed5 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -295,13 +295,6 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 	 */
 	percpu_timer_setup();
 
-	while (!cpu_active(cpu))
-		cpu_relax();
-
-	/*
-	 * cpu_active bit is set, so it's safe to enalbe interrupts
-	 * now.
-	 */
 	local_irq_enable();
 	local_fiq_enable();
 
diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index ea33957..92c5af9 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -40,9 +40,7 @@ void cpu_idle(void)
 			cpu_idle_sleep();
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 8dd0416..a80a643 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -94,9 +94,7 @@ void cpu_idle(void)
 			idle();
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/cris/kernel/process.c b/arch/cris/kernel/process.c
index aa585e4..d8f50ff 100644
--- a/arch/cris/kernel/process.c
+++ b/arch/cris/kernel/process.c
@@ -115,9 +115,7 @@ void cpu_idle (void)
 				idle = default_idle;
 			idle();
 		}
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index 3901df1..29cc497 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -92,9 +92,7 @@ void cpu_idle(void)
 				idle();
 		}
 
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
index 933bd38..1a173b3 100644
--- a/arch/h8300/kernel/process.c
+++ b/arch/h8300/kernel/process.c
@@ -81,9 +81,7 @@ void cpu_idle(void)
 	while (1) {
 		while (!need_resched())
 			idle();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/hexagon/kernel/smp.c b/arch/hexagon/kernel/smp.c
index c871a2c..0123c63 100644
--- a/arch/hexagon/kernel/smp.c
+++ b/arch/hexagon/kernel/smp.c
@@ -179,8 +179,6 @@ void __cpuinit start_secondary(void)
 	printk(KERN_INFO "%s cpu %d\n", __func__, current_thread_info()->cpu);
 
 	set_cpu_online(cpu, true);
-	while (!cpumask_test_cpu(cpu, cpu_active_mask))
-		cpu_relax();
 	local_irq_enable();
 
 	cpu_idle();
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index 6d33c5c..9dc52b6 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -330,9 +330,7 @@ cpu_idle (void)
 			normal_xtp();
 #endif
 		}
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 		check_pgt_cache();
 		if (cpu_is_offline(cpu))
 			play_dead();
diff --git a/arch/m32r/kernel/process.c b/arch/m32r/kernel/process.c
index 422bea9..3a4a32b 100644
--- a/arch/m32r/kernel/process.c
+++ b/arch/m32r/kernel/process.c
@@ -90,9 +90,7 @@ void cpu_idle (void)
 
 			idle();
 		}
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/m68k/kernel/process_mm.c b/arch/m68k/kernel/process_mm.c
index 099283e..fe4186b 100644
--- a/arch/m68k/kernel/process_mm.c
+++ b/arch/m68k/kernel/process_mm.c
@@ -78,9 +78,7 @@ void cpu_idle(void)
 	while (1) {
 		while (!need_resched())
 			idle();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/m68k/kernel/process_no.c b/arch/m68k/kernel/process_no.c
index 5e1078c..f7fe6c3 100644
--- a/arch/m68k/kernel/process_no.c
+++ b/arch/m68k/kernel/process_no.c
@@ -73,9 +73,7 @@ void cpu_idle(void)
 	/* endless idle loop with no priority at all */
 	while (1) {
 		idle();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index 7dcb5bf..9155f7d 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -110,9 +110,7 @@ void cpu_idle(void)
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
 
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 		check_pgt_cache();
 	}
 }
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index 7955409..61f1cb4 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -80,9 +80,7 @@ void __noreturn cpu_idle(void)
 #endif
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index 28eec31..cac401d 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -123,9 +123,7 @@ void cpu_idle(void)
 			idle();
 		}
 
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index 62c60b8..d4b94b3 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -71,9 +71,7 @@ void cpu_idle(void)
 	while (1) {
 		while (!need_resched())
 			barrier();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 		check_pgt_cache();
 	}
 }
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 0a48bf5..c97fc60 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -101,11 +101,11 @@ void cpu_idle(void)
 		ppc64_runlatch_on();
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		if (cpu_should_die())
+		if (cpu_should_die()) {
+			sched_preempt_enable_no_resched();
 			cpu_die();
-		schedule();
-		preempt_disable();
+		}
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/powerpc/platforms/iseries/setup.c b/arch/powerpc/platforms/iseries/setup.c
index 8fc6258..a5fbf4c 100644
--- a/arch/powerpc/platforms/iseries/setup.c
+++ b/arch/powerpc/platforms/iseries/setup.c
@@ -584,9 +584,7 @@ static void iseries_shared_idle(void)
 		if (hvlpevent_is_pending())
 			process_iSeries_events();
 
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
@@ -615,9 +613,7 @@ static void iseries_dedicated_idle(void)
 		ppc64_runlatch_on();
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index e795933..7618085 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -97,9 +97,7 @@ void cpu_idle(void)
 		tick_nohz_idle_exit();
 		if (test_thread_flag(TIF_MCCK_PENDING))
 			s390_handle_mcck();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 2398ce6..b0e28c4 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -550,12 +550,6 @@ int __cpuinit start_secondary(void *cpuvoid)
 	S390_lowcore.restart_psw.addr =
 		PSW_ADDR_AMODE | (unsigned long) psw_restart_int_handler;
 	__ctl_set_bit(0, 28); /* Enable lowcore protection */
-	/*
-	 * Wait until the cpu which brought this one up marked it
-	 * active before enabling interrupts.
-	 */
-	while (!cpumask_test_cpu(smp_processor_id(), cpu_active_mask))
-		cpu_relax();
 	local_irq_enable();
 	/* cpu_idle will call schedule for us */
 	cpu_idle();
diff --git a/arch/score/kernel/process.c b/arch/score/kernel/process.c
index 25d0803..2707023 100644
--- a/arch/score/kernel/process.c
+++ b/arch/score/kernel/process.c
@@ -53,9 +53,7 @@ void __noreturn cpu_idle(void)
 		while (!need_resched())
 			barrier();
 
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index 406508d..7e48928 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -114,9 +114,7 @@ void cpu_idle(void)
 
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/sparc/kernel/process_32.c b/arch/sparc/kernel/process_32.c
index f793742..935fdbc 100644
--- a/arch/sparc/kernel/process_32.c
+++ b/arch/sparc/kernel/process_32.c
@@ -113,9 +113,7 @@ void cpu_idle(void)
 			while (!need_resched())
 				cpu_relax();
 		}
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 		check_pgt_cache();
 	}
 }
@@ -138,9 +136,7 @@ void cpu_idle(void)
 			while (!need_resched())
 				cpu_relax();
 		}
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 		check_pgt_cache();
 	}
 }
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index 39d8b05..06b5b5f 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -104,15 +104,13 @@ void cpu_idle(void)
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
 
-		preempt_enable_no_resched();
-
 #ifdef CONFIG_HOTPLUG_CPU
-		if (cpu_is_offline(cpu))
+		if (cpu_is_offline(cpu)) {
+			sched_preempt_enable_no_resched();
 			cpu_play_dead();
+		}
 #endif
-
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 4c1ac6e..6ae495e 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -108,9 +108,7 @@ void cpu_idle(void)
 		}
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
index 431793e..34baa0e 100644
--- a/arch/x86/include/asm/timer.h
+++ b/arch/x86/include/asm/timer.h
@@ -57,14 +57,10 @@ DECLARE_PER_CPU(unsigned long long, cyc2ns_offset);
 
 static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
 {
-	unsigned long long quot;
-	unsigned long long rem;
 	int cpu = smp_processor_id();
 	unsigned long long ns = per_cpu(cyc2ns_offset, cpu);
-	quot = (cyc >> CYC2NS_SCALE_FACTOR);
-	rem = cyc & ((1ULL << CYC2NS_SCALE_FACTOR) - 1);
-	ns += quot * per_cpu(cyc2ns, cpu) +
-		((rem * per_cpu(cyc2ns, cpu)) >> CYC2NS_SCALE_FACTOR);
+	ns += mult_frac(cyc, per_cpu(cyc2ns, cpu),
+			(1UL << CYC2NS_SCALE_FACTOR));
 	return ns;
 }
 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index c08d1ff..49888fe 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -119,9 +119,7 @@ void cpu_idle(void)
 		}
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index cfa5c90..e34257c 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -156,9 +156,7 @@ void cpu_idle(void)
 		}
 
 		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 66d250c..58f7816 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -291,19 +291,6 @@ notrace static void __cpuinit start_secondary(void *unused)
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 	x86_platform.nmi_init();
 
-	/*
-	 * Wait until the cpu which brought this one up marked it
-	 * online before enabling interrupts. If we don't do that then
-	 * we can end up waking up the softirq thread before this cpu
-	 * reached the active state, which makes the scheduler unhappy
-	 * and schedule the softirq thread on the wrong cpu. This is
-	 * only observable with forced threaded interrupts, but in
-	 * theory it could also happen w/o them. It's just way harder
-	 * to achieve.
-	 */
-	while (!cpumask_test_cpu(smp_processor_id(), cpu_active_mask))
-		cpu_relax();
-
 	/* enable local interrupts */
 	local_irq_enable();
 
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index a62c201..183c592 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -620,7 +620,8 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 
 	if (cpu_khz) {
 		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
-		*offset = ns_now - (tsc_now * *scale >> CYC2NS_SCALE_FACTOR);
+		*offset = ns_now - mult_frac(tsc_now, *scale,
+					     (1UL << CYC2NS_SCALE_FACTOR));
 	}
 
 	sched_clock_idle_wakeup_event(0);
diff --git a/arch/xtensa/kernel/process.c b/arch/xtensa/kernel/process.c
index 47041e7..2c90047 100644
--- a/arch/xtensa/kernel/process.c
+++ b/arch/xtensa/kernel/process.c
@@ -113,9 +113,7 @@ void cpu_idle(void)
 	while (1) {
 		while (!need_resched())
 			platform_idle();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 1366a89..467c8de 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -8,6 +8,7 @@
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
+#include <linux/sched.h>
 
 #include "blk.h"
 
@@ -103,9 +104,10 @@ static struct notifier_block __cpuinitdata blk_cpu_notifier = {
 
 void __blk_complete_request(struct request *req)
 {
-	int ccpu, cpu, group_cpu = NR_CPUS;
+	int ccpu, cpu;
 	struct request_queue *q = req->q;
 	unsigned long flags;
+	bool shared = false;
 
 	BUG_ON(!q->softirq_done_fn);
 
@@ -117,22 +119,20 @@ void __blk_complete_request(struct request *req)
 	 */
 	if (req->cpu != -1) {
 		ccpu = req->cpu;
-		if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags)) {
-			ccpu = blk_cpu_to_group(ccpu);
-			group_cpu = blk_cpu_to_group(cpu);
-		}
+		if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags))
+			shared = cpus_share_cache(cpu, ccpu);
 	} else
 		ccpu = cpu;
 
 	/*
-	 * If current CPU and requested CPU are in the same group, running
-	 * softirq in current CPU. One might concern this is just like
+	 * If current CPU and requested CPU share a cache, run the softirq on
+	 * the current CPU. One might concern this is just like
 	 * QUEUE_FLAG_SAME_FORCE, but actually not. blk_complete_request() is
 	 * running in interrupt handler, and currently I/O controller doesn't
 	 * support multiple interrupts, so current CPU is unique actually. This
 	 * avoids IPI sending from current CPU to the first CPU of a group.
 	 */
-	if (ccpu == cpu || ccpu == group_cpu) {
+	if (ccpu == cpu || shared) {
 		struct list_head *list;
 do_local:
 		list = &__get_cpu_var(blk_cpu_done);
diff --git a/block/blk.h b/block/blk.h
index 9c12f80..d45be87 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -166,22 +166,6 @@ static inline int queue_congestion_off_threshold(struct request_queue *q)
 	return q->nr_congestion_off;
 }
 
-static inline int blk_cpu_to_group(int cpu)
-{
-	int group = NR_CPUS;
-#ifdef CONFIG_SCHED_MC
-	const struct cpumask *mask = cpu_coregroup_mask(cpu);
-	group = cpumask_first(mask);
-#elif defined(CONFIG_SCHED_SMT)
-	group = cpumask_first(topology_thread_cpumask(cpu));
-#else
-	return cpu;
-#endif
-	if (likely(group < NR_CPUS))
-		return group;
-	return cpu;
-}
-
 /*
  * Contribute to IO statistics IFF:
  *
diff --git a/fs/proc/base.c b/fs/proc/base.c
index d4548dd..965d4bd 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1310,8 +1310,7 @@ sched_autogroup_write(struct file *file, const char __user *buf,
 	if (!p)
 		return -ESRCH;
 
-	err = nice;
-	err = proc_sched_autogroup_set_nice(p, &err);
+	err = proc_sched_autogroup_set_nice(p, nice);
 	if (err)
 		count = err;
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 9c66b1a..f994d51 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -149,7 +149,7 @@ extern struct cred init_cred;
 	},								\
 	.rt		= {						\
 		.run_list	= LIST_HEAD_INIT(tsk.rt.run_list),	\
-		.time_slice	= HZ, 					\
+		.time_slice	= RR_TIMESLICE,				\
 		.nr_cpus_allowed = NR_CPUS,				\
 	},								\
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e834342..d801acb 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -85,6 +85,19 @@
 }							\
 )
 
+/*
+ * Multiplies an integer by a fraction, while avoiding unnecessary
+ * overflow or loss of precision.
+ */
+#define mult_frac(x, numer, denom)(			\
+{							\
+	typeof(x) quot = (x) / (denom);			\
+	typeof(x) rem  = (x) % (denom);			\
+	(quot * (numer)) + ((rem * (numer)) / (denom));	\
+}							\
+)
+
+
 #define _RET_IP_		(unsigned long)__builtin_return_address(0)
 #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
 
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 58969b2..5a710b9 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -48,12 +48,14 @@ do { \
 	barrier(); \
 } while (0)
 
-#define preempt_enable_no_resched() \
+#define sched_preempt_enable_no_resched() \
 do { \
 	barrier(); \
 	dec_preempt_count(); \
 } while (0)
 
+#define preempt_enable_no_resched()	sched_preempt_enable_no_resched()
+
 #define preempt_enable() \
 do { \
 	preempt_enable_no_resched(); \
@@ -92,6 +94,7 @@ do { \
 #else /* !CONFIG_PREEMPT_COUNT */
 
 #define preempt_disable()		do { } while (0)
+#define sched_preempt_enable_no_resched()	do { } while (0)
 #define preempt_enable_no_resched()	do { } while (0)
 #define preempt_enable()		do { } while (0)
 
diff --git a/include/linux/printk.h b/include/linux/printk.h
index f0e22f7..1f77a41 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -101,6 +101,11 @@ asmlinkage __printf(1, 2) __cold
 int printk(const char *fmt, ...);
 
 /*
+ * Special printk facility for scheduler use only, _DO_NOT_USE_ !
+ */
+__printf(1, 2) __cold int printk_sched(const char *fmt, ...);
+
+/*
  * Please don't use printk_ratelimit(), because it shares ratelimiting state
  * with all other unrelated printk_ratelimit() callsites.  Instead use
  * printk_ratelimited() or plain old __ratelimit().
@@ -127,6 +132,11 @@ int printk(const char *s, ...)
 {
 	return 0;
 }
+static inline __printf(1, 2) __cold
+int printk_sched(const char *s, ...)
+{
+	return 0;
+}
 static inline int printk_ratelimit(void)
 {
 	return 0;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0657368..0cd002c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -361,6 +361,7 @@ extern signed long schedule_timeout_interruptible(signed long timeout);
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
 asmlinkage void schedule(void);
+extern void schedule_preempt_disabled(void);
 extern int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner);
 
 struct nsproxy;
@@ -905,6 +906,7 @@ struct sched_group_power {
 	 * single CPU.
 	 */
 	unsigned int power, power_orig;
+	unsigned long next_update;
 	/*
 	 * Number of busy cpus in this group.
 	 */
@@ -1052,6 +1054,8 @@ static inline int test_sd_parent(struct sched_domain *sd, int flag)
 unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu);
 unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu);
 
+bool cpus_share_cache(int this_cpu, int that_cpu);
+
 #else /* CONFIG_SMP */
 
 struct sched_domain_attr;
@@ -1061,6 +1065,12 @@ partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 			struct sched_domain_attr *dattr_new)
 {
 }
+
+static inline bool cpus_share_cache(int this_cpu, int that_cpu)
+{
+	return true;
+}
+
 #endif	/* !CONFIG_SMP */
 
 
@@ -1225,6 +1235,12 @@ struct sched_rt_entity {
 #endif
 };
 
+/*
+ * default timeslice is 100 msecs (used only for SCHED_RR tasks).
+ * Timeslices get refilled after they expire.
+ */
+#define RR_TIMESLICE		(100 * HZ / 1000)
+
 struct rcu_node;
 
 enum perf_event_task_context {
@@ -2048,7 +2064,7 @@ extern void sched_autogroup_fork(struct signal_struct *sig);
 extern void sched_autogroup_exit(struct signal_struct *sig);
 #ifdef CONFIG_PROC_FS
 extern void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m);
-extern int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice);
+extern int proc_sched_autogroup_set_nice(struct task_struct *p, int nice);
 #endif
 #else
 static inline void sched_autogroup_create_attach(struct task_struct *p) { }
@@ -2065,12 +2081,20 @@ extern unsigned int sysctl_sched_cfs_bandwidth_slice;
 extern int rt_mutex_getprio(struct task_struct *p);
 extern void rt_mutex_setprio(struct task_struct *p, int prio);
 extern void rt_mutex_adjust_pi(struct task_struct *p);
+static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
+{
+	return tsk->pi_blocked_on != NULL;
+}
 #else
 static inline int rt_mutex_getprio(struct task_struct *p)
 {
 	return p->normal_prio;
 }
 # define rt_mutex_adjust_pi(p)		do { } while (0)
+static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
+{
+	return false;
+}
 #endif
 
 extern bool yield_to(struct task_struct *p, bool preempt);
@@ -2389,12 +2413,15 @@ static inline void task_unlock(struct task_struct *p)
 extern struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
 							unsigned long *flags);
 
-#define lock_task_sighand(tsk, flags)					\
-({	struct sighand_struct *__ss;					\
-	__cond_lock(&(tsk)->sighand->siglock,				\
-		    (__ss = __lock_task_sighand(tsk, flags)));		\
-	__ss;								\
-})									\
+static inline struct sighand_struct *lock_task_sighand(struct task_struct *tsk,
+						       unsigned long *flags)
+{
+	struct sighand_struct *ret;
+
+	ret = __lock_task_sighand(tsk, flags);
+	(void)__cond_lock(&tsk->sighand->siglock, ret);
+	return ret;
+}
 
 static inline void unlock_task_sighand(struct task_struct *tsk,
 						unsigned long *flags)
diff --git a/include/linux/wait.h b/include/linux/wait.h
index a9ce45e..7d9a9e9 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -157,7 +157,7 @@ void __wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
 void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key);
 void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode, int nr,
 			void *key);
-void __wake_up_locked(wait_queue_head_t *q, unsigned int mode);
+void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_bit(wait_queue_head_t *, void *, int);
 int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
@@ -170,7 +170,8 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 #define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL)
 #define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
 #define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
-#define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL)
+#define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL, 1)
+#define wake_up_all_locked(x)		__wake_up_locked((x), TASK_NORMAL, 0)
 
 #define wake_up_interruptible(x)	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
 #define wake_up_interruptible_nr(x, nr)	__wake_up(x, TASK_INTERRUPTIBLE, nr, NULL)
diff --git a/init/main.c b/init/main.c
index ff49a6d..4990f7e 100644
--- a/init/main.c
+++ b/init/main.c
@@ -374,11 +374,8 @@ static noinline void __init_refok rest_init(void)
 	 * at least once to get things moving:
 	 */
 	init_idle_bootup_task(current);
-	preempt_enable_no_resched();
-	schedule();
-
+	schedule_preempt_disabled();
 	/* Call into cpu_idle with preempt disabled */
-	preempt_disable();
 	cpu_idle();
 }
 
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 89096dd..a307cc9 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -240,9 +240,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 		/* didn't get the lock, go to sleep: */
 		spin_unlock_mutex(&lock->wait_lock, flags);
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
+		schedule_preempt_disabled();
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}
 
diff --git a/kernel/printk.c b/kernel/printk.c
index 32690a0..b64ce71 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1211,13 +1211,27 @@ int is_console_locked(void)
 	return console_locked;
 }
 
+/*
+ * Delayed printk facility, for scheduler-internal messages:
+ */
+#define PRINTK_BUF_SIZE		512
+
+#define PRINTK_PENDING_WAKEUP	0x01
+#define PRINTK_PENDING_SCHED	0x02
+
 static DEFINE_PER_CPU(int, printk_pending);
+static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
 
 void printk_tick(void)
 {
 	if (__this_cpu_read(printk_pending)) {
-		__this_cpu_write(printk_pending, 0);
-		wake_up_interruptible(&log_wait);
+		int pending = __this_cpu_xchg(printk_pending, 0);
+		if (pending & PRINTK_PENDING_SCHED) {
+			char *buf = __get_cpu_var(printk_sched_buf);
+			printk(KERN_WARNING "[sched_delayed] %s", buf);
+		}
+		if (pending & PRINTK_PENDING_WAKEUP)
+			wake_up_interruptible(&log_wait);
 	}
 }
 
@@ -1231,7 +1245,7 @@ int printk_needs_cpu(int cpu)
 void wake_up_klogd(void)
 {
 	if (waitqueue_active(&log_wait))
-		this_cpu_write(printk_pending, 1);
+		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
 }
 
 /**
@@ -1624,6 +1638,26 @@ late_initcall(printk_late_init);
 
 #if defined CONFIG_PRINTK
 
+int printk_sched(const char *fmt, ...)
+{
+	unsigned long flags;
+	va_list args;
+	char *buf;
+	int r;
+
+	local_irq_save(flags);
+	buf = __get_cpu_var(printk_sched_buf);
+
+	va_start(args, fmt);
+	r = vsnprintf(buf, PRINTK_BUF_SIZE, fmt, args);
+	va_end(args);
+
+	__this_cpu_or(printk_pending, PRINTK_PENDING_SCHED);
+	local_irq_restore(flags);
+
+	return r;
+}
+
 /*
  * printk rate limiting, lifted from the networking subsystem.
  *
diff --git a/kernel/sched/auto_group.c b/kernel/sched/auto_group.c
index e8a1f83..0984a21 100644
--- a/kernel/sched/auto_group.c
+++ b/kernel/sched/auto_group.c
@@ -195,20 +195,20 @@ __setup("noautogroup", setup_autogroup);
 
 #ifdef CONFIG_PROC_FS
 
-int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice)
+int proc_sched_autogroup_set_nice(struct task_struct *p, int nice)
 {
 	static unsigned long next = INITIAL_JIFFIES;
 	struct autogroup *ag;
 	int err;
 
-	if (*nice < -20 || *nice > 19)
+	if (nice < -20 || nice > 19)
 		return -EINVAL;
 
-	err = security_task_setnice(current, *nice);
+	err = security_task_setnice(current, nice);
 	if (err)
 		return err;
 
-	if (*nice < 0 && !can_nice(current, *nice))
+	if (nice < 0 && !can_nice(current, nice))
 		return -EPERM;
 
 	/* this is a heavy operation taking global locks.. */
@@ -219,9 +219,9 @@ int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice)
 	ag = autogroup_task_get(p);
 
 	down_write(&ag->lock);
-	err = sched_group_set_shares(ag->tg, prio_to_weight[*nice + 20]);
+	err = sched_group_set_shares(ag->tg, prio_to_weight[nice + 20]);
 	if (!err)
-		ag->nice = *nice;
+		ag->nice = nice;
 	up_write(&ag->lock);
 
 	autogroup_kref_put(ag);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b342f57..e3ccc13 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1284,7 +1284,7 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 	 * leave kernel.
 	 */
 	if (p->mm && printk_ratelimit()) {
-		printk(KERN_INFO "process %d (%s) no longer affine to cpu%d\n",
+		printk_sched("process %d (%s) no longer affine to cpu%d\n",
 				task_pid_nr(p), p->comm, cpu);
 	}
 
@@ -1507,7 +1507,7 @@ static int ttwu_activate_remote(struct task_struct *p, int wake_flags)
 }
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 
-static inline int ttwu_share_cache(int this_cpu, int that_cpu)
+bool cpus_share_cache(int this_cpu, int that_cpu)
 {
 	return per_cpu(sd_llc_id, this_cpu) == per_cpu(sd_llc_id, that_cpu);
 }
@@ -1518,7 +1518,7 @@ static void ttwu_queue(struct task_struct *p, int cpu)
 	struct rq *rq = cpu_rq(cpu);
 
 #if defined(CONFIG_SMP)
-	if (sched_feat(TTWU_QUEUE) && !ttwu_share_cache(smp_processor_id(), cpu)) {
+	if (sched_feat(TTWU_QUEUE) && !cpus_share_cache(smp_processor_id(), cpu)) {
 		sched_clock_cpu(cpu); /* sync clocks x-cpu */
 		ttwu_queue_remote(p, cpu);
 		return;
@@ -2266,13 +2266,10 @@ calc_load_n(unsigned long load, unsigned long exp,
  * Once we've updated the global active value, we need to apply the exponential
  * weights adjusted to the number of cycles missed.
  */
-static void calc_global_nohz(unsigned long ticks)
+static void calc_global_nohz(void)
 {
 	long delta, active, n;
 
-	if (time_before(jiffies, calc_load_update))
-		return;
-
 	/*
 	 * If we crossed a calc_load_update boundary, make sure to fold
 	 * any pending idle changes, the respective CPUs might have
@@ -2284,31 +2281,25 @@ static void calc_global_nohz(unsigned long ticks)
 		atomic_long_add(delta, &calc_load_tasks);
 
 	/*
-	 * If we were idle for multiple load cycles, apply them.
+	 * It could be the one fold was all it took, we done!
 	 */
-	if (ticks >= LOAD_FREQ) {
-		n = ticks / LOAD_FREQ;
+	if (time_before(jiffies, calc_load_update + 10))
+		return;
 
-		active = atomic_long_read(&calc_load_tasks);
-		active = active > 0 ? active * FIXED_1 : 0;
+	/*
+	 * Catch-up, fold however many we are behind still
+	 */
+	delta = jiffies - calc_load_update - 10;
+	n = 1 + (delta / LOAD_FREQ);
 
-		avenrun[0] = calc_load_n(avenrun[0], EXP_1, active, n);
-		avenrun[1] = calc_load_n(avenrun[1], EXP_5, active, n);
-		avenrun[2] = calc_load_n(avenrun[2], EXP_15, active, n);
+	active = atomic_long_read(&calc_load_tasks);
+	active = active > 0 ? active * FIXED_1 : 0;
 
-		calc_load_update += n * LOAD_FREQ;
-	}
+	avenrun[0] = calc_load_n(avenrun[0], EXP_1, active, n);
+	avenrun[1] = calc_load_n(avenrun[1], EXP_5, active, n);
+	avenrun[2] = calc_load_n(avenrun[2], EXP_15, active, n);
 
-	/*
-	 * Its possible the remainder of the above division also crosses
-	 * a LOAD_FREQ period, the regular check in calc_global_load()
-	 * which comes after this will take care of that.
-	 *
-	 * Consider us being 11 ticks before a cycle completion, and us
-	 * sleeping for 4*LOAD_FREQ + 22 ticks, then the above code will
-	 * age us 4 cycles, and the test in calc_global_load() will
-	 * pick up the final one.
-	 */
+	calc_load_update += n * LOAD_FREQ;
 }
 #else
 void calc_load_account_idle(struct rq *this_rq)
@@ -2320,7 +2311,7 @@ static inline long calc_load_fold_idle(void)
 	return 0;
 }
 
-static void calc_global_nohz(unsigned long ticks)
+static void calc_global_nohz(void)
 {
 }
 #endif
@@ -2348,8 +2339,6 @@ void calc_global_load(unsigned long ticks)
 {
 	long active;
 
-	calc_global_nohz(ticks);
-
 	if (time_before(jiffies, calc_load_update + 10))
 		return;
 
@@ -2361,6 +2350,16 @@ void calc_global_load(unsigned long ticks)
 	avenrun[2] = calc_load(avenrun[2], EXP_15, active);
 
 	calc_load_update += LOAD_FREQ;
+
+	/*
+	 * Account one period with whatever state we found before
+	 * folding in the nohz state and ageing the entire idle period.
+	 *
+	 * This avoids loosing a sample when we go idle between 
+	 * calc_load_account_active() (10 ticks ago) and now and thus
+	 * under-accounting.
+	 */
+	calc_global_nohz();
 }
 
 /*
@@ -3220,14 +3219,14 @@ need_resched:
 
 	post_schedule(rq);
 
-	preempt_enable_no_resched();
+	sched_preempt_enable_no_resched();
 	if (need_resched())
 		goto need_resched;
 }
 
 static inline void sched_submit_work(struct task_struct *tsk)
 {
-	if (!tsk->state)
+	if (!tsk->state || tsk_is_pi_blocked(tsk))
 		return;
 	/*
 	 * If we are going to sleep and we have plugged IO queued,
@@ -3246,6 +3245,18 @@ asmlinkage void __sched schedule(void)
 }
 EXPORT_SYMBOL(schedule);
 
+/**
+ * schedule_preempt_disabled - called with preemption disabled
+ *
+ * Returns with preemption disabled. Note: preempt_count must be 1
+ */
+void __sched schedule_preempt_disabled(void)
+{
+	sched_preempt_enable_no_resched();
+	schedule();
+	preempt_disable();
+}
+
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
 
 static inline bool owner_running(struct mutex *lock, struct task_struct *owner)
@@ -3406,9 +3417,9 @@ EXPORT_SYMBOL(__wake_up);
 /*
  * Same as __wake_up but called with the spinlock in wait_queue_head_t held.
  */
-void __wake_up_locked(wait_queue_head_t *q, unsigned int mode)
+void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr)
 {
-	__wake_up_common(q, mode, 1, 0, NULL);
+	__wake_up_common(q, mode, nr, 0, NULL);
 }
 EXPORT_SYMBOL_GPL(__wake_up_locked);
 
@@ -3767,6 +3778,24 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 
 	rq = __task_rq_lock(p);
 
+	/*
+	 * Idle task boosting is a nono in general. There is one
+	 * exception, when PREEMPT_RT and NOHZ is active:
+	 *
+	 * The idle task calls get_next_timer_interrupt() and holds
+	 * the timer wheel base->lock on the CPU and another CPU wants
+	 * to access the timer (probably to cancel it). We can safely
+	 * ignore the boosting request, as the idle CPU runs this code
+	 * with interrupts disabled and will complete the lock
+	 * protected section without being interrupted. So there is no
+	 * real need to boost.
+	 */
+	if (unlikely(p == rq->idle)) {
+		WARN_ON(p != rq->curr);
+		WARN_ON(p->pi_blocked_on);
+		goto out_unlock;
+	}
+
 	trace_sched_pi_setprio(p, prio);
 	oldprio = p->prio;
 	prev_class = p->sched_class;
@@ -3790,11 +3819,10 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 		enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);
 
 	check_class_changed(rq, p, prev_class, oldprio);
+out_unlock:
 	__task_rq_unlock(rq);
 }
-
 #endif
-
 void set_user_nice(struct task_struct *p, long nice)
 {
 	int old_prio, delta, on_rq;
@@ -4474,7 +4502,7 @@ SYSCALL_DEFINE0(sched_yield)
 	__release(rq->lock);
 	spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
 	do_raw_spin_unlock(&rq->lock);
-	preempt_enable_no_resched();
+	sched_preempt_enable_no_resched();
 
 	schedule();
 
@@ -4548,8 +4576,24 @@ EXPORT_SYMBOL(__cond_resched_softirq);
 /**
  * yield - yield the current processor to other threads.
  *
- * This is a shortcut for kernel-space yielding - it marks the
- * thread runnable and calls sys_sched_yield().
+ * Do not ever use this function, there's a 99% chance you're doing it wrong.
+ *
+ * The scheduler is at all times free to pick the calling task as the most
+ * eligible task to run, if removing the yield() call from your code breaks
+ * it, its already broken.
+ *
+ * Typical broken usage is:
+ *
+ * while (!event)
+ * 	yield();
+ *
+ * where one assumes that yield() will let 'the other' process run that will
+ * make event true. If the current task is a SCHED_FIFO task that will never
+ * happen. Never use yield() as a progress guarantee!!
+ *
+ * If you want to use yield() to wait for something, use wait_event().
+ * If you want to use yield() to be 'nice' for others, use cond_resched().
+ * If you still want to use yield(), do not!
  */
 void __sched yield(void)
 {
@@ -5381,7 +5425,7 @@ static int __cpuinit sched_cpu_active(struct notifier_block *nfb,
 				      unsigned long action, void *hcpu)
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_ONLINE:
+	case CPU_STARTING:
 	case CPU_DOWN_FAILED:
 		set_cpu_active((long)hcpu, true);
 		return NOTIFY_OK;
@@ -5753,7 +5797,7 @@ static void destroy_sched_domains(struct sched_domain *sd, int cpu)
  *
  * Also keep a unique ID per domain (we use the first cpu number in
  * the cpumask of the domain), this allows us to quickly tell if
- * two cpus are in the same cache domain, see ttwu_share_cache().
+ * two cpus are in the same cache domain, see cpus_share_cache().
  */
 DEFINE_PER_CPU(struct sched_domain *, sd_llc);
 DEFINE_PER_CPU(int, sd_llc_id);
@@ -6930,6 +6974,9 @@ void __init sched_init(void)
 		rq->online = 0;
 		rq->idle_stamp = 0;
 		rq->avg_idle = 2*sysctl_sched_migration_cost;
+
+		INIT_LIST_HEAD(&rq->cfs_tasks);
+
 		rq_attach_root(rq, &def_root_domain);
 #ifdef CONFIG_NO_HZ
 		rq->nohz_flags = 0;
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 2a075e1..09acaa1 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -288,7 +288,6 @@ static void print_cpu(struct seq_file *m, int cpu)
 
 	P(yld_count);
 
-	P(sched_switch);
 	P(sched_count);
 	P(sched_goidle);
 #ifdef CONFIG_SMP
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index aca16b8..11f3979 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -776,29 +776,16 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
  * Scheduling class queueing methods:
  */
 
-#if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
-static void
-add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long weight)
-{
-	cfs_rq->task_weight += weight;
-}
-#else
-static inline void
-add_cfs_task_weight(struct cfs_rq *cfs_rq, unsigned long weight)
-{
-}
-#endif
-
 static void
 account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	update_load_add(&cfs_rq->load, se->load.weight);
 	if (!parent_entity(se))
 		update_load_add(&rq_of(cfs_rq)->load, se->load.weight);
-	if (entity_is_task(se)) {
-		add_cfs_task_weight(cfs_rq, se->load.weight);
-		list_add(&se->group_node, &cfs_rq->tasks);
-	}
+#ifdef CONFIG_SMP
+	if (entity_is_task(se))
+		list_add_tail(&se->group_node, &rq_of(cfs_rq)->cfs_tasks);
+#endif
 	cfs_rq->nr_running++;
 }
 
@@ -808,10 +795,8 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	update_load_sub(&cfs_rq->load, se->load.weight);
 	if (!parent_entity(se))
 		update_load_sub(&rq_of(cfs_rq)->load, se->load.weight);
-	if (entity_is_task(se)) {
-		add_cfs_task_weight(cfs_rq, -se->load.weight);
+	if (entity_is_task(se))
 		list_del_init(&se->group_node);
-	}
 	cfs_rq->nr_running--;
 }
 
@@ -2672,8 +2657,6 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	/*
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
 	 */
-	rcu_read_lock();
-
 	sd = rcu_dereference(per_cpu(sd_llc, target));
 	for_each_lower_domain(sd) {
 		sg = sd->groups;
@@ -2695,8 +2678,6 @@ next:
 		} while (sg != sd->groups);
 	}
 done:
-	rcu_read_unlock();
-
 	return target;
 }
 
@@ -2922,7 +2903,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 		return;
 
 	/*
-	 * This is possible from callers such as pull_task(), in which we
+	 * This is possible from callers such as move_task(), in which we
 	 * unconditionally check_prempt_curr() after an enqueue (which may have
 	 * lead to a throttle).  This both saves work and prevents false
 	 * next-buddy nomination below.
@@ -3086,17 +3067,39 @@ static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preemp
  * Fair scheduling class load-balancing methods:
  */
 
+static unsigned long __read_mostly max_load_balance_interval = HZ/10;
+
+#define LBF_ALL_PINNED	0x01
+#define LBF_NEED_BREAK	0x02
+
+struct lb_env {
+	struct sched_domain	*sd;
+
+	int			src_cpu;
+	struct rq		*src_rq;
+
+	int			dst_cpu;
+	struct rq		*dst_rq;
+
+	enum cpu_idle_type	idle;
+	long			load_move;
+	unsigned int		flags;
+
+	unsigned int		loop;
+	unsigned int		loop_break;
+	unsigned int		loop_max;
+};
+
 /*
- * pull_task - move a task from a remote runqueue to the local runqueue.
+ * move_task - move a task from one runqueue to another runqueue.
  * Both runqueues must be locked.
  */
-static void pull_task(struct rq *src_rq, struct task_struct *p,
-		      struct rq *this_rq, int this_cpu)
+static void move_task(struct task_struct *p, struct lb_env *env)
 {
-	deactivate_task(src_rq, p, 0);
-	set_task_cpu(p, this_cpu);
-	activate_task(this_rq, p, 0);
-	check_preempt_curr(this_rq, p, 0);
+	deactivate_task(env->src_rq, p, 0);
+	set_task_cpu(p, env->dst_cpu);
+	activate_task(env->dst_rq, p, 0);
+	check_preempt_curr(env->dst_rq, p, 0);
 }
 
 /*
@@ -3131,19 +3134,11 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	return delta < (s64)sysctl_sched_migration_cost;
 }
 
-#define LBF_ALL_PINNED	0x01
-#define LBF_NEED_BREAK	0x02	/* clears into HAD_BREAK */
-#define LBF_HAD_BREAK	0x04
-#define LBF_HAD_BREAKS	0x0C	/* count HAD_BREAKs overflows into ABORT */
-#define LBF_ABORT	0x10
-
 /*
  * can_migrate_task - may task p from runqueue rq be migrated to this_cpu?
  */
 static
-int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
-		     struct sched_domain *sd, enum cpu_idle_type idle,
-		     int *lb_flags)
+int can_migrate_task(struct task_struct *p, struct lb_env *env)
 {
 	int tsk_cache_hot = 0;
 	/*
@@ -3152,13 +3147,13 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
 	 * 3) are cache-hot on their current CPU.
 	 */
-	if (!cpumask_test_cpu(this_cpu, tsk_cpus_allowed(p))) {
+	if (!cpumask_test_cpu(env->dst_cpu, tsk_cpus_allowed(p))) {
 		schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
 		return 0;
 	}
-	*lb_flags &= ~LBF_ALL_PINNED;
+	env->flags &= ~LBF_ALL_PINNED;
 
-	if (task_running(rq, p)) {
+	if (task_running(env->src_rq, p)) {
 		schedstat_inc(p, se.statistics.nr_failed_migrations_running);
 		return 0;
 	}
@@ -3169,12 +3164,12 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 	 * 2) too many balance attempts have failed.
 	 */
 
-	tsk_cache_hot = task_hot(p, rq->clock_task, sd);
+	tsk_cache_hot = task_hot(p, env->src_rq->clock_task, env->sd);
 	if (!tsk_cache_hot ||
-		sd->nr_balance_failed > sd->cache_nice_tries) {
+		env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
 #ifdef CONFIG_SCHEDSTATS
 		if (tsk_cache_hot) {
-			schedstat_inc(sd, lb_hot_gained[idle]);
+			schedstat_inc(env->sd, lb_hot_gained[env->idle]);
 			schedstat_inc(p, se.statistics.nr_forced_migrations);
 		}
 #endif
@@ -3195,65 +3190,80 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
  *
  * Called with both runqueues locked.
  */
-static int
-move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
-	      struct sched_domain *sd, enum cpu_idle_type idle)
+static int move_one_task(struct lb_env *env)
 {
 	struct task_struct *p, *n;
-	struct cfs_rq *cfs_rq;
-	int pinned = 0;
 
-	for_each_leaf_cfs_rq(busiest, cfs_rq) {
-		list_for_each_entry_safe(p, n, &cfs_rq->tasks, se.group_node) {
-			if (throttled_lb_pair(task_group(p),
-					      busiest->cpu, this_cpu))
-				break;
+	list_for_each_entry_safe(p, n, &env->src_rq->cfs_tasks, se.group_node) {
+		if (throttled_lb_pair(task_group(p), env->src_rq->cpu, env->dst_cpu))
+			continue;
 
-			if (!can_migrate_task(p, busiest, this_cpu,
-						sd, idle, &pinned))
-				continue;
+		if (!can_migrate_task(p, env))
+			continue;
 
-			pull_task(busiest, p, this_rq, this_cpu);
-			/*
-			 * Right now, this is only the second place pull_task()
-			 * is called, so we can safely collect pull_task()
-			 * stats here rather than inside pull_task().
-			 */
-			schedstat_inc(sd, lb_gained[idle]);
-			return 1;
-		}
+		move_task(p, env);
+		/*
+		 * Right now, this is only the second place move_task()
+		 * is called, so we can safely collect move_task()
+		 * stats here rather than inside move_task().
+		 */
+		schedstat_inc(env->sd, lb_gained[env->idle]);
+		return 1;
 	}
-
 	return 0;
 }
 
-static unsigned long
-balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
-	      unsigned long max_load_move, struct sched_domain *sd,
-	      enum cpu_idle_type idle, int *lb_flags,
-	      struct cfs_rq *busiest_cfs_rq)
+static unsigned long task_h_load(struct task_struct *p);
+
+/*
+ * move_tasks tries to move up to load_move weighted load from busiest to
+ * this_rq, as part of a balancing operation within domain "sd".
+ * Returns 1 if successful and 0 otherwise.
+ *
+ * Called with both runqueues locked.
+ */
+static int move_tasks(struct lb_env *env)
 {
-	int loops = 0, pulled = 0;
-	long rem_load_move = max_load_move;
-	struct task_struct *p, *n;
+	struct list_head *tasks = &env->src_rq->cfs_tasks;
+	struct task_struct *p;
+	unsigned long load;
+	int pulled = 0;
+
+	if (env->load_move <= 0)
+		return 0;
 
-	if (max_load_move == 0)
-		goto out;
+	while (!list_empty(tasks)) {
+		p = list_first_entry(tasks, struct task_struct, se.group_node);
 
-	list_for_each_entry_safe(p, n, &busiest_cfs_rq->tasks, se.group_node) {
-		if (loops++ > sysctl_sched_nr_migrate) {
-			*lb_flags |= LBF_NEED_BREAK;
+		env->loop++;
+		/* We've more or less seen every task there is, call it quits */
+		if (env->loop > env->loop_max)
+			break;
+
+		/* take a breather every nr_migrate tasks */
+		if (env->loop > env->loop_break) {
+			env->loop_break += sysctl_sched_nr_migrate;
+			env->flags |= LBF_NEED_BREAK;
 			break;
 		}
 
-		if ((p->se.load.weight >> 1) > rem_load_move ||
-		    !can_migrate_task(p, busiest, this_cpu, sd, idle,
-				      lb_flags))
-			continue;
+		if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
+			goto next;
+
+		load = task_h_load(p);
+
+		if (load < 16 && !env->sd->nr_balance_failed)
+			goto next;
+
+		if ((load / 2) > env->load_move)
+			goto next;
 
-		pull_task(busiest, p, this_rq, this_cpu);
+		if (!can_migrate_task(p, env))
+			goto next;
+
+		move_task(p, env);
 		pulled++;
-		rem_load_move -= p->se.load.weight;
+		env->load_move -= load;
 
 #ifdef CONFIG_PREEMPT
 		/*
@@ -3261,28 +3271,30 @@ balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		 * kernels will stop after the first task is pulled to minimize
 		 * the critical section.
 		 */
-		if (idle == CPU_NEWLY_IDLE) {
-			*lb_flags |= LBF_ABORT;
+		if (env->idle == CPU_NEWLY_IDLE)
 			break;
-		}
 #endif
 
 		/*
 		 * We only want to steal up to the prescribed amount of
 		 * weighted load.
 		 */
-		if (rem_load_move <= 0)
+		if (env->load_move <= 0)
 			break;
+
+		continue;
+next:
+		list_move_tail(&p->se.group_node, tasks);
 	}
-out:
+
 	/*
-	 * Right now, this is one of only two places pull_task() is called,
-	 * so we can safely collect pull_task() stats here rather than
-	 * inside pull_task().
+	 * Right now, this is one of only two places move_task() is called,
+	 * so we can safely collect move_task() stats here rather than
+	 * inside move_task().
 	 */
-	schedstat_add(sd, lb_gained[idle], pulled);
+	schedstat_add(env->sd, lb_gained[env->idle], pulled);
 
-	return max_load_move - rem_load_move;
+	return pulled;
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -3362,113 +3374,35 @@ static int tg_load_down(struct task_group *tg, void *data)
 
 static void update_h_load(long cpu)
 {
+	rcu_read_lock();
 	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
+	rcu_read_unlock();
 }
 
-static unsigned long
-load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		  unsigned long max_load_move,
-		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *lb_flags)
+static unsigned long task_h_load(struct task_struct *p)
 {
-	long rem_load_move = max_load_move;
-	struct cfs_rq *busiest_cfs_rq;
-
-	rcu_read_lock();
-	update_h_load(cpu_of(busiest));
-
-	for_each_leaf_cfs_rq(busiest, busiest_cfs_rq) {
-		unsigned long busiest_h_load = busiest_cfs_rq->h_load;
-		unsigned long busiest_weight = busiest_cfs_rq->load.weight;
-		u64 rem_load, moved_load;
-
-		if (*lb_flags & (LBF_NEED_BREAK|LBF_ABORT))
-			break;
-
-		/*
-		 * empty group or part of a throttled hierarchy
-		 */
-		if (!busiest_cfs_rq->task_weight ||
-		    throttled_lb_pair(busiest_cfs_rq->tg, cpu_of(busiest), this_cpu))
-			continue;
-
-		rem_load = (u64)rem_load_move * busiest_weight;
-		rem_load = div_u64(rem_load, busiest_h_load + 1);
-
-		moved_load = balance_tasks(this_rq, this_cpu, busiest,
-				rem_load, sd, idle, lb_flags,
-				busiest_cfs_rq);
-
-		if (!moved_load)
-			continue;
+	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	unsigned long load;
 
-		moved_load *= busiest_h_load;
-		moved_load = div_u64(moved_load, busiest_weight + 1);
+	load = p->se.load.weight;
+	load = div_u64(load * cfs_rq->h_load, cfs_rq->load.weight + 1);
 
-		rem_load_move -= moved_load;
-		if (rem_load_move < 0)
-			break;
-	}
-	rcu_read_unlock();
-
-	return max_load_move - rem_load_move;
+	return load;
 }
 #else
 static inline void update_shares(int cpu)
 {
 }
 
-static unsigned long
-load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		  unsigned long max_load_move,
-		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *lb_flags)
+static inline void update_h_load(long cpu)
 {
-	return balance_tasks(this_rq, this_cpu, busiest,
-			max_load_move, sd, idle, lb_flags,
-			&busiest->cfs);
 }
-#endif
 
-/*
- * move_tasks tries to move up to max_load_move weighted load from busiest to
- * this_rq, as part of a balancing operation within domain "sd".
- * Returns 1 if successful and 0 otherwise.
- *
- * Called with both runqueues locked.
- */
-static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		      unsigned long max_load_move,
-		      struct sched_domain *sd, enum cpu_idle_type idle,
-		      int *lb_flags)
+static unsigned long task_h_load(struct task_struct *p)
 {
-	unsigned long total_load_moved = 0, load_moved;
-
-	do {
-		load_moved = load_balance_fair(this_rq, this_cpu, busiest,
-				max_load_move - total_load_moved,
-				sd, idle, lb_flags);
-
-		total_load_moved += load_moved;
-
-		if (*lb_flags & (LBF_NEED_BREAK|LBF_ABORT))
-			break;
-
-#ifdef CONFIG_PREEMPT
-		/*
-		 * NEWIDLE balancing is a source of latency, so preemptible
-		 * kernels will stop after the first task is pulled to minimize
-		 * the critical section.
-		 */
-		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running) {
-			*lb_flags |= LBF_ABORT;
-			break;
-		}
-#endif
-	} while (load_moved && max_load_move > total_load_moved);
-
-	return total_load_moved > 0;
+	return p->se.load.weight;
 }
+#endif
 
 /********** Helpers for find_busiest_group ************************/
 /*
@@ -3778,6 +3712,11 @@ void update_group_power(struct sched_domain *sd, int cpu)
 	struct sched_domain *child = sd->child;
 	struct sched_group *group, *sdg = sd->groups;
 	unsigned long power;
+	unsigned long interval;
+
+	interval = msecs_to_jiffies(sd->balance_interval);
+	interval = clamp(interval, 1UL, max_load_balance_interval);
+	sdg->sgp->next_update = jiffies + interval;
 
 	if (!child) {
 		update_cpu_power(sd, cpu);
@@ -3885,12 +3824,15 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	 * domains. In the newly idle case, we will allow all the cpu's
 	 * to do the newly idle load balance.
 	 */
-	if (idle != CPU_NEWLY_IDLE && local_group) {
-		if (balance_cpu != this_cpu) {
-			*balance = 0;
-			return;
-		}
-		update_group_power(sd, this_cpu);
+	if (local_group) {
+		if (idle != CPU_NEWLY_IDLE) {
+			if (balance_cpu != this_cpu) {
+				*balance = 0;
+				return;
+			}
+			update_group_power(sd, this_cpu);
+		} else if (time_after_eq(jiffies, group->sgp->next_update))
+			update_group_power(sd, this_cpu);
 	}
 
 	/* Adjust by relative CPU power of the group */
@@ -4453,13 +4395,21 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 			struct sched_domain *sd, enum cpu_idle_type idle,
 			int *balance)
 {
-	int ld_moved, lb_flags = 0, active_balance = 0;
+	int ld_moved, active_balance = 0;
 	struct sched_group *group;
 	unsigned long imbalance;
 	struct rq *busiest;
 	unsigned long flags;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
+	struct lb_env env = {
+		.sd		= sd,
+		.dst_cpu	= this_cpu,
+		.dst_rq		= this_rq,
+		.idle		= idle,
+		.loop_break	= sysctl_sched_nr_migrate,
+	};
+
 	cpumask_copy(cpus, cpu_active_mask);
 
 	schedstat_inc(sd, lb_count[idle]);
@@ -4494,32 +4444,34 @@ redo:
 		 * still unbalanced. ld_moved simply stays zero, so it is
 		 * correctly treated as an imbalance.
 		 */
-		lb_flags |= LBF_ALL_PINNED;
+		env.flags |= LBF_ALL_PINNED;
+		env.load_move = imbalance;
+		env.src_cpu = busiest->cpu;
+		env.src_rq = busiest;
+		env.loop_max = busiest->nr_running;
+
+more_balance:
 		local_irq_save(flags);
 		double_rq_lock(this_rq, busiest);
-		ld_moved = move_tasks(this_rq, this_cpu, busiest,
-				      imbalance, sd, idle, &lb_flags);
+		if (!env.loop)
+			update_h_load(env.src_cpu);
+		ld_moved += move_tasks(&env);
 		double_rq_unlock(this_rq, busiest);
 		local_irq_restore(flags);
 
+		if (env.flags & LBF_NEED_BREAK) {
+			env.flags &= ~LBF_NEED_BREAK;
+			goto more_balance;
+		}
+
 		/*
 		 * some other cpu did the load balance for us.
 		 */
 		if (ld_moved && this_cpu != smp_processor_id())
 			resched_cpu(this_cpu);
 
-		if (lb_flags & LBF_ABORT)
-			goto out_balanced;
-
-		if (lb_flags & LBF_NEED_BREAK) {
-			lb_flags += LBF_HAD_BREAK - LBF_NEED_BREAK;
-			if (lb_flags & LBF_ABORT)
-				goto out_balanced;
-			goto redo;
-		}
-
 		/* All tasks on this runqueue were pinned by CPU affinity */
-		if (unlikely(lb_flags & LBF_ALL_PINNED)) {
+		if (unlikely(env.flags & LBF_ALL_PINNED)) {
 			cpumask_clear_cpu(cpu_of(busiest), cpus);
 			if (!cpumask_empty(cpus))
 				goto redo;
@@ -4549,7 +4501,7 @@ redo:
 					tsk_cpus_allowed(busiest->curr))) {
 				raw_spin_unlock_irqrestore(&busiest->lock,
 							    flags);
-				lb_flags |= LBF_ALL_PINNED;
+				env.flags |= LBF_ALL_PINNED;
 				goto out_one_pinned;
 			}
 
@@ -4602,7 +4554,7 @@ out_balanced:
 
 out_one_pinned:
 	/* tune up the balancing interval */
-	if (((lb_flags & LBF_ALL_PINNED) &&
+	if (((env.flags & LBF_ALL_PINNED) &&
 			sd->balance_interval < MAX_PINNED_INTERVAL) ||
 			(sd->balance_interval < sd->max_interval))
 		sd->balance_interval *= 2;
@@ -4712,10 +4664,18 @@ static int active_load_balance_cpu_stop(void *data)
 	}
 
 	if (likely(sd)) {
+		struct lb_env env = {
+			.sd		= sd,
+			.dst_cpu	= target_cpu,
+			.dst_rq		= target_rq,
+			.src_cpu	= busiest_rq->cpu,
+			.src_rq		= busiest_rq,
+			.idle		= CPU_IDLE,
+		};
+
 		schedstat_inc(sd, alb_count);
 
-		if (move_one_task(target_rq, target_cpu, busiest_rq,
-				  sd, CPU_IDLE))
+		if (move_one_task(&env))
 			schedstat_inc(sd, alb_pushed);
 		else
 			schedstat_inc(sd, alb_failed);
@@ -4947,8 +4907,6 @@ static int __cpuinit sched_ilb_notifier(struct notifier_block *nfb,
 
 static DEFINE_SPINLOCK(balancing);
 
-static unsigned long __read_mostly max_load_balance_interval = HZ/10;
-
 /*
  * Scale the max load_balance interval with the number of CPUs in the system.
  * This trades load-balance latency on larger machines for less cross talk.
@@ -5342,7 +5300,6 @@ static void set_curr_task_fair(struct rq *rq)
 void init_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	cfs_rq->tasks_timeline = RB_ROOT;
-	INIT_LIST_HEAD(&cfs_rq->tasks);
 	cfs_rq->min_vruntime = (u64)(-(1LL << 20));
 #ifndef CONFIG_64BIT
 	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
@@ -5614,6 +5571,7 @@ __init void init_sched_fair_class(void)
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
 
 #ifdef CONFIG_NO_HZ
+	nohz.next_balance = jiffies;
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
 	cpu_notifier(sched_ilb_notifier, 0);
 #endif
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index f42ae7f..b60dad7 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -778,12 +778,9 @@ static inline int balance_runtime(struct rt_rq *rt_rq)
 
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 {
-	int i, idle = 1;
+	int i, idle = 1, throttled = 0;
 	const struct cpumask *span;
 
-	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
-		return 1;
-
 	span = sched_rt_period_mask();
 	for_each_cpu(i, span) {
 		int enqueue = 0;
@@ -818,12 +815,17 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 			if (!rt_rq_throttled(rt_rq))
 				enqueue = 1;
 		}
+		if (rt_rq->rt_throttled)
+			throttled = 1;
 
 		if (enqueue)
 			sched_rt_rq_enqueue(rt_rq);
 		raw_spin_unlock(&rq->lock);
 	}
 
+	if (!throttled && (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF))
+		return 1;
+
 	return idle;
 }
 
@@ -855,8 +857,30 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 		return 0;
 
 	if (rt_rq->rt_time > runtime) {
-		rt_rq->rt_throttled = 1;
-		printk_once(KERN_WARNING "sched: RT throttling activated\n");
+		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+
+		/*
+		 * Don't actually throttle groups that have no runtime assigned
+		 * but accrue some time due to boosting.
+		 */
+		if (likely(rt_b->rt_runtime)) {
+			static bool once = false;
+
+			rt_rq->rt_throttled = 1;
+
+			if (!once) {
+				once = true;
+				printk_sched("sched: RT throttling activated\n");
+			}
+		} else {
+			/*
+			 * In case we did anyway, make it go away,
+			 * replenishment is a joke, since it will replenish us
+			 * with exactly 0 ns.
+			 */
+			rt_rq->rt_time = 0;
+		}
+
 		if (rt_rq_throttled(rt_rq)) {
 			sched_rt_rq_dequeue(rt_rq);
 			return 1;
@@ -884,7 +908,8 @@ static void update_curr_rt(struct rq *rq)
 	if (unlikely((s64)delta_exec < 0))
 		delta_exec = 0;
 
-	schedstat_set(curr->se.statistics.exec_max, max(curr->se.statistics.exec_max, delta_exec));
+	schedstat_set(curr->se.statistics.exec_max,
+		      max(curr->se.statistics.exec_max, delta_exec));
 
 	curr->se.sum_exec_runtime += delta_exec;
 	account_group_exec_runtime(curr, delta_exec);
@@ -1972,7 +1997,7 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 	if (--p->rt.time_slice)
 		return;
 
-	p->rt.time_slice = DEF_TIMESLICE;
+	p->rt.time_slice = RR_TIMESLICE;
 
 	/*
 	 * Requeue to the end of queue if we are not the only element
@@ -2000,7 +2025,7 @@ static unsigned int get_rr_interval_rt(struct rq *rq, struct task_struct *task)
 	 * Time slice is 0 for SCHED_FIFO tasks
 	 */
 	if (task->policy == SCHED_RR)
-		return DEF_TIMESLICE;
+		return RR_TIMESLICE;
 	else
 		return 0;
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 98c0c26..753bdd5 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -36,11 +36,7 @@ extern __read_mostly int scheduler_running;
 
 /*
  * These are the 'tuning knobs' of the scheduler:
- *
- * default timeslice is 100 msecs (used only for SCHED_RR tasks).
- * Timeslices get refilled after they expire.
  */
-#define DEF_TIMESLICE		(100 * HZ / 1000)
 
 /*
  * single value that denotes runtime == period, ie unlimited time.
@@ -216,9 +212,6 @@ struct cfs_rq {
 	struct rb_root tasks_timeline;
 	struct rb_node *rb_leftmost;
 
-	struct list_head tasks;
-	struct list_head *balance_iterator;
-
 	/*
 	 * 'curr' points to currently running entity on this cfs_rq.
 	 * It is set to NULL otherwise (i.e when none are currently running).
@@ -246,11 +239,6 @@ struct cfs_rq {
 
 #ifdef CONFIG_SMP
 	/*
-	 * the part of load.weight contributed by tasks
-	 */
-	unsigned long task_weight;
-
-	/*
 	 *   h_load = weight * f(tg)
 	 *
 	 * Where f(tg) is the recursive weight fraction assigned to
@@ -424,6 +412,8 @@ struct rq {
 	int cpu;
 	int online;
 
+	struct list_head cfs_tasks;
+
 	u64 rt_avg;
 	u64 age_stamp;
 	u64 idle_stamp;
@@ -462,7 +452,6 @@ struct rq {
 	unsigned int yld_count;
 
 	/* schedule() stats */
-	unsigned int sched_switch;
 	unsigned int sched_count;
 	unsigned int sched_goidle;
 
diff --git a/kernel/sched/stats.c b/kernel/sched/stats.c
index 2a581ba..903ffa9e 100644
--- a/kernel/sched/stats.c
+++ b/kernel/sched/stats.c
@@ -32,9 +32,9 @@ static int show_schedstat(struct seq_file *seq, void *v)
 
 		/* runqueue-specific stats */
 		seq_printf(seq,
-		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
+		    "cpu%d %u 0 %u %u %u %u %llu %llu %lu",
 		    cpu, rq->yld_count,
-		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
+		    rq->sched_count, rq->sched_goidle,
 		    rq->ttwu_count, rq->ttwu_local,
 		    rq->rq_cpu_time,
 		    rq->rq_sched_info.run_delay, rq->rq_sched_info.pcount);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 4eb3a0f..f268369 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -353,7 +353,7 @@ void irq_exit(void)
 		tick_nohz_irq_exit();
 #endif
 	rcu_irq_exit();
-	preempt_enable_no_resched();
+	sched_preempt_enable_no_resched();
 }
 
 /*
@@ -744,9 +744,7 @@ static int run_ksoftirqd(void * __bind_cpu)
 	while (!kthread_should_stop()) {
 		preempt_disable();
 		if (!local_softirq_pending()) {
-			preempt_enable_no_resched();
-			schedule();
-			preempt_disable();
+			schedule_preempt_disabled();
 		}
 
 		__set_current_state(TASK_RUNNING);
@@ -761,7 +759,7 @@ static int run_ksoftirqd(void * __bind_cpu)
 			if (local_softirq_pending())
 				__do_softirq();
 			local_irq_enable();
-			preempt_enable_no_resched();
+			sched_preempt_enable_no_resched();
 			cond_resched();
 			preempt_disable();
 			rcu_note_context_switch((long)__bind_cpu);
