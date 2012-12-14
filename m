Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab2LNSmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:42:10 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:34630 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab2LNSmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:42:08 -0500
Subject: [RFC][PATCH 2/7] consolidate per-arch stack overflow debugging options
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 14 Dec 2012 13:42:02 -0500
References: <20121214184200.8EC5168B@kernel.stglabs.ibm.com>
In-Reply-To: <20121214184200.8EC5168B@kernel.stglabs.ibm.com>
Message-Id: <20121214184202.F54094D9@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121418-2876-0000-0000-000003225200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Several architectures have similar stack debugging config options.
They all pretty much do the same thing, some with slightly
differing help text.

This patch changes the architectures to instead enable a Kconfig
boolean, and then use that boolean in the generic Kconfig.debug
to present the actual menu option.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/blackfin/Kconfig       |    1 +
 linux-2.6.git-dave/arch/blackfin/Kconfig.debug |    7 -------
 linux-2.6.git-dave/arch/frv/Kconfig            |    1 +
 linux-2.6.git-dave/arch/frv/Kconfig.debug      |    4 ----
 linux-2.6.git-dave/arch/m32r/Kconfig           |    1 +
 linux-2.6.git-dave/arch/m32r/Kconfig.debug     |    7 -------
 linux-2.6.git-dave/arch/mips/Kconfig           |    1 +
 linux-2.6.git-dave/arch/mips/Kconfig.debug     |    9 ---------
 linux-2.6.git-dave/arch/mn10300/Kconfig        |    1 +
 linux-2.6.git-dave/arch/mn10300/Kconfig.debug  |    4 ----
 linux-2.6.git-dave/arch/powerpc/Kconfig        |    1 +
 linux-2.6.git-dave/arch/powerpc/Kconfig.debug  |    7 -------
 linux-2.6.git-dave/arch/tile/Kconfig           |    1 +
 linux-2.6.git-dave/arch/tile/Kconfig.debug     |    7 -------
 linux-2.6.git-dave/arch/x86/Kconfig            |    1 +
 linux-2.6.git-dave/arch/x86/Kconfig.debug      |   10 ----------
 linux-2.6.git-dave/lib/Kconfig.debug           |   21 +++++++++++++++++++++
 17 files changed, 29 insertions(+), 55 deletions(-)

diff -puN arch/blackfin/Kconfig~consolidat-stack-debugging-configs arch/blackfin/Kconfig
--- linux-2.6.git/arch/blackfin/Kconfig~consolidat-stack-debugging-configs	2012-12-10 11:26:13.963147904 -0500
+++ linux-2.6.git-dave/arch/blackfin/Kconfig	2012-12-10 11:26:13.999148224 -0500
@@ -45,6 +45,7 @@ config BLACKFIN
 	select ARCH_USES_GETTIMEOFFSET if !GENERIC_CLOCKEVENTS
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config GENERIC_CSUM
 	def_bool y
diff -puN arch/blackfin/Kconfig.debug~consolidat-stack-debugging-configs arch/blackfin/Kconfig.debug
--- linux-2.6.git/arch/blackfin/Kconfig.debug~consolidat-stack-debugging-configs	2012-12-10 11:26:13.963147904 -0500
+++ linux-2.6.git-dave/arch/blackfin/Kconfig.debug	2012-12-10 11:26:13.999148224 -0500
@@ -2,13 +2,6 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-	help
-	  This option will cause messages to be printed if free stack space
-	  drops below a certain limit.
-
 config DEBUG_VERBOSE
 	bool "Verbose fault messages"
 	default y
diff -puN arch/frv/Kconfig~consolidat-stack-debugging-configs arch/frv/Kconfig
--- linux-2.6.git/arch/frv/Kconfig~consolidat-stack-debugging-configs	2012-12-10 11:26:13.967147938 -0500
+++ linux-2.6.git-dave/arch/frv/Kconfig	2012-12-10 11:26:13.999148224 -0500
@@ -14,6 +14,7 @@ config FRV
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_KERNEL_THREAD
 	select GENERIC_KERNEL_EXECVE
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config ZONE_DMA
 	bool
diff -puN arch/frv/Kconfig.debug~consolidat-stack-debugging-configs arch/frv/Kconfig.debug
--- linux-2.6.git/arch/frv/Kconfig.debug~consolidat-stack-debugging-configs	2012-12-10 11:26:13.967147938 -0500
+++ linux-2.6.git-dave/arch/frv/Kconfig.debug	2012-12-10 11:26:13.999148224 -0500
@@ -2,10 +2,6 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-
 config GDBSTUB
 	bool "Remote GDB kernel debugging"
 	depends on DEBUG_KERNEL
