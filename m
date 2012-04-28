Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab2D1Gdb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 02:33:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:61375 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab2D1Gd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 02:33:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="94099233"
From: Feng Tang <feng.tang@intel.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH] Revert "x86/platform: Add a wallclock_init func to x86_platforms ops"
Date: Sat, 28 Apr 2012 14:30:40 +0800
Message-Id: <1335594640-21182-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit cf8ff6b6ab0e99dd3058852f4ec76a6140abadec.

Just find this commit is a function duplicatation of commit 6b617e22
"x86/platform: Add a wallclock_init func to x86_init.timers ops".
Let's revert it and sorry for the noise.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/x86/include/asm/x86_init.h |    2 --
 arch/x86/kernel/setup.c         |    2 --
 arch/x86/kernel/x86_init.c      |    2 --
 3 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 764b66a..19675b6 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -156,7 +156,6 @@ struct x86_cpuinit_ops {
 /**
  * struct x86_platform_ops - platform specific runtime functions
  * @calibrate_tsc:		calibrate TSC
- * @wallclock_init:		init the wallclock device
  * @get_wallclock:		get time from HW clock like RTC etc.
  * @set_wallclock:		set time back to HW clock
  * @is_untracked_pat_range	exclude from PAT logic
@@ -167,7 +166,6 @@ struct x86_cpuinit_ops {
  */
 struct x86_platform_ops {
 	unsigned long (*calibrate_tsc)(void);
-	void (*wallclock_init)(void);
 	unsigned long (*get_wallclock)(void);
 	int (*set_wallclock)(unsigned long nowtime);
 	void (*iommu_shutdown)(void);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1a29015..15f59fa 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1035,8 +1035,6 @@ void __init setup_arch(char **cmdline_p)
 
 	x86_init.timers.wallclock_init();
 
-	x86_platform.wallclock_init();
-
 	mcheck_init();
 
 	arch_init_ideal_nops();
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 9cf71d0..b815f72 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -28,7 +28,6 @@ void __init x86_init_uint_noop(unsigned int unused) { }
 void __init x86_init_pgd_noop(pgd_t *unused) { }
 int __init iommu_init_noop(void) { return 0; }
 void iommu_shutdown_noop(void) { }
-void wallclock_init_noop(void) { }
 
 /*
  * The platform setup functions are preset with the default functions
@@ -100,7 +99,6 @@ static int default_i8042_detect(void) { return 1; };
 
 struct x86_platform_ops x86_platform = {
 	.calibrate_tsc			= native_calibrate_tsc,
-	.wallclock_init			= wallclock_init_noop,
 	.get_wallclock			= mach_get_cmos_time,
 	.set_wallclock			= mach_set_rtc_mmss,
 	.iommu_shutdown			= iommu_shutdown_noop,
-- 
1.7.1

