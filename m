Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab2LUIKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 03:10:33 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:31394 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab2LUIK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 03:10:28 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-6f-50d4194da081
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        sylvester.nawrocki@gmail.com, thomas.abraham@linaro.org,
        t.figa@samsung.com, ben-linux@fluff.org,
        broonie@opensource.wolfsonmicro.com, l.majewski@samsung.com,
        kyungmin.park@samsung.com, grant.likely@secretlab.ca, heiko@sntech.de,
        dianders@chromium.org, p.paneri@samsung.com
Subject: [PATCH v3] usb: phy: samsung: Add support to set pmu isolation
Date: Fri, 21 Dec 2012 13:46:19 +0530
Message-id: <1356077779-5759-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1356077779-5759-1-git-send-email-gautam.vivek@samsung.com>
References: <1356077779-5759-1-git-send-email-gautam.vivek@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWyRsSkTtdX8kqAwax2BYvLu+awWcw4v4/J
	YtGyVmYHZo/Pm+QCGKO4bFJSczLLUov07RK4MlZ0f2cqaPKv+HMyooHxr30XIyeHhICJxP7j
	a1ggbDGJC/fWs3UxcnEICSxllLg39S87TNGLCfNZIRLTGSXeXfvLAuFMZpI4v+8mI0gVm4Cu
	RNPbXWC2iICsxOErv5lBipgF3jFLdO96ywySEBZwl3jx4RpQNwcHi4CqxPKvJSBhXqDwqiU/
	WCG2KUi8uf0MrJxTwENi1vsLYDOFgGo2NK1iA7FZBAQkvk0+BDZGAmjXpgNgqyQE7rNJTPj9
	gxlijqTEwRU3WCYwCi9gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERiWp/89k9rBuLLB
	4hCjAAejEg8vo9nlACHWxLLiytxDjBIczEoivExfgUK8KYmVValF+fFFpTmpxYcYfYAumcgs
	JZqcD4yZvJJ4Q2MTc1NjU0sjIzNTUxzCSuK8zR4pAUIC6YklqdmpqQWpRTDjmDg4pRoYlZJu
	dVvEdv0smSaw1vvNsReKAuVnvvjcTsm5veVVaRF/xNlu91q2CRPe3Tj+TD/I/Hh0dGedyied
	S883PYx6KLRUzuH6G+flffPXnDfeMlnswsv4BIYtm1Mm52vphuh9nlP1LO5Gf8Ht1Qzc++d/
	kKlO3CPDGcIncoPzRYmtYGXnlPAPc3YvVWIpzkg01GIuKk4EAFPMT+t4AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t9jQV1fySsBBvsPilpc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ixovs7
	U0GTf8WfkxENjH/tuxg5OSQETCReTJjPCmGLSVy4t56ti5GLQ0hgOqPEu2t/WSCcyUwS5/fd
	ZASpYhPQlWh6uwvMFhGQlTh85TczSBGzwDtmie5db5lBEsIC7hIvPlwD6ubgYBFQlVj+tQQk
	zAsUXrXkB9Q2BYk3t5+BlXMKeEjMen8BbKYQUM2GplVsExh5FzAyrGIUTS1ILihOSs811CtO
	zC0uzUvXS87P3cQIDvpnUjsYVzZYHGIU4GBU4uFlNLscIMSaWFZcmXuIUYKDWUmEl+krUIg3
	JbGyKrUoP76oNCe1+BCjD9BRE5mlRJPzgRGZVxJvaGxibmpsamliYWJmiUNYSZy32SMlQEgg
	PbEkNTs1tSC1CGYcEwenVAPjEpv/CWxn9i+5prDF+na2bzLDJJPY/lmr3jv5ZaoxP3MKulW2
	5rhtZlvGnYk/jQ7+9anUbU8MXmD5e/WzmuXvbPZ+rF1wQ+y7r/feV9y/sqwWnvUJM/p4/KjE
	0b153lFcNkKH/n9fIXROLnJro2LojX73ifYvrh+5zZZq9/qayKe3YfPcT70VUGIpzkg01GIu
	Kk4EAAGlIpqnAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to parse device node data in order to get
