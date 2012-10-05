Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab2JEKHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 06:07:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60613 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab2JEKHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 06:07:47 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <tony@atomide.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <kishon@ti.com>, <arnd@arndb.de>, <olof@lixom.net>,
        <rdunlap@xenotime.net>, <balbi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH 2/3] ARM: OMAP4: add _dev_attr_ to ocp2scp for representing usb_phy
Date: Fri, 5 Oct 2012 15:37:07 +0530
Message-ID: <1349431628-2819-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349431628-2819-1-git-send-email-kishon@ti.com>
References: <1349431628-2819-1-git-send-email-kishon@ti.com>
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
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 652d028..cf579b5 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -21,6 +21,7 @@
 #include <linux/io.h>
 #include <linux/platform_data/gpio-omap.h>
 #include <linux/power/smartreflex.h>
+#include <linux/platform_data/omap_ocp2scp.h>
 
 #include <plat/omap_hwmod.h>
 #include <plat/i2c.h>
@@ -2681,6 +2682,32 @@ static struct omap_hwmod_class omap44xx_ocp2scp_hwmod_class = {
 	.sysc	= &omap44xx_ocp2scp_sysc,
 };
 
+/* ocp2scp dev_attr */
+static struct resource omap44xx_usb_phy_and_pll_addrs[] = {
+	{
+		.name		= "usb_phy",
+		.start		= 0x4a0ad080,
+		.end		= 0x4a0ae000,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		/* XXX: Remove this once control module driver is in place */
+		.name		= "ctrl_dev",
+		.start		= 0x4a002300,
+		.end		= 0x4a002303,
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
 static struct omap_hwmod omap44xx_ocp2scp_usb_phy_hwmod = {
 	.name		= "ocp2scp_usb_phy",
@@ -2694,6 +2721,7 @@ static struct omap_hwmod omap44xx_ocp2scp_usb_phy_hwmod = {
 			.modulemode   = MODULEMODE_HWCTRL,
 		},
 	},
+	.dev_attr	= ocp2scp_dev_attr,
 };
 
 /*
-- 
1.7.9.5

