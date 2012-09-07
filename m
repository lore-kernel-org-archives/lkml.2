Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab2IGEgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:36:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57482 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab2IGEgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:36:16 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 43/57] staging/rts_pstor: remove braces {} in sd.c (reset_mmc_only)
Date: Fri,  7 Sep 2012 13:36:11 +0900
Message-Id: <1346992571-17770-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
References: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
-WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/sd.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index f0b11a4..f109bbc 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -3060,33 +3060,29 @@ static int reset_mmc_only(struct rtsx_chip *chip)
 	chip->capacity[chip->card2lun[SD_CARD]] = sd_card->capacity = 0;
 
 	retval = enable_card_clock(chip, SD_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = sd_init_power(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = reset_mmc(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = sd_set_clock_divider(chip, SD_CLK_DIVIDE_0);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
+
 	RTSX_WRITE_REG(chip, REG_SD_BYTE_CNT_L, 0xFF, 0);
 	RTSX_WRITE_REG(chip, REG_SD_BYTE_CNT_H, 0xFF, 2);
 
 	chip->capacity[chip->card2lun[SD_CARD]] = sd_card->capacity;
 
 	retval = sd_set_init_para(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_DEBUGP("In reset_mmc_only, sd_card->sd_type = 0x%x\n", sd_card->sd_type);
 
-- 
1.7.9.5

