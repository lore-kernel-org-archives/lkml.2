Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab2LLSWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:22:53 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:35175 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753966Ab2LLSWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:22:50 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 21/26] irq: Convert print_symbol to %pSR
Date: Wed, 12 Dec 2012 10:19:10 -0800
Message-Id: <6a6e90a166a5e904d2284c2becbfbdda45bc1121.1355335228.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1355335227.git.joe@perches.com>
References: <cover.1355335227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new vsprintf extension to avoid any possible
message interleaving.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/irq/debug.h |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/irq/debug.h b/kernel/irq/debug.h
index e75e29e..70f487d9 100644
--- a/kernel/irq/debug.h
+++ b/kernel/irq/debug.h
@@ -13,15 +13,14 @@ static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
 {
 	printk("irq %d, desc: %p, depth: %d, count: %d, unhandled: %d\n",
 		irq, desc, desc->depth, desc->irq_count, desc->irqs_unhandled);
-	printk("->handle_irq():  %p, ", desc->handle_irq);
-	print_symbol("%s\n", (unsigned long)desc->handle_irq);
-	printk("->irq_data.chip(): %p, ", desc->irq_data.chip);
-	print_symbol("%s\n", (unsigned long)desc->irq_data.chip);
+	printk("->handle_irq():  %p, %pSR\n",
+	       desc->handle_irq, desc->handle_irq);
+	printk("->irq_data.chip(): %p, %pSR\n",
+	       desc->irq_data.chip, desc->irq_data.chip);
 	printk("->action(): %p\n", desc->action);
-	if (desc->action) {
-		printk("->action->handler(): %p, ", desc->action->handler);
-		print_symbol("%s\n", (unsigned long)desc->action->handler);
-	}
+	if (desc->action)
+		printk("->action->handler(): %p, %pSR\n",
+		       desc->action->handler, desc->action->handler);
 
 	___P(IRQ_LEVEL);
 	___P(IRQ_PER_CPU);
-- 
1.7.8.112.g3fd21

