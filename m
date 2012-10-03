Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab2JCQrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:47:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51470 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932112Ab2JCQre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:47:34 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Mike Frysinger <vapier@gentoo.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/4] Clean up the long arch list for the UID16 config option
Date: Wed,  3 Oct 2012 17:44:23 +0100
Message-Id: <1349282666-32100-2-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1349282666-32100-1-git-send-email-catalin.marinas@arm.com>
References: <1349282666-32100-1-git-send-email-catalin.marinas@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces HAVE_UID16 config option and selects it in
corresponding architecture Kconfig files. UID16 now only depends on
HAVE_UID16.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/arm/Kconfig       |    1 +
 arch/arm64/Kconfig     |    1 +
 arch/blackfin/Kconfig  |    1 +
 arch/cris/Kconfig      |    1 +
 arch/frv/Kconfig       |    1 +
 arch/h8300/Kconfig     |    1 +
 arch/m68k/Kconfig      |    1 +
 arch/s390/Kconfig      |    1 +
 arch/sh/Kconfig        |    1 +
 arch/sparc/Kconfig     |    2 ++
 arch/um/Kconfig.common |    1 +
 arch/x86/Kconfig       |    2 ++
 init/Kconfig           |    6 ++++--
 13 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 7bab17e..63ff281 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -49,6 +49,7 @@ config ARM
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select DCACHE_WORD_ACCESS if (CPU_V6 || CPU_V6K || CPU_V7) && !CPU_BIG_ENDIAN
+	select HAVE_UID16
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 767ba56..e61acae 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -193,6 +193,7 @@ config COMPAT
 	bool "Kernel support for 32-bit EL0"
 	depends on !ARM64_64K_PAGES
 	select COMPAT_BINFMT_ELF
+	select HAVE_UID16
 	help
 	  This option enables support for a 32-bit EL0 running under a 64-bit
 	  kernel at EL1. AArch32-specific components such as system calls,
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index c7092e6..edf12a1 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -42,6 +42,7 @@ config BLACKFIN
 	select HAVE_NMI_WATCHDOG if NMI_WATCHDOG
 	select GENERIC_SMP_IDLE_THREAD
 	select ARCH_USES_GETTIMEOFFSET if !GENERIC_CLOCKEVENTS
+	select HAVE_UID16
 
 config GENERIC_CSUM
 	def_bool y
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index e922154..f3f61ad 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -47,6 +47,7 @@ config CRIS
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD if ETRAX_ARCH_V32
 	select GENERIC_CMOS_UPDATE
+	select HAVE_UID16
 
 config HZ
 	int
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 971c0a1..b885519 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -10,6 +10,7 @@ config FRV
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CPU_DEVICES
 	select ARCH_WANT_IPC_PARSE_VERSION
+	select HAVE_UID16
 
 config ZONE_DMA
 	bool
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 5e8a0d9..544ac1d 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -6,6 +6,7 @@ config H8300
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
+	select HAVE_UID16
 
 config SYMBOL_PREFIX
 	string
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index b22df94..2517e4f 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -13,6 +13,7 @@ config M68K
 	select FPU if MMU
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_USES_GETTIMEOFFSET if MMU && !COLDFIRE
+	select HAVE_UID16
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index f9acddd..4de3a85 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -132,6 +132,7 @@ config S390
 	select GENERIC_CLOCKEVENTS
 	select KTIME_SCALAR if 32BIT
 	select HAVE_ARCH_SECCOMP_FILTER
+	select HAVE_UID16 if 32BIT
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 36f5141..fa6e2f1 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -35,6 +35,7 @@ config SUPERH
 	select GENERIC_CMOS_UPDATE if SH_SH03 || SH_DREAMCAST
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select HAVE_UID16
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 67f1f6f..931eaed 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -42,6 +42,7 @@ config SPARC32
 	def_bool !64BIT
 	select GENERIC_ATOMIC64
 	select CLZ_TAB
+	select HAVE_UID16
 
 config SPARC64
 	def_bool 64BIT
@@ -572,6 +573,7 @@ config COMPAT
 	default y
 	select COMPAT_BINFMT_ELF
 	select ARCH_WANT_OLD_COMPAT_IPC
+	select HAVE_UID16
 
 config SYSVIPC_COMPAT
 	bool
diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index cb837c2..3783413 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -11,6 +11,7 @@ config UML
 	select GENERIC_CPU_DEVICES
 	select GENERIC_IO
 	select GENERIC_CLOCKEVENTS
+	select HAVE_UID16
 
 config MMU
 	bool
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7f9a395..2e84642 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -10,6 +10,7 @@ config X86_32
 	def_bool y
 	depends on !64BIT
 	select CLKSRC_I8253
+	select HAVE_UID16
 
 config X86_64
 	def_bool y
@@ -2173,6 +2174,7 @@ config IA32_EMULATION
 	bool "IA32 Emulation"
 	depends on X86_64
 	select COMPAT_BINFMT_ELF
+	select HAVE_UID16
 	---help---
 	  Include code to run legacy 32-bit programs under a
 	  64-bit kernel. You should likely turn this on, unless you're
diff --git a/init/Kconfig b/init/Kconfig
index cb003a3..f8de091 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1125,10 +1125,12 @@ menuconfig EXPERT
           environments which can tolerate a "non-standard" kernel.
           Only use this if you really know what you are doing.
 
+config HAVE_UID16
+	bool
+
 config UID16
 	bool "Enable 16-bit UID system calls" if EXPERT
-	depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && COMPAT) || UML || (X86_64 && IA32_EMULATION) \
-		|| AARCH32_EMULATION
+	depends on HAVE_UID16
 	default y
 	help
 	  This enables the legacy 16-bit UID syscall wrappers.
