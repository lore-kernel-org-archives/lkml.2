Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab1BJXg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:36:59 -0500
Received: from www.tglx.de ([62.245.132.106]:44071 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757422Ab1BJXgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:52 -0500
Message-Id: <20110210223256.342045157@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 21/75] genirq: Mark handle_IRQ_event deprecated
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline;
	filename=genirq-mark-handle_IRQ_event-deprecated.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We really want to have special flow handlers in the core code so we
can see the patterns.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -248,8 +248,9 @@ static inline void move_masked_irq(int i
 
 extern int no_irq_affinity;
 
-/* Handle irq action chains: */
-extern irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action);
+/* Handle irq action chains. Will go away */
+extern irqreturn_t __deprecated handle_IRQ_event(unsigned int irq,
+						 struct irqaction *action);
 
 /*
  * Built-in IRQ handlers for various IRQ types,


