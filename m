Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab0IQIZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 04:25:06 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33365 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab0IQIZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 04:25:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LSysiSLE4bP/YVs1zTd5Y3RtJ6UmukYyQABsf1+x2iWkcx7nWPPX0dSrqbbg+13nxm
         KxIwAfRvo/oKD8IlSIKjPTxO0zr4qyeZgOrc+spgLdFv68fMf/R6IJFjJKhCK/mIMI2c
         Is/g7wk6dLrFvcvM+p1y3gkBLsySGU5ZcKzCA=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 1/9] staging: rt2860: '&pointer[0]' to 'pointer' fix
Date: Fri, 17 Sep 2010 11:24:43 +0300
Message-Id: <668ce39e9bd64e2a285367e2cc0963d678d1b501.1284711623.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <20100916225346.GA14448@kroah.com>
References: <20100916225346.GA14448@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/rt2860/common/ba_action.c   |    2 +-
 drivers/staging/rt2860/common/cmm_mac_usb.c |    2 +-
 drivers/staging/rt2860/common/cmm_wpa.c     |    2 +-
 drivers/staging/rt2860/common/mlme.c        |    3 +--
 drivers/staging/rt2860/common/rtmp_init.c   |    4 ++--
 drivers/staging/rt2860/sta/assoc.c          |    2 +-
 drivers/staging/rt2860/sta/connect.c        |    6 +++---
 drivers/staging/rt2860/sta/sync.c           |    4 ++--
 drivers/staging/rt2860/sta_ioctl.c          |    4 ++--
 9 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/rt2860/common/ba_action.c b/drivers/staging/rt2860/common/ba_action.c
index 3f71c50..1befe99 100644
--- a/drivers/staging/rt2860/common/ba_action.c
+++ b/drivers/staging/rt2860/common/ba_action.c
@@ -655,7 +655,7 @@ BOOLEAN BARecSessionAdd(struct rt_rtmp_adapter *pAd,
 		Status = FALSE;
 		DBGPRINT(RT_DEBUG_TRACE,
 			("Can't Accept ADDBA for %pM TID = %d\n",
-				&pEntry->Addr[0], TID));
+				pEntry->Addr, TID));
 	}
 	return (Status);
 }
diff --git a/drivers/staging/rt2860/common/cmm_mac_usb.c b/drivers/staging/rt2860/common/cmm_mac_usb.c
index d08abf7..72731cb 100644
--- a/drivers/staging/rt2860/common/cmm_mac_usb.c
+++ b/drivers/staging/rt2860/common/cmm_mac_usb.c
@@ -663,7 +663,7 @@ int RTUSBWriteHWMACAddress(struct rt_rtmp_adapter *pAd)
 	StaMacReg1.field.Byte5 = pAd->CurrentAddress[5];
 	StaMacReg1.field.U2MeMask = 0xff;
 	DBGPRINT_RAW(RT_DEBUG_TRACE,
-		("Local MAC = %pM\n", &pAd->CurrentAddress[0]));
+		("Local MAC = %pM\n", pAd->CurrentAddress));
 
 	RTUSBWriteMACRegister(pAd, MAC_ADDR_DW0, StaMacReg0.word);
 	RTUSBWriteMACRegister(pAd, MAC_ADDR_DW1, StaMacReg1.word);
