Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab2IGLRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:17:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41840 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760408Ab2IGLPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:15:33 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>,
        linux-i2c@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 12/19] i2c-nomadik: Register sub-devices when passed via Device Tree
Date: Fri,  7 Sep 2012 12:14:52 +0100
Message-Id: <1347016499-29354-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each I2C device can be correctly probed already using Device Tree,
but the sub-devices still have to be registered by calls to
i2c_register_board_info(). After this patch, each sub-device can
be registered directly from Device Tree instead, removing the
requirement for the aforementioned calls from platform code.

CC: linux-i2c@vger.kernel.org
CC: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/i2c/busses/i2c-nomadik.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index 5d1a970..01231c2 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -26,6 +26,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/platform_data/i2c-nomadik.h>
 #include <linux/of.h>
+#include <linux/of_i2c.h>
 
 #define DRIVER_NAME "nmk-i2c"
 
@@ -998,6 +999,7 @@ static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 	}
 
 	adap = &dev->adap;
+	adap->dev.of_node = np;
 	adap->dev.parent = &adev->dev;
 	adap->owner	= THIS_MODULE;
 	adap->class	= I2C_CLASS_HWMON | I2C_CLASS_SPD;
@@ -1027,6 +1029,8 @@ static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 		goto err_add_adap;
 	}
 
+	of_i2c_register_devices(adap);
+
 	pm_runtime_put(&adev->dev);
 
 	return 0;
-- 
1.7.9.5

