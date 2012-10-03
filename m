Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab2JCQsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:48:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51486 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932112Ab2JCQsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:48:06 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/4] Clean up the "#if defined(arch)" list for exception-trace sysctl entry
Date: Wed,  3 Oct 2012 17:44:26 +0100
Message-Id: <1349282666-32100-5-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1349282666-32100-1-git-send-email-catalin.marinas@arm.com>
References: <1349282666-32100-1-git-send-email-catalin.marinas@arm.com>
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
index 63c640d..1ab473a 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -140,6 +140,7 @@ config PPC
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select HAVE_DEBUG_KMEMLEAK
+	select SYSCTL_EXCEPTION_TRACE
 
 config EARLY_PRINTK
 	bool
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index d3216d7..0391630 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -134,6 +134,7 @@ config S390
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_UID16 if 32BIT
 	select HAVE_DEBUG_KMEMLEAK
+	select SYSCTL_EXCEPTION_TRACE
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 2006ddc..d427993 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -38,6 +38,7 @@ config SPARC
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select HAVE_DEBUG_BUGVERBOSE
+	select SYSCTL_EXCEPTION_TRACE
 
 config SPARC32
 	def_bool !64BIT
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index e38ae98..e4bb0ca 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -19,6 +19,7 @@ config TILE
 	select GENERIC_CLOCKEVENTS
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DEBUG_BUGVERBOSE
+	select SYSCTL_EXCEPTION_TRACE
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6995d6b..5aaa3b6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -106,6 +106,7 @@ config X86
 	select HAVE_RCU_USER_QS if X86_64
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select HAVE_DEBUG_KMEMLEAK
+	select SYSCTL_EXCEPTION_TRACE
 
 config INSTRUCTION_DECODER
 	def_bool y
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
