Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab2GaGd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:33:26 -0400
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:59651 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752239Ab2GaGdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:33:24 -0400
From: Chao Xie <xiechao.mail@gmail.com>
To: haojian.zhuang@gmail.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Chao Xie <chao.xie@marvell.com>, Chao Xie <xiechao.mail@gmail.com>
Subject: [PATCH] i2c: pxa: fix the clock APIs
Date: Tue, 31 Jul 2012 14:33:04 +0800
Message-Id: <1343716384-6609-1-git-send-email-xiechao.mail@gmail.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 31 Jul 2012 06:32:57.0707 (UTC) FILETIME=[52F713B0:01CD6EE6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Xie <chao.xie@marvell.com>

Signed-off-by: Chao Xie <xiechao.mail@gmail.com>
---
 drivers/i2c/busses/i2c-pxa.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index a997c7d..0a57f3e 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -44,8 +44,8 @@
 #ifndef CONFIG_HAVE_CLK
 #define clk_get(dev, id)	NULL
 #define clk_put(clk)		do { } while (0)
-#define clk_disable(clk)	do { } while (0)
-#define clk_enable(clk)		do { } while (0)
+#define clk_disable_unprepare(clk)	do { } while (0)
+#define clk_prepare_enable(clk)		do { } while (0)
 #endif
 
 struct pxa_reg_layout {
@@ -1169,7 +1169,7 @@ static int i2c_pxa_probe(struct platform_device *dev)
 		i2c->adap.class = plat->class;
 	}
 
-	clk_enable(i2c->clk);
+	clk_prepare_enable(i2c->clk);
 
 	if (i2c->use_pio) {
 		i2c->adap.algo = &i2c_pxa_pio_algorithm;
@@ -1211,7 +1211,7 @@ eadapt:
 	if (!i2c->use_pio)
 		free_irq(irq, i2c);
 ereqirq:
-	clk_disable(i2c->clk);
+	clk_disable_unprepare(i2c->clk);
 	iounmap(i2c->reg_base);
 eremap:
 	clk_put(i2c->clk);
@@ -1232,7 +1232,7 @@ static int __exit i2c_pxa_remove(struct platform_device *dev)
 	if (!i2c->use_pio)
 		free_irq(i2c->irq, i2c);
 
-	clk_disable(i2c->clk);
+	clk_disable_unprepare(i2c->clk);
 	clk_put(i2c->clk);
 
 	iounmap(i2c->reg_base);
@@ -1248,7 +1248,7 @@ static int i2c_pxa_suspend_noirq(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct pxa_i2c *i2c = platform_get_drvdata(pdev);
 
-	clk_disable(i2c->clk);
+	clk_disable_unprepare(i2c->clk);
 
 	return 0;
 }
@@ -1258,7 +1258,7 @@ static int i2c_pxa_resume_noirq(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct pxa_i2c *i2c = platform_get_drvdata(pdev);
 
-	clk_enable(i2c->clk);
+	clk_prepare_enable(i2c->clk);
 	i2c_pxa_reset(i2c);
 
 	return 0;
-- 
1.7.0.4

