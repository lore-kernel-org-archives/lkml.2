Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab2DTOsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 10:48:42 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:59048
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754754Ab2DTOsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 10:48:40 -0400
X-SpamScore: 1
X-BigFish: VS1(zcb8kz154dMzz1202h1082kzz8275dhz2dh2a8h668h839hd24h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>, <s.hauer@pengutronix.de>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>
Subject: [PATCH v2 3/3] ARM: imx6q: switch to use pinctrl driver
Date: Fri, 20 Apr 2012 22:58:36 +0800
Message-ID: <1334933916-12971-3-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1334933916-12971-1-git-send-email-b29396@freescale.com>
References: <1334933916-12971-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

---
This is not a formal patch and is only used for test
since before the pinctrl core handle dummy state is in,
enable pinctrl in driver will break other platforms.

ChangeLog v1->v2:
* using updated binding
---
 arch/arm/boot/dts/imx6q-arm2.dts   |    2 ++
 arch/arm/boot/dts/imx6q.dtsi       |   17 +++++++++++++++++
 arch/arm/mach-imx/Kconfig          |    2 ++
 drivers/mmc/host/sdhci-esdhc-imx.c |   12 ++++++++++++
 4 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q-arm2.dts b/arch/arm/boot/dts/imx6q-arm2.dts
index ce1c823..68b1d8d 100644
--- a/arch/arm/boot/dts/imx6q-arm2.dts
+++ b/arch/arm/boot/dts/imx6q-arm2.dts
@@ -44,6 +44,8 @@
 				fsl,card-wired;
 				vmmc-supply = <&reg_3p3v>;
 				status = "okay";
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_usdhc4_1>;
 			};
 
 			uart4: uart@021f0000 {
diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index 4905f51..8cbd88b 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -386,7 +386,24 @@
 			};
 
 			iomuxc@020e0000 {
+				compatible = "fsl,imx6q-iomuxc";
 				reg = <0x020e0000 0x4000>;
+
+				/* shared pinctrl settings */
+				usdhc4 {
+					pinctrl_usdhc4_1: usdhc4grp-1 {
+						fsl,pins = <1386 0x17059	/* MX6Q_PAD_SD4_CMD__USDHC4_CMD */
+							    1392 0x17059	/* MX6Q_PAD_SD4_CLK__USDHC4_CLK	*/
+							    1462 0x17059	/* MX6Q_PAD_SD4_DAT0__USDHC4_DAT0 */
+							    1470 0x17059	/* MX6Q_PAD_SD4_DAT1__USDHC4_DAT1 */
+							    1478 0x17059	/* MX6Q_PAD_SD4_DAT2__USDHC4_DAT2 */
+							    1486 0x17059	/* MX6Q_PAD_SD4_DAT3__USDHC4_DAT3 */
+							    1493 0x17059	/* MX6Q_PAD_SD4_DAT4__USDHC4_DAT4 */
+							    1501 0x17059	/* MX6Q_PAD_SD4_DAT5__USDHC4_DAT5 */
+							    1509 0x17059	/* MX6Q_PAD_SD4_DAT6__USDHC4_DAT6 */
+							    1517 0x17059>;	/* MX6Q_PAD_SD4_DAT7__USDHC4_DAT7 */
+					};
+				};
 			};
 
 			dcic@020e4000 { /* DCIC1 */
diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 7561eca..e0fc67c 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -842,6 +842,8 @@ config SOC_IMX6Q
 	select HAVE_IMX_MMDC
 	select HAVE_IMX_SRC
 	select HAVE_SMP
+	select PINCTRL
+	select PINCTRL_IMX6Q
 	select USE_OF
 
 	help
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 6193a0d..84ef749 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -24,6 +24,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_gpio.h>
+#include <linux/pinctrl/consumer.h>
 #include <mach/esdhc.h>
 #include "sdhci-pltfm.h"
 #include "sdhci-esdhc.h"
@@ -68,6 +69,7 @@ struct pltfm_imx_data {
 	int flags;
 	u32 scratchpad;
 	enum imx_esdhc_type devtype;
+	struct pinctrl *p;
 	struct esdhc_platform_data boarddata;
 };
 
@@ -467,6 +469,12 @@ static int __devinit sdhci_esdhc_imx_probe(struct platform_device *pdev)
 	clk_prepare_enable(clk);
 	pltfm_host->clk = clk;
 
+	imx_data->p = pinctrl_get_select_default(&pdev->dev);
+	if (IS_ERR(imx_data->p)) {
+		err = PTR_ERR(imx_data->p);
+		goto pin_err;
+	}
+
 	if (!is_imx25_esdhc(imx_data))
 		host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
 
@@ -559,6 +567,8 @@ no_card_detect_irq:
 		gpio_free(boarddata->wp_gpio);
 no_card_detect_pin:
 no_board_data:
+	pinctrl_put(imx_data->p);
+pin_err:
 	clk_disable_unprepare(pltfm_host->clk);
 	clk_put(pltfm_host->clk);
 err_clk_get:
@@ -586,6 +596,8 @@ static int __devexit sdhci_esdhc_imx_remove(struct platform_device *pdev)
 		gpio_free(boarddata->cd_gpio);
 	}
 
+	pinctrl_put(imx_data->p);
+
 	clk_disable_unprepare(pltfm_host->clk);
 	clk_put(pltfm_host->clk);
 	kfree(imx_data);
-- 
1.7.0.4


