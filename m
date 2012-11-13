Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab2KMJnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 04:43:43 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45006 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265Ab2KMJnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 04:43:41 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH] usb: otg: twl4030: Change TWL4030_MODULE_* ids to TWL_MODULE_*
Date: Tue, 13 Nov 2012 10:43:38 +0100
Message-ID: <1352799818-22363-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To facilitate upcoming cleanup in twl stack.
No functional changes.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/usb/otg/twl4030-usb.c | 46 ++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 25 deletions(-)

diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
index f0d2e75..11b2a12 100644
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -123,10 +123,10 @@
 #define PHY_CLK_CTRL_STS		0xFF
 #define PHY_DPLL_CLK			(1 << 0)
 
-/* In module TWL4030_MODULE_PM_MASTER */
+/* In module TWL_MODULE_PM_MASTER */
 #define STS_HW_CONDITIONS		0x0F
 
-/* In module TWL4030_MODULE_PM_RECEIVER */
+/* In module TWL_MODULE_PM_RECEIVER */
 #define VUSB_DEDICATED1			0x7D
 #define VUSB_DEDICATED2			0x7E
 #define VUSB1V5_DEV_GRP			0x71
@@ -195,14 +195,14 @@ static int twl4030_i2c_write_u8_verify(struct twl4030_usb *twl,
 }
 
 #define twl4030_usb_write_verify(twl, address, data)	\
-	twl4030_i2c_write_u8_verify(twl, TWL4030_MODULE_USB, (data), (address))
+	twl4030_i2c_write_u8_verify(twl, TWL_MODULE_USB, (data), (address))
 
 static inline int twl4030_usb_write(struct twl4030_usb *twl,
 		u8 address, u8 data)
 {
 	int ret = 0;
 
-	ret = twl_i2c_write_u8(TWL4030_MODULE_USB, data, address);
+	ret = twl_i2c_write_u8(TWL_MODULE_USB, data, address);
 	if (ret < 0)
 		dev_dbg(twl->dev,
 			"TWL4030:USB:Write[0x%x] Error %d\n", address, ret);
@@ -227,7 +227,7 @@ static inline int twl4030_readb(struct twl4030_usb *twl, u8 module, u8 address)
 
 static inline int twl4030_usb_read(struct twl4030_usb *twl, u8 address)
 {
-	return twl4030_readb(twl, TWL4030_MODULE_USB, address);
+	return twl4030_readb(twl, TWL_MODULE_USB, address);
 }
 
 /*-------------------------------------------------------------------------*/
@@ -264,8 +264,7 @@ static enum omap_musb_vbus_id_status
 	 * signal is active, the OTG module is activated, and
 	 * its interrupt may be raised (may wake the system).
 	 */
-	status = twl4030_readb(twl, TWL4030_MODULE_PM_MASTER,
-			STS_HW_CONDITIONS);
+	status = twl4030_readb(twl, TWL_MODULE_PM_MASTER, STS_HW_CONDITIONS);
 	if (status < 0)
 		dev_err(twl->dev, "USB link status err %d\n", status);
 	else if (status & (BIT(7) | BIT(2))) {
@@ -372,8 +371,7 @@ static void twl4030_phy_power(struct twl4030_usb *twl, int on)
 		 * SLEEP. We work around this by clearing the bit after usv3v1
 		 * is re-activated. This ensures that VUSB3V1 is really active.
 		 */
-		twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0,
-							VUSB_DEDICATED2);
+		twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB_DEDICATED2);
 		regulator_enable(twl->usb1v5);
 		__twl4030_phy_power(twl, 1);
 		twl4030_usb_write(twl, PHY_CLK_CTRL,
@@ -419,50 +417,48 @@ static void twl4030_phy_resume(struct twl4030_usb *twl)
 static int twl4030_usb_ldo_init(struct twl4030_usb *twl)
 {
 	/* Enable writing to power configuration registers */
-	twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
-			TWL4030_PM_MASTER_KEY_CFG1,
-			TWL4030_PM_MASTER_PROTECT_KEY);
+	twl_i2c_write_u8(TWL_MODULE_PM_MASTER, TWL4030_PM_MASTER_KEY_CFG1,
+			 TWL4030_PM_MASTER_PROTECT_KEY);
 
-	twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
-			TWL4030_PM_MASTER_KEY_CFG2,
-			TWL4030_PM_MASTER_PROTECT_KEY);
+	twl_i2c_write_u8(TWL_MODULE_PM_MASTER, TWL4030_PM_MASTER_KEY_CFG2,
+			 TWL4030_PM_MASTER_PROTECT_KEY);
 
 	/* Keep VUSB3V1 LDO in sleep state until VBUS/ID change detected*/
-	/*twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB_DEDICATED2);*/
+	/*twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB_DEDICATED2);*/
 
 	/* input to VUSB3V1 LDO is from VBAT, not VBUS */
-	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0x14, VUSB_DEDICATED1);
+	twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0x14, VUSB_DEDICATED1);
 
 	/* Initialize 3.1V regulator */
-	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB3V1_DEV_GRP);
+	twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB3V1_DEV_GRP);
 
 	twl->usb3v1 = regulator_get(twl->dev, "usb3v1");
 	if (IS_ERR(twl->usb3v1))
 		return -ENODEV;
 
-	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB3V1_TYPE);
+	twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB3V1_TYPE);
 
 	/* Initialize 1.5V regulator */
-	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V5_DEV_GRP);
+	twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB1V5_DEV_GRP);
 
 	twl->usb1v5 = regulator_get(twl->dev, "usb1v5");
 	if (IS_ERR(twl->usb1v5))
 		goto fail1;
 
-	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V5_TYPE);
+	twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB1V5_TYPE);
 
 	/* Initialize 1.8V regulator */
-	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V8_DEV_GRP);
+	twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB1V8_DEV_GRP);
 
 	twl->usb1v8 = regulator_get(twl->dev, "usb1v8");
 	if (IS_ERR(twl->usb1v8))
 		goto fail2;
 
-	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V8_TYPE);
+	twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB1V8_TYPE);
 
 	/* disable access to power configuration registers */
-	twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0,
-			TWL4030_PM_MASTER_PROTECT_KEY);
+	twl_i2c_write_u8(TWL_MODULE_PM_MASTER, 0,
+			 TWL4030_PM_MASTER_PROTECT_KEY);
 
 	return 0;
 
-- 
1.8.0

