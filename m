Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab1IZLVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 07:21:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:47567 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab1IZLVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 07:21:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="56485816"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>,
        Lin Tony-B19295 <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCHv5 01/19] usb: otg: Rename otg_transceiver to usb_phy
Date: Mon, 26 Sep 2011 14:21:14 +0300
Message-Id: <1317036092-3000-2-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317036092-3000-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1317036092-3000-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first step in separating USB transceivers from
USB OTG utilities.

Includes fixes to IMX code from Sascha Hauer.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/mach-imx/mx31moboard-devboard.c   |    6 +-
 arch/arm/mach-imx/mx31moboard-marxbot.c    |    6 +-
 arch/arm/mach-pxa/pxa3xx-ulpi.c            |    6 +-
 arch/arm/mach-tegra/include/mach/usb_phy.h |    2 +-
 arch/arm/plat-mxc/include/mach/mxc_ehci.h  |    2 +-
 arch/arm/plat-mxc/include/mach/ulpi.h      |    4 +-
 arch/arm/plat-mxc/ulpi.c                   |    6 +-
 drivers/power/isp1704_charger.c            |    2 +-
 drivers/power/pda_power.c                  |    2 +-
 drivers/power/twl4030_charger.c            |    2 +-
 drivers/usb/gadget/ci13xxx_udc.h           |    2 +-
 drivers/usb/gadget/fsl_usb2_udc.h          |    2 +-
 drivers/usb/gadget/langwell_udc.c          |    2 +-
 drivers/usb/gadget/langwell_udc.h          |    2 +-
 drivers/usb/gadget/omap_udc.c              |    4 +-
 drivers/usb/gadget/omap_udc.h              |    2 +-
 drivers/usb/gadget/pxa25x_udc.h            |    2 +-
 drivers/usb/gadget/pxa27x_udc.h            |    2 +-
 drivers/usb/host/ehci-msm.c                |    2 +-
 drivers/usb/host/ehci-tegra.c              |    2 +-
 drivers/usb/host/ehci.h                    |    2 +-
 drivers/usb/host/ohci.h                    |    2 +-
 drivers/usb/musb/blackfin.c                |    2 +-
 drivers/usb/musb/musb_core.c               |    4 +-
 drivers/usb/musb/musb_core.h               |    2 +-
 drivers/usb/musb/tusb6010.c                |    2 +-
 drivers/usb/otg/Kconfig                    |    2 +-
 drivers/usb/otg/ab8500-usb.c               |   12 ++--
 drivers/usb/otg/fsl_otg.c                  |   18 +++---
 drivers/usb/otg/fsl_otg.h                  |    2 +-
 drivers/usb/otg/gpio_vbus.c                |    8 +-
 drivers/usb/otg/isp1301_omap.c             |   12 ++--
 drivers/usb/otg/langwell_otg.c             |   16 ++--
 drivers/usb/otg/msm_otg.c                  |   54 ++++++++--------
 drivers/usb/otg/nop-usb-xceiv.c            |   10 ++--
 drivers/usb/otg/otg.c                      |    8 +-
 drivers/usb/otg/otg_fsm.h                  |    2 +-
 drivers/usb/otg/twl4030-usb.c              |    8 +-
 drivers/usb/otg/twl6030-usb.c              |   20 +++---
 drivers/usb/otg/ulpi.c                     |   20 +++---
 drivers/usb/otg/ulpi_viewport.c            |    4 +-
 include/linux/usb/intel_mid_otg.h          |    6 +-
 include/linux/usb/msm_hsusb.h              |    2 +-
 include/linux/usb/otg.h                    |   98 ++++++++++++++--------------
 include/linux/usb/ulpi.h                   |    2 +-
 45 files changed, 189 insertions(+), 189 deletions(-)

diff --git a/arch/arm/mach-imx/mx31moboard-devboard.c b/arch/arm/mach-imx/mx31moboard-devboard.c
index 0aa2536..9cd4a97 100644
--- a/arch/arm/mach-imx/mx31moboard-devboard.c
+++ b/arch/arm/mach-imx/mx31moboard-devboard.c
@@ -158,7 +158,7 @@ static int devboard_usbh1_hw_init(struct platform_device *pdev)
 #define USBH1_VBUSEN_B	IOMUX_TO_GPIO(MX31_PIN_NFRE_B)
 #define USBH1_MODE	IOMUX_TO_GPIO(MX31_PIN_NFALE)
 
-static int devboard_isp1105_init(struct otg_transceiver *otg)
+static int devboard_isp1105_init(struct usb_phy *otg)
 {
 	int ret = gpio_request(USBH1_MODE, "usbh1-mode");
 	if (ret)
@@ -177,7 +177,7 @@ static int devboard_isp1105_init(struct otg_transceiver *otg)
 }
 
 
