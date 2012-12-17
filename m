Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab2LQSWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 13:22:30 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:45179 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab2LQSWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 13:22:23 -0500
Subject: [PATCH 4/7] consolidate RCU debugging Kconfig options
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-arch@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Mon, 17 Dec 2012 13:22:11 -0500
References: <20121217182206.91AA150A@kernel.stglabs.ibm.com>
In-Reply-To: <20121217182206.91AA150A@kernel.stglabs.ibm.com>
Message-Id: <20121217182211.F300A6BF@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121718-5406-0000-0000-0000034C02B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These were in two different places, and taking up too much of my
valuable screen real-estate.  Banish them to their own menu.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/lib/Kconfig.debug |  160 +++++++++++++++++------------------
 1 file changed, 82 insertions(+), 78 deletions(-)

diff -puN lib/Kconfig.debug~consolidat-rcu-debugging-configs lib/Kconfig.debug
--- linux-2.6.git/lib/Kconfig.debug~consolidat-rcu-debugging-configs	2012-12-14 13:32:32.474878413 -0500
+++ linux-2.6.git-dave/lib/Kconfig.debug	2012-12-14 13:32:49.219018930 -0500
@@ -720,6 +720,8 @@ config PROVE_LOCKING
 
 	 For more details, see Documentation/lockdep-design.txt.
 
+menu "RCU Debugging"
+
 config PROVE_RCU
 	bool "RCU debugging: prove RCU correctness"
 	depends on PROVE_LOCKING
@@ -775,6 +777,86 @@ config SPARSE_RCU_POINTER
 
 	 Say N if you are unsure.
 
