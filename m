Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab2FXUMQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 16:12:16 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10193 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2FXUMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 16:12:14 -0400
Date: Sun, 24 Jun 2012 22:12:12 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Forest Bond <forest@alittletooquiet.net>, Jiri Kosina <trivial@kernel.org>,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH] Staging: vt6656: int.c: A few trivial style cleanups
Message-ID: <alpine.LNX.2.00.1206242209570.30361@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed a pointless cast + some whitespace cleanups.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/int.c | 52 ++++++++++++++++++++------------------------
 drivers/staging/vt6656/int.h | 43 ++++++++++++++++++------------------
 2 files changed, 45 insertions(+), 50 deletions(-)

 Note: I don't have hardware to test. Compile tested only.

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 0a11423..35214b4 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -41,9 +41,7 @@
 #include "usbpipe.h"
 
 /*---------------------  Static Definitions -------------------------*/
-/* static int msglevel = MSG_LEVEL_DEBUG; */
-static int msglevel = MSG_LEVEL_INFO;
-
+static int msglevel = MSG_LEVEL_INFO; /* MSG_LEVEL_DEBUG */
 
 /*---------------------  Static Classes  ----------------------------*/
 
@@ -53,10 +51,8 @@ static int msglevel = MSG_LEVEL_INFO;
 
 /*---------------------  Export Variables  --------------------------*/
 
-
 /*---------------------  Export Functions  --------------------------*/
 
