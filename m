Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab0CRPpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 11:45:10 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:45232 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab0CRPpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 11:45:08 -0400
X-SENDER-IP: [83.226.250.86]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmZBAB7noUtT4vpWPGdsb2JhbACHYJNMDAEBAQE3LawIjWyEeQQ
X-IronPort-AV: E=Sophos;i="4.51,267,1267398000"; 
   d="scan'208";a="52716543"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: winbond: mlme_s.h Coding style fixes
Date: Thu, 18 Mar 2010 16:45:06 +0100
Message-Id: <1268927106-12321-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed all problems found by checkpatch.pl except typedefs.

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/winbond/mlme_s.h |  288 ++++++++++++++++++-------------------
 1 files changed, 140 insertions(+), 148 deletions(-)

diff --git a/drivers/staging/winbond/mlme_s.h b/drivers/staging/winbond/mlme_s.h
index 1217a1c..a7ef3c7 100644
--- a/drivers/staging/winbond/mlme_s.h
+++ b/drivers/staging/winbond/mlme_s.h
@@ -7,28 +7,29 @@
 #include "mac_structures.h"
 #include "mds_s.h"
 
-//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-//	Mlme.h
-//		Define the related definitions of MLME module
-//	history -- 01/14/03' created
-//
-//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-
-#define AUTH_REJECT_REASON_CHALLENGE_FAIL		1
-
-//====== the state of MLME module
-#define INACTIVE			0x0
-#define IDLE_SCAN			0x1
-
-//====== the state of MLME/ESS module
-#define STATE_1				0x2
-#define AUTH_REQ			0x3
-#define AUTH_WEP			0x4
-#define STATE_2				0x5
-#define ASSOC_REQ			0x6
-#define STATE_3				0x7
-
-//====== the state of MLME/IBSS module
+/*
+ * +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ *	Mlme.h
+ *		Define the related definitions of MLME module
+ *
+ * +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ */
+
+#define AUTH_REJECT_REASON_CHALLENGE_FAIL	1
+
+/* the state of MLME module */
+#define INACTIVE		0x0
+#define IDLE_SCAN		0x1
+
+/* the state of MLME/ESS module */
+#define STATE_1			0x2
+#define AUTH_REQ		0x3
+#define AUTH_WEP		0x4
+#define STATE_2			0x5
+#define ASSOC_REQ		0x6
+#define STATE_3			0x7
+
+/* the state of MLME/IBSS module */
 #define IBSS_JOIN_SYNC		0x8
 #define IBSS_AUTH_REQ		0x9
 #define IBSS_AUTH_CHANLGE	0xa
@@ -38,159 +39,150 @@
 
 
 
-//=========================================
-//depend on D5C(MAC timing control 03 register): MaxTxMSDULifeTime default 0x80000us
-#define AUTH_FAIL_TIMEOUT		550
-#define ASSOC_FAIL_TIMEOUT		550
+/*
+ * =========================================
+ * depend on D5C(MAC timing control 03 register):
+ * MaxTxMSDULifeTime default 0x80000us
+ */
+#define AUTH_FAIL_TIMEOUT	550
+#define ASSOC_FAIL_TIMEOUT	550
 #define REASSOC_FAIL_TIMEOUT	550
 
-
-
-//
-// MLME task global CONSTANTS, STRUCTURE, variables
-//
-
-
-/////////////////////////////////////////////////////////////
-//  enum_ResultCode --
-//  Result code returned from MLME to SME.
-//
-/////////////////////////////////////////////////////////////
-// PD43 20030829 Modifiled
-//#define	SUCCESS								0
-#define MLME_SUCCESS                        0 //follow spec.
-#define	INVALID_PARAMETERS					1 //Not following spec.
-#define	NOT_SUPPPORTED						2
-#define	TIMEOUT								3
-#define	TOO_MANY_SIMULTANEOUS_REQUESTS		4
-#define REFUSED								5
-#define	BSS_ALREADY_STARTED_OR_JOINED		6
-#define	TRANSMIT_FRAME_FAIL					7
-#define	NO_BSS_FOUND						8
-#define RETRY								9
-#define GIVE_UP								10
-
-
-#define OPEN_AUTH							0
-#define SHARE_AUTH							1
-#define ANY_AUTH							2
-#define WPA_AUTH							3	//for WPA
-#define WPAPSK_AUTH							4
-#define WPANONE_AUTH						5
-///////////////////////////////////////////// added by ws 04/19/04
+/* MLME task global CONSTANTS, STRUCTURE, variables */
+
+/* =========================================
+ * enum_ResultCode --
+ * Result code returned from MLME to SME.
+ * =========================================
+ */
+#define MLME_SUCCESS			0	/* follow spec. */
+#define	INVALID_PARAMETERS		1	/* Not following spec. */
+#define	NOT_SUPPPORTED			2
+#define	TIMEOUT				3
+#define	TOO_MANY_SIMULTANEOUS_REQUESTS	4
+#define REFUSED				5
+#define	BSS_ALREADY_STARTED_OR_JOINED	6
+#define	TRANSMIT_FRAME_FAIL		7
+#define	NO_BSS_FOUND			8
+#define RETRY				9
+#define GIVE_UP				10
+
+
+#define OPEN_AUTH			0
+#define SHARE_AUTH			1
+#define ANY_AUTH			2
+#define WPA_AUTH			3	/* for WPA */
+#define WPAPSK_AUTH			4
+#define WPANONE_AUTH			5
 #ifdef _WPA2_
