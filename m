Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab2JDQTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 12:19:33 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43773 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757198Ab2JDQTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 12:19:30 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH v2 2/4] Clean up the long arch list for the DEBUG_KMEMLEAK config option
Date: Thu,  4 Oct 2012 17:15:55 +0100
Message-Id: <1349367357-13865-3-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1349367357-13865-1-git-send-email-catalin.marinas@arm.com>
References: <1349367357-13865-1-git-send-email-catalin.marinas@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces HAVE_DEBUG_KMEMLEAK config option and selects it
in corresponding architecture Kconfig files. DEBUG_KMEMLEAK now only
depends on HAVE_DEBUG_KMEMLEAK.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/arm/Kconfig        |    1 +
 arch/arm64/Kconfig      |    1 +
 arch/microblaze/Kconfig |    1 +
 arch/mips/Kconfig       |    1 +
 arch/powerpc/Kconfig    |    1 +
 arch/s390/Kconfig       |    1 +
 arch/sh/Kconfig         |    1 +
 arch/sparc/Kconfig      |    1 +
 arch/tile/Kconfig       |    1 +
 arch/x86/Kconfig        |    1 +
 lib/Kconfig.debug       |    8 ++++----
 11 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 31af8e4..07679b0 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -24,6 +24,7 @@ config ARM
 	select HAVE_FUNCTION_GRAPH_TRACER if (!THUMB2_KERNEL)
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select HAVE_GENERIC_DMA_COHERENT
+	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZO
 	select HAVE_KERNEL_LZMA
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e61acae..5dc9273 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -10,6 +10,7 @@ config ARM64
 	select GENERIC_TIME_VSYSCALL
 	select HARDIRQS_SW_RESEND
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_API_DEBUG
 	select HAVE_DMA_ATTRS
 	select HAVE_GENERIC_DMA_COHERENT
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index ab9afca..fa6725b 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -16,6 +16,7 @@ config MICROBLAZE
 	select OF
 	select OF_EARLY_FLATTREE
 	select ARCH_WANT_IPC_PARSE_VERSION
+	select HAVE_DEBUG_KMEMLEAK
 	select IRQ_DOMAIN
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index faf6528..335115e 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -17,6 +17,7 @@ config MIPS
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_DEBUG_KMEMLEAK
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select RTC_LIB if !MACH_LOONGSON
 	select GENERIC_ATOMIC64 if !64BIT
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 352f416..7a7f5cc 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -113,6 +113,7 @@ config PPC
 	select HAVE_DMA_API_DEBUG
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_OPROFILE
+	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_SYSCALL_WRAPPERS if PPC64
 	select GENERIC_ATOMIC64 if PPC32
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index c19e7ec..2e26b97 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -80,6 +80,7 @@ config S390
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index f0c85e4..cfbf3e3 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -16,6 +16,7 @@ config SUPERH
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if (GUSA_RB || CPU_SH4A)
 	select PERF_USE_VMALLOC
+	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index e664810..274d6cf 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -60,6 +60,7 @@ config SPARC64
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_SYSCALL_TRACEPOINTS
+	select HAVE_DEBUG_KMEMLEAK
 	select RTC_DRV_CMOS
 	select RTC_DRV_BQ4802
 	select RTC_DRV_SUN4V
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index c9a3c1f..9a0d77d 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -9,6 +9,7 @@ config TILE
 	select GENERIC_FIND_FIRST_BIT
 	select USE_GENERIC_SMP_HELPERS
 	select CC_OPTIMIZE_FOR_SIZE
+	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2e84642..302094d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -66,6 +66,7 @@ config X86
 	select HAVE_PERF_EVENTS_NMI
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
+	select HAVE_DEBUG_KMEMLEAK
 	select ANON_INODES
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB && !M386
 	select HAVE_CMPXCHG_LOCAL if !M386
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 35c4565..63dfc4c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -449,12 +449,12 @@ config SLUB_STATS
 	  out which slabs are relevant to a particular load.
 	  Try running: slabinfo -DA
 
+config HAVE_DEBUG_KMEMLEAK
+	bool
+
 config DEBUG_KMEMLEAK
 	bool "Kernel memory leak detector"
-	depends on DEBUG_KERNEL && EXPERIMENTAL && \
-		(X86 || ARM || PPC || MIPS || S390 || SPARC64 || SUPERH || \
-		 MICROBLAZE || TILE || ARM64)
-
+	depends on DEBUG_KERNEL && EXPERIMENTAL && HAVE_DEBUG_KMEMLEAK
 	select DEBUG_FS
 	select STACKTRACE if STACKTRACE_SUPPORT
 	select KALLSYMS
