Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab2LNQUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:20:22 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64409 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285Ab2LNQUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:20:15 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Yang QU <yang.qu@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 18/21] gpio: ab8500: Fix parameter uninitialized warning for ab8540
Date: Fri, 14 Dec 2012 16:19:36 +0000
Message-Id: <1355501979-1157-19-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang QU <yang.qu@stericsson.com>

Missing initial value in ab8540 gpio configuration function. So
initialize it and fix this warning.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Yang QU <yang.qu@stericsson.com>
Reviewed-by: Rabin VINCENT <rabin.vincent@stericsson.com>
---
 drivers/gpio/gpio-ab8500.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index b4f631a..833d4c2 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -673,6 +673,8 @@ int ab8540_gpio_config_vinsel(struct device *dev,
 		goto out;
 	}
 
+	pos = (gpio - AB8500_PIN_GPIO(51)) << 1;
+
 	ret = abx500_mask_and_set_register_interruptible(dev,
 			AB8500_MISC, AB8540_GPIO_VINSEL_REG,
 			AB8540_GPIO_VINSEL_MASK << pos, val << pos);
-- 
1.7.9.5

