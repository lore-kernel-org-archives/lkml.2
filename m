Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab2KPCXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 21:23:15 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49227 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab2KPCVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 21:21:47 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 3/9] irq_work: Remove CONFIG_HAVE_IRQ_WORK
Date: Fri, 16 Nov 2012 03:21:25 +0100
Message-Id: <1353032491-16462-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353032491-16462-1-git-send-email-fweisbec@gmail.com>
References: <1353032491-16462-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq work can run on any arch even without IPI
support because of the hook on update_process_times().

So lets remove HAVE_IRQ_WORK because it doesn't reflect
any backend requirement.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/alpha/Kconfig                  |    1 -
 arch/arm/Kconfig                    |    1 -
 arch/arm64/Kconfig                  |    1 -
 arch/blackfin/Kconfig               |    1 -
 arch/frv/Kconfig                    |    1 -
 arch/hexagon/Kconfig                |    1 -
 arch/mips/Kconfig                   |    1 -
 arch/parisc/Kconfig                 |    1 -
 arch/powerpc/Kconfig                |    1 -
 arch/s390/Kconfig                   |    1 -
 arch/sh/Kconfig                     |    1 -
 arch/sparc/Kconfig                  |    1 -
 arch/x86/Kconfig                    |    1 -
 drivers/staging/iio/trigger/Kconfig |    1 -
 init/Kconfig                        |    4 ----
 15 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 5dd7f5d..e56c2d1 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -5,7 +5,6 @@ config ALPHA
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_SYSCALL_WRAPPERS
-	select HAVE_IRQ_WORK
 	select HAVE_PCSPKR_PLATFORM
 	select HAVE_PERF_EVENTS
 	select HAVE_DMA_ATTRS
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ade7e92..22d378b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -36,7 +36,6 @@ config ARM
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_HW_BREAKPOINT if (PERF_EVENTS && (CPU_V6 || CPU_V6K || CPU_V7))
 	select HAVE_IDE if PCI || ISA || PCMCIA
-	select HAVE_IRQ_WORK
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZMA
 	select HAVE_KERNEL_LZO
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ef54a59..dd50d72 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -17,7 +17,6 @@ config ARM64
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
-	select HAVE_IRQ_WORK
 	select HAVE_MEMBLOCK
 	select HAVE_PERF_EVENTS
 	select HAVE_SPARSE_IRQ
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index b6f3ad5..86f891f 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -24,7 +24,6 @@ config BLACKFIN
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_IDE
-	select HAVE_IRQ_WORK
 	select HAVE_KERNEL_GZIP if RAMKERNEL
 	select HAVE_KERNEL_BZIP2 if RAMKERNEL
 	select HAVE_KERNEL_LZMA if RAMKERNEL
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index df2eb4b..c44fd6e 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -3,7 +3,6 @@ config FRV
 	default y
 	select HAVE_IDE
 	select HAVE_ARCH_TRACEHOOK
-	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select HAVE_UID16
 	select HAVE_GENERIC_HARDIRQS
diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 0744f7d..40a3185 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -14,7 +14,6 @@ config HEXAGON
 	# select HAVE_CLK
 	# select IRQ_PER_CPU
 	# select GENERIC_PENDING_IRQ if SMP
-	select HAVE_IRQ_WORK
 	select GENERIC_ATOMIC64
 	select HAVE_PERF_EVENTS
 	select HAVE_GENERIC_HARDIRQS
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index dba9390..3d86d69 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -4,7 +4,6 @@ config MIPS
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_IDE
 	select HAVE_OPROFILE
-	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 	select HAVE_ARCH_KGDB
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 11def45..8f0df47 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -9,7 +9,6 @@ config PARISC
 	select RTC_DRV_GENERIC
 	select INIT_ALL_POSSIBLE
 	select BUG
-	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select GENERIC_ATOMIC64 if !64BIT
 	select HAVE_GENERIC_HARDIRQS
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index a902a5c..a90f0c9 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -118,7 +118,6 @@ config PPC
 	select HAVE_SYSCALL_WRAPPERS if PPC64
 	select GENERIC_ATOMIC64 if PPC32
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
-	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS && PPC_BOOK3S_64
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 5dba755..0816ff0 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -78,7 +78,6 @@ config S390
 	select HAVE_KVM if 64BIT
 	select HAVE_ARCH_TRACEHOOK
 	select INIT_ALL_POSSIBLE
-	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_DEBUG_KMEMLEAK
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index babc2b8..996e008 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -11,7 +11,6 @@ config SUPERH
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DMA_API_DEBUG
 	select HAVE_DMA_ATTRS
-	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select HAVE_DEBUG_BUGVERBOSE
 	select ARCH_HAVE_CUSTOM_GPIO_H
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index b6b442b..05a478f 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -22,7 +22,6 @@ config SPARC
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select RTC_CLASS
 	select RTC_DRV_M48T59
-	select HAVE_IRQ_WORK
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
 	select HAVE_ARCH_JUMP_LABEL
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 46c3bff..c13e07a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -26,7 +26,6 @@ config X86
 	select HAVE_OPROFILE
 	select HAVE_PCSPKR_PLATFORM
 	select HAVE_PERF_EVENTS
-	select HAVE_IRQ_WORK
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
 	select HAVE_MEMBLOCK
diff --git a/drivers/staging/iio/trigger/Kconfig b/drivers/staging/iio/trigger/Kconfig
index 7d32075..d44d3ad 100644
--- a/drivers/staging/iio/trigger/Kconfig
+++ b/drivers/staging/iio/trigger/Kconfig
@@ -21,7 +21,6 @@ config IIO_GPIO_TRIGGER
 config IIO_SYSFS_TRIGGER
 	tristate "SYSFS trigger"
 	depends on SYSFS
-	depends on HAVE_IRQ_WORK
 	select IRQ_WORK
 	help
 	  Provides support for using SYSFS entry as IIO triggers.
diff --git a/init/Kconfig b/init/Kconfig
index 6fdd6e3..cdc152c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -20,12 +20,8 @@ config CONSTRUCTORS
 	bool
 	depends on !UML
 
-config HAVE_IRQ_WORK
-	bool
-
 config IRQ_WORK
 	bool
-	depends on HAVE_IRQ_WORK
 
 config BUILDTIME_EXTABLE_SORT
 	bool
-- 
1.7.5.4

