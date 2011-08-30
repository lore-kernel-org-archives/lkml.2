Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab1H3OBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 10:01:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46122 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877Ab1H3OBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 10:01:30 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <balbi@ti.com>,
        <gadiyar@ti.com>, <sameo@linux.intel.com>, <parthab@india.ti.com>,
        <tony@atomide.com>, <khilman@ti.com>, <b-cousson@ti.com>,
        <paul@pwsan.com>, <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>,
        Kishon Vijay Abraham <kishon@ti.com>
Subject: [PATCH 1/2] arm: omap: usb: Add mux initialization to ehci and ohci hwmods for omap4
Date: Tue, 30 Aug 2011 19:27:26 +0530
Message-ID: <1314712647-30008-2-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1314712647-30008-1-git-send-email-keshava_mgowda@ti.com>
References: <1314712647-30008-1-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kishon Vijay Abraham <kishon@ti.com>

For ehci and ohci hwmods, the omap4 mux initializations functions
are included.

Signed-off-by: Kishon Vijay Abraham <kishon@ti.com>
Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
---
 arch/arm/mach-omap2/usb-host.c |  546 +++++++++++++++++++++++++++++-----------
 1 files changed, 403 insertions(+), 143 deletions(-)

diff --git a/arch/arm/mach-omap2/usb-host.c b/arch/arm/mach-omap2/usb-host.c
index 9c37db9..9ec3d01 100644
--- a/arch/arm/mach-omap2/usb-host.c
+++ b/arch/arm/mach-omap2/usb-host.c
@@ -52,6 +52,355 @@ static struct omap_device_pm_latency omap_uhhtll_latency[] = {
 	  },
 };
 
