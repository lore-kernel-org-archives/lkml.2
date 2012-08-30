Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab2H3NpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 09:45:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46966 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab2H3NpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 09:45:19 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH] staging/rts_pstor: remove braces {} in rtsx_transport.c
Date: Thu, 30 Aug 2012 22:45:11 +0900
Message-Id: <1346334311-20771-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
-WARNING: braces {} are not necessary for single statement blocks
-WARNING: braces {} are not necessary for any arm of this statement

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/rtsx_transport.c |  100 +++++++++++++---------------
 1 file changed, 45 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx_transport.c b/drivers/staging/rts_pstor/rtsx_transport.c
index 54a4742..1f9a424 100644
--- a/drivers/staging/rts_pstor/rtsx_transport.c
+++ b/drivers/staging/rts_pstor/rtsx_transport.c
@@ -218,9 +218,9 @@ void rtsx_add_cmd(struct rtsx_chip *chip,
 	val |= (u32)data;
 
 	spin_lock_irq(&chip->rtsx->reg_lock);
-	if (chip->ci < (HOST_CMDS_BUF_LEN / 4)) {
+	if (chip->ci < (HOST_CMDS_BUF_LEN / 4))
 		cb[(chip->ci)++] = cpu_to_le32(val);
-	}
+
 	spin_unlock_irq(&chip->rtsx->reg_lock);
 }
 
@@ -244,15 +244,14 @@ int rtsx_send_cmd(struct rtsx_chip *chip, u8 card, int timeout)
 	long timeleft;
 	int err = 0;
 
-	if (card == SD_CARD) {
+	if (card == SD_CARD)
 		rtsx->check_card_cd = SD_EXIST;
-	} else if (card == MS_CARD) {
+	else if (card == MS_CARD)
 		rtsx->check_card_cd = MS_EXIST;
-	} else if (card == XD_CARD) {
+	else if (card == XD_CARD)
 		rtsx->check_card_cd = XD_EXIST;
-	} else {
+	else
 		rtsx->check_card_cd = 0;
-	}
 
 	spin_lock_irq(&rtsx->reg_lock);
 
@@ -281,11 +280,11 @@ int rtsx_send_cmd(struct rtsx_chip *chip, u8 card, int timeout)
 	}
 
 	spin_lock_irq(&rtsx->reg_lock);
-	if (rtsx->trans_result == TRANS_RESULT_FAIL) {
+	if (rtsx->trans_result == TRANS_RESULT_FAIL)
 		err = -EIO;
-	} else if (rtsx->trans_result == TRANS_RESULT_OK) {
+	else if (rtsx->trans_result == TRANS_RESULT_OK)
 		err = 0;
-	}
+
 	spin_unlock_irq(&rtsx->reg_lock);
 
 finish_send_cmd:
