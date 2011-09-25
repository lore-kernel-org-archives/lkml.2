Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab1IYLCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 07:02:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56363 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab1IYLBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 07:01:41 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        <iommu@lists.linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Cousson Benoit <b-cousson@ti.com>,
        Kevin Hilman <khilman@ti.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [RFC 4/5] ARM: OMAP3: bind omap3isp_device to its iommu device
Date: Sun, 25 Sep 2011 13:58:56 +0300
Message-Id: <1316948337-7924-5-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316948337-7924-1-git-send-email-ohad@wizery.com>
References: <1316948337-7924-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bind OMAP3's isp device to the isp's dedicated iommu, by setting
the device's archdata iommu member.

This way omap3isp will be able to use the generic IOMMU API without
having to call any omap-specific binding method.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 arch/arm/mach-omap2/devices.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 1077ad6..44122f7 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -28,6 +28,7 @@
 #include <plat/mcbsp.h>
 #include <mach/gpio.h>
 #include <plat/mmc.h>
+#include <plat/iommu.h>
 #include <plat/dma.h>
 #include <plat/omap_hwmod.h>
 #include <plat/omap_device.h>
@@ -207,9 +208,15 @@ static struct platform_device omap3isp_device = {
 	.resource	= omap3isp_resources,
 };
 
+static struct omap_iommu_arch_data omap3_isp_iommu = {
+	.name = "isp",
+};
+
 int omap3_init_camera(struct isp_platform_data *pdata)
 {
 	omap3isp_device.dev.platform_data = pdata;
+	omap3isp_device.dev.archdata.iommu = &omap3_isp_iommu;
+
 	return platform_device_register(&omap3isp_device);
 }
 
-- 
1.7.4.1