required properties to set pmu isolation for usb-phy.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 .../devicetree/bindings/usb/samsung-usbphy.txt     |   28 ++++
 drivers/usb/phy/samsung-usbphy.c                   |  145 +++++++++++++++++---
 2 files changed, 152 insertions(+), 21 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
index 7b26e2d..09f06f8 100644
--- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
+++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
@@ -9,3 +9,31 @@ Required properties:
 - compatible : should be "samsung,exynos4210-usbphy"
 - reg : base physical address of the phy registers and length of memory mapped
 	region.
+- #address-cells: should be 1.
+- #size-cells: should be 0.
+
+Optional properties:
+- The samsung usbphy nodes should provide the following information required
+  by USB-phy controller to enable/disable the phy controller.
+   - reg : base physical address of PHY control register in PMU which
+           enables/disables the phy controller.
+           The size of this register is the total sum of size of all phy-control
+           registers that the SoC has. For example, the size will be
+           '0x4' in case we have only one phy-control register (like in S3C64XX) or
+           '0x8' in case we have two phy-control registers (like in Exynos4210)
+           and so on.
+
+Example:
+ - Exysno4210
+
+	usbphy@125B0000 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "samsung,exynos4210-usbphy";
+		reg = <0x125B0000 0x100>;
+
+		usbphy-pmu {
+			/* USB device and host PHY_CONTROL registers */
+			reg = <0x10020704 0x8>;
+		};
+	};
diff --git a/drivers/usb/phy/samsung-usbphy.c b/drivers/usb/phy/samsung-usbphy.c
index 5c5e1bb5..2260029 100644
--- a/drivers/usb/phy/samsung-usbphy.c
+++ b/drivers/usb/phy/samsung-usbphy.c
@@ -60,20 +60,43 @@
 #define MHZ (1000*1000)
 #endif
 
