Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab2KWIsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 03:48:22 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46845 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758061Ab2KWIsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 03:48:19 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: w.sang@pengutronix.de, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH RESEND 1/4] i2c: s3c2410: Remove unnecessary label err_noclk
Date: Fri, 23 Nov 2012 14:11:52 +0530
Message-Id: <1353660115-9710-2-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353660115-9710-1-git-send-email-tushar.behera@linaro.org>
References: <1353660115-9710-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

err_noclk label redirects to a simple return statement. Move the
return statement to the caller location and remove the label.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/i2c/busses/i2c-s3c2410.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 3e0335f..7522f40 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -945,8 +945,8 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 
 	i2c->pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!i2c->pdata) {
-		ret = -ENOMEM;
-		goto err_noclk;
+		dev_err(&pdev->dev, "no memory for platform data\n");
+		return -ENOMEM;
 	}
 
 	i2c->quirks = s3c24xx_get_device_quirks(pdev);
@@ -971,8 +971,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	i2c->clk = clk_get(&pdev->dev, "i2c");
 	if (IS_ERR(i2c->clk)) {
 		dev_err(&pdev->dev, "cannot get clock\n");
-		ret = -ENOENT;
-		goto err_noclk;
+		return -ENOENT;
 	}
 
 	dev_dbg(&pdev->dev, "clock source %p\n", i2c->clk);
@@ -1084,8 +1083,6 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
  err_clk:
 	clk_disable_unprepare(i2c->clk);
 	clk_put(i2c->clk);
-
- err_noclk:
 	return ret;
 }
 
-- 
1.7.4.1

