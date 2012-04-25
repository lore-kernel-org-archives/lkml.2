Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab2DYCDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 22:03:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60432 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757933Ab2DYCDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 22:03:49 -0400
Message-ID: <1335319424.30909.4.camel@phoenix>
Subject: [PATCH 2/5] mfd: s5m-core: Convert to devm_regmap_init_i2c()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Sangbeom Kim <sbkim73@samsung.com>
Date: Wed, 25 Apr 2012 10:03:44 +0800
In-Reply-To: <1335319315.30909.2.camel@phoenix>
References: <1335319315.30909.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/s5m-core.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/s5m-core.c b/drivers/mfd/s5m-core.c
index 48949d9..dd17030 100644
--- a/drivers/mfd/s5m-core.c
+++ b/drivers/mfd/s5m-core.c
@@ -114,12 +114,12 @@ static int s5m87xx_i2c_probe(struct i2c_client *i2c,
 		s5m87xx->wakeup = pdata->wakeup;
 	}
 
-	s5m87xx->regmap = regmap_init_i2c(i2c, &s5m_regmap_config);
+	s5m87xx->regmap = devm_regmap_init_i2c(i2c, &s5m_regmap_config);
 	if (IS_ERR(s5m87xx->regmap)) {
 		ret = PTR_ERR(s5m87xx->regmap);
 		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
 			ret);
-		goto err;
+		return ret;
 	}
 
 	s5m87xx->rtc = i2c_new_dummy(i2c->adapter, RTC_I2C_ADDR);
@@ -159,7 +159,6 @@ err:
 	mfd_remove_devices(s5m87xx->dev);
 	s5m_irq_exit(s5m87xx);
 	i2c_unregister_device(s5m87xx->rtc);
-	regmap_exit(s5m87xx->regmap);
 	return ret;
 }
 
@@ -170,7 +169,6 @@ static int s5m87xx_i2c_remove(struct i2c_client *i2c)
 	mfd_remove_devices(s5m87xx->dev);
 	s5m_irq_exit(s5m87xx);
 	i2c_unregister_device(s5m87xx->rtc);
-	regmap_exit(s5m87xx->regmap);
 	return 0;
 }
 
-- 
1.7.5.4



