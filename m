Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab1BFXjk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:39:40 -0500
Received: from www.tglx.de ([62.245.132.106]:40381 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab1BFXji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:39:38 -0500
Message-Id: <20110206233904.970326252@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 23:39:32 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Subject: [patch 09/10] m68knommu: Use proper irq_desc accessors in
	show_interrupts()
References: <20110206233845.480884215@linutronix.de>
Content-Disposition: inline;
	filename=m68k-nommu-use-proper-irq-desc-accessors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68knommu/kernel/irq.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-next/arch/m68knommu/kernel/irq.c
===================================================================
--- linux-next.orig/arch/m68knommu/kernel/irq.c
+++ linux-next/arch/m68knommu/kernel/irq.c
@@ -38,11 +38,13 @@ int show_interrupts(struct seq_file *p, 
 		seq_puts(p, "           CPU0\n");
 
 	if (irq < NR_IRQS) {
-		ap = irq_desc[irq].action;
+		struct irq_desc *desc = irq_to_desc(irq);
+
+		ap = desc->action;
 		if (ap) {
 			seq_printf(p, "%3d: ", irq);
 			seq_printf(p, "%10u ", kstat_irqs(irq));
-			seq_printf(p, "%14s  ", irq_desc[irq].chip->name);
+			seq_printf(p, "%14s  ", get_irq_desc_chip(desc)->name);
 
 			seq_printf(p, "%s", ap->name);
 			for (ap = ap->next; ap; ap = ap->next)