-
 /*+
  *
  *  Function:   InterruptPollingThread
@@ -81,7 +77,7 @@ static int msglevel = MSG_LEVEL_INFO;
 -*/
 void INTvWorkItem(void *Context)
 {
-	PSDevice pDevice = (PSDevice) Context;
+	PSDevice pDevice = Context;
 	int ntStatus;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Interrupt Polling Thread\n");
@@ -94,17 +90,17 @@ void INTvWorkItem(void *Context)
 
 void INTnsProcessData(PSDevice pDevice)
 {
-	PSINTData	pINTData;
-	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
+	PSINTData pINTData;
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 	struct net_device_stats *pStats = &pDevice->stats;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsInterruptProcessData\n");
 
-	pINTData = (PSINTData) pDevice->intBuf.pDataBuf;
+	pINTData = (PSINTData)pDevice->intBuf.pDataBuf;
 	if (pINTData->byTSR0 & TSR_VALID) {
 		STAvUpdateTDStatCounter(&(pDevice->scStatistic),
-					(BYTE) (pINTData->byPkt0 & 0x0F),
-					(BYTE) (pINTData->byPkt0>>4),
+					(BYTE)(pINTData->byPkt0 & 0x0F),
+					(BYTE)(pINTData->byPkt0 >> 4),
 					pINTData->byTSR0);
 		BSSvUpdateNodeTxCounter(pDevice,
 					&(pDevice->scStatistic),
@@ -114,8 +110,8 @@ void INTnsProcessData(PSDevice pDevice)
 	}
 	if (pINTData->byTSR1 & TSR_VALID) {
 		STAvUpdateTDStatCounter(&(pDevice->scStatistic),
-					(BYTE) (pINTData->byPkt1 & 0x0F),
-					(BYTE) (pINTData->byPkt1>>4),
+					(BYTE)(pINTData->byPkt1 & 0x0F),
+					(BYTE)(pINTData->byPkt1 >> 4),
 					pINTData->byTSR1);
 		BSSvUpdateNodeTxCounter(pDevice,
 					&(pDevice->scStatistic),
@@ -125,8 +121,8 @@ void INTnsProcessData(PSDevice pDevice)
 	}
 	if (pINTData->byTSR2 & TSR_VALID) {
 		STAvUpdateTDStatCounter(&(pDevice->scStatistic),
-					(BYTE) (pINTData->byPkt2 & 0x0F),
-					(BYTE) (pINTData->byPkt2>>4),
+					(BYTE)(pINTData->byPkt2 & 0x0F),
+					(BYTE)(pINTData->byPkt2 >> 4),
 					pINTData->byTSR2);
 		BSSvUpdateNodeTxCounter(pDevice,
 					&(pDevice->scStatistic),
@@ -136,8 +132,8 @@ void INTnsProcessData(PSDevice pDevice)
 	}
 	if (pINTData->byTSR3 & TSR_VALID) {
 		STAvUpdateTDStatCounter(&(pDevice->scStatistic),
-					(BYTE) (pINTData->byPkt3 & 0x0F),
-					(BYTE) (pINTData->byPkt3>>4),
+					(BYTE)(pINTData->byPkt3 & 0x0F),
+					(BYTE)(pINTData->byPkt3 >> 4),
 					pINTData->byTSR3);
 		BSSvUpdateNodeTxCounter(pDevice,
 					&(pDevice->scStatistic),
@@ -158,34 +154,34 @@ void INTnsProcessData(PSDevice pDevice)
 						pMgmt->byDTIMPeriod-1;
 					pMgmt->sNodeDBTable[0].bRxPSPoll = TRUE;
 					if (pMgmt->sNodeDBTable[0].bPSEnable)
-						bScheduleCommand((void *) pDevice,
-								 WLAN_CMD_RX_PSPOLL,
-								 NULL);
+						bScheduleCommand((void *)pDevice,
+								WLAN_CMD_RX_PSPOLL,
+								NULL);
 				}
-				bScheduleCommand((void *) pDevice,
+				bScheduleCommand((void *)pDevice,
 						WLAN_CMD_BECON_SEND,
 						NULL);
 			} /* if (pDevice->eOPMode == OP_MODE_AP) */
-		pDevice->bBeaconSent = TRUE;
+			pDevice->bBeaconSent = TRUE;
 		} else {
 			pDevice->bBeaconSent = FALSE;
 		}
 		if (pINTData->byISR0 & ISR_TBTT) {
 			if (pDevice->bEnablePSMode)
-				bScheduleCommand((void *) pDevice,
+				bScheduleCommand((void *)pDevice,
 						WLAN_CMD_TBTT_WAKEUP,
 						NULL);
 			if (pDevice->bChannelSwitch) {
 				pDevice->byChannelSwitchCount--;
 				if (pDevice->byChannelSwitchCount == 0)
-					bScheduleCommand((void *) pDevice,
+					bScheduleCommand((void *)pDevice,
 							WLAN_CMD_11H_CHSW,
 							NULL);
 			}
 		}
 		LODWORD(pDevice->qwCurrTSF) = pINTData->dwLoTSF;
 		HIDWORD(pDevice->qwCurrTSF) = pINTData->dwHiTSF;
-		/*DBG_PRN_GRP01(("ISR0 = %02x ,
+		/*DBG_PRN_GRP01(("ISR0 = %02x,
 				LoTsf =  %08x,
 				HiTsf =  %08x\n",
 				pINTData->byISR0,
@@ -205,7 +201,7 @@ void INTnsProcessData(PSDevice pDevice)
 
 	if (pINTData->byISR1 != 0)
 		if (pINTData->byISR1 & ISR_GPIO3)
-			bScheduleCommand((void *) pDevice,
+			bScheduleCommand((void *)pDevice,
 					WLAN_CMD_RADIO,
 					NULL);
 	pDevice->intBuf.uDataLen = 0;
@@ -213,8 +209,8 @@ void INTnsProcessData(PSDevice pDevice)
 
 	pStats->tx_packets = pDevice->scStatistic.ullTsrOK;
 	pStats->tx_bytes = pDevice->scStatistic.ullTxDirectedBytes +
-			pDevice->scStatistic.ullTxMulticastBytes +
-			pDevice->scStatistic.ullTxBroadcastBytes;
+		pDevice->scStatistic.ullTxMulticastBytes +
+		pDevice->scStatistic.ullTxBroadcastBytes;
 	pStats->tx_errors = pDevice->scStatistic.dwTsrErr;
 	pStats->tx_dropped = pDevice->scStatistic.dwTsrErr;
 }
diff --git a/drivers/staging/vt6656/int.h b/drivers/staging/vt6656/int.h
index a5d96b9..892c27e 100644
--- a/drivers/staging/vt6656/int.h
+++ b/drivers/staging/vt6656/int.h
@@ -36,31 +36,30 @@
 /*---------------------  Export Definitions -------------------------*/
 #pragma pack(1)
 typedef struct tagSINTData {
-    BYTE    byTSR0;
-    BYTE    byPkt0;
-    WORD    wTime0;
-    BYTE    byTSR1;
-    BYTE    byPkt1;
-    WORD    wTime1;
-    BYTE    byTSR2;
-    BYTE    byPkt2;
-    WORD    wTime2;
-    BYTE    byTSR3;
-    BYTE    byPkt3;
-    WORD    wTime3;
-    DWORD   dwLoTSF;
-    DWORD   dwHiTSF;
-    BYTE    byISR0;
-    BYTE    byISR1;
-    BYTE    byRTSSuccess;
-    BYTE    byRTSFail;
-    BYTE    byACKFail;
-    BYTE    byFCSErr;
-    BYTE    abySW[2];
+	BYTE  byTSR0;
+	BYTE  byPkt0;
+	WORD  wTime0;
+	BYTE  byTSR1;
+	BYTE  byPkt1;
+	WORD  wTime1;
+	BYTE  byTSR2;
+	BYTE  byPkt2;
+	WORD  wTime2;
+	BYTE  byTSR3;
+	BYTE  byPkt3;
+	WORD  wTime3;
+	DWORD dwLoTSF;
+	DWORD dwHiTSF;
+	BYTE  byISR0;
+	BYTE  byISR1;
+	BYTE  byRTSSuccess;
+	BYTE  byRTSFail;
+	BYTE  byACKFail;
+	BYTE  byFCSErr;
+	BYTE  abySW[2];
 } __attribute__ ((__packed__))
 SINTData, *PSINTData;
 
-
 /*---------------------  Export Classes  ----------------------------*/
 
 /*---------------------  Export Variables  --------------------------*/
-- 
1.7.11


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

