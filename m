Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab1BFWqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 17:46:19 -0500
Received: from www.tglx.de ([62.245.132.106]:59970 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab1BFWpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 17:45:41 -0500
Message-Id: <20110206224515.224027758@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 22:45:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeff Dike <jdike@addtoit.com>
Subject: [patch 2/4] um: Convert irq_chips to new functions
References: <20110206224358.096841291@linutronix.de>
Content-Disposition: inline; filename=um-convert-irq-chips.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/um/kernel/irq.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

Index: linux-next/arch/um/kernel/irq.c
===================================================================
--- linux-next.orig/arch/um/kernel/irq.c
+++ linux-next/arch/um/kernel/irq.c
@@ -360,10 +360,10 @@ EXPORT_SYMBOL(um_request_irq);
 EXPORT_SYMBOL(reactivate_fd);
 
 /*
- * irq_chip must define (startup || enable) &&
- * (shutdown || disable) && end
+ * irq_chip must define at least enable/disable and ack when
+ * the edge handler is used.
  */
-static void dummy(unsigned int irq)
+static void dummy(struct irq_data *d)
 {
 }
 
@@ -371,18 +371,17 @@ static void dummy(unsigned int irq)
 static struct irq_chip normal_irq_type = {
 	.name = "SIGIO",
 	.release = free_irq_by_irq_and_dev,
-	.disable = dummy,
-	.enable = dummy,
-	.ack = dummy,
+	.irq_disable = dummy,
+	.irq_enable = dummy,
+	.irq_ack = dummy,
 };
 
 static struct irq_chip SIGVTALRM_irq_type = {
 	.name = "SIGVTALRM",
 	.release = free_irq_by_irq_and_dev,
-	.shutdown = dummy, /* never called */
-	.disable = dummy,
-	.enable = dummy,
-	.ack = dummy,
+	.irq_disable = dummy,
+	.irq_enable = dummy,
+	.irq_ack = dummy,
 };
 
 void __init init_IRQ(void)


