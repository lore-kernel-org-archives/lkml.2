Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965646Ab2JWVKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:10:14 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34398 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933665Ab2JWUFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:05 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 031/193] arch/x86: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:44 -0700
Message-Id: <1351022666-6960-32-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/Kconfig |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 46c3bff..25bf30c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -225,7 +225,7 @@ config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 
 config HAVE_INTEL_TXT
 	def_bool y
-	depends on EXPERIMENTAL && INTEL_IOMMU && ACPI
+	depends on INTEL_IOMMU && ACPI
 
 config X86_32_SMP
 	def_bool y
@@ -619,7 +619,7 @@ config PARAVIRT
 
 config PARAVIRT_SPINLOCKS
 	bool "Paravirtualization layer for spinlocks"
-	depends on PARAVIRT && SMP && EXPERIMENTAL
+	depends on PARAVIRT && SMP
 	---help---
 	  Paravirtualized spinlocks allow a pvops backend to replace the
 	  spinlock implementation with something virtualization-friendly
@@ -731,7 +731,7 @@ config GART_IOMMU
 config CALGARY_IOMMU
 	bool "IBM Calgary IOMMU support"
 	select SWIOTLB
-	depends on X86_64 && PCI && EXPERIMENTAL
+	depends on X86_64 && PCI
 	---help---
 	  Support for hardware IOMMUs in IBM's xSeries x366 and x460
 	  systems. Needed to run systems with more than 3GB of memory
@@ -773,7 +773,7 @@ config IOMMU_HELPER
 
 config MAXSMP
 	bool "Enable Maximum number of SMP Processors and NUMA Nodes"
-	depends on X86_64 && SMP && DEBUG_KERNEL && EXPERIMENTAL
+	depends on X86_64 && SMP && DEBUG_KERNEL
 	select CPUMASK_OFFSTACK
 	---help---
 	  Enable maximum number of CPUS and NUMA Nodes for this architecture.
@@ -1109,7 +1109,6 @@ config HIGHMEM64G
 endchoice
 
 choice
-	depends on EXPERIMENTAL
 	prompt "Memory split" if EXPERT
 	default VMSPLIT_3G
 	depends on X86_32
@@ -1186,7 +1185,7 @@ config DIRECT_GBPAGES
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support"
 	depends on SMP
-	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI) && EXPERIMENTAL)
+	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI))
 	default y if (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP)
 	---help---
 	  Enable NUMA (Non Uniform Memory Access) support.
@@ -1281,7 +1280,7 @@ config ARCH_DISCONTIGMEM_DEFAULT
 
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
-	depends on X86_64 || NUMA || (EXPERIMENTAL && X86_32) || X86_32_NON_STANDARD
+	depends on X86_64 || NUMA || X86_32 || X86_32_NON_STANDARD
 	select SPARSEMEM_STATIC if X86_32
 	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
 
@@ -1595,8 +1594,7 @@ config CRASH_DUMP
 	  For more details see Documentation/kdump/kdump.txt
 
 config KEXEC_JUMP
-	bool "kexec jump (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "kexec jump"
 	depends on KEXEC && HIBERNATION
 	---help---
 	  Jump between original kernel and kexeced kernel and invoke
@@ -1995,7 +1993,7 @@ config PCI_MMCONFIG
 
 config PCI_CNB20LE_QUIRK
 	bool "Read CNB20LE Host Bridge Windows" if EXPERT
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  Read the PCI windows out of the CNB20LE host bridge. This allows
 	  PCI hotplug to work on systems with the CNB20LE chipset which do
@@ -2189,8 +2187,8 @@ config IA32_AOUT
 	  Support old a.out binaries in the 32bit emulation.
 
 config X86_X32
-	bool "x32 ABI for 64-bit mode (EXPERIMENTAL)"
-	depends on X86_64 && IA32_EMULATION && EXPERIMENTAL
+	bool "x32 ABI for 64-bit mode"
+	depends on X86_64 && IA32_EMULATION
 	---help---
 	  Include code to run binaries for the x32 native 32-bit ABI
 	  for 64-bit processors.  An x32 process gets access to the
-- 
1.7.9.5

