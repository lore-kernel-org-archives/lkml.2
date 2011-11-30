Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab1K3CUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:20:19 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40947 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab1K3CUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:20:15 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: gregkh@suse.de
Cc: forest@alittletooquiet.net, driver@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH 4/5] staging: vt6656: baseband.c: Remove commented code
Date: Wed, 30 Nov 2011 00:19:25 -0200
Message-Id: <1322619565-10178-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a lot of commented code, and some return calls of
void functions.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>

Cc: Greg kroah-Hartman <gregkh@suse.de>
Cc: Forest Bond <forest@alittletooquiet.net>
Cc: driver@driverdev.osuosl.org
---
 drivers/staging/vt6656/baseband.c |    2 -
 drivers/staging/vt6656/bssdb.c    |  100 +-----------------------------------
 2 files changed, 3 insertions(+), 99 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 7da57b8..acba315 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1558,7 +1558,6 @@ void TimerSQ3CallBack(void *hDeviceContext)
 
 
     spin_unlock_irq(&pDevice->lock);
-    return;
 }
 
 
@@ -1606,7 +1605,6 @@ void TimerSQ3Tmax3CallBack(void *hDeviceContext)
     add_timer(&pDevice->TimerSQ3Tmax1);
 
     spin_unlock_irq(&pDevice->lock);
-    return;
 }
 
 void
diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index af006df..be54b4a 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -216,26 +216,6 @@ PKnownBSS BSSpSearchBSSList(void *hDeviceContext,
                         continue;
                     }
                 }
-/*
-                if (pMgmt->eAuthenMode < WMAC_AUTH_WPA) {
-                    if (pCurrBSS->bWPAValid == TRUE) {
-                        // WPA AP will reject connection of station without WPA enable.
-                        continue;
-                    }
-                } else if ((pMgmt->eAuthenMode == WMAC_AUTH_WPA) ||
-                           (pMgmt->eAuthenMode == WMAC_AUTH_WPAPSK)) {
-                    if (pCurrBSS->bWPAValid == FALSE) {
-                        // station with WPA enable can't join NonWPA AP.
-                        continue;
-                    }
-                } else if ((pMgmt->eAuthenMode == WMAC_AUTH_WPA2) ||
-                           (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK)) {
-                    if (pCurrBSS->bWPA2Valid == FALSE) {
-                        // station with WPA2 enable can't join NonWPA2 AP.
-                        continue;
-                    }
-                }
-*/
 
         pMgmt->pSameBSS[jj].uChannel = pCurrBSS->uChannel;
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BSSpSearchBSSList pSelect1[%02X %02X %02X-%02X %02X %02X]\n",*pCurrBSS->abyBSSID,*(pCurrBSS->abyBSSID+1),*(pCurrBSS->abyBSSID+2),*(pCurrBSS->abyBSSID+3),*(pCurrBSS->abyBSSID+4),*(pCurrBSS->abyBSSID+5));
@@ -300,18 +280,11 @@ void BSSvClearBSSList(void *hDeviceContext, BOOL bKeepCurrBSSID)
                 continue;
             }
         }
-/*
-        if ((pMgmt->sBSSList[ii].bActive) && (pMgmt->sBSSList[ii].uClearCount < BSS_CLEAR_COUNT)) {
-             pMgmt->sBSSList[ii].uClearCount ++;
-             continue;
-        }
-*/
-        pMgmt->sBSSList[ii].bActive = FALSE;
+
+	pMgmt->sBSSList[ii].bActive = FALSE;
         memset(&pMgmt->sBSSList[ii], 0, sizeof(KnownBSS));
     }
     BSSvClearAnyBSSJoinRecord(pDevice);
-
-    return;
 }
 
 
@@ -524,46 +497,6 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
             pBSSList->ldBmAverage[ii] = 0;
     }
 
