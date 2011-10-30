Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934135Ab1J3Myf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 08:54:35 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:37490 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615Ab1J3Mss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 08:48:48 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 03/27] m68k/irq: Kill irq_node_t typedef, always use struct irq_node
Date: Sun, 30 Oct 2011 13:48:11 +0100
Message-Id: <1319978915-10933-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
References: <1319978915-10933-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68k/include/asm/irq.h |    8 ++++----
 arch/m68k/kernel/ints.c     |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/m68k/include/asm/irq.h b/arch/m68k/include/asm/irq.h
index d8c6f68..bfc521f 100644
--- a/arch/m68k/include/asm/irq.h
+++ b/arch/m68k/include/asm/irq.h
@@ -75,13 +75,13 @@ struct pt_regs;
  * This structure is used to chain together the ISRs for a particular
  * interrupt source (if it supports chaining).
  */
-typedef struct irq_node {
+struct irq_node {
 	irqreturn_t	(*handler)(int, void *);
 	void		*dev_id;
 	struct irq_node *next;
 	unsigned long	flags;
 	const char	*devname;
-} irq_node_t;
+};
 
 /*
  * This structure has only 4 elements for speed reasons
@@ -105,9 +105,9 @@ extern unsigned int m68k_irq_startup(unsigned int);
 extern void m68k_irq_shutdown(unsigned int);
 
 /*
- * This function returns a new irq_node_t
+ * This function returns a new struct irq_node
  */
-extern irq_node_t *new_irq_node(void);
+extern struct irq_node *new_irq_node(void);
 
 extern void m68k_setup_auto_interrupt(void (*handler)(unsigned int, struct pt_regs *));
 extern void m68k_setup_user_interrupt(unsigned int vec, unsigned int cnt,
diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index f43ad7b..9de8eb4 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -70,7 +70,7 @@ static struct irq_chip user_irq_chip = {
 };
 
 #define NUM_IRQ_NODES 100
-static irq_node_t nodes[NUM_IRQ_NODES];
+static struct irq_node nodes[NUM_IRQ_NODES];
 
 /*
  * void init_IRQ(void)
@@ -160,9 +160,9 @@ void m68k_setup_irq_chip(struct irq_chip *contr, unsigned int irq,
 		irq_chip[irq + i] = contr;
 }
 
-irq_node_t *new_irq_node(void)
+struct irq_node *new_irq_node(void)
 {
-	irq_node_t *node;
+	struct irq_node *node;
 	short i;
 
 	for (node = nodes, i = NUM_IRQ_NODES-1; i >= 0; node++, i--) {
-- 
1.7.0.4

