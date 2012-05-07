Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab2EGSBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 14:01:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:41402 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab2EGR7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:59:51 -0400
Message-Id: <20120507175652.392394511@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 07 May 2012 17:59:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Tony Luck <tony.luck@intel.com>
Subject: [patch 7/8] ia64: Remove unused cpu_idle_wait()
References: <20120507175450.513667947@linutronix.de>
Content-Disposition: inline; filename=ia64-use-kick_all_cpus_sync.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IA64 does not set CONFIG_ARCH_HAVE_IDLE_WAIT and cpuidle uses a
generic function now. Remove the unused code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/include/asm/processor.h |    1 -
 arch/ia64/kernel/process.c        |   20 --------------------
 2 files changed, 21 deletions(-)

Index: tip/arch/ia64/include/asm/processor.h
===================================================================
--- tip.orig/arch/ia64/include/asm/processor.h
+++ tip/arch/ia64/include/asm/processor.h
@@ -723,7 +723,6 @@ extern unsigned long boot_option_idle_ov
 enum idle_boot_override {IDLE_NO_OVERRIDE=0, IDLE_HALT, IDLE_FORCE_MWAIT,
 			 IDLE_NOMWAIT, IDLE_POLL};
 
-void cpu_idle_wait(void);
 void default_idle(void);
 
 #define ia64_platform_is(x) (strcmp(x, platform_name) == 0)
Index: tip/arch/ia64/kernel/process.c
===================================================================
--- tip.orig/arch/ia64/kernel/process.c
+++ tip/arch/ia64/kernel/process.c
@@ -273,26 +273,6 @@ static inline void play_dead(void)
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
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
 void __attribute__((noreturn))
 cpu_idle (void)
 {


