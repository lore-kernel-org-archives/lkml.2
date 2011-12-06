Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472Ab1LFOck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 09:32:40 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:55549
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933384Ab1LFOcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 09:32:39 -0500
X-SpamScore: -17
X-BigFish: VS-17(zz9371K542M1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 6 Dec 2011 22:44:59 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Dong Aisheng-B29396 <B29396@freescale.com>
CC: Guo Shawn-R65073 <r65073@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [RFC PATCH 3/3] pinctrl: imx: add pinmux-imx6q support
Message-ID: <20111206144457.GA4066@S2100-06.ap.freescale.net>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
 <1322999384-7886-3-git-send-email-b29396@freescale.com>
 <20111206072326.GA3712@S2100-06.ap.freescale.net>
 <65EE16ACC360FA4D99C96DC085B3F772345A0B@039-SN1MPN1-002.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <65EE16ACC360FA4D99C96DC085B3F772345A0B@039-SN1MPN1-002.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 03:23:34PM +0800, Dong Aisheng-B29396 wrote:
> > -----Original Message-----
> > From: Guo Shawn-R65073
> > Sent: Tuesday, December 06, 2011 3:23 PM
> > To: Dong Aisheng-B29396
> > Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> > linus.walleij@stericsson.com; s.hauer@pengutronix.de;
> > kernel@pengutronix.de
> > Subject: Re: [RFC PATCH 3/3] pinctrl: imx: add pinmux-imx6q support
> > 
> > On Sun, Dec 04, 2011 at 07:49:44PM +0800, Dong Aisheng wrote:
> > > Signed-off-by: Dong Aisheng <b29396@freescale.com>
> > > Cc: Linus Walleij <linus.walleij@linaro.org>
> > > Cc: Sascha Hauer <s.hauer@pengutronix.de>
> > > Cc: Shawn Guo <shanw.guo@freescale.com>
> > > ---
> > >  drivers/pinctrl/pinmux-imx6q.c |  464
> > > ++++++++++++++++++++++++++++++++++++++++
> > >  1 files changed, 464 insertions(+), 0 deletions(-)
> > >
> > As I do not see the device tree probing added in pinmux-imx-core.c, I
> > expect the patch has not got the chance to run on imx6, right?
> > 
> Yes, I would add it if the pinctrl framework supports DT.
> 
It's not really the business of pinctrl framework.  We can run your
patch on imx6 (DT) right now.  I attached the quick hacking based on
your series below, so that we can push pinctrl DT bindings forward
(move those data into device tree).

Regards,
Shawn

---
 arch/arm/boot/dts/imx6q.dtsi       |    1 +
 arch/arm/mach-imx/Kconfig          |    1 +
 arch/arm/mach-imx/mach-imx6q.c     |    8 +++++++-
 drivers/mmc/host/sdhci-esdhc-imx.c |   20 ++++++++++++++++++++
 drivers/pinctrl/pinmux-imx-core.c  |   36 +++++++++++++++++++-----------------
 drivers/pinctrl/pinmux-imx-core.h  |    2 ++
 6 files changed, 50 insertions(+), 18 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index 7dda599..42499bb 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -386,6 +386,7 @@
 			};
 
 			iomuxc@020e0000 {
+				compatible = "fsl,imx6q-iomuxc";
 				reg = <0x020e0000 0x4000>;
 			};
 
diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index c44aa97..1e0befa 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -602,6 +602,7 @@ config SOC_IMX6Q
 	select HAVE_IMX_GPC
 	select HAVE_IMX_MMDC
 	select HAVE_IMX_SRC
+	select PINCTRL
 	select USE_OF
 
 	help
diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index 9cd860a..e12ae63 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -16,6 +16,7 @@
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/pinctrl/machine.h>
 #include <asm/hardware/cache-l2x0.h>
 #include <asm/hardware/gic.h>
 #include <asm/mach/arch.h>
@@ -23,10 +24,15 @@
 #include <mach/common.h>
 #include <mach/hardware.h>
 
+static struct pinmux_map imx6q_pinmux_map[] = {
+	PINMUX_MAP_PRIMARY("usdhc4", "sd4", "219c000.usdhc"),
+};
+
 static void __init imx6q_init_machine(void)
 {
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-
+	pinmux_register_mappings(imx6q_pinmux_map,
+				 ARRAY_SIZE(imx6q_pinmux_map));
 	imx6q_pm_init();
 }
 
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 4b976f0..4504136 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -24,6 +24,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_gpio.h>
+#include <linux/pinctrl/pinmux.h>
 #include <mach/esdhc.h>
 #include "sdhci-pltfm.h"
 #include "sdhci-esdhc.h"
@@ -68,6 +69,7 @@ struct pltfm_imx_data {
 	int flags;
 	u32 scratchpad;
 	enum imx_esdhc_type devtype;
+	struct pinmux *pmx;
 	struct esdhc_platform_data boarddata;
 };
 
@@ -439,6 +441,7 @@ static int __devinit sdhci_esdhc_imx_probe(struct platform_device *pdev)
 	struct clk *clk;
 	int err;
 	struct pltfm_imx_data *imx_data;
+	struct pinmux *pmx;
 
 	host = sdhci_pltfm_init(pdev, &sdhci_esdhc_imx_pdata);
 	if (IS_ERR(host))
@@ -466,6 +469,16 @@ static int __devinit sdhci_esdhc_imx_probe(struct platform_device *pdev)
 	clk_enable(clk);
 	pltfm_host->clk = clk;
 
