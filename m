Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1KEK7W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 06:59:22 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.93]:42557 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab1KEK7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 06:59:21 -0400
Date: Sat, 5 Nov 2011 11:59:17 +0100
From: Peter Feuerer <peter@piie.net>
To: mjg@redhat.com
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Borislav Petkov <petkovbb@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Feuerer <peter@piie.net>
Subject: [PATCH RESEND 2/3] acerhdf: Add support for new hardware
Message-Id: <20111105115917.3d64689c.peter@piie.net>
In-Reply-To: <20111105115818.bd26dc8d.peter@piie.net>
References: <20111014234055.2265c524.peter@piie.net>
	<20111014234334.a87a2388.peter@piie.net>
	<20111015223210.GC16432@liondog.tnic>
	<cone.1318721291.690132.3813.1000@zopiie>
	<20111016084300.GB32343@liondog.tnic>
	<20111016114100.88295b72.peter@piie.net>
	<20111016114251.a710b196.peter@piie.net>
	<20111016114423.2df6271c.peter@piie.net>
	<20111105115818.bd26dc8d.peter@piie.net>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Df-Sender: NjUwNDc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Feuerer <peter@piie.net>

Add support for new hardware:
Acer Aspire LT-10Q/531/751/1810/1825,
Acer Travelmate 7730,
Packard Bell ENBFT/DOTVR46

Signed-off-by: Peter Feuerer <peter@piie.net>
Acked-by: Borislav Petkov <petkovbb@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>
---
 drivers/platform/x86/acerhdf.c |   62 +++++++++++++++++++++++++++-------------
 1 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 698e45c..f15e320 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -50,7 +50,7 @@
  */
 #undef START_IN_KERNEL_MODE
 
