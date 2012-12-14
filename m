Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab2LNQT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:19:58 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51922 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab2LNQT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:19:56 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bibek Basu <bibek.basu@stericsson.com>
Subject: [PATCH 05/21] gpio: ab8500: Allow direction and pullups configuration
Date: Fri, 14 Dec 2012 16:19:23 +0000
Message-Id: <1355501979-1157-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>

This patch extends the the platform data to include gpio direction and pullups
configurations. These configurations are applied during probe().

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Bibek Basu <bibek.basu@stericsson.com>
Signed-off-by: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Tested-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/gpio/gpio-ab8500.c             |   12 ++++++++++++
 include/linux/mfd/abx500/ab8500-gpio.h |    2 ++
 2 files changed, 14 insertions(+)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index 77fe1d7..dd95cb3 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -445,6 +445,18 @@ static int __devinit ab8500_gpio_probe(struct platform_device *pdev)
 				pdata->config_reg[i]);
 		if (ret < 0)
 			goto out_free;
+
+		ret = abx500_set_register_interruptible(ab8500_gpio->dev,
+				AB8500_MISC, i + AB8500_GPIO_DIR1_REG,
+				pdata->config_direction[i]);
+		if (ret < 0)
+			goto out_free;
+
+		ret = abx500_set_register_interruptible(ab8500_gpio->dev,
+				AB8500_MISC, i + AB8500_GPIO_PUD1_REG,
+				pdata->config_pullups[i]);
+		if (ret < 0)
+			goto out_free;
 	}
 	ret = abx500_set_register_interruptible(ab8500_gpio->dev, AB8500_MISC,
 				AB8500_GPIO_ALTFUN_REG,
diff --git a/include/linux/mfd/abx500/ab8500-gpio.h b/include/linux/mfd/abx500/ab8500-gpio.h
index 5caa615..94e85ca 100644
--- a/include/linux/mfd/abx500/ab8500-gpio.h
+++ b/include/linux/mfd/abx500/ab8500-gpio.h
@@ -18,6 +18,8 @@ struct ab8500_gpio_platform_data {
 	int gpio_base;
 	u32 irq_base;
 	u8  config_reg[8];
+	u8  config_direction[6];
+	u8  config_pullups[6];
 };
 
 enum ab8500_pin {
-- 
1.7.9.5

