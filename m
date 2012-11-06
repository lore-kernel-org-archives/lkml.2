Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab2KFPRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 10:17:23 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:51396 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930Ab2KFPRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 10:17:18 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/5] gpiolib: call pin removal in chip removal function
Date: Tue, 6 Nov 2012 16:17:01 +0100
Message-ID: <1352215021-30341-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This makes us call gpiochio_remove_pin_ranges() in the
gpiochip_remove() function, so we get rid of ranges when
freeing the chip.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpiolib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 10fc9c3..fd7280f 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1125,6 +1125,7 @@ int gpiochip_remove(struct gpio_chip *chip)
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
+	gpiochip_remove_pin_ranges(chip);
 	of_gpiochip_remove(chip);
 
 	for (id = chip->base; id < chip->base + chip->ngpio; id++) {
-- 
1.7.11.3

