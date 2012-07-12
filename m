Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161894Ab2GLXbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:31:45 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:63475 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161808Ab2GLWk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:40:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [ 094/187] gpiolib: wm8994: Pay attention to the value set when enabling as output
Date: Thu, 12 Jul 2012 15:34:10 -0700
Message-Id: <20120712191531.121298219@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 8cd578b6e28693f357867a77598a88ef3deb6b39 upstream.

Not paying attention to the value being set is a bad thing because it
means that we'll not set the hardware up to reflect what was requested.
Not setting the hardware up to reflect what was requested means that the
caller won't get the results they wanted.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-wm8994.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpio-wm8994.c
+++ b/drivers/gpio/gpio-wm8994.c
@@ -89,8 +89,11 @@ static int wm8994_gpio_direction_out(str
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


