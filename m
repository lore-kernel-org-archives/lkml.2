Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab2L1T4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:56:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54934 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754316Ab2L1TRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:07 -0500
Message-Id: <20121228190402.659691100@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:06:20 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 170/173] staging: vt6656: 64 bit fixes: fix long warning messages.
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit b4dc03af5513774277c9c36b12a25cd3f25f4404 upstream.

Fixes long warning messages from patch
[PATCH 08/14] staging: vt6656: 64 bit fixes : correct all type sizes

 Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/vt6656/dpc.c  |    4 ++--
 drivers/staging/vt6656/key.c  |   47 +++++++++++++++++++++++++++++------------
 drivers/staging/vt6656/mac.c  |    6 ++++--
 drivers/staging/vt6656/rxtx.c |   18 ++++++++++------
 4 files changed, 51 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 1ff6ea3..6f9b2b4 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -1238,7 +1238,7 @@ static BOOL s_bHandleRxEncryption (
 
         PayloadLen -= (WLAN_HDR_ADDR3_LEN + 8 + 4); // 24 is 802.11 header, 8 is IV&ExtIV, 4 is crc
         *pdwRxTSC47_16 = cpu_to_le32(*(PDWORD)(pbyIV + 4));
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ExtIV: %lx\n",*pdwRxTSC47_16);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ExtIV: %x\n", *pdwRxTSC47_16);
         if (byDecMode == KEY_CTL_TKIP) {
             *pwRxTSC15_0 = cpu_to_le16(MAKEWORD(*(pbyIV+2), *pbyIV));
         } else {
@@ -1349,7 +1349,7 @@ static BOOL s_bHostWepRxEncryption (
 
         PayloadLen -= (WLAN_HDR_ADDR3_LEN + 8 + 4); // 24 is 802.11 header, 8 is IV&ExtIV, 4 is crc
         *pdwRxTSC47_16 = cpu_to_le32(*(PDWORD)(pbyIV + 4));
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ExtIV: %lx\n",*pdwRxTSC47_16);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ExtIV: %x\n", *pdwRxTSC47_16);
 
         if (byDecMode == KEY_CTL_TKIP) {
             *pwRxTSC15_0 = cpu_to_le16(MAKEWORD(*(pbyIV+2), *pbyIV));
diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index a61fcb9..617fda1 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -235,7 +235,8 @@ BOOL KeybSetKey(
     PSKeyItem   pKey;
     unsigned int        uKeyIdx;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Enter KeybSetKey: %lX\n", dwKeyIndex);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+		"Enter KeybSetKey: %X\n", dwKeyIndex);
 
     j = (MAX_KEY_TABLE-1);
     for (i=0;i<(MAX_KEY_TABLE-1);i++) {
@@ -261,7 +262,9 @@ BOOL KeybSetKey(
                 if ((dwKeyIndex & TRANSMIT_KEY) != 0)  {
                     // Group transmit key
                     pTable->KeyTable[i].dwGTKeyIndex = dwKeyIndex;
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Group transmit key(R)[%lX]: %d\n", pTable->KeyTable[i].dwGTKeyIndex, i);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"Group transmit key(R)[%X]: %d\n",
+					pTable->KeyTable[i].dwGTKeyIndex, i);
                 }
                 pTable->KeyTable[i].wKeyCtl &= 0xFF0F;          // clear group key control filed
                 pTable->KeyTable[i].wKeyCtl |= (byKeyDecMode << 4);
@@ -302,9 +305,12 @@ BOOL KeybSetKey(
             }
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"\n");
 
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwTSC47_16: %lx\n ", pKey->dwTSC47_16);
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->wTSC15_0: %x\n ", pKey->wTSC15_0);
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwKeyIndex: %lx\n ", pKey->dwKeyIndex);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwTSC47_16: %x\n ",
+			pKey->dwTSC47_16);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->wTSC15_0: %x\n ",
+			pKey->wTSC15_0);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwKeyIndex: %x\n ",
+			pKey->dwKeyIndex);
 
             return (TRUE);
         }
