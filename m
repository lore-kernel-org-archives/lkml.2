Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab2IGEXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:23:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35260 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2IGEXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:23:35 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 04/57] staging/rts_pstor: remove braces {} in sd.c (sd_check_csd)
Date: Fri,  7 Sep 2012 13:23:29 +0900
Message-Id: <1346991809-16509-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
References: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
-WARNING: braces {} are not necessary for single statement blocks
-WARNING: braces {} are not necessary for any arm of this statement

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/sd.c |   39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index b9624f2..88163e1 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -444,15 +444,13 @@ static int sd_check_csd(struct rtsx_chip *chip, char check_wp)
 			break;
 	}
 
-	if (i == 6) {
+	if (i == 6)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	memcpy(sd_card->raw_csd, rsp + 1, 15);
 
-	if (CHECK_PID(chip, 0x5209)) {
+	if (CHECK_PID(chip, 0x5209))
 		RTSX_READ_REG(chip, REG_SD_CMD5, sd_card->raw_csd + 15);
-	}
 
 	RTSX_DEBUGP("CSD Response:\n");
 	RTSX_DUMP(sd_card->raw_csd, 16);
@@ -463,35 +461,34 @@ static int sd_check_csd(struct rtsx_chip *chip, char check_wp)
 	trans_speed = rsp[4];
 	if ((trans_speed & 0x07) == 0x02) {
 		if ((trans_speed & 0xf8) >= 0x30) {
-			if (chip->asic_code) {
+			if (chip->asic_code)
 				sd_card->sd_clock = 47;
-			} else {
+			else
 				sd_card->sd_clock = CLK_50;
-			}
+
 		} else if ((trans_speed & 0xf8) == 0x28) {
-			if (chip->asic_code) {
+			if (chip->asic_code)
 				sd_card->sd_clock = 39;
-			} else {
+			else
 				sd_card->sd_clock = CLK_40;
-			}
+
 		} else if ((trans_speed & 0xf8) == 0x20) {
-			if (chip->asic_code) {
+			if (chip->asic_code)
 				sd_card->sd_clock = 29;
-			} else {
+			else
 				sd_card->sd_clock = CLK_30;
-			}
+
 		} else if ((trans_speed & 0xf8) >= 0x10) {
-			if (chip->asic_code) {
+			if (chip->asic_code)
 				sd_card->sd_clock = 23;
-			} else {
+			else
 				sd_card->sd_clock = CLK_20;
-			}
+
 		} else if ((trans_speed & 0x08) >= 0x08) {
-			if (chip->asic_code) {
+			if (chip->asic_code)
 				sd_card->sd_clock = 19;
-			} else {
+			else
 				sd_card->sd_clock = CLK_20;
-			}
 		} else {
 			TRACE_RET(chip, STATUS_FAIL);
 		}
@@ -521,9 +518,9 @@ static int sd_check_csd(struct rtsx_chip *chip, char check_wp)
 	}
 
 	if (check_wp) {
-		if (rsp[15] & 0x30) {
+		if (rsp[15] & 0x30)
 			chip->card_wp |= SD_CARD;
-		}
+
 		RTSX_DEBUGP("CSD WP Status: 0x%x\n", rsp[15]);
 	}
 
-- 
1.7.9.5

