Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab2LNQYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:24:41 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:63808 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab2LNQTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:19:54 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Bibek Basu <bibek.basu@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Subject: [PATCH 04/21] gpio: ab8500: Read register corrected in get_value api
Date: Fri, 14 Dec 2012 16:19:22 +0000
Message-Id: <1355501979-1157-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bibek Basu <bibek.basu@stericsson.com>

Read register is corrected from "AB8500_GPIO_OUT1_REG" to
"AB8500_GPIO_IN1_REG" in get_value api

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Bibek Basu <bibek.basu@stericsson.com>
Signed-off-by: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Tested-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/gpio/gpio-ab8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index b7d4416..77fe1d7 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -115,7 +115,7 @@ static int ab8500_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
 	struct ab8500_gpio *ab8500_gpio = to_ab8500_gpio(chip);
 	u8 mask = 1 << (offset % 8);
-	u8 reg = AB8500_GPIO_OUT1_REG + (offset / 8);
+	u8 reg = AB8500_GPIO_IN1_REG + (offset / 8);
 	int ret;
 	u8 data;
 	ret = abx500_get_register_interruptible(ab8500_gpio->dev, AB8500_MISC,
-- 
1.7.9.5