-/*
-    if ((pIE_Country != NULL) &&
-        (pMgmt->b11hEnable == TRUE)) {
-        CARDvSetCountryInfo(pMgmt->pAdapter,
-                            pBSSList->eNetworkTypeInUse,
-                            pIE_Country);
-    }
-
-    if ((bParsingQuiet == TRUE) && (pIE_Quiet != NULL)) {
-        if ((((PWLAN_IE_QUIET)pIE_Quiet)->len == 8) &&
-            (((PWLAN_IE_QUIET)pIE_Quiet)->byQuietCount != 0)) {
-            // valid EID
-            if (pQuiet == NULL) {
-                pQuiet = (PWLAN_IE_QUIET)pIE_Quiet;
-                CARDbSetQuiet(  pMgmt->pAdapter,
-                                TRUE,
-                                pQuiet->byQuietCount,
-                                pQuiet->byQuietPeriod,
-                                *((PWORD)pQuiet->abyQuietDuration),
-                                *((PWORD)pQuiet->abyQuietOffset)
-                                );
-            } else {
-                pQuiet = (PWLAN_IE_QUIET)pIE_Quiet;
-                CARDbSetQuiet(  pMgmt->pAdapter,
-                                FALSE,
-                                pQuiet->byQuietCount,
-                                pQuiet->byQuietPeriod,
-                                *((PWORD)pQuiet->abyQuietDuration),
-                                *((PWORD)pQuiet->abyQuietOffset)
-                                );
-            }
-        }
-    }
-
-    if ((bParsingQuiet == TRUE) &&
-        (pQuiet != NULL)) {
-        CARDbStartQuiet(pMgmt->pAdapter);
-    }
-*/
-
     pBSSList->uIELength = uIELength;
     if (pBSSList->uIELength > WLAN_BEACON_FR_MAXLEN)
         pBSSList->uIELength = WLAN_BEACON_FR_MAXLEN;
@@ -609,8 +542,6 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
     PSRxMgmtPacket  pRxPacket = (PSRxMgmtPacket)pRxPacketContext;
     signed long            ldBm, ldBmSum;
     BOOL            bParsingQuiet = FALSE;
-  //  BYTE            abyTmpSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
-
 
     if (pBSSList == NULL)
         return FALSE;
@@ -622,7 +553,6 @@ BOOL BSSbUpdateToBSSList(void *hDeviceContext,
     pBSSList->wCapInfo = cpu_to_le16(wCapInfo);
     pBSSList->uClearCount = 0;
     pBSSList->uChannel = byCurrChannel;
-//    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BSSbUpdateToBSSList: pBSSList->uChannel: %d\n", pBSSList->uChannel);
 
     if (pSSID->len > WLAN_SSID_MAXLEN)
         pSSID->len = WLAN_SSID_MAXLEN;
@@ -809,7 +739,6 @@ void BSSvCreateOneNode(void *hDeviceContext, unsigned int *puNodeIndex)
     pMgmt->sNodeDBTable[*puNodeIndex].byAuthSequence = 0;
     pMgmt->sNodeDBTable[*puNodeIndex].wEnQueueCnt = 0;
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Create node index = %d\n", ii);
-    return;
 };
 
 
@@ -840,8 +769,6 @@ void BSSvRemoveOneNode(void *hDeviceContext, unsigned int uNodeIndex)
     memset(&pMgmt->sNodeDBTable[uNodeIndex], 0, sizeof(KnownNodeDB));
     // clear tx bit map
     pMgmt->abyPSTxMap[pMgmt->sNodeDBTable[uNodeIndex].wAID >> 3] &=  ~byMask[pMgmt->sNodeDBTable[uNodeIndex].wAID & 7];
