Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab0F1Lzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 07:55:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48266 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab0F1Lzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 07:55:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WEvgUkT7UwGYPD944QQnTEBSE4DpTk7eb728QgRatn7Q/BITh1toEdCjqvgV4BlZyo
         vhUZ4YnGe9n/uOP/1B8m5qdveZ+c1Z1msIjjhs2g1VjJU5eZsEwod6D+3eLiPkbkDVH5
         yeJ6rS+1MFq2iPUXrrhGmWohvzTQi1YhHrRjs=
From: Kulikov Vasiliy <segooon@gmail.com>
To: trivial@kernel.org
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Pavel Machek <pavel@ucw.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Kulikov Vasiliy <segooon@gmail.com>, Lars Lindley <lindley@coyote.org>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/16] trivial: use ARRAY_SIZE
Date: Mon, 28 Jun 2010 15:55:37 +0400
Message-Id: <1277726138-24865-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/winbond/reg.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index d9a8128..990f9d4 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -966,42 +966,42 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 	switch (pHwData->phy_type) {
 	case RF_MAXIM_2825:
 	case RF_MAXIM_V1: /* 11g Winbond 2nd BB(with Phy board (v1) + Maxim 331) */
-		number = sizeof(max2825_rf_data) / sizeof(max2825_rf_data[0]);
+		number = ARRAY_SIZE(max2825_rf_data);
 		for (i = 0; i < number; i++) {
 			pHwData->phy_para[i] = max2825_rf_data[i]; /* Backup Rf parameter */
 			pltmp[i] = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(max2825_rf_data[i], 18);
 		}
 		break;
 	case RF_MAXIM_2827:
-		number = sizeof(max2827_rf_data) / sizeof(max2827_rf_data[0]);
+		number = ARRAY_SIZE(max2827_rf_data);
 		for (i = 0; i < number; i++) {
 			pHwData->phy_para[i] = max2827_rf_data[i];
 			pltmp[i] = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(max2827_rf_data[i], 18);
 		}
 		break;
 	case RF_MAXIM_2828:
-		number = sizeof(max2828_rf_data) / sizeof(max2828_rf_data[0]);
+		number = ARRAY_SIZE(max2828_rf_data);
 		for (i = 0; i < number; i++) {
 			pHwData->phy_para[i] = max2828_rf_data[i];
 			pltmp[i] = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(max2828_rf_data[i], 18);
 		}
 		break;
 	case RF_MAXIM_2829:
-		number = sizeof(max2829_rf_data) / sizeof(max2829_rf_data[0]);
+		number = ARRAY_SIZE(max2829_rf_data);
 		for (i = 0; i < number; i++) {
 			pHwData->phy_para[i] = max2829_rf_data[i];
 			pltmp[i] = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(max2829_rf_data[i], 18);
 		}
 		break;
 	case RF_AIROHA_2230:
-		number = sizeof(al2230_rf_data) / sizeof(al2230_rf_data[0]);
+		number = ARRAY_SIZE(al2230_rf_data);
 		for (i = 0; i < number; i++) {
 			pHwData->phy_para[i] = al2230_rf_data[i];
 			pltmp[i] = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse(al2230_rf_data[i], 20);
 		}
 		break;
 	case RF_AIROHA_2230S:
-		number = sizeof(al2230s_rf_data) / sizeof(al2230s_rf_data[0]);
+		number = ARRAY_SIZE(al2230s_rf_data);
 		for (i = 0; i < number; i++) {
 			pHwData->phy_para[i] = al2230s_rf_data[i];
 			pltmp[i] = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse(al2230s_rf_data[i], 20);
@@ -1013,12 +1013,12 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 		#ifdef _PE_STATE_DUMP_
 		printk("* PLL_ON    low\n");
 		#endif
-		number = sizeof(al7230_rf_data_24) / sizeof(al7230_rf_data_24[0]);
+		number = ARRAY_SIZE(al7230_rf_data_24);
 		Set_ChanIndep_RfData_al7230_24(pHwData, pltmp, number);
 		break;
 	case RF_WB_242:
 	case RF_WB_242_1:
-		number = sizeof(w89rf242_rf_data) / sizeof(w89rf242_rf_data[0]);
+		number = ARRAY_SIZE(w89rf242_rf_data);
 		for (i = 0; i < number; i++) {
 			ltmp = w89rf242_rf_data[i];
 			if (i == 4) { /* Update the VCO trim from EEPROM */
@@ -1119,7 +1119,7 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 		printk("* PLL_ON    low\n");
 		#endif
 
-		number = sizeof(al7230_rf_data_50) / sizeof(al7230_rf_data_50[0]);
+		number = ARRAY_SIZE(al7230_rf_data_50);
 		Set_ChanIndep_RfData_al7230_50(pHwData, pltmp, number);
 		/* Write to register. number must less and equal than 16 */
 		for (i = 0; i < number; i++)
@@ -1747,7 +1747,7 @@ void RFSynthesizer_SwitchingChannel(struct hw_data *pHwData,  struct chan_info C
 				pltmp[i] = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(max2829_channel_data_24[Channel.ChanNo-1][i], 18);
 			Wb35Reg_BurstWrite(pHwData, 0x0864, pltmp, 3, NO_INCREMENT);
 		} else if (Channel.band == BAND_TYPE_OFDM_5) {
-			count = sizeof(max2829_channel_data_50) / sizeof(max2829_channel_data_50[0]);
+			count = ARRAY_SIZE(max2829_channel_data_50);
 
 			for (i = 0; i < count; i++) {
 				if (max2829_channel_data_50[i][0] == Channel.ChanNo) {
@@ -1783,13 +1783,13 @@ void RFSynthesizer_SwitchingChannel(struct hw_data *pHwData,  struct chan_info C
 				/* Update BB register */
 				BBProcessor_AL7230_2400(pHwData);
 
-				number = sizeof(al7230_rf_data_24) / sizeof(al7230_rf_data_24[0]);
+				number = ARRAY_SIZE(al7230_rf_data_24);
 				Set_ChanIndep_RfData_al7230_24(pHwData, pltmp, number);
 			} else {
 				/* Update BB register */
 				BBProcessor_AL7230_5000(pHwData);
 
-				number = sizeof(al7230_rf_data_50) / sizeof(al7230_rf_data_50[0]);
+				number = ARRAY_SIZE(al7230_rf_data_50);
 				Set_ChanIndep_RfData_al7230_50(pHwData, pltmp, number);
 			}
 
@@ -1814,7 +1814,7 @@ void RFSynthesizer_SwitchingChannel(struct hw_data *pHwData,  struct chan_info C
 				Wb35Reg_Write(pHwData, 0x0864, ltmp);
 			}
 
-			count = sizeof(al7230_channel_data_5) / sizeof(al7230_channel_data_5[0]);
+			count = ARRAY_SIZE(al7230_channel_data_5);
 
 			for (i = 0; i < count; i++) {
 				if (al7230_channel_data_5[i][0] == Channel.ChanNo) {
@@ -1978,7 +1978,7 @@ u8 RFSynthesizer_SetAiroha2230Power(struct hw_data *pHwData, u8 index)
 	u32	PowerData;
 	u8	i, count;
 
-	count = sizeof(al2230_txvga_data) / sizeof(al2230_txvga_data[0]);
+	count = ARRAY_SIZE(al2230_txvga_data);
 	for (i = 0; i < count; i++) {
 		if (al2230_txvga_data[i][1] >= index)
 			break;
@@ -1996,7 +1996,7 @@ u8 RFSynthesizer_SetAiroha7230Power(struct hw_data *pHwData, u8 index)
 	u32	PowerData;
 	u8	i, count;
 
-	count = sizeof(al7230_txvga_data) / sizeof(al7230_txvga_data[0]);
+	count = ARRAY_SIZE(al7230_txvga_data);
 	for (i = 0; i < count; i++) {
 		if (al7230_txvga_data[i][1] >= index)
 			break;
@@ -2013,7 +2013,7 @@ u8 RFSynthesizer_SetWinbond242Power(struct hw_data *pHwData, u8 index)
 	u32	PowerData;
 	u8	i, count;
 
-	count = sizeof(w89rf242_txvga_data) / sizeof(w89rf242_txvga_data[0]);
+	count = ARRAY_SIZE(w89rf242_txvga_data);
 	for (i = 0; i < count; i++) {
 		if (w89rf242_txvga_data[i][1] >= index)
 			break;
@@ -2184,14 +2184,14 @@ void GetTxVgaFromEEPROM(struct hw_data *pHwData)
 	/* Adjust WB_242 to WB_242_1 TxVga scale */
 	if (pHwData->phy_type == RF_WB_242) {
 		for (i = 0; i < 4; i++) { /* Only 2412 2437 2462 2484 case must be modified */
-			for (j = 0; j < (sizeof(w89rf242_txvga_old_mapping) / sizeof(w89rf242_txvga_old_mapping[0])); j++) {
+			for (j = 0; j < ARRAY_SIZE(w89rf242_txvga_old_mapping); j++) {
 				if (pctmp[i] < (u8) w89rf242_txvga_old_mapping[j][1]) {
 					pctmp[i] = (u8) w89rf242_txvga_old_mapping[j][0];
 					break;
 				}
 			}
 
-			if (j == (sizeof(w89rf242_txvga_old_mapping) / sizeof(w89rf242_txvga_old_mapping[0])))
+			if (j == ARRAY_SIZE(w89rf242_txvga_old_mapping))
 				pctmp[i] = (u8)w89rf242_txvga_old_mapping[j-1][0];
 		}
 	}
-- 
1.7.0.4

