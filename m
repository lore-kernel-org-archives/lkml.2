Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317Ab2CAMTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:19:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37507 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab2CAMTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:19:08 -0500
Date: Thu, 1 Mar 2012 04:18:18 -0800
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-24swm5zut3h9c4a6s46x8rws@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Use schedule_preempt_disabled()
Git-Commit-ID: bd2f55361f18347e890d52ff9cfd8895455ec11b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 01 Mar 2012 04:18:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd2f55361f18347e890d52ff9cfd8895455ec11b
Gitweb:     http://git.kernel.org/tip/bd2f55361f18347e890d52ff9cfd8895455ec11b
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 21 Mar 2011 12:33:18 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Mar 2012 10:28:03 +0100

sched/rt: Use schedule_preempt_disabled()

Coccinelle based conversion.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-24swm5zut3h9c4a6s46x8rws@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/arm/kernel/process.c              |    4 +---
 arch/avr32/kernel/process.c            |    4 +---
 arch/blackfin/kernel/process.c         |    4 +---
 arch/cris/kernel/process.c             |    4 +---
 arch/frv/kernel/process.c              |    4 +---
 arch/h8300/kernel/process.c            |    4 +---
 arch/ia64/kernel/process.c             |    4 +---
 arch/m32r/kernel/process.c             |    4 +---
 arch/m68k/kernel/process_mm.c          |    4 +---
 arch/m68k/kernel/process_no.c          |    4 +---
 arch/microblaze/kernel/process.c       |    4 +---
 arch/mips/kernel/process.c             |    4 +---
 arch/mn10300/kernel/process.c          |    4 +---
 arch/parisc/kernel/process.c           |    4 +---
 arch/powerpc/kernel/idle.c             |    8 ++++----
 arch/powerpc/platforms/iseries/setup.c |    8 ++------
 arch/s390/kernel/process.c             |    4 +---
 arch/score/kernel/process.c            |    4 +---
 arch/sh/kernel/idle.c                  |    4 +---
 arch/sparc/kernel/process_32.c         |    8 ++------
 arch/sparc/kernel/process_64.c         |   10 ++++------
 arch/tile/kernel/process.c             |    4 +---
 arch/x86/kernel/process_32.c           |    4 +---
 arch/x86/kernel/process_64.c           |    4 +---
 arch/xtensa/kernel/process.c           |    4 +---
 init/main.c                            |    5 +----
 kernel/mutex.c                         |    4 +---
 kernel/softirq.c                       |    4 +---
 28 files changed, 36 insertions(+), 95 deletions(-)

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
index 0a48bf5..6503514 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -101,11 +101,11 @@ void cpu_idle(void)
 		ppc64_runlatch_on();
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		if (cpu_should_die())
+		if (cpu_should_die()) {
+			preempt_enable_no_resched();
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
index 39d8b05..ab9a292 100644
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
+			preempt_enable_no_resched();
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
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 4eb3a0f..79b5247 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
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
