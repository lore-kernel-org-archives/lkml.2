Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab2IKRpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:45:39 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60696 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2IKRph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:45:37 -0400
From: Matt Porter <mporter@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Lindgren <tony@atomide.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        AnilKumar <anilkumar@ti.com>
Subject: [PATCH 2/2] ARM: OMAP2+: Enable pinctrl dummy states
Date: Tue, 11 Sep 2012 13:46:39 -0400
Message-Id: <1347385599-27558-3-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347385599-27558-1-git-send-email-mporter@ti.com>
References: <1347385599-27558-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable pinctrl dummy states for all OMAP platforms. This allows
drivers to be converted to pinctrl while still running on
platforms that do not provide pinctrl data.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/mach-omap2/devices.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index c00c689..577cd04 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -17,6 +17,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/pinctrl/machine.h>
 #include <linux/platform_data/omap4-keypad.h>
 
 #include <mach/hardware.h>
@@ -631,6 +632,9 @@ static inline void omap_init_vout(void) {}
 
 static int __init omap2_init_devices(void)
 {
+	/* Enable dummy states for those platforms without pinctrl support */
+	pinctrl_provide_dummies();
+
 	/*
 	 * please keep these calls, and their implementations above,
 	 * in alphabetical order so they're easier to sort through.
-- 
1.7.9.5

