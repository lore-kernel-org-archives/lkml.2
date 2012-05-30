Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab2E3K5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 06:57:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34513 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2E3K5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 06:57:10 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <paul@pwsan.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <b-cousson@ti.com>, <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        <kishon@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Subject: [RFC PATCH 4/5] ARM: OMAP4: add _dev_attr_ to ocp2scp for representing usb_phy
Date: Wed, 30 May 2012 16:26:33 +0530
Message-ID: <1338375394-16268-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1338375394-16268-1-git-send-email-kishon@ti.com>
References: <1338375394-16268-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to reflect devices(usb_phy) attached to ocp2scp bus, ocp2scp
is assigned a device attribute to represent the attached devices.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Benoit Cousson <b-cousson@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 249ff76..b5a91e8 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/io.h>
+#include <linux/platform_data/omap_ocp2scp.h>
 
 #include <plat/omap_hwmod.h>
 #include <plat/cpu.h>
@@ -2499,6 +2500,25 @@ static struct omap_hwmod_class omap44xx_ocp2scp_hwmod_class = {
 	.name	= "ocp2scp",
 };
 
+/* ocp2scp dev_attr */
+static struct resource omap44xx_usb_phy_and_pll_addrs[] = {
+	{
+		.name		= "usb_phy",
+		.start		= 0x4a0ad080,
+		.end		= 0x4a0ae000,
+		.flags		= IORESOURCE_MEM,
+	},
+	{ }
+};
+
+static struct omap_ocp2scp_dev ocp2scp_dev_attr[] = {
+	{
+		.drv_name       = "omap-usb2",
+		.res		= omap44xx_usb_phy_and_pll_addrs,
+	},
+	{ }
+};
+
 /* ocp2scp_usb_phy */
 static struct omap_hwmod_opt_clk ocp2scp_usb_phy_opt_clks[] = {
 	{ .role = "phy_48m", .clk = "ocp2scp_usb_phy_phy_48m" },
@@ -2516,6 +2536,7 @@ static struct omap_hwmod omap44xx_ocp2scp_usb_phy_hwmod = {
 			.modulemode   = MODULEMODE_HWCTRL,
 		},
 	},
+	.dev_attr	= ocp2scp_dev_attr,
 	.opt_clks	= ocp2scp_usb_phy_opt_clks,
 	.opt_clks_cnt	= ARRAY_SIZE(ocp2scp_usb_phy_opt_clks),
 };
-- 
1.7.5.4

