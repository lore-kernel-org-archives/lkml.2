Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab1LACcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 21:32:13 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36895 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab1LACcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 21:32:12 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org
Subject: [PATCH 3/4] staging: vt6656: datarate.c: Remove unneeded comments
Date: Thu,  1 Dec 2011 00:31:57 +0000
Message-Id: <1322699517-19721-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove some unneeded comments and make a atribution more simple.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Forest Bond <forest@alittletooquiet.net>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/vt6656/datarate.c |   40 ++++--------------------------------
 drivers/staging/vt6656/datarate.h |   14 -------------
 drivers/staging/vt6656/desc.h     |   18 ----------------
 3 files changed, 5 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/vt6656/datarate.c b/drivers/staging/vt6656/datarate.c
index 5c2719f..0a78914 100644
--- a/drivers/staging/vt6656/datarate.c
+++ b/drivers/staging/vt6656/datarate.c
@@ -44,17 +44,6 @@
 #include "srom.h"
 #include "rf.h"
 
-/*---------------------  Static Definitions -------------------------*/
-
-
-
-
-/*---------------------  Static Classes  ----------------------------*/
-
-
-
-/*---------------------  Static Variables  --------------------------*/
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 static int          msglevel                =MSG_LEVEL_INFO;
 const BYTE acbyIERate[MAX_RATE] =
 {0x02, 0x04, 0x0B, 0x16, 0x0C, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C};
@@ -63,27 +52,15 @@ const BYTE acbyIERate[MAX_RATE] =
 #define AUTORATE_TXFAIL_CNT     0x0064
 #define AUTORATE_TIMEOUT        10
 
-/*---------------------  Static Functions  --------------------------*/
-
-void s_vResetCounter(PKnownNodeDB psNodeDBTable);
-
 void s_vResetCounter(PKnownNodeDB psNodeDBTable)
 {
-    BYTE            ii;
+	BYTE ii;
 
-    // clear statistic counter for auto_rate
-    for (ii = 0; ii <= MAX_RATE; ii++) {
-        psNodeDBTable->uTxOk[ii] = 0;
-        psNodeDBTable->uTxFail[ii] = 0;
-    }
+	/* clear statistic counter for auto_rate */
+	for (ii = 0; ii <= MAX_RATE; ii++)
+		psNodeDBTable->uTxOk[ii] = psNodeDBTable->uTxFail[ii] = 0;
 }
 
-/*---------------------  Export Variables  --------------------------*/
-
-
-/*---------------------  Export Functions  --------------------------*/
-
-
 /*+
  *
  * Description:
@@ -260,9 +237,8 @@ unsigned int  uRateLen;
             if (byRate > byHighSuppRate)
                 byHighSuppRate = byRate;
             *pwSuppRate |= (1<<RATEwGetRateIdx(byRate));
-            //DBG_PRN_GRP09(("ParseMaxRate : HighSuppRate: %d, %X\n", RATEwGetRateIdx(byRate), byRate));
         }
-    } //if(pItemExtRates != NULL)
+    }
 
     if ((pDevice->byPacketType == PK_TYPE_11GB)
 	&& CARDbIsOFDMinBasicRate((void *)pDevice)) {
@@ -278,11 +254,8 @@ unsigned int  uRateLen;
        *pwMaxBasicRate = pDevice->byTopOFDMBasicRate;
     if (wOldBasicRate != pDevice->wBasicRate)
 	CARDvSetRSPINF((void *)pDevice, pDevice->byBBType);
-
-     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Exit ParseMaxRate\n");
 }
 
-
 /*+
  *
  * Routine Description:
@@ -384,10 +357,7 @@ DWORD           dwTxDiff = 0;
         if (psNodeDBTable->wTxDataRate <= RATE_11M)
             psNodeDBTable->wTxDataRate = RATE_6M;
     }
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"uTxOk[MAX_RATE] %d, uTxFail[MAX_RATE]:%d\n",(int)psNodeDBTable->uTxOk[MAX_RATE], (int)psNodeDBTable->uTxFail[MAX_RATE]);
     s_vResetCounter(psNodeDBTable);
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Rate: %d, U:%d, D:%d\n", (int)psNodeDBTable->wTxDataRate, (int)wIdxUpRate, (int)wIdxDownRate);
-    return;
 }
 
 /*+
diff --git a/drivers/staging/vt6656/datarate.h b/drivers/staging/vt6656/datarate.h
index c6f5163..f094ed4 100644
--- a/drivers/staging/vt6656/datarate.h
+++ b/drivers/staging/vt6656/datarate.h
@@ -29,8 +29,6 @@
 #ifndef __DATARATE_H__
 #define __DATARATE_H__
 
-/*---------------------  Export Definitions -------------------------*/
-
 #define FALLBACK_PKT_COLLECT_TR_H  50   // pkts
 #define FALLBACK_PKT_COLLECT_TR_L  10   // pkts
 #define FALLBACK_POLL_SECOND       5    // 5 sec
