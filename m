Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab2CKKyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 06:54:21 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:38674 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752371Ab2CKKyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 06:54:17 -0400
From: Roland Stigge <stigge@antcom.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de,
        kevin.wells@nxp.com, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v7 2/4] USB: ohci-nxp: Rename symbols from pnx4008 to nxp
Date: Sun, 11 Mar 2012 11:53:37 +0100
Message-Id: <1331463219-23293-3-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1331463219-23293-1-git-send-email-stigge@antcom.de>
References: <1331463219-23293-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since this driver is compatible with several NXP devices, the driver was renamed
accordingly. This patch also changes the respective symbol names.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 Documentation/i2c/instantiating-devices |    6 +--
 drivers/usb/host/ohci-hcd.c             |    2 -
 drivers/usb/host/ohci-nxp.c             |   55 ++++++++++++++++----------------
 3 files changed, 33 insertions(+), 30 deletions(-)

--- linux-2.6.orig/Documentation/i2c/instantiating-devices
+++ linux-2.6/Documentation/i2c/instantiating-devices
@@ -87,11 +87,11 @@ it may have different addresses from one
 changing its design without notice). In this case, you can call
 i2c_new_probed_device() instead of i2c_new_device().
 
-Example (from the pnx4008 OHCI driver):
+Example (from the nxp OHCI driver):
 
 static const unsigned short normal_i2c[] = { 0x2c, 0x2d, I2C_CLIENT_END };
 
-static int __devinit usb_hcd_pnx4008_probe(struct platform_device *pdev)
+static int __devinit usb_hcd_nxp_probe(struct platform_device *pdev)
 {
 	(...)
 	struct i2c_adapter *i2c_adap;
@@ -100,7 +100,7 @@ static int __devinit usb_hcd_pnx4008_pro
 	(...)
 	i2c_adap = i2c_get_adapter(2);
 	memset(&i2c_info, 0, sizeof(struct i2c_board_info));
-	strlcpy(i2c_info.type, "isp1301_pnx", I2C_NAME_SIZE);
+	strlcpy(i2c_info.type, "isp1301_nxp", I2C_NAME_SIZE);
 	isp1301_i2c_client = i2c_new_probed_device(i2c_adap, &i2c_info,
 						   normal_i2c, NULL);
 	i2c_put_adapter(i2c_adap);
--- linux-2.6.orig/drivers/usb/host/ohci-hcd.c
+++ linux-2.6/drivers/usb/host/ohci-hcd.c
@@ -1052,7 +1052,7 @@ MODULE_LICENSE ("GPL");
 
 #ifdef CONFIG_ARCH_PNX4008
 #include "ohci-nxp.c"
-#define PLATFORM_DRIVER		usb_hcd_pnx4008_driver
+#define PLATFORM_DRIVER		usb_hcd_nxp_driver
 #endif
 
 #ifdef CONFIG_ARCH_DAVINCI_DA8XX
--- linux-2.6.orig/drivers/usb/host/ohci-nxp.c
+++ linux-2.6/drivers/usb/host/ohci-nxp.c
@@ -1,7 +1,10 @@
 /*
- * drivers/usb/host/ohci-pnx4008.c
+ * drivers/usb/host/ohci-nxp.c
  *
- * driver for Philips PNX4008 USB Host
+ * driver for NXP USB Host devices
+ *
+ * Currently supported OHCI host devices:
+ * - Philips PNX4008
  *
  * Authors: Dmitry Chigirev <source@mvista.com>
  *	    Vitaly Wool <vitalywool@gmail.com>
@@ -121,13 +124,13 @@ static int isp1301_remove(struct i2c_cli
 }
 
 static const struct i2c_device_id isp1301_id[] = {
-	{ "isp1301_pnx", 0 },
+	{ "isp1301_nxp", 0 },
 	{ }
 };
 
 static struct i2c_driver isp1301_driver = {
 	.driver = {
-		.name = "isp1301_pnx",
+		.name = "isp1301_nxp",
 	},
 	.probe = isp1301_probe,
 	.remove = isp1301_remove,
@@ -180,14 +183,14 @@ static inline void isp1301_vbus_off(void
 		  ISP1301_I2C_OTG_CONTROL_1 | ISP1301_I2C_REG_CLEAR_ADDR);
 }
 
-static void pnx4008_start_hc(void)
+static void nxp_start_hc(void)
 {
 	unsigned long tmp = __raw_readl(USB_OTG_STAT_CONTROL) | HOST_EN;
 	__raw_writel(tmp, USB_OTG_STAT_CONTROL);
 	isp1301_vbus_on();
 }
 
-static void pnx4008_stop_hc(void)
+static void nxp_stop_hc(void)
 {
 	unsigned long tmp;
 	isp1301_vbus_off();
@@ -195,7 +198,7 @@ static void pnx4008_stop_hc(void)
 	__raw_writel(tmp, USB_OTG_STAT_CONTROL);
 }
 
-static int __devinit ohci_pnx4008_start(struct usb_hcd *hcd)
+static int __devinit ohci_nxp_start(struct usb_hcd *hcd)
 {
 	struct ohci_hcd *ohci = hcd_to_ohci(hcd);
 	int ret;
@@ -211,9 +214,9 @@ static int __devinit ohci_pnx4008_start(
 	return 0;
 }
 
-static const struct hc_driver ohci_pnx4008_hc_driver = {
+static const struct hc_driver ohci_nxp_hc_driver = {
 	.description = hcd_name,
-	.product_desc =		"pnx4008 OHCI",
+	.product_desc =		"nxp OHCI",
 
 	/*
 	 * generic hardware linkage
@@ -225,7 +228,7 @@ static const struct hc_driver ohci_pnx40
 	/*
 	 * basic lifecycle operations
 	 */
-	.start = ohci_pnx4008_start,
+	.start = ohci_nxp_start,
 	.stop = ohci_stop,
 	.shutdown = ohci_shutdown,
 
@@ -255,7 +258,7 @@ static const struct hc_driver ohci_pnx40
 
 #define USB_CLOCK_MASK (AHB_M_CLOCK_ON| OTG_CLOCK_ON | HOST_CLOCK_ON | I2C_CLOCK_ON)
 
-static void pnx4008_set_usb_bits(void)
+static void nxp_set_usb_bits(void)
 {
 	start_int_set_falling_edge(SE_USB_OTG_ATX_INT_N);
 	start_int_ack(SE_USB_OTG_ATX_INT_N);
@@ -282,7 +285,7 @@ static void pnx4008_set_usb_bits(void)
 	start_int_umask(SE_USB_AHB_NEED_CLK_INT);
 }
 
-static void pnx4008_unset_usb_bits(void)
+static void nxp_unset_usb_bits(void)
 {
 	start_int_mask(SE_USB_OTG_ATX_INT_N);
 	start_int_mask(SE_USB_OTG_TIMER_INT);
@@ -292,17 +295,17 @@ static void pnx4008_unset_usb_bits(void)
 	start_int_mask(SE_USB_AHB_NEED_CLK_INT);
 }
 
-static int __devinit usb_hcd_pnx4008_probe(struct platform_device *pdev)
+static int __devinit usb_hcd_nxp_probe(struct platform_device *pdev)
 {
 	struct usb_hcd *hcd = 0;
 	struct ohci_hcd *ohci;
-	const struct hc_driver *driver = &ohci_pnx4008_hc_driver;
+	const struct hc_driver *driver = &ohci_nxp_hc_driver;
 	struct i2c_adapter *i2c_adap;
 	struct i2c_board_info i2c_info;
 
 	int ret = 0, irq;
 
-	dev_dbg(&pdev->dev, "%s: " DRIVER_DESC " (pnx4008)\n", hcd_name);
+	dev_dbg(&pdev->dev, "%s: " DRIVER_DESC " (nxp)\n", hcd_name);
 	if (usb_disabled()) {
 		err("USB is disabled");
 		ret = -ENODEV;
@@ -327,7 +330,7 @@ static int __devinit usb_hcd_pnx4008_pro
 	}
 	i2c_adap = i2c_get_adapter(2);
 	memset(&i2c_info, 0, sizeof(struct i2c_board_info));
-	strlcpy(i2c_info.type, "isp1301_pnx", I2C_NAME_SIZE);
+	strlcpy(i2c_info.type, "isp1301_nxp", I2C_NAME_SIZE);
 	isp1301_i2c_client = i2c_new_probed_device(i2c_adap, &i2c_info,
 						   normal_i2c, NULL);
 	i2c_put_adapter(i2c_adap);
@@ -375,7 +378,7 @@ static int __devinit usb_hcd_pnx4008_pro
 	}
 
 	/* Set all USB bits in the Start Enable register */
-	pnx4008_set_usb_bits();
+	nxp_set_usb_bits();
 
 	hcd->rsrc_start = pdev->resource[0].start;
 	hcd->rsrc_len = pdev->resource[0].end - pdev->resource[0].start + 1;
@@ -392,7 +395,7 @@ static int __devinit usb_hcd_pnx4008_pro
 		goto out4;
 	}
 
