Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab2LNQUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:20:08 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62587 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab2LNQT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:19:59 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org,
        Marcel Tunnissen <Marcel.Tuennissen@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/21] gpio: ab8500: Write argument value instead of hardwired 1
Date: Fri, 14 Dec 2012 16:19:25 +0000
Message-Id: <1355501979-1157-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Tunnissen <Marcel.Tuennissen@stericsson.com>

This fixes a bug in gpio_set_value(xxx, 0) for ab8500 GPIOs.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Marcel Tunnissen <Marcel.Tuennissen@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Tested-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/gpio/gpio-ab8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index b71bb72..d3bbcce 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -132,7 +132,7 @@ static void ab8500_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
 	struct ab8500_gpio *ab8500_gpio = to_ab8500_gpio(chip);
 	int ret;
 	/* Write the data */
-	ret = ab8500_gpio_set_bits(chip, AB8500_GPIO_OUT1_REG, offset, 1);
+	ret = ab8500_gpio_set_bits(chip, AB8500_GPIO_OUT1_REG, offset, val);
 	if (ret < 0)
 		dev_err(ab8500_gpio->dev, "%s write failed\n", __func__);
 }
-- 
1.7.9.5