diff -puN arch/m32r/Kconfig~consolidat-stack-debugging-configs arch/m32r/Kconfig
--- linux-2.6.git/arch/m32r/Kconfig~consolidat-stack-debugging-configs	2012-12-10 11:26:13.971147973 -0500
+++ linux-2.6.git-dave/arch/m32r/Kconfig	2012-12-10 11:26:13.999148224 -0500
@@ -15,6 +15,7 @@ config M32R
 	select GENERIC_ATOMIC64
 	select ARCH_USES_GETTIMEOFFSET
 	select MODULES_USE_ELF_RELA
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config SBUS
 	bool
diff -puN arch/m32r/Kconfig.debug~consolidat-stack-debugging-configs arch/m32r/Kconfig.debug
--- linux-2.6.git/arch/m32r/Kconfig.debug~consolidat-stack-debugging-configs	2012-12-10 11:26:13.971147973 -0500
+++ linux-2.6.git-dave/arch/m32r/Kconfig.debug	2012-12-10 11:26:13.999148224 -0500
@@ -2,13 +2,6 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-	help
-	  This option will cause messages to be printed if free stack space
-	  drops below a certain limit.
-
 config DEBUG_PAGEALLOC
 	bool "Debug page memory allocations"
 	depends on DEBUG_KERNEL && BROKEN
diff -puN arch/mips/Kconfig~consolidat-stack-debugging-configs arch/mips/Kconfig
--- linux-2.6.git/arch/mips/Kconfig~consolidat-stack-debugging-configs	2012-12-10 11:26:13.975148010 -0500
+++ linux-2.6.git-dave/arch/mips/Kconfig	2012-12-10 11:26:13.999148224 -0500
@@ -40,6 +40,7 @@ config MIPS
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_REL
 	select MODULES_USE_ELF_RELA if 64BIT
+	select HAVE_DEBUG_STACKOVERFLOW
 
 menu "Machine selection"
 
diff -puN arch/mips/Kconfig.debug~consolidat-stack-debugging-configs arch/mips/Kconfig.debug
--- linux-2.6.git/arch/mips/Kconfig.debug~consolidat-stack-debugging-configs	2012-12-10 11:26:13.975148010 -0500
+++ linux-2.6.git-dave/arch/mips/Kconfig.debug	2012-12-10 11:26:13.999148224 -0500
@@ -67,15 +67,6 @@ config CMDLINE_OVERRIDE
 
 	  Normally, you will choose 'N' here.
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-	help
-	  This option will cause messages to be printed if free stack space
-	  drops below a certain limit(2GB on MIPS). The debugging option
-	  provides another way to check stack overflow happened on kernel mode
-	  stack usually caused by nested interruption.
-
 config SMTC_IDLE_HOOK_DEBUG
 	bool "Enable additional debug checks before going into CPU idle loop"
 	depends on DEBUG_KERNEL && MIPS_MT_SMTC
diff -puN arch/mn10300/Kconfig~consolidat-stack-debugging-configs arch/mn10300/Kconfig
--- linux-2.6.git/arch/mn10300/Kconfig~consolidat-stack-debugging-configs	2012-12-10 11:26:13.979148046 -0500
+++ linux-2.6.git-dave/arch/mn10300/Kconfig	2012-12-10 11:26:13.999148224 -0500
@@ -10,6 +10,7 @@ config MN10300
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_KERNEL_THREAD
 	select MODULES_USE_ELF_RELA
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config AM33_2
 	def_bool n
diff -puN arch/mn10300/Kconfig.debug~consolidat-stack-debugging-configs arch/mn10300/Kconfig.debug
--- linux-2.6.git/arch/mn10300/Kconfig.debug~consolidat-stack-debugging-configs	2012-12-10 11:26:13.979148046 -0500
+++ linux-2.6.git-dave/arch/mn10300/Kconfig.debug	2012-12-10 11:26:13.999148224 -0500
@@ -2,10 +2,6 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-
 config DEBUG_DECOMPRESS_KERNEL
 	bool "Using serial port during decompressing kernel"
 	depends on DEBUG_KERNEL
diff -puN arch/powerpc/Kconfig~consolidat-stack-debugging-configs arch/powerpc/Kconfig
--- linux-2.6.git/arch/powerpc/Kconfig~consolidat-stack-debugging-configs	2012-12-10 11:26:13.983148082 -0500
+++ linux-2.6.git-dave/arch/powerpc/Kconfig	2012-12-10 11:26:59.899558241 -0500
@@ -144,6 +144,7 @@ config PPC
 	select GENERIC_KERNEL_THREAD
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config EARLY_PRINTK
 	bool
diff -puN arch/powerpc/Kconfig.debug~consolidat-stack-debugging-configs arch/powerpc/Kconfig.debug
--- linux-2.6.git/arch/powerpc/Kconfig.debug~consolidat-stack-debugging-configs	2012-12-10 11:26:13.983148082 -0500
+++ linux-2.6.git-dave/arch/powerpc/Kconfig.debug	2012-12-10 11:26:13.999148224 -0500
@@ -28,13 +28,6 @@ config PRINT_STACK_DEPTH
 	  too small and stack traces cause important information to
 	  scroll off the screen.
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-	help
-	  This option will cause messages to be printed if free stack space
-	  drops below a certain limit.
-
 config HCALL_STATS
 	bool "Hypervisor call instrumentation"
 	depends on PPC_PSERIES && DEBUG_FS && TRACEPOINTS