@@ -326,7 +332,9 @@ BOOL KeybSetKey(
             if ((dwKeyIndex & TRANSMIT_KEY) != 0)  {
                 // Group transmit key
                 pTable->KeyTable[j].dwGTKeyIndex = dwKeyIndex;
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Group transmit key(N)[%lX]: %d\n", pTable->KeyTable[j].dwGTKeyIndex, j);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"Group transmit key(N)[%X]: %d\n",
+				pTable->KeyTable[j].dwGTKeyIndex, j);
             }
             pTable->KeyTable[j].wKeyCtl &= 0xFF0F;          // clear group key control filed
             pTable->KeyTable[j].wKeyCtl |= (byKeyDecMode << 4);
@@ -367,9 +375,11 @@ BOOL KeybSetKey(
         }
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"\n");
 
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwTSC47_16: %lx\n ", pKey->dwTSC47_16);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwTSC47_16: %x\n ",
+		pKey->dwTSC47_16);
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->wTSC15_0: %x\n ", pKey->wTSC15_0);
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwKeyIndex: %lx\n ", pKey->dwKeyIndex);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwKeyIndex: %x\n ",
+		pKey->dwKeyIndex);
 
         return (TRUE);
     }
@@ -597,7 +607,8 @@ BOOL KeybGetTransmitKey(PSKeyManagement pTable, PBYTE pbyBSSID, DWORD dwKeyType,
                             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"%x ", pTable->KeyTable[i].abyBSSID[ii]);
                         }
                         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"\n");
-                        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"dwGTKeyIndex: %lX\n", pTable->KeyTable[i].dwGTKeyIndex);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"dwGTKeyIndex: %X\n",
+				pTable->KeyTable[i].dwGTKeyIndex);
 
                     return (TRUE);
                 }
@@ -696,7 +707,10 @@ BOOL KeybSetDefaultKey(
     if ((dwKeyIndex & TRANSMIT_KEY) != 0)  {
         // Group transmit key
         pTable->KeyTable[MAX_KEY_TABLE-1].dwGTKeyIndex = dwKeyIndex;
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Group transmit key(R)[%lX]: %d\n", pTable->KeyTable[MAX_KEY_TABLE-1].dwGTKeyIndex, MAX_KEY_TABLE-1);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+		"Group transmit key(R)[%X]: %d\n",
+		pTable->KeyTable[MAX_KEY_TABLE-1].dwGTKeyIndex,
+		MAX_KEY_TABLE-1);
 
     }
     pTable->KeyTable[MAX_KEY_TABLE-1].wKeyCtl &= 0x7F00;          // clear all key control filed
@@ -747,9 +761,11 @@ BOOL KeybSetDefaultKey(
     }
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"\n");
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwTSC47_16: %lx\n", pKey->dwTSC47_16);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwTSC47_16: %x\n",
+		pKey->dwTSC47_16);
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->wTSC15_0: %x\n", pKey->wTSC15_0);
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwKeyIndex: %lx\n", pKey->dwKeyIndex);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"pKey->dwKeyIndex: %x\n",
+		pKey->dwKeyIndex);
 
     return (TRUE);
 }
@@ -787,7 +803,8 @@ BOOL KeybSetAllGroupKey(
     PSKeyItem   pKey;
     unsigned int        uKeyIdx;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Enter KeybSetAllGroupKey: %lX\n", dwKeyIndex);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Enter KeybSetAllGroupKey: %X\n",
+		dwKeyIndex);
 
 
     if ((dwKeyIndex & PAIRWISE_KEY) != 0) {                  // Pairwise key
@@ -804,7 +821,9 @@ BOOL KeybSetAllGroupKey(
             if ((dwKeyIndex & TRANSMIT_KEY) != 0)  {
                 // Group transmit key
                 pTable->KeyTable[i].dwGTKeyIndex = dwKeyIndex;
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Group transmit key(R)[%lX]: %d\n", pTable->KeyTable[i].dwGTKeyIndex, i);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"Group transmit key(R)[%X]: %d\n",
+			pTable->KeyTable[i].dwGTKeyIndex, i);
 
             }
             pTable->KeyTable[i].wKeyCtl &= 0xFF0F;          // clear group key control filed
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index af4a29d..8fddc7b 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -260,7 +260,8 @@ BYTE            pbyData[24];
     dwData1 <<= 16;
     dwData1 |= MAKEWORD(*(pbyAddr+4), *(pbyAddr+5));
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"1. wOffset: %d, Data: %lX, KeyCtl:%X\n", wOffset, dwData1, wKeyCtl);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"1. wOffset: %d, Data: %X,"\
+		" KeyCtl:%X\n", wOffset, dwData1, wKeyCtl);
 
     //VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
     //VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
