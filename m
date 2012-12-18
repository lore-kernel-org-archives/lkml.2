Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab2LROie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 09:38:34 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:49218 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab2LROic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 09:38:32 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-bd-50d07fe68d9e
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, stern@rowland.harvard.edu, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        jg1.han@samsung.com, yulgon.kim@samsung.com, kishon@ti.com,
        p.paneri@samsung.com
Subject: [PATCH v5 2/4] usb: phy: samsung: Add host phy support to samsung-phy
 driver
Date: Tue, 18 Dec 2012 20:13:04 +0530
Message-id: <1355841786-13307-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1355841786-13307-1-git-send-email-gautam.vivek@samsung.com>
References: <1355841786-13307-1-git-send-email-gautam.vivek@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsWyRsSkTvdZ/YUAgy23ZS0u75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIzisklJzcksSy3St0vgylh66xZzwbMNjBVNj+UbGD/1MXYxcnJICJhI
	LFz5gB3CFpO4cG89WxcjF4eQwFJGiaf75rPAFM07+h8qMZ1RYuve+ewQzmQmicuPJzKBVLEJ
	6Eo0vd0FNlZEQFbi8JXfzCBFzAK9zBKnTh4BGyUsEC6xZ003WAOLgKrE/02n2EBsXgEPiUPX
	J0KtU5B4c/sZM4jNKeAp0XjkGFA9B9A2D4mu21IQrQIS3yYfYgEJSwDt2nQAbJWEwGM2ibP3
	57JCjJGUOLjiBssERuEFjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MQJD8/S/Z1I7GFc2
	WBxiFOBgVOLhvZF/IUCINbGsuDL3EKMEB7OSCO+bOKAQb0piZVVqUX58UWlOavEhRh+gSyYy
	S4km5wPjJq8k3tDYxNzU2NTSyMjM1BSHsJI4b7NHSoCQQHpiSWp2ampBahHMOCYOTqkGRs6/
	uzeH5pXwKCoX+CrPeyZ5M//YpHsi4jLbn4r9aJ/+5tmZl29URRwWNQckus/Mqj7yxnzC0pvX
	tbbPO3Cl1Jl/7yrxveIOdx41fb16Nuho+YugFX8TJ2RuyN3aEDvFw/r9jbe/HF+6eFZLHTQr
	i7oulPbJLDDTN27KqrMezWvkPzwvz/00X12JpTgj0VCLuag4EQBGMHcTegIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t9jQd1n9RcCDD49FLK4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFj6a1b
	zAXPNjBWND2Wb2D81MfYxcjJISFgIjHv6H82CFtM4sK99UA2F4eQwHRGia1757NDOJOZJC4/
	nsgEUsUmoCvR9HYXWLeIgKzE4Su/mUGKmAV6mSVOnTzCApIQFgiX2LOmG6yBRUBV4v+mU2Ar
	eAU8JA5dn8gCsU5B4s3tZ8wgNqeAp0TjkWNA9RxA2zwkum5LTWDkXcDIsIpRNLUguaA4KT3X
	UK84Mbe4NC9dLzk/dxMjOPCfSe1gXNlgcYhRgINRiYf3Rv6FACHWxLLiytxDjBIczEoivG/i
	gEK8KYmVValF+fFFpTmpxYcYfYCOmsgsJZqcD4zKvJJ4Q2MTc1NjU0sTCxMzSxzCSuK8zR4p
	AUIC6YklqdmpqQWpRTDjmDg4pRoY+23uzE/48Y3V/3L6Ib+7Oxs/LgyOka+byhReIqwTNyXy
	qJ/Uv/X31kSsPy/F/niH7NYp0X8+rpvvf114z85y11nspqeXK/X2SM7VTHjAWLxtWs0qYzeB
	CyF2921e3+yXa3nVeH3HwR8bliYlM89OVo47W3j0jG+x0b4SlmUKiguvTa4TcDBzVmIpzkg0
	1GIuKk4EAIn1lWupAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds host phy support to samsung-usbphy.c and
further adds support for samsung's exynos5250 usb-phy.

Signed-off-by: Praveen Paneri <p.paneri@samsung.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 .../devicetree/bindings/usb/samsung-usbphy.txt     |   25 +-
 drivers/usb/phy/Kconfig                            |    2 +-
 drivers/usb/phy/samsung-usbphy.c                   |  465 ++++++++++++++++++--
 include/linux/usb/samsung_usb_phy.h                |   13 +
 4 files changed, 454 insertions(+), 51 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