+config RCU_TORTURE_TEST
+	tristate "torture tests for RCU"
+	depends on DEBUG_KERNEL
+	default n
+	help
+	  This option provides a kernel module that runs torture tests
+	  on the RCU infrastructure.  The kernel module may be built
+	  after the fact on the running kernel to be tested, if desired.
+
+	  Say Y here if you want RCU torture tests to be built into
+	  the kernel.
+	  Say M if you want the RCU torture tests to build as a module.
+	  Say N if you are unsure.
+
+config RCU_TORTURE_TEST_RUNNABLE
+	bool "torture tests for RCU runnable by default"
+	depends on RCU_TORTURE_TEST = y
+	default n
+	help
+	  This option provides a way to build the RCU torture tests
+	  directly into the kernel without them starting up at boot
+	  time.  You can use /proc/sys/kernel/rcutorture_runnable
+	  to manually override this setting.  This /proc file is
+	  available only when the RCU torture tests have been built
+	  into the kernel.
+
+	  Say Y here if you want the RCU torture tests to start during
+	  boot (you probably don't).
+	  Say N here if you want the RCU torture tests to start only
+	  after being manually enabled via /proc.
+
+config RCU_CPU_STALL_TIMEOUT
+	int "RCU CPU stall timeout in seconds"
+	depends on TREE_RCU || TREE_PREEMPT_RCU
+	range 3 300
+	default 60
+	help
+	  If a given RCU grace period extends more than the specified
+	  number of seconds, a CPU stall warning is printed.  If the
+	  RCU grace period persists, additional CPU stall warnings are
+	  printed at more widely spaced intervals.
+
+config RCU_CPU_STALL_VERBOSE
+	bool "Print additional per-task information for RCU_CPU_STALL_DETECTOR"
+	depends on TREE_PREEMPT_RCU
+	default y
+	help
+	  This option causes RCU to printk detailed per-task information
+	  for any tasks that are stalling the current RCU grace period.
+
+	  Say N if you are unsure.
+
+	  Say Y if you want to enable such checks.
+
+config RCU_CPU_STALL_INFO
+	bool "Print additional diagnostics on RCU CPU stall"
+	depends on (TREE_RCU || TREE_PREEMPT_RCU) && DEBUG_KERNEL
+	default n
+	help
+	  For each stalled CPU that is aware of the current RCU grace
+	  period, print out additional per-CPU diagnostic information
+	  regarding scheduling-clock ticks, idle state, and,
+	  for RCU_FAST_NO_HZ kernels, idle-entry state.
+
+	  Say N if you are unsure.
+
+	  Say Y if you want to enable such diagnostics.
+
+config RCU_TRACE
+	bool "Enable tracing for RCU"
+	depends on DEBUG_KERNEL
+	help
+	  This option provides tracing in RCU which presents stats
+	  in debugfs for debugging RCU implementation.
+
+	  Say Y here if you want to enable RCU tracing
+	  Say N if you are unsure.
+
+endmenu # RCU Debugging
+
 config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
@@ -990,84 +1072,6 @@ config BOOT_PRINTK_DELAY
 	  BOOT_PRINTK_DELAY also may cause LOCKUP_DETECTOR to detect
 	  what it believes to be lockup conditions.
 
-config RCU_TORTURE_TEST
-	tristate "torture tests for RCU"
-	depends on DEBUG_KERNEL
-	default n
-	help
-	  This option provides a kernel module that runs torture tests
-	  on the RCU infrastructure.  The kernel module may be built
-	  after the fact on the running kernel to be tested, if desired.
-
-	  Say Y here if you want RCU torture tests to be built into
-	  the kernel.
-	  Say M if you want the RCU torture tests to build as a module.
-	  Say N if you are unsure.
-
-config RCU_TORTURE_TEST_RUNNABLE
-	bool "torture tests for RCU runnable by default"
-	depends on RCU_TORTURE_TEST = y
-	default n
-	help
-	  This option provides a way to build the RCU torture tests
-	  directly into the kernel without them starting up at boot
-	  time.  You can use /proc/sys/kernel/rcutorture_runnable
-	  to manually override this setting.  This /proc file is
-	  available only when the RCU torture tests have been built
-	  into the kernel.
-
-	  Say Y here if you want the RCU torture tests to start during
-	  boot (you probably don't).
-	  Say N here if you want the RCU torture tests to start only
-	  after being manually enabled via /proc.
-
-config RCU_CPU_STALL_TIMEOUT
-	int "RCU CPU stall timeout in seconds"
-	depends on TREE_RCU || TREE_PREEMPT_RCU
-	range 3 300
-	default 21
-	help
-	  If a given RCU grace period extends more than the specified
-	  number of seconds, a CPU stall warning is printed.  If the
-	  RCU grace period persists, additional CPU stall warnings are
-	  printed at more widely spaced intervals.
-
-config RCU_CPU_STALL_VERBOSE
-	bool "Print additional per-task information for RCU_CPU_STALL_DETECTOR"
-	depends on TREE_PREEMPT_RCU
-	default y
-	help
-	  This option causes RCU to printk detailed per-task information
-	  for any tasks that are stalling the current RCU grace period.
-
-	  Say N if you are unsure.
-
-	  Say Y if you want to enable such checks.
-
-config RCU_CPU_STALL_INFO
-	bool "Print additional diagnostics on RCU CPU stall"
-	depends on (TREE_RCU || TREE_PREEMPT_RCU) && DEBUG_KERNEL
-	default n
-	help
-	  For each stalled CPU that is aware of the current RCU grace
-	  period, print out additional per-CPU diagnostic information
-	  regarding scheduling-clock ticks, idle state, and,
-	  for RCU_FAST_NO_HZ kernels, idle-entry state.
-
-	  Say N if you are unsure.
-
-	  Say Y if you want to enable such diagnostics.
-
-config RCU_TRACE
-	bool "Enable tracing for RCU"
-	depends on DEBUG_KERNEL
-	help
-	  This option provides tracing in RCU which presents stats
-	  in debugfs for debugging RCU implementation.
-
-	  Say Y here if you want to enable RCU tracing
-	  Say N if you are unsure.
-
 config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL
_

