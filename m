Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab2JWJrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:47:14 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:51009 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753027Ab2JWJrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:47:11 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] pinctrl/nomadik: pass DT node to the irqdomain
Date: Tue, 23 Oct 2012 11:46:59 +0200
Message-ID: <1350985619-17408-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

When creating the simple irqdomain, pass the DT node pointer along,
as is apropriate.

Cc: Lee Jones <lee.jones@linaro.org>
Reported-by: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 8bfbad6..cf82d9c 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1387,7 +1387,7 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 
 	if (!np)
 		irq_start = NOMADIK_GPIO_TO_IRQ(pdata->first_gpio);
-	nmk_chip->domain = irq_domain_add_simple(NULL,
+	nmk_chip->domain = irq_domain_add_simple(np,
 				NMK_GPIO_PER_CHIP, irq_start,
 				&nmk_gpio_irq_simple_ops, nmk_chip);
 	if (!nmk_chip->domain) {
-- 
1.7.11.3

