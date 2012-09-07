Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab2IGEdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:33:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43087 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab2IGEdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:33:23 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 32/57] staging/rts_pstor: remove braces {} in sd.c (sd_switch_clock)
Date: Fri,  7 Sep 2012 13:33:16 +0900
Message-Id: <1346992396-17413-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
References: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
-WARNING: braces {} are not necessary for any arm of this statement
-WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/sd.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index c22689c..5e4e007 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -1900,9 +1900,8 @@ int sd_switch_clock(struct rtsx_chip *chip)
 	int re_tuning = 0;
 
 	retval = select_card(chip, SD_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (CHECK_PID(chip, 0x5209) &&
 			(CHK_SD30_SPEED(sd_card) || CHK_MMC_DDR52(sd_card))) {
@@ -1913,26 +1912,22 @@ int sd_switch_clock(struct rtsx_chip *chip)
 	}
 
 	retval = switch_clock(chip, sd_card->sd_clock);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (re_tuning) {
 		if (CHK_SD(sd_card)) {
-			if (CHK_SD_DDR50(sd_card)) {
+			if (CHK_SD_DDR50(sd_card))
 				retval = sd_ddr_tuning(chip);
-			} else {
+			else
 				retval = sd_sdr_tuning(chip);
-			}
 		} else {
-			if (CHK_MMC_DDR52(sd_card)) {
+			if (CHK_MMC_DDR52(sd_card))
 				retval = mmc_ddr_tuning(chip);
-			}
 		}
 
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	return STATUS_SUCCESS;
-- 
1.7.9.5

