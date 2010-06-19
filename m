Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0FSLsg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 07:48:36 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.42]:55141 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab0FSLsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 07:48:35 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Jun 2010 07:48:34 EDT
Date: Sat, 19 Jun 2010 13:43:43 +0200
From: Peter Feuerer <peter@piie.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@googlemail.com>,
       lenb@kernel.org, Andreas Mohr <andi@lisas.de>,
       Peter Feuerer <peter@piie.net>
Subject: [PATCH 2/4] Removed "chk_off" as it was only needed for T31
 netbooks
Message-Id: <20100619134343.46564310.peter@piie.net>
In-Reply-To: <20100619134232.7fedd2f1.peter@piie.net>
References: <20100619134232.7fedd2f1.peter@piie.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Df-Sender: 650477
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed "chk_off" as it was only needed for T31 netbooks. But those
netbooks can also be handled just with "cmd_off" register (0x9e) for reading
the state back.

Signed-off-by: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Len Brown <lenb@kernel.org>

---
 drivers/platform/x86/acerhdf.c |   92 +++++++++++++++++++--------------------
 1 files changed, 45 insertions(+), 47 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 40be6a4..9226838 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -112,14 +112,12 @@ module_param_string(force_product, force_product, 16, 0);
 MODULE_PARM_DESC(force_product, "Force BIOS product and omit BIOS check");
 
 /*
- * cmd_off: to switch the fan completely off
- * chk_off: to check if the fan is off
+ * cmd_off: to switch the fan completely off and check if the fan is off
  *	cmd_auto: to set the BIOS in control of the fan. The BIOS regulates then
  *		the fan speed depending on the temperature
  */
 struct fancmd {
 	u8 cmd_off;
-	u8 chk_off;
 	u8 cmd_auto;
 };
 
