Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab0C2NId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 09:08:33 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42718 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab0C2NIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 09:08:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wQYhSoi0BOUq/njMHP6EV7y0cx04HLFGwwrKJ27xQ6mvFjJcuQjbFmKc/Xad0Z3fzR
         7S/W3WtWF7hLhUfbA1oZLm0p521qxDAh/22Lz9V2kRUJSu9zMUjM7ruoDwzobKCSpNBq
         QD6ii4JmtsTWZ+skjRaSc7m7tfUUpwqR6Nw3Q=
From: Kenji Toyama <kenji.toyama@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Kenji Toyama <kenji.toyama@gmail.com>
Subject: [PATCH 9/9] staging: vt6656: int.c: Fixed Coding Style issues
Date: Tue, 30 Mar 2010 00:28:19 +1100
Message-Id: <1269869299-18586-1-git-send-email-kenji.toyama@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed almost all the issues given by checkpatch.pl except for one warning about an 81 character line, which cannot really be decomposed (the code is a bit too nested there).
Signed-off-by: Daniel Kenji Toyama <kenji.toyama@gmail.com>
---
 drivers/staging/vt6656/int.c |  250 ++++++++++++++++++++++++------------------
 1 files changed, 141 insertions(+), 109 deletions(-)

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 35053be..824c67d 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -41,8 +41,8 @@
 #include "usbpipe.h"
 
 /*---------------------  Static Definitions -------------------------*/
-//static int          msglevel                =MSG_LEVEL_DEBUG;
-static int          msglevel                =MSG_LEVEL_INFO;
+/* static int msglevel = MSG_LEVEL_DEBUG; */
+static int msglevel = MSG_LEVEL_INFO;
 
 
 /*---------------------  Static Classes  ----------------------------*/
@@ -74,120 +74,152 @@ static int          msglevel                =MSG_LEVEL_INFO;
  *
  *  Notes:
  *
- *  USB reads are by nature 'Blocking', and when in a read, the device looks like it's
- *  in a 'stall' condition, so we deliberately time out every second if we've gotten no data
+ *  USB reads are by nature 'Blocking', and when in a read, the device looks
+ *  like it's in a 'stall' condition, so we deliberately time out every second
+ *  if we've gotten no data
  *
 -*/
 VOID
-INTvWorkItem(
-    PVOID Context
-    )
+INTvWorkItem(PVOID Context)
 {
-    PSDevice pDevice = (PSDevice) Context;
-    NTSTATUS ntStatus;
+	PSDevice pDevice = (PSDevice) Context;
+	NTSTATUS ntStatus;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Interrupt Polling Thread\n");
-
-    spin_lock_irq(&pDevice->lock);
-    if (pDevice->fKillEventPollingThread != TRUE) {
-        ntStatus = PIPEnsInterruptRead(pDevice);
-    }
-    spin_unlock_irq(&pDevice->lock);
-
- }
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Interrupt Polling Thread\n");
 
+	spin_lock_irq(&pDevice->lock);
+	if (pDevice->fKillEventPollingThread != TRUE)
+		ntStatus = PIPEnsInterruptRead(pDevice);
+	spin_unlock_irq(&pDevice->lock);
+}
 
 NTSTATUS
