Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab2JGOBX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 10:01:23 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:50119 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2JGOBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 10:01:16 -0400
MIME-Version: 1.0
Date: Sun, 7 Oct 2012 22:01:15 +0800
Message-ID: <CAPgLHd8F99f5LVS-wNekKA+a1369RfqCa-w_jHGV-_Wueg_cTQ@mail.gmail.com>
Subject: [PATCH] pinctrl: fix return value in bcm2835_pinctrl_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: swarren@wwwdotorg.org, linus.walleij@linaro.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linux-rpi-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function pinctrl_register() returns
NULL not ERR_PTR(). The PTR_ERR() in the return value
should be replaced with error no.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/pinctrl/pinctrl-bcm2835.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-bcm2835.c b/drivers/pinctrl/pinctrl-bcm2835.c
index a4adee6..1f9a878 100644
--- a/drivers/pinctrl/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/pinctrl-bcm2835.c
@@ -1032,7 +1032,7 @@ static int __devinit bcm2835_pinctrl_probe(struct platform_device *pdev)
 	pc->pctl_dev = pinctrl_register(&bcm2835_pinctrl_desc, dev, pc);
 	if (!pc->pctl_dev) {
 		gpiochip_remove(&pc->gpio_chip);
-		return PTR_ERR(pc->pctl_dev);
+		return -EINVAL;
 	}
 
 	pc->gpio_range = bcm2835_pinctrl_gpio_range;


