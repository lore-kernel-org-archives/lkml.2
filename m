Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967447Ab2EPLMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:12:12 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:52280 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967378Ab2EPLMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:12:09 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        peter.ujfalusi@ti.com, Misael Lopez Cruz <misael.lopez@ti.com>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH v3 1/4] MFD: twl6040: Code cleanup in interrupt initialization part
Date: Wed, 16 May 2012 14:11:55 +0300
Message-Id: <1337166718-8458-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1337166718-8458-1-git-send-email-peter.ujfalusi@ti.com>
References: <1337166718-8458-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change, just to make the code a bit more uniform and
remove wrapped lines.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-irq.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/twl6040-irq.c b/drivers/mfd/twl6040-irq.c
index b3f8dda..008022c 100644
--- a/drivers/mfd/twl6040-irq.c
+++ b/drivers/mfd/twl6040-irq.c
@@ -138,7 +138,7 @@ static irqreturn_t twl6040_irq_thread(int irq, void *data)
 
 int twl6040_irq_init(struct twl6040 *twl6040)
 {
-	int cur_irq, ret;
+	int i, nr_irqs, ret;
 	u8 val;
 
 	mutex_init(&twl6040->irq_mutex);
@@ -148,21 +148,20 @@ int twl6040_irq_init(struct twl6040 *twl6040)
 	twl6040->irq_masks_cache = TWL6040_ALLINT_MSK;
 	twl6040_reg_write(twl6040, TWL6040_REG_INTMR, TWL6040_ALLINT_MSK);
 
+	nr_irqs = ARRAY_SIZE(twl6040_irqs);
 	/* Register them with genirq */
-	for (cur_irq = twl6040->irq_base;
-	     cur_irq < twl6040->irq_base + ARRAY_SIZE(twl6040_irqs);
-	     cur_irq++) {
-		irq_set_chip_data(cur_irq, twl6040);
-		irq_set_chip_and_handler(cur_irq, &twl6040_irq_chip,
+	for (i = twl6040->irq_base; i < twl6040->irq_base + nr_irqs; i++) {
+		irq_set_chip_data(i, twl6040);
+		irq_set_chip_and_handler(i, &twl6040_irq_chip,
 					 handle_level_irq);
-		irq_set_nested_thread(cur_irq, 1);
+		irq_set_nested_thread(i, 1);
 
 		/* ARM needs us to explicitly flag the IRQ as valid
 		 * and will set them noprobe when we do so. */
 #ifdef CONFIG_ARM
-		set_irq_flags(cur_irq, IRQF_VALID);
+		set_irq_flags(i, IRQF_VALID);
 #else
-		irq_set_noprobe(cur_irq);
+		irq_set_noprobe(i);
 #endif
 	}
 
-- 
1.7.8.6

