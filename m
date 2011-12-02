Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab1LBVzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 16:55:35 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53259 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793Ab1LBVze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 16:55:34 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 1/3] staging: vtt6655: 80211hdr.h, 80211mgr.c: General cleanup
Date: Fri,  2 Dec 2011 19:55:14 +0000
Message-Id: <1322855714-6182-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some useless comments, commented code and blank
lines. Also fix coding style of headers of functions.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/vt6655/80211hdr.h |   14 --
 drivers/staging/vt6655/80211mgr.c |  300 ++++++-------------------------------
 2 files changed, 43 insertions(+), 271 deletions(-)

diff --git a/drivers/staging/vt6655/80211hdr.h b/drivers/staging/vt6655/80211hdr.h
index f55283b..cfc22d0 100644
--- a/drivers/staging/vt6655/80211hdr.h
+++ b/drivers/staging/vt6655/80211hdr.h
@@ -33,7 +33,6 @@
 
 #include "ttype.h"
 
-/*---------------------  Export Definitions -------------------------*/
 /* bit type */
 #define BIT0	0x00000001
 #define BIT1	0x00000002
@@ -80,7 +79,6 @@
 #define WLAN_HDR_ADDR4_LEN          30
 #define WLAN_IEHDR_LEN              2
 #define WLAN_SSID_MAXLEN            32
-/*#define WLAN_RATES_MAXLEN           255*/
 #define WLAN_RATES_MAXLEN           16
 #define WLAN_RATES_MAXLEN_11B       4
 #define WLAN_RSN_MAXLEN             32
@@ -106,7 +104,6 @@
 #define WLAN_WEP40_KEYLEN           5
 #define WLAN_WEP104_KEYLEN          13
 #define WLAN_WEP232_KEYLEN          29
-/*#define WLAN_WEPMAX_KEYLEN          29*/
 #define WLAN_WEPMAX_KEYLEN          32
 #define WLAN_CHALLENGE_IE_MAXLEN    255
 #define WLAN_CHALLENGE_IE_LEN       130
@@ -339,15 +336,4 @@ typedef union tagUWLAN_80211HDR {
 
 } UWLAN_80211HDR, *PUWLAN_80211HDR;
 
-
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
-
-
 #endif /* __80211HDR_H__ */
-
-
diff --git a/drivers/staging/vt6655/80211mgr.c b/drivers/staging/vt6655/80211mgr.c
index 1ed0f26..0594fb2 100644
--- a/drivers/staging/vt6655/80211mgr.c
+++ b/drivers/staging/vt6655/80211mgr.c
@@ -59,35 +59,11 @@
 #include "device.h"
 #include "wpa.h"
 
-/*---------------------  Static Definitions -------------------------*/
-
-
-
-/*---------------------  Static Classes  ----------------------------*/
-
-/*---------------------  Static Variables  --------------------------*/
-
 static int          msglevel                =MSG_LEVEL_INFO;
-//static int          msglevel                =MSG_LEVEL_DEBUG;
-/*---------------------  Static Functions  --------------------------*/
-
-
 
