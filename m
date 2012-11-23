Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab2KWGFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 01:05:47 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:55035 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab2KWGFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 01:05:45 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: w.sang@pengutronix.de, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH 3/7] i2c: s3c2410: Convert to use devm_request_mem_region()
Date: Fri, 23 Nov 2012 11:29:09 +0530
Message-Id: <1353650353-17576-4-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353650353-17576-1-git-send-email-tushar.behera@linaro.org>
References: <1353650353-17576-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/i2c/busses/i2c-s3c2410.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 019c3d7..a274ef7 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -987,8 +987,8 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
-	i2c->ioarea = request_mem_region(res->start, resource_size(res),
-					 pdev->name);
+	i2c->ioarea = devm_request_mem_region(&pdev->dev, res->start,
+					      resource_size(res), pdev->name);
 
 	if (i2c->ioarea == NULL) {
 		dev_err(&pdev->dev, "cannot request IO\n");
@@ -1001,7 +1001,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	if (i2c->regs == NULL) {
 		dev_err(&pdev->dev, "cannot map IO\n");
 		ret = -ENXIO;
-		goto err_ioarea;
+		goto err_clk;
 	}
 
 	dev_dbg(&pdev->dev, "registers %p (%p, %p)\n",
@@ -1076,10 +1076,6 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
  err_iomap:
 	iounmap(i2c->regs);
 
- err_ioarea:
-	release_resource(i2c->ioarea);
-	kfree(i2c->ioarea);
-
  err_clk:
 	clk_disable_unprepare(i2c->clk);
 	return ret;
@@ -1106,9 +1102,7 @@ static int s3c24xx_i2c_remove(struct platform_device *pdev)
 
 	iounmap(i2c->regs);
 
-	release_resource(i2c->ioarea);
 	s3c24xx_i2c_dt_gpio_free(i2c);
-	kfree(i2c->ioarea);
 
 	return 0;
 }
-- 
1.7.4.1

