Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab1BCArd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:47:33 -0500
Received: from www.tglx.de ([62.245.132.106]:37647 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012Ab1BCAra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:47:30 -0500
Message-Id: <20110203004210.529096297@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 Feb 2011 00:46:59 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, Tony Luck <tony.luck@intel.com>,
        David Howells <dhowells@redhat.com>, Michal Simek <monstr@monstr.eu>
Subject: [patch 6/8] powerpc: Remove stale irq_chip.end
References: <20110203003745.371989282@linutronix.de>
Content-Disposition: inline; filename=powerpc-remove-stale-irq_chip-end.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_chip.end got obsolete with the removal of __do_IRQ()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c |    1 -
 arch/powerpc/sysdev/tsi108_pci.c             |   13 -------------
 2 files changed, 14 deletions(-)

Index: linux-2.6-tip/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
+++ linux-2.6-tip/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
@@ -71,7 +71,6 @@ static void pq2ads_pci_unmask_irq(unsign
 
 static struct irq_chip pq2ads_pci_ic = {
 	.name = "PQ2 ADS PCI",
-	.end = pq2ads_pci_unmask_irq,
 	.mask = pq2ads_pci_mask_irq,
 	.mask_ack = pq2ads_pci_mask_irq,
 	.ack = pq2ads_pci_mask_irq,
Index: linux-2.6-tip/arch/powerpc/sysdev/tsi108_pci.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/sysdev/tsi108_pci.c
+++ linux-2.6-tip/arch/powerpc/sysdev/tsi108_pci.c
@@ -358,18 +358,6 @@ static void tsi108_pci_irq_ack(u_int irq
 	tsi108_pci_int_mask(irq);
 }
 
-static void tsi108_pci_irq_end(u_int irq)
-{
-	tsi108_pci_int_unmask(irq);
-
-	/* Enable interrupts from PCI block */
-	tsi108_write_reg(TSI108_PCI_OFFSET + TSI108_PCI_IRP_ENABLE,
-			 tsi108_read_reg(TSI108_PCI_OFFSET +
-					 TSI108_PCI_IRP_ENABLE) |
-			 TSI108_PCI_IRP_ENABLE_P_INT);
-	mb();
-}
-
 /*
  * Interrupt controller descriptor for cascaded PCI interrupt controller.
  */
@@ -378,7 +366,6 @@ static struct irq_chip tsi108_pci_irq = 
 	.name = "tsi108_PCI_int",
 	.mask = tsi108_pci_irq_disable,
 	.ack = tsi108_pci_irq_ack,
-	.end = tsi108_pci_irq_end,
 	.unmask = tsi108_pci_irq_enable,
 };
 


