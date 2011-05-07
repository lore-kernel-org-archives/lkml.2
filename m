Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab1EGF5V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 01:57:21 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8391 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab1EGF5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 01:57:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6338"; a="89861682"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-m32r@ml.linux-m32r.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        user-mode-linux-devel@lists.sourceforge.net, x86@kernel.org
Subject: [PATCH] lib: Consolidate DEBUG_STACK_USAGE option
Date: Fri,  6 May 2011 22:57:11 -0700
Message-Id: <1304747831-2098-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.5.185.g0b9dee
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most arches define CONFIG_DEBUG_STACK_USAGE exactly the same way.
Move it to lib/Kconfig.debug so each arch doesn't have to define
it. This obviously makes the option generic, but that's fine
because the config is already used in generic code.

It's not obvious to me that sysrq-P actually does anything
different with this option enabled, but I erred on the side of
caution by keeping the most inclusive wording.

Cc: linux-arch@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-m32r@ml.linux-m32r.org
Cc: linux-mips@linux-mips.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-sh@vger.kernel.org
Cc: sparclinux@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: user-mode-linux-devel@lists.sourceforge.net
Cc: x86@kernel.org
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

This is on top of mmotm's lib-conslidate-debug_per_cpu_maps patch.

 arch/arm/Kconfig.debug       |    7 -------
 arch/blackfin/Kconfig.debug  |    9 ---------
 arch/m32r/Kconfig.debug      |    9 ---------
 arch/mips/Kconfig.debug      |    9 ---------
 arch/powerpc/Kconfig.debug   |    9 ---------
 arch/score/Kconfig.debug     |    9 ---------
 arch/sh/Kconfig.debug        |    9 ---------
 arch/sparc/Kconfig.debug     |    9 ---------
 arch/tile/Kconfig.debug      |    9 ---------
 arch/um/Kconfig.debug        |    9 ---------
 arch/unicore32/Kconfig.debug |    7 -------
 arch/x86/Kconfig.debug       |    9 ---------
 lib/Kconfig.debug            |    9 +++++++++
 13 files changed, 9 insertions(+), 104 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 03d01d7..81cbe40 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -63,13 +63,6 @@ config DEBUG_USER
 	      8 - SIGSEGV faults
 	     16 - SIGBUS faults
 
-config DEBUG_STACK_USAGE
-	bool "Enable stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T output.
-
 # These options are only for real kernel hackers who want to get their hands dirty.
 config DEBUG_LL
 	bool "Kernel low-level debugging functions"
diff --git a/arch/blackfin/Kconfig.debug b/arch/blackfin/Kconfig.debug
index 2641731..19ccfb3 100644
--- a/arch/blackfin/Kconfig.debug
+++ b/arch/blackfin/Kconfig.debug
@@ -9,15 +9,6 @@ config DEBUG_STACKOVERFLOW
 	  This option will cause messages to be printed if free stack space
 	  drops below a certain limit.
 
-config DEBUG_STACK_USAGE
-	bool "Enable stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T output.
-
-	  This option will slow down process creation somewhat.
-
 config DEBUG_VERBOSE
 	bool "Verbose fault messages"
 	default y
diff --git a/arch/m32r/Kconfig.debug b/arch/m32r/Kconfig.debug
index 2e1019d..bb1afc1 100644
--- a/arch/m32r/Kconfig.debug
+++ b/arch/m32r/Kconfig.debug
@@ -9,15 +9,6 @@ config DEBUG_STACKOVERFLOW
 	  This option will cause messages to be printed if free stack space
 	  drops below a certain limit.
 
-config DEBUG_STACK_USAGE
-	bool "Stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T and sysrq-P debug output.
-
-	  This option will slow down process creation somewhat.
-
 config DEBUG_PAGEALLOC
 	bool "Debug page memory allocations"
 	depends on DEBUG_KERNEL && BROKEN
diff --git a/arch/mips/Kconfig.debug b/arch/mips/Kconfig.debug
index 5358f90..83ed00a 100644
--- a/arch/mips/Kconfig.debug
+++ b/arch/mips/Kconfig.debug
@@ -76,15 +76,6 @@ config DEBUG_STACKOVERFLOW
 	  provides another way to check stack overflow happened on kernel mode
 	  stack usually caused by nested interruption.
 
-config DEBUG_STACK_USAGE
-	bool "Enable stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T and sysrq-P debug output.
-
-	  This option will slow down process creation somewhat.
-
 config SMTC_IDLE_HOOK_DEBUG
 	bool "Enable additional debug checks before going into CPU idle loop"
 	depends on DEBUG_KERNEL && MIPS_MT_SMTC
diff --git a/arch/powerpc/Kconfig.debug b/arch/powerpc/Kconfig.debug
index 12a8d18..f862fc0 100644
--- a/arch/powerpc/Kconfig.debug
+++ b/arch/powerpc/Kconfig.debug
@@ -35,15 +35,6 @@ config DEBUG_STACKOVERFLOW
 	  This option will cause messages to be printed if free stack space
 	  drops below a certain limit.
 
-config DEBUG_STACK_USAGE
-	bool "Stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T and sysrq-P debug output.
-
-	  This option will slow down process creation somewhat.
-
 config HCALL_STATS
 	bool "Hypervisor call instrumentation"
 	depends on PPC_PSERIES && DEBUG_FS && TRACEPOINTS
