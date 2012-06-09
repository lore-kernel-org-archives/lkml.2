Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab2FIDIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 23:08:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45622 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641Ab2FIDIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 23:08:11 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        stable@vger.kernel.org
Date: Sat,  9 Jun 2012 11:07:56 +0800
Message-Id: <1339211276-31626-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: [PATCH] gpiolib: wm8994: Pay attention to the value set when enabling as output
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not paying attention to the value being set is a bad thing because it
means that we'll not set the hardware up to reflect what was requested.
Not setting the hardware up to reflect what was requested means that the
caller won't get the results they wanted.
`
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
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