-static int devboard_isp1105_set_vbus(struct otg_transceiver *otg, bool on)
+static int devboard_isp1105_set_vbus(struct usb_phy *otg, bool on)
 {
 	if (on)
 		gpio_set_value(USBH1_VBUSEN_B, 0);
@@ -194,7 +194,7 @@ static struct mxc_usbh_platform_data usbh1_pdata __initdata = {
 
 static int __init devboard_usbh1_init(void)
 {
-	struct otg_transceiver *otg;
+	struct usb_phy *otg;
 	struct platform_device *pdev;
 
 	otg = kzalloc(sizeof(*otg), GFP_KERNEL);
diff --git a/arch/arm/mach-imx/mx31moboard-marxbot.c b/arch/arm/mach-imx/mx31moboard-marxbot.c
index bb639cb..2be769b 100644
--- a/arch/arm/mach-imx/mx31moboard-marxbot.c
+++ b/arch/arm/mach-imx/mx31moboard-marxbot.c
@@ -272,7 +272,7 @@ static int marxbot_usbh1_hw_init(struct platform_device *pdev)
 #define USBH1_VBUSEN_B	IOMUX_TO_GPIO(MX31_PIN_NFRE_B)
 #define USBH1_MODE	IOMUX_TO_GPIO(MX31_PIN_NFALE)
 
-static int marxbot_isp1105_init(struct otg_transceiver *otg)
+static int marxbot_isp1105_init(struct usb_phy *otg)
 {
 	int ret = gpio_request(USBH1_MODE, "usbh1-mode");
 	if (ret)
@@ -291,7 +291,7 @@ static int marxbot_isp1105_init(struct otg_transceiver *otg)
 }
 
 
-static int marxbot_isp1105_set_vbus(struct otg_transceiver *otg, bool on)
+static int marxbot_isp1105_set_vbus(struct usb_phy *otg, bool on)
 {
 	if (on)
 		gpio_set_value(USBH1_VBUSEN_B, 0);
@@ -308,7 +308,7 @@ static struct mxc_usbh_platform_data usbh1_pdata __initdata = {
 
 static int __init marxbot_usbh1_init(void)
 {
-	struct otg_transceiver *otg;
+	struct usb_phy *otg;
 	struct platform_device *pdev;
 
 	otg = kzalloc(sizeof(*otg), GFP_KERNEL);
diff --git a/arch/arm/mach-pxa/pxa3xx-ulpi.c b/arch/arm/mach-pxa/pxa3xx-ulpi.c
index ce7168b..83e185d 100644
--- a/arch/arm/mach-pxa/pxa3xx-ulpi.c
+++ b/arch/arm/mach-pxa/pxa3xx-ulpi.c
@@ -33,7 +33,7 @@ struct pxa3xx_u2d_ulpi {
 	struct clk		*clk;
 	void __iomem		*mmio_base;
 
-	struct otg_transceiver	*otg;
+	struct usb_phy		*otg;
 	unsigned int		ulpi_mode;
 };
 
@@ -79,7 +79,7 @@ static int pxa310_ulpi_poll(void)
 	return -ETIMEDOUT;
 }
 
-static int pxa310_ulpi_read(struct otg_transceiver *otg, u32 reg)
+static int pxa310_ulpi_read(struct usb_phy *otg, u32 reg)
 {
 	int err;
 
@@ -98,7 +98,7 @@ static int pxa310_ulpi_read(struct otg_transceiver *otg, u32 reg)
 	return u2d_readl(U2DOTGUCR) & U2DOTGUCR_RDATA;
 }
 
-static int pxa310_ulpi_write(struct otg_transceiver *otg, u32 val, u32 reg)
+static int pxa310_ulpi_write(struct usb_phy *otg, u32 val, u32 reg)
 {
 	if (pxa310_ulpi_get_phymode() != SYNCH) {
 		pr_warning("%s: PHY is not in SYNCH mode!\n", __func__);
diff --git a/arch/arm/mach-tegra/include/mach/usb_phy.h b/arch/arm/mach-tegra/include/mach/usb_phy.h
index d4b8f9e..de1a0f6 100644
--- a/arch/arm/mach-tegra/include/mach/usb_phy.h
+++ b/arch/arm/mach-tegra/include/mach/usb_phy.h
@@ -58,7 +58,7 @@ struct tegra_usb_phy {
 	struct clk *pad_clk;
 	enum tegra_usb_phy_mode mode;
 	void *config;
-	struct otg_transceiver *ulpi;
+	struct usb_phy *ulpi;
 };
 
 struct tegra_usb_phy *tegra_usb_phy_open(int instance, void __iomem *regs,
diff --git a/arch/arm/plat-mxc/include/mach/mxc_ehci.h b/arch/arm/plat-mxc/include/mach/mxc_ehci.h
index 2c159dc..9ffd1bb 100644
--- a/arch/arm/plat-mxc/include/mach/mxc_ehci.h
+++ b/arch/arm/plat-mxc/include/mach/mxc_ehci.h
@@ -44,7 +44,7 @@ struct mxc_usbh_platform_data {
 	int (*exit)(struct platform_device *pdev);
 
 	unsigned int		 portsc;
-	struct otg_transceiver	*otg;
+	struct usb_phy		*otg;
 };
 
 int mx51_initialize_usb_hw(int port, unsigned int flags);
diff --git a/arch/arm/plat-mxc/include/mach/ulpi.h b/arch/arm/plat-mxc/include/mach/ulpi.h
index f9161c9..d39d94a 100644
--- a/arch/arm/plat-mxc/include/mach/ulpi.h
+++ b/arch/arm/plat-mxc/include/mach/ulpi.h
@@ -2,9 +2,9 @@
 #define __MACH_ULPI_H
 
 #ifdef CONFIG_USB_ULPI
-struct otg_transceiver *imx_otg_ulpi_create(unsigned int flags);
+struct usb_phy *imx_otg_ulpi_create(unsigned int flags);
 #else
-static inline struct otg_transceiver *imx_otg_ulpi_create(unsigned int flags)
+static inline struct usb_phy *imx_otg_ulpi_create(unsigned int flags)
 {
 	return NULL;
 }
diff --git a/arch/arm/plat-mxc/ulpi.c b/arch/arm/plat-mxc/ulpi.c
index 477e45b..8eeeb6b 100644
--- a/arch/arm/plat-mxc/ulpi.c
+++ b/arch/arm/plat-mxc/ulpi.c
@@ -58,7 +58,7 @@ static int ulpi_poll(void __iomem *view, u32 bit)
 	return -ETIMEDOUT;
 }
 
-static int ulpi_read(struct otg_transceiver *otg, u32 reg)
+static int ulpi_read(struct usb_phy *otg, u32 reg)
 {
 	int ret;
 	void __iomem *view = otg->io_priv;
@@ -84,7 +84,7 @@ static int ulpi_read(struct otg_transceiver *otg, u32 reg)
 	return (__raw_readl(view) >> ULPIVW_RDATA_SHIFT) & ULPIVW_RDATA_MASK;
 }
 
-static int ulpi_write(struct otg_transceiver *otg, u32 val, u32 reg)
+static int ulpi_write(struct usb_phy *otg, u32 val, u32 reg)
 {
 	int ret;
 	void __iomem *view = otg->io_priv;
@@ -112,7 +112,7 @@ struct otg_io_access_ops mxc_ulpi_access_ops = {
 };
 EXPORT_SYMBOL_GPL(mxc_ulpi_access_ops);
 
-struct otg_transceiver *imx_otg_ulpi_create(unsigned int flags)
+struct usb_phy *imx_otg_ulpi_create(unsigned int flags)
 {
 	return otg_ulpi_create(&mxc_ulpi_access_ops, flags);
 }
diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
index f6d72b4..9230bdd 100644
--- a/drivers/power/isp1704_charger.c
+++ b/drivers/power/isp1704_charger.c
@@ -56,7 +56,7 @@ static u16 isp170x_id[] = {
 struct isp1704_charger {
 	struct device		*dev;
 	struct power_supply	psy;
-	struct otg_transceiver	*otg;
+	struct usb_phy		*otg;
 	struct notifier_block	nb;
 	struct work_struct	work;
 
diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index 69f8aa3..8f817e6 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -39,7 +39,7 @@ static struct timer_list polling_timer;
 static int polling;
 
 #ifdef CONFIG_USB_OTG_UTILS
-static struct otg_transceiver *transceiver;
+static struct usb_phy *transceiver;
 #endif
 static struct regulator *ac_draw;
 
diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index 54b9198..b3ead23 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -69,7 +69,7 @@ struct twl4030_bci {
 	struct device		*dev;
 	struct power_supply	ac;
 	struct power_supply	usb;
-	struct otg_transceiver	*transceiver;
+	struct usb_phy		*transceiver;
 	struct notifier_block	otg_nb;
 	struct work_struct	work;
 	int			irq_chg;
diff --git a/drivers/usb/gadget/ci13xxx_udc.h b/drivers/usb/gadget/ci13xxx_udc.h
index 2370777..3660627 100644
--- a/drivers/usb/gadget/ci13xxx_udc.h
+++ b/drivers/usb/gadget/ci13xxx_udc.h
@@ -136,7 +136,7 @@ struct ci13xxx {
 	struct usb_gadget_driver  *driver;     /* 3rd party gadget driver */
 	struct ci13xxx_udc_driver *udc_driver; /* device controller driver */
 	int                        vbus_active; /* is VBUS active */
-	struct otg_transceiver    *transceiver; /* Transceiver struct */
+	struct usb_phy            *transceiver; /* Transceiver struct */
 };
 
 /******************************************************************************
diff --git a/drivers/usb/gadget/fsl_usb2_udc.h b/drivers/usb/gadget/fsl_usb2_udc.h
index 1d51be8..a0041f4 100644
--- a/drivers/usb/gadget/fsl_usb2_udc.h
+++ b/drivers/usb/gadget/fsl_usb2_udc.h
@@ -471,7 +471,7 @@ struct fsl_udc {
 
 	struct usb_ctrlrequest local_setup_buff;
 	spinlock_t lock;
-	struct otg_transceiver *transceiver;
+	struct usb_phy *transceiver;
 	unsigned softconnect:1;
 	unsigned vbus_active:1;
 	unsigned stopped:1;
diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index a06e2c2..00ddf29 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -3163,7 +3163,7 @@ static int langwell_udc_probe(struct pci_dev *pdev,
 	dev_dbg(&dev->pdev->dev, "---> %s()\n", __func__);
 
 #ifdef	OTG_TRANSCEIVER
-	/* PCI device is already enabled by otg_transceiver driver */
+	/* PCI device is already enabled by usb_phy driver */
 	dev->enabled = 1;
 
 	/* mem region and register base */
diff --git a/drivers/usb/gadget/langwell_udc.h b/drivers/usb/gadget/langwell_udc.h
index f1d9c1b..d7db7ed 100644
--- a/drivers/usb/gadget/langwell_udc.h
+++ b/drivers/usb/gadget/langwell_udc.h
@@ -173,7 +173,7 @@ struct langwell_udc {
 	spinlock_t		lock;	/* device lock */
 	struct langwell_ep	*ep;
 	struct usb_gadget_driver	*driver;
-	struct otg_transceiver	*transceiver;
+	struct usb_phy		*transceiver;
 	u8			dev_addr;
 	u32			usb_state;
 	u32			resume_state;
diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index 740c7da..56d4f47 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -2660,7 +2660,7 @@ static void omap_udc_release(struct device *dev)
 }
 
 static int __init
-omap_udc_setup(struct platform_device *odev, struct otg_transceiver *xceiv)
+omap_udc_setup(struct platform_device *odev, struct usb_phy *xceiv)
 {
 	unsigned	tmp, buf;
 
@@ -2799,7 +2799,7 @@ static int __init omap_udc_probe(struct platform_device *pdev)
 {
 	int			status = -ENODEV;
 	int			hmc;
-	struct otg_transceiver	*xceiv = NULL;
+	struct usb_phy		*xceiv = NULL;
 	const char		*type = NULL;
 	struct omap_usb_config	*config = pdev->dev.platform_data;
 	struct clk		*dc_clk;
diff --git a/drivers/usb/gadget/omap_udc.h b/drivers/usb/gadget/omap_udc.h
index 29edc51..59d3b22 100644
--- a/drivers/usb/gadget/omap_udc.h
+++ b/drivers/usb/gadget/omap_udc.h
@@ -164,7 +164,7 @@ struct omap_udc {
 	struct omap_ep			ep[32];
 	u16				devstat;
 	u16				clr_halt;
-	struct otg_transceiver		*transceiver;
+	struct usb_phy			*transceiver;
 	struct list_head		iso;
 	unsigned			softconnect:1;
 	unsigned			vbus_active:1;
diff --git a/drivers/usb/gadget/pxa25x_udc.h b/drivers/usb/gadget/pxa25x_udc.h
index f572c56..93da15c 100644
--- a/drivers/usb/gadget/pxa25x_udc.h
+++ b/drivers/usb/gadget/pxa25x_udc.h
@@ -128,7 +128,7 @@ struct pxa25x_udc {
 	struct device				*dev;
 	struct clk				*clk;
 	struct pxa2xx_udc_mach_info		*mach;
-	struct otg_transceiver			*transceiver;
+	struct usb_phy				*transceiver;
 	u64					dma_mask;
 	struct pxa25x_ep			ep [PXA_UDC_NUM_ENDPOINTS];
 
diff --git a/drivers/usb/gadget/pxa27x_udc.h b/drivers/usb/gadget/pxa27x_udc.h
index b01696e..f4ad833 100644
--- a/drivers/usb/gadget/pxa27x_udc.h
+++ b/drivers/usb/gadget/pxa27x_udc.h
@@ -456,7 +456,7 @@ struct pxa_udc {
 	struct usb_gadget_driver		*driver;
 	struct device				*dev;
 	struct pxa2xx_udc_mach_info		*mach;
-	struct otg_transceiver			*transceiver;
+	struct usb_phy				*transceiver;
 
 	enum ep0_state				ep0state;
 	struct udc_stats			stats;
diff --git a/drivers/usb/host/ehci-msm.c b/drivers/usb/host/ehci-msm.c
index 592d5f7..ef7c431 100644
--- a/drivers/usb/host/ehci-msm.c
+++ b/drivers/usb/host/ehci-msm.c
@@ -32,7 +32,7 @@
 
 #define MSM_USB_BASE (hcd->regs)
 
-static struct otg_transceiver *otg;
+static struct usb_phy *otg;
 
 static int ehci_msm_reset(struct usb_hcd *hcd)
 {
diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 02b2bfd..4637a29 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -30,7 +30,7 @@ struct tegra_ehci_hcd {
 	struct tegra_usb_phy *phy;
 	struct clk *clk;
 	struct clk *emc_clk;
-	struct otg_transceiver *transceiver;
+	struct usb_phy *transceiver;
 	int host_resumed;
 	int bus_suspended;
 	int port_resuming;
diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index cc7d337..f3bb5ce 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -168,7 +168,7 @@ struct ehci_hcd {			/* one per controller */
 	/*
 	 * OTG controllers and transceivers need software interaction
 	 */
-	struct otg_transceiver	*transceiver;
+	struct usb_phy	*transceiver;
 };
 
 /* convert between an HCD pointer and the corresponding EHCI_HCD */
diff --git a/drivers/usb/host/ohci.h b/drivers/usb/host/ohci.h
index 35e5fd6..f5b042c 100644
--- a/drivers/usb/host/ohci.h
+++ b/drivers/usb/host/ohci.h
@@ -370,7 +370,7 @@ struct ohci_hcd {
 	 * OTG controllers and transceivers need software interaction;
 	 * other external transceivers should be software-transparent
 	 */
-	struct otg_transceiver	*transceiver;
+	struct usb_phy	*transceiver;
 	void (*start_hnp)(struct ohci_hcd *ohci);
 
 	/*
diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
index 5e7cfba..fc8e9ed 100644
--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -317,7 +317,7 @@ static void bfin_musb_set_vbus(struct musb *musb, int is_on)
 		musb_readb(musb->mregs, MUSB_DEVCTL));
 }
 
-static int bfin_musb_set_power(struct otg_transceiver *x, unsigned mA)
+static int bfin_musb_set_power(struct usb_phy *x, unsigned mA)
 {
 	return 0;
 }
diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 20a2873..b5beb7d 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -131,7 +131,7 @@ static inline struct musb *dev_to_musb(struct device *dev)
 /*-------------------------------------------------------------------------*/
 
 #ifndef CONFIG_BLACKFIN
-static int musb_ulpi_read(struct otg_transceiver *otg, u32 offset)
+static int musb_ulpi_read(struct usb_phy *otg, u32 offset)
 {
 	void __iomem *addr = otg->io_priv;
 	int	i = 0;
@@ -165,7 +165,7 @@ static int musb_ulpi_read(struct otg_transceiver *otg, u32 offset)
 	return musb_readb(addr, MUSB_ULPI_REG_DATA);
 }
 
-static int musb_ulpi_write(struct otg_transceiver *otg,
+static int musb_ulpi_write(struct usb_phy *otg,
 		u32 offset, u32 data)
 {
 	void __iomem *addr = otg->io_priv;
diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
index b3c065a..2168319 100644
--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
@@ -371,7 +371,7 @@ struct musb {
 	u16			int_rx;
 	u16			int_tx;
 
-	struct otg_transceiver	*xceiv;
+	struct usb_phy		*xceiv;
 
 	int nIrq;
 	unsigned		irq_wake:1;
diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index ec14801..38d5ce8 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -276,7 +276,7 @@ static struct musb *the_musb;
  * mode), or low power Default-B sessions, something else supplies power.
  * Caller must take care of locking.
  */
-static int tusb_draw_power(struct otg_transceiver *x, unsigned mA)
+static int tusb_draw_power(struct usb_phy *x, unsigned mA)
 {
 	struct musb	*musb = the_musb;
 	void __iomem	*tbase = musb->ctrl_base;
diff --git a/drivers/usb/otg/Kconfig b/drivers/usb/otg/Kconfig
index c66481a..ec61cb4 100644
--- a/drivers/usb/otg/Kconfig
+++ b/drivers/usb/otg/Kconfig
@@ -23,7 +23,7 @@ config USB_GPIO_VBUS
 	select USB_OTG_UTILS
 	help
 	  Provides simple GPIO VBUS sensing for controllers with an
-	  internal transceiver via the otg_transceiver interface, and
+	  internal transceiver via the usb_phy interface, and
 	  optionally control of a D+ pullup GPIO as well as a VBUS
 	  current limit regulator.
 
diff --git a/drivers/usb/otg/ab8500-usb.c b/drivers/usb/otg/ab8500-usb.c
index 07ccea9..99a56af 100644
--- a/drivers/usb/otg/ab8500-usb.c
+++ b/drivers/usb/otg/ab8500-usb.c
@@ -68,7 +68,7 @@ enum ab8500_usb_link_status {
 };
 
 struct ab8500_usb {
-	struct otg_transceiver otg;
+	struct usb_phy otg;
 	struct device *dev;
 	int irq_num_id_rise;
 	int irq_num_id_fall;
@@ -82,7 +82,7 @@ struct ab8500_usb {
 	int rev;
 };
 
-static inline struct ab8500_usb *xceiv_to_ab(struct otg_transceiver *x)
+static inline struct ab8500_usb *xceiv_to_ab(struct usb_phy *x)
 {
 	return container_of(x, struct ab8500_usb, otg);
 }
@@ -269,7 +269,7 @@ static void ab8500_usb_phy_disable_work(struct work_struct *work)
 		ab8500_usb_peri_phy_dis(ab);
 }
 
-static int ab8500_usb_set_power(struct otg_transceiver *otg, unsigned mA)
+static int ab8500_usb_set_power(struct usb_phy *otg, unsigned mA)
 {
 	struct ab8500_usb *ab;
 
@@ -290,13 +290,13 @@ static int ab8500_usb_set_power(struct otg_transceiver *otg, unsigned mA)
  * ab->vbus_draw.
  */
 
-static int ab8500_usb_set_suspend(struct otg_transceiver *x, int suspend)
+static int ab8500_usb_set_suspend(struct usb_phy *x, int suspend)
 {
 	/* TODO */
 	return 0;
 }
 
-static int ab8500_usb_set_peripheral(struct otg_transceiver *otg,
+static int ab8500_usb_set_peripheral(struct usb_phy *otg,
 		struct usb_gadget *gadget)
 {
 	struct ab8500_usb *ab;
@@ -329,7 +329,7 @@ static int ab8500_usb_set_peripheral(struct otg_transceiver *otg,
 	return 0;
 }
 
-static int ab8500_usb_set_host(struct otg_transceiver *otg,
+static int ab8500_usb_set_host(struct usb_phy *otg,
 					struct usb_bus *host)
 {
 	struct ab8500_usb *ab;
diff --git a/drivers/usb/otg/fsl_otg.c b/drivers/usb/otg/fsl_otg.c
index 0f420b2..2f0678d 100644
--- a/drivers/usb/otg/fsl_otg.c
+++ b/drivers/usb/otg/fsl_otg.c
@@ -452,7 +452,7 @@ void otg_reset_controller(void)
 /* Call suspend/resume routines in host driver */
 int fsl_otg_start_host(struct otg_fsm *fsm, int on)
 {
-	struct otg_transceiver *xceiv = fsm->transceiver;
+	struct usb_phy *xceiv = fsm->transceiver;
 	struct device *dev;
 	struct fsl_otg *otg_dev = container_of(xceiv, struct fsl_otg, otg);
 	u32 retval = 0;
@@ -518,7 +518,7 @@ end:
  */
 int fsl_otg_start_gadget(struct otg_fsm *fsm, int on)
 {
-	struct otg_transceiver *xceiv = fsm->transceiver;
+	struct usb_phy *xceiv = fsm->transceiver;
 	struct device *dev;
 
 	if (!xceiv->gadget || !xceiv->gadget->dev.parent)
@@ -542,7 +542,7 @@ int fsl_otg_start_gadget(struct otg_fsm *fsm, int on)
  * Called by initialization code of host driver.  Register host controller
  * to the OTG.  Suspend host for OTG role detection.
  */
-static int fsl_otg_set_host(struct otg_transceiver *otg_p, struct usb_bus *host)
+static int fsl_otg_set_host(struct usb_phy *otg_p, struct usb_bus *host)
 {
 	struct fsl_otg *otg_dev = container_of(otg_p, struct fsl_otg, otg);
 
@@ -587,7 +587,7 @@ static int fsl_otg_set_host(struct otg_transceiver *otg_p, struct usb_bus *host)
 }
 
 /* Called by initialization code of udc.  Register udc to OTG. */
-static int fsl_otg_set_peripheral(struct otg_transceiver *otg_p,
+static int fsl_otg_set_peripheral(struct usb_phy *otg_p,
 				  struct usb_gadget *gadget)
 {
 	struct fsl_otg *otg_dev = container_of(otg_p, struct fsl_otg, otg);
@@ -625,7 +625,7 @@ static int fsl_otg_set_peripheral(struct otg_transceiver *otg_p,
 }
 
 /* Set OTG port power, only for B-device */
-static int fsl_otg_set_power(struct otg_transceiver *otg_p, unsigned mA)
+static int fsl_otg_set_power(struct usb_phy *otg_p, unsigned mA)
 {
 	if (!fsl_otg_dev)
 		return -ENODEV;
@@ -658,7 +658,7 @@ static void fsl_otg_event(struct work_struct *work)
 }
 
 /* B-device start SRP */
-static int fsl_otg_start_srp(struct otg_transceiver *otg_p)
+static int fsl_otg_start_srp(struct usb_phy *otg_p)
 {
 	struct fsl_otg *otg_dev = container_of(otg_p, struct fsl_otg, otg);
 
@@ -673,7 +673,7 @@ static int fsl_otg_start_srp(struct otg_transceiver *otg_p)
 }
 
 /* A_host suspend will call this function to start hnp */
-static int fsl_otg_start_hnp(struct otg_transceiver *otg_p)
+static int fsl_otg_start_hnp(struct usb_phy *otg_p)
 {
 	struct fsl_otg *otg_dev = container_of(otg_p, struct fsl_otg, otg);
 
@@ -698,7 +698,7 @@ static int fsl_otg_start_hnp(struct otg_transceiver *otg_p)
 irqreturn_t fsl_otg_isr(int irq, void *dev_id)
 {
 	struct otg_fsm *fsm = &((struct fsl_otg *)dev_id)->fsm;
-	struct otg_transceiver *otg = &((struct fsl_otg *)dev_id)->otg;
+	struct usb_phy *otg = &((struct fsl_otg *)dev_id)->otg;
 	u32 otg_int_src, otg_sc;
 
 	otg_sc = fsl_readl(&usb_dr_regs->otgsc);
@@ -815,7 +815,7 @@ err:
 int usb_otg_start(struct platform_device *pdev)
 {
 	struct fsl_otg *p_otg;
-	struct otg_transceiver *otg_trans = otg_get_transceiver();
+	struct usb_phy *otg_trans = otg_get_transceiver();
 	struct otg_fsm *fsm;
 	int status;
 	struct resource *res;
diff --git a/drivers/usb/otg/fsl_otg.h b/drivers/usb/otg/fsl_otg.h
index 3f8ef73..caec254 100644
--- a/drivers/usb/otg/fsl_otg.h
+++ b/drivers/usb/otg/fsl_otg.h
@@ -369,7 +369,7 @@ inline struct fsl_otg_timer *otg_timer_initializer
 }
 
 struct fsl_otg {
-	struct otg_transceiver otg;
+	struct usb_phy otg;
 	struct otg_fsm fsm;
 	struct usb_dr_mmap *dr_mem_map;
 	struct delayed_work otg_event;
diff --git a/drivers/usb/otg/gpio_vbus.c b/drivers/usb/otg/gpio_vbus.c
index 52733d9..5e4c7a0 100644
--- a/drivers/usb/otg/gpio_vbus.c
+++ b/drivers/usb/otg/gpio_vbus.c
@@ -31,7 +31,7 @@
  * Needs to be loaded before the UDC driver that will use it.
  */
 struct gpio_vbus_data {
-	struct otg_transceiver otg;
+	struct usb_phy		otg;
 	struct device          *dev;
 	struct regulator       *vbus_draw;
 	int			vbus_draw_enabled;
@@ -148,7 +148,7 @@ static irqreturn_t gpio_vbus_irq(int irq, void *data)
 /* OTG transceiver interface */
 
 /* bind/unbind the peripheral controller */
-static int gpio_vbus_set_peripheral(struct otg_transceiver *otg,
+static int gpio_vbus_set_peripheral(struct usb_phy *otg,
 				struct usb_gadget *gadget)
 {
 	struct gpio_vbus_data *gpio_vbus;
@@ -188,7 +188,7 @@ static int gpio_vbus_set_peripheral(struct otg_transceiver *otg,
 }
 
 /* effective for B devices, ignored for A-peripheral */
-static int gpio_vbus_set_power(struct otg_transceiver *otg, unsigned mA)
+static int gpio_vbus_set_power(struct usb_phy *otg, unsigned mA)
 {
 	struct gpio_vbus_data *gpio_vbus;
 
@@ -200,7 +200,7 @@ static int gpio_vbus_set_power(struct otg_transceiver *otg, unsigned mA)
 }
 
 /* for non-OTG B devices: set/clear transceiver suspend mode */
-static int gpio_vbus_set_suspend(struct otg_transceiver *otg, int suspend)
+static int gpio_vbus_set_suspend(struct usb_phy *otg, int suspend)
 {
 	struct gpio_vbus_data *gpio_vbus;
 
diff --git a/drivers/usb/otg/isp1301_omap.c b/drivers/usb/otg/isp1301_omap.c
index ca9b690..a0250b2 100644
--- a/drivers/usb/otg/isp1301_omap.c
+++ b/drivers/usb/otg/isp1301_omap.c
@@ -52,7 +52,7 @@ MODULE_DESCRIPTION("ISP1301 USB OTG Transceiver Driver");
 MODULE_LICENSE("GPL");
 
 struct isp1301 {
-	struct otg_transceiver	otg;
+	struct usb_phy		otg;
 	struct i2c_client	*client;
 	void			(*i2c_release)(struct device *dev);
 
@@ -1274,7 +1274,7 @@ static int isp1301_otg_enable(struct isp1301 *isp)
 
 /* add or disable the host device+driver */
 static int
-isp1301_set_host(struct otg_transceiver *otg, struct usb_bus *host)
+isp1301_set_host(struct usb_phy *otg, struct usb_bus *host)
 {
 	struct isp1301	*isp = container_of(otg, struct isp1301, otg);
 
@@ -1330,7 +1330,7 @@ isp1301_set_host(struct otg_transceiver *otg, struct usb_bus *host)
 }
 
 static int
-isp1301_set_peripheral(struct otg_transceiver *otg, struct usb_gadget *gadget)
+isp1301_set_peripheral(struct usb_phy *otg, struct usb_gadget *gadget)
 {
 	struct isp1301	*isp = container_of(otg, struct isp1301, otg);
 #ifndef	CONFIG_USB_OTG
@@ -1399,7 +1399,7 @@ isp1301_set_peripheral(struct otg_transceiver *otg, struct usb_gadget *gadget)
 /*-------------------------------------------------------------------------*/
 
 static int
-isp1301_set_power(struct otg_transceiver *dev, unsigned mA)
+isp1301_set_power(struct usb_phy *dev, unsigned mA)
 {
 	if (!the_transceiver)
 		return -ENODEV;
@@ -1409,7 +1409,7 @@ isp1301_set_power(struct otg_transceiver *dev, unsigned mA)
 }
 
 static int
-isp1301_start_srp(struct otg_transceiver *dev)
+isp1301_start_srp(struct usb_phy *dev)
 {
 	struct isp1301	*isp = container_of(dev, struct isp1301, otg);
 	u32		otg_ctrl;
@@ -1436,7 +1436,7 @@ isp1301_start_srp(struct otg_transceiver *dev)
 }
 
 static int
-isp1301_start_hnp(struct otg_transceiver *dev)
+isp1301_start_hnp(struct usb_phy *dev)
 {
 #ifdef	CONFIG_USB_OTG
 	struct isp1301	*isp = container_of(dev, struct isp1301, otg);
diff --git a/drivers/usb/otg/langwell_otg.c b/drivers/usb/otg/langwell_otg.c
index f08f784..880cdf2 100644
--- a/drivers/usb/otg/langwell_otg.c
+++ b/drivers/usb/otg/langwell_otg.c
@@ -55,11 +55,11 @@ static void langwell_otg_remove(struct pci_dev *pdev);
 static int langwell_otg_suspend(struct pci_dev *pdev, pm_message_t message);
 static int langwell_otg_resume(struct pci_dev *pdev);
 
-static int langwell_otg_set_host(struct otg_transceiver *otg,
+static int langwell_otg_set_host(struct usb_phy *otg,
 				struct usb_bus *host);
-static int langwell_otg_set_peripheral(struct otg_transceiver *otg,
+static int langwell_otg_set_peripheral(struct usb_phy *otg,
 				struct usb_gadget *gadget);
-static int langwell_otg_start_srp(struct otg_transceiver *otg);
+static int langwell_otg_start_srp(struct usb_phy *otg);
 
 static const struct pci_device_id pci_ids[] = {{
 	.class =        ((PCI_CLASS_SERIAL_USB << 8) | 0xfe),
@@ -118,7 +118,7 @@ void langwell_update_transceiver(void)
 }
 EXPORT_SYMBOL(langwell_update_transceiver);
 
-static int langwell_otg_set_host(struct otg_transceiver *otg,
+static int langwell_otg_set_host(struct usb_phy *otg,
 					struct usb_bus *host)
 {
 	otg->host = host;
@@ -126,7 +126,7 @@ static int langwell_otg_set_host(struct otg_transceiver *otg,
 	return 0;
 }
 
-static int langwell_otg_set_peripheral(struct otg_transceiver *otg,
+static int langwell_otg_set_peripheral(struct usb_phy *otg,
 					struct usb_gadget *gadget)
 {
 	otg->gadget = gadget;
@@ -134,14 +134,14 @@ static int langwell_otg_set_peripheral(struct otg_transceiver *otg,
 	return 0;
 }
 
-static int langwell_otg_set_power(struct otg_transceiver *otg,
+static int langwell_otg_set_power(struct usb_phy *otg,
 				unsigned mA)
 {
 	return 0;
 }
 
 /* A-device drives vbus, controlled through IPC commands */
-static int langwell_otg_set_vbus(struct otg_transceiver *otg, bool enabled)
+static int langwell_otg_set_vbus(struct usb_phy *otg, bool enabled)
 {
 	struct langwell_otg		*lnw = the_transceiver;
 	u8				sub_id;
@@ -180,7 +180,7 @@ static void langwell_otg_chrg_vbus(int on)
 }
 
 /* Start SRP */
-static int langwell_otg_start_srp(struct otg_transceiver *otg)
+static int langwell_otg_start_srp(struct usb_phy *otg)
 {
 	struct langwell_otg		*lnw = the_transceiver;
 	struct intel_mid_otg_xceiv	*iotg = &lnw->iotg;
diff --git a/drivers/usb/otg/msm_otg.c b/drivers/usb/otg/msm_otg.c
index b276f8f..cba4737 100644
--- a/drivers/usb/otg/msm_otg.c
+++ b/drivers/usb/otg/msm_otg.c
@@ -235,7 +235,7 @@ static int msm_hsusb_ldo_set_mode(int on)
 	return ret < 0 ? ret : 0;
 }
 
-static int ulpi_read(struct otg_transceiver *otg, u32 reg)
+static int ulpi_read(struct usb_phy *otg, u32 reg)
 {
 	struct msm_otg *motg = container_of(otg, struct msm_otg, otg);
 	int cnt = 0;
@@ -260,7 +260,7 @@ static int ulpi_read(struct otg_transceiver *otg, u32 reg)
 	return ULPI_DATA_READ(readl(USB_ULPI_VIEWPORT));
 }
 
-static int ulpi_write(struct otg_transceiver *otg, u32 val, u32 reg)
+static int ulpi_write(struct usb_phy *otg, u32 val, u32 reg)
 {
 	struct msm_otg *motg = container_of(otg, struct msm_otg, otg);
 	int cnt = 0;
@@ -390,7 +390,7 @@ static int msm_otg_phy_reset(struct msm_otg *motg)
 }
 
 #define LINK_RESET_TIMEOUT_USEC		(250 * 1000)
-static int msm_otg_reset(struct otg_transceiver *otg)
+static int msm_otg_reset(struct usb_phy *otg)
 {
 	struct msm_otg *motg = container_of(otg, struct msm_otg, otg);
 	struct msm_otg_platform_data *pdata = motg->pdata;
@@ -448,7 +448,7 @@ static int msm_otg_reset(struct otg_transceiver *otg)
 #ifdef CONFIG_PM_SLEEP
 static int msm_otg_suspend(struct msm_otg *motg)
 {
-	struct otg_transceiver *otg = &motg->otg;
+	struct usb_phy *otg = &motg->otg;
 	struct usb_bus *bus = otg->host;
 	struct msm_otg_platform_data *pdata = motg->pdata;
 	int cnt = 0;
@@ -543,7 +543,7 @@ static int msm_otg_suspend(struct msm_otg *motg)
 
 static int msm_otg_resume(struct msm_otg *motg)
 {
-	struct otg_transceiver *otg = &motg->otg;
+	struct usb_phy *otg = &motg->otg;
 	struct usb_bus *bus = otg->host;
 	int cnt = 0;
 	unsigned temp;
@@ -627,7 +627,7 @@ static void msm_otg_notify_charger(struct msm_otg *motg, unsigned mA)
 	motg->cur_power = mA;
 }
 
-static int msm_otg_set_power(struct otg_transceiver *otg, unsigned mA)
+static int msm_otg_set_power(struct usb_phy *otg, unsigned mA)
 {
 	struct msm_otg *motg = container_of(otg, struct msm_otg, otg);
 
@@ -644,7 +644,7 @@ static int msm_otg_set_power(struct otg_transceiver *otg, unsigned mA)
 	return 0;
 }
 
-static void msm_otg_start_host(struct otg_transceiver *otg, int on)
+static void msm_otg_start_host(struct usb_phy *otg, int on)
 {
 	struct msm_otg *motg = container_of(otg, struct msm_otg, otg);
 	struct msm_otg_platform_data *pdata = motg->pdata;
@@ -683,7 +683,7 @@ static void msm_otg_start_host(struct otg_transceiver *otg, int on)
 	}
 }
 
-static int msm_otg_set_host(struct otg_transceiver *otg, struct usb_bus *host)
+static int msm_otg_set_host(struct usb_phy *otg, struct usb_bus *host)
 {
 	struct msm_otg *motg = container_of(otg, struct msm_otg, otg);
 	struct usb_hcd *hcd;
@@ -729,7 +729,7 @@ static int msm_otg_set_host(struct otg_transceiver *otg, struct usb_bus *host)
 	return 0;
 }
 
-static void msm_otg_start_peripheral(struct otg_transceiver *otg, int on)
+static void msm_otg_start_peripheral(struct usb_phy *otg, int on)
 {
 	struct msm_otg *motg = container_of(otg, struct msm_otg, otg);
 	struct msm_otg_platform_data *pdata = motg->pdata;
@@ -756,7 +756,7 @@ static void msm_otg_start_peripheral(struct otg_transceiver *otg, int on)
 
 }
 
-static int msm_otg_set_peripheral(struct otg_transceiver *otg,
+static int msm_otg_set_peripheral(struct usb_phy *otg,
 			struct usb_gadget *gadget)
 {
 	struct msm_otg *motg = container_of(otg, struct msm_otg, otg);
@@ -800,7 +800,7 @@ static int msm_otg_set_peripheral(struct otg_transceiver *otg,
 
 static bool msm_chg_check_secondary_det(struct msm_otg *motg)
 {
-	struct otg_transceiver *otg = &motg->otg;
+	struct usb_phy *otg = &motg->otg;
 	u32 chg_det;
 	bool ret = false;
 
@@ -821,7 +821,7 @@ static bool msm_chg_check_secondary_det(struct msm_otg *motg)
 
 static void msm_chg_enable_secondary_det(struct msm_otg *motg)
 {
-	struct otg_transceiver *otg = &motg->otg;
+	struct usb_phy *otg = &motg->otg;
 	u32 chg_det;
 
 	switch (motg->pdata->phy_type) {
@@ -861,7 +861,7 @@ static void msm_chg_enable_secondary_det(struct msm_otg *motg)
 
 static bool msm_chg_check_primary_det(struct msm_otg *motg)
 {
-	struct otg_transceiver *otg = &motg->otg;
+	struct usb_phy *otg = &motg->otg;
 	u32 chg_det;
 	bool ret = false;
 
@@ -882,7 +882,7 @@ static bool msm_chg_check_primary_det(struct msm_otg *motg)
 
 static void msm_chg_enable_primary_det(struct msm_otg *motg)
 {
-	struct otg_transceiver *otg = &motg->otg;
+	struct usb_phy *otg = &motg->otg;
 	u32 chg_det;
 
 	switch (motg->pdata->phy_type) {
@@ -907,7 +907,7 @@ static void msm_chg_enable_primary_det(struct msm_otg *motg)
 
 static bool msm_chg_check_dcd(struct msm_otg *motg)
 {
-	struct otg_transceiver *otg = &motg->otg;
+	struct usb_phy *otg = &motg->otg;
 	u32 line_state;
 	bool ret = false;
 
@@ -928,7 +928,7 @@ static bool msm_chg_check_dcd(struct msm_otg *motg)
 
 static void msm_chg_disable_dcd(struct msm_otg *motg)
 {
-	struct otg_transceiver *otg = &motg->otg;
+	struct usb_phy *otg = &motg->otg;
 	u32 chg_det;
 
 	switch (motg->pdata->phy_type) {
@@ -947,7 +947,7 @@ static void msm_chg_disable_dcd(struct msm_otg *motg)
 
 static void msm_chg_enable_dcd(struct msm_otg *motg)
 {
-	struct otg_transceiver *otg = &motg->otg;
+	struct usb_phy *otg = &motg->otg;
 	u32 chg_det;
 
 	switch (motg->pdata->phy_type) {
@@ -968,7 +968,7 @@ static void msm_chg_enable_dcd(struct msm_otg *motg)
 
 static void msm_chg_block_on(struct msm_otg *motg)
 {
-	struct otg_transceiver *otg = &motg->otg;
+	struct usb_phy *otg = &motg->otg;
 	u32 func_ctrl, chg_det;
 
 	/* put the controller in non-driving mode */
@@ -1003,7 +1003,7 @@ static void msm_chg_block_on(struct msm_otg *motg)
 
 static void msm_chg_block_off(struct msm_otg *motg)
 {
-	struct otg_transceiver *otg = &motg->otg;
+	struct usb_phy *otg = &motg->otg;
 	u32 func_ctrl, chg_det;
 
 	switch (motg->pdata->phy_type) {
@@ -1038,7 +1038,7 @@ static void msm_chg_block_off(struct msm_otg *motg)
 static void msm_chg_detect_work(struct work_struct *w)
 {
 	struct msm_otg *motg = container_of(w, struct msm_otg, chg_work.work);
-	struct otg_transceiver *otg = &motg->otg;
+	struct usb_phy *otg = &motg->otg;
 	bool is_dcd, tmout, vout;
 	unsigned long delay;
 
@@ -1152,7 +1152,7 @@ static void msm_otg_init_sm(struct msm_otg *motg)
 static void msm_otg_sm_work(struct work_struct *w)
 {
 	struct msm_otg *motg = container_of(w, struct msm_otg, sm_work);
-	struct otg_transceiver *otg = &motg->otg;
+	struct usb_phy *otg = &motg->otg;
 
 	switch (otg->state) {
 	case OTG_STATE_UNDEFINED:
@@ -1243,7 +1243,7 @@ static void msm_otg_sm_work(struct work_struct *w)
 static irqreturn_t msm_otg_irq(int irq, void *data)
 {
 	struct msm_otg *motg = data;
-	struct otg_transceiver *otg = &motg->otg;
+	struct usb_phy *otg = &motg->otg;
 	u32 otgsc = 0;
 
 	if (atomic_read(&motg->in_lpm)) {
@@ -1281,7 +1281,7 @@ static irqreturn_t msm_otg_irq(int irq, void *data)
 static int msm_otg_mode_show(struct seq_file *s, void *unused)
 {
 	struct msm_otg *motg = s->private;
-	struct otg_transceiver *otg = &motg->otg;
+	struct usb_phy *otg = &motg->otg;
 
 	switch (otg->state) {
 	case OTG_STATE_A_HOST:
@@ -1309,7 +1309,7 @@ static ssize_t msm_otg_mode_write(struct file *file, const char __user *ubuf,
 	struct seq_file *s = file->private_data;
 	struct msm_otg *motg = s->private;
 	char buf[16];
-	struct otg_transceiver *otg = &motg->otg;
+	struct usb_phy *otg = &motg->otg;
 	int status = count;
 	enum usb_mode_type req_mode;
 
@@ -1414,7 +1414,7 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	int ret = 0;
 	struct resource *res;
 	struct msm_otg *motg;
-	struct otg_transceiver *otg;
+	struct usb_phy *otg;
 
 	dev_info(&pdev->dev, "msm_otg probe\n");
 	if (!pdev->dev.platform_data) {
@@ -1598,7 +1598,7 @@ free_motg:
 static int __devexit msm_otg_remove(struct platform_device *pdev)
 {
 	struct msm_otg *motg = platform_get_drvdata(pdev);
-	struct otg_transceiver *otg = &motg->otg;
+	struct usb_phy *otg = &motg->otg;
 	int cnt = 0;
 
 	if (otg->host || otg->gadget)
@@ -1660,7 +1660,7 @@ static int __devexit msm_otg_remove(struct platform_device *pdev)
 static int msm_otg_runtime_idle(struct device *dev)
 {
 	struct msm_otg *motg = dev_get_drvdata(dev);
-	struct otg_transceiver *otg = &motg->otg;
+	struct usb_phy *otg = &motg->otg;
 
 	dev_dbg(dev, "OTG runtime idle\n");
 
diff --git a/drivers/usb/otg/nop-usb-xceiv.c b/drivers/usb/otg/nop-usb-xceiv.c
index c1e3600..2ab0279 100644
--- a/drivers/usb/otg/nop-usb-xceiv.c
+++ b/drivers/usb/otg/nop-usb-xceiv.c
@@ -33,7 +33,7 @@
 #include <linux/slab.h>
 
 struct nop_usb_xceiv {
-	struct otg_transceiver	otg;
+	struct usb_phy		otg;
 	struct device		*dev;
 };
 
@@ -58,17 +58,17 @@ void usb_nop_xceiv_unregister(void)
 }
 EXPORT_SYMBOL(usb_nop_xceiv_unregister);
 
-static inline struct nop_usb_xceiv *xceiv_to_nop(struct otg_transceiver *x)
+static inline struct nop_usb_xceiv *xceiv_to_nop(struct usb_phy *x)
 {
 	return container_of(x, struct nop_usb_xceiv, otg);
 }
 
-static int nop_set_suspend(struct otg_transceiver *x, int suspend)
+static int nop_set_suspend(struct usb_phy *x, int suspend)
 {
 	return 0;
 }
 
-static int nop_set_peripheral(struct otg_transceiver *x,
+static int nop_set_peripheral(struct usb_phy *x,
 		struct usb_gadget *gadget)
 {
 	struct nop_usb_xceiv *nop;
@@ -88,7 +88,7 @@ static int nop_set_peripheral(struct otg_transceiver *x,
 	return 0;
 }
 
-static int nop_set_host(struct otg_transceiver *x, struct usb_bus *host)
+static int nop_set_host(struct usb_phy *x, struct usb_bus *host)
 {
 	struct nop_usb_xceiv *nop;
 
diff --git a/drivers/usb/otg/otg.c b/drivers/usb/otg/otg.c
index fb7adef..059c487 100644
--- a/drivers/usb/otg/otg.c
+++ b/drivers/usb/otg/otg.c
@@ -14,7 +14,7 @@
 
 #include <linux/usb/otg.h>
 
-static struct otg_transceiver *xceiv;
+static struct usb_phy *xceiv;
 
 /**
  * otg_get_transceiver - find the (single) OTG transceiver
@@ -25,7 +25,7 @@ static struct otg_transceiver *xceiv;
  *
  * For use by USB host and peripheral drivers.
  */
-struct otg_transceiver *otg_get_transceiver(void)
+struct usb_phy *otg_get_transceiver(void)
 {
 	if (xceiv)
 		get_device(xceiv->dev);
@@ -41,7 +41,7 @@ EXPORT_SYMBOL(otg_get_transceiver);
  *
  * For use by USB host and peripheral drivers.
  */
-void otg_put_transceiver(struct otg_transceiver *x)
+void otg_put_transceiver(struct usb_phy *x)
 {
 	if (x)
 		put_device(x->dev);
@@ -56,7 +56,7 @@ EXPORT_SYMBOL(otg_put_transceiver);
  * coordinate the activities of drivers for host and peripheral
  * controllers, and in some cases for VBUS current regulation.
  */
-int otg_set_transceiver(struct otg_transceiver *x)
+int otg_set_transceiver(struct usb_phy *x)
 {
 	if (xceiv && x)
 		return -EBUSY;
diff --git a/drivers/usb/otg/otg_fsm.h b/drivers/usb/otg/otg_fsm.h
index 0cecf1d..5e589ae 100644
--- a/drivers/usb/otg/otg_fsm.h
+++ b/drivers/usb/otg/otg_fsm.h
@@ -82,7 +82,7 @@ struct otg_fsm {
 	int loc_sof;
 
 	struct otg_fsm_ops *ops;
-	struct otg_transceiver *transceiver;
+	struct usb_phy *transceiver;
 
 	/* Current usb protocol used: 0:undefine; 1:host; 2:client */
 	int protocol;
diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
index 14f66c3..beeecc2 100644
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -144,7 +144,7 @@
 #define GPIO_USB_4PIN_ULPI_2430C	(3 << 0)
 
 struct twl4030_usb {
-	struct otg_transceiver	otg;
+	struct usb_phy		otg;
 	struct device		*dev;
 
 	/* TWL4030 internal USB regulator supplies */
@@ -548,7 +548,7 @@ static void twl4030_usb_phy_init(struct twl4030_usb *twl)
 	sysfs_notify(&twl->dev->kobj, NULL, "vbus");
 }
 
-static int twl4030_set_suspend(struct otg_transceiver *x, int suspend)
+static int twl4030_set_suspend(struct usb_phy *x, int suspend)
 {
 	struct twl4030_usb *twl = xceiv_to_twl(x);
 
@@ -560,7 +560,7 @@ static int twl4030_set_suspend(struct otg_transceiver *x, int suspend)
 	return 0;
 }
 
-static int twl4030_set_peripheral(struct otg_transceiver *x,
+static int twl4030_set_peripheral(struct usb_phy *x,
 		struct usb_gadget *gadget)
 {
 	struct twl4030_usb *twl;
@@ -576,7 +576,7 @@ static int twl4030_set_peripheral(struct otg_transceiver *x,
 	return 0;
 }
 
-static int twl4030_set_host(struct otg_transceiver *x, struct usb_bus *host)
+static int twl4030_set_host(struct usb_phy *x, struct usb_bus *host)
 {
 	struct twl4030_usb *twl;
 
diff --git a/drivers/usb/otg/twl6030-usb.c b/drivers/usb/otg/twl6030-usb.c
index b4d2c09..e6e63fb 100644
--- a/drivers/usb/otg/twl6030-usb.c
+++ b/drivers/usb/otg/twl6030-usb.c
@@ -87,7 +87,7 @@
 #define	VBUS_DET			BIT(2)
 
 struct twl6030_usb {
-	struct otg_transceiver	otg;
+	struct usb_phy		otg;
 	struct device		*dev;
 
 	/* for vbus reporting with irqs disabled */
@@ -138,7 +138,7 @@ static inline u8 twl6030_readb(struct twl6030_usb *twl, u8 module, u8 address)
 }
 
 /*-------------------------------------------------------------------------*/
-static int twl6030_set_phy_clk(struct otg_transceiver *x, int on)
+static int twl6030_set_phy_clk(struct usb_phy *x, int on)
 {
 	struct twl6030_usb *twl;
 	struct device *dev;
@@ -153,7 +153,7 @@ static int twl6030_set_phy_clk(struct otg_transceiver *x, int on)
 	return 0;
 }
 
-static int twl6030_phy_init(struct otg_transceiver *x)
+static int twl6030_phy_init(struct usb_phy *x)
 {
 	struct twl6030_usb *twl;
 	struct device *dev;
@@ -171,7 +171,7 @@ static int twl6030_phy_init(struct otg_transceiver *x)
 	return 0;
 }
 
-static void twl6030_phy_shutdown(struct otg_transceiver *x)
+static void twl6030_phy_shutdown(struct usb_phy *x)
 {
 	struct twl6030_usb *twl;
 	struct device *dev;
@@ -183,7 +183,7 @@ static void twl6030_phy_shutdown(struct otg_transceiver *x)
 	pdata->phy_power(twl->dev, 0, 0);
 }
 
-static int twl6030_phy_suspend(struct otg_transceiver *x, int suspend)
+static int twl6030_phy_suspend(struct usb_phy *x, int suspend)
 {
 	struct twl6030_usb *twl = xceiv_to_twl(x);
 	struct device *dev = twl->dev;
@@ -194,7 +194,7 @@ static int twl6030_phy_suspend(struct otg_transceiver *x, int suspend)
 	return 0;
 }
 
-static int twl6030_start_srp(struct otg_transceiver *x)
+static int twl6030_start_srp(struct usb_phy *x)
 {
 	struct twl6030_usb *twl = xceiv_to_twl(x);
 
@@ -340,7 +340,7 @@ static irqreturn_t twl6030_usbotg_irq(int irq, void *_twl)
 	return IRQ_HANDLED;
 }
 
-static int twl6030_set_peripheral(struct otg_transceiver *x,
+static int twl6030_set_peripheral(struct usb_phy *x,
 		struct usb_gadget *gadget)
 {
 	struct twl6030_usb *twl;
@@ -356,7 +356,7 @@ static int twl6030_set_peripheral(struct otg_transceiver *x,
 	return 0;
 }
 
-static int twl6030_enable_irq(struct otg_transceiver *x)
+static int twl6030_enable_irq(struct usb_phy *x)
 {
 	struct twl6030_usb *twl = xceiv_to_twl(x);
 
@@ -392,7 +392,7 @@ static void otg_set_vbus_work(struct work_struct *data)
 							CHARGERUSB_CTRL1);
 }
 
-static int twl6030_set_vbus(struct otg_transceiver *x, bool enabled)
+static int twl6030_set_vbus(struct usb_phy *x, bool enabled)
 {
 	struct twl6030_usb *twl = xceiv_to_twl(x);
 
@@ -402,7 +402,7 @@ static int twl6030_set_vbus(struct otg_transceiver *x, bool enabled)
 	return 0;
 }
 
-static int twl6030_set_host(struct otg_transceiver *x, struct usb_bus *host)
+static int twl6030_set_host(struct usb_phy *x, struct usb_bus *host)
 {
 	struct twl6030_usb *twl;
 
diff --git a/drivers/usb/otg/ulpi.c b/drivers/usb/otg/ulpi.c
index 770d799..abc2339 100644
--- a/drivers/usb/otg/ulpi.c
+++ b/drivers/usb/otg/ulpi.c
@@ -48,7 +48,7 @@ static struct ulpi_info ulpi_ids[] = {
 	ULPI_INFO(ULPI_ID(0x0424, 0x0006), "SMSC USB331x"),
 };
 
-static int ulpi_set_otg_flags(struct otg_transceiver *otg)
+static int ulpi_set_otg_flags(struct usb_phy *otg)
 {
 	unsigned int flags = ULPI_OTG_CTRL_DP_PULLDOWN |
 			     ULPI_OTG_CTRL_DM_PULLDOWN;
@@ -72,7 +72,7 @@ static int ulpi_set_otg_flags(struct otg_transceiver *otg)
 	return otg_io_write(otg, flags, ULPI_OTG_CTRL);
 }
 
-static int ulpi_set_fc_flags(struct otg_transceiver *otg)
+static int ulpi_set_fc_flags(struct usb_phy *otg)
 {
 	unsigned int flags = 0;
 
@@ -114,7 +114,7 @@ static int ulpi_set_fc_flags(struct otg_transceiver *otg)
 	return otg_io_write(otg, flags, ULPI_FUNC_CTRL);
 }
 
-static int ulpi_set_ic_flags(struct otg_transceiver *otg)
+static int ulpi_set_ic_flags(struct usb_phy *otg)
 {
 	unsigned int flags = 0;
 
@@ -133,7 +133,7 @@ static int ulpi_set_ic_flags(struct otg_transceiver *otg)
 	return otg_io_write(otg, flags, ULPI_IFC_CTRL);
 }
 
-static int ulpi_set_flags(struct otg_transceiver *otg)
+static int ulpi_set_flags(struct usb_phy *otg)
 {
 	int ret;
 
@@ -148,7 +148,7 @@ static int ulpi_set_flags(struct otg_transceiver *otg)
 	return ulpi_set_fc_flags(otg);
 }
 
-static int ulpi_check_integrity(struct otg_transceiver *otg)
+static int ulpi_check_integrity(struct usb_phy *otg)
 {
 	int ret, i;
 	unsigned int val = 0x55;
@@ -174,7 +174,7 @@ static int ulpi_check_integrity(struct otg_transceiver *otg)
 	return 0;
 }
 
-static int ulpi_init(struct otg_transceiver *otg)
+static int ulpi_init(struct usb_phy *otg)
 {
 	int i, vid, pid, ret;
 	u32 ulpi_id = 0;
@@ -205,7 +205,7 @@ static int ulpi_init(struct otg_transceiver *otg)
 	return ulpi_set_flags(otg);
 }
 
-static int ulpi_set_host(struct otg_transceiver *otg, struct usb_bus *host)
+static int ulpi_set_host(struct usb_phy *otg, struct usb_bus *host)
 {
 	unsigned int flags = otg_io_read(otg, ULPI_IFC_CTRL);
 
@@ -230,7 +230,7 @@ static int ulpi_set_host(struct otg_transceiver *otg, struct usb_bus *host)
 	return otg_io_write(otg, flags, ULPI_IFC_CTRL);
 }
 
-static int ulpi_set_vbus(struct otg_transceiver *otg, bool on)
+static int ulpi_set_vbus(struct usb_phy *otg, bool on)
 {
 	unsigned int flags = otg_io_read(otg, ULPI_OTG_CTRL);
 
@@ -247,11 +247,11 @@ static int ulpi_set_vbus(struct otg_transceiver *otg, bool on)
 	return otg_io_write(otg, flags, ULPI_OTG_CTRL);
 }
 
-struct otg_transceiver *
+struct usb_phy *
 otg_ulpi_create(struct otg_io_access_ops *ops,
 		unsigned int flags)
 {
-	struct otg_transceiver *otg;
+	struct usb_phy *otg;
 
 	otg = kzalloc(sizeof(*otg), GFP_KERNEL);
 	if (!otg)
diff --git a/drivers/usb/otg/ulpi_viewport.c b/drivers/usb/otg/ulpi_viewport.c
index e9a37f9..e7b311b 100644
--- a/drivers/usb/otg/ulpi_viewport.c
+++ b/drivers/usb/otg/ulpi_viewport.c
@@ -40,7 +40,7 @@ static int ulpi_viewport_wait(void __iomem *view, u32 mask)
 	return -ETIMEDOUT;
 }
 
-static int ulpi_viewport_read(struct otg_transceiver *otg, u32 reg)
+static int ulpi_viewport_read(struct usb_phy *otg, u32 reg)
 {
 	int ret;
 	void __iomem *view = otg->io_priv;
@@ -58,7 +58,7 @@ static int ulpi_viewport_read(struct otg_transceiver *otg, u32 reg)
 	return ULPI_VIEW_DATA_READ(readl(view));
 }
 
-static int ulpi_viewport_write(struct otg_transceiver *otg, u32 val, u32 reg)
+static int ulpi_viewport_write(struct usb_phy *otg, u32 val, u32 reg)
 {
 	int ret;
 	void __iomem *view = otg->io_priv;
diff --git a/include/linux/usb/intel_mid_otg.h b/include/linux/usb/intel_mid_otg.h
index a0ccf79..756cf55 100644
--- a/include/linux/usb/intel_mid_otg.h
+++ b/include/linux/usb/intel_mid_otg.h
@@ -104,11 +104,11 @@ struct iotg_ulpi_access_ops {
 /*
  * the Intel MID (Langwell/Penwell) otg transceiver driver needs to interact
  * with device and host drivers to implement the USB OTG related feature. More
- * function members are added based on otg_transceiver data structure for this
+ * function members are added based on usb_phy data structure for this
  * purpose.
  */
 struct intel_mid_otg_xceiv {
-	struct otg_transceiver	otg;
+	struct usb_phy		otg;
 	struct otg_hsm		hsm;
 
 	/* base address */
@@ -147,7 +147,7 @@ struct intel_mid_otg_xceiv {
 
 };
 static inline
-struct intel_mid_otg_xceiv *otg_to_mid_xceiv(struct otg_transceiver *otg)
+struct intel_mid_otg_xceiv *otg_to_mid_xceiv(struct usb_phy *otg)
 {
 	return container_of(otg, struct intel_mid_otg_xceiv, otg);
 }
diff --git a/include/linux/usb/msm_hsusb.h b/include/linux/usb/msm_hsusb.h
index 00311fe..2d3547a 100644
--- a/include/linux/usb/msm_hsusb.h
+++ b/include/linux/usb/msm_hsusb.h
@@ -160,7 +160,7 @@ struct msm_otg_platform_data {
  *               detection process.
  */
 struct msm_otg {
-	struct otg_transceiver otg;
+	struct usb_phy otg;
 	struct msm_otg_platform_data *pdata;
 	int irq;
 	struct clk *clk;
diff --git a/include/linux/usb/otg.h b/include/linux/usb/otg.h
index d87f44f..e0bc557 100644
--- a/include/linux/usb/otg.h
+++ b/include/linux/usb/otg.h
@@ -43,14 +43,14 @@ enum usb_xceiv_events {
 	USB_EVENT_ENUMERATED,   /* gadget driver enumerated */
 };
 
-struct otg_transceiver;
+struct usb_phy;
 
 /* for transceivers connected thru an ULPI interface, the user must
  * provide access ops
  */
 struct otg_io_access_ops {
-	int (*read)(struct otg_transceiver *otg, u32 reg);
-	int (*write)(struct otg_transceiver *otg, u32 val, u32 reg);
+	int (*read)(struct usb_phy *x, u32 reg);
+	int (*write)(struct usb_phy *x, u32 val, u32 reg);
 };
 
 /*
@@ -59,7 +59,7 @@ struct otg_io_access_ops {
  * moment, using the transceiver, ID signal, HNP and sometimes static
  * configuration information (including "board isn't wired for otg").
  */
-struct otg_transceiver {
+struct usb_phy {
 	struct device		*dev;
 	const char		*label;
 	unsigned int		 flags;
@@ -82,40 +82,40 @@ struct otg_transceiver {
 	u16			port_change;
 
 	/* initialize/shutdown the OTG controller */
-	int	(*init)(struct otg_transceiver *otg);
-	void	(*shutdown)(struct otg_transceiver *otg);
+	int	(*init)(struct usb_phy *x);
+	void	(*shutdown)(struct usb_phy *x);
 
 	/* bind/unbind the host controller */
-	int	(*set_host)(struct otg_transceiver *otg,
+	int	(*set_host)(struct usb_phy *x,
 				struct usb_bus *host);
 
 	/* bind/unbind the peripheral controller */
-	int	(*set_peripheral)(struct otg_transceiver *otg,
+	int	(*set_peripheral)(struct usb_phy *x,
 				struct usb_gadget *gadget);
 
 	/* effective for B devices, ignored for A-peripheral */
-	int	(*set_power)(struct otg_transceiver *otg,
+	int	(*set_power)(struct usb_phy *x,
 				unsigned mA);
 
 	/* effective for A-peripheral, ignored for B devices */
-	int	(*set_vbus)(struct otg_transceiver *otg,
+	int	(*set_vbus)(struct usb_phy *x,
 				bool enabled);
 
 	/* for non-OTG B devices: set transceiver into suspend mode */
-	int	(*set_suspend)(struct otg_transceiver *otg,
+	int	(*set_suspend)(struct usb_phy *x,
 				int suspend);
 
 	/* for B devices only:  start session with A-Host */
-	int	(*start_srp)(struct otg_transceiver *otg);
+	int	(*start_srp)(struct usb_phy *x);
 
 	/* start or continue HNP role switch */
-	int	(*start_hnp)(struct otg_transceiver *otg);
+	int	(*start_hnp)(struct usb_phy *x);
 
 };
 
 
 /* for board-specific init logic */
-extern int otg_set_transceiver(struct otg_transceiver *);
+extern int otg_set_transceiver(struct usb_phy *);
 
 #if defined(CONFIG_NOP_USB_XCEIV) || (defined(CONFIG_NOP_USB_XCEIV_MODULE) && defined(MODULE))
 /* sometimes transceivers are accessed only through e.g. ULPI */
@@ -132,50 +132,50 @@ static inline void usb_nop_xceiv_unregister(void)
 #endif
 
 /* helpers for direct access thru low-level io interface */
-static inline int otg_io_read(struct otg_transceiver *otg, u32 reg)
+static inline int otg_io_read(struct usb_phy *x, u32 reg)
 {
-	if (otg->io_ops && otg->io_ops->read)
-		return otg->io_ops->read(otg, reg);
+	if (x->io_ops && x->io_ops->read)
+		return x->io_ops->read(x, reg);
 
 	return -EINVAL;
 }
 
-static inline int otg_io_write(struct otg_transceiver *otg, u32 val, u32 reg)
+static inline int otg_io_write(struct usb_phy *x, u32 val, u32 reg)
 {
-	if (otg->io_ops && otg->io_ops->write)
-		return otg->io_ops->write(otg, val, reg);
+	if (x->io_ops && x->io_ops->write)
+		return x->io_ops->write(x, val, reg);
 
 	return -EINVAL;
 }
 
 static inline int
-otg_init(struct otg_transceiver *otg)
+otg_init(struct usb_phy *x)
 {
-	if (otg->init)
-		return otg->init(otg);
+	if (x->init)
+		return x->init(x);
 
 	return 0;
 }
 
 static inline void
-otg_shutdown(struct otg_transceiver *otg)
+otg_shutdown(struct usb_phy *x)
 {
-	if (otg->shutdown)
-		otg->shutdown(otg);
+	if (x->shutdown)
+		x->shutdown(x);
 }
 
 /* for usb host and peripheral controller drivers */
 #ifdef CONFIG_USB_OTG_UTILS
-extern struct otg_transceiver *otg_get_transceiver(void);
-extern void otg_put_transceiver(struct otg_transceiver *);
+extern struct usb_phy *otg_get_transceiver(void);
+extern void otg_put_transceiver(struct usb_phy *);
 extern const char *otg_state_string(enum usb_otg_state state);
 #else
-static inline struct otg_transceiver *otg_get_transceiver(void)
+static inline struct usb_phy *otg_get_transceiver(void)
 {
 	return NULL;
 }
 
-static inline void otg_put_transceiver(struct otg_transceiver *x)
+static inline void otg_put_transceiver(struct usb_phy *x)
 {
 }
 
@@ -187,67 +187,67 @@ static inline const char *otg_state_string(enum usb_otg_state state)
 
 /* Context: can sleep */
 static inline int
-otg_start_hnp(struct otg_transceiver *otg)
+otg_start_hnp(struct usb_phy *x)
 {
-	return otg->start_hnp(otg);
+	return x->start_hnp(x);
 }
 
 /* Context: can sleep */
 static inline int
-otg_set_vbus(struct otg_transceiver *otg, bool enabled)
+otg_set_vbus(struct usb_phy *x, bool enabled)
 {
-	return otg->set_vbus(otg, enabled);
+	return x->set_vbus(x, enabled);
 }
 
 /* for HCDs */
 static inline int
-otg_set_host(struct otg_transceiver *otg, struct usb_bus *host)
+otg_set_host(struct usb_phy *x, struct usb_bus *host)
 {
-	return otg->set_host(otg, host);
+	return x->set_host(x, host);
 }
 
 /* for usb peripheral controller drivers */
 
 /* Context: can sleep */
 static inline int
-otg_set_peripheral(struct otg_transceiver *otg, struct usb_gadget *periph)
+otg_set_peripheral(struct usb_phy *x, struct usb_gadget *periph)
 {
-	return otg->set_peripheral(otg, periph);
+	return x->set_peripheral(x, periph);
 }
 
 static inline int
-otg_set_power(struct otg_transceiver *otg, unsigned mA)
+otg_set_power(struct usb_phy *x, unsigned mA)
 {
-	return otg->set_power(otg, mA);
+	return x->set_power(x, mA);
 }
 
 /* Context: can sleep */
 static inline int
-otg_set_suspend(struct otg_transceiver *otg, int suspend)
+otg_set_suspend(struct usb_phy *x, int suspend)
 {
-	if (otg->set_suspend != NULL)
-		return otg->set_suspend(otg, suspend);
+	if (x->set_suspend != NULL)
+		return x->set_suspend(x, suspend);
 	else
 		return 0;
 }
 
 static inline int
-otg_start_srp(struct otg_transceiver *otg)
+otg_start_srp(struct usb_phy *x)
 {
-	return otg->start_srp(otg);
+	return x->start_srp(x);
 }
 
 /* notifiers */
 static inline int
-otg_register_notifier(struct otg_transceiver *otg, struct notifier_block *nb)
+otg_register_notifier(struct usb_phy *x, struct notifier_block *nb)
 {
-	return atomic_notifier_chain_register(&otg->notifier, nb);
+	return atomic_notifier_chain_register(&x->notifier, nb);
 }
 
 static inline void
-otg_unregister_notifier(struct otg_transceiver *otg, struct notifier_block *nb)
+otg_unregister_notifier(struct usb_phy *x, struct notifier_block *nb)
 {
-	atomic_notifier_chain_unregister(&otg->notifier, nb);
+	atomic_notifier_chain_unregister(&x->notifier, nb);
 }
 
 /* for OTG controller drivers (and maybe other stuff) */
diff --git a/include/linux/usb/ulpi.h b/include/linux/usb/ulpi.h
index 9595796..51ebf72 100644
--- a/include/linux/usb/ulpi.h
+++ b/include/linux/usb/ulpi.h
@@ -181,7 +181,7 @@
 
 /*-------------------------------------------------------------------------*/
 
-struct otg_transceiver *otg_ulpi_create(struct otg_io_access_ops *ops,
+struct usb_phy *otg_ulpi_create(struct otg_io_access_ops *ops,
 					unsigned int flags);
 
 #ifdef CONFIG_USB_ULPI_VIEWPORT
-- 
1.7.4.1

