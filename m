Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab2IGEff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:35:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61979 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab2IGEfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:35:32 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 40/57] staging/rts_pstor: remove braces {} in sd.c (mmc_switch_timing_bus)
Date: Fri,  7 Sep 2012 13:35:28 +0900
Message-Id: <1346992528-17674-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index ff8eb96..dfb728b 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -2724,11 +2724,10 @@ static int mmc_switch_timing_bus(struct rtsx_chip *chip, int switch_ddr)
 			card_type_mask = 0x03;
 		}
 #else
-		if (chip->sd_ctl & SUPPORT_MMC_DDR_MODE) {
+		if (chip->sd_ctl & SUPPORT_MMC_DDR_MODE)
 			card_type_mask = 0x07;
-		} else {
+		else
 			card_type_mask = 0x03;
-		}
 #endif
 	} else {
 		card_type_mask = 0x03;
@@ -2738,11 +2737,10 @@ static int mmc_switch_timing_bus(struct rtsx_chip *chip, int switch_ddr)
 		u8 rsp[5];
 
 		if (card_type & 0x04) {
-			if (switch_ddr) {
+			if (switch_ddr)
 				SET_MMC_DDR52(sd_card);
-			} else {
+			else
 				SET_MMC_52M(sd_card);
-			}
 		} else if (card_type & 0x02) {
 			SET_MMC_52M(sd_card);
 		} else {
@@ -2751,16 +2749,14 @@ static int mmc_switch_timing_bus(struct rtsx_chip *chip, int switch_ddr)
 
 		retval = sd_send_cmd_get_rsp(chip, SWITCH,
 				0x03B90100, SD_RSP_TYPE_R1b, rsp, 5);
-		if ((retval != STATUS_SUCCESS) || (rsp[4] & MMC_SWITCH_ERR)) {
+		if ((retval != STATUS_SUCCESS) || (rsp[4] & MMC_SWITCH_ERR))
 			CLR_MMC_HS(sd_card);
-		}
 	}
 
 	sd_choose_proper_clock(chip);
 	retval = switch_clock(chip, sd_card->sd_clock);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	/* Test Bus Procedure */
 	retval = mmc_test_switch_bus(chip, MMC_8BIT_BUS);
-- 
1.7.9.5

