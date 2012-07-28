Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab2G1GKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 02:10:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60089 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab2G1GKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 02:10:53 -0400
From: Chandrabhanu Mahapatra <cmahapatra@ti.com>
To: <linus.walleij@stericsson.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <leed.aguilar@ti.com>, Chandrabhanu Mahapatra <cmahapatra@ti.com>
Subject: [PATCH V1 2/3] gpio/pca953x: increase variables size to support 24 bit of data
Date: Sat, 28 Jul 2012 11:37:55 +0530
Message-ID: <d22b134ca3d86a37a0a54484ad473d7dfe151529.1343026861.git.cmahapatra@ti.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1343026861.git.cmahapatra@ti.com>
References: <cover.1341925681.git.cmahapatra@ti.com> <cover.1343026861.git.cmahapatra@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leed Aguilar <leed.aguilar@ti.com>

Increase variable size from u16 to u32 to allocate 24 bit of data required for
the TCA6424 I/O expander device type.

Signed-off-by: Leed Aguilar <leed.aguilar@ti.com>
Signed-off-by: Chandrabhanu Mahapatra <cmahapatra@ti.com>
---
 drivers/gpio/gpio-pca953x.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index af7024f..c3ca7d8 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -78,10 +78,10 @@ struct pca953x_chip {
 
 #ifdef CONFIG_GPIO_PCA953X_IRQ
 	struct mutex irq_lock;
-	uint16_t irq_mask;
-	uint16_t irq_stat;
-	uint16_t irq_trig_raise;
-	uint16_t irq_trig_fall;
+	u32 irq_mask;
+	u32 irq_stat;
+	u32 irq_trig_raise;
+	u32 irq_trig_fall;
 	int	 irq_base;
 #endif
 
@@ -349,8 +349,8 @@ static void pca953x_irq_bus_lock(struct irq_data *d)
 static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 {
 	struct pca953x_chip *chip = irq_data_get_irq_chip_data(d);
-	uint16_t new_irqs;
-	uint16_t level;
+	u32 new_irqs;
+	u32 level;
 
 	/* Look for any newly setup interrupt */
 	new_irqs = chip->irq_trig_fall | chip->irq_trig_raise;
@@ -368,8 +368,8 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 static int pca953x_irq_set_type(struct irq_data *d, unsigned int type)
 {
 	struct pca953x_chip *chip = irq_data_get_irq_chip_data(d);
-	uint16_t level = d->irq - chip->irq_base;
-	uint16_t mask = 1 << level;
+	u32 level = d->irq - chip->irq_base;
+	u32 mask = 1 << level;
 
 	if (!(type & IRQ_TYPE_EDGE_BOTH)) {
 		dev_err(&chip->client->dev, "irq %d: unsupported type %d\n",
@@ -399,12 +399,12 @@ static struct irq_chip pca953x_irq_chip = {
 	.irq_set_type		= pca953x_irq_set_type,
 };
 
-static uint16_t pca953x_irq_pending(struct pca953x_chip *chip)
+static u32 pca953x_irq_pending(struct pca953x_chip *chip)
 {
 	u32 cur_stat;
-	uint16_t old_stat;
-	uint16_t pending;
-	uint16_t trigger;
+	u32 old_stat;
+	u32 pending;
+	u32 trigger;
 	int ret, offset = 0;
 
 	switch (chip->chip_type) {
@@ -440,8 +440,8 @@ static uint16_t pca953x_irq_pending(struct pca953x_chip *chip)
 static irqreturn_t pca953x_irq_handler(int irq, void *devid)
 {
 	struct pca953x_chip *chip = devid;
-	uint16_t pending;
-	uint16_t level;
+	u32 pending;
+	u32 level;
 
 	pending = pca953x_irq_pending(chip);
 
-- 
1.7.10