-#define WPA2_AUTH                           6//for WPA2
-#define WPA2PSK_AUTH                        7
-#endif //end def _WPA2_
-
-//////////////////////////////////////////////////////////////////
-//define the msg type of MLME module
-//////////////////////////////////////////////////////////////////
-//--------------------------------------------------------
-//from SME
-
-#define MLMEMSG_AUTH_REQ				0x0b
-#define MLMEMSG_DEAUTH_REQ				0x0c
-#define MLMEMSG_ASSOC_REQ				0x0d
-#define MLMEMSG_REASSOC_REQ				0x0e
-#define MLMEMSG_DISASSOC_REQ			0x0f
-#define MLMEMSG_START_IBSS_REQ			0x10
-#define MLMEMSG_IBSS_NET_CFM			0x11
-
-//from RX :
-#define MLMEMSG_RCV_MLMEFRAME			0x20
-#define MLMEMSG_RCV_ASSOCRSP			0x22
-#define MLMEMSG_RCV_REASSOCRSP			0x24
-#define MLMEMSG_RCV_DISASSOC			0x2b
-#define MLMEMSG_RCV_AUTH				0x2c
-#define MLMEMSG_RCV_DEAUTH				0x2d
-
-
-//from TX callback
-#define MLMEMSG_TX_CALLBACK				0x40
-#define MLMEMSG_ASSOCREQ_CALLBACK		0x41
-#define MLMEMSG_REASSOCREQ_CALLBACK		0x43
-#define MLMEMSG_DISASSOC_CALLBACK		0x4a
-#define MLMEMSG_AUTH_CALLBACK			0x4c
-#define MLMEMSG_DEAUTH_CALLBACK			0x4d
-
-//#define MLMEMSG_JOIN_FAIL				4
-//#define MLMEMSG_AUTHEN_FAIL			18
-#define MLMEMSG_TIMEOUT					0x50
-
-///////////////////////////////////////////////////////////////////////////
-//Global data structures
-#define MAX_NUM_TX_MMPDU	2
-#define MAX_MMPDU_SIZE		1512
-#define MAX_NUM_RX_MMPDU	6
-
-
-///////////////////////////////////////////////////////////////////////////
-//MACRO
-#define boMLME_InactiveState(_AA_)	(_AA_->wState==INACTIVE)
-#define boMLME_IdleScanState(_BB_)	(_BB_->wState==IDLE_SCAN)
-#define boMLME_FoundSTAinfo(_CC_)	(_CC_->wState>=IDLE_SCAN)
-
-typedef struct _MLME_FRAME
-{
-	//NDIS_PACKET		MLME_Packet;
-	s8 *			pMMPDU;
-	u16			len;
-	u8			DataType;
-	u8			IsInUsed;
+#define WPA2_AUTH			6	/* for WPA2 */
+#define WPA2PSK_AUTH			7
+#endif /* end def _WPA2_ */
+
+/*
+ * =========================================
+ * define the msg type of MLME module
+ * =========================================
+ */
+
+/* from SME */
+#define MLMEMSG_AUTH_REQ		0x0b
+#define MLMEMSG_DEAUTH_REQ		0x0c
+#define MLMEMSG_ASSOC_REQ		0x0d
+#define MLMEMSG_REASSOC_REQ		0x0e
+#define MLMEMSG_DISASSOC_REQ		0x0f
+#define MLMEMSG_START_IBSS_REQ		0x10
+#define MLMEMSG_IBSS_NET_CFM		0x11
+
+/* from RX */
+#define MLMEMSG_RCV_MLMEFRAME		0x20
+#define MLMEMSG_RCV_ASSOCRSP		0x22
+#define MLMEMSG_RCV_REASSOCRSP		0x24
+#define MLMEMSG_RCV_DISASSOC		0x2b
+#define MLMEMSG_RCV_AUTH		0x2c
+#define MLMEMSG_RCV_DEAUTH		0x2d
+
+
+/* from TX callback */
+#define MLMEMSG_TX_CALLBACK		0x40
+#define MLMEMSG_ASSOCREQ_CALLBACK	0x41
+#define MLMEMSG_REASSOCREQ_CALLBACK	0x43
+#define MLMEMSG_DISASSOC_CALLBACK	0x4a
+#define MLMEMSG_AUTH_CALLBACK		0x4c
+#define MLMEMSG_DEAUTH_CALLBACK		0x4d
+
+#define MLMEMSG_TIMEOUT			0x50
+
+/*
+ * ==============================================
+ * Global data structures
+ * ==============================================
+ */
+#define MAX_NUM_TX_MMPDU		2
+#define MAX_MMPDU_SIZE			1512
+#define MAX_NUM_RX_MMPDU		6
+
+
+/*
+ * ==============================================
+ * MACRO
+ * ==============================================
+ */
+#define boMLME_InactiveState(_AA_)	(_AA_->wState == INACTIVE)
+#define boMLME_IdleScanState(_BB_)	(_BB_->wState == IDLE_SCAN)
+#define boMLME_FoundSTAinfo(_CC_)	(_CC_->wState >= IDLE_SCAN)
+
+typedef struct _MLME_FRAME {
+	s8		*pMMPDU;
+	u16		len;
+	u8		DataType;
+	u8		IsInUsed;
 
 	spinlock_t	MLMESpinLock;
 
-    u8		TxMMPDU[MAX_NUM_TX_MMPDU][MAX_MMPDU_SIZE];
-	u8		TxMMPDUInUse[ (MAX_NUM_TX_MMPDU+3) & ~0x03 ];
+	u8		TxMMPDU[MAX_NUM_TX_MMPDU][MAX_MMPDU_SIZE];
+	u8		TxMMPDUInUse[(MAX_NUM_TX_MMPDU + 3) & ~0x03];
 
 	u16		wNumTxMMPDU;
 	u16		wNumTxMMPDUDiscarded;
 
-    u8		RxMMPDU[MAX_NUM_RX_MMPDU][MAX_MMPDU_SIZE];
-    u8	 	SaveRxBufSlotInUse[ (MAX_NUM_RX_MMPDU+3) & ~0x03 ];
+	u8		RxMMPDU[MAX_NUM_RX_MMPDU][MAX_MMPDU_SIZE];
+	u8		SaveRxBufSlotInUse[(MAX_NUM_RX_MMPDU + 3) & ~0x03];
 
 	u16		wNumRxMMPDU;
 	u16		wNumRxMMPDUDiscarded;
 
-	u16		wNumRxMMPDUInMLME; 	// Number of the Rx MMPDU
-	u16		reserved_1;			//  in MLME.
-                    	            //  excluding the discarded
+	u16		wNumRxMMPDUInMLME;	/* Number of the Rx MMPDU */
+	u16		reserved_1;		/*  in MLME. */
+						/*  excluding the discarded */
 } MLME_FRAME, *psMLME_FRAME;
 
 typedef struct _AUTHREQ {
 
-	u8 	peerMACaddr[MAC_ADDR_LENGTH];
-	u16	wAuthAlgorithm;
-
+	u8		peerMACaddr[MAC_ADDR_LENGTH];
+	u16		wAuthAlgorithm;
 } MLME_AUTHREQ_PARA, *psMLME_AUTHREQ_PARA;
 
 typedef struct _ASSOCREQ {
-  u8       PeerSTAAddr[MAC_ADDR_LENGTH];
-  u16       CapabilityInfo;
-  u16       ListenInterval;
-
-}__attribute__ ((packed)) MLME_ASSOCREQ_PARA, *psMLME_ASSOCREQ_PARA;
+	u8		PeerSTAAddr[MAC_ADDR_LENGTH];
+	u16		CapabilityInfo;
+	u16		ListenInterval;
+} __attribute__ ((packed)) MLME_ASSOCREQ_PARA, *psMLME_ASSOCREQ_PARA;
 
 typedef struct _REASSOCREQ {
-  u8       NewAPAddr[MAC_ADDR_LENGTH];
-  u16       CapabilityInfo;
-  u16       ListenInterval;
-
-}__attribute__ ((packed)) MLME_REASSOCREQ_PARA, *psMLME_REASSOCREQ_PARA;
+	u8		NewAPAddr[MAC_ADDR_LENGTH];
+	u16		CapabilityInfo;
+	u16		ListenInterval;
+} __attribute__ ((packed)) MLME_REASSOCREQ_PARA, *psMLME_REASSOCREQ_PARA;
 
 typedef struct _MLMECALLBACK {
-
-  u8 	*psFramePtr;
-  u8		bResult;
-
+	u8		*psFramePtr;
+	u8		bResult;
 } MLME_TXCALLBACK, *psMLME_TXCALLBACK;
 
-typedef struct _RXDATA
-{
+typedef struct _RXDATA {
 	s32		FrameLength;
-	u8	__attribute__ ((packed)) *pbFramePtr;
-
-}__attribute__ ((packed)) RXDATA, *psRXDATA;
+	u8		__attribute__ ((packed)) *pbFramePtr;
+} __attribute__ ((packed)) RXDATA, *psRXDATA;
 
 #endif
-- 
1.7.0.2

