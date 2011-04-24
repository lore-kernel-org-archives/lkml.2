Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab1DXCXc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 22:23:32 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:36047 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757402Ab1DXCXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 22:23:09 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19TVSd62zdTmUz5qgARv6U5NzmYaK5Z5+CM3WpTgJ
	IGPLGl1J+WYhwg
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/2] viafb: reduce OLPC refresh a bit
Date: Sun, 24 Apr 2011 02:39:23 +0000
Message-Id: <1303612763-8852-3-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1303612763-8852-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1303612763-8852-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When allowing some PLL calculation we get a frequency that seems to
be a bit higher than what the OLPC DCON likes resulting in a still
readable but not so good image. We don't really know whether this is
a problem with the calculation formula or the OLPC but as other
displays seem to be happy with the other modes adjusting the OLPC
refresh looks like the better thing. This patch prevents a
regression when dynamic PLL calculation is allowed.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c      |    2 +-
 drivers/video/via/share.h   |    1 +
 drivers/video/via/viamode.c |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index b8f0110..56ad185 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2605,7 +2605,7 @@ int viafb_get_refresh(int hres, int vres, u32 long_refresh)
 
 	if (abs(best->refresh_rate - long_refresh) > 3) {
 		if (hres == 1200 && vres == 900)
-			return 50; /* OLPC DCON only supports 50 Hz */
+			return 49; /* OLPC DCON only supports 50 Hz */
 		else
 			return 60;
 	}
diff --git a/drivers/video/via/share.h b/drivers/video/via/share.h
index 4b7831f..62bed2b 100644
--- a/drivers/video/via/share.h
+++ b/drivers/video/via/share.h
@@ -290,6 +290,7 @@
 #define HW_LAYOUT_LCD_EXTERNAL_LCD2 0x10
 
 /* Definition Refresh Rate */
+#define REFRESH_49      49
 #define REFRESH_50      50
 #define REFRESH_60      60
 #define REFRESH_75      75
diff --git a/drivers/video/via/viamode.c b/drivers/video/via/viamode.c
index 260d339..ccb5eec 100644
--- a/drivers/video/via/viamode.c
+++ b/drivers/video/via/viamode.c
@@ -606,7 +606,7 @@ static struct crt_mode_table CRTM1200x720[] = {
 /* 1200x900 (DCON) */
 static struct crt_mode_table DCON1200x900[] = {
 	/* r_rate,               hsp,               vsp   */
-	{REFRESH_50, M1200X900_R60_HSP, M1200X900_R60_VSP,
+	{REFRESH_49, M1200X900_R60_HSP, M1200X900_R60_VSP,
 	/* The correct htotal is 1240, but this doesn't raster on VX855. */
 	/* Via suggested changing to a multiple of 16, hence 1264.       */
 	/*  HT,   HA,  HBS, HBE,  HSS, HSE,  VT,  VA, VBS, VBE, VSS, VSE */
-- 
1.6.3.2

