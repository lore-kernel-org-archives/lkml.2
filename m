Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab1DJEZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 00:25:31 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:48038 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750933Ab1DJEZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 00:25:27 -0400
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: linux-kernel@vger.kernel.org
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice Vilchez <patrice.vilchez@atmel.com>
Subject: [PATCH 1/2] avr32: At32ap: fix extint irq_chip type from irq_chip to irq_data
Date: Sun, 10 Apr 2011 06:17:19 +0200
Message-Id: <1302409040-13791-1-git-send-email-plagnioj@jcrosoft.com>
X-Mailer: git-send-email 1.7.2.3
X-Ovh-Tracer-Id: 3545177333337074456
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

introduce in commit 7776e233ef

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Patrice Vilchez <patrice.vilchez@atmel.com>
---
 arch/avr32/mach-at32ap/extint.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/avr32/mach-at32ap/extint.c b/arch/avr32/mach-at32ap/extint.c
index 47ba4b9..755ac59 100644
--- a/arch/avr32/mach-at32ap/extint.c
+++ b/arch/avr32/mach-at32ap/extint.c
@@ -61,34 +61,34 @@ struct eic {
 static struct eic *nmi_eic;
 static bool nmi_enabled;
 
-static void eic_ack_irq(struct irq_chip *d)
+static void eic_ack_irq(struct irq_data *d)
 {
-	struct eic *eic = irq_data_get_irq_chip_data(data);
+	struct eic *eic = irq_data_get_irq_chip_data(d);
 	eic_writel(eic, ICR, 1 << (d->irq - eic->first_irq));
 }
 
-static void eic_mask_irq(struct irq_chip *d)
+static void eic_mask_irq(struct irq_data *d)
 {
-	struct eic *eic = irq_data_get_irq_chip_data(data);
+	struct eic *eic = irq_data_get_irq_chip_data(d);
 	eic_writel(eic, IDR, 1 << (d->irq - eic->first_irq));
 }
 
-static void eic_mask_ack_irq(struct irq_chip *d)
+static void eic_mask_ack_irq(struct irq_data *d)
 {
-	struct eic *eic = irq_data_get_irq_chip_data(data);
+	struct eic *eic = irq_data_get_irq_chip_data(d);
 	eic_writel(eic, ICR, 1 << (d->irq - eic->first_irq));
 	eic_writel(eic, IDR, 1 << (d->irq - eic->first_irq));
 }
 
-static void eic_unmask_irq(struct irq_chip *d)
+static void eic_unmask_irq(struct irq_data *d)
 {
-	struct eic *eic = irq_data_get_irq_chip_data(data);
+	struct eic *eic = irq_data_get_irq_chip_data(d);
 	eic_writel(eic, IER, 1 << (d->irq - eic->first_irq));
 }
 
-static int eic_set_irq_type(struct irq_chip *d, unsigned int flow_type)
+static int eic_set_irq_type(struct irq_data *d, unsigned int flow_type)
 {
-	struct eic *eic = irq_data_get_irq_chip_data(data);
+	struct eic *eic = irq_data_get_irq_chip_data(d);
 	unsigned int irq = d->irq;
 	unsigned int i = irq - eic->first_irq;
 	u32 mode, edge, level;
-- 
1.7.4.1

