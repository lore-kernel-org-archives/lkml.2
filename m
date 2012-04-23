Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab2DWJO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 05:14:57 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:34546 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753598Ab2DWJOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 05:14:51 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Philippe LANGLAIS <philippe.langlais@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5/9] gpio/nomadik: use typesafe __io_address()
Date: Mon, 23 Apr 2012 11:14:42 +0200
Message-ID: <1335172482-27648-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

We were using a custom io_p2v() (physical-to-virtual) translation
macro, but with the advent of the cross-platform __io_address()
let us try to get rid of this. Inspired by a similar patch by
Jonas Aberg.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-nomadik.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-nomadik.c b/drivers/gpio/gpio-nomadik.c
index 7b45d88..edf9a95 100644
--- a/drivers/gpio/gpio-nomadik.c
+++ b/drivers/gpio/gpio-nomadik.c
@@ -1186,7 +1186,7 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 	 */
 	nmk_chip->bank = dev->id;
 	nmk_chip->clk = clk;
-	nmk_chip->addr = io_p2v(res->start);
+	nmk_chip->addr = __io_address(res->start);
 	nmk_chip->chip = nmk_gpio_template;
 	nmk_chip->parent_irq = irq;
 	nmk_chip->secondary_parent_irq = secondary_irq;
-- 
1.7.9.2

