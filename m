Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab2JDQTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 12:19:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43777 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757132Ab2JDQTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 12:19:39 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH v2 4/4] Clean up the "#if defined(arch)" list for exception-trace sysctl entry
Date: Thu,  4 Oct 2012 17:15:57 +0100
Message-Id: <1349367357-13865-5-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1349367357-13865-1-git-send-email-catalin.marinas@arm.com>
References: <1349367357-13865-1-git-send-email-catalin.marinas@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces SYSCTL_EXCEPTION_TRACE config option and selects
it in the architectures requiring support for the "exception-trace"
debug_table entry in kernel/sysctl.c.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/arm64/Kconfig   |    1 +
 arch/powerpc/Kconfig |    1 +
 arch/s390/Kconfig    |    1 +
 arch/sparc/Kconfig   |    1 +
 arch/tile/Kconfig    |    1 +
 arch/x86/Kconfig     |    1 +
 init/Kconfig         |    5 +++++
 kernel/sysctl.c      |    3 +--
 8 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a308560..7ff68c9 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -28,6 +28,7 @@ config ARM64
 	select PERF_USE_VMALLOC
 	select RTC_LIB
 	select SPARSE_IRQ
+	select SYSCTL_EXCEPTION_TRACE
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 7a7f5cc..cba7b65 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -99,6 +99,7 @@ config PPC
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
+	select SYSCTL_EXCEPTION_TRACE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_IDE
 	select HAVE_IOREMAP_PROT
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 2e26b97..5af0350 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -68,6 +68,7 @@ config S390
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_SYSCALL_TRACEPOINTS
+	select SYSCTL_EXCEPTION_TRACE
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_REGS_AND_STACK_ACCESS_API
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 700a01a..e184075 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -18,6 +18,7 @@ config SPARC
 	select HAVE_OPROFILE
 	select HAVE_ARCH_KGDB if !SMP || SPARC64
 	select HAVE_ARCH_TRACEHOOK
+	select SYSCTL_EXCEPTION_TRACE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select RTC_CLASS
 	select RTC_DRV_M48T59
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index df69d42..dc46490 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -7,6 +7,7 @@ config TILE
 	select HAVE_DMA_API_DEBUG
 	select HAVE_KVM if !TILEGX
 	select GENERIC_FIND_FIRST_BIT
+	select SYSCTL_EXCEPTION_TRACE
 	select USE_GENERIC_SMP_HELPERS
 	select CC_OPTIMIZE_FOR_SIZE
 	select HAVE_DEBUG_KMEMLEAK
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 302094d..8244d4c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -47,6 +47,7 @@ config X86
 	select HAVE_FUNCTION_GRAPH_FP_TEST
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_SYSCALL_TRACEPOINTS
+	select SYSCTL_EXCEPTION_TRACE
 	select HAVE_KVM
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
diff --git a/init/Kconfig b/init/Kconfig
index f8de091..4d13aae 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1152,6 +1152,11 @@ config SYSCTL_SYSCALL
 
 	  If unsure say N here.
 
+config SYSCTL_EXCEPTION_TRACE
+	bool
+	help
+	  Enable support for /proc/sys/debug/exception-trace.
+
 config KALLSYMS
 	 bool "Load all symbols for debugging/ksymoops" if EXPERT
 	 default y
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 84c76a3..b0eaca7 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1543,8 +1543,7 @@ static struct ctl_table fs_table[] = {
 };
 
 static struct ctl_table debug_table[] = {
-#if defined(CONFIG_X86) || defined(CONFIG_PPC) || defined(CONFIG_SPARC) || \
-    defined(CONFIG_S390) || defined(CONFIG_TILE) || defined(CONFIG_ARM64)
+#ifdef CONFIG_SYSCTL_EXCEPTION_TRACE
 	{
 		.procname	= "exception-trace",
 		.data		= &show_unhandled_signals,
