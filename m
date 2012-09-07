Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100Ab2IGEQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:16:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35124 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab2IGEQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:16:36 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 01/57] staging/rts_pstor: remove braces {} in sd.c (sd_send_cmd_get_rsp)
Date: Fri,  7 Sep 2012 13:16:27 +0900
Message-Id: <1346991387-16321-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346506980-2868-1-git-send-email-yamanetoshi@gmail.com>
References: <1346506980-2868-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
-WARNING: braces {} are not necessary for single statement blocks
-WARNING: braces {} are not necessary for any arm of this statement

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/sd.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 3cc9a48..3a7f869 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -192,9 +192,9 @@ RTY_SEND_CMD:
 
 		stat_idx = 16;
 	} else if (rsp_type != SD_RSP_TYPE_R0) {
-		for (reg_addr = REG_SD_CMD0; reg_addr <= REG_SD_CMD4; reg_addr++) {
+		for (reg_addr = REG_SD_CMD0; reg_addr <= REG_SD_CMD4; reg_addr++)
 			rtsx_add_cmd(chip, READ_REG_CMD, reg_addr, 0, 0);
-		}
+
 		stat_idx = 5;
 	}
 
@@ -273,9 +273,8 @@ RTY_SEND_CMD:
 	if ((rsp_type == SD_RSP_TYPE_R1) || (rsp_type == SD_RSP_TYPE_R1b)) {
 		if ((cmd_idx != SEND_RELATIVE_ADDR) && (cmd_idx != SEND_IF_COND)) {
 			if (cmd_idx != STOP_TRANSMISSION) {
-				if (ptr[1] & 0x80) {
+				if (ptr[1] & 0x80)
 					TRACE_RET(chip, STATUS_FAIL);
-				}
 			}
 #ifdef SUPPORT_SD_LOCK
 			if (ptr[1] & 0x7D)
@@ -294,11 +293,10 @@ RTY_SEND_CMD:
 				RTSX_DEBUGP("ptr[3]: 0x%02x\n", ptr[3]);
 				TRACE_RET(chip, STATUS_FAIL);
 			}
-			if (ptr[3] & 0x01) {
+			if (ptr[3] & 0x01)
 				sd_card->sd_data_buf_ready = 1;
-			} else {
+			else
 				sd_card->sd_data_buf_ready = 0;
-			}
 		}
 	}
 
-- 
1.7.9.5

