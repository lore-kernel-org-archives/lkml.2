Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab0EQWwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:52:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51794 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906Ab0EQWwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:52:34 -0400
Date: Tue, 18 May 2010 00:52:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpu changes for v2.6.35
Message-ID: <20100517225225.GA32562@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4482]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cleanups-for-linus

 Thanks,

	Ingo

------------------>
Jan Beulich (2):
      x86-64: Don't export init_level4_pgt
      x86: Clean up arch/x86/Kconfig*


 arch/x86/Kconfig                 |   49 +++++++++++--------------------------
 arch/x86/Kconfig.debug           |    2 -
 arch/x86/include/asm/boot.h      |    2 +-
 arch/x86/kernel/x8664_ksyms_64.c |    1 -
 4 files changed, 16 insertions(+), 38 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9458685..85e2252 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -197,20 +197,17 @@ config HAVE_INTEL_TXT
 
 # Use the generic interrupt handling code in kernel/irq/:
 config GENERIC_HARDIRQS
-	bool
-	default y
+	def_bool y
 
 config GENERIC_HARDIRQS_NO__DO_IRQ
        def_bool y
 
 config GENERIC_IRQ_PROBE
-	bool
-	default y
+	def_bool y
 
 config GENERIC_PENDING_IRQ
-	bool
+	def_bool y
 	depends on GENERIC_HARDIRQS && SMP
-	default y
 
 config USE_GENERIC_SMP_HELPERS
 	def_bool y
@@ -225,14 +222,12 @@ config X86_64_SMP
 	depends on X86_64 && SMP
 
 config X86_HT
-	bool
+	def_bool y
 	depends on SMP
-	default y
 
 config X86_TRAMPOLINE
-	bool
+	def_bool y
 	depends on SMP || (64BIT && ACPI_SLEEP)
-	default y
 
 config X86_32_LAZY_GS
 	def_bool y
@@ -447,7 +442,7 @@ config X86_NUMAQ
 	  firmware with - send email to <Martin.Bligh@us.ibm.com>.
 
 config X86_SUPPORTS_MEMORY_FAILURE
-	bool
+	def_bool y
 	# MCE code calls memory_failure():
 	depends on X86_MCE
 	# On 32-bit this adds too big of NODES_SHIFT and we run out of page flags:
@@ -455,7 +450,6 @@ config X86_SUPPORTS_MEMORY_FAILURE
 	# On 32-bit SPARSEMEM adds too big of SECTIONS_WIDTH:
 	depends on X86_64 || !SPARSEMEM
 	select ARCH_SUPPORTS_MEMORY_FAILURE
-	default y
 
 config X86_VISWS
 	bool "SGI 320/540 (Visual Workstation)"
@@ -570,7 +564,6 @@ config PARAVIRT_SPINLOCKS
 
 config PARAVIRT_CLOCK
 	bool
-	default n
 
 endif
 
@@ -749,7 +742,6 @@ config MAXSMP
 	bool "Configure Maximum number of SMP Processors and NUMA Nodes"
 	depends on X86_64 && SMP && DEBUG_KERNEL && EXPERIMENTAL
 	select CPUMASK_OFFSTACK
-	default n
 	---help---
 	  Configure maximum number of CPUS and NUMA Nodes for this architecture.
 	  If unsure, say N.
@@ -829,7 +821,6 @@ config X86_VISWS_APIC
 
 config X86_REROUTE_FOR_BROKEN_BOOT_IRQS
 	bool "Reroute for broken boot IRQs"
-	default n
 	depends on X86_IO_APIC
 	---help---
 	  This option enables a workaround that fixes a source of
@@ -876,9 +867,8 @@ config X86_MCE_AMD
 	   the DRAM Error Threshold.
 
 config X86_ANCIENT_MCE
-	def_bool n
+	bool "Support for old Pentium 5 / WinChip machine checks"
 	depends on X86_32 && X86_MCE
-	prompt "Support for old Pentium 5 / WinChip machine checks"
 	---help---
 	  Include support for machine check handling on old Pentium 5 or WinChip
 	  systems. These typically need to be enabled explicitely on the command
@@ -886,8 +876,7 @@ config X86_ANCIENT_MCE
 
 config X86_MCE_THRESHOLD
 	depends on X86_MCE_AMD || X86_MCE_INTEL
-	bool
-	default y
+	def_bool y
 
 config X86_MCE_INJECT
 	depends on X86_MCE
@@ -1026,8 +1015,8 @@ config X86_CPUID
 
 choice
 	prompt "High Memory Support"
-	default HIGHMEM4G if !X86_NUMAQ
 	default HIGHMEM64G if X86_NUMAQ
+	default HIGHMEM4G
 	depends on X86_32
 
 config NOHIGHMEM
@@ -1285,7 +1274,7 @@ source "mm/Kconfig"
 
 config HIGHPTE
 	bool "Allocate 3rd-level pagetables from highmem"
