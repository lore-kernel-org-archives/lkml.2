Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab2LAAew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 19:34:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39246 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2LAAeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 19:34:50 -0500
Date: Fri, 30 Nov 2012 16:34:37 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-eb068e781020cf491333c773fb41820b57bfada4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1354132230-21854-2-git-send-email-hpa@linux.intel.com>
References: <1354132230-21854-2-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/nuke386] x86, 386 removal:
  Remove CONFIG_M386 from Kconfig
Git-Commit-ID: eb068e781020cf491333c773fb41820b57bfada4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 30 Nov 2012 16:34:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb068e781020cf491333c773fb41820b57bfada4
Gitweb:     http://git.kernel.org/tip/eb068e781020cf491333c773fb41820b57bfada4
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 28 Nov 2012 11:50:23 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 Nov 2012 13:23:01 -0800

x86, 386 removal: Remove CONFIG_M386 from Kconfig

Remove the CONFIG_M386 symbol from Kconfig so that it cannot be
selected.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1354132230-21854-2-git-send-email-hpa@linux.intel.com
---
 arch/x86/Kconfig                 |  6 ++---
 arch/x86/Kconfig.cpu             | 58 ++++++++++++++++------------------------
 arch/x86/Makefile_32.cpu         |  1 -
 arch/x86/include/asm/module.h    |  2 --
 arch/x86/include/asm/processor.h |  2 +-
 5 files changed, 27 insertions(+), 42 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 46c3bff..a1a6627 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -69,8 +69,8 @@ config X86
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_DEBUG_KMEMLEAK
 	select ANON_INODES
-	select HAVE_ALIGNED_STRUCT_PAGE if SLUB && !M386
-	select HAVE_CMPXCHG_LOCAL if !M386
+	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
+	select HAVE_CMPXCHG_LOCAL
 	select HAVE_CMPXCHG_DOUBLE
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
@@ -1100,7 +1100,7 @@ config HIGHMEM4G
 
 config HIGHMEM64G
 	bool "64GB"
-	depends on !M386 && !M486
+	depends on !M486
 	select X86_PAE
 	---help---
 	  Select this if you have a 32-bit processor and more than 4
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index f3b86d0..36a07eb 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -4,23 +4,24 @@ choice
 	default M686 if X86_32
 	default GENERIC_CPU if X86_64
 
-config M386
-	bool "386"
-	depends on X86_32 && !UML
+config M486
+	bool "486"
+	depends on X86_32
 	---help---
-	  This is the processor type of your CPU. This information is used for
-	  optimizing purposes. In order to compile a kernel that can run on
-	  all x86 CPU types (albeit not optimally fast), you can specify
-	  "386" here.
+	  This is the processor type of your CPU. This information is
+	  used for optimizing purposes. In order to compile a kernel
+	  that can run on all supported x86 CPU types (albeit not
+	  optimally fast), you can specify "486" here.
+
+	  Note that the 386 is no longer supported, this includes
+	  AMD/Cyrix/Intel 386DX/DXL/SL/SLC/SX, Cyrix/TI 486DLC/DLC2,
+	  and UMC 486SX-S.
 
 	  The kernel will not necessarily run on earlier architectures than
 	  the one you have chosen, e.g. a Pentium optimized kernel will run on
 	  a PPro, but not necessarily on a i486.
 
 	  Here are the settings recommended for greatest speed:
-	  - "386" for the AMD/Cyrix/Intel 386DX/DXL/SL/SLC/SX, Cyrix/TI
-	  486DLC/DLC2, and UMC 486SX-S.  Only "386" kernels will run on a 386
-	  class machine.
 	  - "486" for the AMD/Cyrix/IBM/Intel 486DX/DX2/DX4 or
 	  SL/SLC/SLC2/SLC3/SX/SX2 and UMC U5D or U5S.
 	  - "586" for generic Pentium CPUs lacking the TSC
@@ -43,16 +44,7 @@ config M386
 	  - "VIA C3-2" for VIA C3-2 "Nehemiah" (model 9 and above).
 	  - "VIA C7" for VIA C7.
 
-	  If you don't know what to do, choose "386".
-
-config M486
-	bool "486"
-	depends on X86_32
-	---help---
-	  Select this for a 486 series processor, either Intel or one of the
-	  compatible processors from AMD, Cyrix, IBM, or Intel.  Includes DX,
-	  DX2, and DX4 variants; also SL/SLC/SLC2/SLC3/SX/SX2 and UMC U5D or
-	  U5S.
+	  If you don't know what to do, choose "486".
 
 config M586
 	bool "586/K5/5x86/6x86/6x86MX"
@@ -307,22 +299,20 @@ config X86_INTERNODE_CACHE_SHIFT
 
 config X86_CMPXCHG
 	def_bool y
