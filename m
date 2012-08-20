Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab2HTOJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:09:43 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37760 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab2HTOJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:09:40 -0400
From: Prabhakar Lad <prabhakar.lad@ti.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>, Sekhar Nori <nsekhar@ti.com>
Subject: [PATCH v2 1/2] ARM: da850/omap-l138: Add SoC related definitions for VPIF
Date: Mon, 20 Aug 2012 19:38:50 +0530
Message-ID: <1345471731-31678-2-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1345471731-31678-1-git-send-email-prabhakar.lad@ti.com>
References: <1345471731-31678-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

Add clock, pin mux definitions and registration function for
VPIF capture and display driver on DA850/OMAP-L138 SoC.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
---
 arch/arm/mach-davinci/da850.c              |  162 ++++++++++++++++++++++++++++
 arch/arm/mach-davinci/include/mach/da8xx.h |   11 ++
 arch/arm/mach-davinci/include/mach/mux.h   |   42 +++++++
 arch/arm/mach-davinci/include/mach/psc.h   |    1 +
 4 files changed, 216 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index b44dc84..76e434a 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -347,6 +347,13 @@ static struct clk spi1_clk = {
 	.flags		= DA850_CLK_ASYNC3,
 };
 
+static struct clk vpif_clk = {
+	.name		= "vpif",
+	.parent		= &pll0_sysclk2,
+	.lpsc		= DA850_LPSC1_VPIF,
+	.gpsc		= 1,
+};
+
 static struct clk sata_clk = {
 	.name		= "sata",
 	.parent		= &pll0_sysclk2,
@@ -397,6 +404,7 @@ static struct clk_lookup da850_clks[] = {
 	CLK(NULL,		"usb20",	&usb20_clk),
 	CLK("spi_davinci.0",	NULL,		&spi0_clk),
 	CLK("spi_davinci.1",	NULL,		&spi1_clk),
+	CLK("vpif",		NULL,		&vpif_clk),
 	CLK("ahci",		NULL,		&sata_clk),
 	CLK(NULL,		NULL,		NULL),
 };
@@ -573,6 +581,46 @@ static const struct mux_config da850_pins[] = {
 	MUX_CFG(DA850, GPIO6_10,	13,	20,	15,	8,	false)
 	MUX_CFG(DA850, GPIO6_13,	13,	8,	15,	8,	false)
 	MUX_CFG(DA850, RTC_ALARM,	0,	28,	15,	2,	false)
+	/* VPIF Capture */
+	MUX_CFG(DA850, VPIF_DIN0,	15,	4,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DIN1,	15,	0,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DIN2,	14,	28,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DIN3,	14,	24,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DIN4,	14,	20,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DIN5,	14,	16,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DIN6,	14,	12,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DIN7,	14,	8,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DIN8,	16,	4,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DIN9,	16,	0,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DIN10,	15,	28,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DIN11,	15,	24,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DIN12,	15,	20,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DIN13,	15,	16,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DIN14,	15,	12,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DIN15,	15,	8,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_CLKIN0,	14,	0,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_CLKIN1,	14,	4,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_CLKIN2,	19,	8,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_CLKIN3,	19,	16,	15,	1,	false)
+	/* VPIF Display */
+	MUX_CFG(DA850, VPIF_DOUT0,	17,	4,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DOUT1,	17,	0,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DOUT2,	16,	28,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DOUT3,	16,	24,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DOUT4,	16,	20,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DOUT5,	16,	16,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DOUT6,	16,	12,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DOUT7,	16,	8,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DOUT8,	18,	4,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DOUT9,	18,	0,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DOUT10,	17,	28,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DOUT11,	17,	24,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DOUT12,	17,	20,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DOUT13,	17,	16,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DOUT14,	17,	12,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_DOUT15,	17,	8,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_CLKO2,	19,	12,	15,	1,	false)
+	MUX_CFG(DA850, VPIF_CLKO3,	19,	20,	15,	1,	false)
 #endif
 };
 
@@ -595,6 +643,26 @@ const short da850_lcdcntl_pins[] __initdata = {
 	-1
 };
 
+const short da850_vpif_capture_pins[] __initdata = {
+	DA850_VPIF_DIN0, DA850_VPIF_DIN1, DA850_VPIF_DIN2, DA850_VPIF_DIN3,
+	DA850_VPIF_DIN4, DA850_VPIF_DIN5, DA850_VPIF_DIN6, DA850_VPIF_DIN7,
+	DA850_VPIF_DIN8, DA850_VPIF_DIN9, DA850_VPIF_DIN10, DA850_VPIF_DIN11,
+	DA850_VPIF_DIN12, DA850_VPIF_DIN13, DA850_VPIF_DIN14, DA850_VPIF_DIN15,
+	DA850_VPIF_CLKIN0, DA850_VPIF_CLKIN1, DA850_VPIF_CLKIN2,
+	DA850_VPIF_CLKIN3,
+	-1
+};
+
+const short da850_vpif_display_pins[] __initdata = {
+	DA850_VPIF_DOUT0, DA850_VPIF_DOUT1, DA850_VPIF_DOUT2, DA850_VPIF_DOUT3,
+	DA850_VPIF_DOUT4, DA850_VPIF_DOUT5, DA850_VPIF_DOUT6, DA850_VPIF_DOUT7,
+	DA850_VPIF_DOUT8, DA850_VPIF_DOUT9, DA850_VPIF_DOUT10,
+	DA850_VPIF_DOUT11, DA850_VPIF_DOUT12, DA850_VPIF_DOUT13,
+	DA850_VPIF_DOUT14, DA850_VPIF_DOUT15, DA850_VPIF_CLKO2,
+	DA850_VPIF_CLKO3,
+	-1
+};
+
 /* FIQ are pri 0-1; otherwise 2-7, with 7 lowest priority */
 static u8 da850_default_priorities[DA850_N_CP_INTC_IRQ] = {
 	[IRQ_DA8XX_COMMTX]		= 7,
@@ -1064,6 +1132,100 @@ no_ddrpll_mem:
 	return ret;
 }
 
+/* VPIF resource, platform data */
+static u64 da850_vpif_dma_mask = DMA_BIT_MASK(32);
+
+static struct resource da850_vpif_resource[] = {
+	{
+		.start = DA8XX_VPIF_BASE,
+		.end   = DA8XX_VPIF_BASE + 0xfff,
+		.flags = IORESOURCE_MEM,
+	}
+};
+
+static struct platform_device da850_vpif_dev = {
+	.name		= "vpif",
+	.id		= -1,
+	.dev		= {
+		.dma_mask		= &da850_vpif_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+	.resource	= da850_vpif_resource,
+	.num_resources	= ARRAY_SIZE(da850_vpif_resource),
+};
+
+static struct platform_device da850_vpif_display_dev = {
+	.name		= "vpif_display",
+	.id		= -1,
+	.dev		= {
+		.dma_mask		= &da850_vpif_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
+static struct platform_device da850_vpif_capture_dev = {
+	.name		= "vpif_capture",
+	.id		= -1,
+	.dev		= {
+		.dma_mask		= &da850_vpif_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
+int __init da850_register_vpif(void)
+{
+	return platform_device_register(&da850_vpif_dev);
+}
+
+int __init da850_register_vpif_display(struct vpif_display_config
+						*display_config)
+{
+	struct resource da850_vpif_display_resource[] = {
+		{
+			.start = IRQ_DA850_VPIFINT,
+			.end   = IRQ_DA850_VPIFINT,
+			.flags = IORESOURCE_IRQ,
+		},
+	};
+	int ret;
+
+	ret = platform_device_add_resources(&da850_vpif_display_dev,
+				da850_vpif_display_resource,
+				ARRAY_SIZE(da850_vpif_display_resource));
+	if (ret)
+		return -EINVAL;
+
+	da850_vpif_display_dev.dev.platform_data = display_config;
+	return platform_device_register(&da850_vpif_display_dev);
+}
+
+int __init da850_register_vpif_capture(struct vpif_capture_config
+							*capture_config)
+{
+	static struct resource da850_vpif_capture_resource[] = {
+		{
+			.start = IRQ_DA850_VPIFINT,
+			.end   = IRQ_DA850_VPIFINT,
+			.flags = IORESOURCE_IRQ,
+		},
+		{
+			.start = IRQ_DA850_VPIFINT,
+			.end   = IRQ_DA850_VPIFINT,
+			.flags = IORESOURCE_IRQ,
+		},
+	};
+	int ret;
+
+	ret = platform_device_add_resources(&da850_vpif_capture_dev,
+				da850_vpif_capture_resource,
+				ARRAY_SIZE(da850_vpif_capture_resource));
+	if (ret)
+		return -EINVAL;
+
+	da850_vpif_capture_dev.dev.platform_data = capture_config;
+	return platform_device_register(&da850_vpif_capture_dev);
+}
+
 static struct davinci_soc_info davinci_soc_info_da850 = {
 	.io_desc		= da850_io_desc,
 	.io_desc_num		= ARRAY_SIZE(da850_io_desc),
diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h b/arch/arm/mach-davinci/include/mach/da8xx.h
index a2f1f27..8eecbce 100644
--- a/arch/arm/mach-davinci/include/mach/da8xx.h
+++ b/arch/arm/mach-davinci/include/mach/da8xx.h
@@ -16,6 +16,7 @@
 #include <linux/platform_device.h>
 #include <linux/davinci_emac.h>
 #include <linux/spi/spi.h>
+#include <linux/videodev2.h>
 
 #include <mach/serial.h>
 #include <mach/edma.h>
@@ -26,6 +27,8 @@
 #include <mach/pm.h>
 #include <mach/spi.h>
 
+#include <media/davinci/vpif_types.h>
+
 extern void __iomem *da8xx_syscfg0_base;
 extern void __iomem *da8xx_syscfg1_base;
 
@@ -63,6 +66,7 @@ extern unsigned int da850_max_speed;
 #define DA8XX_PLL0_BASE		0x01c11000
 #define DA8XX_TIMER64P0_BASE	0x01c20000
 #define DA8XX_TIMER64P1_BASE	0x01c21000
+#define DA8XX_VPIF_BASE		0x01e17000
 #define DA8XX_GPIO_BASE		0x01e26000
 #define DA8XX_PSC1_BASE		0x01e27000
 #define DA8XX_AEMIF_CS2_BASE	0x60000000
@@ -92,6 +96,11 @@ int da8xx_register_cpuidle(void);
 void __iomem * __init da8xx_get_mem_ctlr(void);
 int da850_register_pm(struct platform_device *pdev);
 int __init da850_register_sata(unsigned long refclkpn);
+int __init da850_register_vpif(void);
+int __init da850_register_vpif_display
+			(struct vpif_display_config *display_config);
+int __init da850_register_vpif_capture
+			(struct vpif_capture_config *capture_config);
 void da8xx_restart(char mode, const char *cmd);
 
 extern struct platform_device da8xx_serial_device;
@@ -126,6 +135,8 @@ extern const short da830_ecap1_pins[];
 extern const short da830_ecap2_pins[];
 extern const short da830_eqep0_pins[];
 extern const short da830_eqep1_pins[];
+extern const short da850_vpif_capture_pins[];
+extern const short da850_vpif_display_pins[];
 
 extern const short da850_i2c0_pins[];
 extern const short da850_i2c1_pins[];
diff --git a/arch/arm/mach-davinci/include/mach/mux.h b/arch/arm/mach-davinci/include/mach/mux.h
index a7e92fc..9e95b8a 100644
--- a/arch/arm/mach-davinci/include/mach/mux.h
+++ b/arch/arm/mach-davinci/include/mach/mux.h
@@ -928,6 +928,48 @@ enum davinci_da850_index {
 	DA850_GPIO6_10,
 	DA850_GPIO6_13,
 	DA850_RTC_ALARM,
+
+	/* VPIF Capture */
+	DA850_VPIF_DIN0,
+	DA850_VPIF_DIN1,
+	DA850_VPIF_DIN2,
+	DA850_VPIF_DIN3,
+	DA850_VPIF_DIN4,
+	DA850_VPIF_DIN5,
+	DA850_VPIF_DIN6,
+	DA850_VPIF_DIN7,
+	DA850_VPIF_DIN8,
+	DA850_VPIF_DIN9,
+	DA850_VPIF_DIN10,
+	DA850_VPIF_DIN11,
+	DA850_VPIF_DIN12,
+	DA850_VPIF_DIN13,
+	DA850_VPIF_DIN14,
+	DA850_VPIF_DIN15,
+	DA850_VPIF_CLKIN0,
+	DA850_VPIF_CLKIN1,
+	DA850_VPIF_CLKIN2,
+	DA850_VPIF_CLKIN3,
+
+	/* VPIF Display */
+	DA850_VPIF_DOUT0,
+	DA850_VPIF_DOUT1,
+	DA850_VPIF_DOUT2,
+	DA850_VPIF_DOUT3,
+	DA850_VPIF_DOUT4,
+	DA850_VPIF_DOUT5,
+	DA850_VPIF_DOUT6,
+	DA850_VPIF_DOUT7,
+	DA850_VPIF_DOUT8,
+	DA850_VPIF_DOUT9,
+	DA850_VPIF_DOUT10,
+	DA850_VPIF_DOUT11,
+	DA850_VPIF_DOUT12,
+	DA850_VPIF_DOUT13,
+	DA850_VPIF_DOUT14,
+	DA850_VPIF_DOUT15,
+	DA850_VPIF_CLKO2,
+	DA850_VPIF_CLKO3,
 };
 
 enum davinci_tnetv107x_index {
diff --git a/arch/arm/mach-davinci/include/mach/psc.h b/arch/arm/mach-davinci/include/mach/psc.h
index 405318e..40a0027 100644
--- a/arch/arm/mach-davinci/include/mach/psc.h
+++ b/arch/arm/mach-davinci/include/mach/psc.h
@@ -166,6 +166,7 @@
 #define DA830_LPSC1_McASP1		8
 #define DA850_LPSC1_SATA		8
 #define DA830_LPSC1_McASP2		9
+#define DA850_LPSC1_VPIF		9
 #define DA8XX_LPSC1_SPI1		10
 #define DA8XX_LPSC1_I2C			11
 #define DA8XX_LPSC1_UART1		12
-- 
1.7.0.4

