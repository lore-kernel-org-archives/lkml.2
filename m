Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab2GWBn5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:43:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54496 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753628Ab2GWBns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:48 -0400
Message-Id: <20120723010655.616884499@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [ 027/108] gpiolib: wm8994: Pay attention to the value set when enabling as
 output
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 8cd578b6e28693f357867a77598a88ef3deb6b39 upstream.

Not paying attention to the value being set is a bad thing because it
means that we'll not set the hardware up to reflect what was requested.
Not setting the hardware up to reflect what was requested means that the
caller won't get the results they wanted.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpio/gpio-wm8994.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-wm8994.c b/drivers/gpio/gpio-wm8994.c
index 92ea535..aa61ad2 100644
--- a/drivers/gpio/gpio-wm8994.c
+++ b/drivers/gpio/gpio-wm8994.c
@@ -89,8 +89,11 @@ static int wm8994_gpio_direction_out(struct gpio_chip *chip,
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


