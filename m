Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab1K3CUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:20:05 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40947 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757617Ab1K3CT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:19:58 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: gregkh@suse.de
Cc: forest@alittletooquiet.net, driver@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH 3/5] staging: vt6656: baseband.c: Removed dead code, and fix coding standards
Date: Wed, 30 Nov 2011 00:19:08 -0200
Message-Id: <1322619548-10138-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remved some commented code, and fixed some style issues. was removed too
a redundant if statement.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>

Cc: Greg kroah-Hartman <gregkh@suse.de>
Cc: Forest Bond <forest@alittletooquiet.net>
Cc: driver@driverdev.osuosl.org
---
 drivers/staging/vt6656/baseband.c |   59 +++++++++----------------------------
 1 files changed, 14 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 0d11147..7da57b8 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -932,30 +932,8 @@ BBvCaculateParameter (
 void
 BBvSetAntennaMode (PSDevice pDevice, BYTE byAntennaMode)
 {
-    //{{ RobertYu: 20041124, ABG Mode, VC1/VC2 define, make the ANT_A, ANT_B inverted
-    /*if ( (pDevice->byRFType == RF_MAXIM2829) ||
-         (pDevice->byRFType == RF_UW2452) ||
-         (pDevice->byRFType == RF_AIROHA7230) ) { // RobertYu: 20041210, 20050104
-
-        switch (byAntennaMode) {
-            case ANT_TXA:
-                byAntennaMode = ANT_TXB;
-                break;
-            case ANT_TXB:
-                byAntennaMode = ANT_TXA;
-                break;
-            case ANT_RXA:
-                byAntennaMode = ANT_RXB;
-                break;
-            case ANT_RXB:
-                byAntennaMode = ANT_RXA;
-                break;
-        }
-    }*/
-
     switch (byAntennaMode) {
         case ANT_TXA:
-            break;
         case ANT_TXB:
             break;
         case ANT_RXA:
@@ -1249,8 +1227,7 @@ void BBvLoopbackOff (PSDevice pDevice)
         // Set the CR33 Bit2 to disable internal Loopback.
         ControlvReadByte (pDevice, MESSAGE_REQUEST_BBREG, 0x21, &byData);//CR33
         ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0x21, (BYTE)(byData & 0xFE));//CR33
-    }
-    else { // OFDM
+	} else { /* OFDM */
         ControlvReadByte (pDevice, MESSAGE_REQUEST_BBREG, 0x9A, &byData);//CR154
         ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0x9A, (BYTE)(byData & 0xFE));//CR154
     }
@@ -1277,19 +1254,16 @@ BBvSetShortSlotTime (PSDevice pDevice)
 {
     BYTE byBBVGA=0;
 
-    if (pDevice->bShortSlotTime) {
+	if (pDevice->bShortSlotTime)
         pDevice->byBBRxConf &= 0xDF;//1101 1111
-    } else {
+	else
         pDevice->byBBRxConf |= 0x20;//0010 0000
-    }
 
     ControlvReadByte (pDevice, MESSAGE_REQUEST_BBREG, 0xE7, &byBBVGA);
-    if (byBBVGA == pDevice->abyBBVGA[0]) {
+	if (byBBVGA == pDevice->abyBBVGA[0])
         pDevice->byBBRxConf |= 0x20;//0010 0000
-    }
 
     ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0x0A, pDevice->byBBRxConf);
-
 }
 
 
@@ -1299,13 +1273,11 @@ void BBvSetVGAGainOffset(PSDevice pDevice, BYTE byData)
     ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xE7, byData);
 
     // patch for 3253B0 Baseband with Cardbus module
-    if (byData == pDevice->abyBBVGA[0]) {
-        pDevice->byBBRxConf |= 0x20;//0010 0000
-    } else if (pDevice->bShortSlotTime) {
-        pDevice->byBBRxConf &= 0xDF;//1101 1111
-    } else {
-        pDevice->byBBRxConf |= 0x20;//0010 0000
-    }
+	if (pDevice->bShortSlotTime)
+		pDevice->byBBRxConf &= 0xDF; /* 1101 1111 */
+	else
+		pDevice->byBBRxConf |= 0x20; /* 0010 0000 */
+
     ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0x0A, pDevice->byBBRxConf);//CR10
 }
 
@@ -1365,15 +1337,14 @@ static unsigned long s_ulGetLowSQ3(PSDevice pDevice)
 	unsigned long ulMaxPacket;
 
     ulMaxPacket = pDevice->aulPktNum[RATE_54M];
-    if ( pDevice->aulPktNum[RATE_54M] != 0 ) {
+	if (pDevice->aulPktNum[RATE_54M] != 0)
         ulSQ3 = pDevice->aulSQ3Val[RATE_54M] / pDevice->aulPktNum[RATE_54M];
-    }
-    for ( ii=RATE_48M;ii>=RATE_6M;ii-- ) {
-        if ( pDevice->aulPktNum[ii] > ulMaxPacket ) {
+
+	for (ii = RATE_48M; ii >= RATE_6M; ii--)
+		if (pDevice->aulPktNum[ii] > ulMaxPacket) {
             ulMaxPacket = pDevice->aulPktNum[ii];
             ulSQ3 = pDevice->aulSQ3Val[ii] / pDevice->aulPktNum[ii];
         }
-    }
 
     return ulSQ3;
 }
@@ -1392,7 +1363,7 @@ static unsigned long s_ulGetRatio(PSDevice pDevice)
         ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
         ulRatio += TOP_RATE_54M;
     }
-    for ( ii=RATE_48M;ii>=RATE_1M;ii-- ) {
+	for (ii = RATE_48M; ii >= RATE_1M; ii--)
         if ( pDevice->aulPktNum[ii] > ulMaxPacket ) {
             ulPacketNum = 0;
             for ( jj=RATE_54M;jj>=ii;jj--)
@@ -1402,8 +1373,6 @@ static unsigned long s_ulGetRatio(PSDevice pDevice)
             ulMaxPacket = pDevice->aulPktNum[ii];
         }
 
-    }
-
     return ulRatio;
 }
 
-- 
1.7.4.4