-	depends on X86_64 || (X86_32 && !M386)
 
 config X86_L1_CACHE_SHIFT
 	int
 	default "7" if MPENTIUM4 || MPSC
 	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 || X86_GENERIC || GENERIC_CPU
-	default "4" if MELAN || M486 || M386 || MGEODEGX1
+	default "4" if MELAN || M486 || MGEODEGX1
 	default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
 
 config X86_XADD
 	def_bool y
-	depends on !M386
 
 config X86_PPRO_FENCE
 	bool "PentiumPro memory ordering errata workaround"
-	depends on M686 || M586MMX || M586TSC || M586 || M486 || M386 || MGEODEGX1
+	depends on M686 || M586MMX || M586TSC || M586 || M486 || MGEODEGX1
 	---help---
 	  Old PentiumPro multiprocessor systems had errata that could cause
 	  memory operations to violate the x86 ordering standard in rare cases.
@@ -335,27 +325,26 @@ config X86_PPRO_FENCE
 
 config X86_F00F_BUG
 	def_bool y
-	depends on M586MMX || M586TSC || M586 || M486 || M386
+	depends on M586MMX || M586TSC || M586 || M486
 
 config X86_INVD_BUG
 	def_bool y
-	depends on M486 || M386
+	depends on M486
 
 config X86_WP_WORKS_OK
 	def_bool y
-	depends on !M386
 
 config X86_INVLPG
 	def_bool y
-	depends on X86_32 && !M386
+	depends on X86_32
 
 config X86_BSWAP
 	def_bool y
-	depends on X86_32 && !M386
+	depends on X86_32
 
 config X86_POPAD_OK
 	def_bool y
-	depends on X86_32 && !M386
+	depends on X86_32
 
 config X86_ALIGNMENT_16
 	def_bool y
@@ -412,12 +401,11 @@ config X86_MINIMUM_CPU_FAMILY
 	default "64" if X86_64
 	default "6" if X86_32 && X86_P6_NOP
 	default "5" if X86_32 && X86_CMPXCHG64
-	default "4" if X86_32 && (X86_XADD || X86_CMPXCHG || X86_BSWAP || X86_WP_WORKS_OK)
-	default "3"
+	default "4"
 
 config X86_DEBUGCTLMSR
 	def_bool y
-	depends on !(MK6 || MWINCHIPC6 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486 || M386) && !UML
+	depends on !(MK6 || MWINCHIPC6 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486) && !UML
 
 menuconfig PROCESSOR_SELECT
 	bool "Supported processor vendors" if EXPERT
@@ -441,7 +429,7 @@ config CPU_SUP_INTEL
 config CPU_SUP_CYRIX_32
 	default y
 	bool "Support Cyrix processors" if PROCESSOR_SELECT
-	depends on M386 || M486 || M586 || M586TSC || M586MMX || (EXPERT && !64BIT)
+	depends on M486 || M586 || M586TSC || M586MMX || (EXPERT && !64BIT)
 	---help---
 	  This enables detection, tunings and quirks for Cyrix processors
 
@@ -495,7 +483,7 @@ config CPU_SUP_TRANSMETA_32
 config CPU_SUP_UMC_32
 	default y
 	bool "Support UMC processors" if PROCESSOR_SELECT
-	depends on M386 || M486 || (EXPERT && !64BIT)
+	depends on M486 || (EXPERT && !64BIT)
 	---help---
 	  This enables detection, tunings and quirks for UMC processors
 
diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
index 86cee7b..6647ed4 100644
--- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -10,7 +10,6 @@ tune		= $(call cc-option,-mcpu=$(1),$(2))
 endif
 
 align := $(cc-option-align)
-cflags-$(CONFIG_M386)		+= -march=i386
 cflags-$(CONFIG_M486)		+= -march=i486
 cflags-$(CONFIG_M586)		+= -march=i586
 cflags-$(CONFIG_M586TSC)	+= -march=i586
diff --git a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
index 9eae775..e3b7819 100644
--- a/arch/x86/include/asm/module.h
+++ b/arch/x86/include/asm/module.h
@@ -5,8 +5,6 @@
 
 #ifdef CONFIG_X86_64
 /* X86_64 does not define MODULE_PROC_FAMILY */
-#elif defined CONFIG_M386
-#define MODULE_PROC_FAMILY "386 "
 #elif defined CONFIG_M486
 #define MODULE_PROC_FAMILY "486 "
 #elif defined CONFIG_M586
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index ad1fc85..9a4ee46 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -672,7 +672,7 @@ static inline void sync_core(void)
 {
 	int tmp;
 
-#if defined(CONFIG_M386) || defined(CONFIG_M486)
+#ifdef CONFIG_M486
 	if (boot_cpu_data.x86 < 5)
 		/* There is no speculative execution.
 		 * jmp is a barrier to prefetching. */
