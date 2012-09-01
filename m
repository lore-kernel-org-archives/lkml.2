Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab2IAGLb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 02:11:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65094 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab2IAGLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 02:11:30 -0400
Message-ID: <1346479882.3272.1.camel@phoenix>
Subject: [PATCH] gpio: rdc321x: Prevent removal of modules exporting active
 GPIOs
From: Axel Lin <axel.lin@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Florian Fainelli <florian@openwrt.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Date: Sat, 01 Sep 2012 14:11:22 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver can be built as a module, set the missing owner field of
struct gpio_chip to prevent removal of modules exporting active GPIOs.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-rdc321x.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-rdc321x.c b/drivers/gpio/gpio-rdc321x.c
index e97016a..b62d443 100644
--- a/drivers/gpio/gpio-rdc321x.c
+++ b/drivers/gpio/gpio-rdc321x.c
@@ -170,6 +170,7 @@ static int __devinit rdc321x_gpio_probe(struct platform_device *pdev)
 	rdc321x_gpio_dev->reg2_data_base = r->start + 0x4;
 
 	rdc321x_gpio_dev->chip.label = "rdc321x-gpio";
+	rdc321x_gpio_dev->chip.owner = THIS_MODULE;
 	rdc321x_gpio_dev->chip.direction_input = rdc_gpio_direction_input;
 	rdc321x_gpio_dev->chip.direction_output = rdc_gpio_config;
 	rdc321x_gpio_dev->chip.get = rdc_gpio_get_value;
-- 
1.7.9.5



