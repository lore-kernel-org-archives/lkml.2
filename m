Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030901Ab2I1TIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:08:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030834Ab2I1THC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:07:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Roland Stigge <stigge@antcom.de>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [ 258/262] gpio-lpc32xx: Fix value handling of gpio_direction_output()
Date: Fri, 28 Sep 2012 11:53:07 -0700
Message-Id: <20120928183028.988943380@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Stigge <stigge@antcom.de>

commit b1268d3737c6316016026245eef276eda6b0a621 upstream.

For GPIOs of gpio-lpc32xx, gpio_direction_output() ignores the value argument
(initial value of output). This patch fixes this by setting the level
accordingly.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-lpc32xx.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpio/gpio-lpc32xx.c
+++ b/drivers/gpio/gpio-lpc32xx.c
@@ -307,6 +307,7 @@ static int lpc32xx_gpio_dir_output_p012(
 {
 	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
 
+	__set_gpio_level_p012(group, pin, value);
 	__set_gpio_dir_p012(group, pin, 0);
 
 	return 0;
@@ -317,6 +318,7 @@ static int lpc32xx_gpio_dir_output_p3(st
 {
 	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
 
+	__set_gpio_level_p3(group, pin, value);
 	__set_gpio_dir_p3(group, pin, 0);
 
 	return 0;
@@ -325,6 +327,9 @@ static int lpc32xx_gpio_dir_output_p3(st
 static int lpc32xx_gpio_dir_out_always(struct gpio_chip *chip, unsigned pin,
 	int value)
 {
+	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
+
+	__set_gpo_level_p3(group, pin, value);
 	return 0;
 }
 


