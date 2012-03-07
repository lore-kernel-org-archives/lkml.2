Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030528Ab2CGW2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:28:55 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39873 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab2CGW2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:28:51 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Shawn Guo <shawn.guo@linaro.org>, Huang Shijie <b32955@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 2/3] i2c: mxs: use global reset function
Date: Wed,  7 Mar 2012 23:28:33 +0100
Message-Id: <1331159314-12022-3-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1331159314-12022-1-git-send-email-w.sang@pengutronix.de>
References: <1331159314-12022-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The former mach specific reset_block function has been converted to a global
one. Use the new one to remove mach dependency from the driver.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/i2c/busses/Kconfig   |    1 +
 drivers/i2c/busses/i2c-mxs.c |    9 ++-------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 3101dd5..d4378cf 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -467,6 +467,7 @@ config I2C_MV64XXX
 config I2C_MXS
 	tristate "Freescale i.MX28 I2C interface"
 	depends on SOC_IMX28
+	select STMP_DEVICE
 	help
 	  Say Y here if you want to use the I2C bus controller on
 	  the Freescale i.MX28 processors.
diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index 3d471d5..0834802 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -26,8 +26,7 @@
 #include <linux/platform_device.h>
 #include <linux/jiffies.h>
 #include <linux/io.h>
-
-#include <mach/common.h>
+#include <linux/stmp_device.h>
 
 #define DRIVER_NAME "mxs-i2c"
 
@@ -111,13 +110,9 @@ struct mxs_i2c_dev {
 	struct i2c_adapter adapter;
 };
 
-/*
- * TODO: check if calls to here are really needed. If not, we could get rid of
- * mxs_reset_block and the mach-dependency. Needs an I2C analyzer, probably.
- */
 static void mxs_i2c_reset(struct mxs_i2c_dev *i2c)
 {
-	mxs_reset_block(i2c->regs);
+	stmp_reset_block(i2c->regs);
 	writel(MXS_I2C_IRQ_MASK << 8, i2c->regs + MXS_I2C_CTRL1_SET);
 	writel(MXS_I2C_QUEUECTRL_PIO_QUEUE_MODE,
 			i2c->regs + MXS_I2C_QUEUECTRL_SET);
-- 
1.7.9.1

