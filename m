Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab1JYMrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 08:47:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48997 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932198Ab1JYMrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 08:47:48 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] mfd: Convert wm831x core driver to devm_kzalloc()
Date: Tue, 25 Oct 2011 14:47:40 +0200
Message-Id: <1319546861-7620-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c |    2 --
 drivers/mfd/wm831x-i2c.c  |    3 +--
 drivers/mfd/wm831x-spi.c  |    3 +--
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 0a2b8d4..3b76189 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1875,7 +1875,6 @@ err_irq:
 err_regmap:
 	mfd_remove_devices(wm831x->dev);
 	regmap_exit(wm831x->regmap);
-	kfree(wm831x);
 	return ret;
 }
 
@@ -1887,7 +1886,6 @@ void wm831x_device_exit(struct wm831x *wm831x)
 		free_irq(wm831x->irq_base + WM831X_IRQ_AUXADC_DATA, wm831x);
 	wm831x_irq_exit(wm831x);
 	regmap_exit(wm831x->regmap);
-	kfree(wm831x);
 }
 
 int wm831x_device_suspend(struct wm831x *wm831x)
diff --git a/drivers/mfd/wm831x-i2c.c b/drivers/mfd/wm831x-i2c.c
index ac8da1d..cb15609 100644
--- a/drivers/mfd/wm831x-i2c.c
+++ b/drivers/mfd/wm831x-i2c.c
@@ -30,7 +30,7 @@ static int wm831x_i2c_probe(struct i2c_client *i2c,
 	struct wm831x *wm831x;
 	int ret;
 
-	wm831x = kzalloc(sizeof(struct wm831x), GFP_KERNEL);
+	wm831x = devm_kzalloc(&i2c->dev, sizeof(struct wm831x), GFP_KERNEL);
 	if (wm831x == NULL)
 		return -ENOMEM;
 
@@ -42,7 +42,6 @@ static int wm831x_i2c_probe(struct i2c_client *i2c,
 		ret = PTR_ERR(wm831x->regmap);
 		dev_err(wm831x->dev, "Failed to allocate register map: %d\n",
 			ret);
-		kfree(wm831x);
 		return ret;
 	}
 
diff --git a/drivers/mfd/wm831x-spi.c b/drivers/mfd/wm831x-spi.c
index 8d6a9a9..a43cba3 100644
--- a/drivers/mfd/wm831x-spi.c
+++ b/drivers/mfd/wm831x-spi.c
@@ -30,7 +30,7 @@ static int __devinit wm831x_spi_probe(struct spi_device *spi)
 
 	type = (enum wm831x_parent)id->driver_data;
 
-	wm831x = kzalloc(sizeof(struct wm831x), GFP_KERNEL);
+	wm831x = devm_kzalloc(&spi->dev, sizeof(struct wm831x), GFP_KERNEL);
 	if (wm831x == NULL)
 		return -ENOMEM;
 
@@ -45,7 +45,6 @@ static int __devinit wm831x_spi_probe(struct spi_device *spi)
 		ret = PTR_ERR(wm831x->regmap);
 		dev_err(wm831x->dev, "Failed to allocate register map: %d\n",
 			ret);
-		kfree(wm831x);
 		return ret;
 	}
 
-- 
1.7.6.3

