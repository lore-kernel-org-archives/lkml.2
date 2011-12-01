Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab1LACiC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 21:38:02 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50030 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab1LACiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 21:38:00 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org
Subject: [PATCH 4/4] staging: vt6656: dpc.c: Remove dead code
Date: Thu,  1 Dec 2011 00:37:36 +0000
Message-Id: <1322699856-20102-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some dead code, unneeded comments, commented code and
some unneeded debug messages.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Forest Bond <forest@alittletooquiet.net>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/vt6656/device.h |   13 ------
 drivers/staging/vt6656/dpc.c    |   92 +-------------------------------------
 2 files changed, 3 insertions(+), 102 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index f1496ec..59cf5fc 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -97,7 +97,6 @@
 #include "key.h"
 #include "card.h"
 
-/*---------------------  Export Definitions -------------------------*/
 #define VNT_USB_VENDOR_ID                     0x160a
 #define VNT_USB_PRODUCT_ID                    0x3184
 
@@ -106,10 +105,6 @@
 #define MAX_MULTICAST_ADDRESS_NUM       32
 #define MULTICAST_ADDRESS_LIST_SIZE     (MAX_MULTICAST_ADDRESS_NUM * ETH_ALEN)
 
-//#define OP_MODE_INFRASTRUCTURE  0
-//#define OP_MODE_ADHOC           1
-//#define OP_MODE_AP              2
-
 #define DUPLICATE_RX_CACHE_LENGTH       5
 
 #define NUM_KEY_ENTRY                   11
@@ -165,8 +160,6 @@
 
 #define PRIVATE_Message                 0
 
-/*---------------------  Export Types  ------------------------------*/
-
 #define DBG_PRT(l, p, args...) { if (l <= msglevel) printk(p, ##args); }
 #define PRINT_K(p, args...) { if (PRIVATE_Message) printk(p, ##args); }
 
@@ -236,7 +229,6 @@ typedef struct _DEFAULT_CONFIG {
 typedef struct {
     unsigned int            uDataLen;
     PBYTE           pDataBuf;
-//    struct urb      *pUrb;
     BOOL            bInUse;
 } INT_BUFFER, *PINT_BUFFER;
 
@@ -897,11 +889,6 @@ typedef struct __device_info {
 #define MP_IS_READY(_M)        (((_M)->Flags & \
                                  (fMP_DISCONNECTED | fMP_RESET_IN_PROGRESS | fMP_HALT_IN_PROGRESS | fMP_INIT_IN_PROGRESS | fMP_SURPRISE_REMOVED)) == 0)
 
-/*---------------------  Export Functions  --------------------------*/
-
-/* BOOL device_dma0_xmit(PSDevice pDevice, struct sk_buff *skb,
- *                       unsigned int uNodeIndex);
- */
 BOOL device_alloc_frag_buf(PSDevice pDevice, PSDeFragControlBlock pDeF);
 
 #endif
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index c0edf97..5e95800 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -56,24 +56,11 @@
 #include "datarate.h"
 #include "usbpipe.h"
 
-/*---------------------  Static Definitions -------------------------*/
-
-/*---------------------  Static Classes  ----------------------------*/
-
-/*---------------------  Static Variables  --------------------------*/
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 static int          msglevel                =MSG_LEVEL_INFO;
 
 const BYTE acbyRxRate[MAX_RATE] =
 {2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108};
 
-
-/*---------------------  Static Functions  --------------------------*/
-
-/*---------------------  Static Definitions -------------------------*/
-
-/*---------------------  Static Functions  --------------------------*/
-
 static BYTE s_byGetRateIdx(BYTE byRate);
 
 static
@@ -140,8 +127,6 @@ static BOOL s_bHostWepRxEncryption(
 
     );
 