diff --git a/drivers/staging/rt2860/common/cmm_wpa.c b/drivers/staging/rt2860/common/cmm_wpa.c
index 78ca4ed..e37b64b 100644
--- a/drivers/staging/rt2860/common/cmm_wpa.c
+++ b/drivers/staging/rt2860/common/cmm_wpa.c
@@ -222,7 +222,7 @@ void WpaEAPOLKeyAction(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *E
 
 		DBGPRINT(RT_DEBUG_TRACE,
 			("Receive EAPoL-Key frame from STA %pMF\n",
-				&pEntry->Addr[0]));
+				pEntry->Addr));
 
 		if (((pEapol_packet->ProVer != EAPOL_VER)
 		     && (pEapol_packet->ProVer != EAPOL_VER2))
diff --git a/drivers/staging/rt2860/common/mlme.c b/drivers/staging/rt2860/common/mlme.c
index e514033..3558f65 100644
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -1537,8 +1537,7 @@ void MlmeAutoReconnectLastSSID(struct rt_rtmp_adapter *pAd)
 	if (pAd->StaCfg.bAutoConnectByBssid) {
 		DBGPRINT(RT_DEBUG_TRACE,
 			("Driver auto reconnect to last OID_802_11_BSSID "
-				"setting - %pM\n",
-				&pAd->MlmeAux.Bssid[0]));
+				"setting - %pM\n", pAd->MlmeAux.Bssid));
 
 		pAd->MlmeAux.Channel = pAd->CommonCfg.Channel;
 		MlmeEnqueue(pAd,
diff --git a/drivers/staging/rt2860/common/rtmp_init.c b/drivers/staging/rt2860/common/rtmp_init.c
index afeb528..3628e85 100644
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -749,7 +749,7 @@ void NICReadEEPROMParameters(struct rt_rtmp_adapter *pAd, u8 *mac_addr)
 		/*      pAd->PermanentAddress[5] = RandomByte(pAd)&0xf8; */
 
 		DBGPRINT_RAW(RT_DEBUG_TRACE,
-			("E2PROM MAC: =%pM\n", &pAd->PermanentAddress[0]));
+			("E2PROM MAC: =%pM\n", pAd->PermanentAddress));
 		if (pAd->bLocalAdminMAC == FALSE) {
 			MAC_DW0_STRUC csr2;
 			MAC_DW1_STRUC csr3;
@@ -767,7 +767,7 @@ void NICReadEEPROMParameters(struct rt_rtmp_adapter *pAd, u8 *mac_addr)
 			RTMP_IO_WRITE32(pAd, MAC_ADDR_DW1, csr3.word);
 			DBGPRINT_RAW(RT_DEBUG_TRACE,
 				("E2PROM MAC: =%pM\n",
-					&pAd->PermanentAddress[0]));
+					pAd->PermanentAddress));
 		}
 	}
 
diff --git a/drivers/staging/rt2860/sta/assoc.c b/drivers/staging/rt2860/sta/assoc.c
index 1efd75b..b7efb0b 100644
--- a/drivers/staging/rt2860/sta/assoc.c
+++ b/drivers/staging/rt2860/sta/assoc.c
@@ -795,7 +795,7 @@ void MlmeDisassocReqAction(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_ele
 
 	DBGPRINT(RT_DEBUG_TRACE,
 		("ASSOC - Send DISASSOC request[BSSID::%pM (Reason=%d)\n",
-			&pDisassocReq->Addr[0], pDisassocReq->Reason));
+			pDisassocReq->Addr, pDisassocReq->Reason));
 	MgtMacHeaderInit(pAd, &DisassocHdr, SUBTYPE_DISASSOC, 0, pDisassocReq->Addr, pDisassocReq->Addr);	/* patch peap ttls switching issue */
 	MakeOutgoingFrame(pOutBuffer, &FrameLen,
 			  sizeof(struct rt_header_802_11), &DisassocHdr,
diff --git a/drivers/staging/rt2860/sta/connect.c b/drivers/staging/rt2860/sta/connect.c
index 05b4af6..c380551 100644
--- a/drivers/staging/rt2860/sta/connect.c
+++ b/drivers/staging/rt2860/sta/connect.c
@@ -654,7 +654,7 @@ void CntlOidRTBssidProc(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *
 			   } */
 			/* No active association, join the BSS immediately */
 			DBGPRINT(RT_DEBUG_TRACE, ("CNTL - joining %pM ...\n",
-					&pOidBssid[0]));
+					pOidBssid));
 
 			JoinParmFill(pAd, &JoinReq, pAd->MlmeAux.BssIdx);
 			MlmeEnqueue(pAd, SYNC_STATE_MACHINE, MT2_MLME_JOIN_REQ,
@@ -777,7 +777,7 @@ void CntlWaitJoinProc(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *El
 				pAd->Mlme.CntlMachine.CurrState = CNTL_IDLE;
 				DBGPRINT(RT_DEBUG_TRACE,
 					("CNTL - join the IBSS = %pM ...\n",
-						&pAd->CommonCfg.Bssid[0]));
+						pAd->CommonCfg.Bssid));
 
 				pAd->IndicateMediaState =
 				    NdisMediaStateConnected;