@@ -277,7 +278,8 @@ BYTE            pbyData[24];
     dwData2 <<= 8;
     dwData2 |= *(pbyAddr+0);
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"2. wOffset: %d, Data: %lX\n", wOffset, dwData2);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"2. wOffset: %d, Data: %X\n",
+		wOffset, dwData2);
 
     //VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset);
     //VNSvOutPortD(dwIoBase + MAC_REG_MISCFFDATA, dwData);
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 1f87213..cd9debc 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -375,7 +375,8 @@ s_vFillTxKey (
         *(pbyIVHead+3) = (BYTE)(((pDevice->byKeyIndex << 6) & 0xc0) | 0x20); // 0x20 is ExtIV
         // Append IV&ExtIV after Mac Header
         *pdwExtIV = cpu_to_le32(pTransmitKey->dwTSC47_16);
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"vFillTxKey()---- pdwExtIV: %lx\n", *pdwExtIV);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"vFillTxKey()---- pdwExtIV: %x\n",
+		*pdwExtIV);
 
     } else if (pTransmitKey->byCipherSuite == KEY_CTL_CCMP) {
         pTransmitKey->wTSC15_0++;
@@ -1749,7 +1750,8 @@ s_bPacketToWirelessUsb(
         MIC_vAppend((PBYTE)&(psEthHeader->abyDstAddr[0]), 12);
         dwMIC_Priority = 0;
         MIC_vAppend((PBYTE)&dwMIC_Priority, 4);
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"MIC KEY: %lX, %lX\n", dwMICKey0, dwMICKey1);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"MIC KEY: %X, %X\n",
+		dwMICKey0, dwMICKey1);
 
         ///////////////////////////////////////////////////////////////////
 
@@ -2631,7 +2633,8 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb) {
             MIC_vAppend((PBYTE)&(sEthHeader.abyDstAddr[0]), 12);
             dwMIC_Priority = 0;
             MIC_vAppend((PBYTE)&dwMIC_Priority, 4);
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"DMA0_tx_8021:MIC KEY: %lX, %lX\n", dwMICKey0, dwMICKey1);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"DMA0_tx_8021:MIC KEY:"\
+			" %X, %X\n", dwMICKey0, dwMICKey1);
 
             uLength = cbHeaderSize + cbMacHdLen + uPadding + cbIVlen;
 
@@ -2651,7 +2654,8 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb) {
 
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"uLength: %d, %d\n", uLength, cbFrameBodySize);
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"cbReqCount:%d, %d, %d, %d\n", cbReqCount, cbHeaderSize, uPadding, cbIVlen);
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"MIC:%lx, %lx\n", *pdwMIC_L, *pdwMIC_R);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"MIC:%x, %x\n",
+			*pdwMIC_L, *pdwMIC_R);
 
         }
 
@@ -3025,7 +3029,8 @@ int nsDMA_tx_packet(PSDevice pDevice, unsigned int uDMAIdx, struct sk_buff *skb)
                         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"error: KEY is GTK!!~~\n");
                     }
                     else {
-                        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Find PTK [%lX]\n", pTransmitKey->dwKeyIndex);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Find PTK [%X]\n",
+				pTransmitKey->dwKeyIndex);
                         bNeedEncryption = TRUE;
                     }
                 }
@@ -3034,7 +3039,8 @@ int nsDMA_tx_packet(PSDevice pDevice, unsigned int uDMAIdx, struct sk_buff *skb)
             if (pDevice->bEnableHostWEP) {
                 if ((uNodeIndex != 0) &&
                     (pMgmt->sNodeDBTable[uNodeIndex].dwKeyIndex & PAIRWISE_KEY)) {
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Find PTK [%lX]\n", pTransmitKey->dwKeyIndex);
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Find PTK [%X]\n",
+				pTransmitKey->dwKeyIndex);
                     bNeedEncryption = TRUE;
                  }
              }


