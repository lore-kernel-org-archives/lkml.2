Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934603Ab2C3Pwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:52:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37473 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934481Ab2C3PuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:50:18 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-i2c@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Jon Hunter <jon-hunter@ti.com>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv3 09/16] I2C: OMAP: Correct I2C revision for OMAP3
Date: Fri, 30 Mar 2012 21:20:04 +0530
Message-ID: <1333122611-29953-10-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1333122611-29953-1-git-send-email-shubhrajyoti@ti.com>
References: <1333122611-29953-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Hunter <jon-hunter@ti.com>

The OMAP3530 is based upon the same silicon as the OMAP3430 and so the I2C
revision is the same for 3430 and 3530. However, the OMAP3630 device has the
same I2C revision as OMAP4. Correct the revision definition to reflect this.

This patch is based on work done by Jon Hunter <jon-hunter@ti.com>
Changes from his patch
- Update OMAP_I2C_REV_ON_3430 also to reflect that it is same as 3530

Signed-off-by: Jon Hunter <jon-hunter@ti.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 1e36507..121b29b 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -50,8 +50,8 @@
 
 /* I2C controller revisions present on specific hardware */
 #define OMAP_I2C_REV_ON_2430		0x36
-#define OMAP_I2C_REV_ON_3430		0x3C
-#define OMAP_I2C_REV_ON_3530_4430	0x40
+#define OMAP_I2C_REV_ON_3430_3530	0x3C
+#define OMAP_I2C_REV_ON_3630_4430	0x40
 
 /* timeout waiting for the controller to respond */
 #define OMAP_I2C_TIMEOUT (msecs_to_jiffies(1000))
@@ -298,7 +298,7 @@ static int omap_i2c_reset(struct omap_i2c_dev *dev)
 			omap_i2c_write_reg(dev, OMAP_I2C_SYSC_REG,
 					   SYSC_AUTOIDLE_MASK);
 
-		} else if (dev->rev >= OMAP_I2C_REV_ON_3430) {
+		} else if (dev->rev >= OMAP_I2C_REV_ON_3430_3530) {
 			dev->syscstate = SYSC_AUTOIDLE_MASK;
 			dev->syscstate |= SYSC_ENAWAKEUP_MASK;
 			dev->syscstate |= (SYSC_IDLEMODE_SMART <<
@@ -1051,7 +1051,7 @@ omap_i2c_probe(struct platform_device *pdev)
 
 	dev->rev = omap_i2c_read_reg(dev, OMAP_I2C_REV_REG) & 0xff;
 
-	if (dev->rev <= OMAP_I2C_REV_ON_3430)
+	if (dev->rev <= OMAP_I2C_REV_ON_3430_3530)
 		dev->errata |= I2C_OMAP3_1P153;
 
 	if (!(dev->flags & OMAP_I2C_FLAG_NO_FIFO)) {
@@ -1069,7 +1069,7 @@ omap_i2c_probe(struct platform_device *pdev)
 
 		dev->fifo_size = (dev->fifo_size / 2);
 
-		if (dev->rev >= OMAP_I2C_REV_ON_3530_4430)
+		if (dev->rev >= OMAP_I2C_REV_ON_3630_4430)
 			dev->b_hw = 0; /* Disable hardware fixes */
 		else
 			dev->b_hw = 1; /* Enable hardware fixes */
-- 
1.7.1

