Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab1BJXo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:44:57 -0500
Received: from www.tglx.de ([62.245.132.106]:44331 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932245Ab1BJXhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:50 -0500
Message-Id: <20110210223259.041816965@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 49/75] genirq: Add state field to irq_data
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-add-state-to-irq-data.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some chip implementations need to access certain status flags. With
sparse irqs that requires a lookup of the irq descriptor. Add a state
field which contains such flags.

Name it in a way which will make coders happy to access it with the
proper accessor functions. And it's easy to grep for.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h     |    3 +++
 include/linux/irqdesc.h |    1 +
 2 files changed, 4 insertions(+)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -100,6 +100,8 @@ struct msi_desc;
  * struct irq_data - per irq and irq chip data passed down to chip functions
  * @irq:		interrupt number
  * @node:		node index useful for balancing
+ * @state_use_accessor: status information for irq chip functions.
+ *			Use accessor functions to deal with it
  * @chip:		low level interrupt hardware access
  * @handler_data:	per-IRQ data for the irq_chip methods
  * @chip_data:		platform-specific per-chip private data for the chip
@@ -114,6 +116,7 @@ struct msi_desc;
 struct irq_data {
 	unsigned int		irq;
 	unsigned int		node;
+	unsigned int		state_use_accessors;
 	struct irq_chip		*chip;
 	void			*handler_data;
 	void			*chip_data;
Index: linux-2.6-tip/include/linux/irqdesc.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irqdesc.h
+++ linux-2.6-tip/include/linux/irqdesc.h
@@ -48,6 +48,7 @@ struct irq_desc {
 		struct {
 			unsigned int		irq;
 			unsigned int		node;
+			unsigned int		pad_do_not_even_think_about_it;
 			struct irq_chip		*chip;
 			void			*handler_data;
 			void			*chip_data;


