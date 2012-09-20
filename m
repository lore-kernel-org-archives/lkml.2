Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab2ITOmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:42:39 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41616 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab2ITOm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:42:28 -0400
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>
Cc: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [RFC PATCH 06/13] ARM: omap: add hsmmc am33xx specific init
Date: Thu, 20 Sep 2012 10:43:39 -0400
Message-Id: <1348152226-13588-7-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348152226-13588-1-git-send-email-mporter@ti.com>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AM33xx requires special handling in hsmmc initialization
platform glue.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/mach-omap2/hsmmc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/hsmmc.c b/arch/arm/mach-omap2/hsmmc.c
index a9675d8..679fb43 100644
--- a/arch/arm/mach-omap2/hsmmc.c
+++ b/arch/arm/mach-omap2/hsmmc.c
@@ -364,7 +364,7 @@ static int __init omap_hsmmc_pdata_init(struct omap2_hsmmc_info *c,
 	else
 		mmc->slots[0].ocr_mask = c->ocr_mask;
 
-	if (!soc_is_am35xx())
+	if (!soc_is_am35xx() && !soc_is_am33xx())
 		mmc->slots[0].features |= HSMMC_HAS_PBIAS;
 
 	if (cpu_is_omap44xx() && (omap_rev() > OMAP4430_REV_ES1_0))
@@ -387,7 +387,7 @@ static int __init omap_hsmmc_pdata_init(struct omap2_hsmmc_info *c,
 			}
 		}
 
-		if (soc_is_am35xx())
+		if (soc_is_am35xx() || soc_is_am33xx())
 			mmc->slots[0].set_power = nop_mmc_set_power;
 
 		/* OMAP3630 HSMMC1 supports only 4-bit */
@@ -488,7 +488,8 @@ static void __init omap_hsmmc_init_one(struct omap2_hsmmc_info *hsmmcinfo,
 	if (res < 0)
 		goto free_mmc;
 
-	omap_hsmmc_mux(mmc_data, (ctrl_nr - 1));
+	if (!soc_is_am33xx())
+		omap_hsmmc_mux(mmc_data, (ctrl_nr - 1));
 
 	name = "omap_hsmmc";
 	res = snprintf(oh_name, MAX_OMAP_MMC_HWMOD_NAME_LEN,
-- 
1.7.9.5

