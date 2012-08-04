Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab2HDQwF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 12:52:05 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:37654
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753729Ab2HDQvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 12:51:00 -0400
X-IronPort-AV: E=Sophos;i="4.77,713,1336341600"; 
   d="scan'208";a="152439852"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] drivers/pinctrl/pinctrl-nomadik.c: drop devm_kfree of devm_kzalloc'd data
Date: Sat,  4 Aug 2012 18:50:47 +0200
Message-Id: <1344099049-15212-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

devm_kfree should not have to be explicitly used.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,d;
@@

x = devm_kzalloc(...)
...
?-devm_kfree(d,x);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/pinctrl/pinctrl-nomadik.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 53b0d49..ec6ac50 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1731,7 +1731,6 @@ static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
 	for (i = 0; i < npct->soc->gpio_num_ranges; i++) {
 		if (!nmk_gpio_chips[i]) {
 			dev_warn(&pdev->dev, "GPIO chip %d not registered yet\n", i);
-			devm_kfree(&pdev->dev, npct);
 			return -EPROBE_DEFER;
 		}
 		npct->soc->gpio_ranges[i].gc = &nmk_gpio_chips[i]->chip;

