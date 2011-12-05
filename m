Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab1LELNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:13:21 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46239 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab1LELNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:13:19 -0500
Message-ID: <1323083592.6763.5.camel@phoenix>
Subject: [PATCH] Input: zylonite-wm97xx - replace IRQ_GPIO() with
 gpio_to_irq()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Date: Mon, 05 Dec 2011 19:13:12 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 6384fd "ARM: pxa: rename IRQ_GPIO to PXA_GPIO_TO_IRQ",
I got below buid errors due to implicit declaration of function 'IRQ_GPIO'.

Use common gpio_to_irq() to replace machine dependant macro IRQ_GPIO().

  CC      drivers/input/touchscreen/zylonite-wm97xx.o
drivers/input/touchscreen/zylonite-wm97xx.c: In function 'zylonite_wm97xx_probe':
drivers/input/touchscreen/zylonite-wm97xx.c:195: error: implicit declaration of function 'IRQ_GPIO'
make[3]: *** [drivers/input/touchscreen/zylonite-wm97xx.o] Error 1
make[2]: *** [drivers/input/touchscreen] Error 2
make[1]: *** [drivers/input] Error 2
make: *** [drivers] Error 2

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
I got the build error in linux-next tree,
thus this patch is against linux-next (20111205).

Axel
 drivers/input/touchscreen/zylonite-wm97xx.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/zylonite-wm97xx.c b/drivers/input/touchscreen/zylonite-wm97xx.c
index add6e3b..bf0869a7 100644
--- a/drivers/input/touchscreen/zylonite-wm97xx.c
+++ b/drivers/input/touchscreen/zylonite-wm97xx.c
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/gpio.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -192,8 +193,8 @@ static int zylonite_wm97xx_probe(struct platform_device *pdev)
 	else
 		gpio_touch_irq = mfp_to_gpio(MFP_PIN_GPIO26);
 
-	wm->pen_irq = IRQ_GPIO(gpio_touch_irq);
-	irq_set_irq_type(IRQ_GPIO(gpio_touch_irq), IRQ_TYPE_EDGE_BOTH);
+	wm->pen_irq = gpio_to_irq(gpio_touch_irq);
+	irq_set_irq_type(wm->pen_irq, IRQ_TYPE_EDGE_BOTH);
 
 	wm97xx_config_gpio(wm, WM97XX_GPIO_13, WM97XX_GPIO_IN,
 			   WM97XX_GPIO_POL_HIGH,
-- 
1.7.5.4



