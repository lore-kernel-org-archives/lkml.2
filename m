Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab2EGR7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 13:59:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:41391 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab2EGR7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:59:50 -0400
Message-Id: <20120507175652.260797846@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 07 May 2012 17:59:49 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [patch 5/8] arm: Remove unused cpu_idle_wait()
References: <20120507175450.513667947@linutronix.de>
Content-Disposition: inline; filename=arm-use-kick_all_cpus_sync.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuidle uses a generic function now. Remove the unused code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/Kconfig                 |    3 ---
 arch/arm/include/asm/processor.h |    2 --
 arch/arm/kernel/process.c        |   20 --------------------
 3 files changed, 25 deletions(-)

Index: tip/arch/arm/Kconfig
===================================================================
--- tip.orig/arch/arm/Kconfig
+++ tip/arch/arm/Kconfig
@@ -160,9 +160,6 @@ config ARCH_HAS_CPUFREQ
 	  and that the relevant menu configurations are displayed for
 	  it.
 
-config ARCH_HAS_CPU_IDLE_WAIT
-       def_bool y
-
 config GENERIC_HWEIGHT
 	bool
 	default y
Index: tip/arch/arm/include/asm/processor.h
===================================================================
--- tip.orig/arch/arm/include/asm/processor.h
+++ tip/arch/arm/include/asm/processor.h
@@ -88,8 +88,6 @@ unsigned long get_wchan(struct task_stru
 #define cpu_relax()			barrier()
 #endif
 
-void cpu_idle_wait(void);
-
 /*
  * Create a new kernel thread
  */
Index: tip/arch/arm/kernel/process.c
===================================================================
--- tip.orig/arch/arm/kernel/process.c
+++ tip/arch/arm/kernel/process.c
@@ -157,26 +157,6 @@ EXPORT_SYMBOL(pm_power_off);
 void (*arm_pm_restart)(char str, const char *cmd) = null_restart;
 EXPORT_SYMBOL_GPL(arm_pm_restart);
 
-static void do_nothing(void *unused)
-{
-}
-
-/*
- * cpu_idle_wait - Used to ensure that all the CPUs discard old value of
- * pm_idle and update to new pm_idle value. Required while changing pm_idle
- * handler on SMP systems.
- *
- * Caller must have changed pm_idle to the new value before the call. Old
- * pm_idle value will not be used by any CPU after the return of this function.
- */
-void cpu_idle_wait(void)
-{
-	smp_mb();
-	/* kick all the CPUs so that they exit out of pm_idle */
-	smp_call_function(do_nothing, NULL, 1);
-}
-EXPORT_SYMBOL_GPL(cpu_idle_wait);
-
 /*
  * This is our default idle handler.
  */