+	pmx = pinmux_get(&pdev->dev, NULL);
+	if (IS_ERR(pmx)) {
+		err = PTR_ERR(pmx);
+		goto err_pmx_get;
+	}
+	err = pinmux_enable(pmx);
+	if (err)
+		goto err_pmx_enable;
+	imx_data->pmx = pmx;
+
 	if (!is_imx25_esdhc(imx_data))
 		host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
 
@@ -558,6 +571,10 @@ no_card_detect_irq:
 		gpio_free(boarddata->wp_gpio);
 no_card_detect_pin:
 no_board_data:
+	pinmux_disable(imx_data->pmx);
+err_pmx_enable:
+	pinmux_put(imx_data->pmx);
+err_pmx_get:
 	clk_disable(pltfm_host->clk);
 	clk_put(pltfm_host->clk);
 err_clk_get:
@@ -585,6 +602,9 @@ static int __devexit sdhci_esdhc_imx_remove(struct platform_device *pdev)
 		gpio_free(boarddata->cd_gpio);
 	}
 
+	pinmux_disable(imx_data->pmx);
+	pinmux_put(imx_data->pmx);
+
 	clk_disable(pltfm_host->clk);
 	clk_put(pltfm_host->clk);
 	kfree(imx_data);
diff --git a/drivers/pinctrl/pinmux-imx-core.c b/drivers/pinctrl/pinmux-imx-core.c
index 1e60932..4d5c384 100644
--- a/drivers/pinctrl/pinmux-imx-core.c
+++ b/drivers/pinctrl/pinmux-imx-core.c
@@ -14,7 +14,7 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/platform_device.h>
+#include <linux/of_device.h>
 #include <linux/io.h>
 #include <linux/err.h>
 #include <linux/pinctrl/pinctrl.h>
@@ -38,19 +38,6 @@ struct imx_pmx {
 #define IMX_PINCTRL_REG_SIZE 4
 #define IMX_PINCTRL_MAX_FUNC 7
 
-extern struct imx_pinctrl_info mx53_pinctrl_info;
-extern struct imx_pinctrl_info mx6q_pinctrl_info;
-
-static struct platform_device_id imx_pinctrl_devtype[] = {
-	{
-		.name = "sdhci-pinctrl-imx53",
-		.driver_data = (kernel_ulong_t)&mx53_pinctrl_info,
-	}, {
-		.name = "sdhci-pinctrl-imx6q",
-		.driver_data = (kernel_ulong_t)&mx6q_pinctrl_info,
-	},
-};
-
 static int imx_list_groups(struct pinctrl_dev *pctldev, unsigned selector)
 {
 	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
@@ -144,6 +131,12 @@ static int imx_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
 	return 0;
 }
 
+static void imx_pmx_disable(struct pinctrl_dev *pctldev, unsigned func_selector,
+			    unsigned group_selector)
+{
+	/* nothing to do here */
+}
+
 static int imx_pmx_list_funcs(struct pinctrl_dev *pctldev, unsigned selector)
 {
 	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
@@ -182,6 +175,7 @@ static struct pinmux_ops imx_pmx_ops = {
 	.get_function_name = imx_pmx_get_func_name,
 	.get_function_groups = imx_pmx_get_groups,
 	.enable = imx_pmx_enable,
+	.disable = imx_pmx_disable,
 };
 
 static struct pinctrl_desc imx_pmx_desc = {
@@ -199,17 +193,25 @@ static inline void imx_pmx_desc_init(struct pinctrl_desc *pmx_desc,
 	pmx_desc->maxpin = info->maxpin;
 }
 
+static const struct of_device_id imx_pmx_dt_ids[] = {
+	{ .compatible = "fsl,imx6q-iomuxc", .data = (void *) &mx6q_pinctrl_info, },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, imx_pmx_dt_ids);
+
 static int __init imx_pmx_probe(struct platform_device *pdev)
 {
+	const struct of_device_id *of_id =
+			of_match_device(imx_pmx_dt_ids, &pdev->dev);
 	struct device *dev = &pdev->dev;
 	struct imx_pmx *ipmx;
 	struct resource *res;
 	struct imx_pinctrl_info *info;
 	resource_size_t res_size;
 
-	info = (struct imx_pinctrl_info *)pdev->id_entry->driver_data;
+	info = of_id->data;
 	if (!info || !info->pins || !info->groups || !info->functions
-		|| (info->maxpin > info->npins)) {
+		|| !(info->maxpin > info->npins)) {
 		dev_err(&pdev->dev, "wrong pinctrl info\n");
 		return -EINVAL;
 	}
@@ -262,8 +264,8 @@ static struct platform_driver imx_pmx_driver = {
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
+		.of_match_table = imx_pmx_dt_ids,
 	},
-	.id_table = imx_pinctrl_devtype,
 	.remove = __exit_p(imx_pmx_remove),
 };
 
diff --git a/drivers/pinctrl/pinmux-imx-core.h b/drivers/pinctrl/pinmux-imx-core.h
index 8ccc0c6..09d988d 100644
--- a/drivers/pinctrl/pinmux-imx-core.h
+++ b/drivers/pinctrl/pinmux-imx-core.h
@@ -62,6 +62,8 @@ struct imx_pinctrl_info {
 	u32 mux_offset;
 };
 
+extern const struct imx_pinctrl_info mx6q_pinctrl_info;
+
 #define IMX_PINCTRL_PIN(pin) PINCTRL_PIN(pin, #pin)
 
 #define IMX_PIN_GROUP(n, p, m)  \
-- 
1.7.4.1

