Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209Ab1IKMFt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 08:05:49 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:38281 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760101Ab1IKMAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 08:00:03 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 16/28] m68k/amiga: Refactor amiints.c
Date: Sun, 11 Sep 2011 13:59:42 +0200
Message-Id: <1315742394-16036-17-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - Remove filename in comments,
  - Reorder functions so we no longer need forward declarations.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v2: Added this changeset
---
 arch/m68k/amiga/amiints.c |   98 +++++++++++++++++++++-----------------------
 1 files changed, 47 insertions(+), 51 deletions(-)

diff --git a/arch/m68k/amiga/amiints.c b/arch/m68k/amiga/amiints.c
index e5f3033..c8f9eac 100644
--- a/arch/m68k/amiga/amiints.c
+++ b/arch/m68k/amiga/amiints.c
@@ -1,5 +1,5 @@
 /*
- * linux/arch/m68k/amiga/amiints.c -- Amiga Linux interrupt handling code
+ * Amiga Linux interrupt handling code
  *
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file COPYING in the main directory of this archive
@@ -16,56 +16,6 @@
 #include <asm/amigaints.h>
 #include <asm/amipcmcia.h>
 
-static void amiga_irq_enable(struct irq_data *data);
-static void amiga_irq_disable(struct irq_data *data);
-static irqreturn_t ami_int1(int irq, void *dev_id);
-static irqreturn_t ami_int3(int irq, void *dev_id);
-static irqreturn_t ami_int4(int irq, void *dev_id);
-static irqreturn_t ami_int5(int irq, void *dev_id);
-
-static struct irq_chip amiga_irq_chip = {
-	.name		= "amiga",
-	.irq_enable	= amiga_irq_enable,
-	.irq_disable	= amiga_irq_disable,
-};
-
-/*
- * void amiga_init_IRQ(void)
- *
- * Parameters:	None
- *
- * Returns:	Nothing
- *
- * This function should be called during kernel startup to initialize
- * the amiga IRQ handling routines.
- */
-
-void __init amiga_init_IRQ(void)
-{
-	if (request_irq(IRQ_AUTO_1, ami_int1, 0, "int1", NULL))
-		pr_err("Couldn't register int%d\n", 1);
-	if (request_irq(IRQ_AUTO_3, ami_int3, 0, "int3", NULL))
-		pr_err("Couldn't register int%d\n", 3);
-	if (request_irq(IRQ_AUTO_4, ami_int4, 0, "int4", NULL))
-		pr_err("Couldn't register int%d\n", 4);
-	if (request_irq(IRQ_AUTO_5, ami_int5, 0, "int5", NULL))
-		pr_err("Couldn't register int%d\n", 5);
-
-	m68k_setup_irq_controller(&amiga_irq_chip, handle_simple_irq, IRQ_USER,
-				  AMI_STD_IRQS);
-
-	/* turn off PCMCIA interrupts */
-	if (AMIGAHW_PRESENT(PCMCIA))
-		gayle.inten = GAYLE_IRQ_IDE;
-
-	/* turn off all interrupts and enable the master interrupt bit */
-	amiga_custom.intena = 0x7fff;
-	amiga_custom.intreq = 0x7fff;
-	amiga_custom.intena = IF_SETCLR | IF_INTEN;
-
-	cia_init_IRQ(&ciaa_base);
-	cia_init_IRQ(&ciab_base);
-}
 
 /*
  * Enable/disable a particular machine specific interrupt source.
@@ -84,6 +34,13 @@ static void amiga_irq_disable(struct irq_data *data)
 	amiga_custom.intena = 1 << (data->irq - IRQ_USER);
 }
 
+static struct irq_chip amiga_irq_chip = {
+	.name		= "amiga",
+	.irq_enable	= amiga_irq_enable,
+	.irq_disable	= amiga_irq_disable,
+};
+
+
 /*
  * The builtin Amiga hardware interrupt handlers.
  */
@@ -183,3 +140,42 @@ static irqreturn_t ami_int5(int irq, void *dev_id)
 	}
 	return IRQ_HANDLED;
 }
+
+
+/*
+ * void amiga_init_IRQ(void)
+ *
+ * Parameters:	None
+ *
+ * Returns:	Nothing
+ *
+ * This function should be called during kernel startup to initialize
+ * the amiga IRQ handling routines.
+ */
+
+void __init amiga_init_IRQ(void)
+{
+	if (request_irq(IRQ_AUTO_1, ami_int1, 0, "int1", NULL))
+		pr_err("Couldn't register int%d\n", 1);
+	if (request_irq(IRQ_AUTO_3, ami_int3, 0, "int3", NULL))
+		pr_err("Couldn't register int%d\n", 3);
+	if (request_irq(IRQ_AUTO_4, ami_int4, 0, "int4", NULL))
+		pr_err("Couldn't register int%d\n", 4);
+	if (request_irq(IRQ_AUTO_5, ami_int5, 0, "int5", NULL))
+		pr_err("Couldn't register int%d\n", 5);
+
+	m68k_setup_irq_controller(&amiga_irq_chip, handle_simple_irq, IRQ_USER,
+				  AMI_STD_IRQS);
+
+	/* turn off PCMCIA interrupts */
+	if (AMIGAHW_PRESENT(PCMCIA))
+		gayle.inten = GAYLE_IRQ_IDE;
+
+	/* turn off all interrupts and enable the master interrupt bit */
+	amiga_custom.intena = 0x7fff;
+	amiga_custom.intreq = 0x7fff;
+	amiga_custom.intena = IF_SETCLR | IF_INTEN;
+
+	cia_init_IRQ(&ciaa_base);
+	cia_init_IRQ(&ciab_base);
+}
-- 
1.7.0.4

