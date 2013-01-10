Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab3AJQwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:52:06 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50200 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135Ab3AJQvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:51:55 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <kishon@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH 01/14] mfd: omap-usb-host: Consolidate OMAP USB-HS platform data
Date: Thu, 10 Jan 2013 18:51:21 +0200
Message-ID: <1357836694-30788-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357836694-30788-1-git-send-email-rogerq@ti.com>
References: <1357836694-30788-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's have a single platform data structure for the OMAP's High-Speed
USB host subsystem instead of having 3 separate ones i.e. one for
board data, one for USB Host (UHH) module and one for USB-TLL module.

This makes the code much simpler and avoids creating multiple copies of
platform data.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-3430sdp.c        |    2 +-
 arch/arm/mach-omap2/board-3630sdp.c        |    2 +-
 arch/arm/mach-omap2/board-am3517crane.c    |    2 +-
 arch/arm/mach-omap2/board-am3517evm.c      |    2 +-
 arch/arm/mach-omap2/board-cm-t35.c         |    2 +-
 arch/arm/mach-omap2/board-cm-t3517.c       |    2 +-
 arch/arm/mach-omap2/board-devkit8000.c     |    2 +-
 arch/arm/mach-omap2/board-igep0020.c       |    4 +-
 arch/arm/mach-omap2/board-omap3beagle.c    |    2 +-
 arch/arm/mach-omap2/board-omap3evm.c       |    2 +-
 arch/arm/mach-omap2/board-omap3pandora.c   |    2 +-
 arch/arm/mach-omap2/board-omap3stalker.c   |    2 +-
 arch/arm/mach-omap2/board-omap3touchbook.c |    2 +-
 arch/arm/mach-omap2/board-omap4panda.c     |    2 +-
 arch/arm/mach-omap2/board-overo.c          |    2 +-
 arch/arm/mach-omap2/board-zoom.c           |    2 +-
 arch/arm/mach-omap2/usb-host.c             |   30 +++---------------
 arch/arm/mach-omap2/usb.h                  |   21 +------------
 drivers/mfd/omap-usb-host.c                |   46 ++++++++++++----------------
 drivers/mfd/omap-usb-tll.c                 |    8 ++--
 drivers/usb/host/ehci-omap.c               |    6 ++--
 include/linux/platform_data/usb-omap.h     |   26 ++++------------
 22 files changed, 56 insertions(+), 115 deletions(-)

diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index bb73afc..46147c8 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -424,7 +424,7 @@ static void enable_board_wakeup_source(void)
 		OMAP_WAKEUP_EN | OMAP_PIN_INPUT_PULLUP);
 }
 
-static const struct usbhs_omap_board_data usbhs_bdata __initconst = {
+static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
diff --git a/arch/arm/mach-omap2/board-3630sdp.c b/arch/arm/mach-omap2/board-3630sdp.c
index 050aaa7..78b1724 100644
--- a/arch/arm/mach-omap2/board-3630sdp.c
+++ b/arch/arm/mach-omap2/board-3630sdp.c
@@ -53,7 +53,7 @@ static void enable_board_wakeup_source(void)
 		OMAP_WAKEUP_EN | OMAP_PIN_INPUT_PULLUP);
 }
 
