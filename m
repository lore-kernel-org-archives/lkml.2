Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab2EHMac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:30:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54815 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab2EHMab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:30:31 -0400
Date: Tue, 8 May 2012 05:30:17 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-c9b92b840705542a1ae50b5407154a5595d17359@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        benh@kernel.crashing.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20120507175652.330322737@linutronix.de>
References: <20120507175652.330322737@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] powerpc: Remove unused cpu_idle_wait()
Git-Commit-ID: c9b92b840705542a1ae50b5407154a5595d17359
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:30:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9b92b840705542a1ae50b5407154a5595d17359
Gitweb:     http://git.kernel.org/tip/c9b92b840705542a1ae50b5407154a5595d17359
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 7 May 2012 17:59:50 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 12:35:07 +0200

powerpc: Remove unused cpu_idle_wait()

cpuidle uses a generic function now. Remove the cruft.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Link: http://lkml.kernel.org/r/20120507175652.330322737@linutronix.de
---
 arch/powerpc/Kconfig                 |    4 ----
 arch/powerpc/include/asm/processor.h |    1 -
 arch/powerpc/kernel/idle.c           |   19 -------------------
 3 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index c815535..296e4f9 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -87,10 +87,6 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default y if 64BIT
 
-config ARCH_HAS_CPU_IDLE_WAIT
-	bool
-	default y
-
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index 8e2d037..48a26d3 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -386,7 +386,6 @@ extern unsigned long cpuidle_disable;
 enum idle_boot_override {IDLE_NO_OVERRIDE = 0, IDLE_POWERSAVE_OFF};
 
 extern int powersave_nap;	/* set if nap mode can be used in idle loop */
-void cpu_idle_wait(void);
 
 #ifdef CONFIG_PSERIES_IDLE
 extern void update_smt_snooze_delay(int snooze);
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 04d7909..2099d9a 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -113,25 +113,6 @@ void cpu_idle(void)
 	}
 }
 
-static void do_nothing(void *unused)
-{
-}
-
-/*
- * cpu_idle_wait - Used to ensure that all the CPUs come out of the old
- * idle loop and start using the new idle loop.
- * Required while changing idle handler on SMP systems.
- * Caller must have changed idle handler to the new value before the call.
- * This window may be larger on shared systems.
- */
-void cpu_idle_wait(void)
-{
-	smp_mb();
-	/* kick all the CPUs so that they exit out of pm_idle */
-	smp_call_function(do_nothing, NULL, 1);
-}
-EXPORT_SYMBOL_GPL(cpu_idle_wait);
-
 int powersave_nap;
 
 #ifdef CONFIG_SYSCTL