index a7b28b2..2ec5400 100644
--- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
+++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
@@ -1,23 +1,38 @@
 * Samsung's usb phy transceiver
 
-The Samsung's phy transceiver is used for controlling usb otg phy for
-s3c-hsotg usb device controller.
+The Samsung's phy transceiver is used for controlling usb phy for
+s3c-hsotg as well as ehci-s5p and ohci-exynos usb controllers
+across Samsung SOCs.
 TODO: Adding the PHY binding with controller(s) according to the under
 developement generic PHY driver.
 
 Required properties:
+
+Exynos4210:
 - compatible : should be "samsung,exynos4210-usbphy"
 - reg : base physical address of the phy registers and length of memory mapped
 	region.
 
+Exynos5250:
+- compatible : should be "samsung,exynos5250-usbphy"
+- reg : base physical address of the phy registers and length of memory mapped
+	region.
+
 Optional properties:
 - samsung,usb-phyhandle : should point to usb-phyhandle sub-node which provides
 			binding data to enable/disable device PHY handled by
-			PMU register.
+			PMU register; or to configure usb2.0 phy handled by
+			SYSREG.
 
 			Required properties:
 			- compatible : should be "samsung,usbdev-phyctrl" for
-					DEVICE type phy.
+				       DEVICE type phy; or
+				       should be "samsung,usbhost-phyctrl" for
+				       HOST type phy; or
+				       should be "samsung,usb-phycfg" for
+				       USB2.0 PHY_CFG.
 			- samsung,phyhandle-reg: base physical address of
-						PHY_CONTROL register in PMU.
+						 PHY_CONTROL register in PMU;
+						 or USB2.0 PHY_CFG register
+						 in SYSREG.
 - samsung,enable-mask : should be '1'
diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 17ad743..13c0eaf 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -47,7 +47,7 @@ config USB_RCAR_PHY
 
 config SAMSUNG_USBPHY
 	bool "Samsung USB PHY controller Driver"
-	depends on USB_S3C_HSOTG
+	depends on USB_S3C_HSOTG || USB_EHCI_S5P || USB_OHCI_EXYNOS
 	select USB_OTG_UTILS
 	help
 	  Enable this to support Samsung USB phy controller for samsung
diff --git a/drivers/usb/phy/samsung-usbphy.c b/drivers/usb/phy/samsung-usbphy.c
index 4ceabe3..621348a 100644
--- a/drivers/usb/phy/samsung-usbphy.c
+++ b/drivers/usb/phy/samsung-usbphy.c
@@ -5,7 +5,8 @@
  *
  * Author: Praveen Paneri <p.paneri@samsung.com>
  *
- * Samsung USB2.0 High-speed OTG transceiver, talks to S3C HS OTG controller
+ * Samsung USB-PHY transceiver; talks to S3C HS OTG controller, EHCI-S5P and
+ * OHCI-EXYNOS controllers.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -24,7 +25,7 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/of.h>
-#include <linux/usb/otg.h>
+#include <linux/usb/samsung_usb_phy.h>
 #include <linux/platform_data/samsung-usbphy.h>
 
 /* Register definitions */
@@ -56,6 +57,103 @@
 #define RSTCON_HLINK_SWRST			(0x1 << 1)
 #define RSTCON_SWRST				(0x1 << 0)
 
