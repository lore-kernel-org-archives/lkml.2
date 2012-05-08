Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab2EHM3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:29:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54790 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab2EHM3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:29:40 -0400
Date: Tue, 8 May 2012 05:29:27 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-bbe78cbd729f85c4da6e04f45c8b2de43c3573f1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tony.luck@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, tony.luck@intel.com
In-Reply-To: <20120507175652.392394511@linutronix.de>
References: <20120507175652.392394511@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] ia64: Remove unused cpu_idle_wait()
Git-Commit-ID: bbe78cbd729f85c4da6e04f45c8b2de43c3573f1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:29:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bbe78cbd729f85c4da6e04f45c8b2de43c3573f1
Gitweb:     http://git.kernel.org/tip/bbe78cbd729f85c4da6e04f45c8b2de43c3573f1
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 7 May 2012 17:59:50 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 12:35:06 +0200

ia64: Remove unused cpu_idle_wait()

IA64 does not set CONFIG_ARCH_HAVE_IDLE_WAIT and cpuidle uses a
generic function now. Remove the unused code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/20120507175652.392394511@linutronix.de
---
 arch/ia64/include/asm/processor.h |    1 -
 arch/ia64/kernel/process.c        |   20 --------------------
 2 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
index 483f6c6..f92f67a 100644
--- a/arch/ia64/include/asm/processor.h
+++ b/arch/ia64/include/asm/processor.h
@@ -723,7 +723,6 @@ extern unsigned long boot_option_idle_override;
 enum idle_boot_override {IDLE_NO_OVERRIDE=0, IDLE_HALT, IDLE_FORCE_MWAIT,
 			 IDLE_NOMWAIT, IDLE_POLL};
 
-void cpu_idle_wait(void);
 void default_idle(void);
 
 #define ia64_platform_is(x) (strcmp(x, platform_name) == 0)
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index ce74e14..5e0e86d 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
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
