Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab1BJXiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:38:05 -0500
Received: from www.tglx.de ([62.245.132.106]:44386 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932286Ab1BJXiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:38:02 -0500
Message-Id: <20110210223259.324003319@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:52 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 52/75] genirq: Make CHECK_IRQ_PER_CPU an inline and deprecate
	it
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-make-that-wierd-check-inline.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its' too ugly and needs to go. The only users are core code and
parisc. Core code does not need it and parisc gets a new check once
IRQ_PER_CPU is reflected in irq_data.state.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -76,8 +76,12 @@ typedef	void (*irq_flow_handler_t)(unsig
 	 IRQ_NOAUTOEN | IRQ_MOVE_PCNTXT | IRQ_LEVEL | IRQ_NO_BALANCING | \
 	 IRQ_PER_CPU)
 
-# define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
-# define IRQ_NO_BALANCING_MASK	(IRQ_PER_CPU | IRQ_NO_BALANCING)
+#define IRQ_NO_BALANCING_MASK	(IRQ_PER_CPU | IRQ_NO_BALANCING)
+
+static inline __deprecated bool CHECK_IRQ_PER_CPU(unsigned int status)
+{
+	return status & IRQ_PER_CPU;
+}
 
 /*
  * Return value for chip->irq_set_affinity()


