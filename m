Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab2JRRVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:21:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43236 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747Ab2JRRVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:21:00 -0400
From: Sangho Yi <antiroot@gmail.com>
To: prakity@marvell.com, aaron.lu@amd.com, linus.walleij@linaro.org,
        ulf.hansson@stericsson.com, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 3/4] mmc: core: sd.c: Modified pr_warning to pr_warn
Date: Fri, 19 Oct 2012 02:19:19 +0900
Message-Id: <1350580760-3886-3-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350580760-3886-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350580760-3886-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the coding style warning;
from pr_warning(...) to pr_warn(...)

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/mmc/core/sd.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 7c6b38e..0622b9b 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -219,7 +219,7 @@ static int mmc_read_ssr(struct mmc_card *card)
 	u32 *ssr;
 
 	if (!(card->csd.cmdclass & CCC_APP_SPEC)) {
-		pr_warning("%s: card lacks mandatory SD Status "
+		pr_warn("%s: card lacks mandatory SD Status "
 			"function.\n", mmc_hostname(card->host));
 		return 0;
 	}
@@ -230,7 +230,7 @@ static int mmc_read_ssr(struct mmc_card *card)
 
 	err = mmc_app_sd_status(card, ssr);
 	if (err) {
-		pr_warning("%s: problem reading SD Status "
+		pr_warn("%s: problem reading SD Status "
 			"register.\n", mmc_hostname(card->host));
 		err = 0;
 		goto out;
@@ -254,7 +254,7 @@ static int mmc_read_ssr(struct mmc_card *card)
 			card->ssr.erase_offset = eo * 1000;
 		}
 	} else {
-		pr_warning("%s: SD Status: Invalid Allocation Unit "
+		pr_warn("%s: SD Status: Invalid Allocation Unit "
 			"size.\n", mmc_hostname(card->host));
 	}
 out:
@@ -274,7 +274,7 @@ static int mmc_read_switch(struct mmc_card *card)
 		return 0;
 
 	if (!(card->csd.cmdclass & CCC_SWITCH)) {
-		pr_warning("%s: card lacks mandatory switch "
+		pr_warn("%s: card lacks mandatory switch "
 			"function, performance might suffer.\n",
 			mmc_hostname(card->host));
 		return 0;
@@ -304,8 +304,8 @@ static int mmc_read_switch(struct mmc_card *card)
 		if (err != -EINVAL && err != -ENOSYS && err != -EFAULT)
 			goto out;
 
-		pr_warning("%s: problem reading Bus Speed modes.\n",
-			   mmc_hostname(card->host));
+		pr_warn("%s: problem reading Bus Speed modes.\n",
+			mmc_hostname(card->host));
 		err = 0;
 
 		goto out;
@@ -360,8 +360,7 @@ int mmc_sd_switch_hs(struct mmc_card *card)
 		goto out;
 
 	if ((status[16] & 0xF) != 1) {
-		pr_warning("%s: Problem switching card "
-			"into high-speed mode!\n",
+		pr_warn("%s: Problem switching card into high-speed mode!\n",
 			mmc_hostname(card->host));
 		err = 0;
 	} else {
@@ -428,8 +427,8 @@ static int sd_select_driver_type(struct mmc_card *card, u8 *status)
 		return err;
 
 	if ((status[15] & 0xF) != drive_strength) {
-		pr_warning("%s: Problem setting drive strength!\n",
-			   mmc_hostname(card->host));
+		pr_warn("%s: Problem setting drive strength!\n",
+			mmc_hostname(card->host));
 		return 0;
 	}
 
@@ -507,8 +506,8 @@ static int sd_set_bus_speed_mode(struct mmc_card *card, u8 *status)
 		return err;
 
 	if ((status[16] & 0xF) != card->sd_bus_speed)
-		pr_warning("%s: Problem setting bus speed mode!\n",
-			   mmc_hostname(card->host));
+		pr_warn("%s: Problem setting bus speed mode!\n",
+			mmc_hostname(card->host));
 	else {
 		mmc_set_timing(card->host, timing);
 		mmc_set_clock(card->host, card->sw_caps.uhs_max_dtr);
@@ -587,8 +586,8 @@ static int sd_set_current_limit(struct mmc_card *card, u8 *status)
 			return err;
 
 		if (((status[15] >> 4) & 0x0F) != current_limit)
-			pr_warning("%s: Problem setting current limit!\n",
-				   mmc_hostname(card->host));
+			pr_warn("%s: Problem setting current limit!\n",
+				mmc_hostname(card->host));
 
 	}
 
@@ -852,7 +851,7 @@ int mmc_sd_setup_card(struct mmc_host *host, struct mmc_card *card,
 		}
 
 		if (ro < 0) {
-			pr_warning("%s: host does not "
+			pr_warn("%s: host does not "
 				"support reading read-only "
 				"switch. assuming write-enable.\n",
 				mmc_hostname(host));
@@ -1179,17 +1178,17 @@ int mmc_attach_sd(struct mmc_host *host)
 	 * support.
 	 */
 	if (ocr & 0x7F) {
-		pr_warning("%s: card claims to support voltages "
-		       "below the defined range. These will be ignored.\n",
-		       mmc_hostname(host));
+		pr_warn("%s: card claims to support voltages "
+			"below the defined range. These will be ignored.\n",
+			mmc_hostname(host));
 		ocr &= ~0x7F;
 	}
 
 	if ((ocr & MMC_VDD_165_195) &&
 	    !(host->ocr_avail_sd & MMC_VDD_165_195)) {
-		pr_warning("%s: SD card claims to support the "
-		       "incompletely defined 'low voltage range'. This "
-		       "will be ignored.\n", mmc_hostname(host));
+		pr_warn("%s: SD card claims to support the "
+			"incompletely defined 'low voltage range'. This "
+			"will be ignored.\n", mmc_hostname(host));
 		ocr &= ~MMC_VDD_165_195;
 	}
 
-- 
1.7.9.5

