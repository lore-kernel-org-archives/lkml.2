Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab2JDDQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 23:16:40 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:34134 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab2JDDQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 23:16:01 -0400
From: Fabio Estevam <festevam@gmail.com>
To: sameo@linux.intel.com
Cc: broonie@opensource.wolfsonmicro.com, ashish.jangam@kpitcummins.com,
        dchen@diasemi.com, arnd@arndb.de, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6/6] gpio: gpio-da9052: Convert to the new da9052 interrupt functions
Date: Thu,  4 Oct 2012 00:15:09 -0300
Message-Id: <1349320509-26930-6-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349320509-26930-1-git-send-email-festevam@gmail.com>
References: <1349320509-26930-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Convert to the new da9052 interrupt functions, so that we can get rid of 
irq_base references.

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Build tested only.
 drivers/gpio/gpio-da9052.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-da9052.c b/drivers/gpio/gpio-da9052.c
index 24b8c29..3837072 100644
--- a/drivers/gpio/gpio-da9052.c
+++ b/drivers/gpio/gpio-da9052.c
@@ -185,7 +185,11 @@ static int da9052_gpio_to_irq(struct gpio_chip *gc, u32 offset)
 	struct da9052_gpio *gpio = to_da9052_gpio(gc);
 	struct da9052 *da9052 = gpio->da9052;
 
-	return da9052->irq_base + DA9052_IRQ_GPI0 + offset;
+	int irq;
+
+	irq = regmap_irq_get_virq(da9052->irq_data, DA9052_IRQ_GPI0 + offset);
+
+	return irq;
 }
 
 static struct gpio_chip reference_gp __devinitdata = {
-- 
1.7.9.5

