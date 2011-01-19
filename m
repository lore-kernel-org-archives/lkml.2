Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab1ASVur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:50:47 -0500
Received: from www.tglx.de ([62.245.132.106]:40805 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab1ASVud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:50:33 -0500
Message-Id: <20110119210840.041837065@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 19 Jan 2011 21:49:30 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Richard Henderson <rth@twiddle.net>,
        Mike Frysinger <vapier@gentoo.org>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Greg Ungerer <gerg@uclinux.org>, Michal Simek <monstr@monstr.eu>,
        Kyle McMartin <kyle@mcmartin.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chen Liqin <liqin.chen@sunplusct.com>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Jeff Dike <jdike@addtoit.com>
Subject: [patch 24/37] genirq: Remove __do_IRQ
References: <20110119205258.462759212@linutronix.de>
Content-Disposition: inline; filename=genirq-remove__do_IRQ.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All architectures are finally converted. Remove the cruft.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: David Howells <dhowells@redhat.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Jeff Dike <jdike@addtoit.com>
---
 Documentation/feature-removal-schedule.txt |    8 --
 arch/alpha/Kconfig                         |    3 
 arch/blackfin/Kconfig                      |    3 
 arch/frv/Kconfig                           |    4 -
 arch/ia64/Kconfig                          |    3 
 arch/m68knommu/Kconfig                     |    4 -
 arch/microblaze/Kconfig                    |    3 
 arch/mips/Kconfig                          |    3 
 arch/mn10300/Kconfig                       |    3 
 arch/parisc/Kconfig                        |    4 -
 arch/powerpc/Kconfig                       |    4 -
 arch/score/Kconfig                         |    3 
 arch/sparc/Kconfig                         |    4 -
 arch/tile/Kconfig                          |    3 
 arch/um/Kconfig.um                         |    3 
 include/linux/irqdesc.h                    |   14 ---
 kernel/irq/Kconfig                         |    3 
 kernel/irq/handle.c                        |  111 -----------------------------
 18 files changed, 183 deletions(-)

Index: linux-2.6/Documentation/feature-removal-schedule.txt
===================================================================
--- linux-2.6.orig/Documentation/feature-removal-schedule.txt
+++ linux-2.6/Documentation/feature-removal-schedule.txt
@@ -357,14 +357,6 @@ Who:	Dave Jones <davej@redhat.com>, Matt
 
 -----------------------------
 
-What:	__do_IRQ all in one fits nothing interrupt handler
-When:	2.6.32
-Why:	__do_IRQ was kept for easy migration to the type flow handlers.
-	More than two years of migration time is enough.
-Who:	Thomas Gleixner <tglx@linutronix.de>
-
------------------------------
-
 What:	fakephp and associated sysfs files in /sys/bus/pci/slots/
 When:	2011
 Why:	In 2.6.27, the semantics of /sys/bus/pci/slots was redefined to
Index: linux-2.6/arch/alpha/Kconfig
===================================================================
--- linux-2.6.orig/arch/alpha/Kconfig
+++ linux-2.6/arch/alpha/Kconfig
@@ -68,9 +68,6 @@ config GENERIC_IOMAP
 	bool
 	default n
 
-config GENERIC_HARDIRQS_NO__DO_IRQ
-	def_bool y
-
 config GENERIC_HARDIRQS
 	bool
 	default y
Index: linux-2.6/arch/blackfin/Kconfig
===================================================================
--- linux-2.6.orig/arch/blackfin/Kconfig
+++ linux-2.6/arch/blackfin/Kconfig
@@ -50,9 +50,6 @@ config GENERIC_HARDIRQS
 config GENERIC_IRQ_PROBE
 	def_bool y
 
-config GENERIC_HARDIRQS_NO__DO_IRQ
-	def_bool y
-
 config GENERIC_GPIO
 	def_bool y
 
Index: linux-2.6/arch/frv/Kconfig
===================================================================
--- linux-2.6.orig/arch/frv/Kconfig
+++ linux-2.6/arch/frv/Kconfig
@@ -33,10 +33,6 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
-config GENERIC_HARDIRQS_NO__DO_IRQ
-	bool
-	default y
-
 config TIME_LOW_RES
 	bool
 	default y
Index: linux-2.6/arch/ia64/Kconfig
===================================================================
--- linux-2.6.orig/arch/ia64/Kconfig
+++ linux-2.6/arch/ia64/Kconfig
@@ -684,9 +684,6 @@ source "lib/Kconfig"
 config GENERIC_HARDIRQS
 	def_bool y
 
-config GENERIC_HARDIRQS_NO__DO_IRQ
-	def_bool y
-
 config GENERIC_IRQ_PROBE
 	bool
 	default y
Index: linux-2.6/arch/m68knommu/Kconfig
===================================================================
--- linux-2.6.orig/arch/m68knommu/Kconfig
+++ linux-2.6/arch/m68knommu/Kconfig
@@ -52,10 +52,6 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
-config GENERIC_HARDIRQS_NO__DO_IRQ
-	bool
-	default y
-
 config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
Index: linux-2.6/arch/microblaze/Kconfig
===================================================================
--- linux-2.6.orig/arch/microblaze/Kconfig
+++ linux-2.6/arch/microblaze/Kconfig
@@ -52,9 +52,6 @@ config GENERIC_TIME_VSYSCALL
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
-config GENERIC_HARDIRQS_NO__DO_IRQ
-	def_bool y
-
 config GENERIC_GPIO
 	def_bool y
 
Index: linux-2.6/arch/mips/Kconfig
===================================================================
--- linux-2.6.orig/arch/mips/Kconfig
+++ linux-2.6/arch/mips/Kconfig
@@ -793,9 +793,6 @@ config SCHED_OMIT_FRAME_POINTER
 	bool
 	default y
 
-config GENERIC_HARDIRQS_NO__DO_IRQ
-	def_bool y
-
 #
 # Select some configuration options automatically based on user selections.
 #
Index: linux-2.6/arch/mn10300/Kconfig
===================================================================
--- linux-2.6.orig/arch/mn10300/Kconfig
+++ linux-2.6/arch/mn10300/Kconfig
@@ -34,9 +34,6 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
-config GENERIC_HARDIRQS_NO__DO_IRQ
-	def_bool y
-
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
Index: linux-2.6/arch/parisc/Kconfig
===================================================================
--- linux-2.6.orig/arch/parisc/Kconfig
+++ linux-2.6/arch/parisc/Kconfig
@@ -12,7 +12,6 @@ config PARISC
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select GENERIC_ATOMIC64 if !64BIT
-	select GENERIC_HARDIRQS_NO__DO_IRQ
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
 	  in many of their workstations & servers (HP9000 700 and 800 series,
@@ -79,9 +78,6 @@ config IRQ_PER_CPU
 	bool
 	default y
 
-config GENERIC_HARDIRQS_NO__DO_IRQ
-	def_bool y
-
 # unless you want to implement ACPI on PA-RISC ... ;-)
 config PM
 	bool
Index: linux-2.6/arch/powerpc/Kconfig
===================================================================
--- linux-2.6.orig/arch/powerpc/Kconfig
+++ linux-2.6/arch/powerpc/Kconfig
@@ -40,10 +40,6 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
-config GENERIC_HARDIRQS_NO__DO_IRQ
-	bool
-	default y
-
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool PPC64
 
Index: linux-2.6/arch/score/Kconfig
===================================================================
--- linux-2.6.orig/arch/score/Kconfig
+++ linux-2.6/arch/score/Kconfig
@@ -53,9 +53,6 @@ config GENERIC_CLOCKEVENTS
 config SCHED_NO_NO_OMIT_FRAME_POINTER
 	def_bool y
 
-config GENERIC_HARDIRQS_NO__DO_IRQ
-	def_bool y
-
 config GENERIC_SYSCALL_TABLE
 	def_bool y
 
Index: linux-2.6/arch/sparc/Kconfig
===================================================================
--- linux-2.6.orig/arch/sparc/Kconfig
+++ linux-2.6/arch/sparc/Kconfig
@@ -107,10 +107,6 @@ config NEED_PER_CPU_EMBED_FIRST_CHUNK
 config NEED_PER_CPU_PAGE_FIRST_CHUNK
 	def_bool y if SPARC64
 
-config GENERIC_HARDIRQS_NO__DO_IRQ
-	bool
-	def_bool y if SPARC64
-
 config MMU
 	bool
 	default y
Index: linux-2.6/arch/tile/Kconfig
===================================================================
--- linux-2.6.orig/arch/tile/Kconfig
+++ linux-2.6/arch/tile/Kconfig
@@ -10,9 +10,6 @@ config GENERIC_CSUM
 config GENERIC_HARDIRQS
 	def_bool y
 
-config GENERIC_HARDIRQS_NO__DO_IRQ
-	def_bool y
-
 config GENERIC_IRQ_PROBE
 	def_bool y
 
Index: linux-2.6/arch/um/Kconfig.um
===================================================================
--- linux-2.6.orig/arch/um/Kconfig.um
+++ linux-2.6/arch/um/Kconfig.um
@@ -120,9 +120,6 @@ config SMP
 
 	  If you don't know what to do, say N.
 
-config GENERIC_HARDIRQS_NO__DO_IRQ
-	def_bool y
-
 config NR_CPUS
 	int "Maximum number of CPUs (2-32)"
 	range 2 32
Index: linux-2.6/include/linux/irqdesc.h
===================================================================
--- linux-2.6.orig/include/linux/irqdesc.h
+++ linux-2.6/include/linux/irqdesc.h
@@ -101,13 +101,6 @@ static inline struct irq_desc *move_irq_
 #define get_irq_desc_msi(desc)		((desc)->irq_data.msi_desc)
 
 /*
- * Monolithic do_IRQ implementation.
- */
-#ifndef CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ
-extern unsigned int __do_IRQ(unsigned int irq);
-#endif
-
-/*
  * Architectures call this to let the generic IRQ layer
  * handle an interrupt. If the descriptor is attached to an
  * irqchip-style controller then we call the ->handle_irq() handler,
@@ -115,14 +108,7 @@ extern unsigned int __do_IRQ(unsigned in
  */
 static inline void generic_handle_irq_desc(unsigned int irq, struct irq_desc *desc)
 {
-#ifdef CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ
 	desc->handle_irq(irq, desc);
-#else
-	if (likely(desc->handle_irq))
-		desc->handle_irq(irq, desc);
-	else
-		__do_IRQ(irq);
-#endif
 }
 
 static inline void generic_handle_irq(unsigned int irq)
Index: linux-2.6/kernel/irq/Kconfig
===================================================================
--- linux-2.6.orig/kernel/irq/Kconfig
+++ linux-2.6/kernel/irq/Kconfig
@@ -9,9 +9,6 @@ menu "IRQ subsystem"
 config GENERIC_HARDIRQS
        def_bool y
 
-config GENERIC_HARDIRQS_NO__DO_IRQ
-       def_bool y
-
 # Select this to disable the deprecated stuff
 config GENERIC_HARDIRQS_NO_DEPRECATED
        def_bool n
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -118,114 +118,3 @@ irqreturn_t handle_IRQ_event(unsigned in
 
 	return retval;
 }
-
-#ifndef CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ
-
-#ifdef CONFIG_ENABLE_WARN_DEPRECATED
-# warning __do_IRQ is deprecated. Please convert to proper flow handlers
-#endif
-
-/**
- * __do_IRQ - original all in one highlevel IRQ handler
- * @irq:	the interrupt number
- *
- * __do_IRQ handles all normal device IRQ's (the special
- * SMP cross-CPU interrupts have their own specific
- * handlers).
- *
- * This is the original x86 implementation which is used for every
- * interrupt type.
- */
-unsigned int __do_IRQ(unsigned int irq)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irqaction *action;
-	unsigned int status;
-
-	kstat_incr_irqs_this_cpu(irq, desc);
-
-	if (CHECK_IRQ_PER_CPU(desc->status)) {
-		irqreturn_t action_ret;
-
-		/*
-		 * No locking required for CPU-local interrupts:
-		 */
-		if (desc->irq_data.chip->ack)
-			desc->irq_data.chip->ack(irq);
-		if (likely(!(desc->status & IRQ_DISABLED))) {
-			action_ret = handle_IRQ_event(irq, desc->action);
-			if (!noirqdebug)
-				note_interrupt(irq, desc, action_ret);
-		}
-		desc->irq_data.chip->end(irq);
-		return 1;
-	}
-
-	raw_spin_lock(&desc->lock);
-	if (desc->irq_data.chip->ack)
-		desc->irq_data.chip->ack(irq);
-	/*
-	 * REPLAY is when Linux resends an IRQ that was dropped earlier
-	 * WAITING is used by probe to mark irqs that are being tested
-	 */
-	status = desc->status & ~(IRQ_REPLAY | IRQ_WAITING);
-	status |= IRQ_PENDING; /* we _want_ to handle it */
-
-	/*
-	 * If the IRQ is disabled for whatever reason, we cannot
-	 * use the action we have.
-	 */
-	action = NULL;
-	if (likely(!(status & (IRQ_DISABLED | IRQ_INPROGRESS)))) {
-		action = desc->action;
-		status &= ~IRQ_PENDING; /* we commit to handling */
-		status |= IRQ_INPROGRESS; /* we are handling it */
-	}
-	desc->status = status;
-
-	/*
-	 * If there is no IRQ handler or it was disabled, exit early.
-	 * Since we set PENDING, if another processor is handling
-	 * a different instance of this same irq, the other processor
-	 * will take care of it.
-	 */
-	if (unlikely(!action))
-		goto out;
-
-	/*
-	 * Edge triggered interrupts need to remember
-	 * pending events.
-	 * This applies to any hw interrupts that allow a second
-	 * instance of the same irq to arrive while we are in do_IRQ
-	 * or in the handler. But the code here only handles the _second_
-	 * instance of the irq, not the third or fourth. So it is mostly
-	 * useful for irq hardware that does not mask cleanly in an
-	 * SMP environment.
-	 */
-	for (;;) {
-		irqreturn_t action_ret;
-
-		raw_spin_unlock(&desc->lock);
-
-		action_ret = handle_IRQ_event(irq, action);
-		if (!noirqdebug)
-			note_interrupt(irq, desc, action_ret);
-
-		raw_spin_lock(&desc->lock);
-		if (likely(!(desc->status & IRQ_PENDING)))
-			break;
-		desc->status &= ~IRQ_PENDING;
-	}
-	desc->status &= ~IRQ_INPROGRESS;
-
-out:
-	/*
-	 * The ->end() handler has to deal with interrupts which got
-	 * disabled while the handler was running.
-	 */
-	desc->irq_data.chip->end(irq);
-	raw_spin_unlock(&desc->lock);
-
-	return 1;
-}
-#endif


