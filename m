Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab2IGEdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:33:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43087 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab2IGEdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:33:50 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 33/57] staging/rts_pstor: remove braces {} in sd.c (sd_prepare_reset)
Date: Fri,  7 Sep 2012 13:33:45 +0900
Message-Id: <1346992425-17447-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 5e4e007..667e93d 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -1938,11 +1938,10 @@ static int sd_prepare_reset(struct rtsx_chip *chip)
 	struct sd_info *sd_card = &(chip->sd_card);
 	int retval;
 
-	if (chip->asic_code) {
+	if (chip->asic_code)
 		sd_card->sd_clock = 29;
-	} else {
+	else
 		sd_card->sd_clock = CLK_30;
-	}
 
 	sd_card->sd_type = 0;
 	sd_card->seq_mode = 0;
@@ -1958,9 +1957,8 @@ static int sd_prepare_reset(struct rtsx_chip *chip)
 	chip->sd_io = 0;
 
 	retval = sd_set_init_para(chip);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, retval);
-	}
 
 	if (CHECK_PID(chip, 0x5209)) {
 		RTSX_WRITE_REG(chip, REG_SD_CFG1, 0xFF,
@@ -1974,9 +1972,8 @@ static int sd_prepare_reset(struct rtsx_chip *chip)
 	RTSX_WRITE_REG(chip, CARD_STOP, SD_STOP | SD_CLR_ERR, SD_STOP | SD_CLR_ERR);
 
 	retval = select_card(chip, SD_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
-- 
1.7.9.5

