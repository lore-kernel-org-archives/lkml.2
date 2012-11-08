Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab2KHC1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 21:27:43 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:46839 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2KHC1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 21:27:42 -0500
Message-ID: <1352341649.19098.1.camel@phoenix>
Subject: [PATCH] gpio: mvebu: Set free callback for gpio_chip
From: Axel Lin <axel.lin@ingics.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Date: Thu, 08 Nov 2012 10:27:29 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call pinctrl_request_gpio() in request callback, thus we need to call
pinctrl_free_gpio() in free callback.

Both mvebu_gpio_request() and mvebu_gpio_free() are not referenced outside of
this file, make them static.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/gpio/gpio-mvebu.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 325c3de..a515b92 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -168,12 +168,12 @@ static void __iomem *mvebu_gpioreg_level_mask(struct mvebu_gpio_chip *mvchip)
  * Functions implementing the gpio_chip methods
  */
 
-int mvebu_gpio_request(struct gpio_chip *chip, unsigned pin)
+static int mvebu_gpio_request(struct gpio_chip *chip, unsigned pin)
 {
 	return pinctrl_request_gpio(chip->base + pin);
 }
 
-void mvebu_gpio_free(struct gpio_chip *chip, unsigned pin)
+static void mvebu_gpio_free(struct gpio_chip *chip, unsigned pin)
 {
 	pinctrl_free_gpio(chip->base + pin);
 }
@@ -546,6 +546,7 @@ static int __devinit mvebu_gpio_probe(struct platform_device *pdev)
 	mvchip->chip.label = dev_name(&pdev->dev);
 	mvchip->chip.dev = &pdev->dev;
 	mvchip->chip.request = mvebu_gpio_request;
+	mvchip->chip.free = mvebu_gpio_free;
 	mvchip->chip.direction_input = mvebu_gpio_direction_input;
 	mvchip->chip.get = mvebu_gpio_get;
 	mvchip->chip.direction_output = mvebu_gpio_direction_output;
-- 
1.7.9.5