@@ -57,18 +55,6 @@
 #define RATE_AUTO      12
 #define MAX_RATE       12
 
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-
-/*---------------------  Export Types  ------------------------------*/
-
-
-/*---------------------  Export Functions  --------------------------*/
-
-
-
 void
 RATEvParseMaxRate(
      void *pDeviceHandler,
diff --git a/drivers/staging/vt6656/desc.h b/drivers/staging/vt6656/desc.h
index 767112b..5389984 100644
--- a/drivers/staging/vt6656/desc.h
+++ b/drivers/staging/vt6656/desc.h
@@ -36,8 +36,6 @@
 #include "ttype.h"
 #include "tether.h"
 
-/*---------------------  Export Definitions -------------------------*/
-
 // max transmit or receive buffer size
 #define CB_MAX_BUF_SIZE     2900U       // max buffer size
                                         // NOTE: must be multiple of 4
@@ -120,17 +118,11 @@
 #define FRAGCTL_TKIP        0x0200 // 0000 0010 0000 0000
 #define FRAGCTL_LEGACY      0x0100 // 0000 0001 0000 0000
 #define FRAGCTL_NONENCRYPT  0x0000 // 0000 0000 0000 0000
-//#define FRAGCTL_AC3         0x000C // 0000 0000 0000 1100
-//#define FRAGCTL_AC2         0x0008 // 0000 0000 0000 1000
-//#define FRAGCTL_AC1         0x0004 // 0000 0000 0000 0100
-//#define FRAGCTL_AC0         0x0000 // 0000 0000 0000 0000
 #define FRAGCTL_ENDFRAG     0x0003 // 0000 0000 0000 0011
 #define FRAGCTL_MIDFRAG     0x0002 // 0000 0000 0000 0010
 #define FRAGCTL_STAFRAG     0x0001 // 0000 0000 0000 0001
 #define FRAGCTL_NONFRAG     0x0000 // 0000 0000 0000 0000
 
-//#define TYPE_AC0DMA     0
-//#define TYPE_TXDMA0     1
 #define TYPE_TXDMA0     0
 #define TYPE_AC0DMA     1
 #define TYPE_ATIMDMA    2
@@ -147,9 +139,6 @@
 #define TD_FLAGS_NETIF_SKB               0x01       // check if need release skb
 #define TD_FLAGS_PRIV_SKB                0x02       // check if called from private skb(hostap)
 #define TD_FLAGS_PS_RETRY                0x04       // check if PS STA frame re-transmit
-//#define TD_FLAGS_NETIF_SKB                0x04
-
-/*---------------------  Export Types  ------------------------------*/
 
 //
 // RsvTime buffer header
@@ -421,12 +410,5 @@ typedef struct tagSKeyEntry {
     DWORD dwKey4[4];
 } __attribute__ ((__packed__))
 SKeyEntry;
-/*---------------------  Export Macros ------------------------------*/
-
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
 
 #endif /* __DESC_H__ */
-- 
1.7.4.4

