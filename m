Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab2JWHyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:54:12 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:58521 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751817Ab2JWHyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:54:10 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] pinctrl/nomadik: use zero as default irq_start
Date: Tue, 23 Oct 2012 09:53:49 +0200
Message-ID: <1350978829-12416-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The irqdomain semantics were supposed to be such that a linear
domain would be used if the passed first_irq was zero or
negative, but I got it wrong so only passing zero as first_irq
will work properly. Well, zero is NO_IRQ these days so let's
pass zero. The semantics of irqdomain_add_simple() will be
fixed in a separate patch.

Cc: Lee Jones <lee.jones@linaro.org>
Reported-by: Rikard Olsson <rikard.p.olsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index d1d3cb9..3834629 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1281,7 +1281,7 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 	struct clk *clk;
 	int secondary_irq;
 	void __iomem *base;
-	int irq_start = -1;
+	int irq_start = 0;
 	int irq;
 	int ret;
 
-- 
1.7.11.3

