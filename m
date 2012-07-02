Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab2GBIz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:55:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57967 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170Ab2GBIz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:55:57 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <paul@pwsan.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <b-cousson@ti.com>, <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        <kishon@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Subject: [PATCH] arm: omap: hwmod: make *phy_48m* as the main_clk of ocp2scp
Date: Mon, 2 Jul 2012 14:25:37 +0530
Message-ID: <1341219337-25815-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Made *ocp2scp_usb_phy_phy_48m* as the main_clk for ocp2scp.
Since this ocp2scp module does not have any fck but does have a
single opt_clock, it is added as the main_clk for ocp2scp. Also
removed phy_48m as the optional clock since it is now made as the
main clock.

Cc: Benoît Cousson <b-cousson@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
Changes from [RFC PATCH 1/5] arm: omap: hwmod: make *phy_48m* as the main_clk
of ocp2scp:
* Removed *ocp2scp_usb_phy_phy_48m* as the optional functional clock

 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index f30e861..17cf933 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -2504,14 +2504,11 @@ static struct omap_hwmod_class omap44xx_ocp2scp_hwmod_class = {
 };
 
 /* ocp2scp_usb_phy */
-static struct omap_hwmod_opt_clk ocp2scp_usb_phy_opt_clks[] = {
-	{ .role = "phy_48m", .clk = "ocp2scp_usb_phy_phy_48m" },
-};
-
 static struct omap_hwmod omap44xx_ocp2scp_usb_phy_hwmod = {
 	.name		= "ocp2scp_usb_phy",
 	.class		= &omap44xx_ocp2scp_hwmod_class,
 	.clkdm_name	= "l3_init_clkdm",
+	.main_clk	= "ocp2scp_usb_phy_phy_48m",
 	.prcm = {
 		.omap4 = {
 			.clkctrl_offs = OMAP4_CM_L3INIT_USBPHYOCP2SCP_CLKCTRL_OFFSET,
@@ -2519,8 +2516,6 @@ static struct omap_hwmod omap44xx_ocp2scp_usb_phy_hwmod = {
 			.modulemode   = MODULEMODE_HWCTRL,
 		},
 	},
-	.opt_clks	= ocp2scp_usb_phy_opt_clks,
-	.opt_clks_cnt	= ARRAY_SIZE(ocp2scp_usb_phy_opt_clks),
 };
 
 /*
-- 
1.7.5.4

