Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1GFQqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 12:46:36 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:49855
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754815Ab1GFQqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 12:46:34 -0400
X-SpamScore: 8
X-BigFish: VS8(za62pzzz1202hzz8275dhz2dh87h2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Shawn Guo <shawn.guo@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <patches@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v3 1/3] gpio/mxc: get rid of the uses of cpu_is_mx()
Date: Thu, 7 Jul 2011 00:37:41 +0800
Message-ID: <1309970263-13239-2-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309970263-13239-1-git-send-email-shawn.guo@linaro.org>
References: <1309970263-13239-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch removes all the uses of cpu_is_mx().  Instead, it utilizes
platform_device_id to distinguish the different gpio types, IMX1_GPIO
on i.mx1, IMX21_GPIO on i.mx21 and i.mx27, IMX31_GPIO on all other
i.mx SoCs.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/mach-imx/mm-imx1.c                   |    8 +-
 arch/arm/mach-imx/mm-imx21.c                  |   12 +-
 arch/arm/mach-imx/mm-imx25.c                  |    9 +-
 arch/arm/mach-imx/mm-imx27.c                  |   13 ++-
 arch/arm/mach-imx/mm-imx31.c                  |    6 +-
 arch/arm/mach-imx/mm-imx35.c                  |    7 +-
 arch/arm/mach-mx5/mm-mx50.c                   |   13 ++-
 arch/arm/mach-mx5/mm.c                        |   24 +++--
 arch/arm/plat-mxc/devices/platform-gpio-mxc.c |    4 +-
 arch/arm/plat-mxc/include/mach/common.h       |    2 +-
 drivers/gpio/gpio-mxc.c                       |  125 +++++++++++++++++++++----
 11 files changed, 159 insertions(+), 64 deletions(-)

