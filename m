Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1BBGpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 01:45:16 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52612 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab1BBGpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 01:45:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=OSHKtcXAGTi0A2SUywa2zJqLBJ2jxGEiWxo4WrcgzFYDlpGxgqeUCMlNQe+wjQsuhw
         BMhRikDEGd5q7nM5SxRh45hV6vawHObMCdJF1KCIFQwqqeOdBDHwOfJ6qvxqzw9aY+oz
         sqZLV+GlBrGphck/1OIwZZ6DKhfNdoYN5Rm74=
Subject: [PATCH] Staging: Westbridge: added ioremap_nocache instead of
 phys_to_virt
From: Sutharsan <sutharsan.tech@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, david.cross@cypress.com, srmt@cypress.com
Content-Type: text/plain
Date: Tue, 01 Feb 2011 22:45:04 -0800
Message-Id: <1296629104.3592.26.camel@sutharsan-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sutharsan Ramamoorthy <srmt@cypress.com>

This patch removes phys_to_virt() and adds ioremap_nocache() for
memory mapping the GPMC registers.

Signed-off-by: Sutharsan Ramamoorthy <srmt@cypress.com>

---

diff -uprN -X linux-2.6.37_vanilla/Documentation/dontdiff linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c linux-2.6.37-ptov/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c
--- linux-2.6.37_vanilla/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c	2010-11-29 20:42:04.000000000 -0800
+++ linux-2.6.37-ptov/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c	2011-02-01 16:00:31.214861085 -0800
@@ -347,11 +347,8 @@ static int cy_as_hal_gpmc_init(void)
 	u32 tmp32;
 	int err;
 	struct gpmc_timings	timings;
-	/*
-	 * get GPMC i/o registers base(already been i/o mapped
-	 * in kernel, no need for separate i/o remap)
-	 */
-	gpmc_base = phys_to_virt(OMAP34XX_GPMC_BASE);
+
+	gpmc_base = (u32)ioremap_nocache(OMAP34XX_GPMC_BASE, BLKSZ_4K);
 	DBGPRN(KERN_INFO "kernel has gpmc_base=%x , val@ the base=%x",
 		gpmc_base, __raw_readl(gpmc_base)
 	);