+
+static struct omap_device_pad port1_phy_pads[] __initdata = {
+	{
+		.name = "usbb1_ulpitll_stp.usbb1_ulpiphy_stp",
+		.enable = OMAP_PIN_OUTPUT | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb1_ulpitll_clk.usbb1_ulpiphy_clk",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb1_ulpitll_dir.usbb1_ulpiphy_dir",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb1_ulpitll_nxt.usbb1_ulpiphy_nxt",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb1_ulpitll_dat0.usbb1_ulpiphy_dat0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb1_ulpitll_dat1.usbb1_ulpiphy_dat1",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb1_ulpitll_dat2.usbb1_ulpiphy_dat2",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb1_ulpitll_dat3.usbb1_ulpiphy_dat3",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb1_ulpitll_dat4.usbb1_ulpiphy_dat4",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb1_ulpitll_dat5.usbb1_ulpiphy_dat5",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb1_ulpitll_dat6.usbb1_ulpiphy_dat6",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb1_ulpitll_dat7.usbb1_ulpiphy_dat7",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+};
+
+static struct omap_device_pad port1_tll_pads[] __initdata = {
+	{
+		.name = "usbb1_ulpitll_stp.usbb1_ulpitll_stp",
+		.enable = OMAP_PIN_INPUT_PULLUP | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb1_ulpitll_clk.usbb1_ulpitll_clk",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb1_ulpitll_dir.usbb1_ulpitll_dir",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb1_ulpitll_nxt.usbb1_ulpitll_nxt",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb1_ulpitll_dat0.usbb1_ulpitll_dat0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb1_ulpitll_dat1.usbb1_ulpitll_dat1",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb1_ulpitll_dat2.usbb1_ulpitll_dat2",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb1_ulpitll_dat3.usbb1_ulpitll_dat3",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb1_ulpitll_dat4.usbb1_ulpitll_dat4",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb1_ulpitll_dat5.usbb1_ulpitll_dat5",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb1_ulpitll_dat6.usbb1_ulpitll_dat6",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb1_ulpitll_dat7.usbb1_ulpitll_dat7",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+};
+
+static struct omap_device_pad port2_phy_pads[] __initdata = {
+	{
+		.name = "usbb2_ulpitll_stp.usbb2_ulpiphy_stp",
+		.enable = OMAP_PIN_OUTPUT | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb2_ulpitll_clk.usbb2_ulpiphy_clk",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb2_ulpitll_dir.usbb2_ulpiphy_dir",
+		.enable	= OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb2_ulpitll_nxt.usbb2_ulpiphy_nxt",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb2_ulpitll_dat0.usbb2_ulpiphy_dat0",
+		.enable	= OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb2_ulpitll_dat1.usbb2_ulpiphy_dat1",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb2_ulpitll_dat2.usbb2_ulpiphy_dat2",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb2_ulpitll_dat3.usbb2_ulpiphy_dat3",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb2_ulpitll_dat4.usbb2_ulpiphy_dat4",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb2_ulpitll_dat5.usbb2_ulpiphy_dat5",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb2_ulpitll_dat6.usbb2_ulpiphy_dat6",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "usbb2_ulpitll_dat7.usbb2_ulpiphy_dat7",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+};
+
+static struct omap_device_pad port2_tll_pads[] __initdata = {
+	{
+		.name = "usbb2_ulpitll_stp.usbb2_ulpitll_stp",
+		.enable = OMAP_PIN_INPUT_PULLUP | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb2_ulpitll_clk.usbb2_ulpitll_clk",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb2_ulpitll_dir.usbb2_ulpitll_dir",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb2_ulpitll_nxt.usbb2_ulpitll_nxt",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb2_ulpitll_dat0.usbb2_ulpitll_dat0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb2_ulpitll_dat1.usbb2_ulpitll_dat1",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb2_ulpitll_dat2.usbb2_ulpitll_dat2",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb2_ulpitll_dat3.usbb2_ulpitll_dat3",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb2_ulpitll_dat4.usbb2_ulpitll_dat4",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb2_ulpitll_dat5.usbb2_ulpitll_dat5",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb2_ulpitll_dat6.usbb2_ulpitll_dat6",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+	{
+		.name = "usbb2_ulpitll_dat7.usbb2_ulpitll_dat7",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE0,
+	},
+};
+
+static struct omap_device_pad port1_6pin_pads[] __initdata = {
+	{
+		.name = "usbb1_ulpitll_stp.usbb1_mm_rxdp",
+		.enable	= OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "usbb1_ulpitll_nxt.usbb1_mm_rxdm",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "usbb1_ulpitll_dat0.usbb1_mm_rxrcv",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "usbb1_ulpitll_dat3.usbb1_mm_txen",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "usbb1_ulpitll_dat1.usbb1_mm_txdat",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "usbb1_ulpitll_dat2.usbb1_mm_txse0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+};
+
+static struct omap_device_pad port1_4pin_pads[] __initdata = {
+	{
+		.name = "usbb1_ulpitll_dat0.usbb1_mm_rxrcv",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "usbb1_ulpitll_dat3.usbb1_mm_txen",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "usbb1_ulpitll_dat1.usbb1_mm_txdat",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "usbb1_ulpitll_dat2.usbb1_mm_txse0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+};
+
+static struct omap_device_pad port1_3pin_pads[] __initdata = {
+	{
+		.name = "usbb1_ulpitll_dat3.usbb1_mm_txen",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "usbb1_ulpitll_dat1.usbb1_mm_txdat",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "usbb1_ulpitll_dat2.usbb1_mm_txse0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+};
+
+static struct omap_device_pad port1_2pin_pads[] __initdata = {
+	{
+		.name = "usbb1_ulpitll_dat1.usbb1_mm_txdat",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+	{
+		.name = "usbb1_ulpitll_dat2.usbb1_mm_txse0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE5,
+	},
+};
+
+static struct omap_device_pad port2_6pin_pads[] __initdata = {
+	{
+		.name = "abe_mcbsp2_dr.usbb2_mm_rxdp",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "abe_mcbsp2_clkx.usbb2_mm_rxdm",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "abe_mcbsp2_dx.usbb2_mm_rxrcv",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "abe_mcbsp2_fsx.usbb2_mm_txen",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "abe_dmic_din1.usbb2_mm_txdat",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "abe_dmic_clk1.usbb2_mm_txse0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+};
+
+static struct omap_device_pad port2_4pin_pads[] __initdata = {
+	{
+		.name = "abe_mcbsp2_dx.usbb2_mm_rxrcv",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "abe_mcbsp2_fsx.usbb2_mm_txen",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "abe_dmic_din1.usbb2_mm_txdat",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "abe_dmic_clk1.usbb2_mm_txse0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+};
+
+static struct omap_device_pad port2_3pin_pads[] __initdata = {
+	{
+		.name = "abe_mcbsp2_fsx.usbb2_mm_txen",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "abe_dmic_din1.usbb2_mm_txdat",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "abe_dmic_clk1.usbb2_mm_txse0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+};
+
+static struct omap_device_pad port2_2pin_pads[] __initdata = {
+	{
+		.name = "abe_dmic_din1.usbb2_mm_txdat",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+	{
+		.name = "abe_dmic_clk1.usbb2_mm_txse0",
+		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
+	},
+};
+
 /* MUX settings for EHCI pins */
 /*
  * setup_ehci_io_mux - initialize IO pad mux for USBHOST
@@ -199,121 +548,34 @@ static void setup_ehci_io_mux(const enum usbhs_omap_port_mode *port_mode)
 	return;
 }
 
-static void setup_4430ehci_io_mux(const enum usbhs_omap_port_mode *port_mode)
+static void setup_4430ehci_io_mux(const enum usbhs_omap_port_mode *port_mode,
+				struct omap_board_data *bdata)
 {
 	switch (port_mode[0]) {
 	case OMAP_EHCI_PORT_MODE_PHY:
-		omap_mux_init_signal("usbb1_ulpiphy_stp",
-			OMAP_PIN_OUTPUT);
-		omap_mux_init_signal("usbb1_ulpiphy_clk",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpiphy_dir",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpiphy_nxt",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpiphy_dat0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpiphy_dat1",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpiphy_dat2",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpiphy_dat3",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpiphy_dat4",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpiphy_dat5",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpiphy_dat6",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpiphy_dat7",
-			OMAP_PIN_INPUT_PULLDOWN);
-			break;
+		bdata->pads = port1_phy_pads;
+		bdata->pads_cnt = ARRAY_SIZE(port1_phy_pads);
+		break;
 	case OMAP_EHCI_PORT_MODE_TLL:
-		omap_mux_init_signal("usbb1_ulpitll_stp",
-			OMAP_PIN_INPUT_PULLUP);
-		omap_mux_init_signal("usbb1_ulpitll_clk",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpitll_dir",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpitll_nxt",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpitll_dat0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpitll_dat1",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpitll_dat2",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpitll_dat3",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpitll_dat4",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpitll_dat5",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpitll_dat6",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpitll_dat7",
-			OMAP_PIN_INPUT_PULLDOWN);
-			break;
+		bdata->pads = port1_tll_pads;
+		bdata->pads_cnt = ARRAY_SIZE(port1_tll_pads);
+		break;
 	case OMAP_USBHS_PORT_MODE_UNUSED:
 	default:
-			break;
+		break;
 	}
 	switch (port_mode[1]) {
 	case OMAP_EHCI_PORT_MODE_PHY:
-		omap_mux_init_signal("usbb2_ulpiphy_stp",
-			OMAP_PIN_OUTPUT);
-		omap_mux_init_signal("usbb2_ulpiphy_clk",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpiphy_dir",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpiphy_nxt",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpiphy_dat0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpiphy_dat1",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpiphy_dat2",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpiphy_dat3",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpiphy_dat4",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpiphy_dat5",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpiphy_dat6",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpiphy_dat7",
-			OMAP_PIN_INPUT_PULLDOWN);
-			break;
+		bdata->pads = port2_phy_pads;
+		bdata->pads_cnt = ARRAY_SIZE(port2_phy_pads);
+		break;
 	case OMAP_EHCI_PORT_MODE_TLL:
-		omap_mux_init_signal("usbb2_ulpitll_stp",
-			OMAP_PIN_INPUT_PULLUP);
-		omap_mux_init_signal("usbb2_ulpitll_clk",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpitll_dir",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpitll_nxt",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpitll_dat0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpitll_dat1",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpitll_dat2",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpitll_dat3",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpitll_dat4",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpitll_dat5",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpitll_dat6",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpitll_dat7",
-			OMAP_PIN_INPUT_PULLDOWN);
-			break;
+		bdata->pads = port2_tll_pads;
+		bdata->pads_cnt = ARRAY_SIZE(port2_tll_pads);
+		break;
 	case OMAP_USBHS_PORT_MODE_UNUSED:
 	default:
-			break;
+		break;
 	}
 }
 
@@ -414,35 +676,31 @@ static void setup_ohci_io_mux(const enum usbhs_omap_port_mode *port_mode)
 	}
 }
 
-static void setup_4430ohci_io_mux(const enum usbhs_omap_port_mode *port_mode)
+static void setup_4430ohci_io_mux(const enum usbhs_omap_port_mode *port_mode,
+				struct omap_board_data *bdata)
 {
 	switch (port_mode[0]) {
 	case OMAP_OHCI_PORT_MODE_PHY_6PIN_DATSE0:
 	case OMAP_OHCI_PORT_MODE_PHY_6PIN_DPDM:
 	case OMAP_OHCI_PORT_MODE_TLL_6PIN_DATSE0:
 	case OMAP_OHCI_PORT_MODE_TLL_6PIN_DPDM:
-		omap_mux_init_signal("usbb1_mm_rxdp",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_mm_rxdm",
-			OMAP_PIN_INPUT_PULLDOWN);
-
+		bdata->pads = port1_6pin_pads;
+		bdata->pads_cnt = ARRAY_SIZE(port1_6pin_pads);
+		break;
 	case OMAP_OHCI_PORT_MODE_PHY_4PIN_DPDM:
 	case OMAP_OHCI_PORT_MODE_TLL_4PIN_DPDM:
-		omap_mux_init_signal("usbb1_mm_rxrcv",
-			OMAP_PIN_INPUT_PULLDOWN);
-
+		bdata->pads = port1_4pin_pads;
+		bdata->pads_cnt = ARRAY_SIZE(port1_4pin_pads);
+		break;
 	case OMAP_OHCI_PORT_MODE_PHY_3PIN_DATSE0:
 	case OMAP_OHCI_PORT_MODE_TLL_3PIN_DATSE0:
-		omap_mux_init_signal("usbb1_mm_txen",
-			OMAP_PIN_INPUT_PULLDOWN);
-
-
+		bdata->pads = port1_3pin_pads;
+		bdata->pads_cnt = ARRAY_SIZE(port1_3pin_pads);
+		break;
 	case OMAP_OHCI_PORT_MODE_TLL_2PIN_DATSE0:
 	case OMAP_OHCI_PORT_MODE_TLL_2PIN_DPDM:
-		omap_mux_init_signal("usbb1_mm_txdat",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_mm_txse0",
-			OMAP_PIN_INPUT_PULLDOWN);
+		bdata->pads = port1_2pin_pads;
+		bdata->pads_cnt = ARRAY_SIZE(port1_2pin_pads);
 		break;
 
 	case OMAP_USBHS_PORT_MODE_UNUSED:
@@ -455,28 +713,23 @@ static void setup_4430ohci_io_mux(const enum usbhs_omap_port_mode *port_mode)
 	case OMAP_OHCI_PORT_MODE_PHY_6PIN_DPDM:
 	case OMAP_OHCI_PORT_MODE_TLL_6PIN_DATSE0:
 	case OMAP_OHCI_PORT_MODE_TLL_6PIN_DPDM:
-		omap_mux_init_signal("usbb2_mm_rxdp",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_mm_rxdm",
-			OMAP_PIN_INPUT_PULLDOWN);
-
+		bdata->pads = port2_6pin_pads;
+		bdata->pads_cnt = ARRAY_SIZE(port2_6pin_pads);
+		break;
 	case OMAP_OHCI_PORT_MODE_PHY_4PIN_DPDM:
 	case OMAP_OHCI_PORT_MODE_TLL_4PIN_DPDM:
-		omap_mux_init_signal("usbb2_mm_rxrcv",
-			OMAP_PIN_INPUT_PULLDOWN);
-
+		bdata->pads = port2_4pin_pads;
+		bdata->pads_cnt = ARRAY_SIZE(port2_4pin_pads);
+		break;
 	case OMAP_OHCI_PORT_MODE_PHY_3PIN_DATSE0:
 	case OMAP_OHCI_PORT_MODE_TLL_3PIN_DATSE0:
-		omap_mux_init_signal("usbb2_mm_txen",
-			OMAP_PIN_INPUT_PULLDOWN);
-
-
+		bdata->pads = port2_3pin_pads;
+		bdata->pads_cnt = ARRAY_SIZE(port2_3pin_pads);
+		break;
 	case OMAP_OHCI_PORT_MODE_TLL_2PIN_DATSE0:
 	case OMAP_OHCI_PORT_MODE_TLL_2PIN_DPDM:
-		omap_mux_init_signal("usbb2_mm_txdat",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_mm_txse0",
-			OMAP_PIN_INPUT_PULLDOWN);
+		bdata->pads = port2_2pin_pads;
+		bdata->pads_cnt = ARRAY_SIZE(port2_3pin_pads);
 		break;
 
 	case OMAP_USBHS_PORT_MODE_UNUSED:
@@ -491,7 +744,9 @@ void __init usbhs_init(const struct usbhs_omap_board_data *pdata)
 	struct omap_device	*od;
 	int			bus_id = -1;
 	int			i;
+	struct omap_board_data	bdata;
 
+	bdata.pads = NULL;
 	for (i = 0; i < OMAP3_HS_USB_PORTS; i++) {
 		usbhs_data.port_mode[i] = pdata->port_mode[i];
 		ohci_data.port_mode[i] = pdata->port_mode[i];
@@ -504,13 +759,6 @@ void __init usbhs_init(const struct usbhs_omap_board_data *pdata)
 	usbhs_data.ehci_data = &ehci_data;
 	usbhs_data.ohci_data = &ohci_data;
 
-	if (cpu_is_omap34xx()) {
-		setup_ehci_io_mux(pdata->port_mode);
-		setup_ohci_io_mux(pdata->port_mode);
-	} else if (cpu_is_omap44xx()) {
-		setup_4430ehci_io_mux(pdata->port_mode);
-		setup_4430ohci_io_mux(pdata->port_mode);
-	}
 
 	oh[0] = omap_hwmod_lookup(USBHS_UHH_HWMODNAME);
 	if (!oh[0]) {
@@ -536,6 +784,18 @@ void __init usbhs_init(const struct usbhs_omap_board_data *pdata)
 		return;
 	}
 
+	if (cpu_is_omap34xx()) {
+		setup_ehci_io_mux(pdata->port_mode);
+		setup_ohci_io_mux(pdata->port_mode);
+	} else if (cpu_is_omap44xx()) {
+		setup_4430ehci_io_mux(pdata->port_mode, &bdata);
+		oh[2]->mux = omap_hwmod_mux_init((&bdata)->pads,
+						bdata.pads_cnt);
+		setup_4430ohci_io_mux(pdata->port_mode, &bdata);
+		oh[1]->mux = omap_hwmod_mux_init((&bdata)->pads,
+						bdata.pads_cnt);
+	}
+
 	od = omap_device_build_ss(OMAP_USBHS_DEVICE, bus_id, oh, 4,
 				(void *)&usbhs_data, sizeof(usbhs_data),
 				omap_uhhtll_latency,
-- 
1.6.0.4

