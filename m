Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab2EHM3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:29:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54772 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab2EHM3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:29:11 -0400
Date: Tue, 8 May 2012 05:28:37 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-448eca90932d97856b6a6097fc50eef96d77dec0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        linux@arm.linux.org.uk, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20120507175652.260797846@linutronix.de>
References: <20120507175652.260797846@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] arm: Remove unused cpu_idle_wait()
Git-Commit-ID: 448eca90932d97856b6a6097fc50eef96d77dec0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:28:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  448eca90932d97856b6a6097fc50eef96d77dec0
Gitweb:     http://git.kernel.org/tip/448eca90932d97856b6a6097fc50eef96d77dec0
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 7 May 2012 17:59:49 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 12:35:06 +0200

arm: Remove unused cpu_idle_wait()

cpuidle uses a generic function now. Remove the unused code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King <linux@arm.linux.org.uk>
Link: http://lkml.kernel.org/r/20120507175652.260797846@linutronix.de
---
 arch/arm/Kconfig                 |    3 ---
 arch/arm/include/asm/processor.h |    2 --
 arch/arm/kernel/process.c        |   20 --------------------
 3 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index cb253ce..a3ad496 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -160,9 +160,6 @@ config ARCH_HAS_CPUFREQ
 	  and that the relevant menu configurations are displayed for
 	  it.
 
-config ARCH_HAS_CPU_IDLE_WAIT
-       def_bool y
-
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/arm/include/asm/processor.h b/arch/arm/include/asm/processor.h
index 5ac8d3d..d7038fa 100644
--- a/arch/arm/include/asm/processor.h
+++ b/arch/arm/include/asm/processor.h
@@ -88,8 +88,6 @@ unsigned long get_wchan(struct task_struct *p);
 #define cpu_relax()			barrier()
 #endif
 
-void cpu_idle_wait(void);
-
 /*
  * Create a new kernel thread
  */
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 2b7b017..19c95ea 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
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
