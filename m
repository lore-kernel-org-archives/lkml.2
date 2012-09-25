Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab2IYHyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 03:54:15 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:55807 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753468Ab2IYHyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 03:54:13 -0400
From: Roland Stigge <stigge@antcom.de>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RESEND] gpio-lpc32xx: Fix value handling of gpio_direction_output()
Date: Tue, 25 Sep 2012 09:53:54 +0200
Message-Id: <1348559634-15337-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For GPIOs of gpio-lpc32xx, gpio_direction_output() ignores the value argument
(initial value of output). This patch fixes this by setting the level
accordingly.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

---
Applies to v3.6-rc7

 drivers/gpio/gpio-lpc32xx.c |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-2.6.orig/drivers/gpio/gpio-lpc32xx.c
+++ linux-2.6/drivers/gpio/gpio-lpc32xx.c
@@ -308,6 +308,7 @@ static int lpc32xx_gpio_dir_output_p012(
 {
 	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
 
+	__set_gpio_level_p012(group, pin, value);
 	__set_gpio_dir_p012(group, pin, 0);
 
 	return 0;
@@ -318,6 +319,7 @@ static int lpc32xx_gpio_dir_output_p3(st
 {
 	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
 
+	__set_gpio_level_p3(group, pin, value);
 	__set_gpio_dir_p3(group, pin, 0);
 
 	return 0;
@@ -326,6 +328,9 @@ static int lpc32xx_gpio_dir_output_p3(st
 static int lpc32xx_gpio_dir_out_always(struct gpio_chip *chip, unsigned pin,
 	int value)
 {
+	struct lpc32xx_gpio_chip *group = to_lpc32xx_gpio(chip);
+
+	__set_gpo_level_p3(group, pin, value);
 	return 0;
 }
 
