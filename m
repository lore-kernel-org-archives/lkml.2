Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab1DJFtv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 01:49:51 -0400
Received: from mail-iy0-f194.google.com ([209.85.210.194]:45798 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab1DJFtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 01:49:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GcHeyOBGNHbx+QQCWAAOEipaVHdZRzeawrnVQi9kQ2oBSMXszGc0AYw6rexNx4R2Oi
         i4n5AoZjeW4q7+Evw+FCFgqw03S1yS66IT/N6O1+BYQ1G3qSH1rvL/Kc2r+6koOu4HwH
         lx3dJB62vUwVO2J/Mc7QceM5diRmsGChzLjzQ=
From: wanlong.gao@gmail.com
To: hans-christian.egtvedt@atmel.com, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] fix the argument and irq_chip's members error
Date: Sun, 10 Apr 2011 13:49:00 +0800
Message-Id: <1302414540-13241-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

fix the functions' definition error of argument.
since the irq_chip and irq_data had changed .

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 arch/avr32/mach-at32ap/extint.c |   20 ++++++++++----------
 drivers/misc/sgi-gru/grufile.c  |    8 ++++----
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/avr32/mach-at32ap/extint.c b/arch/avr32/mach-at32ap/extint.c
index 47ba4b9..755ac59
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
diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
index 20e4e93..ecafa4b
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -348,15 +348,15 @@ static unsigned long gru_chiplet_cpu_to_mmr(int chiplet, int cpu, int *corep)
 
 static int gru_irq_count[GRU_CHIPLETS_PER_BLADE];
 
-static void gru_noop(unsigned int irq)
+static void gru_noop(struct irq_data *d)
 {
 }
 
 static struct irq_chip gru_chip[GRU_CHIPLETS_PER_BLADE] = {
 	[0 ... GRU_CHIPLETS_PER_BLADE - 1] {
-		.mask		= gru_noop,
-		.unmask		= gru_noop,
-		.ack		= gru_noop
+		.irq_mask	= gru_noop,
+		.irq_unmask	= gru_noop,
+		.irq_ack	= gru_noop
 	}
 };
 
-- 
1.7.3