-
-    return;
 };
 /*+
  *
@@ -1054,10 +981,6 @@ if((pMgmt->eCurrState!=WMAC_STATE_ASSOC) &&
 
             // Rate fallback check
             if (!pDevice->bFixRate) {
-/*
-                if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA) && (ii == 0))
-                    RATEvTxRateFallBack(pDevice, &(pMgmt->sNodeDBTable[ii]));
-*/
                 if (ii > 0) {
                     // ii = 0 for multicast node (AP & Adhoc)
 			RATEvTxRateFallBack((void *)pDevice,
@@ -1152,7 +1075,6 @@ if((pMgmt->eCurrState!=WMAC_STATE_ASSOC) &&
         (pMgmt->eCurrMode == WMAC_MODE_ESS_STA)) {
 
         if (pMgmt->sNodeDBTable[0].bActive) { // Assoc with BSS
-           // DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Callback inactive Count = [%d]\n", pMgmt->sNodeDBTable[0].uInActiveCount);
 
             if (pDevice->bUpdateBBVGA) {
 		/* s_vCheckSensitivity((void *) pDevice); */
@@ -1194,7 +1116,6 @@ if((pMgmt->eCurrState!=WMAC_STATE_ASSOC) &&
              pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
          }
    #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-  // if(pDevice->bWPASuppWextEnabled == TRUE)
       {
 	union iwreq_data  wrqu;
 	memset(&wrqu, 0, sizeof (wrqu));
@@ -1223,7 +1144,6 @@ DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bIsRoaming %d, !\n", pDevice->bIsRoaming );
                 pDevice->uIsroamingTime = 0;
                 pDevice->bRoaming = FALSE;
 
-//            if ((pDevice->bWPADEVUp) && (pDevice->skb != NULL)) {
              wpahdr = (viawget_wpa_header *)pDevice->skb->data;
              wpahdr->type = VIAWGET_CCKM_ROAM_MSG;
              wpahdr->resp_ie_len = 0;
@@ -1237,7 +1157,6 @@ DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bIsRoaming %d, !\n", pDevice->bIsRoaming );
              netif_rx(pDevice->skb);
             pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
 
-//         }
           }
       else if ((pDevice->bRoaming == FALSE)&&(pDevice->bIsRoaming == TRUE)) {
                             pDevice->uIsroamingTime++;
@@ -1315,7 +1234,6 @@ else {
 
     pMgmt->sTimerSecondCallback.expires = RUN_AT(HZ);
     add_timer(&pMgmt->sTimerSecondCallback);
-    return;
 }
 
 /*+
@@ -1364,7 +1282,6 @@ void BSSvUpdateNodeTxCounter(void *hDeviceContext,
 
     // Only Unicast using support rates
     if (wFIFOCtl & FIFOCTL_NEEDACK) {
-        //DBG_PRN_GRP21(("Device %08X, wRate %04X, byTSR %02X\n", hDeviceContext, wRate, byTSR));
         if (pMgmt->eCurrMode == WMAC_MODE_ESS_STA) {
             pMgmt->sNodeDBTable[0].uTxAttempts += 1;
             if ( !(byTSR & (TSR_TMO | TSR_RETRYTMO))) {
@@ -1475,10 +1392,6 @@ void BSSvUpdateNodeTxCounter(void *hDeviceContext,
             }
         }
     }
-
-    return;
-
-
 }
 
 /*+
@@ -1519,8 +1432,6 @@ void BSSvClearNodeDBTable(void *hDeviceContext,
             memset(&pMgmt->sNodeDBTable[ii], 0, sizeof(KnownNodeDB));
         }
     }
-
-    return;
 };
 
 void s_vCheckSensitivity(void *hDeviceContext)
@@ -1584,7 +1495,6 @@ RxOkRatio = (RxCnt < 6) ? 2000:((pDevice->scStatistic.RxOkCnt * 2000) / RxCnt);
 //decide link quality
 if(pDevice->bLinkPass !=TRUE)
 {
- //  printk("s_uCalculateLinkQual-->Link disconnect and Poor quality**\n");
    pDevice->scStatistic.LinkQuality = 0;
    pDevice->scStatistic.SignalStren = 0;
 }
@@ -1608,7 +1518,6 @@ else
    pDevice->scStatistic.TxFailCount = 0;
    pDevice->scStatistic.TxNoRetryOkCount = 0;
    pDevice->scStatistic.TxRetryOkCount = 0;
-   return;
 }
 
 void BSSvClearAnyBSSJoinRecord(void *hDeviceContext)
@@ -1617,10 +1526,8 @@ void BSSvClearAnyBSSJoinRecord(void *hDeviceContext)
     PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
     unsigned int            ii;
 
-    for (ii = 0; ii < MAX_BSS_NUM; ii++) {
+	for (ii = 0; ii < MAX_BSS_NUM; ii++)
         pMgmt->sBSSList[ii].bSelected = FALSE;
-    }
-    return;
 }
 
 void s_vCheckPreEDThreshold(void *hDeviceContext)
@@ -1637,6 +1544,5 @@ void s_vCheckPreEDThreshold(void *hDeviceContext)
             BBvUpdatePreEDThreshold(pDevice, FALSE);
         }
     }
-    return;
 }
 
-- 
1.7.4.4

