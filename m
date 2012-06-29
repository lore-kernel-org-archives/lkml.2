Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab2F2NcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 09:32:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61414 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab2F2NcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 09:32:21 -0400
Message-ID: <1340976735.4752.2.camel@phoenix>
Subject: [PATCH 3/4] pwm: Convert pwm-samsung to use devm_* APIs
From: Axel Lin <axel.lin@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Date: Fri, 29 Jun 2012 21:32:15 +0800
In-Reply-To: <1340976628.4752.0.camel@phoenix>
References: <1340976628.4752.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/pwm/pwm-samsung.c |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/pwm/pwm-samsung.c b/drivers/pwm/pwm-samsung.c
index c40c37e..35fa0e8 100644
--- a/drivers/pwm/pwm-samsung.c
+++ b/drivers/pwm/pwm-samsung.c
@@ -1,4 +1,4 @@
-/* arch/arm/plat-s3c/pwm.c
+/* drivers/pwm/pwm-samsung.c
  *
  * Copyright (c) 2007 Ben Dooks
  * Copyright (c) 2008 Simtec Electronics
@@ -215,7 +215,7 @@ static int s3c_pwm_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	s3c = kzalloc(sizeof(*s3c), GFP_KERNEL);
+	s3c = devm_kzalloc(&pdev->dev, sizeof(*s3c), GFP_KERNEL);
 	if (s3c == NULL) {
 		dev_err(dev, "failed to allocate pwm_device\n");
 		return -ENOMEM;
@@ -227,18 +227,16 @@ static int s3c_pwm_probe(struct platform_device *pdev)
 	s3c->chip.base = -1;
 	s3c->chip.npwm = 1;
 
-	s3c->clk = clk_get(dev, "pwm-tin");
+	s3c->clk = devm_clk_get(dev, "pwm-tin");
 	if (IS_ERR(s3c->clk)) {
 		dev_err(dev, "failed to get pwm tin clk\n");
-		ret = PTR_ERR(s3c->clk);
-		goto err_alloc;
+		return PTR_ERR(s3c->clk);
 	}
 
-	s3c->clk_div = clk_get(dev, "pwm-tdiv");
+	s3c->clk_div = devm_clk_get(dev, "pwm-tdiv");
 	if (IS_ERR(s3c->clk_div)) {
 		dev_err(dev, "failed to get pwm tdiv clk\n");
-		ret = PTR_ERR(s3c->clk_div);
-		goto err_clk_tin;
+		return PTR_ERR(s3c->clk_div);
 	}
 
 	clk_enable(s3c->clk);
@@ -272,13 +270,6 @@ static int s3c_pwm_probe(struct platform_device *pdev)
  err_clk_tdiv:
 	clk_disable(s3c->clk_div);
 	clk_disable(s3c->clk);
-	clk_put(s3c->clk_div);
-
- err_clk_tin:
-	clk_put(s3c->clk);
-
- err_alloc:
-	kfree(s3c);
 	return ret;
 }
 
@@ -293,9 +284,6 @@ static int __devexit s3c_pwm_remove(struct platform_device *pdev)
 
 	clk_disable(s3c->clk_div);
 	clk_disable(s3c->clk);
-	clk_put(s3c->clk_div);
-	clk_put(s3c->clk);
-	kfree(s3c);
 
 	return 0;
 }
-- 
1.7.9.5