-static const struct usbhs_omap_board_data usbhs_bdata __initconst = {
+static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
diff --git a/arch/arm/mach-omap2/board-am3517crane.c b/arch/arm/mach-omap2/board-am3517crane.c
index 51b96a1..26f1916 100644
--- a/arch/arm/mach-omap2/board-am3517crane.c
+++ b/arch/arm/mach-omap2/board-am3517crane.c
@@ -40,7 +40,7 @@ static struct omap_board_mux board_mux[] __initdata = {
 };
 #endif
 
-static struct usbhs_omap_board_data usbhs_bdata __initdata = {
+static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
 	.port_mode[1] = OMAP_USBHS_PORT_MODE_UNUSED,
 	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
diff --git a/arch/arm/mach-omap2/board-am3517evm.c b/arch/arm/mach-omap2/board-am3517evm.c
index f81a303..c76725d 100644
--- a/arch/arm/mach-omap2/board-am3517evm.c
+++ b/arch/arm/mach-omap2/board-am3517evm.c
@@ -274,7 +274,7 @@ static __init void am3517_evm_mcbsp1_init(void)
 	omap_ctrl_writel(devconf0, OMAP2_CONTROL_DEVCONF0);
 }
 
-static const struct usbhs_omap_board_data usbhs_bdata __initconst = {
+static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
 #if defined(CONFIG_PANEL_SHARP_LQ043T1DG01) || \
 		defined(CONFIG_PANEL_SHARP_LQ043T1DG01_MODULE)
diff --git a/arch/arm/mach-omap2/board-cm-t35.c b/arch/arm/mach-omap2/board-cm-t35.c
index b3102c2..cdf1d6e 100644
--- a/arch/arm/mach-omap2/board-cm-t35.c
+++ b/arch/arm/mach-omap2/board-cm-t35.c
@@ -418,7 +418,7 @@ static struct omap2_hsmmc_info mmc[] = {
 	{}	/* Terminator */
 };
 
-static struct usbhs_omap_board_data usbhs_bdata __initdata = {
+static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
 	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
diff --git a/arch/arm/mach-omap2/board-cm-t3517.c b/arch/arm/mach-omap2/board-cm-t3517.c
index ebbc2ad..cfa9098 100644
--- a/arch/arm/mach-omap2/board-cm-t3517.c
+++ b/arch/arm/mach-omap2/board-cm-t3517.c
@@ -166,7 +166,7 @@ static inline void cm_t3517_init_rtc(void) {}
 #define HSUSB2_RESET_GPIO	(147)
 #define USB_HUB_RESET_GPIO	(152)
 
-static struct usbhs_omap_board_data cm_t3517_ehci_pdata __initdata = {
+static struct usbhs_omap_platform_data cm_t3517_ehci_pdata __initdata = {
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
 	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 12865af..051ec0d 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -435,7 +435,7 @@ static struct platform_device *devkit8000_devices[] __initdata = {
 	&omap_dm9000_dev,
 };
 
-static const struct usbhs_omap_board_data usbhs_bdata __initconst = {
+static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
 	.port_mode[1] = OMAP_USBHS_PORT_MODE_UNUSED,
diff --git a/arch/arm/mach-omap2/board-igep0020.c b/arch/arm/mach-omap2/board-igep0020.c
index 0f24cb8..cfba790 100644
--- a/arch/arm/mach-omap2/board-igep0020.c
+++ b/arch/arm/mach-omap2/board-igep0020.c
@@ -526,7 +526,7 @@ static void __init igep_i2c_init(void)
 	omap3_pmic_init("twl4030", &igep_twldata);
 }
 
-static const struct usbhs_omap_board_data igep2_usbhs_bdata __initconst = {
+static struct usbhs_omap_platform_data igep2_usbhs_bdata __initdata = {
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
 	.port_mode[1] = OMAP_USBHS_PORT_MODE_UNUSED,
 	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
@@ -537,7 +537,7 @@ static const struct usbhs_omap_board_data igep2_usbhs_bdata __initconst = {
 	.reset_gpio_port[2] = -EINVAL,
 };
 
-static const struct usbhs_omap_board_data igep3_usbhs_bdata __initconst = {
+static struct usbhs_omap_platform_data igep3_usbhs_bdata __initdata = {
 	.port_mode[0] = OMAP_USBHS_PORT_MODE_UNUSED,
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
 	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 22c483d..1cb114e 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -430,7 +430,7 @@ static struct platform_device *omap3_beagle_devices[] __initdata = {
 	&madc_hwmon,
 };
 
-static const struct usbhs_omap_board_data usbhs_bdata __initconst = {
+static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 
 	.port_mode[0] = OMAP_USBHS_PORT_MODE_UNUSED,
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index 3985f35..7bdc8a4 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -538,7 +538,7 @@ static int __init omap3_evm_i2c_init(void)
 	return 0;
 }
 
-static struct usbhs_omap_board_data usbhs_bdata __initdata = {
+static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 
 	.port_mode[0] = OMAP_USBHS_PORT_MODE_UNUSED,
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index a53a668..145a6f8 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -567,7 +567,7 @@ static struct platform_device *omap3pandora_devices[] __initdata = {
 	&pandora_backlight,
 };
 
-static const struct usbhs_omap_board_data usbhs_bdata __initconst = {
+static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 
 	.port_mode[0] = OMAP_USBHS_PORT_MODE_UNUSED,
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
diff --git a/arch/arm/mach-omap2/board-omap3stalker.c b/arch/arm/mach-omap2/board-omap3stalker.c
index 53a6cbc..278ae95 100644
--- a/arch/arm/mach-omap2/board-omap3stalker.c
+++ b/arch/arm/mach-omap2/board-omap3stalker.c
@@ -361,7 +361,7 @@ static struct platform_device *omap3_stalker_devices[] __initdata = {
 	&keys_gpio,
 };
 
-static struct usbhs_omap_board_data usbhs_bdata __initconst = {
+static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 	.port_mode[0] = OMAP_USBHS_PORT_MODE_UNUSED,
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
 	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
diff --git a/arch/arm/mach-omap2/board-omap3touchbook.c b/arch/arm/mach-omap2/board-omap3touchbook.c
index 263cb9c..65a285f 100644
--- a/arch/arm/mach-omap2/board-omap3touchbook.c
+++ b/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -309,7 +309,7 @@ static struct platform_device *omap3_touchbook_devices[] __initdata = {
 	&keys_gpio,
 };
 
-static const struct usbhs_omap_board_data usbhs_bdata __initconst = {
+static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index 5c8e9ce..ee76830 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -139,7 +139,7 @@ static struct platform_device *panda_devices[] __initdata = {
 	&btwilink_device,
 };
 
-static const struct usbhs_omap_board_data usbhs_bdata __initconst = {
+static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
 	.port_mode[1] = OMAP_USBHS_PORT_MODE_UNUSED,
 	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index c8fde3e..b1b0f09 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -457,7 +457,7 @@ static int __init overo_spi_init(void)
 	return 0;
 }
 
-static const struct usbhs_omap_board_data usbhs_bdata __initconst = {
+static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 	.port_mode[0] = OMAP_USBHS_PORT_MODE_UNUSED,
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
 	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
diff --git a/arch/arm/mach-omap2/board-zoom.c b/arch/arm/mach-omap2/board-zoom.c
index d7fa31e..2d7a457 100644
--- a/arch/arm/mach-omap2/board-zoom.c
+++ b/arch/arm/mach-omap2/board-zoom.c
@@ -92,7 +92,7 @@ static struct mtd_partition zoom_nand_partitions[] = {
 	},
 };
 
-static const struct usbhs_omap_board_data usbhs_bdata __initconst = {
+static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 	.port_mode[0]		= OMAP_USBHS_PORT_MODE_UNUSED,
 	.port_mode[1]		= OMAP_EHCI_PORT_MODE_PHY,
 	.port_mode[2]		= OMAP_USBHS_PORT_MODE_UNUSED,
diff --git a/arch/arm/mach-omap2/usb-host.c b/arch/arm/mach-omap2/usb-host.c
index ee8c473..940aad4 100644
--- a/arch/arm/mach-omap2/usb-host.c
+++ b/arch/arm/mach-omap2/usb-host.c
@@ -37,11 +37,6 @@
 #define	USBHS_UHH_HWMODNAME	"usb_host_hs"
 #define USBHS_TLL_HWMODNAME	"usb_tll_hs"
 
-static struct usbhs_omap_platform_data		usbhs_data;
-static struct usbtll_omap_platform_data		usbtll_data;
-static struct ehci_hcd_omap_platform_data	ehci_data;
-static struct ohci_hcd_omap_platform_data	ohci_data;
-
 static struct omap_device_pm_latency omap_uhhtll_latency[] = {
 	  {
 		.deactivate_func = omap_device_idle_hwmods,
@@ -485,33 +480,18 @@ void __init setup_4430ohci_io_mux(const enum usbhs_omap_port_mode *port_mode)
 	}
 }
 
-void __init usbhs_init(const struct usbhs_omap_board_data *pdata)
+void __init usbhs_init(struct usbhs_omap_platform_data *pdata)
 {
 	struct omap_hwmod	*uhh_hwm, *tll_hwm;
 	struct platform_device	*pdev;
 	int			bus_id = -1;
-	int			i;
-
-	for (i = 0; i < OMAP3_HS_USB_PORTS; i++) {
-		usbhs_data.port_mode[i] = pdata->port_mode[i];
-		usbtll_data.port_mode[i] = pdata->port_mode[i];
-		ohci_data.port_mode[i] = pdata->port_mode[i];
-		ehci_data.port_mode[i] = pdata->port_mode[i];
-		ehci_data.reset_gpio_port[i] = pdata->reset_gpio_port[i];
-		ehci_data.regulator[i] = pdata->regulator[i];
-	}
-	ehci_data.phy_reset = pdata->phy_reset;
-	ohci_data.es2_compatibility = pdata->es2_compatibility;
-	usbhs_data.ehci_data = &ehci_data;
-	usbhs_data.ohci_data = &ohci_data;
-	usbhs_data.nports = pdata->nports;
 
 	if (cpu_is_omap34xx()) {
 		setup_ehci_io_mux(pdata->port_mode);
 		setup_ohci_io_mux(pdata->port_mode);
 
 		if (omap_rev() <= OMAP3430_REV_ES2_1)
-			usbhs_data.single_ulpi_bypass = true;
+			pdata->single_ulpi_bypass = true;
 
 	} else if (cpu_is_omap44xx()) {
 		setup_4430ehci_io_mux(pdata->port_mode);
@@ -531,7 +511,7 @@ void __init usbhs_init(const struct usbhs_omap_board_data *pdata)
 	}
 
 	pdev = omap_device_build(OMAP_USBTLL_DEVICE, bus_id, tll_hwm,
-				&usbtll_data, sizeof(usbtll_data),
+				pdata, sizeof(*pdata),
 				omap_uhhtll_latency,
 				ARRAY_SIZE(omap_uhhtll_latency), false);
 	if (IS_ERR(pdev)) {
@@ -541,7 +521,7 @@ void __init usbhs_init(const struct usbhs_omap_board_data *pdata)
 	}
 
 	pdev = omap_device_build(OMAP_USBHS_DEVICE, bus_id, uhh_hwm,
-				&usbhs_data, sizeof(usbhs_data),
+				pdata, sizeof(*pdata),
 				omap_uhhtll_latency,
 				ARRAY_SIZE(omap_uhhtll_latency), false);
 	if (IS_ERR(pdev)) {
@@ -553,7 +533,7 @@ void __init usbhs_init(const struct usbhs_omap_board_data *pdata)
 
 #else
 
-void __init usbhs_init(const struct usbhs_omap_board_data *pdata)
+void __init usbhs_init(struct usbhs_omap_platform_data *pdata)
 {
 }
 
diff --git a/arch/arm/mach-omap2/usb.h b/arch/arm/mach-omap2/usb.h
index 7dc0f04..3319f5c 100644
--- a/arch/arm/mach-omap2/usb.h
+++ b/arch/arm/mach-omap2/usb.h
@@ -53,27 +53,8 @@
 #define USBPHY_OTGSESSEND_EN	(1 << 20)
 #define USBPHY_DATA_POLARITY	(1 << 23)
 
-struct usbhs_omap_board_data {
-	int				nports;
-	enum usbhs_omap_port_mode	port_mode[OMAP3_HS_USB_PORTS];
-
-	/* have to be valid if phy_reset is true and portx is in phy mode */
-	int	reset_gpio_port[OMAP3_HS_USB_PORTS];
-
-	/* Set this to true for ES2.x silicon */
-	unsigned			es2_compatibility:1;
-
-	unsigned			phy_reset:1;
-
-	/*
-	 * Regulators for USB PHYs.
-	 * Each PHY can have a separate regulator.
-	 */
-	struct regulator		*regulator[OMAP3_HS_USB_PORTS];
-};
-
 extern void usb_musb_init(struct omap_musb_board_data *board_data);
-extern void usbhs_init(const struct usbhs_omap_board_data *pdata);
+extern void usbhs_init(struct usbhs_omap_platform_data *pdata);
 
 extern void am35x_musb_reset(void);
 extern void am35x_musb_phy_power(u8 on);
diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 9612535..7180b00 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -185,19 +185,13 @@ err_end:
 static int omap_usbhs_alloc_children(struct platform_device *pdev)
 {
 	struct device				*dev = &pdev->dev;
-	struct usbhs_hcd_omap			*omap;
-	struct ehci_hcd_omap_platform_data	*ehci_data;
-	struct ohci_hcd_omap_platform_data	*ohci_data;
+	struct usbhs_omap_platform_data		*pdata = dev->platform_data;
 	struct platform_device			*ehci;
 	struct platform_device			*ohci;
 	struct resource				*res;
 	struct resource				resources[2];
 	int					ret;
 
-	omap = platform_get_drvdata(pdev);
-	ehci_data = omap->pdata->ehci_data;
-	ohci_data = omap->pdata->ohci_data;
-
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ehci");
 	if (!res) {
 		dev_err(dev, "EHCI get resource IORESOURCE_MEM failed\n");
@@ -214,8 +208,8 @@ static int omap_usbhs_alloc_children(struct platform_device *pdev)
 	}
 	resources[1] = *res;
 
-	ehci = omap_usbhs_alloc_child(OMAP_EHCI_DEVICE, resources, 2, ehci_data,
-		sizeof(*ehci_data), dev);
+	ehci = omap_usbhs_alloc_child(OMAP_EHCI_DEVICE, resources, 2, pdata,
+		sizeof(*pdata), dev);
 
 	if (!ehci) {
 		dev_err(dev, "omap_usbhs_alloc_child failed\n");
@@ -239,8 +233,8 @@ static int omap_usbhs_alloc_children(struct platform_device *pdev)
 	}
 	resources[1] = *res;
 
-	ohci = omap_usbhs_alloc_child(OMAP_OHCI_DEVICE, resources, 2, ohci_data,
-		sizeof(*ohci_data), dev);
+	ohci = omap_usbhs_alloc_child(OMAP_OHCI_DEVICE, resources, 2, pdata,
+		sizeof(*pdata), dev);
 	if (!ohci) {
 		dev_err(dev, "omap_usbhs_alloc_child failed\n");
 		ret = -ENOMEM;
@@ -441,13 +435,13 @@ static void omap_usbhs_init(struct device *dev)
 
 	dev_dbg(dev, "starting TI HSUSB Controller\n");
 
-	if (pdata->ehci_data->phy_reset) {
-		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[0]))
-			gpio_request_one(pdata->ehci_data->reset_gpio_port[0],
+	if (pdata->phy_reset) {
+		if (gpio_is_valid(pdata->reset_gpio_port[0]))
+			gpio_request_one(pdata->reset_gpio_port[0],
 					 GPIOF_OUT_INIT_LOW, "USB1 PHY reset");
 
-		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[1]))
-			gpio_request_one(pdata->ehci_data->reset_gpio_port[1],
+		if (gpio_is_valid(pdata->reset_gpio_port[1]))
+			gpio_request_one(pdata->reset_gpio_port[1],
 					 GPIOF_OUT_INIT_LOW, "USB2 PHY reset");
 
 		/* Hold the PHY in RESET for enough time till DIR is high */
@@ -473,19 +467,19 @@ static void omap_usbhs_init(struct device *dev)
 	dev_dbg(dev, "UHH setup done, uhh_hostconfig=%x\n", reg);
 
 	pm_runtime_put_sync(dev);
-	if (pdata->ehci_data->phy_reset) {
+	if (pdata->phy_reset) {
 		/* Hold the PHY in RESET for enough time till
 		 * PHY is settled and ready
 		 */
 		udelay(10);
 
-		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[0]))
+		if (gpio_is_valid(pdata->reset_gpio_port[0]))
 			gpio_set_value_cansleep
-				(pdata->ehci_data->reset_gpio_port[0], 1);
+				(pdata->reset_gpio_port[0], 1);
 
-		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[1]))
+		if (gpio_is_valid(pdata->reset_gpio_port[1]))
 			gpio_set_value_cansleep
-				(pdata->ehci_data->reset_gpio_port[1], 1);
+				(pdata->reset_gpio_port[1], 1);
 	}
 }
 
@@ -494,12 +488,12 @@ static void omap_usbhs_deinit(struct device *dev)
 	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
 	struct usbhs_omap_platform_data	*pdata = omap->pdata;
 
-	if (pdata->ehci_data->phy_reset) {
-		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[0]))
-			gpio_free(pdata->ehci_data->reset_gpio_port[0]);
+	if (pdata->phy_reset) {
+		if (gpio_is_valid(pdata->reset_gpio_port[0]))
+			gpio_free(pdata->reset_gpio_port[0]);
 
-		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[1]))
-			gpio_free(pdata->ehci_data->reset_gpio_port[1]);
+		if (gpio_is_valid(pdata->reset_gpio_port[1]))
+			gpio_free(pdata->reset_gpio_port[1]);
 	}
 }
 
diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index e63dc0b..a729cf3 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -105,7 +105,7 @@
 
 struct usbtll_omap {
 	int					nch;	/* num. of channels */
-	struct usbtll_omap_platform_data	*pdata;
+	struct usbhs_omap_platform_data		*pdata;
 	struct clk				**ch_clk;
 };
 
@@ -210,7 +210,7 @@ static unsigned ohci_omap3_fslsmode(enum usbhs_omap_port_mode mode)
 static int usbtll_omap_probe(struct platform_device *pdev)
 {
 	struct device				*dev =  &pdev->dev;
-	struct usbtll_omap_platform_data	*pdata = dev->platform_data;
+	struct usbhs_omap_platform_data		*pdata = dev->platform_data;
 	void __iomem				*base;
 	struct resource				*res;
 	struct usbtll_omap			*tll;
@@ -376,7 +376,7 @@ static int usbtll_omap_remove(struct platform_device *pdev)
 static int usbtll_runtime_resume(struct device *dev)
 {
 	struct usbtll_omap			*tll = dev_get_drvdata(dev);
-	struct usbtll_omap_platform_data	*pdata = tll->pdata;
+	struct usbhs_omap_platform_data		*pdata = tll->pdata;
 	int i;
 
 	dev_dbg(dev, "usbtll_runtime_resume\n");
@@ -402,7 +402,7 @@ static int usbtll_runtime_resume(struct device *dev)
 static int usbtll_runtime_suspend(struct device *dev)
 {
 	struct usbtll_omap			*tll = dev_get_drvdata(dev);
-	struct usbtll_omap_platform_data	*pdata = tll->pdata;
+	struct usbhs_omap_platform_data		*pdata = tll->pdata;
 	int i;
 
 	dev_dbg(dev, "usbtll_runtime_suspend\n");
diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index e9d9b09..b96a4bf 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -107,7 +107,7 @@ static int omap_ehci_init(struct usb_hcd *hcd)
 {
 	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
 	int			rc;
-	struct ehci_hcd_omap_platform_data	*pdata;
+	struct usbhs_omap_platform_data	*pdata;
 
 	pdata = hcd->self.controller->platform_data;
 
@@ -151,7 +151,7 @@ static int omap_ehci_init(struct usb_hcd *hcd)
 }
 
 static void disable_put_regulator(
-		struct ehci_hcd_omap_platform_data *pdata)
+		struct usbhs_omap_platform_data *pdata)
 {
 	int i;
 
@@ -176,7 +176,7 @@ static void disable_put_regulator(
 static int ehci_hcd_omap_probe(struct platform_device *pdev)
 {
 	struct device				*dev = &pdev->dev;
-	struct ehci_hcd_omap_platform_data	*pdata = dev->platform_data;
+	struct usbhs_omap_platform_data		*pdata = dev->platform_data;
 	struct resource				*res;
 	struct usb_hcd				*hcd;
 	void __iomem				*regs;
diff --git a/include/linux/platform_data/usb-omap.h b/include/linux/platform_data/usb-omap.h
index 57707c7..d63eb7d 100644
--- a/include/linux/platform_data/usb-omap.h
+++ b/include/linux/platform_data/usb-omap.h
@@ -38,31 +38,17 @@ enum usbhs_omap_port_mode {
 	OMAP_OHCI_PORT_MODE_TLL_2PIN_DPDM
 };
 
-struct usbtll_omap_platform_data {
-	enum usbhs_omap_port_mode		port_mode[OMAP3_HS_USB_PORTS];
-};
-
-struct ehci_hcd_omap_platform_data {
+struct usbhs_omap_platform_data {
+	int				nports;
 	enum usbhs_omap_port_mode	port_mode[OMAP3_HS_USB_PORTS];
 	int				reset_gpio_port[OMAP3_HS_USB_PORTS];
-	struct regulator		*regulator[OMAP3_HS_USB_PORTS];
-	unsigned			phy_reset:1;
-};
 
-struct ohci_hcd_omap_platform_data {
-	enum usbhs_omap_port_mode	port_mode[OMAP3_HS_USB_PORTS];
-	unsigned			es2_compatibility:1;
-};
-
-struct usbhs_omap_platform_data {
-	int					nports;
-	enum usbhs_omap_port_mode		port_mode[OMAP3_HS_USB_PORTS];
-
-	struct ehci_hcd_omap_platform_data	*ehci_data;
-	struct ohci_hcd_omap_platform_data	*ohci_data;
+	struct regulator		*regulator[OMAP3_HS_USB_PORTS];
 
 	/* OMAP3 <= ES2.1 have a single ulpi bypass control bit */
-	unsigned				single_ulpi_bypass:1;
+	unsigned			single_ulpi_bypass:1;
+	unsigned			es2_compatibility:1;
+	unsigned			phy_reset:1;
 };
 
 /*-------------------------------------------------------------------------*/
-- 
1.7.4.1