diff --git a/arch/score/Kconfig.debug b/arch/score/Kconfig.debug
index 451ed54..a1f346d 100644
--- a/arch/score/Kconfig.debug
+++ b/arch/score/Kconfig.debug
@@ -16,15 +16,6 @@ config CMDLINE
 	  other cases you can specify kernel args so that you don't have
 	  to set them up in board prom initialization routines.
 
-config DEBUG_STACK_USAGE
-	bool "Enable stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T and sysrq-P debug output.
-
-	  This option will slow down process creation somewhat.
-
 config RUNTIME_DEBUG
 	bool "Enable run-time debugging"
 	depends on DEBUG_KERNEL
diff --git a/arch/sh/Kconfig.debug b/arch/sh/Kconfig.debug
index 1553d56..c1d5a82 100644
--- a/arch/sh/Kconfig.debug
+++ b/arch/sh/Kconfig.debug
@@ -28,15 +28,6 @@ config STACK_DEBUG
 	  every function call and will therefore incur a major
 	  performance hit. Most users should say N.
 
-config DEBUG_STACK_USAGE
-	bool "Stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T and sysrq-P debug output.
-
-	  This option will slow down process creation somewhat.
-
 config 4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
 	depends on DEBUG_KERNEL && (MMU || BROKEN) && !PAGE_SIZE_64KB
diff --git a/arch/sparc/Kconfig.debug b/arch/sparc/Kconfig.debug
index d9a795e..6db35fb 100644
--- a/arch/sparc/Kconfig.debug
+++ b/arch/sparc/Kconfig.debug
@@ -6,15 +6,6 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
-config DEBUG_STACK_USAGE
-	bool "Enable stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T and sysrq-P debug output.
-
-	  This option will slow down process creation somewhat.
-
 config DEBUG_DCFLUSH
 	bool "D-cache flush debugging"
 	depends on SPARC64 && DEBUG_KERNEL
diff --git a/arch/tile/Kconfig.debug b/arch/tile/Kconfig.debug
index 9bc161a..ddbfc33 100644
--- a/arch/tile/Kconfig.debug
+++ b/arch/tile/Kconfig.debug
@@ -21,15 +21,6 @@ config DEBUG_STACKOVERFLOW
 	  This option will cause messages to be printed if free stack space
 	  drops below a certain limit.
 
-config DEBUG_STACK_USAGE
-	bool "Stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T and sysrq-P debug output.
-
-	  This option will slow down process creation somewhat.
-
 config DEBUG_EXTRA_FLAGS
 	string "Additional compiler arguments when building with '-g'"
 	depends on DEBUG_INFO
diff --git a/arch/um/Kconfig.debug b/arch/um/Kconfig.debug
index 8fce5e5..34ac57f 100644
--- a/arch/um/Kconfig.debug
+++ b/arch/um/Kconfig.debug
@@ -28,13 +28,4 @@ config GCOV
 	  If you're involved in UML kernel development and want to use gcov,
 	  say Y.  If you're unsure, say N.
 
-config DEBUG_STACK_USAGE
-	bool "Stack utilization instrumentation"
-	default N
-	help
-	  Track the maximum kernel stack usage - this will look at each
-	  kernel stack at process exit and log it if it's the deepest
-	  stack seen so far.
-
-	  This option will slow down process creation and destruction somewhat.
 endmenu
diff --git a/arch/unicore32/Kconfig.debug b/arch/unicore32/Kconfig.debug
index 3140151..ae2ec33 100644
--- a/arch/unicore32/Kconfig.debug
+++ b/arch/unicore32/Kconfig.debug
@@ -27,13 +27,6 @@ config EARLY_PRINTK
 	  with klogd/syslogd or the X server. You should normally N here,
 	  unless you want to debug such a crash.
 
-config DEBUG_STACK_USAGE
-	bool "Enable stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T output.
-
 # These options are only for real kernel hackers who want to get their hands dirty.
 config DEBUG_LL
 	bool "Kernel low-level debugging functions"
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 1bf8839..c0f8a5c 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -66,15 +66,6 @@ config DEBUG_STACKOVERFLOW
 	  This option will cause messages to be printed if free stack space
 	  drops below a certain limit.
 
-config DEBUG_STACK_USAGE
-	bool "Stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	---help---
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T and sysrq-P debug output.
-
-	  This option will slow down process creation somewhat.
-
 config X86_PTDUMP
 	bool "Export kernel pagetable layout to userspace via debugfs"
 	depends on DEBUG_KERNEL
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c0872ee..37fae12 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -654,6 +654,15 @@ config STACKTRACE
 	bool
 	depends on STACKTRACE_SUPPORT
 
+config DEBUG_STACK_USAGE
+	bool "Stack utilization instrumentation"
+	depends on DEBUG_KERNEL
+	help
+	  Enables the display of the minimum amount of free stack which each
+	  task has ever had available in the sysrq-T and sysrq-P debug output.
+
+	  This option will slow down process creation somewhat.
+
 config DEBUG_KOBJECT
 	bool "kobject debugging"
 	depends on DEBUG_KERNEL
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

