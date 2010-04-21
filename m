Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab0DUOXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 10:23:48 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:39565 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab0DUOXr convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Wed, 21 Apr 2010 10:23:47 -0400
Message-Id: <4BCF2690020000780003B340@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 21 Apr 2010 15:23:44 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: clean up arch/x86/Kconfig*
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change intended.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/Kconfig            |   49 +++++++++++++-------------------------------
 arch/x86/Kconfig.debug      |    2 -
 arch/x86/include/asm/boot.h |    2 -
 3 files changed, 16 insertions(+), 37 deletions(-)

--- linux-2.6.34-rc5/arch/x86/Kconfig	2010-04-20 16:07:41.000000000 +0200
+++ 2.6.34-rc5-x86-kconfig-cleanup/arch/x86/Kconfig	2010-03-25 15:05:54.000000000 +0100
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
@@ -1436,8 +1424,7 @@ config MTRR_SANITIZER_SPARE_REG_NR_DEFAU
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
--- linux-2.6.34-rc5/arch/x86/Kconfig.debug	2010-02-24 19:52:17.000000000 +0100
+++ 2.6.34-rc5-x86-kconfig-cleanup/arch/x86/Kconfig.debug	2010-03-25 15:07:20.000000000 +0100
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
--- linux-2.6.34-rc5/arch/x86/include/asm/boot.h	2009-09-10 00:13:59.000000000 +0200
+++ 2.6.34-rc5-x86-kconfig-cleanup/arch/x86/include/asm/boot.h	2010-03-25 15:04:29.000000000 +0100
@@ -24,7 +24,7 @@
 #define MIN_KERNEL_ALIGN	(_AC(1, UL) << MIN_KERNEL_ALIGN_LG2)
 
 #if (CONFIG_PHYSICAL_ALIGN & (CONFIG_PHYSICAL_ALIGN-1)) || \
-	(CONFIG_PHYSICAL_ALIGN < (_AC(1, UL) << MIN_KERNEL_ALIGN_LG2))
+	(CONFIG_PHYSICAL_ALIGN < MIN_KERNEL_ALIGN)
 #error "Invalid value for CONFIG_PHYSICAL_ALIGN"
 #endif
 