+#define S3C64XX_USBPHY_ENABLE			(0x1 << 16)
+#define EXYNOS_USBPHY_ENABLE			(0x1 << 0)
+
 enum samsung_cpu_type {
 	TYPE_S3C64XX,
 	TYPE_EXYNOS4210,
 };
 
 /*
+ * struct samsung_usbphy_drvdata - driver data for various SoC variants
+ * @cpu_type: machine identifier
+ * @devphy_en_mask: device phy enable mask for PHY CONTROL register
+ * @hostphy_en_mask: host phy enable mask for PHY CONTROL register
+ *
+ *	having different mask for host and device type phy
+ *	helps in setting independent masks in case of SoCs like
+ *	S5PV210 in which PHY0 and PHY1 enable bits belong to same
+ *	register placed at [0] and [1] respectively.
+ *	Although for newer SoCs like exynos these bits belong to
+ *	different registers altogether placed at [0].
+ */
+struct samsung_usbphy_drvdata {
+	int cpu_type;
+	int devphy_en_mask;
+	int hostphy_en_mask;
+};
+
+/*
  * struct samsung_usbphy - transceiver driver state
  * @phy: transceiver structure
  * @plat: platform data
  * @dev: The parent device supplied to the probe function
  * @clk: usb phy clock
  * @regs: usb phy register memory base
+ * @phyctrl_pmureg: usb device phy-control pmu register memory base
  * @ref_clk_freq: reference clock frequency selection
- * @cpu_type: machine identifier
+ * @drv_data: driver data available for different cpu types
  */
 struct samsung_usbphy {
 	struct usb_phy	phy;
@@ -81,12 +104,66 @@ struct samsung_usbphy {
 	struct device	*dev;
 	struct clk	*clk;
 	void __iomem	*regs;
+	void __iomem	*phyctrl_pmureg;
 	int		ref_clk_freq;
-	int		cpu_type;
+	struct samsung_usbphy_drvdata *drv_data;
 };
 
 #define phy_to_sphy(x)		container_of((x), struct samsung_usbphy, phy)
 
+static int samsung_usbphy_parse_dt_param(struct samsung_usbphy *sphy)
+{
+	struct device_node *usbphy_pmu;
+	u32 reg[2];
+	int ret;
+
+	if (!sphy->dev->of_node) {
+		dev_err(sphy->dev, "Can't get usb-phy node\n");
+		return -ENODEV;
+	}
+
+	usbphy_pmu = of_get_child_by_name(sphy->dev->of_node, "usbphy-pmu");
+	if (!usbphy_pmu)
+		dev_warn(sphy->dev, "Can't get usb-phy pmu control node\n");
+
+	ret = of_property_read_u32_array(usbphy_pmu, "reg", reg, 2);
+	if (!ret)
+		sphy->phyctrl_pmureg = ioremap(reg[0], reg[1]);
+
+	of_node_put(usbphy_pmu);
+
+	if (IS_ERR_OR_NULL(sphy->phyctrl_pmureg)) {
+		dev_err(sphy->dev, "Can't get usb-phy pmu control register\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+/*
+ * Set isolation here for phy.
+ * SOCs control this by controlling corresponding PMU registers
+ */
+static void samsung_usbphy_set_isolation(struct samsung_usbphy *sphy, int on)
+{
+	u32 reg;
+	int en_mask;
+
+	if (!sphy->phyctrl_pmureg) {
+		dev_warn(sphy->dev, "Can't set pmu isolation\n");
+		return;
+	}
+
+	reg = readl(sphy->phyctrl_pmureg);
+
+	en_mask = sphy->drv_data->devphy_en_mask;
+
+	if (on)
+		writel(reg & ~en_mask, sphy->phyctrl_pmureg);
+	else
+		writel(reg | en_mask, sphy->phyctrl_pmureg);
+}
+
 /*
  * Returns reference clock frequency selection value
  */
@@ -112,7 +189,7 @@ static int samsung_usbphy_get_refclk_freq(struct samsung_usbphy *sphy)
 		refclk_freq = PHYCLK_CLKSEL_48M;
 		break;
 	default:
-		if (sphy->cpu_type == TYPE_S3C64XX)
+		if (sphy->drv_data->cpu_type == TYPE_S3C64XX)
 			refclk_freq = PHYCLK_CLKSEL_48M;
 		else
 			refclk_freq = PHYCLK_CLKSEL_24M;
@@ -135,7 +212,7 @@ static void samsung_usbphy_enable(struct samsung_usbphy *sphy)
 	phypwr = readl(regs + SAMSUNG_PHYPWR);
 	rstcon = readl(regs + SAMSUNG_RSTCON);
 
-	switch (sphy->cpu_type) {
+	switch (sphy->drv_data->cpu_type) {
 	case TYPE_S3C64XX:
 		phyclk &= ~PHYCLK_COMMON_ON_N;
 		phypwr &= ~PHYPWR_NORMAL_MASK;
@@ -165,7 +242,7 @@ static void samsung_usbphy_disable(struct samsung_usbphy *sphy)
 
 	phypwr = readl(regs + SAMSUNG_PHYPWR);
 
-	switch (sphy->cpu_type) {
+	switch (sphy->drv_data->cpu_type) {
 	case TYPE_S3C64XX:
 		phypwr |= PHYPWR_NORMAL_MASK;
 		break;
@@ -199,6 +276,8 @@ static int samsung_usbphy_init(struct usb_phy *phy)
 	/* Disable phy isolation */
 	if (sphy->plat && sphy->plat->pmu_isolation)
 		sphy->plat->pmu_isolation(false);
+	else
+		samsung_usbphy_set_isolation(sphy, false);
 
 	/* Initialize usb phy registers */
 	samsung_usbphy_enable(sphy);
@@ -228,38 +307,37 @@ static void samsung_usbphy_shutdown(struct usb_phy *phy)
 	/* Enable phy isolation */
 	if (sphy->plat && sphy->plat->pmu_isolation)
 		sphy->plat->pmu_isolation(true);
+	else
+		samsung_usbphy_set_isolation(sphy, true);
 
 	clk_disable_unprepare(sphy->clk);
 }
 
 static const struct of_device_id samsung_usbphy_dt_match[];
 
-static inline int samsung_usbphy_get_driver_data(struct platform_device *pdev)
+static inline struct samsung_usbphy_drvdata
+*samsung_usbphy_get_driver_data(struct platform_device *pdev)
 {
 	if (pdev->dev.of_node) {
 		const struct of_device_id *match;
 		match = of_match_node(samsung_usbphy_dt_match,
 							pdev->dev.of_node);
-		return (int) match->data;
+		return (struct samsung_usbphy_drvdata *) match->data;
 	}
 
-	return platform_get_device_id(pdev)->driver_data;
+	return ((struct samsung_usbphy_drvdata *)
+				platform_get_device_id(pdev)->driver_data);
 }
 
 static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
 {
 	struct samsung_usbphy *sphy;
-	struct samsung_usbphy_data *pdata;
+	struct samsung_usbphy_data *pdata = pdev->dev.platform_data;
 	struct device *dev = &pdev->dev;
 	struct resource *phy_mem;
 	void __iomem	*phy_base;
 	struct clk *clk;
-
-	pdata = pdev->dev.platform_data;
-	if (!pdata) {
-		dev_err(&pdev->dev, "%s: no platform data defined\n", __func__);
-		return -EINVAL;
-	}
+	int ret;
 
 	phy_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!phy_mem) {
@@ -283,7 +361,19 @@ static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
 		return PTR_ERR(clk);
 	}
 
-	sphy->dev		= &pdev->dev;
+	sphy->dev = dev;
+
+	if (dev->of_node) {
+		ret = samsung_usbphy_parse_dt_param(sphy);
+		if (ret < 0)
+			return ret;
+	} else {
+		if (!pdata) {
+			dev_err(dev, "no platform data specified\n");
+			return -EINVAL;
+		}
+	}
+
 	sphy->plat		= pdata;
 	sphy->regs		= phy_base;
 	sphy->clk		= clk;
@@ -291,7 +381,7 @@ static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
 	sphy->phy.label		= "samsung-usbphy";
 	sphy->phy.init		= samsung_usbphy_init;
 	sphy->phy.shutdown	= samsung_usbphy_shutdown;
-	sphy->cpu_type		= samsung_usbphy_get_driver_data(pdev);
+	sphy->drv_data		= samsung_usbphy_get_driver_data(pdev);
 	sphy->ref_clk_freq	= samsung_usbphy_get_refclk_freq(sphy);
 
 	platform_set_drvdata(pdev, sphy);
@@ -305,17 +395,30 @@ static int __exit samsung_usbphy_remove(struct platform_device *pdev)
 
 	usb_remove_phy(&sphy->phy);
 
+	if (sphy->phyctrl_pmureg)
+		iounmap(sphy->phyctrl_pmureg);
+
 	return 0;
 }
 
+static struct samsung_usbphy_drvdata usbphy_s3c64xx = {
+	.cpu_type		= TYPE_S3C64XX,
+	.devphy_en_mask		= S3C64XX_USBPHY_ENABLE,
+};
+
+static struct samsung_usbphy_drvdata usbphy_exynos4 = {
+	.cpu_type		= TYPE_EXYNOS4210,
+	.devphy_en_mask		= EXYNOS_USBPHY_ENABLE,
+};
+
 #ifdef CONFIG_OF
 static const struct of_device_id samsung_usbphy_dt_match[] = {
 	{
 		.compatible = "samsung,s3c64xx-usbphy",
-		.data = (void *)TYPE_S3C64XX,
+		.data = (void *)&usbphy_s3c64xx,
 	}, {
 		.compatible = "samsung,exynos4210-usbphy",
-		.data = (void *)TYPE_EXYNOS4210,
+		.data = (void *)&usbphy_exynos4,
 	},
 	{},
 };
@@ -325,10 +428,10 @@ MODULE_DEVICE_TABLE(of, samsung_usbphy_dt_match);
 static struct platform_device_id samsung_usbphy_driver_ids[] = {
 	{
 		.name		= "s3c64xx-usbphy",
-		.driver_data	= TYPE_S3C64XX,
+		.driver_data	= (unsigned long)&usbphy_s3c64xx,
 	}, {
 		.name		= "exynos4210-usbphy",
-		.driver_data	= TYPE_EXYNOS4210,
+		.driver_data	= (unsigned long)&usbphy_exynos4,
 	},
 	{},
 };
-- 
1.7.6.5

