Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab1DRTOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:14:12 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:59166 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab1DRTOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:14:08 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 06/12] staging: xgifb: replace setXGIIDXREG() with xgifb_reg_and_or()
Date: Mon, 18 Apr 2011 22:14:02 +0300
Message-Id: <1303154048-21989-7-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
References: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace setXGIIDXREG() with xgifb_reg_and_or().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 1dacd52..3112a25 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1185,14 +1185,14 @@ static int XGIfb_pan_var(struct fb_var_screeninfo *var)
 	xgifb_reg_set(XGICR, 0x0C, (base >> 8) & 0xFF);
 	xgifb_reg_set(XGISR, 0x0D, (base >> 16) & 0xFF);
 	xgifb_reg_set(XGISR, 0x37, (base >> 24) & 0x03);
-	setXGIIDXREG(XGISR, 0x37, 0xDF, (base >> 21) & 0x04);
+	xgifb_reg_and_or(XGISR, 0x37, 0xDF, (base >> 21) & 0x04);
 
 	if (xgi_video_info.disp_state & DISPTYPE_DISP2) {
 		xgifb_reg_or(XGIPART1, XGIfb_CRT2_write_enable, 0x01);
 		xgifb_reg_set(XGIPART1, 0x06, (base & 0xFF));
 		xgifb_reg_set(XGIPART1, 0x05, ((base >> 8) & 0xFF));
 		xgifb_reg_set(XGIPART1, 0x04, ((base >> 16) & 0xFF));
-		setXGIIDXREG(XGIPART1, 0x02, 0x7F, ((base >> 24) & 0x01) << 7);
+		xgifb_reg_and_or(XGIPART1, 0x02, 0x7F, ((base >> 24) & 0x01) << 7);
 	}
 	/* printk("End of pan_var"); */
 	return 0;
@@ -1736,7 +1736,7 @@ int XGIDoSense(int tempbl, int tempbh, int tempcl, int tempch)
 
 	xgifb_reg_set(XGIPART4, 0x11, tempbl);
 	temp = tempbh | tempcl;
-	setXGIIDXREG(XGIPART4, 0x10, 0xe0, temp);
+	xgifb_reg_and_or(XGIPART4, 0x10, 0xe0, temp);
 	for (i = 0; i < 10; i++)
 		XGI_LongWait(&XGI_Pr);
 	tempch &= 0x7f;
@@ -1904,7 +1904,7 @@ static void XGIfb_post_setmode(void)
 	/*
 	xgifb_reg_set(XGISR,IND_XGI_PASSWORD,XGI_PASSWORD);
 	xgifb_reg_set(XGICR, 0x13, 0x00);
-	setXGIIDXREG(XGISR,0x0E, 0xF0, 0x01);
+	xgifb_reg_and_or(XGISR,0x0E, 0xF0, 0x01);
 	*test*
 	*/
 	if (xgi_video_info.video_bpp == 8) {
-- 
1.5.6.5