@@ -341,23 +340,21 @@ static int rtsx_transfer_sglist_adma_partial(struct rtsx_chip *chip, u8 card,
 	if ((sg == NULL) || (num_sg <= 0) || !offset || !index)
 		return -EIO;
 
-	if (dma_dir == DMA_TO_DEVICE) {
+	if (dma_dir == DMA_TO_DEVICE)
 		dir = HOST_TO_DEVICE;
-	} else if (dma_dir == DMA_FROM_DEVICE) {
+	else if (dma_dir == DMA_FROM_DEVICE)
 		dir = DEVICE_TO_HOST;
-	} else {
+	else
 		return -ENXIO;
-	}
 
-	if (card == SD_CARD) {
+	if (card == SD_CARD)
 		rtsx->check_card_cd = SD_EXIST;
-	} else if (card == MS_CARD) {
+	else if (card == MS_CARD)
 		rtsx->check_card_cd = MS_EXIST;
-	} else if (card == XD_CARD) {
+	else if (card == XD_CARD)
 		rtsx->check_card_cd = XD_EXIST;
-	} else {
+	else
 		rtsx->check_card_cd = 0;
-	}
 
 	spin_lock_irq(&rtsx->reg_lock);
 
@@ -405,11 +402,10 @@ static int rtsx_transfer_sglist_adma_partial(struct rtsx_chip *chip, u8 card,
 			*offset = 0;
 			*index = *index + 1;
 		}
-		if ((i == (sg_cnt - 1)) || !resid) {
+		if ((i == (sg_cnt - 1)) || !resid)
 			option = SG_VALID | SG_END | SG_TRANS_DATA;
-		} else {
+		else
 			option = SG_VALID | SG_TRANS_DATA;
-		}
 
 		rtsx_add_sg_tbl(chip, (u32)addr, (u32)len, option);
 
@@ -468,11 +464,11 @@ static int rtsx_transfer_sglist_adma_partial(struct rtsx_chip *chip, u8 card,
 	}
 
 	spin_lock_irq(&rtsx->reg_lock);
-	if (rtsx->trans_result == TRANS_RESULT_FAIL) {
+	if (rtsx->trans_result == TRANS_RESULT_FAIL)
 		err = -EIO;
-	} else if (rtsx->trans_result == TRANS_RESULT_OK) {
+	else if (rtsx->trans_result == TRANS_RESULT_OK)
 		err = 0;
-	}
+
 	spin_unlock_irq(&rtsx->reg_lock);
 
 out:
@@ -501,23 +497,21 @@ static int rtsx_transfer_sglist_adma(struct rtsx_chip *chip, u8 card,
 	if ((sg == NULL) || (num_sg <= 0))
 		return -EIO;
 
-	if (dma_dir == DMA_TO_DEVICE) {
+	if (dma_dir == DMA_TO_DEVICE)
 		dir = HOST_TO_DEVICE;
-	} else if (dma_dir == DMA_FROM_DEVICE) {
+	else if (dma_dir == DMA_FROM_DEVICE)
 		dir = DEVICE_TO_HOST;
-	} else {
+	else
 		return -ENXIO;
-	}
 
-	if (card == SD_CARD) {
+	if (card == SD_CARD)
 		rtsx->check_card_cd = SD_EXIST;
-	} else if (card == MS_CARD) {
+	else if (card == MS_CARD)
 		rtsx->check_card_cd = MS_EXIST;
-	} else if (card == XD_CARD) {
+	else if (card == XD_CARD)
 		rtsx->check_card_cd = XD_EXIST;
-	} else {
+	else
 		rtsx->check_card_cd = 0;
-	}
 
 	spin_lock_irq(&rtsx->reg_lock);
 
@@ -537,11 +531,10 @@ static int rtsx_transfer_sglist_adma(struct rtsx_chip *chip, u8 card,
 		u32 val = TRIG_DMA;
 		int sg_cnt, j;
 
-		if (i == buf_cnt / (HOST_SG_TBL_BUF_LEN / 8)) {
+		if (i == buf_cnt / (HOST_SG_TBL_BUF_LEN / 8))
 			sg_cnt = buf_cnt % (HOST_SG_TBL_BUF_LEN / 8);
-		} else {
+		else
 			sg_cnt = (HOST_SG_TBL_BUF_LEN / 8);
-		}
 
 		chip->sgi = 0;
 		for (j = 0; j < sg_cnt; j++) {
@@ -552,11 +545,10 @@ static int rtsx_transfer_sglist_adma(struct rtsx_chip *chip, u8 card,
 			RTSX_DEBUGP("DMA addr: 0x%x, Len: 0x%x\n",
 				     (unsigned int)addr, len);
 
-			if (j == (sg_cnt - 1)) {
+			if (j == (sg_cnt - 1))
 				option = SG_VALID | SG_END | SG_TRANS_DATA;
-			} else {
+			else
 				option = SG_VALID | SG_TRANS_DATA;
-			}
 
 			rtsx_add_sg_tbl(chip, (u32)addr, (u32)len, option);
 
@@ -615,11 +607,11 @@ static int rtsx_transfer_sglist_adma(struct rtsx_chip *chip, u8 card,
 	}
 
 	spin_lock_irq(&rtsx->reg_lock);
-	if (rtsx->trans_result == TRANS_RESULT_FAIL) {
+	if (rtsx->trans_result == TRANS_RESULT_FAIL)
 		err = -EIO;
-	} else if (rtsx->trans_result == TRANS_RESULT_OK) {
+	else if (rtsx->trans_result == TRANS_RESULT_OK)
 		err = 0;
-	}
+
 	spin_unlock_irq(&rtsx->reg_lock);
 
 out:
@@ -647,27 +639,25 @@ static int rtsx_transfer_buf(struct rtsx_chip *chip, u8 card, void *buf, size_t
 	if ((buf == NULL) || (len <= 0))
 		return -EIO;
 
-	if (dma_dir == DMA_TO_DEVICE) {
+	if (dma_dir == DMA_TO_DEVICE)
 		dir = HOST_TO_DEVICE;
-	} else if (dma_dir == DMA_FROM_DEVICE) {
+	else if (dma_dir == DMA_FROM_DEVICE)
 		dir = DEVICE_TO_HOST;
-	} else {
+	else
 		return -ENXIO;
-	}
 
 	addr = dma_map_single(&(rtsx->pci->dev), buf, len, dma_dir);
 	if (!addr)
 		return -ENOMEM;
 
-	if (card == SD_CARD) {
+	if (card == SD_CARD)
 		rtsx->check_card_cd = SD_EXIST;
-	} else if (card == MS_CARD) {
+	else if (card == MS_CARD)
 		rtsx->check_card_cd = MS_EXIST;
-	} else if (card == XD_CARD) {
+	else if (card == XD_CARD)
 		rtsx->check_card_cd = XD_EXIST;
-	} else {
+	else
 		rtsx->check_card_cd = 0;
-	}
 
 	val |= (u32)(dir & 0x01) << 29;
 	val |= (u32)(len & 0x00FFFFFF);
@@ -698,11 +688,11 @@ static int rtsx_transfer_buf(struct rtsx_chip *chip, u8 card, void *buf, size_t
 	}
 
 	spin_lock_irq(&rtsx->reg_lock);
-	if (rtsx->trans_result == TRANS_RESULT_FAIL) {
+	if (rtsx->trans_result == TRANS_RESULT_FAIL)
 		err = -EIO;
-	} else if (rtsx->trans_result == TRANS_RESULT_OK) {
+	else if (rtsx->trans_result == TRANS_RESULT_OK)
 		err = 0;
-	}
+
 	spin_unlock_irq(&rtsx->reg_lock);
 
 out:
-- 
1.7.9.5

