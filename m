Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab2IGE3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:29:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58147 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab2IGE3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:29:05 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 19/57] staging/rts_pstor: remove braces {} in sd.c (sd_switch_function)
Date: Fri,  7 Sep 2012 13:29:00 +0900
Message-Id: <1346992140-16996-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |   48 ++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index c90deb6..558f25b3 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -1224,9 +1224,8 @@ static int sd_switch_function(struct rtsx_chip *chip, u8 bus_width)
 	/* Get supported functions */
 	retval = sd_check_switch_mode(chip, SD_CHECK_MODE,
 			NO_ARGUMENT, NO_ARGUMENT, bus_width);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	sd_card->func_group1_mask &= ~(sd_card->sd_switch_fail);
 
@@ -1255,9 +1254,9 @@ static int sd_switch_function(struct rtsx_chip *chip, u8 bus_width)
 			break;
 
 		case HS_SUPPORT:
-			if (sd_card->func_group1_mask & HS_SUPPORT_MASK) {
+			if (sd_card->func_group1_mask & HS_SUPPORT_MASK)
 				func_to_switch = HS_SUPPORT;
-			}
+
 			break;
 
 		default:
@@ -1265,9 +1264,9 @@ static int sd_switch_function(struct rtsx_chip *chip, u8 bus_width)
 		}
 
 
-		if (func_to_switch) {
+		if (func_to_switch)
 			break;
-		}
+
 	}
 	RTSX_DEBUGP("SD_FUNC_GROUP_1: func_to_switch = 0x%02x", func_to_switch);
 
@@ -1296,23 +1295,21 @@ static int sd_switch_function(struct rtsx_chip *chip, u8 bus_width)
 			TRACE_RET(chip, STATUS_FAIL);
 		}
 
-		if (func_to_switch == SDR104_SUPPORT) {
+		if (func_to_switch == SDR104_SUPPORT)
 			SET_SD_SDR104(sd_card);
-		} else if (func_to_switch == DDR50_SUPPORT) {
+		else if (func_to_switch == DDR50_SUPPORT)
 			SET_SD_DDR50(sd_card);
-		} else if (func_to_switch == SDR50_SUPPORT) {
+		else if (func_to_switch == SDR50_SUPPORT)
 			SET_SD_SDR50(sd_card);
-		} else {
+		else
 			SET_SD_HS(sd_card);
-		}
 	}
 
 	if (CHK_SD_DDR50(sd_card)) {
 		RTSX_WRITE_REG(chip, SD_PUSH_POINT_CTL, 0x06, 0x04);
 		retval = sd_set_sample_push_timing(chip);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	if (!func_to_switch || (func_to_switch == HS_SUPPORT)) {
@@ -1328,36 +1325,35 @@ static int sd_switch_function(struct rtsx_chip *chip, u8 bus_width)
 	for (i = 0; i < 4; i++) {
 		switch ((u8)(chip->sd_current_prior >> (i*8))) {
 		case CURRENT_LIMIT_800:
-			if (sd_card->func_group4_mask & CURRENT_LIMIT_800_MASK) {
+			if (sd_card->func_group4_mask & CURRENT_LIMIT_800_MASK)
 				func_to_switch = CURRENT_LIMIT_800;
-			}
+
 			break;
 
 		case CURRENT_LIMIT_600:
-			if (sd_card->func_group4_mask & CURRENT_LIMIT_600_MASK) {
+			if (sd_card->func_group4_mask & CURRENT_LIMIT_600_MASK)
 				func_to_switch = CURRENT_LIMIT_600;
-			}
+
 			break;
 
 		case CURRENT_LIMIT_400:
-			if (sd_card->func_group4_mask & CURRENT_LIMIT_400_MASK) {
+			if (sd_card->func_group4_mask & CURRENT_LIMIT_400_MASK)
 				func_to_switch = CURRENT_LIMIT_400;
-			}
+
 			break;
 
 		case CURRENT_LIMIT_200:
-			if (sd_card->func_group4_mask & CURRENT_LIMIT_200_MASK) {
+			if (sd_card->func_group4_mask & CURRENT_LIMIT_200_MASK)
 				func_to_switch = CURRENT_LIMIT_200;
-			}
+
 			break;
 
 		default:
 			continue;
 		}
 
-		if (func_to_switch != 0xFF) {
+		if (func_to_switch != 0xFF)
 			break;
-		}
 	}
 
 	RTSX_DEBUGP("SD_FUNC_GROUP_4: func_to_switch = 0x%02x", func_to_switch);
@@ -1365,16 +1361,14 @@ static int sd_switch_function(struct rtsx_chip *chip, u8 bus_width)
 	if (func_to_switch <= CURRENT_LIMIT_800) {
 		retval = sd_check_switch(chip, SD_FUNC_GROUP_4, func_to_switch, bus_width);
 		if (retval != STATUS_SUCCESS) {
-			if (sd_check_err_code(chip, SD_NO_CARD)) {
+			if (sd_check_err_code(chip, SD_NO_CARD))
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 		}
 		RTSX_DEBUGP("Switch current limit finished! (%d)\n", retval);
 	}
 
-	if (CHK_SD_DDR50(sd_card)) {
+	if (CHK_SD_DDR50(sd_card))
 		RTSX_WRITE_REG(chip, SD_PUSH_POINT_CTL, 0x06, 0);
-	}
 
 	return STATUS_SUCCESS;
 }
-- 
1.7.9.5

