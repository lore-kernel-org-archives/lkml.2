Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab2IQRV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:21:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39717 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab2IQRUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:20:53 -0400
From: Matt Porter <mporter@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Lindgren <tony@atomide.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        AnilKumar <anilkumar@ti.com>
Subject: [PATCH v2 2/2] ARM: OMAP2+: Enable pinctrl dummy states
Date: Mon, 17 Sep 2012 13:22:18 -0400
Message-Id: <1347902538-21208-3-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347902538-21208-1-git-send-email-mporter@ti.com>
References: <1347902538-21208-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable pinctrl dummy states for all OMAP platforms that don't
populate DT. This allows drivers to be converted to pinctrl
and not generate new warnings on platforms that do not provide
pinctrl data. These platforms already have pinmuxes configured
before the drivers probe.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/mach-omap2/devices.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 1efa984..6ef4010 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -17,6 +17,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/pinctrl/machine.h>
 #include <linux/platform_data/omap4-keypad.h>
 
 #include <asm/mach-types.h>
@@ -628,6 +629,10 @@ static inline void omap_init_vout(void) {}
 
 static int __init omap2_init_devices(void)
 {
+	/* Enable dummy states for those platforms without pinctrl support */
+	if (!of_have_populated_dt())
+		pinctrl_provide_dummies();
+
 	/*
 	 * please keep these calls, and their implementations above,
 	 * in alphabetical order so they're easier to sort through.
-- 
1.7.9.5

