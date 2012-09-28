Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab2I1Uj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:39:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40118 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759436Ab2I1Ujy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:39:54 -0400
X-Sasl-enc: UljK9abG3JcwdJW5zFbVFdWV8iSZPtPH8aWxMYBn+T1T 1348864793
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Roland Stigge <stigge@antcom.de>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [ 214/218] gpio-lpc32xx: Fix value handling of gpio_direction_output()
Date: Fri, 28 Sep 2012 13:17:11 -0700
Message-Id: <20120928201526.144516693@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -304,6 +304,7 @@ static int lpc32xx_gpio_dir_output_p012(
 {
 	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
 
+	__set_gpio_level_p012(group, pin, value);
 	__set_gpio_dir_p012(group, pin, 0);
 
 	return 0;
@@ -314,6 +315,7 @@ static int lpc32xx_gpio_dir_output_p3(st
 {
 	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
 
+	__set_gpio_level_p3(group, pin, value);
 	__set_gpio_dir_p3(group, pin, 0);
 
 	return 0;
@@ -322,6 +324,9 @@ static int lpc32xx_gpio_dir_output_p3(st
 static int lpc32xx_gpio_dir_out_always(struct gpio_chip *chip, unsigned pin,
 	int value)
 {
+	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
+
+	__set_gpo_level_p3(group, pin, value);
 	return 0;
 }
 