-/*---------------------  Export Variables  --------------------------*/
-
 /*+
  *
  * Description:
@@ -542,9 +527,7 @@ RXbBulkInProcessData (
                         pDevice->s802_11Counter.TKIPICVErrors++;
                     } else if ((pKey != NULL) && (pKey->byCipherSuite == KEY_CTL_CCMP)) {
                         pDevice->s802_11Counter.CCMPDecryptErrors++;
-                    } else if ((pKey != NULL) && (pKey->byCipherSuite == KEY_CTL_WEP)) {
-//                      pDevice->s802_11Counter.WEPICVErrorCount.QuadPart++;
-                    }
+}
                 }
                 return FALSE;
             }
@@ -625,8 +608,6 @@ RXbBulkInProcessData (
             // hostap Deamon handle 802.11 management
             if (pDevice->bEnableHostapd) {
 	            skb->dev = pDevice->apdev;
-	            //skb->data += 4;
-	            //skb->tail += 4;
 	            skb->data += 8;
 	            skb->tail += 8;
                 skb_put(skb, FrameSize);
@@ -702,12 +683,6 @@ RXbBulkInProcessData (
                         bRxeapol_key = TRUE;
 		      Descriptor_type = skb->data[cbIVOffset + 8 + 24 + 6 + 1 +1+1+1+2];
 		      Key_info = (skb->data[cbIVOffset + 8 + 24 + 6 + 1 +1+1+1+2+1]<<8) |skb->data[cbIVOffset + 8 + 24 + 6 + 1 +1+1+1+2+2] ;
-		      if(Descriptor_type==2) {    //RSN
-                         //  printk("WPA2_Rx_eapol-key_info<-----:%x\n",Key_info);
-		      }
-		     else  if(Descriptor_type==254) {
-                        //  printk("WPA_Rx_eapol-key_info<-----:%x\n",Key_info);
-		     }
                   }
 	      }
    	  }
@@ -720,12 +695,7 @@ RXbBulkInProcessData (
 
 
     if (pDevice->bEnablePSMode) {
-        if (IS_FC_MOREDATA((pbyFrame))) {
-            if (*pbyRsr & RSR_ADDROK) {
-                //PSbSendPSPOLL((PSDevice)pDevice);
-            }
-        }
-        else {
+	if (!IS_FC_MOREDATA((pbyFrame))) {
             if (pMgmt->bInTIMWake == TRUE) {
                 pMgmt->bInTIMWake = FALSE;
             }
@@ -743,27 +713,6 @@ RXbBulkInProcessData (
     pDevice->uCurrRSSI = *pbyRSSI;
     pDevice->byCurrSQ = *pbySQ;
 
-    // todo
-/*
-    if ((*pbyRSSI != 0) &&
-        (pMgmt->pCurrBSS!=NULL)) {
-        RFvRSSITodBm(pDevice, *pbyRSSI, &ldBm);
-        // Moniter if RSSI is too strong.
-        pMgmt->pCurrBSS->byRSSIStatCnt++;
-        pMgmt->pCurrBSS->byRSSIStatCnt %= RSSI_STAT_COUNT;
-        pMgmt->pCurrBSS->ldBmAverage[pMgmt->pCurrBSS->byRSSIStatCnt] = ldBm;
-	for (ii = 0; ii < RSSI_STAT_COUNT; ii++) {
-		if (pMgmt->pCurrBSS->ldBmAverage[ii] != 0) {
-			pMgmt->pCurrBSS->ldBmMAX =
-				max(pMgmt->pCurrBSS->ldBmAverage[ii], ldBm);
-		}
-        }
-    }
-*/
-
-
-    // -----------------------------------------------
-
     if ((pMgmt->eCurrMode == WMAC_MODE_ESS_AP) && (pDevice->bEnable8021x == TRUE)){
         BYTE    abyMacHdr[24];
 
@@ -808,7 +757,6 @@ RXbBulkInProcessData (
         }
     }
 