-	depends on X86_32 && (HIGHMEM4G || HIGHMEM64G)
+	depends on HIGHMEM
 	---help---
 	  The VM uses one page table entry for each page of physical memory.
 	  For systems with a lot of RAM, this can be wasteful of precious
@@ -1369,8 +1358,7 @@ config MATH_EMULATION
 	  kernel, it won't hurt.
 
 config MTRR
-	bool
-	default y
+	def_bool y
 	prompt "MTRR (Memory Type Range Register) support" if EMBEDDED
 	---help---
 	  On Intel P6 family processors (Pentium Pro, Pentium II and later)
@@ -1436,8 +1424,7 @@ config MTRR_SANITIZER_SPARE_REG_NR_DEFAULT
 	  mtrr_spare_reg_nr=N on the kernel command line.
 
 config X86_PAT
-	bool
-	default y
+	def_bool y
 	prompt "x86 PAT support" if EMBEDDED
 	depends on MTRR
 	---help---
@@ -1605,8 +1592,7 @@ config X86_NEED_RELOCS
 	depends on X86_32 && RELOCATABLE
 
 config PHYSICAL_ALIGN
-	hex
-	prompt "Alignment value to which kernel should be aligned" if X86_32
+	hex "Alignment value to which kernel should be aligned" if X86_32
 	default "0x1000000"
 	range 0x2000 0x1000000
 	---help---
@@ -1653,7 +1639,6 @@ config COMPAT_VDSO
 
 config CMDLINE_BOOL
 	bool "Built-in kernel command line"
-	default n
 	---help---
 	  Allow for specifying boot arguments to the kernel at
 	  build time.  On some systems (e.g. embedded ones), it is
@@ -1687,7 +1672,6 @@ config CMDLINE
 
 config CMDLINE_OVERRIDE
 	bool "Built-in command line overrides boot loader arguments"
-	default n
 	depends on CMDLINE_BOOL
 	---help---
 	  Set this option to 'Y' to have the kernel ignore the boot loader
@@ -1723,8 +1707,7 @@ source "drivers/acpi/Kconfig"
 source "drivers/sfi/Kconfig"
 
 config X86_APM_BOOT
-	bool
-	default y
+	def_bool y
 	depends on APM || APM_MODULE
 
 menuconfig APM
@@ -1953,8 +1936,7 @@ config DMAR_DEFAULT_ON
 	  experimental.
 
 config DMAR_BROKEN_GFX_WA
-	def_bool n
-	prompt "Workaround broken graphics drivers (going away soon)"
+	bool "Workaround broken graphics drivers (going away soon)"
 	depends on DMAR && BROKEN
 	---help---
 	  Current Graphics drivers tend to use physical address
@@ -2052,7 +2034,6 @@ config SCx200HR_TIMER
 config OLPC
 	bool "One Laptop Per Child support"
 	select GPIOLIB
-	default n
 	---help---
 	  Add support for detecting the unique features of the OLPC
 	  XO hardware.
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index bc01e3e..e7edd66 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -45,7 +45,6 @@ config EARLY_PRINTK
 
 config EARLY_PRINTK_DBGP
 	bool "Early printk via EHCI debug port"
-	default n
 	depends on EARLY_PRINTK && PCI
 	---help---
 	  Write kernel log output directly into the EHCI debug port.
@@ -76,7 +75,6 @@ config DEBUG_PER_CPU_MAPS
 	bool "Debug access to per_cpu maps"
 	depends on DEBUG_KERNEL
 	depends on SMP
-	default n
 	---help---
 	  Say Y to verify that the per_cpu map being accessed has
 	  been setup.  Adds a fair amount of code to kernel memory
diff --git a/arch/x86/include/asm/boot.h b/arch/x86/include/asm/boot.h
index 7a10659..3b62ab5 100644
--- a/arch/x86/include/asm/boot.h
+++ b/arch/x86/include/asm/boot.h
@@ -24,7 +24,7 @@
 #define MIN_KERNEL_ALIGN	(_AC(1, UL) << MIN_KERNEL_ALIGN_LG2)
 
 #if (CONFIG_PHYSICAL_ALIGN & (CONFIG_PHYSICAL_ALIGN-1)) || \
-	(CONFIG_PHYSICAL_ALIGN < (_AC(1, UL) << MIN_KERNEL_ALIGN_LG2))
+	(CONFIG_PHYSICAL_ALIGN < MIN_KERNEL_ALIGN)
 #error "Invalid value for CONFIG_PHYSICAL_ALIGN"
 #endif
 
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 693920b..1b950d1 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -54,7 +54,6 @@ EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(__memcpy);
 
 EXPORT_SYMBOL(empty_zero_page);
-EXPORT_SYMBOL(init_level4_pgt);
 #ifndef CONFIG_PARAVIRT
 EXPORT_SYMBOL(native_load_gs_index);
 #endif
