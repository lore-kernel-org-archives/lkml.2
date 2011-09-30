Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab1I3Fn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 01:43:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52291 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab1I3Fny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 01:43:54 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>, <khilman@ti.com>,
        <b-cousson@ti.com>, <paul@pwsan.com>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <parthab@india.ti.com>, <tony@atomide.com>,
        <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>,
        Keshava Munegowda <Keshava_mgowda@ti.com>
Subject: [PATCH 4/5 v12] arm: omap: usb: device name change for the clk names of usbhs
Date: Fri, 30 Sep 2011 11:12:33 +0530
Message-ID: <1317361353-28319-1-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keshava Munegowda <Keshava_mgowda@ti.com>

device name usbhs clocks are changed from
usbhs-omap.0 to usbhs_omap; this is because
in the hwmod registration the device name is set
as usbhs_omap; The redudant clock nodes are removed.

Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
Reviewed-by: Partha Basak <parthab@india.ti.com>
---
 arch/arm/mach-omap2/clock3xxx_data.c |   26 ++++++++++++--------------
 arch/arm/mach-omap2/clock44xx_data.c |   10 +++++-----
 drivers/mfd/omap-usb-host.c          |    2 +-
 3 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/arch/arm/mach-omap2/clock3xxx_data.c b/arch/arm/mach-omap2/clock3xxx_data.c
