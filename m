Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab2KMNw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 08:52:28 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18520 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab2KMNvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 08:51:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 13 Nov 2012 05:51:52 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <grant.likely@secretlab.ca>,
        <linus.walleij@linaro.org>, <broonie@opensource.wolfsonmicro.com>
CC: <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH RESEND 3/3] mfd: tps6586x: implement gpio_to_irq
Date: Tue, 13 Nov 2012 19:18:07 +0530
Message-ID: <1352814487-25886-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1352814487-25886-1-git-send-email-ldewangan@nvidia.com>
References: <1352814487-25886-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TPS6586x adds the interrupt of this device using
linear mapping on irq domain.
Hence, implement gpio_to_irq to get the irq number
corresponding to TPS6586x GPIOs which is created
dynamically.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
Reposting in case of patch missed.
Also added Reviewed by Mark as he already reviewed the patches.
Linus W has already acked it as adding his ack.

 drivers/gpio/gpio-tps6586x.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-tps6586x.c b/drivers/gpio/gpio-tps6586x.c
index 2526b3b..62e9e1c 100644
--- a/drivers/gpio/gpio-tps6586x.c
+++ b/drivers/gpio/gpio-tps6586x.c
@@ -80,6 +80,14 @@ static int tps6586x_gpio_output(struct gpio_chip *gc, unsigned offset,
 				val, mask);
 }
 
+static int tps6586x_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
+{
+	struct tps6586x_gpio *tps6586x_gpio = to_tps6586x_gpio(gc);
+
+	return tps6586x_irq_get_virq(tps6586x_gpio->parent,
+				TPS6586X_INT_PLDO_0 + offset);
+}
+
 static int __devinit tps6586x_gpio_probe(struct platform_device *pdev)
 {
 	struct tps6586x_platform_data *pdata;
@@ -106,6 +114,7 @@ static int __devinit tps6586x_gpio_probe(struct platform_device *pdev)
 	tps6586x_gpio->gpio_chip.direction_output = tps6586x_gpio_output;
 	tps6586x_gpio->gpio_chip.set	= tps6586x_gpio_set;
 	tps6586x_gpio->gpio_chip.get	= tps6586x_gpio_get;
+	tps6586x_gpio->gpio_chip.to_irq	= tps6586x_gpio_to_irq;
 
 #ifdef CONFIG_OF_GPIO
 	tps6586x_gpio->gpio_chip.of_node = pdev->dev.parent->of_node;
-- 
1.7.1.1