+/* EXYNOS5 */
+#define EXYNOS5_PHY_HOST_CTRL0			(0x00)
+
+#define HOST_CTRL0_PHYSWRSTALL			(0x1 << 31)
+
+#define HOST_CTRL0_REFCLKSEL_MASK		(0x3)
+#define HOST_CTRL0_REFCLKSEL_XTAL		(0x0 << 19)
+#define HOST_CTRL0_REFCLKSEL_EXTL		(0x1 << 19)
+#define HOST_CTRL0_REFCLKSEL_CLKCORE		(0x2 << 19)
+
+#define HOST_CTRL0_FSEL_MASK			(0x7 << 16)
+#define HOST_CTRL0_FSEL(_x)			((_x) << 16)
+#define HOST_CTRL0_FSEL_CLKSEL_50M		(0x7)
+#define HOST_CTRL0_FSEL_CLKSEL_24M		(0x5)
+#define HOST_CTRL0_FSEL_CLKSEL_20M		(0x4)
+#define HOST_CTRL0_FSEL_CLKSEL_19200K		(0x3)
+#define HOST_CTRL0_FSEL_CLKSEL_12M		(0x2)
+#define HOST_CTRL0_FSEL_CLKSEL_10M		(0x1)
+#define HOST_CTRL0_FSEL_CLKSEL_9600K		(0x0)
+
+#define HOST_CTRL0_TESTBURNIN			(0x1 << 11)
+#define HOST_CTRL0_RETENABLE			(0x1 << 10)
+#define HOST_CTRL0_COMMONON_N			(0x1 << 9)
+#define HOST_CTRL0_SIDDQ			(0x1 << 6)
+#define HOST_CTRL0_FORCESLEEP			(0x1 << 5)
+#define HOST_CTRL0_FORCESUSPEND			(0x1 << 4)
+#define HOST_CTRL0_WORDINTERFACE		(0x1 << 3)
+#define HOST_CTRL0_UTMISWRST			(0x1 << 2)
+#define HOST_CTRL0_LINKSWRST			(0x1 << 1)
+#define HOST_CTRL0_PHYSWRST			(0x1 << 0)
+
+#define EXYNOS5_PHY_HOST_TUNE0			(0x04)
+
+#define EXYNOS5_PHY_HSIC_CTRL1			(0x10)
+
+#define EXYNOS5_PHY_HSIC_TUNE1			(0x14)
+
+#define EXYNOS5_PHY_HSIC_CTRL2			(0x20)
+
+#define EXYNOS5_PHY_HSIC_TUNE2			(0x24)
+
+#define HSIC_CTRL_REFCLKSEL_MASK		(0x3)
+#define HSIC_CTRL_REFCLKSEL			(0x2 << 23)
+
+#define HSIC_CTRL_REFCLKDIV_MASK		(0x7f)
+#define HSIC_CTRL_REFCLKDIV(_x)			((_x) << 16)
+#define HSIC_CTRL_REFCLKDIV_12			(0x24 << 16)
+#define HSIC_CTRL_REFCLKDIV_15			(0x1c << 16)
+#define HSIC_CTRL_REFCLKDIV_16			(0x1a << 16)
+#define HSIC_CTRL_REFCLKDIV_19_2		(0x15 << 16)
+#define HSIC_CTRL_REFCLKDIV_20			(0x14)
+
+#define HSIC_CTRL_SIDDQ				(0x1 << 6)
+#define HSIC_CTRL_FORCESLEEP			(0x1 << 5)
+#define HSIC_CTRL_FORCESUSPEND			(0x1 << 4)
+#define HSIC_CTRL_WORDINTERFACE			(0x1 << 3)
+#define HSIC_CTRL_UTMISWRST			(0x1 << 2)
+#define HSIC_CTRL_PHYSWRST			(0x1 << 0)
+
+#define EXYNOS5_PHY_HOST_EHCICTRL		(0x30)
+
+#define HOST_EHCICTRL_ENAINCRXALIGN		(0x1 << 29)
+#define HOST_EHCICTRL_ENAINCR4			(0x1 << 28)
+#define HOST_EHCICTRL_ENAINCR8			(0x1 << 27)
+#define HOST_EHCICTRL_ENAINCR16			(0x1 << 26)
+
+#define EXYNOS5_PHY_HOST_OHCICTRL		(0x34)
+
+#define HOST_OHCICTRL_SUSPLGCY			(0x1 << 3)
+#define HOST_OHCICTRL_APPSTARTCLK		(0x1 << 2)
+#define HOST_OHCICTRL_CNTSEL			(0x1 << 1)
+#define HOST_OHCICTRL_CLKCKTRST			(0x1 << 0)
+
+#define EXYNOS5_PHY_OTG_SYS			(0x38)
+
+#define OTG_SYS_PHYLINK_SWRESET			(0x1 << 14)
+#define OTG_SYS_LINKSWRST_UOTG			(0x1 << 13)
+#define OTG_SYS_PHY0_SWRST			(0x1 << 12)
+
+#define OTG_SYS_REFCLKSEL_MASK			(0x3 << 9)
+#define OTG_SYS_REFCLKSEL_XTAL			(0x0 << 9)
+#define OTG_SYS_REFCLKSEL_EXTL			(0x1 << 9)
+#define OTG_SYS_REFCLKSEL_CLKCORE		(0x2 << 9)
+
+#define OTG_SYS_IDPULLUP_UOTG			(0x1 << 8)
+#define OTG_SYS_COMMON_ON			(0x1 << 7)
+
+#define OTG_SYS_FSEL_MASK			(0x7 << 4)
+#define OTG_SYS_FSEL(_x)			((_x) << 4)
+
+#define OTG_SYS_FORCESLEEP			(0x1 << 3)
+#define OTG_SYS_OTGDISABLE			(0x1 << 2)
+#define OTG_SYS_SIDDQ_UOTG			(0x1 << 1)
+#define OTG_SYS_FORCESUSPEND			(0x1 << 0)
+
+#define EXYNOS5_PHY_OTG_TUNE			(0x40)
+
 #ifndef MHZ
 #define MHZ (1000*1000)
 #endif