@@ -136,55 +134,55 @@ struct bios_settings_t {
 /* Register addresses and values for different BIOS versions */
 static const struct bios_settings_t bios_tbl[] = {
 	/* AOA110 */
-	{"Acer", "AOA110", "v0.3109", 0x55, 0x58, {0x1f, 0x1f, 0x00} },
-	{"Acer", "AOA110", "v0.3114", 0x55, 0x58, {0x1f, 0x1f, 0x00} },
-	{"Acer", "AOA110", "v0.3301", 0x55, 0x58, {0xaf, 0xaf, 0x00} },
-	{"Acer", "AOA110", "v0.3304", 0x55, 0x58, {0xaf, 0xaf, 0x00} },
-	{"Acer", "AOA110", "v0.3305", 0x55, 0x58, {0xaf, 0xaf, 0x00} },
-	{"Acer", "AOA110", "v0.3307", 0x55, 0x58, {0xaf, 0xaf, 0x00} },
-	{"Acer", "AOA110", "v0.3308", 0x55, 0x58, {0x21, 0x21, 0x00} },
-	{"Acer", "AOA110", "v0.3309", 0x55, 0x58, {0x21, 0x21, 0x00} },
-	{"Acer", "AOA110", "v0.3310", 0x55, 0x58, {0x21, 0x21, 0x00} },
+	{"Acer", "AOA110", "v0.3109", 0x55, 0x58, {0x1f, 0x00} },
+	{"Acer", "AOA110", "v0.3114", 0x55, 0x58, {0x1f, 0x00} },
+	{"Acer", "AOA110", "v0.3301", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "AOA110", "v0.3304", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "AOA110", "v0.3305", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "AOA110", "v0.3307", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "AOA110", "v0.3308", 0x55, 0x58, {0x21, 0x00} },
+	{"Acer", "AOA110", "v0.3309", 0x55, 0x58, {0x21, 0x00} },
+	{"Acer", "AOA110", "v0.3310", 0x55, 0x58, {0x21, 0x00} },
 	/* AOA150 */
-	{"Acer", "AOA150", "v0.3114", 0x55, 0x58, {0x1f, 0x1f, 0x00} },
-	{"Acer", "AOA150", "v0.3301", 0x55, 0x58, {0x20, 0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3304", 0x55, 0x58, {0x20, 0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3305", 0x55, 0x58, {0x20, 0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3307", 0x55, 0x58, {0x20, 0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3308", 0x55, 0x58, {0x20, 0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3309", 0x55, 0x58, {0x20, 0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3310", 0x55, 0x58, {0x20, 0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3114", 0x55, 0x58, {0x1f, 0x00} },
+	{"Acer", "AOA150", "v0.3301", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3304", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3305", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3307", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3308", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3309", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3310", 0x55, 0x58, {0x20, 0x00} },
 	/* Acer 1410 */
-	{"Acer", "Aspire 1410", "v0.3115", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1410", "v0.3120", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1410", "v1.3303", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	{"Acer", "Aspire 1410", "v0.3115", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1410", "v0.3120", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1410", "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
 	/* Acer 1810xx */
-	{"Acer", "Aspire 1810TZ", "v0.3115", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1810T", "v0.3115", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1810TZ", "v0.3119", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1810T", "v0.3119", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1810TZ", "v0.3120", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1810T", "v0.3120", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1810TZ", "v1.3204", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1810T", "v1.3204", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1810TZ", "v1.3303", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1810T", "v1.3303", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	{"Acer", "Aspire 1810TZ", "v0.3115", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810T",  "v0.3115", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810TZ", "v0.3119", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810T",  "v0.3119", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810TZ", "v0.3120", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810T",  "v0.3120", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810TZ", "v1.3204", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810T",  "v1.3204", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810TZ", "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810T",  "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
 	/* Gateway */
-	{"Gateway", "AOA110", "v0.3103", 0x55, 0x58, {0x21, 0x21, 0x00} },
-	{"Gateway", "AOA150", "v0.3103", 0x55, 0x58, {0x20, 0x20, 0x00} },
-	{"Gateway", "LT31", "v1.3103", 0x55, 0x58, {0x10, 0x0f, 0x00} },
-	{"Gateway", "LT31", "v1.3201", 0x55, 0x58, {0x10, 0x0f, 0x00} },
-	{"Gateway", "LT31", "v1.3302", 0x55, 0x58, {0x10, 0x0f, 0x00} },
+	{"Gateway", "AOA110", "v0.3103", 0x55, 0x58, {0x21, 0x00} },
+	{"Gateway", "AOA150", "v0.3103", 0x55, 0x58, {0x20, 0x00} },
+	{"Gateway", "LT31",   "v1.3103", 0x55, 0x58, {0x9e, 0x00} },
+	{"Gateway", "LT31",   "v1.3201", 0x55, 0x58, {0x9e, 0x00} },
+	{"Gateway", "LT31",   "v1.3302", 0x55, 0x58, {0x9e, 0x00} },
 	/* Packard Bell */
-	{"Packard Bell", "DOA150", "v0.3104", 0x55, 0x58, {0x21, 0x21, 0x00} },
-	{"Packard Bell", "DOA150", "v0.3105", 0x55, 0x58, {0x20, 0x20, 0x00} },
-	{"Packard Bell", "AOA110", "v0.3105", 0x55, 0x58, {0x21, 0x21, 0x00} },
-	{"Packard Bell", "AOA150", "v0.3105", 0x55, 0x58, {0x20, 0x20, 0x00} },
-	{"Packard Bell", "DOTMU", "v1.3303", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Packard Bell", "DOTMU", "v0.3120", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Packard Bell", "DOTMA", "v1.3201", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	{"Packard Bell", "DOA150", "v0.3104", 0x55, 0x58, {0x21, 0x00} },
+	{"Packard Bell", "DOA150", "v0.3105", 0x55, 0x58, {0x20, 0x00} },
+	{"Packard Bell", "AOA110", "v0.3105", 0x55, 0x58, {0x21, 0x00} },
+	{"Packard Bell", "AOA150", "v0.3105", 0x55, 0x58, {0x20, 0x00} },
+	{"Packard Bell", "DOTMU",  "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",  "v0.3120", 0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMA",  "v1.3201", 0x55, 0x58, {0x9e, 0x00} },
 	/* pewpew-terminator */
-	{"", "", "", 0, 0, {0, 0, 0} }
+	{"", "", "", 0, 0, {0, 0} }
 };
 
 static const struct bios_settings_t *bios_cfg __read_mostly;
@@ -208,7 +206,7 @@ static int acerhdf_get_fanstate(int *state)
 	if (ec_read(bios_cfg->fanreg, &fan))
 		return -EINVAL;
 
-	if (fan != bios_cfg->cmd.chk_off)
+	if (fan != bios_cfg->cmd.cmd_off)
 		*state = ACERHDF_FAN_AUTO;
 	else
 		*state = ACERHDF_FAN_OFF;
-- 
1.7.1

