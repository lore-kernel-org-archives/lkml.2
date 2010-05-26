Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935033Ab0EZXmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:42:11 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:33626 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934955Ab0EZXlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:41:18 -0400
From: Mike Sheldon <mike@mikeasoft.com>
To: greg@kroah.com, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Sheldon <mike@mikeasoft.com>
Subject: [PATCH 14/15] Staging: winbond: Replace printk usage with pr_info
Date: Thu, 27 May 2010 00:39:51 +0100
Message-Id: <1274917192-16962-14-git-send-email-mike@mikeasoft.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
References: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches reg.c to replace printk usage (missing KERN_ levels) with pr_info.

Signed-off-by: Mike Sheldon <mike@mikeasoft.com>
---
 drivers/staging/winbond/reg.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index d9a8128..ba2e705 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -1011,7 +1011,7 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 		/* Start to fill RF parameters, PLL_ON should be pulled low. */
 		Wb35Reg_WriteSync(pHwData, 0x03dc, 0x00000000);
 		#ifdef _PE_STATE_DUMP_
-		printk("* PLL_ON    low\n");
+		pr_info("* PLL_ON    low\n");
 		#endif
 		number = sizeof(al7230_rf_data_24) / sizeof(al7230_rf_data_24[0]);
 		Set_ChanIndep_RfData_al7230_24(pHwData, pltmp, number);
@@ -1099,7 +1099,7 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 		/* RF parameters have filled completely, PLL_ON should be pulled high */
 		Wb35Reg_WriteSync(pHwData, 0x03dc, 0x00000080);
 		#ifdef _PE_STATE_DUMP_
-		printk("* PLL_ON    high\n");
+		pr_info("* PLL_ON    high\n");
 		#endif
 
 		/* 2.4GHz */
@@ -1116,7 +1116,7 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 		/* 5GHz */
 		Wb35Reg_WriteSync(pHwData, 0x03dc, 0x00000000);
 		#ifdef _PE_STATE_DUMP_
-		printk("* PLL_ON    low\n");
+		pr_info("* PLL_ON    low\n");
 		#endif
 
 		number = sizeof(al7230_rf_data_50) / sizeof(al7230_rf_data_50[0]);
@@ -1128,7 +1128,7 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 
 		Wb35Reg_WriteSync(pHwData, 0x03dc, 0x00000080);
 		#ifdef _PE_STATE_DUMP_
-		printk("* PLL_ON    high\n");
+		pr_info("* PLL_ON    high\n");
 		#endif
 
 		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | 0x9ABA8F;
@@ -1796,7 +1796,7 @@ void RFSynthesizer_SwitchingChannel(struct hw_data *pHwData,  struct chan_info C
 			/* Write to register. number must less and equal than 16 */
 			Wb35Reg_BurstWrite(pHwData, 0x0864, pltmp, number, NO_INCREMENT);
 			#ifdef _PE_STATE_DUMP_
-			printk("Band changed\n");
+			pr_info("Band changed\n");
 			#endif
 		}
 
@@ -2338,9 +2338,9 @@ void EEPROMTxVgaAdjust(struct hw_data *pHwData)
 	}
 
 	#ifdef _PE_STATE_DUMP_
-	printk(" TxVgaFor24 :\n");
+	pr_info(" TxVgaFor24 :\n");
 	DataDmp((u8 *)pHwData->TxVgaFor24, 14 , 0);
-	printk(" TxVgaFor50 :\n");
+	pr_info(" TxVgaFor50 :\n");
 	DataDmp((u8 *)pHwData->TxVgaFor50, 70 , 0);
 	#endif
 }
-- 
1.7.0.4