-    //--------------------------------------------------------------------------------
     // Soft MIC
     if ((pKey != NULL) && (pKey->byCipherSuite == KEY_CTL_TKIP)) {
         if (bIsWEP) {
@@ -856,7 +804,6 @@ RXbBulkInProcessData (
                 (pDevice->bRxMICFail == TRUE)) {
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"MIC comparison is fail!\n");
                 pDevice->bRxMICFail = FALSE;
-                //pDevice->s802_11Counter.TKIPLocalMICFailures.QuadPart++;
                 pDevice->s802_11Counter.TKIPLocalMICFailures++;
                 if (bDeFragRx) {
                     if (!device_alloc_frag_buf(pDevice, &pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx])) {
@@ -866,7 +813,6 @@ RXbBulkInProcessData (
                 }
        #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 				//send event to wpa_supplicant
-				//if(pDevice->bWPASuppWextEnabled == TRUE)
 				{
 					union iwreq_data wrqu;
 					struct iw_michaelmicfailure ev;
@@ -885,9 +831,7 @@ RXbBulkInProcessData (
 					memcpy(ev.src_addr.sa_data, pMACHeader->abyAddr2, ETH_ALEN);
 					memset(&wrqu, 0, sizeof(wrqu));
 					wrqu.data.length = sizeof(ev);
-			PRINT_K("wireless_send_event--->IWEVMICHAELMICFAILURE\n");
 					wireless_send_event(pDevice->dev, IWEVMICHAELMICFAILURE, &wrqu, (char *)&ev);
-
 				}
          #endif
 
@@ -897,10 +841,8 @@ RXbBulkInProcessData (
                      if ((pMgmt->eCurrMode == WMAC_MODE_ESS_STA) &&
                          (pMgmt->eCurrState == WMAC_STATE_ASSOC) &&
                          (*pbyRsr & (RSR_ADDRBROAD | RSR_ADDRMULTI)) == 0) {
-                         //s802_11_Status.Flags = NDIS_802_11_AUTH_REQUEST_PAIRWISE_ERROR;
                          wpahdr->type = VIAWGET_PTK_MIC_MSG;
                      } else {
-                         //s802_11_Status.Flags = NDIS_802_11_AUTH_REQUEST_GROUP_ERROR;
                          wpahdr->type = VIAWGET_GTK_MIC_MSG;
                      }
                      wpahdr->resp_ie_len = 0;
@@ -947,10 +889,8 @@ RXbBulkInProcessData (
                      !((dwRxTSC47_16 == 0) && (dwLocalTSC47_16 == 0xFFFFFFFF))) {
                     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"TSC is illegal~~!\n ");
                     if (pKey->byCipherSuite == KEY_CTL_TKIP)
-                        //pDevice->s802_11Counter.TKIPReplays.QuadPart++;
                         pDevice->s802_11Counter.TKIPReplays++;
                     else
-                        //pDevice->s802_11Counter.CCMPReplays.QuadPart++;
                         pDevice->s802_11Counter.CCMPReplays++;
 
                     if (bDeFragRx) {
@@ -1108,14 +1048,6 @@ static BOOL s_bAPModeRxCtl (
                                        (WLAN_MGMT_REASON_CLASS2_NONAUTH),
                                        &Status
                                        );
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: send vMgrDeAuthenBeginSta 3\n");
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "BSSID:%pM\n",
-				p802_11Header->abyAddr3);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ADDR2:%pM\n",
-				p802_11Header->abyAddr2);
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "ADDR1:%pM\n",
-				p802_11Header->abyAddr1);
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "dpc: wFrameCtl= %x\n", p802_11Header->wFrameCtl );
                     return TRUE;
             }
         }
@@ -1198,19 +1130,9 @@ static BOOL s_bHandleRxEncryption (
 
     if (pKey == NULL) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey == NULL\n");
-        if (byDecMode == KEY_CTL_WEP) {
-//            pDevice->s802_11Counter.WEPUndecryptableCount.QuadPart++;
-        } else if (pDevice->bLinkPass == TRUE) {
-//            pDevice->s802_11Counter.DecryptFailureCount.QuadPart++;
-        }
         return FALSE;
     }
     if (byDecMode != pKey->byCipherSuite) {
-        if (byDecMode == KEY_CTL_WEP) {
-//            pDevice->s802_11Counter.WEPUndecryptableCount.QuadPart++;
-        } else if (pDevice->bLinkPass == TRUE) {
-//            pDevice->s802_11Counter.DecryptFailureCount.QuadPart++;
-        }
         *pKeyOut = NULL;
         return FALSE;
     }
@@ -1313,14 +1235,8 @@ static BOOL s_bHostWepRxEncryption (
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"AES:%d %d %d\n", pMgmt->byCSSPK, pMgmt->byCSSGK, byDecMode);
 
-    if (byDecMode != pKey->byCipherSuite) {
-        if (byDecMode == KEY_CTL_WEP) {
-//            pDevice->s802_11Counter.WEPUndecryptableCount.QuadPart++;
-        } else if (pDevice->bLinkPass == TRUE) {
-//            pDevice->s802_11Counter.DecryptFailureCount.QuadPart++;
-        }
+	if (byDecMode != pKey->byCipherSuite)
         return FALSE;
-    }
 
     if (byDecMode == KEY_CTL_WEP) {
         // handle WEP
@@ -1594,5 +1510,3 @@ void RXvMngWorkItem(void *Context)
 	spin_unlock_irq(&pDevice->lock);
 
 }
-
-
-- 
1.7.4.4