@@ -63,6 +161,7 @@
 enum samsung_cpu_type {
 	TYPE_S3C64XX,
 	TYPE_EXYNOS4210,
+	TYPE_EXYNOS5250,
 };
 
 /*
@@ -73,9 +172,13 @@ enum samsung_cpu_type {
  * @clk: usb phy clock
  * @regs: usb phy register memory base
  * @devctrl_reg: usb device phy-control pmu register memory base
+ * @hostctrl_reg: usb host phy-control pmu register memory base
+ * @phycfg_reg: usb2.0 phy-cfg system register memory base
  * @en_mask: enable mask
  * @ref_clk_freq: reference clock frequency selection
  * @cpu_type: machine identifier
+ * @phy_type: It keeps track of the PHY type.
+ * @host_usage: host_phy usage count.
  */
 struct samsung_usbphy {
 	struct usb_phy	phy;
@@ -84,9 +187,13 @@ struct samsung_usbphy {
 	struct clk	*clk;
 	void __iomem	*regs;
 	void __iomem	*devctrl_reg;
+	void __iomem	*hostctrl_reg;
+	void __iomem	*phycfg_reg;
 	u32		en_mask;
 	int		ref_clk_freq;
 	int		cpu_type;
+	enum samsung_usb_phy_type phy_type;
+	atomic_t	host_usage;
 };
 
 #define phy_to_sphy(x)		container_of((x), struct samsung_usbphy, phy)
@@ -96,26 +203,49 @@ static int samsung_usbphy_parse_dt_param(struct samsung_usbphy *sphy)
 	struct device_node *usb_phyctrl;
 	u32 reg;
 	int lenp;
+	int count = 0;
 
 	if (!sphy->dev->of_node) {
 		sphy->devctrl_reg = NULL;
 		return -ENODEV;
 	}
 
-	if (of_get_property(sphy->dev->of_node, "samsung,usb-phyhandle", &lenp)) {
-		usb_phyctrl = of_parse_phandle(sphy->dev->of_node,
-						"samsung,usb-phyhandle", 0);
-		if (!usb_phyctrl) {
-			dev_warn(sphy->dev, "Can't get usb-phy handle\n");
-			sphy->devctrl_reg = NULL;
-		}
-
-		of_property_read_u32(usb_phyctrl, "samsung,phyhandle-reg", &reg);
+	if (of_get_property(sphy->dev->of_node,
+			"samsung,usb-phyhandle", &lenp)) {
+		do {
+			usb_phyctrl = of_parse_phandle(sphy->dev->of_node,
+							"samsung,usb-phyhandle",
+							count++);
+			if (!usb_phyctrl) {
+				dev_warn(sphy->dev,
+					"Can't get usb-phy handle\n");
+				sphy->devctrl_reg = NULL;
+			}
+
+			of_property_read_u32(usb_phyctrl,
+					"samsung,phyhandle-reg", &reg);
+
+			/*
+			 * Considering here the maximum number of configurable
+			 * register settings: DEVICE_PHY_CONTROL
+			 *		      HOST_PHY_CONTROL
+			 *		      PHY20_CFG
+			 */
+			if (of_device_is_compatible(usb_phyctrl,
+						"samsung,usbdev-phyctrl"))
+				sphy->devctrl_reg = ioremap(reg, SZ_4);
+			else if (of_device_is_compatible(usb_phyctrl,
+						"samsung,usbhost-phyctrl"))
+				sphy->hostctrl_reg = ioremap(reg, SZ_4);
+			else if (of_device_is_compatible(usb_phyctrl,
+						"samsung,usb-phycfg"))
+				sphy->phycfg_reg = ioremap(reg, SZ_4);
+
+			of_property_read_u32(sphy->dev->of_node,
+					"samsung,enable-mask", &sphy->en_mask);
+		} while (of_parse_phandle(sphy->dev->of_node,
+				"samsung,usb-phyhandle", count));
 
-		sphy->devctrl_reg = ioremap(reg, SZ_4);
-
-		of_property_read_u32(sphy->dev->of_node, "samsung,enable-mask",
-							&sphy->en_mask);
 		of_node_put(usb_phyctrl);
 	} else {
 		dev_warn(sphy->dev, "Can't get usb-phy handle\n");
@@ -129,13 +259,18 @@ static int samsung_usbphy_parse_dt_param(struct samsung_usbphy *sphy)
  * Set isolation here for phy.
  * SOCs control this by controlling corresponding PMU registers
  */
-static void samsung_usbphy_set_isolation(struct samsung_usbphy *sphy, int on)
+static void samsung_usbphy_set_isolation(struct samsung_usbphy *sphy,
+							int on, int type)
 {
-	void __iomem *usb_phyctrl_reg;
+	void __iomem *usb_phyctrl_reg = NULL;
 	u32 en_mask = sphy->en_mask;
 	u32 reg;
 
-	usb_phyctrl_reg = sphy->devctrl_reg;
+	if (type == USB_PHY_TYPE_DEVICE) {
+		usb_phyctrl_reg = sphy->devctrl_reg;
+	} else if (type == USB_PHY_TYPE_HOST) {
+		usb_phyctrl_reg = sphy->hostctrl_reg;
+	}
 
 	if (!usb_phyctrl_reg) {
 		dev_warn(sphy->dev, "Can't set pmu isolation\n");
@@ -151,6 +286,47 @@ static void samsung_usbphy_set_isolation(struct samsung_usbphy *sphy, int on)
 }
 
 /*
+ * Configure the mode of working og usb-phy here: HOST/DEVICE.
+ * SOCs control this by controlling corresponding system register
+ */
+static void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy, int type)
+{
+	void __iomem *usb_phycfg_reg;
+	u32 en_mask = sphy->en_mask;
+	u32 reg;
+
+	usb_phycfg_reg = sphy->phycfg_reg;
+
+	if (!usb_phycfg_reg) {
+		dev_warn(sphy->dev, "Can't select specified phy mode\n");
+		return;
+	}
+
+	reg = readl(usb_phycfg_reg);
+
+	if (type == USB_PHY_TYPE_DEVICE)
+		writel(reg & ~en_mask, usb_phycfg_reg);
+	else if (type == USB_PHY_TYPE_HOST)
+		writel(reg | en_mask, usb_phycfg_reg);
+}
+
+/*
+ * PHYs are different for USB Device and USB Host. Controllers can make
+ * sure that the correct PHY type is selected by calling this function
+ * before any PHY operation.
+ */
+int samsung_usbphy_set_type(struct usb_phy *phy,
+				enum samsung_usb_phy_type phy_type)
+{
+	struct samsung_usbphy *sphy = phy_to_sphy(phy);
+
+	if (sphy->phy_type != phy_type)
+		sphy->phy_type = phy_type;
+
+	return 0;
+}
+
+/*
  * Returns reference clock frequency selection value
  */
 static int samsung_usbphy_get_refclk_freq(struct samsung_usbphy *sphy)
@@ -158,34 +334,178 @@ static int samsung_usbphy_get_refclk_freq(struct samsung_usbphy *sphy)
 	struct clk *ref_clk;
 	int refclk_freq = 0;
 
-	ref_clk = clk_get(sphy->dev, "xusbxti");
+	if (sphy->cpu_type == TYPE_EXYNOS5250)
+		ref_clk = clk_get(sphy->dev, "ext_xtal");
+	else
+		ref_clk = clk_get(sphy->dev, "xusbxti");
 	if (IS_ERR(ref_clk)) {
 		dev_err(sphy->dev, "Failed to get reference clock\n");
 		return PTR_ERR(ref_clk);
 	}
 
-	switch (clk_get_rate(ref_clk)) {
-	case 12 * MHZ:
-		refclk_freq = PHYCLK_CLKSEL_12M;
-		break;
-	case 24 * MHZ:
-		refclk_freq = PHYCLK_CLKSEL_24M;
-		break;
-	case 48 * MHZ:
-		refclk_freq = PHYCLK_CLKSEL_48M;
-		break;
-	default:
-		if (sphy->cpu_type == TYPE_S3C64XX)
-			refclk_freq = PHYCLK_CLKSEL_48M;
-		else
+	if (sphy->cpu_type == TYPE_EXYNOS5250) {
+		/* set clock frequency for PLL */
+		switch (clk_get_rate(ref_clk)) {
+		case 96 * 100000:
+			refclk_freq |= HOST_CTRL0_FSEL_CLKSEL_9600K;
+			break;
+		case 10 * MHZ:
+			refclk_freq |= HOST_CTRL0_FSEL_CLKSEL_10M;
+			break;
+		case 12 * MHZ:
+			refclk_freq |= HOST_CTRL0_FSEL_CLKSEL_12M;
+			break;
+		case 192 * 100000:
+			refclk_freq |= HOST_CTRL0_FSEL_CLKSEL_19200K;
+			break;
+		case 20 * MHZ:
+			refclk_freq |= HOST_CTRL0_FSEL_CLKSEL_20M;
+			break;
+		case 50 * MHZ:
+			refclk_freq |= HOST_CTRL0_FSEL_CLKSEL_50M;
+			break;
+		case 24 * MHZ:
+		default:
+			/* default reference clock */
+			refclk_freq |= HOST_CTRL0_FSEL_CLKSEL_24M;
+			break;
+		}
+	} else {
+		switch (clk_get_rate(ref_clk)) {
+		case 12 * MHZ:
+			refclk_freq = PHYCLK_CLKSEL_12M;
+			break;
+		case 24 * MHZ:
 			refclk_freq = PHYCLK_CLKSEL_24M;
-		break;
+			break;
+		case 48 * MHZ:
+			refclk_freq = PHYCLK_CLKSEL_48M;
+			break;
+		default:
+			if (sphy->cpu_type == TYPE_S3C64XX)
+				refclk_freq = PHYCLK_CLKSEL_48M;
+			else
+				refclk_freq = PHYCLK_CLKSEL_24M;
+			break;
+		}
 	}
 	clk_put(ref_clk);
 
 	return refclk_freq;
 }
 
+static int exynos5_phyhost_is_on(void *regs)
+{
+	u32 reg;
+
+	reg = readl(regs + EXYNOS5_PHY_HOST_CTRL0);
+
+	return !(reg & HOST_CTRL0_SIDDQ);
+}
+
+static void samsung_exynos5_usbphy_enable(struct samsung_usbphy *sphy)
+{
+	void __iomem *regs = sphy->regs;
+	u32 phyclk = sphy->ref_clk_freq;
+	u32 phyhost;
+	u32 phyotg;
+	u32 phyhsic;
+	u32 ehcictrl;
+	u32 ohcictrl;
+
+	atomic_inc(&sphy->host_usage);
+
+	if (exynos5_phyhost_is_on(regs)) {
+		dev_info(sphy->dev, "Already power on PHY\n");
+		return;
+	}
+
+	/* Selecting Host/OTG mode; After reset USB2.0PHY_CFG: HOST */
+	samsung_usbphy_cfg_sel(sphy, USB_PHY_TYPE_HOST);
+
+	/* Host configuration */
+	phyhost = readl(regs + EXYNOS5_PHY_HOST_CTRL0);
+
+	/* phy reference clock configuration */
+	phyhost &= ~HOST_CTRL0_FSEL_MASK;
+	phyhost |= HOST_CTRL0_FSEL(phyclk);
+
+	/* host phy reset */
+	phyhost &= ~(HOST_CTRL0_PHYSWRST |
+			HOST_CTRL0_PHYSWRSTALL |
+			HOST_CTRL0_SIDDQ |
+			/* Enable normal mode of operation */
+			HOST_CTRL0_FORCESUSPEND |
+			HOST_CTRL0_FORCESLEEP);
+
+	/* Link reset */
+	phyhost |= (HOST_CTRL0_LINKSWRST |
+			HOST_CTRL0_UTMISWRST |
+			/* COMMON Block configuration during suspend */
+			HOST_CTRL0_COMMONON_N);
+	writel(phyhost, regs + EXYNOS5_PHY_HOST_CTRL0);
+	udelay(10);
+	phyhost &= ~(HOST_CTRL0_LINKSWRST |
+			HOST_CTRL0_UTMISWRST);
+	writel(phyhost, regs + EXYNOS5_PHY_HOST_CTRL0);
+
+	/* OTG configuration */
+	phyotg = readl(regs + EXYNOS5_PHY_OTG_SYS);
+
+	/* phy reference clock configuration */
+	phyotg &= ~OTG_SYS_FSEL_MASK;
+	phyotg |= OTG_SYS_FSEL(phyclk);
+
+	/* Enable normal mode of operation */
+	phyotg &= ~(OTG_SYS_FORCESUSPEND |
+			OTG_SYS_SIDDQ_UOTG |
+			OTG_SYS_FORCESLEEP |
+			OTG_SYS_REFCLKSEL_MASK |
+			/* COMMON Block configuration during suspend */
+			OTG_SYS_COMMON_ON);
+
+	/* OTG phy & link reset */
+	phyotg |= (OTG_SYS_PHY0_SWRST |
+			OTG_SYS_LINKSWRST_UOTG |
+			OTG_SYS_PHYLINK_SWRESET |
+			OTG_SYS_OTGDISABLE |
+			/* Set phy refclk */
+			OTG_SYS_REFCLKSEL_CLKCORE);
+
+	writel(phyotg, regs + EXYNOS5_PHY_OTG_SYS);
+	udelay(10);
+	phyotg &= ~(OTG_SYS_PHY0_SWRST |
+			OTG_SYS_LINKSWRST_UOTG |
+			OTG_SYS_PHYLINK_SWRESET);
+	writel(phyotg, regs + EXYNOS5_PHY_OTG_SYS);
+
+	/* HSIC phy configuration */
+	phyhsic = (HSIC_CTRL_REFCLKDIV_12 |
+			HSIC_CTRL_REFCLKSEL |
+			HSIC_CTRL_PHYSWRST);
+	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL1);
+	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL2);
+	udelay(10);
+	phyhsic &= ~HSIC_CTRL_PHYSWRST;
+	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL1);
+	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL2);
+
+	udelay(80);
+
+	/* enable EHCI DMA burst */
+	ehcictrl = readl(regs + EXYNOS5_PHY_HOST_EHCICTRL);
+	ehcictrl |= (HOST_EHCICTRL_ENAINCRXALIGN |
+				HOST_EHCICTRL_ENAINCR4 |
+				HOST_EHCICTRL_ENAINCR8 |
+				HOST_EHCICTRL_ENAINCR16);
+	writel(ehcictrl, regs + EXYNOS5_PHY_HOST_EHCICTRL);
+
+	/* set ohci_suspend_on_n */
+	ohcictrl = readl(regs + EXYNOS5_PHY_HOST_OHCICTRL);
+	ohcictrl |= HOST_OHCICTRL_SUSPLGCY;
+	writel(ohcictrl, regs + EXYNOS5_PHY_HOST_OHCICTRL);
+}
+
 static void samsung_usbphy_enable(struct samsung_usbphy *sphy)
 {
 	void __iomem *regs = sphy->regs;
@@ -221,6 +541,41 @@ static void samsung_usbphy_enable(struct samsung_usbphy *sphy)
 	writel(rstcon, regs + SAMSUNG_RSTCON);
 }
 
