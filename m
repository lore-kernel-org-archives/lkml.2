Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab2LZMZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 07:25:17 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17954 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab2LZMZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 07:25:13 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-36-50daeca8fbff
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
Subject: [PATCH v4] usb: phy: samsung: Add support to set pmu isolation
Date: Wed, 26 Dec 2012 17:58:32 +0530
Message-id: <1356524912-4736-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1356524912-4736-1-git-send-email-gautam.vivek@samsung.com>
References: <1356524912-4736-1-git-send-email-gautam.vivek@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsWyRsSkTnfFm1sBBreOCVlc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjFZZOSmpNZllqkb5fAlXHj51vWgkkBFTNautkaGO87dDFyckgImEi8
	mrSbHcIWk7hwbz1bFyMXh5DAUkaJvV8fM8EULWvaB5VYxCjxd80KZghnMpPE8snnGUGq2AR0
	JZre7gKzRQRkJQ5f+Q1WxCzwjlmie9dbZpCEsIC7xJGdJ8D2sQioSpz+9ApsBS9QfPKlJ1Dr
	FCTe3H4GVs8p4CEx8eJ8sHohoJr1T5rYIHoFJL5NPsTSxcgBVC8rsekA2C4JgftsEj2f3rNC
	zJGUOLjiBssERuEFjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MQJD8/S/Z1I7GFc2WBxi
	FOBgVOLh3fj9ZoAQa2JZcWXuIUYJDmYlEV6FVbcChHhTEiurUovy44tKc1KLDzH6AF0ykVlK
	NDkfGDd5JfGGxibmpsamlkZGZqamOISVxHmbPVIChATSE0tSs1NTC1KLYMYxcXBKNTCumOL7
	Lzfm7YP1ovmes65t9+9Uj/k1TTrYujVNeZLs/ZemF5nsj7Ff+hJy8fHh2T3ujcLOZoETe6t/
	vf26sXbN264Utl+hiv9+Srgz/G3TWX7pieg67ilJJZ+M9kz+2fKFY8aug7JHeXesvrvCS2/l
	e/+wyJhn069d4t6bzFoVYfojJtx9u32bEktxRqKhFnNRcSIAIApd03oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jAd0Vb24FGJyItLi8aw6bxYzz+5gs
	Fi1rZXZg9vi8SS6AMaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfV
	VsnFJ0DXLTMHaLySQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMePGz7es
	BZMCKma0dLM1MN536GLk5JAQMJFY1rSPDcIWk7hwbz2QzcUhJLCIUeLvmhXMEM5kJonlk88z
	glSxCehKNL3dBWaLCMhKHL7yG6yIWeAds0T3rrfMIAlhAXeJIztPsIPYLAKqEqc/vWICsXmB
	4pMvPWGCWKcg8eb2M7B6TgEPiYkX54PVCwHVrH/SxDaBkXcBI8MqRtHUguSC4qT0XEO94sTc
	4tK8dL3k/NxNjOCwfya1g3Flg8UhRgEORiUe3o3fbwYIsSaWFVfmHmKU4GBWEuFVWHUrQIg3
	JbGyKrUoP76oNCe1+BCjD9BVE5mlRJPzgTGZVxJvaGxibmpsamliYWJmiUNYSZy32SMlQEgg
	PbEkNTs1tSC1CGYcEwenVAPjupjrgRXnGpz8eCcv8dJbpuHR/sB3x9npNvZMXFIHw05W/FyZ
	x6daIFyztOeGhXN+uK+5WK6M0Z7TDduEEr72zPH2ENJONVuXe3PyVGvjwqw7gWukDwcxWe3V
	XSq6vsX2vPOGmrZ1i7j4km/r2a85k6/zpSZke+j204WqjzrOtG0wVj3ZqKHEUpyRaKjFXFSc
	CADIZ7g5qAIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to parse device node data in order to get
required properties to set pmu isolation for usb-phy.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 .../devicetree/bindings/usb/samsung-usbphy.txt     |   31 ++++
 drivers/usb/phy/samsung-usbphy.c                   |  145 +++++++++++++++++---
 2 files changed, 155 insertions(+), 21 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
index 7b26e2d..6b873fd 100644
--- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
+++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
@@ -9,3 +9,34 @@ Required properties:
 - compatible : should be "samsung,exynos4210-usbphy"
 - reg : base physical address of the phy registers and length of memory mapped
 	region.
+
+Optional properties:
+- #address-cells: should be '1' when usbphy node has a child node with 'reg'
+		  property.
+- #size-cells: should be '1' when usbphy node has a child node with 'reg'
+	       property.
+
+- The child node 'usbphy-pmu' to the node usbphy should provide the following
+  information required by usb-phy controller to enable/disable the phy.
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
index 5c5e1bb5..b9f4f42 100644
--- a/drivers/usb/phy/samsung-usbphy.c
+++ b/drivers/usb/phy/samsung-usbphy.c
@@ -60,20 +60,42 @@
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
+ *
+ *	Here we have a separate mask for device type phy.
+ *	Having different masks for host and device type phy helps
+ *	in setting independent masks in case of SoCs like S5PV210,
+ *	in which PHY0 and PHY1 enable bits belong to same register
+ *	placed at [0] and [1] respectively.
+ *	Although for newer SoCs like exynos these bits belong to
+ *	different registers altogether placed at [0].
+ */
+struct samsung_usbphy_drvdata {
+	int cpu_type;
+	int devphy_en_mask;
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
@@ -81,12 +103,67 @@ struct samsung_usbphy {
 	struct device	*dev;
 	struct clk	*clk;
 	void __iomem	*regs;
+	void __iomem	*phyctrl_pmureg;
 	int		ref_clk_freq;
-	int		cpu_type;
+	const struct samsung_usbphy_drvdata *drv_data;
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
+	ret = of_property_read_u32_array(usbphy_pmu, "reg", reg,
+						ARRAY_SIZE(reg));
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
+	return (struct samsung_usbphy_drvdata *)
+				platform_get_device_id(pdev)->driver_data;
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
 
+static const struct samsung_usbphy_drvdata usbphy_s3c64xx = {
+	.cpu_type		= TYPE_S3C64XX,
+	.devphy_en_mask		= S3C64XX_USBPHY_ENABLE,
+};
+
+static const struct samsung_usbphy_drvdata usbphy_exynos4 = {
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

