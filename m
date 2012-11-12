Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2KLPAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 10:00:37 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:34565 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752097Ab2KLPAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 10:00:36 -0500
From: Per Forlin <per.forlin@stericsson.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>, <lee.jones@linaro.org>,
        <fredrik.soderstedt@stericsson.com>
Cc: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Per Forlin <per.forlin@stericsson.com>
Subject: [PATCH] dt: platform: Extract device name from device tree blob
Date: Mon, 12 Nov 2012 15:59:03 +0100
Message-ID: <1352732343-1199-1-git-send-email-per.forlin@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to extract device name from device tree blob.
If the property "dev-name" is set in the DTS this name will
be used when creating the device.
The auxdata_lookup has precedence and will override
the "dev-name" property.

Adding support to parse DTS "dev-name" will make it possible to
replace these kind of structures with a dev-name in the DTS.
OF_DEV_AUXDATA("compatible", BASE_ADDRESS, "dev-name", NULL)

Examples
OF_DEV_AUXDATA("marvell,orion-spi", 0xf1010600, "orion_spi.0", NULL),
OF_DEV_AUXDATA("marvell,mv64xxx-i2c", 0xf1011000, "mv64xxx_i2c.0",
OF_DEV_AUXDATA("marvell,orion-sata", 0xf10a0000, "sata_mv.0", NULL),
OF_DEV_AUXDATA("marvell,dove-sdhci", 0xf1092000, "sdhci-dove.0", NULL),
OF_DEV_AUXDATA("arm,pl330", EXYNOS4_PA_PDMA0, "dma-pl330.0", NULL),
OF_DEV_AUXDATA("arm,pl330", EXYNOS5_PA_PDMA0, "dma-pl330.0", NULL),
OF_DEV_AUXDATA("fsl,imx27-uart", MX27_UART1_BASE_ADDR, "imx21-uart.0", NULL),
OF_DEV_AUXDATA("fsl,imx27-fec", MX27_FEC_BASE_ADDR, "imx27-fec.0", NULL),
OF_DEV_AUXDATA("fsl,imx27-i2c", MX27_I2C1_BASE_ADDR, "imx-i2c.0", NULL),
OF_DEV_AUXDATA("fsl,imx27-cspi", MX27_CSPI1_BASE_ADDR, "imx27-cspi.0", NULL),
OF_DEV_AUXDATA("fsl,imx27-wdt", MX27_WDOG_BASE_ADDR, "imx2-wdt.0", NULL),
OF_DEV_AUXDATA("fsl,imx27-nand", MX27_NFC_BASE_ADDR, "mxc_nand.0", NULL),
OF_DEV_AUXDATA("fsl,imx51-uart", MX51_UART1_BASE_ADDR, "imx21-uart.0", NULL),
OF_DEV_AUXDATA("fsl,imx51-fec", MX51_FEC_BASE_ADDR, "imx27-fec.0", NULL),
OF_DEV_AUXDATA("fsl,imx51-esdhc", MX51_ESDHC1_BASE_ADDR, "sdhci-esdhc-imx51.0", NULL),
OF_DEV_AUXDATA("fsl,imx51-ecspi", MX51_ECSPI1_BASE_ADDR, "imx51-ecspi.0", NULL),
OF_DEV_AUXDATA("fsl,imx51-cspi", MX51_CSPI_BASE_ADDR, "imx35-cspi.0", NULL),
OF_DEV_AUXDATA("fsl,imx51-i2c", MX51_I2C1_BASE_ADDR, "imx-i2c.0", NULL),
OF_DEV_AUXDATA("fsl,imx51-wdt", MX51_WDOG1_BASE_ADDR, "imx2-wdt.0", NULL),
OF_DEV_AUXDATA("fsl,imx53-uart", MX53_UART1_BASE_ADDR, "imx21-uart.0", NULL),
OF_DEV_AUXDATA("fsl,imx53-fec", MX53_FEC_BASE_ADDR, "imx25-fec.0", NULL),
OF_DEV_AUXDATA("fsl,imx53-esdhc", MX53_ESDHC1_BASE_ADDR, "sdhci-esdhc-imx53.0", NULL),
OF_DEV_AUXDATA("fsl,imx53-ecspi", MX53_ECSPI1_BASE_ADDR, "imx51-ecspi.0", NULL),
OF_DEV_AUXDATA("fsl,imx53-cspi", MX53_CSPI_BASE_ADDR, "imx35-cspi.0", NULL),
OF_DEV_AUXDATA("fsl,imx53-i2c", MX53_I2C1_BASE_ADDR, "imx-i2c.0", NULL),
OF_DEV_AUXDATA("fsl,imx53-wdt", MX53_WDOG1_BASE_ADDR, "imx2-wdt.0", NULL),
OF_DEV_AUXDATA("marvell,orion-spi", 0xf1010600, "orion_spi.0", NULL),
OF_DEV_AUXDATA("marvell,mv64xxx-i2c", 0xf1011000, "mv64xxx_i2c.0",
OF_DEV_AUXDATA("marvell,orion-sata", 0xf1080000, "sata_mv.0", NULL),
OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.0", NULL),
OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0", NULL),
OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.0", NULL),
OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0", NULL),
OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4030000, "pxa2xx-uart.0", NULL),
OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0", NULL),
OF_DEV_AUXDATA("mrvl,pxa-uart",		0x40100000, "pxa2xx-uart.0", NULL),
OF_DEV_AUXDATA("marvell,pxa-mmc",	0x41100000, "pxa2xx-mci.0", NULL),
OF_DEV_AUXDATA("mrvl,pxa-i2c",		0x40301680, "pxa2xx-i2c.0", NULL),
OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC1_BASE, "sdhci-tegra.0", NULL),
OF_DEV_AUXDATA("nvidia,tegra20-i2c", TEGRA_I2C_BASE, "tegra-i2c.0", NULL),
OF_DEV_AUXDATA("nvidia,tegra20-i2s", TEGRA_I2S1_BASE, "tegra20-i2s.0", NULL),
OF_DEV_AUXDATA("nvidia,tegra20-ehci", TEGRA_USB_BASE, "tegra-ehci.0",
OF_DEV_AUXDATA("nvidia,tegra20-sdhci", 0x78000000, "sdhci-tegra.0", NULL),
OF_DEV_AUXDATA("nvidia,tegra20-i2c", 0x7000C000, "tegra-i2c.0", NULL),
OF_DEV_AUXDATA("st,nomadik-gpio", 0x8012e000, "gpio.0", NULL),
OF_DEV_AUXDATA("st,nomadik-i2c", 0x80004000, "nmk-i2c.0", NULL),

Signed-off-by: Per Forlin <per.forlin@stericsson.com>
---
 drivers/of/platform.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 9600480..999ee95 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -169,6 +169,8 @@ struct platform_device *of_device_alloc(struct device_node *np,
 
 	if (bus_id)
 		dev_set_name(&dev->dev, "%s", bus_id);
+	else if (of_property_read_string(np, "dev-name", &bus_id) == 0)
+		dev_set_name(&dev->dev, "%s", bus_id);
 	else
 		of_device_make_bus_id(&dev->dev);
 
@@ -264,6 +266,8 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
 	dev->dev.platform_data = platform_data;
 	if (bus_id)
 		dev_set_name(&dev->dev, "%s", bus_id);
+	else if (of_property_read_string(node, "dev-name", &bus_id) == 0)
+		dev_set_name(&dev->dev, "%s", bus_id);
 	else
 		of_device_make_bus_id(&dev->dev);
 
-- 
1.7.11.3

