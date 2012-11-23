Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909Ab2KWGGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 01:06:13 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56263 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884Ab2KWGGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 01:06:00 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: w.sang@pengutronix.de, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH 7/7] i2c: s3c2410: Remove err_cpufreq label
Date: Fri, 23 Nov 2012 11:29:13 +0530
Message-Id: <1353650353-17576-8-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353650353-17576-1-git-send-email-tushar.behera@linaro.org>
References: <1353650353-17576-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

err_cpufreq label is now used only once. It can be removed and related
code can be moved to the caller location.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/i2c/busses/i2c-s3c2410.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 707efaf..c934ec8 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1053,7 +1053,8 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	ret = i2c_add_numbered_adapter(&i2c->adap);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to add bus to i2c core\n");
-		goto err_cpufreq;
+		s3c24xx_i2c_deregister_cpufreq(i2c);
+		return ret;
 	}
 
 	of_i2c_register_devices(&i2c->adap);
@@ -1064,10 +1065,6 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 
 	dev_info(&pdev->dev, "%s: S3C I2C adapter\n", dev_name(&i2c->adap.dev));
 	return 0;
-
- err_cpufreq:
-	s3c24xx_i2c_deregister_cpufreq(i2c);
-	return ret;
 }
 
 /* s3c24xx_i2c_remove
-- 
1.7.4.1

