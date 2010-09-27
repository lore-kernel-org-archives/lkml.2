Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993Ab0I0Mqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:46:54 -0400
Received: from www.tglx.de ([62.245.132.106]:48929 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759277Ab0I0Mqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:46:52 -0400
Message-Id: <20100927121843.314600915@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 27 Sep 2010 12:46:02 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 19/19] x86: Use genirq Kconfig
References: <20100927121651.904100669@linutronix.de>
Content-Disposition: inline; filename=x86-use-genirq-kconfig.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig |   35 +++++------------------------------
 1 file changed, 5 insertions(+), 30 deletions(-)

Index: linux-2.6-tip/arch/x86/Kconfig
===================================================================
--- linux-2.6-tip.orig/arch/x86/Kconfig
+++ linux-2.6-tip/arch/x86/Kconfig
@@ -59,6 +59,10 @@ config X86
 	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
+	select HAVE_SPARSE_IRQ
+	select NUMA_IRQ_DESC if (SPARSE_IRQ && NUMA)
+	select GENERIC_IRQ_PROBE
+	select GENERIC_PENDING_IRQ if SMP
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
@@ -200,20 +204,6 @@ config HAVE_INTEL_TXT
 	def_bool y
 	depends on EXPERIMENTAL && DMAR && ACPI
 
-# Use the generic interrupt handling code in kernel/irq/:
-config GENERIC_HARDIRQS
-	def_bool y
-
-config GENERIC_HARDIRQS_NO__DO_IRQ
-       def_bool y
-
-config GENERIC_IRQ_PROBE
-	def_bool y
-
-config GENERIC_PENDING_IRQ
-	def_bool y
-	depends on GENERIC_HARDIRQS && SMP
-
 config USE_GENERIC_SMP_HELPERS
 	def_bool y
 	depends on SMP
@@ -296,22 +286,7 @@ config X86_X2APIC
 
 	  If you don't know what to do here, say N.
 
-config SPARSE_IRQ
-	bool "Support sparse irq numbering"
-	depends on PCI_MSI || HT_IRQ
-	---help---
-	  This enables support for sparse irqs. This is useful for distro
-	  kernels that want to define a high CONFIG_NR_CPUS value but still
-	  want to have low kernel memory footprint on smaller machines.
-
-	  ( Sparse IRQs can also be beneficial on NUMA boxes, as they spread
-	    out the irq_desc[] array in a more NUMA-friendly way. )
-
-	  If you don't know what to do here, say N.
-
-config NUMA_IRQ_DESC
-	def_bool y
-	depends on SPARSE_IRQ && NUMA
+source "kernel/irq/Kconfig"
 
 config X86_MPPARSE
 	bool "Enable MPS table" if ACPI


