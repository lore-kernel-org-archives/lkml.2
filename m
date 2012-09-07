Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab2IGEXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:23:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47025 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab2IGEXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:23:52 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 05/57] staging/rts_pstor: remove braces {} in sd.c (sd_set_sample_push_timing)
Date: Fri,  7 Sep 2012 13:23:46 +0900
Message-Id: <1346991826-16541-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |   31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 88163e1..28fc8a2 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -559,22 +559,21 @@ static int sd_set_sample_push_timing(struct rtsx_chip *chip)
 					CRC_FIX_CLK | SD30_VAR_CLK0 | SAMPLE_VAR_CLK1);
 			RTSX_WRITE_REG(chip, CLK_CTL, CLK_LOW_FREQ, 0);
 
-			if ((chip->sd_ctl & SD_PUSH_POINT_CTL_MASK) == SD_PUSH_POINT_AUTO) {
+			if ((chip->sd_ctl & SD_PUSH_POINT_CTL_MASK) == SD_PUSH_POINT_AUTO)
 				val = SD20_TX_NEG_EDGE;
-			} else if ((chip->sd_ctl & SD_PUSH_POINT_CTL_MASK) == SD_PUSH_POINT_DELAY) {
+			else if ((chip->sd_ctl & SD_PUSH_POINT_CTL_MASK) == SD_PUSH_POINT_DELAY)
 				val = SD20_TX_14_AHEAD;
-			} else {
+			else
 				val = SD20_TX_NEG_EDGE;
-			}
+
 			RTSX_WRITE_REG(chip, SD_PUSH_POINT_CTL, SD20_TX_SEL_MASK, val);
 
 			if ((chip->sd_ctl & SD_SAMPLE_POINT_CTL_MASK) == SD_SAMPLE_POINT_AUTO) {
 				if (chip->asic_code) {
-					if (CHK_SD_HS(sd_card) || CHK_MMC_52M(sd_card)) {
+					if (CHK_SD_HS(sd_card) || CHK_MMC_52M(sd_card))
 						val = SD20_RX_14_DELAY;
-					} else {
+					else
 						val = SD20_RX_POS_EDGE;
-					}
 				} else {
 					val = SD20_RX_14_DELAY;
 				}
@@ -588,32 +587,28 @@ static int sd_set_sample_push_timing(struct rtsx_chip *chip)
 	} else {
 		u8 val = 0;
 
-		if ((chip->sd_ctl & SD_PUSH_POINT_CTL_MASK) == SD_PUSH_POINT_DELAY) {
+		if ((chip->sd_ctl & SD_PUSH_POINT_CTL_MASK) == SD_PUSH_POINT_DELAY)
 			val |= 0x10;
-		}
 
 		if ((chip->sd_ctl & SD_SAMPLE_POINT_CTL_MASK) == SD_SAMPLE_POINT_AUTO) {
 			if (chip->asic_code) {
 				if (CHK_SD_HS(sd_card) || CHK_MMC_52M(sd_card)) {
-					if (val & 0x10) {
+					if (val & 0x10)
 						val |= 0x04;
-					} else {
+					else
 						val |= 0x08;
-					}
 				}
 			} else {
-				if (val & 0x10) {
+				if (val & 0x10)
 					val |= 0x04;
-				} else {
+				else
 					val |= 0x08;
-				}
 			}
 		} else if ((chip->sd_ctl & SD_SAMPLE_POINT_CTL_MASK) == SD_SAMPLE_POINT_DELAY) {
-			if (val & 0x10) {
+			if (val & 0x10)
 				val |= 0x04;
-			} else {
+			else
 				val |= 0x08;
-			}
 		}
 
 		RTSX_WRITE_REG(chip, REG_SD_CFG1, 0x1C, val);
-- 
1.7.9.5