+static void samsung_exynos5_usbphy_disable(struct samsung_usbphy *sphy)
+{
+	void __iomem *regs = sphy->regs;
+	u32 phyhost;
+	u32 phyotg;
+	u32 phyhsic;
+
+	if (atomic_dec_return(&sphy->host_usage) > 0) {
+		dev_info(sphy->dev, "still being used\n");
+		return;
+	}
+
+	phyhsic = (HSIC_CTRL_REFCLKDIV_12 |
+			HSIC_CTRL_REFCLKSEL |
+			HSIC_CTRL_SIDDQ |
+			HSIC_CTRL_FORCESLEEP |
+			HSIC_CTRL_FORCESUSPEND);
+	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL1);
+	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL2);
+
+	phyhost = readl(regs + EXYNOS5_PHY_HOST_CTRL0);
+	phyhost |= (HOST_CTRL0_SIDDQ |
+			HOST_CTRL0_FORCESUSPEND |
+			HOST_CTRL0_FORCESLEEP |
+			HOST_CTRL0_PHYSWRST |
+			HOST_CTRL0_PHYSWRSTALL);
+	writel(phyhost, regs + EXYNOS5_PHY_HOST_CTRL0);
+
+	phyotg = readl(regs + EXYNOS5_PHY_OTG_SYS);
+	phyotg |= (OTG_SYS_FORCESUSPEND |
+			OTG_SYS_SIDDQ_UOTG |
+			OTG_SYS_FORCESLEEP);
+	writel(phyotg, regs + EXYNOS5_PHY_OTG_SYS);
+}
+
 static void samsung_usbphy_disable(struct samsung_usbphy *sphy)
 {
 	void __iomem *regs = sphy->regs;
@@ -263,10 +618,13 @@ static int samsung_usbphy_init(struct usb_phy *phy)
 	if (sphy->plat && sphy->plat->pmu_isolation)
 		sphy->plat->pmu_isolation(false);
 	else
-		samsung_usbphy_set_isolation(sphy, false);
+		samsung_usbphy_set_isolation(sphy, false, sphy->phy_type);
 
 	/* Initialize usb phy registers */
-	samsung_usbphy_enable(sphy);
+	if (sphy->cpu_type == TYPE_EXYNOS5250)
+		samsung_exynos5_usbphy_enable(sphy);
+	else
+		samsung_usbphy_enable(sphy);
 
 	/* Disable the phy clock */
 	clk_disable_unprepare(sphy->clk);
@@ -288,13 +646,16 @@ static void samsung_usbphy_shutdown(struct usb_phy *phy)
 	}
 
 	/* De-initialize usb phy registers */