diff -puN arch/tile/Kconfig~consolidat-stack-debugging-configs arch/tile/Kconfig
--- linux-2.6.git/arch/tile/Kconfig~consolidat-stack-debugging-configs	2012-12-10 11:26:13.987148118 -0500
+++ linux-2.6.git-dave/arch/tile/Kconfig	2012-12-10 11:27:06.835620193 -0500
@@ -21,6 +21,7 @@ config TILE
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CLOCKEVENTS
 	select MODULES_USE_ELF_RELA
+	select HAVE_DEBUG_STACKOVERFLOW
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
diff -puN arch/tile/Kconfig.debug~consolidat-stack-debugging-configs arch/tile/Kconfig.debug
--- linux-2.6.git/arch/tile/Kconfig.debug~consolidat-stack-debugging-configs	2012-12-10 11:26:13.987148118 -0500
+++ linux-2.6.git-dave/arch/tile/Kconfig.debug	2012-12-10 11:26:14.003148261 -0500
@@ -14,13 +14,6 @@ config EARLY_PRINTK
 	  with klogd/syslogd. You should normally N here,
 	  unless you want to debug such a crash.
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-	help
-	  This option will cause messages to be printed if free stack space
-	  drops below a certain limit.
-
 config DEBUG_EXTRA_FLAGS
 	string "Additional compiler arguments when building with '-g'"
 	depends on DEBUG_INFO
diff -puN arch/x86/Kconfig~consolidat-stack-debugging-configs arch/x86/Kconfig
--- linux-2.6.git/arch/x86/Kconfig~consolidat-stack-debugging-configs	2012-12-10 11:26:13.991148152 -0500
+++ linux-2.6.git-dave/arch/x86/Kconfig	2012-12-10 11:27:31.911844173 -0500
@@ -112,6 +112,7 @@ config X86
 	select GENERIC_KERNEL_EXECVE
 	select MODULES_USE_ELF_REL if X86_32
 	select MODULES_USE_ELF_RELA if X86_64
+	select HAVE_DEBUG_STACKOVERFLOW
 
 config INSTRUCTION_DECODER
 	def_bool y
diff -puN arch/x86/Kconfig.debug~consolidat-stack-debugging-configs arch/x86/Kconfig.debug
--- linux-2.6.git/arch/x86/Kconfig.debug~consolidat-stack-debugging-configs	2012-12-10 11:26:13.991148152 -0500
+++ linux-2.6.git-dave/arch/x86/Kconfig.debug	2012-12-10 11:28:38.856442056 -0500
@@ -59,16 +59,6 @@ config EARLY_PRINTK_DBGP
 	  with klogd/syslogd or the X server. You should normally N here,
 	  unless you want to debug such a crash. You need usb debug device.
 
-config DEBUG_STACKOVERFLOW
-	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
-	---help---
-	  Say Y here if you want to check the overflows of kernel, IRQ
-	  and exception stacks. This option will cause messages of the
-	  stacks in detail when free stack space drops below a certain
-	  limit.
-	  If in doubt, say "N".
-
 config X86_PTDUMP
 	bool "Export kernel pagetable layout to userspace via debugfs"
 	depends on DEBUG_KERNEL
diff -puN lib/Kconfig.debug~consolidat-stack-debugging-configs lib/Kconfig.debug
--- linux-2.6.git/lib/Kconfig.debug~consolidat-stack-debugging-configs	2012-12-10 11:26:13.995148187 -0500
+++ linux-2.6.git-dave/lib/Kconfig.debug	2012-12-10 11:28:38.856442056 -0500
@@ -1464,6 +1464,27 @@ config ASYNC_RAID6_TEST
 
 	  If unsure, say N.
 
+config HAVE_DEBUG_STACKOVERFLOW
+	bool
+
+config DEBUG_STACKOVERFLOW
+	bool "Check for stack overflows"
+	depends on DEBUG_KERNEL && HAVE_DEBUG_STACKOVERFLOW
+	---help---
+	  Say Y here if you want to check for overflows of kernel, IRQ
+	  and exception stacks (if your archicture uses them). This
+	  option will show detailed messages if free stack space drops
+	  below a certain limit.
+
+	  These kinds of bugs usually occur when call-chains in the
+	  kernel get too deep, especially when interrupts are
+	  involved.
+
+	  Use this in cases where you see apparently random memory
+	  corruption, especially if it appears in 'struct thread_info'
+
+	  If in doubt, say "N".
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
_