-	pnx4008_start_hc();
+	nxp_start_hc();
 	platform_set_drvdata(pdev, hcd);
 	ohci = hcd_to_ohci(hcd);
 	ohci_hcd_init(ohci);
@@ -402,9 +405,9 @@ static int __devinit usb_hcd_pnx4008_pro
 	if (ret == 0)
 		return ret;
 
-	pnx4008_stop_hc();
+	nxp_stop_hc();
 out4:
-	pnx4008_unset_usb_bits();
+	nxp_unset_usb_bits();
 	usb_put_hcd(hcd);
 out3:
 	clk_disable(usb_clk);
@@ -419,15 +422,15 @@ out:
 	return ret;
 }
 
-static int usb_hcd_pnx4008_remove(struct platform_device *pdev)
+static int usb_hcd_nxp_remove(struct platform_device *pdev)
 {
 	struct usb_hcd *hcd = platform_get_drvdata(pdev);
 
 	usb_remove_hcd(hcd);
-	pnx4008_stop_hc();
+	nxp_stop_hc();
 	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
-	pnx4008_unset_usb_bits();
+	nxp_unset_usb_bits();
 	clk_disable(usb_clk);
 	clk_put(usb_clk);
 	i2c_unregister_device(isp1301_i2c_client);
@@ -442,12 +445,12 @@ static int usb_hcd_pnx4008_remove(struct
 /* work with hotplug and coldplug */
 MODULE_ALIAS("platform:usb-ohci");
 
-static struct platform_driver usb_hcd_pnx4008_driver = {
+static struct platform_driver usb_hcd_nxp_driver = {
 	.driver = {
 		.name = "usb-ohci",
 		.owner	= THIS_MODULE,
 	},
-	.probe = usb_hcd_pnx4008_probe,
-	.remove = usb_hcd_pnx4008_remove,
+	.probe = usb_hcd_nxp_probe,
+	.remove = usb_hcd_nxp_remove,
 };
 