-	samsung_usbphy_disable(sphy);
+	if (sphy->cpu_type == TYPE_EXYNOS5250)
+		samsung_exynos5_usbphy_disable(sphy);
+	else
+		samsung_usbphy_disable(sphy);
 
 	/* Enable phy isolation */
 	if (sphy->plat && sphy->plat->pmu_isolation)
 		sphy->plat->pmu_isolation(true);
 	else
-		samsung_usbphy_set_isolation(sphy, true);
+		samsung_usbphy_set_isolation(sphy, true, sphy->phy_type);
 
 	clk_disable_unprepare(sphy->clk);
 }
@@ -339,12 +700,6 @@ static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
 	if (!sphy)
 		return -ENOMEM;
 
-	clk = devm_clk_get(dev, "otg");
-	if (IS_ERR(clk)) {
-		dev_err(dev, "Failed to get otg clock\n");
-		return PTR_ERR(clk);
-	}
-
 	sphy->dev = &pdev->dev;
 
 	ret = samsung_usbphy_parse_dt_param(sphy);
@@ -361,7 +716,6 @@ static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
 
 	sphy->plat		= pdata;
 	sphy->regs		= phy_base;
-	sphy->clk		= clk;
 	sphy->phy.dev		= sphy->dev;
 	sphy->phy.label		= "samsung-usbphy";
 	sphy->phy.init		= samsung_usbphy_init;
