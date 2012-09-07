Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab2IGEai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:30:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32812 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab2IGEaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:30:35 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 25/57] staging/rts_pstor: remove braces {} in sd.c (sd_search_final_phase)
Date: Fri,  7 Sep 2012 13:30:30 +0900
Message-Id: <1346992230-17188-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 24daabb..1dfabcf 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -1572,11 +1572,10 @@ static u8 sd_search_final_phase(struct rtsx_chip *chip, u32 phase_map, u8 tune_d
 	u8 final_phase = 0xFF;
 
 	if (phase_map == 0xFFFFFFFF) {
-		if (tune_dir == TUNE_RX) {
+		if (tune_dir == TUNE_RX)
 			final_phase = (u8)chip->sd_default_rx_phase;
-		} else {
+		else
 			final_phase = (u8)chip->sd_default_tx_phase;
-		}
 
 		goto Search_Finish;
 	}
@@ -1617,9 +1616,9 @@ static u8 sd_search_final_phase(struct rtsx_chip *chip, u32 phase_map, u8 tune_d
 		path[0].start = path[cont_path_cnt - 1].start - MAX_PHASE - 1;
 		path[0].len += path[cont_path_cnt - 1].len;
 		path[0].mid = path[0].start + path[0].len / 2;
-		if (path[0].mid < 0) {
+		if (path[0].mid < 0)
 			path[0].mid += MAX_PHASE + 1;
-		}
+
 		cont_path_cnt--;
 	}
 
@@ -1647,11 +1646,10 @@ static u8 sd_search_final_phase(struct rtsx_chip *chip, u32 phase_map, u8 tune_d
 				int temp_final_phase =
 					path[final_path_idx].end - (max_len - (6 + temp_mid));
 
-				if (temp_final_phase < 0) {
+				if (temp_final_phase < 0)
 					final_phase = (u8)(temp_final_phase + MAX_PHASE + 1);
-				} else {
+				else
 					final_phase = (u8)temp_final_phase;
-				}
 			}
 		} else if (CHK_SD_SDR50(sd_card)) {
 			if (max_len > 12) {
@@ -1659,11 +1657,10 @@ static u8 sd_search_final_phase(struct rtsx_chip *chip, u32 phase_map, u8 tune_d
 				int temp_final_phase =
 					path[final_path_idx].end - (max_len - (3 + temp_mid));
 
-				if (temp_final_phase < 0) {
+				if (temp_final_phase < 0)
 					final_phase = (u8)(temp_final_phase + MAX_PHASE + 1);
-				} else {
+				else
 					final_phase = (u8)temp_final_phase;
-				}
 			}
 		}
 	}
-- 
1.7.9.5

