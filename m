Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934915Ab0EZXlC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:41:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56342 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933697Ab0EZXku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:40:50 -0400
From: Mike Sheldon <mike@mikeasoft.com>
To: greg@kroah.com, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Sheldon <mike@mikeasoft.com>
Subject: [PATCH 04/15] Staging: winbond: Replace printk usage with pr_info/pr_err
Date: Thu, 27 May 2010 00:39:41 +0100
Message-Id: <1274917192-16962-4-git-send-email-mike@mikeasoft.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
References: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches mds.c to replace printk usage (missing KERN_ levels) with appropriate pr_info and pr_err calls.

Signed-off-by: Mike Sheldon <mike@mikeasoft.com>
---
 drivers/staging/winbond/mds.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index 477dff4..c4b48c8 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -351,7 +351,7 @@ static void Mds_HeaderCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *
 
 	pDes->TxRate = ctmp1;
 	#ifdef _PE_TX_DUMP_
-	printk("Tx rate =%x\n", ctmp1);
+	pr_info("Tx rate = %x\n", ctmp1);
 	#endif
 
 	pT01->T01_modulation_type = (ctmp1%3) ? 0 : 1;
@@ -419,7 +419,7 @@ Mds_Tx(struct wbsoft_priv *adapter)
 		FillIndex = pMds->TxFillIndex;
 		if (pMds->TxOwner[FillIndex]) { /* Is owned by software 0:Yes 1:No */
 #ifdef _PE_TX_DUMP_
-			printk("[Mds_Tx] Tx Owner is H/W.\n");
+			pr_info("[Mds_Tx] Tx Owner is H/W.\n");
 #endif
 			break;
 		}
@@ -438,7 +438,7 @@ Mds_Tx(struct wbsoft_priv *adapter)
 			FragmentCount = PacketSize/FragmentThreshold + 1;
 			stmp = PacketSize + FragmentCount*32 + 8; /* 931130.5.c 8:MIC */
 			if ((XmitBufSize + stmp) >= MAX_USB_TX_BUFFER) {
-				printk("[Mds_Tx] Excess max tx buffer.\n");
+				pr_err("[Mds_Tx] Excess max tx buffer.\n");
 				break; /* buffer is not enough */
 			}
 
@@ -465,7 +465,7 @@ Mds_Tx(struct wbsoft_priv *adapter)
 			/* For speed up Key setting */
 			if (pTxDes->EapFix) {
 #ifdef _PE_TX_DUMP_
-				printk("35: EPA 4th frame detected. Size = %d\n", PacketSize);
+				pr_info("35: EPA 4th frame detected. Size = %d\n", PacketSize);
 #endif
 				pHwData->IsKeyPreSet = 1;
 			}
@@ -556,7 +556,7 @@ Mds_SendComplete(struct wbsoft_priv *adapter, PT02_DESCRIPTOR pT02)
 				else
 					pHwData->tx_retry_count[7] += RetryCount;
 				#ifdef _PE_STATE_DUMP_
-				printk("dto_tx_retry_count =%d\n", pHwData->dto_tx_retry_count);
+				pr_info("dto_tx_retry_count = %d\n", pHwData->dto_tx_retry_count);
 				#endif
 				MTO_SetTxCount(adapter, TxRate, RetryCount);
 			}
-- 
1.7.0.4

