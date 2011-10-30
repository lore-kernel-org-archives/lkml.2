Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934087Ab1J3MtE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 08:49:04 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:43180 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934032Ab1J3Msu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 08:48:50 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 07/27] m68k/irq: Extract irq_set_chip()
Date: Sun, 30 Oct 2011 13:48:15 +0100
Message-Id: <1319978915-10933-8-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
References: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68k/kernel/ints.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index e68a3bd..4f9868e 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -55,6 +55,12 @@ static struct irq_data *irq_list[NR_IRQS];
 static struct irq_chip *irq_chip[NR_IRQS];
 static int irq_depth[NR_IRQS];
 
+static inline int irq_set_chip(unsigned int irq, struct irq_chip *chip)
+{
+	irq_chip[irq] = chip;
+	return 0;
+}
+
 static int m68k_first_user_vec;
 
 static struct irq_chip auto_irq_chip = {
@@ -94,7 +100,7 @@ void __init init_IRQ(void)
 	}
 
 	for (i = IRQ_AUTO_1; i <= IRQ_AUTO_7; i++)
-		irq_chip[i] = &auto_irq_chip;
+		irq_set_chip(i, &auto_irq_chip);
 
 	mach_init_IRQ();
 }
@@ -134,7 +140,7 @@ void __init m68k_setup_user_interrupt(unsigned int vec, unsigned int cnt,
 	BUG_ON(IRQ_USER + cnt > NR_IRQS);
 	m68k_first_user_vec = vec;
 	for (i = 0; i < cnt; i++)
-		irq_chip[IRQ_USER + i] = &user_irq_chip;
+		irq_set_chip(IRQ_USER + i, &user_irq_chip);
 	*user_irqvec_fixup = vec - IRQ_USER;
 	if (handler)
 		*user_irqhandler_fixup = (u32)handler;
@@ -157,7 +163,7 @@ void m68k_setup_irq_chip(struct irq_chip *contr, unsigned int irq,
 	int i;
 
 	for (i = 0; i < cnt; i++)
-		irq_chip[irq + i] = contr;
+		irq_set_chip(irq + i, contr);
 }
 
 struct irq_data *new_irq_node(void)
-- 
1.7.0.4

