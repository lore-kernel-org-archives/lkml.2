Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab0IMTso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:48:44 -0400
Received: from mail.perches.com ([173.55.12.10]:1914 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353Ab0IMTsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:48:42 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Winischhofer <thomas@winischhofer.net>,
        Joseph Chan <JosephChan@via.com.tw>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: [PATCH 21/25] drivers/video: Use static const char arrays
Date: Mon, 13 Sep 2010 12:47:59 -0700
Message-Id: <2435a9f5831685e3b7f06b93799a8836f4bfef61.1284406639.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284406638.git.joe@perches.com>
References: <cover.1284406638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/video/sh_mipi_dsi.c  |    4 ++--
 drivers/video/sis/sis_main.c |   10 +++++-----
 drivers/video/via/viafbdev.c |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/video/sh_mipi_dsi.c b/drivers/video/sh_mipi_dsi.c
index 5699ce0..4a8501b 100644
--- a/drivers/video/sh_mipi_dsi.c
+++ b/drivers/video/sh_mipi_dsi.c
@@ -319,7 +319,7 @@ static int __init sh_mipi_probe(struct platform_device *pdev)
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	unsigned long rate, f_current;
 	int idx = pdev->id, ret;
-	char dsip_clk[] = "dsi.p_clk";
+	char dsip_clk[sizeof("dsiXp_clk")];
 
 	if (!res || idx >= ARRAY_SIZE(mipi_dsi) || !pdata)
 		return -ENODEV;
@@ -370,7 +370,7 @@ static int __init sh_mipi_probe(struct platform_device *pdev)
 
 	dev_dbg(&pdev->dev, "DSI-T clk %lu -> %lu\n", f_current, rate);
 
-	sprintf(dsip_clk, "dsi%1.1dp_clk", idx);
+	sprintf(dsip_clk, "dsi%cp_clk", idx + '0');
 	mipi->dsip_clk = clk_get(&pdev->dev, dsip_clk);
 	if (IS_ERR(mipi->dsip_clk)) {
 		ret = PTR_ERR(mipi->dsip_clk);
diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 559bf17..4be65d1 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -2387,8 +2387,8 @@ SiS_Sense30x(struct sis_video_info *ivideo)
     u16 cvbs=0, cvbs_c=0;
     u16 vga2=0, vga2_c=0;
     int myflag, result;
-    char stdstr[] = "sisfb: Detected";
-    char tvstr[]  = "TV connected to";
+    static const char stdstr[] = "sisfb: Detected";
+    static const char tvstr[] = "TV connected to";
 
     if(ivideo->vbflags2 & VB2_301) {
        svhs = 0x00b9; cvbs = 0x00b3; vga2 = 0x00d1;
@@ -2525,7 +2525,7 @@ SiS_SenseCh(struct sis_video_info *ivideo)
 {
 #if defined(CONFIG_FB_SIS_300) || defined(CONFIG_FB_SIS_315)
     u8 temp1, temp2;
-    char stdstr[] = "sisfb: Chrontel: Detected TV connected to";
+    static const char stdstr[] = "sisfb: Chrontel: Detected TV connected to";
 #endif
 #ifdef CONFIG_FB_SIS_300
     unsigned char test[3];
@@ -2648,8 +2648,8 @@ SiS_SenseCh(struct sis_video_info *ivideo)
 static void __devinit
 sisfb_get_VB_type(struct sis_video_info *ivideo)
 {
-	char stdstr[]    = "sisfb: Detected";
-	char bridgestr[] = "video bridge";
+	static const char stdstr[] = "sisfb: Detected";
+	static const char bridgestr[] = "video bridge";
 	u8 vb_chipid;
 	u8 reg;
 
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 5a947b0..394ef48 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -367,7 +367,7 @@ static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
 	} u;
 	u32 state_info = 0;
 	u32 *viafb_gamma_table;
-	char driver_name[] = "viafb";
+	static const char driver_name[] = "viafb";
 
 	u32 __user *argp = (u32 __user *) arg;
 	u32 gpu32;
-- 
1.7.3.rc1

