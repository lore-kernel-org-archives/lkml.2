Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab2HCMgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 08:36:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34989 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab2HCMgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 08:36:32 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <khali@linux-fr.org>, <linux@roeck-us.net>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Sourav Poddar <sourav.poddar@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH] hwmon: tmp102: Add device tree support
Date: Fri, 3 Aug 2012 18:05:50 +0530
Message-ID: <1343997350-676-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update tmp102 temperature sensor to also use device tree.

Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 drivers/hwmon/tmp102.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/tmp102.c b/drivers/hwmon/tmp102.c
index 0d466b9..a8a9060 100644
--- a/drivers/hwmon/tmp102.c
+++ b/drivers/hwmon/tmp102.c
@@ -26,6 +26,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/device.h>
+#include <linux/of.h>
 
 #define	DRIVER_NAME "tmp102"
 
@@ -284,8 +285,19 @@ static const struct i2c_device_id tmp102_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, tmp102_id);
 
+#ifdef CONFIG_OF
+static const struct of_device_id temperature_dt_match[] = {
+	{ .compatible = "ti,tmp102" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, temperature_dt_match);
+#endif
+
 static struct i2c_driver tmp102_driver = {
-	.driver.name	= DRIVER_NAME,
+	.driver	= {
+		.name =	DRIVER_NAME,
+		.of_match_table = of_match_ptr(temperature_dt_match),
+	},
 	.driver.pm	= TMP102_DEV_PM_OPS,
 	.probe		= tmp102_probe,
 	.remove		= __devexit_p(tmp102_remove),
-- 
1.7.1

