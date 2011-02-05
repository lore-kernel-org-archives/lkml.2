Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab1BEUJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 15:09:45 -0500
Received: from www.tglx.de ([62.245.132.106]:44500 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab1BEUI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 15:08:58 -0500
Message-Id: <20110205200703.824900693@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 Feb 2011 20:08:52 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [patch 1/4] xen: Remove stale irq_chip.end
References: <20110205200108.921707839@linutronix.de>
Content-Disposition: inline; filename=xen-remove-stale-irq_chip-end.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_chip.end got obsolete with the removal of __do_IRQ()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/xen/events.c |   18 ------------------
 1 file changed, 18 deletions(-)

Index: linux-next/drivers/xen/events.c
===================================================================
--- linux-next.orig/drivers/xen/events.c
+++ linux-next/drivers/xen/events.c
@@ -551,23 +551,6 @@ static void ack_pirq(unsigned int irq)
 	}
 }
 
-static void end_pirq(unsigned int irq)
-{
-	int evtchn = evtchn_from_irq(irq);
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	if (WARN_ON(!desc))
-		return;
-
-	if ((desc->status & (IRQ_DISABLED|IRQ_PENDING)) ==
-	    (IRQ_DISABLED|IRQ_PENDING)) {
-		shutdown_pirq(irq);
-	} else if (VALID_EVTCHN(evtchn)) {
-		unmask_evtchn(evtchn);
-		pirq_unmask_notify(irq);
-	}
-}
-
 static int find_irq_by_gsi(unsigned gsi)
 {
 	int irq;
@@ -1504,7 +1487,6 @@ static struct irq_chip xen_pirq_chip __r
 	.mask		= disable_pirq,
 
 	.ack		= ack_pirq,
-	.end		= end_pirq,
 
 	.set_affinity	= set_affinity_irq,
 


