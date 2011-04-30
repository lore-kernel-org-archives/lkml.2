Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab1D3OBz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 10:01:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50696 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755379Ab1D3OBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 10:01:46 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18Cb15VfIUCH9rBbp26C26xCcYTUnHaQm+kahfvnI
	KJSqqGIwh0HKj6
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 3/3] viafb: remove unused CEA mode
Date: Sat, 30 Apr 2011 14:18:06 +0000
Message-Id: <1304173086-3434-4-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1304173086-3434-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1304173086-3434-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This trivial patch removes unused mode tables.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/share.h   |    8 --------
 drivers/video/via/viamode.c |   17 -----------------
 drivers/video/via/viamode.h |    9 ---------
 3 files changed, 0 insertions(+), 34 deletions(-)

diff --git a/drivers/video/via/share.h b/drivers/video/via/share.h
index 8b93e2f..61b0bd5 100644
--- a/drivers/video/via/share.h
+++ b/drivers/video/via/share.h
@@ -568,10 +568,6 @@
 #define M1280X720_R50_HSP       NEGATIVE
 #define M1280X720_R50_VSP       POSITIVE
 
-/* 1280x720@60 Sync Polarity  (CEA Mode) */
-#define M1280X720_CEA_R60_HSP       POSITIVE
-#define M1280X720_CEA_R60_VSP       POSITIVE
-
 /* 1440x900@60 Sync Polarity (CVT Mode) */
 #define M1440X900_R60_HSP       NEGATIVE
 #define M1440X900_R60_VSP       POSITIVE
@@ -612,10 +608,6 @@
 #define M1920X1200_RB_R60_HSP  POSITIVE
 #define M1920X1200_RB_R60_VSP  NEGATIVE
 
-/* 1920x1080@60 Sync Polarity  (CEA Mode) */
-#define M1920X1080_CEA_R60_HSP       POSITIVE
-#define M1920X1080_CEA_R60_VSP       POSITIVE
-
 /* 2048x1536@60 Sync Polarity (CVT Mode) */
 #define M2048x1536_R60_HSP      NEGATIVE
 #define M2048x1536_R60_VSP      POSITIVE
diff --git a/drivers/video/via/viamode.c b/drivers/video/via/viamode.c
index 50de07f..58df74e 100644
--- a/drivers/video/via/viamode.c
+++ b/drivers/video/via/viamode.c
@@ -854,23 +854,6 @@ static struct VideoModeTable viafb_rb_modes[] = {
 	{CRTM1920x1200_RB, ARRAY_SIZE(CRTM1920x1200_RB)}
 };
 
-struct crt_mode_table CEAM1280x720[] = {
-	{REFRESH_60, M1280X720_CEA_R60_HSP, M1280X720_CEA_R60_VSP,
-	 /* HT,    HA,   HBS,  HBE,  HSS, HSE,  VT,   VA,  VBS, VBE, VSS, VSE */
-	 {1650, 1280, 1280, 370, 1390, 40, 750, 720, 720, 30, 725, 5} }
-};
-struct crt_mode_table CEAM1920x1080[] = {
-	{REFRESH_60, M1920X1080_CEA_R60_HSP, M1920X1080_CEA_R60_VSP,
-	 /* HT,    HA,   HBS,  HBE,  HSS, HSE,  VT,  VA, VBS, VBE,  VSS, VSE */
-	 {2200, 1920, 1920, 300, 2008, 44, 1125, 1080, 1080, 45, 1084, 5} }
-};
-struct VideoModeTable CEA_HDMI_Modes[] = {
-	/* Display : 1280x720 */
-	{CEAM1280x720, ARRAY_SIZE(CEAM1280x720)},
-	{CEAM1920x1080, ARRAY_SIZE(CEAM1920x1080)}
-};
-
-int NUM_TOTAL_CEA_MODES = ARRAY_SIZE(CEA_HDMI_Modes);
 int NUM_TOTAL_CN400_ModeXregs = ARRAY_SIZE(CN400_ModeXregs);
 int NUM_TOTAL_CN700_ModeXregs = ARRAY_SIZE(CN700_ModeXregs);
 int NUM_TOTAL_KM400_ModeXregs = ARRAY_SIZE(KM400_ModeXregs);
diff --git a/drivers/video/via/viamode.h b/drivers/video/via/viamode.h
index 8a67ea1..3751289 100644
--- a/drivers/video/via/viamode.h
+++ b/drivers/video/via/viamode.h
@@ -41,7 +41,6 @@ struct patch_table {
 	struct io_reg *io_reg_table;
 };
 
-extern int NUM_TOTAL_CEA_MODES;
 extern int NUM_TOTAL_CN400_ModeXregs;
 extern int NUM_TOTAL_CN700_ModeXregs;
 extern int NUM_TOTAL_KM400_ModeXregs;
@@ -50,14 +49,6 @@ extern int NUM_TOTAL_VX855_ModeXregs;
 extern int NUM_TOTAL_CLE266_ModeXregs;
 extern int NUM_TOTAL_PATCH_MODE;
 
-/********************/
-/* Mode Table       */
-/********************/
-
-extern struct crt_mode_table CEAM1280x720[];
-extern struct crt_mode_table CEAM1920x1080[];
-extern struct VideoModeTable CEA_HDMI_Modes[];
-
 extern struct io_reg CN400_ModeXregs[];
 extern struct io_reg CN700_ModeXregs[];
 extern struct io_reg KM400_ModeXregs[];
-- 
1.6.3.2