@@ -371,6 +725,17 @@ static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, sphy);
 
+	if (sphy->cpu_type == TYPE_EXYNOS5250)
+		clk = devm_clk_get(dev, "usbhost");
+	else
+		clk = devm_clk_get(dev, "otg");
+	if (IS_ERR(clk)) {
+		dev_err(dev, "Failed to get otg clock\n");
+		return PTR_ERR(clk);
+	}
+
+	sphy->clk = clk;
+
 	return usb_add_phy(&sphy->phy, USB_PHY_TYPE_USB2);
 }
 
@@ -382,6 +747,10 @@ static int __exit samsung_usbphy_remove(struct platform_device *pdev)
 
 	if (sphy->devctrl_reg)
 		iounmap(sphy->devctrl_reg);
+	if (sphy->hostctrl_reg)
+		iounmap(sphy->hostctrl_reg);
+	if (sphy->phycfg_reg)
+		iounmap(sphy->phycfg_reg);
 
 	return 0;
 }
@@ -394,6 +763,9 @@ static const struct of_device_id samsung_usbphy_dt_match[] = {
 	}, {
 		.compatible = "samsung,exynos4210-usbphy",
 		.data = (void *)TYPE_EXYNOS4210,
+	}, {
+		.compatible = "samsung,exynos5250-usbphy",
+		.data = (void *)TYPE_EXYNOS5250,
 	},
 	{},
 };