-/*---------------------  Export Variables  --------------------------*/
-
-
-/*---------------------  Export Functions  --------------------------*/
-
-
-/*+
- *
- * Routine Description:
+/*
  * Encode Beacon frame body offset
- *
- * Return Value:
- *    None.
- *
--*/
+ */
 
 void
 vMgrEncodeBeacon(
@@ -109,16 +85,9 @@ vMgrEncodeBeacon(
     return;
 }
 
-/*+
- *
- * Routine Description:
+/*
  * Decode Beacon frame body offset
- *
- *
- * Return Value:
- *    None.
- *
--*/
+ */
 
 
 void
@@ -229,18 +198,9 @@ vMgrDecodeBeacon(
     return;
 }
 
-
-/*+
- *
- * Routine Description:
+/*
  *  Encode IBSS ATIM
- *
- *
- * Return Value:
- *    None.
- *
--*/
-
+ */
 
 void
 vMgrEncodeIBSSATIM(
@@ -253,17 +213,9 @@ vMgrEncodeIBSSATIM(
     return;
 }
 
-
-/*+
- *
- * Routine Description:
+/*
  *  Decode IBSS ATIM
- *
- *
- * Return Value:
- *    None.
- *
--*/
+ */
 
 void
 vMgrDecodeIBSSATIM(
@@ -275,17 +227,9 @@ vMgrDecodeIBSSATIM(
     return;
 }
 
-
-/*+
- *
- * Routine Description:
+/*
  *  Encode Disassociation
- *
- *
- * Return Value:
- *    None.
- *
--*/
+ */
 
 void
 vMgrEncodeDisassociation(
@@ -294,7 +238,6 @@ vMgrEncodeDisassociation(
 {
     pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
 
-
     // Fixed Fields
     pFrame->pwReason = (unsigned short *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                + WLAN_DISASSOC_OFF_REASON);
@@ -304,17 +247,9 @@ vMgrEncodeDisassociation(
 }
 
 
-/*+
- *
- * Routine Description:
+/*
  *  Decode Disassociation
- *
- *
- * Return Value:
- *    None.
- *
--*/
-
+ */
 void
 vMgrDecodeDisassociation(
     PWLAN_FR_DISASSOC  pFrame
@@ -329,18 +264,9 @@ vMgrDecodeDisassociation(
     return;
 }
 
-/*+
- *
- * Routine Description:
+/*
  *  Encode Association Request
- *
- *
- * Return Value:
- *    None.
- *
--*/
-
-
+ */
 void
 vMgrEncodeAssocRequest(
     PWLAN_FR_ASSOCREQ  pFrame
@@ -356,18 +282,9 @@ vMgrEncodeAssocRequest(
     return;
 }
 
-
-/*+
- *
- * Routine Description: (AP)
+/*
  *  Decode Association Request
- *
- *
- * Return Value:
- *    None.
- *
--*/
-
+ */
 void
 vMgrDecodeAssocRequest(
     PWLAN_FR_ASSOCREQ  pFrame
@@ -423,17 +340,9 @@ vMgrDecodeAssocRequest(
     return;
 }
 
-/*+
- *
- * Routine Description: (AP)
+/*
  *  Encode Association Response
- *
- *
- * Return Value:
- *    None.
- *
--*/
-
+ */
 void
 vMgrEncodeAssocResponse(
     PWLAN_FR_ASSOCRESP  pFrame
@@ -454,18 +363,9 @@ vMgrEncodeAssocResponse(
     return;
 }
 
-
-/*+
- *
- * Routine Description:
+/*
  *  Decode Association Response
- *
- *
- * Return Value:
- *    None.
- *
--*/
-
+ */
 void
 vMgrDecodeAssocResponse(
     PWLAN_FR_ASSOCRESP  pFrame
@@ -501,18 +401,9 @@ vMgrDecodeAssocResponse(
     return;
 }
 
-
-/*+
- *
- * Routine Description:
+/*
  *  Encode Reassociation Request
- *
- *
- * Return Value:
- *    None.
- *
--*/
-
+ */
 void
 vMgrEncodeReassocRequest(
     PWLAN_FR_REASSOCREQ  pFrame
@@ -532,19 +423,9 @@ vMgrEncodeReassocRequest(
     return;
 }
 
-
-/*+
- *
- * Routine Description: (AP)
+/*
  *  Decode Reassociation Request
- *
- *
- * Return Value:
- *    None.
- *
--*/
-
-
+ */
 void
 vMgrDecodeReassocRequest(
     PWLAN_FR_REASSOCREQ  pFrame
@@ -603,20 +484,9 @@ vMgrDecodeReassocRequest(
     return;
 }
 
-
-
-/*+
- *
- * Routine Description:
+/*
  *  Encode Probe Request
- *
- *
- * Return Value:
- *    None.
- *
--*/
-
-
+ */
 void
 vMgrEncodeProbeRequest(
     PWLAN_FR_PROBEREQ  pFrame
@@ -627,17 +497,9 @@ vMgrEncodeProbeRequest(
     return;
 }
 
-/*+
- *
- * Routine Description:
+/*
  *  Decode Probe Request
- *
- *
- * Return Value:
- *    None.
- *
--*/
-
+ */
 void
 vMgrDecodeProbeRequest(
     PWLAN_FR_PROBEREQ  pFrame
@@ -678,19 +540,9 @@ vMgrDecodeProbeRequest(
     return;
 }
 
-
-/*+
- *
- * Routine Description:
+/*
  *  Encode Probe Response
- *
- *
- * Return Value:
- *    None.
- *
--*/
-
-
+ */
 void
 vMgrEncodeProbeResponse(
     PWLAN_FR_PROBERESP  pFrame
@@ -712,19 +564,9 @@ vMgrEncodeProbeResponse(
     return;
 }
 
-
-
-/*+
- *
- * Routine Description:
+/*
  *  Decode Probe Response
- *
- *
- * Return Value:
- *    None.
- *
--*/
-
+ */
 void
 vMgrDecodeProbeResponse(
     PWLAN_FR_PROBERESP  pFrame
@@ -827,18 +669,9 @@ vMgrDecodeProbeResponse(
     return;
 }
 
-
-/*+
- *
- * Routine Description:
+/*
  *     Encode Authentication frame
- *
- *
- * Return Value:
- *    None.
- *
--*/
-
+ */
 void
 vMgrEncodeAuthen(
     PWLAN_FR_AUTHEN  pFrame
@@ -858,18 +691,9 @@ vMgrEncodeAuthen(
     return;
 }
 
-
-/*+
- *
- * Routine Description:
+/*
  *   Decode Authentication
- *
- *
- * Return Value:
- *    None.
- *
--*/
-
+ */
 void
 vMgrDecodeAuthen(
     PWLAN_FR_AUTHEN  pFrame
@@ -898,18 +722,9 @@ vMgrDecodeAuthen(
     return;
 }
 
-
 /*+
- *
- * Routine Description:
  *   Encode Authentication
- *
- *
- * Return Value:
- *    None.
- *
--*/
-
+ */
 void
 vMgrEncodeDeauthen(
     PWLAN_FR_DEAUTHEN  pFrame
@@ -925,18 +740,9 @@ vMgrEncodeDeauthen(
     return;
 }
 
-
-/*+
- *
- * Routine Description:
+/*
  *   Decode Deauthentication
- *
- *
- * Return Value:
- *    None.
- *
--*/
-
+ */
 void
 vMgrDecodeDeauthen(
     PWLAN_FR_DEAUTHEN  pFrame
@@ -947,22 +753,12 @@ vMgrDecodeDeauthen(
     // Fixed Fields
     pFrame->pwReason = (unsigned short *)(WLAN_HDR_A3_DATA_PTR(&(pFrame->pHdr->sA3))
                                + WLAN_DEAUTHEN_OFF_REASON);
-
     return;
 }
 
-
-/*+
- *
- * Routine Description: (AP)
+/*
  *   Encode Reassociation Response
- *
- *
- * Return Value:
- *    None.
- *
--*/
-
+ */
 void
 vMgrEncodeReassocResponse(
     PWLAN_FR_REASSOCRESP  pFrame
@@ -983,19 +779,9 @@ vMgrEncodeReassocResponse(
     return;
 }
 
-
-/*+
- *
- * Routine Description:
+/*
  *   Decode Reassociation Response
- *
- *
- * Return Value:
- *    None.
- *
--*/
-
-
+ */
 void
 vMgrDecodeReassocResponse(
     PWLAN_FR_REASSOCRESP  pFrame
-- 
1.7.4.4

