Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab2LNQYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:24:08 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46880 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab2LNQT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:19:57 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bibek Basu <bibek.basu@stericsson.com>
Subject: [PATCH 06/21] gpio: ab8500: Add api to enable pulldown
Date: Fri, 14 Dec 2012 16:19:24 +0000
Message-Id: <1355501979-1157-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Bibek Basu <bibek.basu@stericsson.com>
Signed-off-by: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Tested-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/gpio/gpio-ab8500.c             |   17 +++++++++++++++++
 include/linux/mfd/abx500/ab8500-gpio.h |    3 +++
 2 files changed, 20 insertions(+)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index dd95cb3..b71bb72 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -507,6 +507,23 @@ static int __devexit ab8500_gpio_remove(struct platform_device *pdev)
 	return 0;
 }
 
+int ab8500_config_pulldown(struct device *dev,
+				enum ab8500_pin gpio, bool enable)
+{
+	u8 offset =  gpio - AB8500_PIN_GPIO1;
+	u8 pos = offset % 8;
+	u8 val = enable ? 0 : 1;
+	u8 reg = AB8500_GPIO_PUD1_REG + (offset / 8);
+	int ret;
+
+	ret = abx500_mask_and_set_register_interruptible(dev,
+				AB8500_MISC, reg, 1 << pos, val << pos);
+	if (ret < 0)
+		dev_err(dev, "%s write failed\n", __func__);
+	return ret;
+}
+EXPORT_SYMBOL(ab8500_config_pulldown);
+
 /*
  * ab8500_gpio_config_select()
  *
diff --git a/include/linux/mfd/abx500/ab8500-gpio.h b/include/linux/mfd/abx500/ab8500-gpio.h
index 94e85ca..48325db 100644
--- a/include/linux/mfd/abx500/ab8500-gpio.h
+++ b/include/linux/mfd/abx500/ab8500-gpio.h
@@ -67,6 +67,9 @@ enum ab8500_pin {
 	AB8500_PIN_GPIO42,
 };
 
+int ab8500_config_pulldown(struct device *dev,
+				enum ab8500_pin gpio, bool enable);
+
 int ab8500_gpio_config_select(struct device *dev,
 				enum ab8500_pin gpio, bool gpio_select);
 
-- 
1.7.9.5

