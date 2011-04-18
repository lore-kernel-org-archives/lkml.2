Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab1DRTPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:15:17 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:48314 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab1DRTOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:14:09 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 08/12] staging: xgifb: delete unused register I/O functions
Date: Mon, 18 Apr 2011 22:14:04 +0300
Message-Id: <1303154048-21989-9-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
References: <1303154048-21989-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete unused register I/O functions.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main.h    |    4 ----
 drivers/staging/xgifb/XGI_main_26.c |   13 -------------
 2 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index 560e2de..c9764a7 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -698,10 +698,6 @@ static int      XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 static void     XGIfb_pre_setmode(void);
 static void     XGIfb_post_setmode(void);
 
-/* Internal hardware access routines */
-void            XGIfb_set_reg4(u16 port, unsigned long data);
-u32             XGIfb_get_reg3(u16 port);
-
 /* Chipset-dependent internal routines */
 
 
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 3112a25..8de6829 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -385,19 +385,6 @@ static void XGIRegInit(struct vb_device_info *XGI_Pr, unsigned long BaseAddr)
 
 }
 
-void XGIfb_set_reg4(u16 port, unsigned long data)
-{
-	outl((u32)(data & 0xffffffff), port);
-}
-
-u32 XGIfb_get_reg3(u16 port)
-{
-	u32 data;
-
-	data = inl(port);
-	return data;
-}
-
 /* ------------ Interface for init & mode switching code ------------- */
 
 unsigned char XGIfb_query_VGA_config_space(
-- 
1.5.6.5

