Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273Ab0I0Mqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:46:47 -0400
Received: from www.tglx.de ([62.245.132.106]:48922 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759188Ab0I0Mqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:46:45 -0400
Message-Id: <20100927121843.217333624@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 27 Sep 2010 12:45:59 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 18/19] genirq: Provide Kconfig
References: <20100927121651.904100669@linutronix.de>
Content-Disposition: inline; filename=genirq-provide-kconfig.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic irq Kconfig options are copied around all archs. Provide a
generic Kconfig file which can be included.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/Kconfig |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

Index: linux-2.6-tip/kernel/irq/Kconfig
===================================================================
--- /dev/null
+++ linux-2.6-tip/kernel/irq/Kconfig
@@ -0,0 +1,49 @@
+#
+# Interrupt subsystem related configuration options
+#
+
+menu "Interrupt handling subsystem"
+
+config GENERIC_HARDIRQS
+	def_bool y
+
+config GENERIC_HARDIRQS_NO__DO_IRQ
+       def_bool y
+
+# Options selectable by the architecture code
+config HAVE_SPARSE_IRQ
+       def_bool n
+
+config GENERIC_IRQ_PROBE
+	def_bool n
+
+config GENERIC_PENDING_IRQ
+	def_bool n
+
+if SPARSE_IRQ && NUMA
+config NUMA_IRQ_DESC
+	def_bool n
+endif
+
+config AUTO_IRQ_AFFINITY
+       def_bool n
+
+config IRQ_PER_CPU
+       def_bool n
+
+config HARDIRQS_SW_RESEND
+       def_bool n
+
+config SPARSE_IRQ
+	bool "Support sparse irq numbering"
+	depends on HAVE_SPARSE_IRQ
+	---help---
+	  This enables support for sparse irqs. This is useful for distro
+	  kernels that want to define a high CONFIG_NR_CPUS value but still
+	  want to have low kernel memory footprint on smaller machines.
+
+	  ( Sparse IRQs can also be beneficial on NUMA boxes, as they spread
+	    out the irq_desc[] array in a more NUMA-friendly way. )
+
+	  If you don't know what to do here, say N.
+


