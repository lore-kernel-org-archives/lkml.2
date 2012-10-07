Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab2JGX3c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:29:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38620 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754614Ab2JGXXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:14 -0400
Message-Id: <20121007225840.805212327@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland Stigge <stigge@antcom.de>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [ 044/108] gpio-lpc32xx: Fix value handling of gpio_direction_output()
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Stigge <stigge@antcom.de>

commit b1268d3737c6316016026245eef276eda6b0a621 upstream.

For GPIOs of gpio-lpc32xx, gpio_direction_output() ignores the value argument
(initial value of output). This patch fixes this by setting the level
accordingly.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpio/gpio-lpc32xx.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpio/gpio-lpc32xx.c b/drivers/gpio/gpio-lpc32xx.c
index 8a420f1..ed94b4e 100644
--- a/drivers/gpio/gpio-lpc32xx.c
+++ b/drivers/gpio/gpio-lpc32xx.c
@@ -308,6 +308,7 @@ static int lpc32xx_gpio_dir_output_p012(struct gpio_chip *chip, unsigned pin,
 {
 	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
 
+	__set_gpio_level_p012(group, pin, value);
 	__set_gpio_dir_p012(group, pin, 0);
 
 	return 0;
@@ -318,6 +319,7 @@ static int lpc32xx_gpio_dir_output_p3(struct gpio_chip *chip, unsigned pin,
 {
 	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
 
+	__set_gpio_level_p3(group, pin, value);
 	__set_gpio_dir_p3(group, pin, 0);
 
 	return 0;
@@ -326,6 +328,9 @@ static int lpc32xx_gpio_dir_output_p3(struct gpio_chip *chip, unsigned pin,
 static int lpc32xx_gpio_dir_out_always(struct gpio_chip *chip, unsigned pin,
 	int value)
 {
+	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
+
+	__set_gpo_level_p3(group, pin, value);
 	return 0;
 }
 


