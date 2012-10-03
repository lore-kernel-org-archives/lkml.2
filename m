Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742Ab2JCQrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:47:45 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51472 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932112Ab2JCQrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:47:42 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/4] Clean up the long arch list for the DEBUG_KMEMLEAK config option
Date: Wed,  3 Oct 2012 17:44:24 +0100
Message-Id: <1349282666-32100-3-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1349282666-32100-1-git-send-email-catalin.marinas@arm.com>
References: <1349282666-32100-1-git-send-email-catalin.marinas@arm.com>
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
index 63ff281..a39477a 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -50,6 +50,7 @@ config ARM
 	select GENERIC_STRNLEN_USER
 	select DCACHE_WORD_ACCESS if (CPU_V6 || CPU_V6K || CPU_V7) && !CPU_BIG_ENDIAN
 	select HAVE_UID16
+	select HAVE_DEBUG_KMEMLEAK
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
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
index ab9afca..61b5d9f 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -24,6 +24,7 @@ config MICROBLAZE
 	select GENERIC_CPU_DEVICES
 	select GENERIC_ATOMIC64
 	select GENERIC_CLOCKEVENTS
+	select HAVE_DEBUG_KMEMLEAK
 
 config SWAP
 	def_bool n
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index faf6528..e04b95b 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -36,6 +36,7 @@ config MIPS
 	select BUILDTIME_EXTABLE_SORT
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CMOS_UPDATE
+	select HAVE_DEBUG_KMEMLEAK
 
 menu "Machine selection"
 
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 352f416..63c640d 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -139,6 +139,7 @@ config PPC
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select HAVE_DEBUG_KMEMLEAK
 
 config EARLY_PRINTK
 	bool
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 4de3a85..d3216d7 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -133,6 +133,7 @@ config S390
 	select KTIME_SCALAR if 32BIT
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_UID16 if 32BIT
+	select HAVE_DEBUG_KMEMLEAK
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index fa6e2f1..cb5a22e 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -36,6 +36,7 @@ config SUPERH
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select HAVE_UID16
+	select HAVE_DEBUG_KMEMLEAK
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 931eaed..a69bc77b 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -70,6 +70,7 @@ config SPARC64
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_C_RECORDMCOUNT
 	select NO_BOOTMEM
+	select HAVE_DEBUG_KMEMLEAK
 
 config ARCH_DEFCONFIG
 	string
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index c9a3c1f..afb3abd 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -17,6 +17,7 @@ config TILE
 	select SYS_HYPERVISOR
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CLOCKEVENTS
+	select HAVE_DEBUG_KMEMLEAK
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2e84642..6995d6b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -105,6 +105,7 @@ config X86
 	select GENERIC_STRNLEN_USER
 	select HAVE_RCU_USER_QS if X86_64
 	select HAVE_IRQ_TIME_ACCOUNTING
+	select HAVE_DEBUG_KMEMLEAK
 
 config INSTRUCTION_DECODER
 	def_bool y
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
