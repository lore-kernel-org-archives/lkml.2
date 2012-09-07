Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab2IGEaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:30:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32812 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab2IGEau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:30:50 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 26/57] staging/rts_pstor: remove braces {} in sd.c (sd_tuning_rx)
Date: Fri,  7 Sep 2012 13:30:45 +0900
Message-Id: <1346992245-17220-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 1dfabcf..cb6ba17 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -1680,17 +1680,16 @@ static int sd_tuning_rx(struct rtsx_chip *chip)
 	int (*tuning_cmd)(struct rtsx_chip *chip, u8 sample_point);
 
 	if (CHK_SD(sd_card)) {
-		if (CHK_SD_DDR50(sd_card)) {
+		if (CHK_SD_DDR50(sd_card))
 			tuning_cmd = sd_ddr_tuning_rx_cmd;
-		} else {
+		else
 			tuning_cmd = sd_sdr_tuning_rx_cmd;
-		}
+
 	} else {
-		if (CHK_MMC_DDR52(sd_card)) {
+		if (CHK_MMC_DDR52(sd_card))
 			tuning_cmd = mmc_ddr_tunning_rx_cmd;
-		} else {
+		else
 			TRACE_RET(chip, STATUS_FAIL);
-		}
 	}
 
 	for (i = 0; i < 3; i++) {
@@ -1702,27 +1701,24 @@ static int sd_tuning_rx(struct rtsx_chip *chip)
 			}
 
 			retval = tuning_cmd(chip, (u8)j);
-			if (retval == STATUS_SUCCESS) {
+			if (retval == STATUS_SUCCESS)
 				raw_phase_map[i] |= 1 << j;
-			}
 		}
 	}
 
 	phase_map = raw_phase_map[0] & raw_phase_map[1] & raw_phase_map[2];
-	for (i = 0; i < 3; i++) {
+	for (i = 0; i < 3; i++)
 		RTSX_DEBUGP("RX raw_phase_map[%d] = 0x%08x\n", i, raw_phase_map[i]);
-	}
+
 	RTSX_DEBUGP("RX phase_map = 0x%08x\n", phase_map);
 
 	final_phase = sd_search_final_phase(chip, phase_map, TUNE_RX);
-	if (final_phase == 0xFF) {
+	if (final_phase == 0xFF)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = sd_change_phase(chip, final_phase, TUNE_RX);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
-- 
1.7.9.5