-INTnsProcessData(
-    IN  PSDevice pDevice
-    )
+INTnsProcessData(IN  PSDevice pDevice)
 {
-    NTSTATUS        status = STATUS_SUCCESS;
-    PSINTData       pINTData;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    struct net_device_stats* pStats = &pDevice->stats;
-
-
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsInterruptProcessData\n");
-
-    pINTData = (PSINTData) pDevice->intBuf.pDataBuf;
-    if (pINTData->byTSR0 & TSR_VALID) {
-        STAvUpdateTDStatCounter (&(pDevice->scStatistic), (BYTE) (pINTData->byPkt0 & 0x0F), (BYTE) (pINTData->byPkt0>>4), pINTData->byTSR0);
-        BSSvUpdateNodeTxCounter (pDevice, &(pDevice->scStatistic),  pINTData->byTSR0, pINTData->byPkt0);
-        //DBG_PRN_GRP01(("TSR0 %02x\n", pINTData->byTSR0));
-    }
-    if (pINTData->byTSR1 & TSR_VALID) {
-        STAvUpdateTDStatCounter (&(pDevice->scStatistic), (BYTE) (pINTData->byPkt1 & 0x0F), (BYTE) (pINTData->byPkt1>>4), pINTData->byTSR1);
-        BSSvUpdateNodeTxCounter (pDevice, &(pDevice->scStatistic),  pINTData->byTSR1, pINTData->byPkt1);
-        //DBG_PRN_GRP01(("TSR1 %02x\n", pINTData->byTSR1));
-    }
-    if (pINTData->byTSR2 & TSR_VALID) {
-        STAvUpdateTDStatCounter (&(pDevice->scStatistic), (BYTE) (pINTData->byPkt2 & 0x0F), (BYTE) (pINTData->byPkt2>>4), pINTData->byTSR2);
-        BSSvUpdateNodeTxCounter (pDevice, &(pDevice->scStatistic),  pINTData->byTSR2, pINTData->byPkt2);
-        //DBG_PRN_GRP01(("TSR2 %02x\n", pINTData->byTSR2));
-    }
-    if (pINTData->byTSR3 & TSR_VALID) {
-        STAvUpdateTDStatCounter (&(pDevice->scStatistic), (BYTE) (pINTData->byPkt3 & 0x0F), (BYTE) (pINTData->byPkt3>>4), pINTData->byTSR3);
-        BSSvUpdateNodeTxCounter (pDevice, &(pDevice->scStatistic),  pINTData->byTSR3, pINTData->byPkt3);
-        //DBG_PRN_GRP01(("TSR3 %02x\n", pINTData->byTSR3));
-    }
-    if ( pINTData->byISR0 != 0 ) {
-        if (pINTData->byISR0 & ISR_BNTX) {
-
-            if (pDevice->eOPMode == OP_MODE_AP) {
-                if(pMgmt->byDTIMCount > 0) {
-                    pMgmt->byDTIMCount --;
-                    pMgmt->sNodeDBTable[0].bRxPSPoll = FALSE;
-                } else if(pMgmt->byDTIMCount == 0) {
-                    // check if mutltcast tx bufferring
-                    pMgmt->byDTIMCount = pMgmt->byDTIMPeriod - 1;
-                    pMgmt->sNodeDBTable[0].bRxPSPoll = TRUE;
-                    if (pMgmt->sNodeDBTable[0].bPSEnable) {
-                        bScheduleCommand((HANDLE)pDevice, WLAN_CMD_RX_PSPOLL, NULL);
-                    }
-                }
-                bScheduleCommand((HANDLE)pDevice, WLAN_CMD_BECON_SEND, NULL);
-            } // if (pDevice->eOPMode == OP_MODE_AP)
-
-            pDevice->bBeaconSent = TRUE;
-        } else {
-            pDevice->bBeaconSent = FALSE;
-        }
-        if (pINTData->byISR0 & ISR_TBTT) {
-            if ( pDevice->bEnablePSMode ) {
-                bScheduleCommand((HANDLE) pDevice, WLAN_CMD_TBTT_WAKEUP, NULL);
-            }
-            if ( pDevice->bChannelSwitch ) {
-                pDevice->byChannelSwitchCount--;
-                if ( pDevice->byChannelSwitchCount == 0 ) {
-                    bScheduleCommand((HANDLE) pDevice, WLAN_CMD_11H_CHSW, NULL);
-                }
-            }
-        }
-        LODWORD(pDevice->qwCurrTSF) = pINTData->dwLoTSF;
-        HIDWORD(pDevice->qwCurrTSF) = pINTData->dwHiTSF;
-        //DBG_PRN_GRP01(("ISR0 = %02x ,LoTsf =  %08x,HiTsf =  %08x\n", pINTData->byISR0, pINTData->dwLoTSF,pINTData->dwHiTSF));
-
-        STAvUpdate802_11Counter(&pDevice->s802_11Counter, &pDevice->scStatistic, pINTData->byRTSSuccess,
-                                pINTData->byRTSFail, pINTData->byACKFail, pINTData->byFCSErr );
-        STAvUpdateIsrStatCounter(&pDevice->scStatistic, pINTData->byISR0, pINTData->byISR1);
-
-    }
-
-    if ( pINTData->byISR1 != 0 ) {
-        if (pINTData->byISR1 & ISR_GPIO3) {
-            bScheduleCommand((HANDLE) pDevice, WLAN_CMD_RADIO, NULL);
-        }
-    }
-    pDevice->intBuf.uDataLen = 0;
-    pDevice->intBuf.bInUse = FALSE;
-
-    pStats->tx_packets = pDevice->scStatistic.ullTsrOK;
-    pStats->tx_bytes = pDevice->scStatistic.ullTxDirectedBytes +
-                       pDevice->scStatistic.ullTxMulticastBytes +
-                       pDevice->scStatistic.ullTxBroadcastBytes;
-    pStats->tx_errors = pDevice->scStatistic.dwTsrErr;
-    pStats->tx_dropped = pDevice->scStatistic.dwTsrErr;
-
-    return status;
+	NTSTATUS	status = STATUS_SUCCESS;
+	PSINTData	pINTData;
+	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
+	struct net_device_stats *pStats = &pDevice->stats;
+
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsInterruptProcessData\n");
+
+	pINTData = (PSINTData) pDevice->intBuf.pDataBuf;
+	if (pINTData->byTSR0 & TSR_VALID) {
+		STAvUpdateTDStatCounter(&(pDevice->scStatistic),
+					(BYTE) (pINTData->byPkt0 & 0x0F),
+					(BYTE) (pINTData->byPkt0>>4),
+					pINTData->byTSR0);
+		BSSvUpdateNodeTxCounter(pDevice,
+					&(pDevice->scStatistic),
+					pINTData->byTSR0,
+					pINTData->byPkt0);
+		/*DBG_PRN_GRP01(("TSR0 %02x\n", pINTData->byTSR0));*/
+	}
+	if (pINTData->byTSR1 & TSR_VALID) {
+		STAvUpdateTDStatCounter(&(pDevice->scStatistic),
+					(BYTE) (pINTData->byPkt1 & 0x0F),
+					(BYTE) (pINTData->byPkt1>>4),
+					pINTData->byTSR1);
+		BSSvUpdateNodeTxCounter(pDevice,
+					&(pDevice->scStatistic),
+					pINTData->byTSR1,
+					pINTData->byPkt1);
+		/*DBG_PRN_GRP01(("TSR1 %02x\n", pINTData->byTSR1));*/
+	}
+	if (pINTData->byTSR2 & TSR_VALID) {
+		STAvUpdateTDStatCounter(&(pDevice->scStatistic),
+					(BYTE) (pINTData->byPkt2 & 0x0F),
+					(BYTE) (pINTData->byPkt2>>4),
+					pINTData->byTSR2);
+		BSSvUpdateNodeTxCounter(pDevice,
+					&(pDevice->scStatistic),
+					pINTData->byTSR2,
+					pINTData->byPkt2);
+		/*DBG_PRN_GRP01(("TSR2 %02x\n", pINTData->byTSR2));*/
+	}
+	if (pINTData->byTSR3 & TSR_VALID) {
+		STAvUpdateTDStatCounter(&(pDevice->scStatistic),
+					(BYTE) (pINTData->byPkt3 & 0x0F),
+					(BYTE) (pINTData->byPkt3>>4),
+					pINTData->byTSR3);
+		BSSvUpdateNodeTxCounter(pDevice,
+					&(pDevice->scStatistic),
+					pINTData->byTSR3,
+					pINTData->byPkt3);
+		/*DBG_PRN_GRP01(("TSR3 %02x\n", pINTData->byTSR3));*/
+	}
+	if (pINTData->byISR0 != 0) {
+		if (pINTData->byISR0 & ISR_BNTX) {
+			if (pDevice->eOPMode == OP_MODE_AP) {
+				if (pMgmt->byDTIMCount > 0) {
+					pMgmt->byDTIMCount--;
+					pMgmt->sNodeDBTable[0].bRxPSPoll =
+						FALSE;
+				} else if (pMgmt->byDTIMCount == 0) {
+					/* check if mutltcast tx bufferring */
+					pMgmt->byDTIMCount =
+						pMgmt->byDTIMPeriod-1;
+					pMgmt->sNodeDBTable[0].bRxPSPoll = TRUE;
+					if (pMgmt->sNodeDBTable[0].bPSEnable)
+						bScheduleCommand((HANDLE)pDevice,
+							WLAN_CMD_RX_PSPOLL,
+							NULL);
+				}
+				bScheduleCommand((HANDLE)pDevice,
+						WLAN_CMD_BECON_SEND,
+						NULL);
+			} /* if (pDevice->eOPMode == OP_MODE_AP) */
+		pDevice->bBeaconSent = TRUE;
+		} else {
+			pDevice->bBeaconSent = FALSE;
+		}
+		if (pINTData->byISR0 & ISR_TBTT) {
+			if (pDevice->bEnablePSMode)
+				bScheduleCommand((HANDLE) pDevice,
+						WLAN_CMD_TBTT_WAKEUP,
+						NULL);
+			if (pDevice->bChannelSwitch) {
+				pDevice->byChannelSwitchCount--;
+				if (pDevice->byChannelSwitchCount == 0)
+					bScheduleCommand((HANDLE) pDevice,
+							WLAN_CMD_11H_CHSW,
+							NULL);
+			}
+		}
+		LODWORD(pDevice->qwCurrTSF) = pINTData->dwLoTSF;
+		HIDWORD(pDevice->qwCurrTSF) = pINTData->dwHiTSF;
+		/*DBG_PRN_GRP01(("ISR0 = %02x ,
+				LoTsf =  %08x,
+				HiTsf =  %08x\n",
+				pINTData->byISR0,
+				pINTData->dwLoTSF,
+				pINTData->dwHiTSF)); */
+
+		STAvUpdate802_11Counter(&pDevice->s802_11Counter,
+					&pDevice->scStatistic,
+					pINTData->byRTSSuccess,
+					pINTData->byRTSFail,
+					pINTData->byACKFail,
+					pINTData->byFCSErr);
+		STAvUpdateIsrStatCounter(&pDevice->scStatistic,
+					pINTData->byISR0,
+					pINTData->byISR1);
+	}
+
+	if (pINTData->byISR1 != 0)
+		if (pINTData->byISR1 & ISR_GPIO3)
+			bScheduleCommand((HANDLE) pDevice,
+					WLAN_CMD_RADIO,
+					NULL);
+	pDevice->intBuf.uDataLen = 0;
+	pDevice->intBuf.bInUse = FALSE;
+
+	pStats->tx_packets = pDevice->scStatistic.ullTsrOK;
+	pStats->tx_bytes = pDevice->scStatistic.ullTxDirectedBytes +
+			pDevice->scStatistic.ullTxMulticastBytes +
+			pDevice->scStatistic.ullTxBroadcastBytes;
+	pStats->tx_errors = pDevice->scStatistic.dwTsrErr;
+	pStats->tx_dropped = pDevice->scStatistic.dwTsrErr;
+
+	return status;
 }
-- 
1.6.3.3

