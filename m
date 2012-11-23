Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab2KWGFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 01:05:42 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46930 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463Ab2KWGFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 01:05:40 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: w.sang@pengutronix.de, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH 2/7] i2c: s3c2410: Convert to use devm_clk_get()
Date: Fri, 23 Nov 2012 11:29:08 +0530
Message-Id: <1353650353-17576-3-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353650353-17576-1-git-send-email-tushar.behera@linaro.org>
References: <1353650353-17576-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/i2c/busses/i2c-s3c2410.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 7522f40..019c3d7 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -968,7 +968,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	/* find the clock and enable it */
 
 	i2c->dev = &pdev->dev;
-	i2c->clk = clk_get(&pdev->dev, "i2c");
+	i2c->clk = devm_clk_get(&pdev->dev, "i2c");
 	if (IS_ERR(i2c->clk)) {
 		dev_err(&pdev->dev, "cannot get clock\n");
 		return -ENOENT;
@@ -1082,7 +1082,6 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 
  err_clk:
 	clk_disable_unprepare(i2c->clk);
-	clk_put(i2c->clk);
 	return ret;
 }
 
@@ -1104,7 +1103,6 @@ static int s3c24xx_i2c_remove(struct platform_device *pdev)
 	free_irq(i2c->irq, i2c);
 
 	clk_disable_unprepare(i2c->clk);
-	clk_put(i2c->clk);
 
 	iounmap(i2c->regs);
 
-- 
1.7.4.1