index ffd55b1..63a822f 100644
--- a/arch/arm/mach-omap2/clock3xxx_data.c
+++ b/arch/arm/mach-omap2/clock3xxx_data.c
@@ -3285,7 +3285,7 @@ static struct omap_clk omap3xxx_clks[] = {
 	CLK(NULL,	"cpefuse_fck",	&cpefuse_fck,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
 	CLK(NULL,	"ts_fck",	&ts_fck,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
 	CLK(NULL,	"usbtll_fck",	&usbtll_fck,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
-	CLK("usbhs-omap.0",	"usbtll_fck",	&usbtll_fck,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
+	CLK("usbhs_omap",	"usbtll_fck",	&usbtll_fck,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
 	CLK("omap-mcbsp.1",	"prcm_fck",	&core_96m_fck,	CK_3XXX),
 	CLK("omap-mcbsp.5",	"prcm_fck",	&core_96m_fck,	CK_3XXX),
 	CLK(NULL,	"core_96m_fck",	&core_96m_fck,	CK_3XXX),
@@ -3321,7 +3321,7 @@ static struct omap_clk omap3xxx_clks[] = {
 	CLK(NULL,	"pka_ick",	&pka_ick,	CK_34XX | CK_36XX),
 	CLK(NULL,	"core_l4_ick",	&core_l4_ick,	CK_3XXX),
 	CLK(NULL,	"usbtll_ick",	&usbtll_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
-	CLK("usbhs-omap.0",	"usbtll_ick",	&usbtll_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
+	CLK("usbhs_omap",	"usbtll_ick",	&usbtll_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
 	CLK("omap_hsmmc.2",	"ick",	&mmchs3_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
 	CLK(NULL,	"icr_ick",	&icr_ick,	CK_34XX | CK_36XX),
 	CLK("omap-aes",	"ick",	&aes2_ick,	CK_34XX | CK_36XX),
@@ -3367,20 +3367,18 @@ static struct omap_clk omap3xxx_clks[] = {
 	CLK(NULL,	"cam_ick",	&cam_ick,	CK_34XX | CK_36XX),
 	CLK(NULL,	"csi2_96m_fck",	&csi2_96m_fck,	CK_34XX | CK_36XX),
 	CLK(NULL,	"usbhost_120m_fck", &usbhost_120m_fck, CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
-	CLK("usbhs-omap.0",	"hs_fck", &usbhost_120m_fck, CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
 	CLK(NULL,	"usbhost_48m_fck", &usbhost_48m_fck, CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
-	CLK("usbhs-omap.0",	"fs_fck", &usbhost_48m_fck, CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
 	CLK(NULL,	"usbhost_ick",	&usbhost_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
-	CLK("usbhs-omap.0",	"usbhost_ick",	&usbhost_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
-	CLK("usbhs-omap.0",	"utmi_p1_gfclk",	&dummy_ck,	CK_3XXX),
-	CLK("usbhs-omap.0",	"utmi_p2_gfclk",	&dummy_ck,	CK_3XXX),
-	CLK("usbhs-omap.0",	"xclk60mhsp1_ck",	&dummy_ck,	CK_3XXX),
-	CLK("usbhs-omap.0",	"xclk60mhsp2_ck",	&dummy_ck,	CK_3XXX),
-	CLK("usbhs-omap.0",	"usb_host_hs_utmi_p1_clk",	&dummy_ck,	CK_3XXX),
-	CLK("usbhs-omap.0",	"usb_host_hs_utmi_p2_clk",	&dummy_ck,	CK_3XXX),
-	CLK("usbhs-omap.0",	"usb_tll_hs_usb_ch0_clk",	&dummy_ck,	CK_3XXX),
-	CLK("usbhs-omap.0",	"usb_tll_hs_usb_ch1_clk",	&dummy_ck,	CK_3XXX),
-	CLK("usbhs-omap.0",	"init_60m_fclk",	&dummy_ck,	CK_3XXX),
+	CLK("usbhs_omap",	"usbhost_ick",	&usbhost_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
+	CLK("usbhs_omap",	"utmi_p1_gfclk",	&dummy_ck,	CK_3XXX),
+	CLK("usbhs_omap",	"utmi_p2_gfclk",	&dummy_ck,	CK_3XXX),
+	CLK("usbhs_omap",	"xclk60mhsp1_ck",	&dummy_ck,	CK_3XXX),
+	CLK("usbhs_omap",	"xclk60mhsp2_ck",	&dummy_ck,	CK_3XXX),
+	CLK("usbhs_omap",	"usb_host_hs_utmi_p1_clk",	&dummy_ck,	CK_3XXX),
+	CLK("usbhs_omap",	"usb_host_hs_utmi_p2_clk",	&dummy_ck,	CK_3XXX),
+	CLK("usbhs_omap",	"usb_tll_hs_usb_ch0_clk",	&dummy_ck,	CK_3XXX),
+	CLK("usbhs_omap",	"usb_tll_hs_usb_ch1_clk",	&dummy_ck,	CK_3XXX),
+	CLK("usbhs_omap",	"init_60m_fclk",	&dummy_ck,	CK_3XXX),
 	CLK(NULL,	"usim_fck",	&usim_fck,	CK_3430ES2PLUS | CK_36XX),
 	CLK(NULL,	"gpt1_fck",	&gpt1_fck,	CK_3XXX),
 	CLK(NULL,	"wkup_32k_fck",	&wkup_32k_fck,	CK_3XXX),
diff --git a/arch/arm/mach-omap2/clock44xx_data.c b/arch/arm/mach-omap2/clock44xx_data.c
index 2af0e3f..088977a 100644
--- a/arch/arm/mach-omap2/clock44xx_data.c
+++ b/arch/arm/mach-omap2/clock44xx_data.c
@@ -3281,7 +3281,7 @@ static struct omap_clk omap44xx_clks[] = {
 	CLK(NULL,	"uart2_fck",			&uart2_fck,	CK_443X),
 	CLK(NULL,	"uart3_fck",			&uart3_fck,	CK_443X),
 	CLK(NULL,	"uart4_fck",			&uart4_fck,	CK_443X),
-	CLK("usbhs-omap.0",	"fs_fck",		&usb_host_fs_fck,	CK_443X),
+	CLK("usbhs_omap",	"fs_fck",		&usb_host_fs_fck,	CK_443X),
 	CLK(NULL,	"utmi_p1_gfclk",		&utmi_p1_gfclk,	CK_443X),
 	CLK(NULL,	"usb_host_hs_utmi_p1_clk",	&usb_host_hs_utmi_p1_clk,	CK_443X),
 	CLK(NULL,	"utmi_p2_gfclk",		&utmi_p2_gfclk,	CK_443X),
@@ -3292,7 +3292,7 @@ static struct omap_clk omap44xx_clks[] = {
 	CLK(NULL,	"usb_host_hs_hsic60m_p2_clk",	&usb_host_hs_hsic60m_p2_clk,	CK_443X),
 	CLK(NULL,	"usb_host_hs_hsic480m_p2_clk",	&usb_host_hs_hsic480m_p2_clk,	CK_443X),
 	CLK(NULL,	"usb_host_hs_func48mclk",	&usb_host_hs_func48mclk,	CK_443X),
-	CLK("usbhs-omap.0",	"hs_fck",		&usb_host_hs_fck,	CK_443X),
+	CLK("usbhs_omap",	"hs_fck",		&usb_host_hs_fck,	CK_443X),
 	CLK(NULL,	"otg_60m_gfclk",		&otg_60m_gfclk,	CK_443X),
 	CLK(NULL,	"usb_otg_hs_xclk",		&usb_otg_hs_xclk,	CK_443X),
 	CLK("musb-omap2430",	"ick",				&usb_otg_hs_ick,	CK_443X),
@@ -3300,7 +3300,7 @@ static struct omap_clk omap44xx_clks[] = {
 	CLK(NULL,	"usb_tll_hs_usb_ch2_clk",	&usb_tll_hs_usb_ch2_clk,	CK_443X),
 	CLK(NULL,	"usb_tll_hs_usb_ch0_clk",	&usb_tll_hs_usb_ch0_clk,	CK_443X),
 	CLK(NULL,	"usb_tll_hs_usb_ch1_clk",	&usb_tll_hs_usb_ch1_clk,	CK_443X),
-	CLK("usbhs-omap.0",	"usbtll_ick",		&usb_tll_hs_ick,	CK_443X),
+	CLK("usbhs_omap",	"usbtll_ick",		&usb_tll_hs_ick,	CK_443X),
 	CLK(NULL,	"usim_ck",			&usim_ck,	CK_443X),
 	CLK(NULL,	"usim_fclk",			&usim_fclk,	CK_443X),
 	CLK(NULL,	"usim_fck",			&usim_fck,	CK_443X),
@@ -3360,8 +3360,8 @@ static struct omap_clk omap44xx_clks[] = {
 	CLK(NULL,	"uart2_ick",			&dummy_ck,	CK_443X),
 	CLK(NULL,	"uart3_ick",			&dummy_ck,	CK_443X),
 	CLK(NULL,	"uart4_ick",			&dummy_ck,	CK_443X),
-	CLK("usbhs-omap.0",	"usbhost_ick",		&dummy_ck,		CK_443X),
-	CLK("usbhs-omap.0",	"usbtll_fck",		&dummy_ck,	CK_443X),
+	CLK("usbhs_omap",	"usbhost_ick",		&dummy_ck,		CK_443X),
+	CLK("usbhs_omap",	"usbtll_fck",		&dummy_ck,	CK_443X),
 	CLK("omap_wdt",	"ick",				&dummy_ck,	CK_443X),
 };
 
diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 8db205e..9c2da29 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -27,7 +27,7 @@
 #include <linux/gpio.h>
 #include <plat/usb.h>
 
-#define USBHS_DRIVER_NAME	"usbhs-omap"
+#define USBHS_DRIVER_NAME	"usbhs_omap"
 #define OMAP_EHCI_DEVICE	"ehci-omap"
 #define OMAP_OHCI_DEVICE	"ohci-omap3"
 
-- 
1.6.0.4