@@ -896,7 +896,7 @@ void CntlWaitStartProc(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *E
 
 			DBGPRINT(RT_DEBUG_TRACE,
 				("CNTL - start a new IBSS = %pM ...\n",
-					&pAd->CommonCfg.Bssid[0]));
+					pAd->CommonCfg.Bssid));
 		} else {
 			DBGPRINT(RT_DEBUG_TRACE,
 				 ("CNTL - Start IBSS fail. BUG!\n"));
diff --git a/drivers/staging/rt2860/sta/sync.c b/drivers/staging/rt2860/sta/sync.c
index 3abc362..747d3c6 100644
--- a/drivers/staging/rt2860/sta/sync.c
+++ b/drivers/staging/rt2860/sta/sync.c
@@ -425,7 +425,7 @@ void MlmeJoinReqAction(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *E
 
 	DBGPRINT(RT_DEBUG_TRACE,
 		("SYNC - Switch to ch %d, Wait BEACON from %pM\n",
-			pBss->Channel, &pBss->Bssid[0]));
+			pBss->Channel, pBss->Bssid));
 
 	pAd->Mlme.SyncMachine.CurrState = JOIN_WAIT_BEACON;
 }
@@ -1226,7 +1226,7 @@ void PeerBeacon(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *Elem)
 					DBGPRINT(RT_DEBUG_TRACE,
 						("SYNC - merge to the IBSS "
 							"with bigger BSSID="
-							"%pM\n", &Bssid[0]));
+							"%pM\n", Bssid));
 					AsicDisableSync(pAd);
 					COPY_MAC_ADDR(pAd->CommonCfg.Bssid,
 						      Bssid);
diff --git a/drivers/staging/rt2860/sta_ioctl.c b/drivers/staging/rt2860/sta_ioctl.c
index bff7b0b..e095a44 100644
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -614,7 +614,7 @@ int rt_ioctl_siwap(struct net_device *dev,
 		    OID_802_11_BSSID,
 		    sizeof(NDIS_802_11_MAC_ADDRESS), (void *) & Bssid);
 
-	DBGPRINT(RT_DEBUG_TRACE, ("IOCTL::SIOCSIWAP %pM\n", &Bssid[0]));
+	DBGPRINT(RT_DEBUG_TRACE, ("IOCTL::SIOCSIWAP %pM\n", Bssid));
 
 	return 0;
 }
@@ -1512,7 +1512,7 @@ void getBaInfo(struct rt_rtmp_adapter *pAd, char *pOutBuf)
 		     && (pEntry->Sst == SST_ASSOC))
 		    || (pEntry->ValidAsWDS) || (pEntry->ValidAsMesh)) {
 			sprintf(pOutBuf + strlen(pOutBuf), "\n%pM (Aid = %d) "
-				"(AP) -\n", &pEntry->Addr[0], pEntry->Aid);
+				"(AP) -\n", pEntry->Addr, pEntry->Aid);
 
 			sprintf(pOutBuf, "%s[Recipient]\n", pOutBuf);
 			for (j = 0; j < NUM_OF_TID; j++) {
-- 
1.7.2.2

