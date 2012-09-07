Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075Ab2IGEhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:37:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43598 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab2IGEhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:37:52 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 49/57] staging/rts_pstor: remove braces {} in sd.c (ext_sd_get_rsp)
Date: Fri,  7 Sep 2012 13:37:47 +0900
Message-Id: <1346992667-17966-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/rts_pstor/sd.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 4168af6..9091700 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -3599,29 +3599,27 @@ int ext_sd_get_rsp(struct rtsx_chip *chip, int len, u8 *rsp, u8 rsp_type)
 	int retval, rsp_len;
 	u16 reg_addr;
 
-	if (rsp_type == SD_RSP_TYPE_R0) {
+	if (rsp_type == SD_RSP_TYPE_R0)
 		return STATUS_SUCCESS;
-	}
 
 	rtsx_init_cmd(chip);
 
 	if (rsp_type == SD_RSP_TYPE_R2) {
-		for (reg_addr = PPBUF_BASE2; reg_addr < PPBUF_BASE2 + 16; reg_addr++) {
+		for (reg_addr = PPBUF_BASE2; reg_addr < PPBUF_BASE2 + 16; reg_addr++)
 			rtsx_add_cmd(chip, READ_REG_CMD, reg_addr, 0xFF, 0);
-		}
+
 		rsp_len = 17;
 	} else if (rsp_type != SD_RSP_TYPE_R0) {
-		for (reg_addr = REG_SD_CMD0; reg_addr <= REG_SD_CMD4; reg_addr++) {
+		for (reg_addr = REG_SD_CMD0; reg_addr <= REG_SD_CMD4; reg_addr++)
 			rtsx_add_cmd(chip, READ_REG_CMD, reg_addr, 0xFF, 0);
-		}
+
 		rsp_len = 6;
 	}
 	rtsx_add_cmd(chip, READ_REG_CMD, REG_SD_CMD5, 0xFF, 0);
 
 	retval = rtsx_send_cmd(chip, SD_CARD, 100);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (rsp) {
 		int min_len = (rsp_len < len) ? rsp_len : len;
-- 
1.7.9.5

