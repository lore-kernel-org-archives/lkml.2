Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423047Ab2CPPme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:42:34 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31196 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760812Ab2CPPmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:42:20 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 16 Mar 2012 16:42:12 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 2/2] s5p-tv: Add initial DT-support for HDMIPHY
In-reply-to: <1331912532-7798-1-git-send-email-k.lewandowsk@samsung.com>
To: t.stanislaws@samsung.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1331912532-7798-3-git-send-email-k.lewandowsk@samsung.com>
X-Mailer: git-send-email 1.7.9
References: <1331912532-7798-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it possible to instantiate driver from device tree description.

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 drivers/media/video/s5p-tv/hdmiphy_drv.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/s5p-tv/hdmiphy_drv.c b/drivers/media/video/s5p-tv/hdmiphy_drv.c
index 6693f4a..ddf3008 100644
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
1.7.9

