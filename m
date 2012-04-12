Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965881Ab2DLSpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:45:32 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43812 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239Ab2DLSpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:45:21 -0400
Date: Thu, 12 Apr 2012 20:45:27 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 08/13] s5p-tv: Add initial DT-support for HDMIPHY
In-reply-to: <1334256332-29867-1-git-send-email-k.lewandowsk@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, thomas.abraham@linaro.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, olof@lixom.net, kgene.kim@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Message-id: <1334256332-29867-9-git-send-email-k.lewandowsk@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.9.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334256332-29867-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it possible to instantiate driver from device tree description.

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 .../devicetree/bindings/i2c/trivial-devices.txt    |    1 +
 drivers/media/video/s5p-tv/hdmiphy_drv.c           |   10 ++++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
index 1a85f98..3087bc4 100644
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
+++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -51,6 +51,7 @@ plx,pex8648		48-Lane, 12-Port PCI Express Gen 2 (5.0 GT/s) Switch
 ramtron,24c64		i2c serial eeprom  (24cxx)
 ricoh,rs5c372a		I2C bus SERIAL INTERFACE REAL-TIME CLOCK IC
 samsung,24ad0xd1	S524AD0XF1 (128K/256K-bit Serial EEPROM for Low Power)
+samsung,s5pv210-hdmiphy PLL-based clock generator for HDMI PHY found on s5pv210+ SoCs
 st-micro,24c256		i2c serial eeprom  (24cxx)
 stm,m41t00		Serial Access TIMEKEEPER
 stm,m41t62		Serial real-time clock (RTC) with alarm
diff --git a/drivers/media/video/s5p-tv/hdmiphy_drv.c b/drivers/media/video/s5p-tv/hdmiphy_drv.c
index 0afef77..3fcac4f 100644
--- a/drivers/media/video/s5p-tv/hdmiphy_drv.c
+++ b/drivers/media/video/s5p-tv/hdmiphy_drv.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/err.h>
+#include <linux/of.h>
 
 #include <media/v4l2-subdev.h>
 
@@ -165,10 +166,19 @@ static const struct i2c_device_id hdmiphy_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, hdmiphy_id);
 
+#ifdef CONFIG_OF
+static struct of_device_id hdmiphy_dt_match[] = {
+	{ .compatible = "samsung,s5pv210-hdmiphy" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, hdmiphy_dt_match);
+#endif
+
 static struct i2c_driver hdmiphy_driver = {
 	.driver = {
 		.name	= "s5p-hdmiphy",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(hdmiphy_dt_match),
 	},
 	.probe		= hdmiphy_probe,
 	.remove		= __devexit_p(hdmiphy_remove),
-- 
1.7.9.1

