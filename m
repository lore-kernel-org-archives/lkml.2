Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab1HOR0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 13:26:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:40253 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750790Ab1HOR0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 13:26:51 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18qPaxhWcIqQXxu+kNva34RH0Qq5SJfH0xAa+w9BK
	hrm88ZoFdEFDDD
From: Peter Huewe <peterhuewe@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Paul Mundt <lethal@linux-sh.org>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterhuewe@gmx.de, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] video/atmel_lcdfb: Fix build failure/typo for avr32 defconfig
Date: Mon, 15 Aug 2011 19:26:30 +0200
Message-Id: <1313429190-29275-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a typo which causes this build failure for the
avr32 defconfig:

drivers/video/atmel_lcdfb.c:63: error: request for member 'xres_virtual'
in something not a structure or union
make[3]: *** [drivers/video/atmel_lcdfb.o] Error 1

The typo was introduced by 895607ec
"atmel_lcdfb: use display information in info not in var for panning"

KernelVersion: Linux-next 20110812
The typo was introduced through the fbdev tree.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
So much for compile testing... ;)

 drivers/video/atmel_lcdfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 77153c6..63409c1 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -60,7 +60,7 @@ static void atmel_lcdfb_update_dma2d(struct atmel_lcdfb_info *sinfo,
 
 	pixeloff = (var->xoffset * info->var.bits_per_pixel) & 0x1f;
 
-	dma2dcfg = (info-var.xres_virtual - info->var.xres)
+	dma2dcfg = (info->var.xres_virtual - info->var.xres)
 		 * info->var.bits_per_pixel / 8;
 	dma2dcfg |= pixeloff << ATMEL_LCDC_PIXELOFF_OFFSET;
 	lcdc_writel(sinfo, ATMEL_LCDC_DMA2DCFG, dma2dcfg);
-- 
1.7.3.4