-#define DRV_VER "0.5.24"
+#define DRV_VER "0.5.26"
 
 /*
  * According to the Atom N270 datasheet,
@@ -150,6 +150,8 @@ static const struct bios_settings_t bios_tbl[] = {
 	{"Acer", "AOA150", "v0.3308", 0x55, 0x58, {0x20, 0x00} },
 	{"Acer", "AOA150", "v0.3309", 0x55, 0x58, {0x20, 0x00} },
 	{"Acer", "AOA150", "v0.3310", 0x55, 0x58, {0x20, 0x00} },
+	/* LT1005u */
+	{"Acer", "LT-10Q", "v0.3310", 0x55, 0x58, {0x20, 0x00} },
 	/* Acer 1410 */
 	{"Acer", "Aspire 1410", "v0.3108", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1410", "v0.3113", 0x55, 0x58, {0x9e, 0x00} },
@@ -184,29 +186,44 @@ static const struct bios_settings_t bios_tbl[] = {
 	{"Acer", "Aspire 1810TZ", "v1.3310", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1810T",  "v1.3310", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1810TZ", "v1.3314", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810T",  "v1.3314", 0x55, 0x58, {0x9e, 0x00} },
 	/* Acer 531 */
+	{"Acer", "AO531h", "v0.3104", 0x55, 0x58, {0x20, 0x00} },
 	{"Acer", "AO531h", "v0.3201", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AO531h", "v0.3304", 0x55, 0x58, {0x20, 0x00} },
+	/* Acer 751 */
+	{"Acer", "AO751h", "V0.3212", 0x55, 0x58, {0x21, 0x00} },
+	/* Acer 1825 */
+	{"Acer", "Aspire 1825PTZ", "V1.3118", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1825PTZ", "V1.3127", 0x55, 0x58, {0x9e, 0x00} },
+	/* Acer TravelMate 7730 */
+	{"Acer", "TravelMate 7730G", "v0.3509", 0x55, 0x58, {0xaf, 0x00} },
 	/* Gateway */
-	{"Gateway", "AOA110", "v0.3103", 0x55, 0x58, {0x21, 0x00} },
-	{"Gateway", "AOA150", "v0.3103", 0x55, 0x58, {0x20, 0x00} },
-	{"Gateway", "LT31",   "v1.3103", 0x55, 0x58, {0x9e, 0x00} },
-	{"Gateway", "LT31",   "v1.3201", 0x55, 0x58, {0x9e, 0x00} },
-	{"Gateway", "LT31",   "v1.3302", 0x55, 0x58, {0x9e, 0x00} },
+	{"Gateway", "AOA110", "v0.3103",  0x55, 0x58, {0x21, 0x00} },
+	{"Gateway", "AOA150", "v0.3103",  0x55, 0x58, {0x20, 0x00} },
+	{"Gateway", "LT31",   "v1.3103",  0x55, 0x58, {0x9e, 0x00} },
+	{"Gateway", "LT31",   "v1.3201",  0x55, 0x58, {0x9e, 0x00} },
+	{"Gateway", "LT31",   "v1.3302",  0x55, 0x58, {0x9e, 0x00} },
+	{"Gateway", "LT31",   "v1.3303t", 0x55, 0x58, {0x9e, 0x00} },
 	/* Packard Bell */
-	{"Packard Bell", "DOA150", "v0.3104", 0x55, 0x58, {0x21, 0x00} },
-	{"Packard Bell", "DOA150", "v0.3105", 0x55, 0x58, {0x20, 0x00} },
-	{"Packard Bell", "AOA110", "v0.3105", 0x55, 0x58, {0x21, 0x00} },
-	{"Packard Bell", "AOA150", "v0.3105", 0x55, 0x58, {0x20, 0x00} },
-	{"Packard Bell", "DOTMU",  "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",  "v0.3120", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",  "v0.3108", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",  "v0.3113", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",  "v0.3115", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",  "v0.3117", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",  "v0.3119", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",  "v1.3204", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMA",  "v1.3201", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMA",  "v1.3302", 0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOA150",  "v0.3104",  0x55, 0x58, {0x21, 0x00} },
+	{"Packard Bell", "DOA150",  "v0.3105",  0x55, 0x58, {0x20, 0x00} },
+	{"Packard Bell", "AOA110",  "v0.3105",  0x55, 0x58, {0x21, 0x00} },
+	{"Packard Bell", "AOA150",  "v0.3105",  0x55, 0x58, {0x20, 0x00} },
+	{"Packard Bell", "ENBFT",   "V1.3118",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "ENBFT",   "V1.3127",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v1.3303",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v0.3120",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v0.3108",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v0.3113",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v0.3115",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v0.3117",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v0.3119",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v1.3204",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMA",   "v1.3201",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMA",   "v1.3302",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMA",   "v1.3303t", 0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTVR46", "v1.3308",  0x55, 0x58, {0x9e, 0x00} },
 	/* pewpew-terminator */
 	{"", "", "", 0, 0, {0, 0} }
 };
@@ -705,15 +722,20 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Peter Feuerer");
 MODULE_DESCRIPTION("Aspire One temperature and fan driver");
 MODULE_ALIAS("dmi:*:*Acer*:pnAOA*:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAO751h*:");
 MODULE_ALIAS("dmi:*:*Acer*:pnAspire*1410*:");
 MODULE_ALIAS("dmi:*:*Acer*:pnAspire*1810*:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAspire*1825PTZ:");
 MODULE_ALIAS("dmi:*:*Acer*:pnAO531*:");
+MODULE_ALIAS("dmi:*:*Acer*:TravelMate*7730G:");
 MODULE_ALIAS("dmi:*:*Gateway*:pnAOA*:");
 MODULE_ALIAS("dmi:*:*Gateway*:pnLT31*:");
 MODULE_ALIAS("dmi:*:*Packard*Bell*:pnAOA*:");
 MODULE_ALIAS("dmi:*:*Packard*Bell*:pnDOA*:");
 MODULE_ALIAS("dmi:*:*Packard*Bell*:pnDOTMU*:");
+MODULE_ALIAS("dmi:*:*Packard*Bell*:pnENBFT*:");
 MODULE_ALIAS("dmi:*:*Packard*Bell*:pnDOTMA*:");
+MODULE_ALIAS("dmi:*:*Packard*Bell*:pnDOTVR46*:");
 
 module_init(acerhdf_init);
 module_exit(acerhdf_exit);
-- 
1.7.7

