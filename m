Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab1KUUzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:55:31 -0500
Received: from brigitte.telenet-ops.be ([195.130.137.66]:49416 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671Ab1KUUyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:54:08 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 7/8] fbdev/amifb: Enable Copper DMA after setting up the Copper
Date: Mon, 21 Nov 2011 21:53:58 +0100
Message-Id: <1321908839-11419-7-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321908839-11419-1-git-send-email-geert@linux-m68k.org>
References: <1321908839-11419-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Else the Copper may start executing random instructions

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/amifb.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/video/amifb.c b/drivers/video/amifb.c
index 13e7a17..2bfaf1b 100644
--- a/drivers/video/amifb.c
+++ b/drivers/video/amifb.c
@@ -3733,17 +3733,15 @@ default_chipset:
 	memset(dummysprite, 0, DUMMYSPRITEMEMSIZE);
 
 	/*
-	 * Enable Display DMA
+	 * Make sure the Copper has something to do
 	 */
-
-	custom.dmacon = DMAF_SETCLR | DMAF_MASTER | DMAF_RASTER | DMAF_COPPER |
-			DMAF_BLITTER | DMAF_SPRITE;
+	ami_init_copper();
 
 	/*
-	 * Make sure the Copper has something to do
+	 * Enable Display DMA
 	 */
-
-	ami_init_copper();
+	custom.dmacon = DMAF_SETCLR | DMAF_MASTER | DMAF_RASTER | DMAF_COPPER |
+			DMAF_BLITTER | DMAF_SPRITE;
 
 	if (request_irq(IRQ_AMIGA_COPPER, amifb_interrupt, 0,
 			"fb vertb handler", &currentpar)) {
-- 
1.7.0.4