@@ -407,6 +779,9 @@ static struct platform_device_id samsung_usbphy_driver_ids[] = {
 	}, {
 		.name		= "exynos4210-usbphy",
 		.driver_data	= TYPE_EXYNOS4210,
+	}, {
+		.name		= "exynos5250-usbphy",
+		.driver_data	= TYPE_EXYNOS5250,
 	},
 	{},
 };
diff --git a/include/linux/usb/samsung_usb_phy.h b/include/linux/usb/samsung_usb_phy.h
index 9167826..aecefaf 100644
--- a/include/linux/usb/samsung_usb_phy.h
+++ b/include/linux/usb/samsung_usb_phy.h
@@ -10,7 +10,20 @@
  * option) any later version.
  */
 
+#include <linux/usb/phy.h>
+
 enum samsung_usb_phy_type {
 	USB_PHY_TYPE_DEVICE,
 	USB_PHY_TYPE_HOST,
 };
+
+#ifdef CONFIG_SAMSUNG_USBPHY
+extern int samsung_usbphy_set_type(struct usb_phy *phy,
+				enum samsung_usb_phy_type phy_type);
+#else
+static inline int samsung_usbphy_set_type(struct usb_phy *phy,
+				enum samsung_usb_phy_type phy_type)
+{
+	return 0;
+}
+#endif /* CONFIG_SAMSUNG_USBPHY */
-- 
1.7.6.5

