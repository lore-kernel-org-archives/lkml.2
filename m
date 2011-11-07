Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186Ab1KGR5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 12:57:06 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:37058 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932732Ab1KGR5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 12:57:04 -0500
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH] arm: omap2+: hwmod: fix breakage introduced by d6504acd
Date: Mon,  7 Nov 2011 19:56:57 +0200
Message-Id: <1320688617-4543-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.8.rc0
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d6504acd (OMAP2+: hwmod: remove OMAP_CHIP*) has
mistakenly added MUSB as a hwmod available only on ES2.0
of OMAP3430.

MUSB hwmod has always be available on all OMAP revisions
since OMAP2430.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index 3008e16..74f1454 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -3232,7 +3232,6 @@ static __initdata struct omap_hwmod *omap3430es1_hwmods[] = {
 /* 3430ES2+-only hwmods */
 static __initdata struct omap_hwmod *omap3430es2plus_hwmods[] = {
 	&omap3xxx_dss_core_hwmod,
-	&omap3xxx_usbhsotg_hwmod,
 	NULL
 };
 
@@ -3240,6 +3239,7 @@ static __initdata struct omap_hwmod *omap3430es2plus_hwmods[] = {
 static __initdata struct omap_hwmod *omap34xx_hwmods[] = {
 	&omap34xx_sr1_hwmod,
 	&omap34xx_sr2_hwmod,
+	&omap3xxx_usbhsotg_hwmod,
 	NULL
 };
 
-- 
1.7.8.rc0

