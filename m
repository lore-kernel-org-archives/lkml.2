Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab0FXLOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 07:14:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52565 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab0FXLOL (ORCPT
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
Subject: [PATCH 2/6] gpio/stmpe-gpio: fix set direction input
Date: Thu, 24 Jun 2010 13:13:37 +0200
Message-Id: <1277378021-16802-3-git-send-email-l.fu@pengutronix.de>
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

to set an GPIO pin to input, the corresponding bit in GPDR needs to be cleared
instead of set. fixed with this patch.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
 drivers/gpio/stmpe-gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/stmpe-gpio.c b/drivers/gpio/stmpe-gpio.c
index a4de271..4e1f1b9 100644
--- a/drivers/gpio/stmpe-gpio.c
+++ b/drivers/gpio/stmpe-gpio.c
@@ -88,7 +88,7 @@ static int stmpe_gpio_direction_input(struct gpio_chip *chip,
 	u8 reg = stmpe->regs[STMPE_IDX_GPDR_LSB] - (offset / 8);
 	u8 mask = 1 << (offset % 8);
 
-	return stmpe_set_bits(stmpe, reg, mask, mask);
+	return stmpe_set_bits(stmpe, reg, mask, 0);
 }
 
 static int stmpe_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
-- 
1.7.1

