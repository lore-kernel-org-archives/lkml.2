Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab2GDQNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:13:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50407 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754683Ab2GDQNC (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Wed, 4 Jul 2012 12:13:02 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        stable@vger.kernel.org
Subject: [PATCH 3/4] gpiolib: wm8994: Pay attention to the value set when enabling as output
Date: Wed,  4 Jul 2012 17:12:57 +0100
Message-Id: <1341418378-26251-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1341418378-26251-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1341418378-26251-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not paying attention to the value being set is a bad thing because it
means that we'll not set the hardware up to reflect what was requested.
Not setting the hardware up to reflect what was requested means that the
caller won't get the results they wanted.
`
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Cc: stable@vger.kernel.org
---
 drivers/gpio/gpio-wm8994.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-wm8994.c b/drivers/gpio/gpio-wm8994.c
index f2b3d19..1c764e7 100644
--- a/drivers/gpio/gpio-wm8994.c
+++ b/drivers/gpio/gpio-wm8994.c
@@ -90,8 +90,11 @@ static int wm8994_gpio_direction_out(struct gpio_chip *chip,
 	struct wm8994_gpio *wm8994_gpio = to_wm8994_gpio(chip);
 	struct wm8994 *wm8994 = wm8994_gpio->wm8994;
 
+	if (value)
+		value = WM8994_GPN_LVL;
+
 	return wm8994_set_bits(wm8994, WM8994_GPIO_1 + offset,
-			       WM8994_GPN_DIR, 0);
+			       WM8994_GPN_DIR | WM8994_GPN_LVL, value);
 }
 
 static void wm8994_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
-- 
1.7.10

