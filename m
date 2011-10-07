Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673Ab1JGJMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 05:12:20 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:59090 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab1JGJMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 05:12:18 -0400
Date: Fri, 7 Oct 2011 03:12:17 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Abhilash K V <abhilash.kv@ti.com>
cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        b-cousson@ti.com, aneesh@ti.com, khilman@ti.com,
        santosh.shilimkar@ti.com, christian.gmeiner@gmail.com
Subject: Re: [PATCH v5 1/3] AM35x: Using OMAP3 generic hwmods
In-Reply-To: <1317363153-10259-2-git-send-email-abhilash.kv@ti.com>
Message-ID: <alpine.DEB.2.00.1110070311290.4611@utopia.booyaka.com>
References: <1317363153-10259-1-git-send-email-abhilash.kv@ti.com> <1317363153-10259-2-git-send-email-abhilash.kv@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 30 Sep 2011, Abhilash K V wrote:

> From: Abhilash K V <abhilash.kv@ti.com>
> 
> Removing modules iva, sr1_hwmod, sr2_hwmod, mailbox from
> the base omap3xxx_hwmods list, so that they can be excluded
> for am35x.
> 
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>

I've dropped the mailbox class comments from this patch -- updated patch 
below:


- Paul

From: Abhilash K V <abhilash.kv@ti.com>
Date: Fri, 7 Oct 2011 03:08:56 -0600
Subject: [PATCH] AM35x: Using OMAP3 generic hwmods

Removing modules iva, sr1_hwmod, sr2_hwmod, mailbox from
the base omap3xxx_hwmods list, so that they can be excluded
for am35x.

Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
[paul@pwsan.com: dropped 'mailbox class' comments]
Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index ab35acb..ac12cd5 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -3132,7 +3132,6 @@ static __initdata struct omap_hwmod *omap3xxx_hwmods[] = {
 	&omap3xxx_mmc2_hwmod,
 	&omap3xxx_mmc3_hwmod,
 	&omap3xxx_mpu_hwmod,
-	&omap3xxx_iva_hwmod,
 
 	&omap3xxx_timer1_hwmod,
 	&omap3xxx_timer2_hwmod,
@@ -3161,8 +3160,6 @@ static __initdata struct omap_hwmod *omap3xxx_hwmods[] = {
 	&omap3xxx_i2c1_hwmod,
 	&omap3xxx_i2c2_hwmod,
 	&omap3xxx_i2c3_hwmod,
-	&omap34xx_sr1_hwmod,
-	&omap34xx_sr2_hwmod,
 
 	/* gpio class */
 	&omap3xxx_gpio1_hwmod,
@@ -3184,8 +3181,6 @@ static __initdata struct omap_hwmod *omap3xxx_hwmods[] = {
 	&omap3xxx_mcbsp2_sidetone_hwmod,
 	&omap3xxx_mcbsp3_sidetone_hwmod,
 
-	/* mailbox class */
-	&omap3xxx_mailbox_hwmod,
 
 	/* mcspi class */
 	&omap34xx_mcspi1,
@@ -3198,31 +3193,39 @@ static __initdata struct omap_hwmod *omap3xxx_hwmods[] = {
 
 /* 3430ES1-only hwmods */
 static __initdata struct omap_hwmod *omap3430es1_hwmods[] = {
+	&omap3xxx_iva_hwmod,
 	&omap3430es1_dss_core_hwmod,
+	&omap3xxx_mailbox_hwmod,
 	NULL
 };
 
 /* 3430ES2+-only hwmods */
 static __initdata struct omap_hwmod *omap3430es2plus_hwmods[] = {
+	&omap3xxx_iva_hwmod,
 	&omap3xxx_dss_core_hwmod,
 	&omap3xxx_usbhsotg_hwmod,
+	&omap3xxx_mailbox_hwmod,
 	NULL
 };
 
 /* 34xx-only hwmods (all ES revisions) */
 static __initdata struct omap_hwmod *omap34xx_hwmods[] = {
+	&omap3xxx_iva_hwmod,
 	&omap34xx_sr1_hwmod,
 	&omap34xx_sr2_hwmod,
+	&omap3xxx_mailbox_hwmod,
 	NULL
 };
 
 /* 36xx-only hwmods (all ES revisions) */
 static __initdata struct omap_hwmod *omap36xx_hwmods[] = {
+	&omap3xxx_iva_hwmod,
 	&omap3xxx_uart4_hwmod,
 	&omap3xxx_dss_core_hwmod,
 	&omap36xx_sr1_hwmod,
 	&omap36xx_sr2_hwmod,
 	&omap3xxx_usbhsotg_hwmod,
+	&omap3xxx_mailbox_hwmod,
 	NULL
 };
 
-- 
1.7.6.3

