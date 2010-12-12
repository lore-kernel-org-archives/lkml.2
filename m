Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab0LLM0F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 07:26:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60292 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752687Ab0LLM0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 07:26:03 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Conver tc35892 to new irq_ APIs
Date: Sun, 12 Dec 2010 12:26:09 +0000
Message-Id: <1292156769-20718-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The genirq core is being converted to pass struct irq_data to irq_chip
operations rather than an IRQ number. Update the tc35892 driver to the
new APIs.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/tc35892.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/tc35892.c b/drivers/mfd/tc35892.c
index e619e2a..6db55d8 100644
--- a/drivers/mfd/tc35892.c
+++ b/drivers/mfd/tc35892.c
@@ -163,15 +163,15 @@ static irqreturn_t tc35892_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static void tc35892_irq_dummy(unsigned int irq)
+static void tc35892_irq_dummy(struct irq_data *data)
 {
 	/* No mask/unmask at this level */
 }
 
 static struct irq_chip tc35892_irq_chip = {
-	.name	= "tc35892",
-	.mask	= tc35892_irq_dummy,
-	.unmask	= tc35892_irq_dummy,
+	.name		= "tc35892",
+	.irq_mask	= tc35892_irq_dummy,
+	.irq_unmask	= tc35892_irq_dummy,
 };
 
 static int tc35892_irq_init(struct tc35892 *tc35892)
-- 
1.7.2.3

