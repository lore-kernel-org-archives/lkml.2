Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab1BJXg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:36:29 -0500
Received: from www.tglx.de ([62.245.132.106]:43957 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360Ab1BJXgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:25 -0500
Message-Id: <20110210223255.481469865@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 12/75] genirq: Move irq thread flags to core
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-move-thread-flags-to-core.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soleley used in core code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h |   14 --------------
 kernel/irq/internals.h    |   14 ++++++++++++++
 2 files changed, 14 insertions(+), 14 deletions(-)

Index: linux-2.6-tip/include/linux/interrupt.h
===================================================================
--- linux-2.6-tip.orig/include/linux/interrupt.h
+++ linux-2.6-tip/include/linux/interrupt.h
@@ -74,20 +74,6 @@
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND)
 
 /*
- * Bits used by threaded handlers:
- * IRQTF_RUNTHREAD - signals that the interrupt handler thread should run
- * IRQTF_DIED      - handler thread died
- * IRQTF_WARNED    - warning "IRQ_WAKE_THREAD w/o thread_fn" has been printed
- * IRQTF_AFFINITY  - irq thread is requested to adjust affinity
- */
-enum {
-	IRQTF_RUNTHREAD,
-	IRQTF_DIED,
-	IRQTF_WARNED,
-	IRQTF_AFFINITY,
-};
-
-/*
  * These values can be returned by request_any_context_irq() and
  * describe the context the interrupt will be run in.
  *
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -5,6 +5,20 @@
 
 extern int noirqdebug;
 
+/*
+ * Bits used by threaded handlers:
+ * IRQTF_RUNTHREAD - signals that the interrupt handler thread should run
+ * IRQTF_DIED      - handler thread died
+ * IRQTF_WARNED    - warning "IRQ_WAKE_THREAD w/o thread_fn" has been printed
+ * IRQTF_AFFINITY  - irq thread is requested to adjust affinity
+ */
+enum {
+	IRQTF_RUNTHREAD,
+	IRQTF_DIED,
+	IRQTF_WARNED,
+	IRQTF_AFFINITY,
+};
+
 #define irq_data_to_desc(data)	container_of(data, struct irq_desc, irq_data)
 
 /* Set default functions for irq_chip structures: */


