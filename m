Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2EGJFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 05:05:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60728 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755959Ab2EGJDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 05:03:37 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 6/7] mfd: wm8994: Read CUST_ID from the device
Date: Mon,  7 May 2012 10:03:22 +0100
Message-Id: <1336381403-7840-6-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336381403-7840-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1336381403-7840-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read CUST_ID from the device and log it for diagnostics.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c            |    7 ++++---
 include/linux/mfd/wm8994/core.h      |    1 +
 include/linux/mfd/wm8994/registers.h |    3 +++
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 9d7ca1e..60e61754 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -500,7 +500,8 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
 			ret);
 		goto err_enable;
 	}
-	wm8994->revision = ret;
+	wm8994->revision = ret & WM8994_CHIP_REV_MASK;
+	wm8994->cust_id = (ret & WM8994_CUST_ID_MASK) >> WM8994_CUST_ID_SHIFT;
 
 	switch (wm8994->type) {
 	case WM8994:
@@ -553,8 +554,8 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		break;
 	}
 
-	dev_info(wm8994->dev, "%s revision %c\n", devname,
-		 'A' + wm8994->revision);
+	dev_info(wm8994->dev, "%s revision %c CUST_ID %02x\n", devname,
+		 'A' + wm8994->revision, wm8994->cust_id);
 
 	switch (wm8994->type) {
 	case WM1811:
diff --git a/include/linux/mfd/wm8994/core.h b/include/linux/mfd/wm8994/core.h
index 9eff2a3..d41bc7b 100644
--- a/include/linux/mfd/wm8994/core.h
+++ b/include/linux/mfd/wm8994/core.h
@@ -57,6 +57,7 @@ struct wm8994 {
 
 	enum wm8994_type type;
 	int revision;
+	int cust_id;
 
 	struct device *dev;
 	struct regmap *regmap;
diff --git a/include/linux/mfd/wm8994/registers.h b/include/linux/mfd/wm8994/registers.h
index 86e6a03..0535489 100644
--- a/include/linux/mfd/wm8994/registers.h
+++ b/include/linux/mfd/wm8994/registers.h
@@ -2212,6 +2212,9 @@
 /*
  * R256 (0x100) - Chip Revision
  */
+#define WM8994_CUST_ID_MASK                     0xFF00  /* CUST_ID - [15:8] */
+#define WM8994_CUST_ID_SHIFT                         8  /* CUST_ID - [15:8] */
+#define WM8994_CUST_ID_WIDTH                         8  /* CUST_ID - [15:8] */
 #define WM8994_CHIP_REV_MASK                    0x000F  /* CHIP_REV - [3:0] */
 #define WM8994_CHIP_REV_SHIFT                        0  /* CHIP_REV - [3:0] */
 #define WM8994_CHIP_REV_WIDTH                        4  /* CHIP_REV - [3:0] */
-- 
1.7.10

