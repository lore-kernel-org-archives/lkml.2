Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab2ECMyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:54:46 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:43528 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754223Ab2ECMyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:54:44 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lrg@ti.com>
Subject: [PATCH 1/3] MFD: twl6040: Code cleanup in interrupt initialization part
Date: Thu,  3 May 2012 15:54:23 +0300
Message-Id: <1336049665-27777-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1336049665-27777-1-git-send-email-peter.ujfalusi@ti.com>
References: <1336049665-27777-1-git-send-email-peter.ujfalusi@ti.com>
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

