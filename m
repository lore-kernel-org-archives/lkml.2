Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab2GHKP5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 06:15:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44151 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab2GHKP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 06:15:56 -0400
From: Hitoshi Nakamori <hitoshi.nakamori@gmail.com>
To: gregkh@linuxfoundation.org
Cc: hitoshi.nakamori@gmail.com, wei_wang@realsil.com.cn,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] staging:rts_pstor: Fix coding style issue in ms.c
Date: Sun,  8 Jul 2012 10:15:48 +0900
Message-Id: <1341710152-4266-1-git-send-email-hitoshi.nakamori@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ms.c that fixes up some brace warning found by checkpatch.pl tool.

Signed-off-by: Hitoshi Nakamori <hitoshi.nakamori@gmail.com>
---
 drivers/staging/rts_pstor/ms.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rts_pstor/ms.c b/drivers/staging/rts_pstor/ms.c
index 0bf6d95..179a068 100644
--- a/drivers/staging/rts_pstor/ms.c
+++ b/drivers/staging/rts_pstor/ms.c
@@ -109,9 +109,8 @@ static int ms_transfer_data(struct rtsx_chip *chip, u8 trans_mode, u8 tpc, u16 s
 	u8 val, err_code = 0;
 	enum dma_data_direction dir;
 
-	if (!buf || !buf_len) {
+	if (!buf || !buf_len)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	if (trans_mode == MS_TM_AUTO_READ) {
 		dir = DMA_FROM_DEVICE;
@@ -151,18 +150,16 @@ static int ms_transfer_data(struct rtsx_chip *chip, u8 trans_mode, u8 tpc, u16 s
 				    use_sg, dir, chip->mspro_timeout);
 	if (retval < 0) {
 		ms_set_err_code(chip, err_code);
-		if (retval == -ETIMEDOUT) {
+		if (retval == -ETIMEDOUT)
 			retval = STATUS_TIMEDOUT;
-		} else {
+		else
 			retval = STATUS_FAIL;
-		}
 		TRACE_RET(chip, retval);
 	}
 
 	RTSX_READ_REG(chip, MS_TRANS_CFG, &val);
-	if (val & (MS_INT_CMDNK | MS_INT_ERR | MS_CRC16_ERR | MS_RDY_TIMEOUT)) {
+	if (val & (MS_INT_CMDNK | MS_INT_ERR | MS_CRC16_ERR | MS_RDY_TIMEOUT))
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
@@ -173,9 +170,8 @@ static int ms_write_bytes(struct rtsx_chip *chip,
 	struct ms_info *ms_card = &(chip->ms_card);
 	int retval, i;
 
-	if (!data || (data_len < cnt)) {
+	if (!data || (data_len < cnt))
 		TRACE_RET(chip, STATUS_ERROR);
-	}
 
 	rtsx_init_cmd(chip);
 
@@ -183,9 +179,8 @@ static int ms_write_bytes(struct rtsx_chip *chip,
 		rtsx_add_cmd(chip, WRITE_REG_CMD,
 			     PPBUF_BASE2 + i, 0xFF, data[i]);
 	}
-	if (cnt % 2) {
+	if (cnt % 2)
 		rtsx_add_cmd(chip, WRITE_REG_CMD, PPBUF_BASE2 + i, 0xFF, 0xFF);
-	}
 
 	rtsx_add_cmd(chip, WRITE_REG_CMD, MS_TPC, 0xFF, tpc);
 	rtsx_add_cmd(chip, WRITE_REG_CMD, MS_BYTE_CNT, 0xFF, cnt);
@@ -238,9 +233,8 @@ static int ms_read_bytes(struct rtsx_chip *chip, u8 tpc, u8 cnt, u8 cfg, u8 *dat
 	int retval, i;
 	u8 *ptr;
 
-	if (!data) {
+	if (!data)
 		TRACE_RET(chip, STATUS_ERROR);
-	}
 
 	rtsx_init_cmd(chip);
 
-- 
1.7.10

