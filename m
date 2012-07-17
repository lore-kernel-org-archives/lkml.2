Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab2GQRLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:11:47 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53018 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab2GQRLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:11:34 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux390@de.ibm.com, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] atomic64_test: Simplify the #ifdef for atomic64_dec_if_positive() test
Date: Tue, 17 Jul 2012 18:10:48 +0100
Message-Id: <1342545048-30958-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
X-OriginalArrivalTime: 17 Jul 2012 17:12:40.0873 (UTC) FILETIME=[5F54E990:01CD643F]
X-MC-Unique: 112071718113205101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q6HHBqYX003351

This patch introduces CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE and uses
this instead of the multitude of #if defined() checks in atomic64_test.c

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linux390@de.ibm.com
Cc: x86@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
---

That's a trivial patch to sort out the #if statement for the
atomic64_dec_if_positive() test. I went for the Kconfig option, the
alternative being #define in the atomic.h header files of each
architecture affected.

Thanks.

 arch/arm/Kconfig     |    1 +
 arch/mips/Kconfig    |    1 +
 arch/powerpc/Kconfig |    1 +
 arch/s390/Kconfig    |    1 +
 arch/x86/Kconfig     |    1 +
 lib/Kconfig          |    3 +++
 lib/atomic64_test.c  |    5 ++---
 7 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a91009c..88df37f 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -11,6 +11,7 @@ config ARM
 	select RTC_LIB
 	select SYS_SUPPORTS_APM_EMULATION
 	select GENERIC_ATOMIC64 if (CPU_V6 || !CPU_32v6K || !AEABI)
+	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select HAVE_OPROFILE if (HAVE_PERF_EVENTS)
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL
 	select HAVE_ARCH_KGDB
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 09ab87e..c9e1812 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -20,6 +20,7 @@ config MIPS
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select RTC_LIB if !MACH_LOONGSON
 	select GENERIC_ATOMIC64 if !64BIT
+	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
 	select HAVE_GENERIC_HARDIRQS
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 050cb37..8b8bc3a 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -115,6 +115,7 @@ config PPC
 	select HAVE_OPROFILE
 	select HAVE_SYSCALL_WRAPPERS if PPC64
 	select GENERIC_ATOMIC64 if PPC32
+	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select HAVE_REGS_AND_STACK_ACCESS_API
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index a39b469..64cb682 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -121,6 +121,7 @@ config S390
 	select GENERIC_TIME_VSYSCALL
 	select GENERIC_CLOCKEVENTS
 	select KTIME_SCALAR if 32BIT
+	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c70684f..1d08863 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -95,6 +95,7 @@ config X86
 	select KTIME_SCALAR if X86_32
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS || UPROBES)
diff --git a/lib/Kconfig b/lib/Kconfig
index a9e1540..e0a7d57 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -340,6 +340,9 @@ config NLATTR
 config GENERIC_ATOMIC64
        bool
 
+config ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
+	def_bool y if GENERIC_ATOMIC64
+
 config LRU_CACHE
 	tristate
 
diff --git a/lib/atomic64_test.c b/lib/atomic64_test.c
index cb99b91..00bca22 100644
--- a/lib/atomic64_test.c
+++ b/lib/atomic64_test.c
@@ -114,8 +114,7 @@ static __init int test_atomic64(void)
 	r += one;
 	BUG_ON(v.counter != r);
 
-#if defined(CONFIG_X86) || defined(CONFIG_MIPS) || defined(CONFIG_PPC) || \
-    defined(CONFIG_S390) || defined(_ASM_GENERIC_ATOMIC64_H) || defined(CONFIG_ARM)
+#ifdef CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	INIT(onestwos);
 	BUG_ON(atomic64_dec_if_positive(&v) != (onestwos - 1));
 	r -= one;
@@ -129,7 +128,7 @@ static __init int test_atomic64(void)
 	BUG_ON(atomic64_dec_if_positive(&v) != (-one - one));
 	BUG_ON(v.counter != r);
 #else
-#warning Please implement atomic64_dec_if_positive for your architecture, and add it to the IF above
+#warning Please implement atomic64_dec_if_positive for your architecture and select the above Kconfig symbol
 #endif
 
 	INIT(onestwos);

