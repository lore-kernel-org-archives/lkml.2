Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab0FXLON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 07:14:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52558 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab0FXLOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 07:14:11 -0400
From: Luotao Fu <l.fu@pengutronix.de>
To: Rabin VINCENT <rabin.vincent@stericsson.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH 1/6] gpio/stmpe-gpio: set GPIO alternate function while requesting
Date: Thu, 24 Jun 2010 13:13:36 +0200
Message-Id: <1277378021-16802-2-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100622135635.GA30720@bnru02.bnr.st.com>
References: <20100622135635.GA30720@bnru02.bnr.st.com>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add reuqest hook to the gpio chip, so that we can make sure that the GPIO pin is
setted to the correct GPIO alternate function after we have requested the GPIO
pin.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
 drivers/gpio/stmpe-gpio.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/stmpe-gpio.c b/drivers/gpio/stmpe-gpio.c
index bd49a3a..a4de271 100644
--- a/drivers/gpio/stmpe-gpio.c
+++ b/drivers/gpio/stmpe-gpio.c
@@ -98,6 +98,14 @@ static int stmpe_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 	return stmpe_gpio->irq_base + offset;
 }
 
+static int stmpe_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(chip);
+	struct stmpe *stmpe = stmpe_gpio->stmpe;
+
+	return stmpe_set_altfunc(stmpe, 1 << offset, STMPE_BLOCK_GPIO);
+}
+
 static struct gpio_chip template_chip = {
 	.label			= "stmpe",
 	.owner			= THIS_MODULE,
@@ -106,6 +114,7 @@ static struct gpio_chip template_chip = {
 	.direction_output	= stmpe_gpio_direction_output,
 	.set			= stmpe_gpio_set,
 	.to_irq			= stmpe_gpio_to_irq,
+	.request		= stmpe_gpio_request,
 	.can_sleep		= 1,
 };
 
-- 
1.7.1

