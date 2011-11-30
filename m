Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659Ab1K3CVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:21:19 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39186 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab1K3CS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:18:58 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: gregkh@suse.de
Cc: forest@alittletooquiet.net, driver@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH 2/5] staging: vt6656: 80211mgr.c: Code cleanup, removed return of void funcs.
Date: Wed, 30 Nov 2011 00:18:07 -0200
Message-Id: <1322619487-10083-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed return call of void functions. Removed some code style issues.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>

Cc: Greg kroah-Hartman <gregkh@suse.de>
Cc: Forest Bond <forest@alittletooquiet.net>
Cc: driver@driverdev.osuosl.org
---
 drivers/staging/vt6656/80211mgr.c |   35 ++---------------------------------
 1 files changed, 2 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/vt6656/80211mgr.c b/drivers/staging/vt6656/80211mgr.c
index fceec49..77d3b7b 100644
--- a/drivers/staging/vt6656/80211mgr.c
+++ b/drivers/staging/vt6656/80211mgr.c
@@ -224,8 +224,6 @@ vMgrDecodeBeacon(
         }
         pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 + pItem->len);
     }
-
-    return;
 }
 
 
@@ -248,8 +246,6 @@ vMgrEncodeIBSSATIM(
 {
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
     pFrame->len = WLAN_HDR_ADDR3_LEN;
-
-    return;
 }
 
 
@@ -270,8 +266,6 @@ vMgrDecodeIBSSATIM(
     )
 {
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
-
-    return;
 }
 
 
@@ -298,8 +292,6 @@ vMgrEncodeDisassociation(
     pFrame->pwReason = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                + WLAN_DISASSOC_OFF_REASON);
     pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_DISASSOC_OFF_REASON + sizeof(*(pFrame->pwReason));
-
-    return;
 }
 
 
@@ -324,8 +316,6 @@ vMgrDecodeDisassociation(
     /* Fixed Fields */
     pFrame->pwReason = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                + WLAN_DISASSOC_OFF_REASON);
-
-    return;
 }
 
 /*+
@@ -352,7 +342,6 @@ vMgrEncodeAssocRequest(
     pFrame->pwListenInterval = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                        + WLAN_ASSOCREQ_OFF_LISTEN_INT);
     pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_ASSOCREQ_OFF_LISTEN_INT + sizeof(*(pFrame->pwListenInterval));
-    return;
 }
 
 
@@ -418,7 +407,6 @@ vMgrDecodeAssocRequest(
         }
         pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 + pItem->len);
     }
-    return;
 }
 
 /*+
@@ -448,8 +436,6 @@ vMgrEncodeAssocResponse(
                             + WLAN_ASSOCRESP_OFF_AID);
     pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_ASSOCRESP_OFF_AID
                   + sizeof(*(pFrame->pwAid));
-
-    return;
 }
 
 
@@ -491,10 +477,8 @@ vMgrDecodeAssocResponse(
     if ((((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) && (pItem->byElementID == WLAN_EID_EXTSUPP_RATES)) {
         pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pFrame->pExtSuppRates=[%p].\n", pItem);
-    } else {
+	} else
         pFrame->pExtSuppRates = NULL;
-    }
-    return;
 }
 
 
@@ -524,8 +508,6 @@ vMgrEncodeReassocRequest(
     pFrame->pAddrCurrAP = (PIEEE_ADDR)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                        + WLAN_REASSOCREQ_OFF_CURR_AP);
     pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_REASSOCREQ_OFF_CURR_AP + sizeof(*(pFrame->pAddrCurrAP));
-
-    return;
 }
 
 
@@ -578,10 +560,9 @@ vMgrDecodeReassocRequest(
                 pFrame->pRSN = (PWLAN_IE_RSN)pItem;
             break;
         case WLAN_EID_RSN_WPA:
-            if (pFrame->pRSNWPA == NULL) {
+		if (pFrame->pRSNWPA == NULL)
                 if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
                     pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
-            }
             break;
 
         case WLAN_EID_EXTSUPP_RATES:
@@ -595,7 +576,6 @@ vMgrDecodeReassocRequest(
         }
         pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 + pItem->len);
     }
-    return;
 }
 
 
@@ -619,7 +599,6 @@ vMgrEncodeProbeRequest(
 {
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
     pFrame->len = WLAN_HDR_ADDR3_LEN;
-    return;
 }
 
 /*+
@@ -670,7 +649,6 @@ vMgrDecodeProbeRequest(
 
         pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 +  pItem->len);
     }
-    return;
 }
 
 
@@ -703,8 +681,6 @@ vMgrEncodeProbeResponse(
 
     pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_PROBERESP_OFF_CAP_INFO +
                   sizeof(*(pFrame->pwCapInfo));
-
-    return;
 }
 
 
@@ -818,7 +794,6 @@ vMgrDecodeProbeResponse(
 
         pItem = (PWLAN_IE)(((PBYTE)pItem) + 2 +  pItem->len);
     }
-    return;
 }
 
 
@@ -848,7 +823,6 @@ vMgrEncodeAuthen(
     pFrame->pwStatus = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                + WLAN_AUTHEN_OFF_STATUS);
     pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_AUTHEN_OFF_STATUS + sizeof(*(pFrame->pwStatus));
-    return;
 }
 
 
@@ -886,7 +860,6 @@ vMgrDecodeAuthen(
 
     if ((((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) && (pItem->byElementID == WLAN_EID_CHALLENGE))
         pFrame->pChallenge = (PWLAN_IE_CHALLENGE)pItem;
-    return;
 }
 
 
@@ -912,7 +885,6 @@ vMgrEncodeDeauthen(
     pFrame->pwReason = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                + WLAN_DEAUTHEN_OFF_REASON);
     pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_DEAUTHEN_OFF_REASON + sizeof(*(pFrame->pwReason));
-    return;
 }
 
 
@@ -937,7 +909,6 @@ vMgrDecodeDeauthen(
     /* Fixed Fields */
     pFrame->pwReason = (PWORD)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                + WLAN_DEAUTHEN_OFF_REASON);
-    return;
 }
 
 
@@ -968,7 +939,6 @@ vMgrEncodeReassocResponse(
                             + WLAN_REASSOCRESP_OFF_AID);
 
     pFrame->len = WLAN_HDR_ADDR3_LEN + WLAN_REASSOCRESP_OFF_AID + sizeof(*(pFrame->pwAid));
-    return;
 }
 
 
@@ -1010,5 +980,4 @@ vMgrDecodeReassocResponse(
 
     if ((((PBYTE)pItem) < (pFrame->pBuf + pFrame->len)) && (pItem->byElementID == WLAN_EID_EXTSUPP_RATES))
         pFrame->pExtSuppRates = (PWLAN_IE_SUPP_RATES)pItem;
-    return;
 }
-- 
1.7.4.4

