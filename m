Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab2IGEbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:31:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32812 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab2IGEbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:31:09 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 27/57] staging/rts_pstor: remove braces {} in sd.c (sd_ddr_pre_tuning_tx)
Date: Fri,  7 Sep 2012 13:31:04 +0900
Message-Id: <1346992264-17252-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index cb6ba17..9812c00 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -1743,15 +1743,13 @@ static int sd_ddr_pre_tuning_tx(struct rtsx_chip *chip)
 		}
 
 		retval = sd_change_phase(chip, (u8)i, TUNE_TX);
-		if (retval != STATUS_SUCCESS) {
+		if (retval != STATUS_SUCCESS)
 			continue;
-		}
 
 		retval = sd_send_cmd_get_rsp(chip, SEND_STATUS, sd_card->sd_addr,
 				SD_RSP_TYPE_R1, NULL, 0);
-		if ((retval == STATUS_SUCCESS) || !sd_check_err_code(chip, SD_RSP_TIMEOUT)) {
+		if ((retval == STATUS_SUCCESS) || !sd_check_err_code(chip, SD_RSP_TIMEOUT))
 			phase_map |= 1 << i;
-		}
 	}
 
 	RTSX_WRITE_REG(chip, SD_CFG3, SD_RSP_80CLK_TIMEOUT_EN, 0);
@@ -1759,14 +1757,12 @@ static int sd_ddr_pre_tuning_tx(struct rtsx_chip *chip)
 	RTSX_DEBUGP("DDR TX pre tune phase_map = 0x%08x\n", phase_map);
 
 	final_phase = sd_search_final_phase(chip, phase_map, TUNE_TX);
-	if (final_phase == 0xFF) {
+	if (final_phase == 0xFF)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = sd_change_phase(chip, final_phase, TUNE_TX);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	RTSX_DEBUGP("DDR TX pre tune phase: %d\n", (int)final_phase);
 
-- 
1.7.9.5