diff --git a/arch/arm/mach-imx/mm-imx1.c b/arch/arm/mach-imx/mm-imx1.c
index f2a6566..2bded59 100644
--- a/arch/arm/mach-imx/mm-imx1.c
+++ b/arch/arm/mach-imx/mm-imx1.c
@@ -50,12 +50,12 @@ void __init mx1_init_irq(void)
 
 void __init imx1_soc_init(void)
 {
-	mxc_register_gpio(0, MX1_GPIO1_BASE_ADDR, SZ_256,
+	mxc_register_gpio("imx1-gpio", 0, MX1_GPIO1_BASE_ADDR, SZ_256,
 						MX1_GPIO_INT_PORTA, 0);
-	mxc_register_gpio(1, MX1_GPIO2_BASE_ADDR, SZ_256,
+	mxc_register_gpio("imx1-gpio", 1, MX1_GPIO2_BASE_ADDR, SZ_256,
 						MX1_GPIO_INT_PORTB, 0);
-	mxc_register_gpio(2, MX1_GPIO3_BASE_ADDR, SZ_256,
+	mxc_register_gpio("imx1-gpio", 2, MX1_GPIO3_BASE_ADDR, SZ_256,
 						MX1_GPIO_INT_PORTC, 0);
-	mxc_register_gpio(3, MX1_GPIO4_BASE_ADDR, SZ_256,
+	mxc_register_gpio("imx1-gpio", 3, MX1_GPIO4_BASE_ADDR, SZ_256,
 						MX1_GPIO_INT_PORTD, 0);
 }
diff --git a/arch/arm/mach-imx/mm-imx21.c b/arch/arm/mach-imx/mm-imx21.c
index 4f32a8a..3f05dfe 100644
--- a/arch/arm/mach-imx/mm-imx21.c
+++ b/arch/arm/mach-imx/mm-imx21.c
@@ -77,12 +77,12 @@ void __init mx21_init_irq(void)
 
 void __init imx21_soc_init(void)
 {
-	mxc_register_gpio(0, MX21_GPIO1_BASE_ADDR, SZ_256, MX21_INT_GPIO, 0);
-	mxc_register_gpio(1, MX21_GPIO2_BASE_ADDR, SZ_256, MX21_INT_GPIO, 0);
-	mxc_register_gpio(2, MX21_GPIO3_BASE_ADDR, SZ_256, MX21_INT_GPIO, 0);
-	mxc_register_gpio(3, MX21_GPIO4_BASE_ADDR, SZ_256, MX21_INT_GPIO, 0);
-	mxc_register_gpio(4, MX21_GPIO5_BASE_ADDR, SZ_256, MX21_INT_GPIO, 0);
-	mxc_register_gpio(5, MX21_GPIO6_BASE_ADDR, SZ_256, MX21_INT_GPIO, 0);
+	mxc_register_gpio("imx21-gpio", 0, MX21_GPIO1_BASE_ADDR, SZ_256, MX21_INT_GPIO, 0);
+	mxc_register_gpio("imx21-gpio", 1, MX21_GPIO2_BASE_ADDR, SZ_256, MX21_INT_GPIO, 0);
+	mxc_register_gpio("imx21-gpio", 2, MX21_GPIO3_BASE_ADDR, SZ_256, MX21_INT_GPIO, 0);
+	mxc_register_gpio("imx21-gpio", 3, MX21_GPIO4_BASE_ADDR, SZ_256, MX21_INT_GPIO, 0);
+	mxc_register_gpio("imx21-gpio", 4, MX21_GPIO5_BASE_ADDR, SZ_256, MX21_INT_GPIO, 0);
+	mxc_register_gpio("imx21-gpio", 5, MX21_GPIO6_BASE_ADDR, SZ_256, MX21_INT_GPIO, 0);
 
 	imx_add_imx_dma();
 }
diff --git a/arch/arm/mach-imx/mm-imx25.c b/arch/arm/mach-imx/mm-imx25.c
index 1e0c956..8bf0291 100644
--- a/arch/arm/mach-imx/mm-imx25.c
+++ b/arch/arm/mach-imx/mm-imx25.c
@@ -86,10 +86,11 @@ static struct sdma_platform_data imx25_sdma_pdata __initdata = {
 
 void __init imx25_soc_init(void)
 {
-	mxc_register_gpio(0, MX25_GPIO1_BASE_ADDR, SZ_16K, MX25_INT_GPIO1, 0);
-	mxc_register_gpio(1, MX25_GPIO2_BASE_ADDR, SZ_16K, MX25_INT_GPIO2, 0);
-	mxc_register_gpio(2, MX25_GPIO3_BASE_ADDR, SZ_16K, MX25_INT_GPIO3, 0);
-	mxc_register_gpio(3, MX25_GPIO4_BASE_ADDR, SZ_16K, MX25_INT_GPIO4, 0);
+	/* i.mx25 has the i.mx31 type gpio */
+	mxc_register_gpio("imx31-gpio", 0, MX25_GPIO1_BASE_ADDR, SZ_16K, MX25_INT_GPIO1, 0);
+	mxc_register_gpio("imx31-gpio", 1, MX25_GPIO2_BASE_ADDR, SZ_16K, MX25_INT_GPIO2, 0);
+	mxc_register_gpio("imx31-gpio", 2, MX25_GPIO3_BASE_ADDR, SZ_16K, MX25_INT_GPIO3, 0);
+	mxc_register_gpio("imx31-gpio", 3, MX25_GPIO4_BASE_ADDR, SZ_16K, MX25_INT_GPIO4, 0);
 
 	imx_add_imx_sdma(MX25_SDMA_BASE_ADDR, MX25_INT_SDMA, &imx25_sdma_pdata);
 }
diff --git a/arch/arm/mach-imx/mm-imx27.c b/arch/arm/mach-imx/mm-imx27.c
index 944e02d..96dd1f5 100644
--- a/arch/arm/mach-imx/mm-imx27.c
+++ b/arch/arm/mach-imx/mm-imx27.c
@@ -77,12 +77,13 @@ void __init mx27_init_irq(void)
 
 void __init imx27_soc_init(void)
 {
-	mxc_register_gpio(0, MX27_GPIO1_BASE_ADDR, SZ_256, MX27_INT_GPIO, 0);
-	mxc_register_gpio(1, MX27_GPIO2_BASE_ADDR, SZ_256, MX27_INT_GPIO, 0);
-	mxc_register_gpio(2, MX27_GPIO3_BASE_ADDR, SZ_256, MX27_INT_GPIO, 0);
-	mxc_register_gpio(3, MX27_GPIO4_BASE_ADDR, SZ_256, MX27_INT_GPIO, 0);
-	mxc_register_gpio(4, MX27_GPIO5_BASE_ADDR, SZ_256, MX27_INT_GPIO, 0);
-	mxc_register_gpio(5, MX27_GPIO6_BASE_ADDR, SZ_256, MX27_INT_GPIO, 0);
+	/* i.mx27 has the i.mx21 type gpio */
+	mxc_register_gpio("imx21-gpio", 0, MX27_GPIO1_BASE_ADDR, SZ_256, MX27_INT_GPIO, 0);
+	mxc_register_gpio("imx21-gpio", 1, MX27_GPIO2_BASE_ADDR, SZ_256, MX27_INT_GPIO, 0);
+	mxc_register_gpio("imx21-gpio", 2, MX27_GPIO3_BASE_ADDR, SZ_256, MX27_INT_GPIO, 0);
+	mxc_register_gpio("imx21-gpio", 3, MX27_GPIO4_BASE_ADDR, SZ_256, MX27_INT_GPIO, 0);
+	mxc_register_gpio("imx21-gpio", 4, MX27_GPIO5_BASE_ADDR, SZ_256, MX27_INT_GPIO, 0);
+	mxc_register_gpio("imx21-gpio", 5, MX27_GPIO6_BASE_ADDR, SZ_256, MX27_INT_GPIO, 0);
 
 	imx_add_imx_dma();
 }
diff --git a/arch/arm/mach-imx/mm-imx31.c b/arch/arm/mach-imx/mm-imx31.c
index a1ff96f..61bff38 100644
--- a/arch/arm/mach-imx/mm-imx31.c
+++ b/arch/arm/mach-imx/mm-imx31.c
@@ -78,9 +78,9 @@ void __init imx31_soc_init(void)
 {
 	int to_version = mx31_revision() >> 4;
 
-	mxc_register_gpio(0, MX31_GPIO1_BASE_ADDR, SZ_16K, MX31_INT_GPIO1, 0);
-	mxc_register_gpio(1, MX31_GPIO2_BASE_ADDR, SZ_16K, MX31_INT_GPIO2, 0);
-	mxc_register_gpio(2, MX31_GPIO3_BASE_ADDR, SZ_16K, MX31_INT_GPIO3, 0);
+	mxc_register_gpio("imx31-gpio", 0, MX31_GPIO1_BASE_ADDR, SZ_16K, MX31_INT_GPIO1, 0);
+	mxc_register_gpio("imx31-gpio", 1, MX31_GPIO2_BASE_ADDR, SZ_16K, MX31_INT_GPIO2, 0);
+	mxc_register_gpio("imx31-gpio", 2, MX31_GPIO3_BASE_ADDR, SZ_16K, MX31_INT_GPIO3, 0);
 
 	if (to_version == 1) {
 		strncpy(imx31_sdma_pdata.fw_name, "sdma-imx31-to1.bin",
diff --git a/arch/arm/mach-imx/mm-imx35.c b/arch/arm/mach-imx/mm-imx35.c
index da530ca..98769ae 100644
--- a/arch/arm/mach-imx/mm-imx35.c
+++ b/arch/arm/mach-imx/mm-imx35.c
@@ -95,9 +95,10 @@ void __init imx35_soc_init(void)
 {
 	int to_version = mx35_revision() >> 4;
 
-	mxc_register_gpio(0, MX35_GPIO1_BASE_ADDR, SZ_16K, MX35_INT_GPIO1, 0);
-	mxc_register_gpio(1, MX35_GPIO2_BASE_ADDR, SZ_16K, MX35_INT_GPIO2, 0);
-	mxc_register_gpio(2, MX35_GPIO3_BASE_ADDR, SZ_16K, MX35_INT_GPIO3, 0);
+	/* i.mx35 has the i.mx31 type gpio */
+	mxc_register_gpio("imx31-gpio", 0, MX35_GPIO1_BASE_ADDR, SZ_16K, MX35_INT_GPIO1, 0);
+	mxc_register_gpio("imx31-gpio", 1, MX35_GPIO2_BASE_ADDR, SZ_16K, MX35_INT_GPIO2, 0);
+	mxc_register_gpio("imx31-gpio", 2, MX35_GPIO3_BASE_ADDR, SZ_16K, MX35_INT_GPIO3, 0);
 
 	if (to_version == 1) {
 		strncpy(imx35_sdma_pdata.fw_name, "sdma-imx35-to1.bin",
diff --git a/arch/arm/mach-mx5/mm-mx50.c b/arch/arm/mach-mx5/mm-mx50.c
index 28c3f60..77e374c 100644
--- a/arch/arm/mach-mx5/mm-mx50.c
+++ b/arch/arm/mach-mx5/mm-mx50.c
@@ -62,10 +62,11 @@ void __init mx50_init_irq(void)
 
 void __init imx50_soc_init(void)
 {
-	mxc_register_gpio(0, MX50_GPIO1_BASE_ADDR, SZ_16K, MX50_INT_GPIO1_LOW, MX50_INT_GPIO1_HIGH);
-	mxc_register_gpio(1, MX50_GPIO2_BASE_ADDR, SZ_16K, MX50_INT_GPIO2_LOW, MX50_INT_GPIO2_HIGH);
-	mxc_register_gpio(2, MX50_GPIO3_BASE_ADDR, SZ_16K, MX50_INT_GPIO3_LOW, MX50_INT_GPIO3_HIGH);
-	mxc_register_gpio(3, MX50_GPIO4_BASE_ADDR, SZ_16K, MX50_INT_GPIO4_LOW, MX50_INT_GPIO4_HIGH);
-	mxc_register_gpio(4, MX50_GPIO5_BASE_ADDR, SZ_16K, MX50_INT_GPIO5_LOW, MX50_INT_GPIO5_HIGH);
-	mxc_register_gpio(5, MX50_GPIO6_BASE_ADDR, SZ_16K, MX50_INT_GPIO6_LOW, MX50_INT_GPIO6_HIGH);
+	/* i.mx50 has the i.mx31 type gpio */
+	mxc_register_gpio("imx31-gpio", 0, MX50_GPIO1_BASE_ADDR, SZ_16K, MX50_INT_GPIO1_LOW, MX50_INT_GPIO1_HIGH);
+	mxc_register_gpio("imx31-gpio", 1, MX50_GPIO2_BASE_ADDR, SZ_16K, MX50_INT_GPIO2_LOW, MX50_INT_GPIO2_HIGH);
+	mxc_register_gpio("imx31-gpio", 2, MX50_GPIO3_BASE_ADDR, SZ_16K, MX50_INT_GPIO3_LOW, MX50_INT_GPIO3_HIGH);
+	mxc_register_gpio("imx31-gpio", 3, MX50_GPIO4_BASE_ADDR, SZ_16K, MX50_INT_GPIO4_LOW, MX50_INT_GPIO4_HIGH);
+	mxc_register_gpio("imx31-gpio", 4, MX50_GPIO5_BASE_ADDR, SZ_16K, MX50_INT_GPIO5_LOW, MX50_INT_GPIO5_HIGH);
+	mxc_register_gpio("imx31-gpio", 5, MX50_GPIO6_BASE_ADDR, SZ_16K, MX50_INT_GPIO6_LOW, MX50_INT_GPIO6_HIGH);
 }
diff --git a/arch/arm/mach-mx5/mm.c b/arch/arm/mach-mx5/mm.c
index 1b7059f..ef8aec9 100644
--- a/arch/arm/mach-mx5/mm.c
+++ b/arch/arm/mach-mx5/mm.c
@@ -142,23 +142,25 @@ static struct sdma_platform_data imx53_sdma_pdata __initdata = {
 
 void __init imx51_soc_init(void)
 {
-	mxc_register_gpio(0, MX51_GPIO1_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO1_LOW, MX51_MXC_INT_GPIO1_HIGH);
-	mxc_register_gpio(1, MX51_GPIO2_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO2_LOW, MX51_MXC_INT_GPIO2_HIGH);
-	mxc_register_gpio(2, MX51_GPIO3_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO3_LOW, MX51_MXC_INT_GPIO3_HIGH);
-	mxc_register_gpio(3, MX51_GPIO4_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO4_LOW, MX51_MXC_INT_GPIO4_HIGH);
+	/* i.mx51 has the i.mx31 type gpio */
+	mxc_register_gpio("imx31-gpio", 0, MX51_GPIO1_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO1_LOW, MX51_MXC_INT_GPIO1_HIGH);
+	mxc_register_gpio("imx31-gpio", 1, MX51_GPIO2_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO2_LOW, MX51_MXC_INT_GPIO2_HIGH);
+	mxc_register_gpio("imx31-gpio", 2, MX51_GPIO3_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO3_LOW, MX51_MXC_INT_GPIO3_HIGH);
+	mxc_register_gpio("imx31-gpio", 3, MX51_GPIO4_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO4_LOW, MX51_MXC_INT_GPIO4_HIGH);
 
 	imx_add_imx_sdma(MX51_SDMA_BASE_ADDR, MX51_INT_SDMA, &imx51_sdma_pdata);
 }
 
 void __init imx53_soc_init(void)
 {
-	mxc_register_gpio(0, MX53_GPIO1_BASE_ADDR, SZ_16K, MX53_INT_GPIO1_LOW, MX53_INT_GPIO1_HIGH);
-	mxc_register_gpio(1, MX53_GPIO2_BASE_ADDR, SZ_16K, MX53_INT_GPIO2_LOW, MX53_INT_GPIO2_HIGH);
-	mxc_register_gpio(2, MX53_GPIO3_BASE_ADDR, SZ_16K, MX53_INT_GPIO3_LOW, MX53_INT_GPIO3_HIGH);
-	mxc_register_gpio(3, MX53_GPIO4_BASE_ADDR, SZ_16K, MX53_INT_GPIO4_LOW, MX53_INT_GPIO4_HIGH);
-	mxc_register_gpio(4, MX53_GPIO5_BASE_ADDR, SZ_16K, MX53_INT_GPIO5_LOW, MX53_INT_GPIO5_HIGH);
-	mxc_register_gpio(5, MX53_GPIO6_BASE_ADDR, SZ_16K, MX53_INT_GPIO6_LOW, MX53_INT_GPIO6_HIGH);
-	mxc_register_gpio(6, MX53_GPIO7_BASE_ADDR, SZ_16K, MX53_INT_GPIO7_LOW, MX53_INT_GPIO7_HIGH);
+	/* i.mx53 has the i.mx31 type gpio */
+	mxc_register_gpio("imx31-gpio", 0, MX53_GPIO1_BASE_ADDR, SZ_16K, MX53_INT_GPIO1_LOW, MX53_INT_GPIO1_HIGH);
+	mxc_register_gpio("imx31-gpio", 1, MX53_GPIO2_BASE_ADDR, SZ_16K, MX53_INT_GPIO2_LOW, MX53_INT_GPIO2_HIGH);
+	mxc_register_gpio("imx31-gpio", 2, MX53_GPIO3_BASE_ADDR, SZ_16K, MX53_INT_GPIO3_LOW, MX53_INT_GPIO3_HIGH);
+	mxc_register_gpio("imx31-gpio", 3, MX53_GPIO4_BASE_ADDR, SZ_16K, MX53_INT_GPIO4_LOW, MX53_INT_GPIO4_HIGH);
+	mxc_register_gpio("imx31-gpio", 4, MX53_GPIO5_BASE_ADDR, SZ_16K, MX53_INT_GPIO5_LOW, MX53_INT_GPIO5_HIGH);
+	mxc_register_gpio("imx31-gpio", 5, MX53_GPIO6_BASE_ADDR, SZ_16K, MX53_INT_GPIO6_LOW, MX53_INT_GPIO6_HIGH);
+	mxc_register_gpio("imx31-gpio", 6, MX53_GPIO7_BASE_ADDR, SZ_16K, MX53_INT_GPIO7_LOW, MX53_INT_GPIO7_HIGH);
 
 	imx_add_imx_sdma(MX53_SDMA_BASE_ADDR, MX53_INT_SDMA, &imx53_sdma_pdata);
 }
diff --git a/arch/arm/plat-mxc/devices/platform-gpio-mxc.c b/arch/arm/plat-mxc/devices/platform-gpio-mxc.c
index cf1b7fd..a7919a2 100644
--- a/arch/arm/plat-mxc/devices/platform-gpio-mxc.c
+++ b/arch/arm/plat-mxc/devices/platform-gpio-mxc.c
@@ -8,7 +8,7 @@
  */
 #include <mach/devices-common.h>
 
-struct platform_device *__init mxc_register_gpio(int id,
+struct platform_device *__init mxc_register_gpio(char *name, int id,
 	resource_size_t iobase, resource_size_t iosize, int irq, int irq_high)
 {
 	struct resource res[] = {
@@ -28,5 +28,5 @@ struct platform_device *__init mxc_register_gpio(int id,
 	};
 
 	return platform_device_register_resndata(&mxc_aips_bus,
-			"gpio-mxc", id, res, ARRAY_SIZE(res), NULL, 0);
+			name, id, res, ARRAY_SIZE(res), NULL, 0);
 }
diff --git a/arch/arm/plat-mxc/include/mach/common.h b/arch/arm/plat-mxc/include/mach/common.h
index 91fa263..4e3d978 100644
--- a/arch/arm/plat-mxc/include/mach/common.h
+++ b/arch/arm/plat-mxc/include/mach/common.h
@@ -64,7 +64,7 @@ extern int mx51_clocks_init(unsigned long ckil, unsigned long osc,
 			unsigned long ckih1, unsigned long ckih2);
 extern int mx53_clocks_init(unsigned long ckil, unsigned long osc,
 			unsigned long ckih1, unsigned long ckih2);
-extern struct platform_device *mxc_register_gpio(int id,
+extern struct platform_device *mxc_register_gpio(char *name, int id,
 	resource_size_t iobase, resource_size_t iosize, int irq, int irq_high);
 extern int mxc_register_device(struct platform_device *pdev, void *data);
 extern void mxc_set_cpu_type(unsigned int type);
diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index 2f6a81b..310a46d 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -27,9 +27,29 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/basic_mmio_gpio.h>
-#include <mach/hardware.h>
 #include <asm-generic/bug.h>
 
+enum mxc_gpio_hwtype {
+	IMX1_GPIO,	/* runs on i.mx1 */
+	IMX21_GPIO,	/* runs on i.mx21 and i.mx27 */
+	IMX31_GPIO,	/* runs on all other i.mx */
+};
+
+/* device type dependent stuff */
+struct mxc_gpio_hwdata {
+	unsigned dr_reg;
+	unsigned gdir_reg;
+	unsigned psr_reg;
+	unsigned icr1_reg;
+	unsigned icr2_reg;
+	unsigned imr_reg;
+	unsigned isr_reg;
+	unsigned low_level;
+	unsigned high_level;
+	unsigned rise_edge;
+	unsigned fall_edge;
+};
+
 struct mxc_gpio_port {
 	struct list_head node;
 	void __iomem *base;
@@ -40,6 +60,66 @@ struct mxc_gpio_port {
 	u32 both_edges;
 };
 
+static struct mxc_gpio_hwdata imx1_imx21_gpio_hwdata = {
+	.dr_reg		= 0x1c,
+	.gdir_reg	= 0x00,
+	.psr_reg	= 0x24,
+	.icr1_reg	= 0x28,
+	.icr2_reg	= 0x2c,
+	.imr_reg	= 0x30,
+	.isr_reg	= 0x34,
+	.low_level	= 0x03,
+	.high_level	= 0x02,
+	.rise_edge	= 0x00,
+	.fall_edge	= 0x01,
+};
+
+static struct mxc_gpio_hwdata imx31_gpio_hwdata = {
+	.dr_reg		= 0x00,
+	.gdir_reg	= 0x04,
+	.psr_reg	= 0x08,
+	.icr1_reg	= 0x0c,
+	.icr2_reg	= 0x10,
+	.imr_reg	= 0x14,
+	.isr_reg	= 0x18,
+	.low_level	= 0x00,
+	.high_level	= 0x01,
+	.rise_edge	= 0x02,
+	.fall_edge	= 0x03,
+};
+
+static enum mxc_gpio_hwtype mxc_gpio_hwtype;
+static struct mxc_gpio_hwdata *mxc_gpio_hwdata;
+
+#define GPIO_DR			(mxc_gpio_hwdata->dr_reg)
+#define GPIO_GDIR		(mxc_gpio_hwdata->gdir_reg)
+#define GPIO_PSR		(mxc_gpio_hwdata->psr_reg)
+#define GPIO_ICR1		(mxc_gpio_hwdata->icr1_reg)
+#define GPIO_ICR2		(mxc_gpio_hwdata->icr2_reg)
+#define GPIO_IMR		(mxc_gpio_hwdata->imr_reg)
+#define GPIO_ISR		(mxc_gpio_hwdata->isr_reg)
+
+#define GPIO_INT_LOW_LEV	(mxc_gpio_hwdata->low_level)
+#define GPIO_INT_HIGH_LEV	(mxc_gpio_hwdata->high_level)
+#define GPIO_INT_RISE_EDGE	(mxc_gpio_hwdata->rise_edge)
+#define GPIO_INT_FALL_EDGE	(mxc_gpio_hwdata->fall_edge)
+#define GPIO_INT_NONE		0x4
+
+static struct platform_device_id mxc_gpio_devtype[] = {
+	{
+		.name = "imx1-gpio",
+		.driver_data = IMX1_GPIO,
+	}, {
+		.name = "imx21-gpio",
+		.driver_data = IMX21_GPIO,
+	}, {
+		.name = "imx31-gpio",
+		.driver_data = IMX31_GPIO,
+	}, {
+		/* sentinel */
+	}
+};
+
 /*
  * MX2 has one interrupt *for all* gpio ports. The list is used
  * to save the references to all ports, so that mx2_gpio_irq_handler
@@ -47,22 +127,6 @@ struct mxc_gpio_port {
  */
 static LIST_HEAD(mxc_gpio_ports);
 
-#define cpu_is_mx1_mx2()	(cpu_is_mx1() || cpu_is_mx2())
-
-#define GPIO_DR		(cpu_is_mx1_mx2() ? 0x1c : 0x00)
-#define GPIO_GDIR	(cpu_is_mx1_mx2() ? 0x00 : 0x04)
-#define GPIO_PSR	(cpu_is_mx1_mx2() ? 0x24 : 0x08)
-#define GPIO_ICR1	(cpu_is_mx1_mx2() ? 0x28 : 0x0C)
-#define GPIO_ICR2	(cpu_is_mx1_mx2() ? 0x2C : 0x10)
-#define GPIO_IMR	(cpu_is_mx1_mx2() ? 0x30 : 0x14)
-#define GPIO_ISR	(cpu_is_mx1_mx2() ? 0x34 : 0x18)
-
-#define GPIO_INT_LOW_LEV	(cpu_is_mx1_mx2() ? 0x3 : 0x0)
-#define GPIO_INT_HIGH_LEV	(cpu_is_mx1_mx2() ? 0x2 : 0x1)
-#define GPIO_INT_RISE_EDGE	(cpu_is_mx1_mx2() ? 0x0 : 0x2)
-#define GPIO_INT_FALL_EDGE	(cpu_is_mx1_mx2() ? 0x1 : 0x3)
-#define GPIO_INT_NONE		0x4
-
 /* Note: This driver assumes 32 GPIOs are handled in one register */
 
 static int gpio_set_irq_type(struct irq_data *d, u32 type)
@@ -236,12 +300,36 @@ static void __init mxc_gpio_init_gc(struct mxc_gpio_port *port)
 			       IRQ_NOREQUEST, 0);
 }
 
+static void __devinit mxc_gpio_get_hw(struct platform_device *pdev)
+{
+	enum mxc_gpio_hwtype hwtype = pdev->id_entry->driver_data;
+
+	if (mxc_gpio_hwtype) {
+		/*
+		 * The driver works with a reasonable presupposition,
+		 * that is all gpio ports must be the same type when
+		 * running on one soc.
+		 */
+		BUG_ON(mxc_gpio_hwtype != hwtype);
+		return;
+	}
+
+	if (hwtype == IMX31_GPIO)
+		mxc_gpio_hwdata = &imx31_gpio_hwdata;
+	else
+		mxc_gpio_hwdata = &imx1_imx21_gpio_hwdata;
+
+	mxc_gpio_hwtype = hwtype;
+}
+
 static int __devinit mxc_gpio_probe(struct platform_device *pdev)
 {
 	struct mxc_gpio_port *port;
 	struct resource *iores;
 	int err;
 
+	mxc_gpio_get_hw(pdev);
+
 	port = kzalloc(sizeof(struct mxc_gpio_port), GFP_KERNEL);
 	if (!port)
 		return -ENOMEM;
@@ -280,7 +368,7 @@ static int __devinit mxc_gpio_probe(struct platform_device *pdev)
 	/* gpio-mxc can be a generic irq chip */
 	mxc_gpio_init_gc(port);
 
-	if (cpu_is_mx2()) {
+	if (mxc_gpio_hwtype == IMX21_GPIO) {
 		/* setup one handler for all GPIO interrupts */
 		if (pdev->id == 0)
 			irq_set_chained_handler(port->irq,
@@ -332,6 +420,7 @@ static struct platform_driver mxc_gpio_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= mxc_gpio_probe,
+	.id_table	= mxc_gpio_devtype,
 };
 
 static int __init gpio_mxc_init(void)
-- 
1.7.4.1


