Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab1DRTOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:14:09 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:48296 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab1DRTOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:14:08 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 01/12] staging: xgifb: replace outXGIREG() with outb()
Date: Mon, 18 Apr 2011 22:13:57 +0300
Message-Id: <1303154048-21989-2-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
References: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace outXGIREG() with outb().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 721bd25..d790eb3 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1235,15 +1235,15 @@ static int XGIfb_setcolreg(unsigned regno, unsigned red, unsigned green,
 
 	switch (info->var.bits_per_pixel) {
 	case 8:
-		outXGIREG(XGIDACA, regno);
-		outXGIREG(XGIDACD, (red >> 10));
-		outXGIREG(XGIDACD, (green >> 10));
-		outXGIREG(XGIDACD, (blue >> 10));
+		outb(regno, XGIDACA);
+		outb((red >> 10), XGIDACD);
+		outb((green >> 10), XGIDACD);
+		outb((blue >> 10), XGIDACD);
 		if (xgi_video_info.disp_state & DISPTYPE_DISP2) {
-			outXGIREG(XGIDAC2A, regno);
-			outXGIREG(XGIDAC2D, (red >> 8));
-			outXGIREG(XGIDAC2D, (green >> 8));
-			outXGIREG(XGIDAC2D, (blue >> 8));
+			outb(regno, XGIDAC2A);
+			outb((red >> 8), XGIDAC2D);
+			outb((green >> 8), XGIDAC2D);
+			outb((blue >> 8), XGIDAC2D);
 		}
 		break;
 	case 16:
-- 
1.5.6.5

