Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab1DRTOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:14:11 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:48305 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab1DRTOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:14:08 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 05/12] staging: xgifb: replace andXGIIDXREG() with xgifb_reg_and()
Date: Mon, 18 Apr 2011 22:14:01 +0300
Message-Id: <1303154048-21989-6-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
References: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace andXGIIDXREG() with xgifb_reg_and().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 2f2c275..1dacd52 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1936,7 +1936,7 @@ static void XGIfb_post_setmode(void)
 		reg |= 0x80;
 	xgifb_reg_set(XGICR, 0x17, reg);
 
-	andXGIIDXREG(XGISR, IND_XGI_RAMDAC_CONTROL, ~0x04);
+	xgifb_reg_and(XGISR, IND_XGI_RAMDAC_CONTROL, ~0x04);
 
 	if ((xgi_video_info.disp_state & DISPTYPE_TV) && (xgi_video_info.hasVB
 			== HASVB_301)) {
@@ -1967,11 +1967,11 @@ static void XGIfb_post_setmode(void)
 
 			if (xgi_video_info.TV_type == TVMODE_NTSC) {
 
-				andXGIIDXREG(XGIPART2, 0x3a, 0x1f);
+				xgifb_reg_and(XGIPART2, 0x3a, 0x1f);
 
 				if (xgi_video_info.TV_plug == TVPLUG_SVIDEO) {
 
-					andXGIIDXREG(XGIPART2, 0x30, 0xdf);
+					xgifb_reg_and(XGIPART2, 0x30, 0xdf);
 
 				} else if (xgi_video_info.TV_plug
 						== TVPLUG_COMPOSITE) {
@@ -2002,11 +2002,11 @@ static void XGIfb_post_setmode(void)
 
 			} else if (xgi_video_info.TV_type == TVMODE_PAL) {
 
-				andXGIIDXREG(XGIPART2, 0x3A, 0x1F);
+				xgifb_reg_and(XGIPART2, 0x3A, 0x1F);
 
 				if (xgi_video_info.TV_plug == TVPLUG_SVIDEO) {
 
-					andXGIIDXREG(XGIPART2, 0x30, 0xDF);
+					xgifb_reg_and(XGIPART2, 0x30, 0xDF);
 
 				} else if (xgi_video_info.TV_plug
 						== TVPLUG_COMPOSITE) {
-- 
1.5.6.5

