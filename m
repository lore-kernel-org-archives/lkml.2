Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab2JDQTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 12:19:22 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43769 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757166Ab2JDQTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 12:19:19 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v2 1/4] Clean up the long arch list for the UID16 config option
Date: Thu,  4 Oct 2012 17:15:54 +0100
Message-Id: <1349367357-13865-2-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1349367357-13865-1-git-send-email-catalin.marinas@arm.com>
References: <1349367357-13865-1-git-send-email-catalin.marinas@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces HAVE_UID16 config option and selects it in
corresponding architecture Kconfig files. UID16 now only depends on
HAVE_UID16.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
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
index 7bab17e..31af8e4 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -38,6 +38,7 @@ config ARM
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
+	select HAVE_UID16
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HARDIRQS_SW_RESEND
 	select CPU_PM if (SUSPEND || CPU_IDLE)
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
index c7092e6..2169889 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -33,6 +33,7 @@ config BLACKFIN
 	select HAVE_PERF_EVENTS
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select HAVE_UID16
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_ATOMIC64
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 72bd5ae..a118163 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -42,6 +42,7 @@ config CRIS
 	select HAVE_IDE
 	select GENERIC_ATOMIC64
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_UID16
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 971c0a1..cc5709d 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -5,6 +5,7 @@ config FRV
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
+	select HAVE_UID16
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 5e8a0d9..90462eb 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -3,6 +3,7 @@ config H8300
 	default y
 	select HAVE_IDE
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_UID16
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index b22df94..3e2b2f6 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -6,6 +6,7 @@ config M68K
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
+	select HAVE_UID16
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 	select GENERIC_CPU_DEVICES
 	select GENERIC_STRNCPY_FROM_USER if MMU
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index f9acddd..c19e7ec 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -126,6 +126,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_BH
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	select HAVE_UID16 if 32BIT
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 36f5141..f0c85e4 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -21,6 +21,7 @@ config SUPERH
 	select HAVE_KERNEL_LZMA
 	select HAVE_KERNEL_XZ
 	select HAVE_KERNEL_LZO
+	select HAVE_UID16
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_REGS_AND_STACK_ACCESS_API
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 67f1f6f..e664810 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -42,6 +42,7 @@ config SPARC32
 	def_bool !64BIT
 	select GENERIC_ATOMIC64
 	select CLZ_TAB
+	select HAVE_UID16
 
 config SPARC64
 	def_bool 64BIT
@@ -571,6 +572,7 @@ config COMPAT
 	depends on SPARC64
 	default y
 	select COMPAT_BINFMT_ELF
+	select HAVE_UID16
 	select ARCH_WANT_OLD_COMPAT_IPC
 
 config SYSVIPC_COMPAT
diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index cb837c2..648121b 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -7,6 +7,7 @@ config UML
 	bool
 	default y
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_UID16
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
 	select GENERIC_IO
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
