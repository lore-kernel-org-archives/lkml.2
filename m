Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0ISJ3i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 05:29:38 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:55867 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab0ISJ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 05:28:46 -0400
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Lars Lindley <lindley@coyote.org>, Pavel Machek <pavel@ucw.cz>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: [PATCH 2/7] w35und: Remove remaining typedef declarations
Date: Sun, 19 Sep 2010 12:28:38 +0300
Message-Id: <1284888523-9625-2-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1284888523-9625-1-git-send-email-penberg@kernel.org>
References: <1284888523-9625-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes remaining typedef declarations from the w35und driver. Most
of them were unused so I just killed them off completely.

Cc: Lars Lindley <lindley@coyote.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Ruslan Pisarev <ruslan@rpisarev.org.ua>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/TODO             |    1 -
 drivers/staging/winbond/core.h           |    2 +-
 drivers/staging/winbond/mac_structures.h |   17 ---------
 drivers/staging/winbond/mds.c            |   34 +++++++++---------
 drivers/staging/winbond/mds_f.h          |    2 +-
 drivers/staging/winbond/mlme_s.h         |   32 +-----------------
 drivers/staging/winbond/mlmetxrx.c       |    5 ---
 drivers/staging/winbond/scan_s.h         |   53 ------------------------------
 drivers/staging/winbond/wb35rx.c         |    2 +-
 drivers/staging/winbond/wb35tx.c         |    2 +-
 drivers/staging/winbond/wbhal_s.h        |   37 ++++++++++-----------
 11 files changed, 41 insertions(+), 146 deletions(-)

diff --git a/drivers/staging/winbond/TODO b/drivers/staging/winbond/TODO
index 8c1baaf..43bee56 100644
--- a/drivers/staging/winbond/TODO
+++ b/drivers/staging/winbond/TODO
@@ -3,7 +3,6 @@ TODO:
 	- checkpatch cleanups
 	- kerneldoc cleanups
 	- fix severeCamelCaseInfestation
-	- remove typedefs
 	- remove unused ioctls
 	- use cfg80211 for regulatory stuff
 	- fix 4k stack problems
diff --git a/drivers/staging/winbond/core.h b/drivers/staging/winbond/core.h
index b87d6c0..2e9f02a 100644
--- a/drivers/staging/winbond/core.h
+++ b/drivers/staging/winbond/core.h
@@ -18,7 +18,7 @@ struct wbsoft_priv {
 	struct wb_local_para sLocalPara;	/* Myself connected
 							parameters */
 
-	MLME_FRAME sMlmeFrame;	/* connect to peerSTA parameters */
+	struct mlme_frame sMlmeFrame;	/* connect to peerSTA parameters */
 
 	struct wb35_mto_params sMtoPara;	/* MTO_struct ... */
 	struct hw_data sHwData;	/*For HAL */
diff --git a/drivers/staging/winbond/mac_structures.h b/drivers/staging/winbond/mac_structures.h
index 415256f..ed3df29 100644
--- a/drivers/staging/winbond/mac_structures.h
+++ b/drivers/staging/winbond/mac_structures.h
@@ -177,23 +177,6 @@ enum enum_MMPDUResultCode
 } WB_MMPDURESULTCODE, *PWB_MMPDURESULTCODE;
 */
 
-/*===========================================================
-// enum_TxRate --
-//   Define the transmission constants based on W89C32 MAC
-//   target specification.
-//===========================================================*/
-typedef enum enum_TxRate {
-    TXRATE_1M               = 0,
-    TXRATE_2MLONG           = 2,
-    TXRATE_2MSHORT          = 3,
-    TXRATE_55MLONG          = 4,
-    TXRATE_55MSHORT         = 5,
-    TXRATE_11MLONG          = 6,
-    TXRATE_11MSHORT         = 7,
-    TXRATE_AUTO             = 255           /* PD43 20021108 */
-} WB_TXRATE, *PWB_TXRATE;
-
-
 #define	RATE_BITMAP_1M				1
 #define	RATE_BITMAP_2M				2
 #define	RATE_BITMAP_5dot5M			5
diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index e8320a6..b6c0921 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -24,12 +24,12 @@ Mds_Destroy(struct wbsoft_priv *adapter)
 
 static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor *pDes,  u8 *buffer)
 {
-	PT00_DESCRIPTOR	pT00;
-	PT01_DESCRIPTOR	pT01;
+	struct T00_descriptor *pT00;
+	struct T01_descriptor *pT01;
 	u16	Duration, NextBodyLen, OffsetSize;
 	u8	Rate, i;
 	unsigned char	CTS_on = false, RTS_on = false;
-	PT00_DESCRIPTOR pNextT00;
+	struct T00_descriptor *pNextT00;
 	u16 BodyLen = 0;
 	unsigned char boGroupAddr = false;
 
@@ -39,9 +39,9 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 	if (!Rate)
 		Rate = 1;
 
-	pT00 = (PT00_DESCRIPTOR)buffer;
-	pT01 = (PT01_DESCRIPTOR)(buffer+4);
-	pNextT00 = (PT00_DESCRIPTOR)(buffer+OffsetSize);
+	pT00 = (struct T00_descriptor *)buffer;
+	pT01 = (struct T01_descriptor *)(buffer+4);
+	pNextT00 = (struct T00_descriptor *)(buffer+OffsetSize);
 
 	if( buffer[ DOT_11_DA_OFFSET+8 ] & 0x1 ) /* +8 for USB hdr */
 		boGroupAddr = true;
@@ -176,9 +176,9 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 			/* ----end 20061009 add by anson's endian */
 
 			buffer += OffsetSize;
-			pT01 = (PT01_DESCRIPTOR)(buffer+4);
+			pT01 = (struct T01_descriptor *)(buffer+4);
 			if (i != 1)	/* The last fragment will not have the next fragment */
-				pNextT00 = (PT00_DESCRIPTOR)(buffer+OffsetSize);
+				pNextT00 = (struct T00_descriptor *)(buffer+OffsetSize);
 		}
 
 		/*******************************************
@@ -219,7 +219,7 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 /* The function return the 4n size of usb pk */
 static u16 Mds_BodyCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *pDes, u8 *TargetBuffer)
 {
-	PT00_DESCRIPTOR	pT00;
+	struct T00_descriptor *pT00;
 	struct wb35_mds *pMds = &adapter->Mds;
 	u8	*buffer;
 	u8	*src_buffer;
@@ -234,9 +234,9 @@ static u16 Mds_BodyCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *pDe
 	SizeLeft = pDes->buffer_total_size;
 	buf_index = pDes->buffer_start_index;
 
-	pT00 = (PT00_DESCRIPTOR)buffer;
+	pT00 = (struct T00_descriptor *)buffer;
 	while (SizeLeft) {
-		pT00 = (PT00_DESCRIPTOR)buffer;
+		pT00 = (struct T00_descriptor *)buffer;
 		CopySize = SizeLeft;
 		if (SizeLeft > pDes->FragmentThreshold) {
 			CopySize = pDes->FragmentThreshold;
@@ -303,7 +303,7 @@ static u16 Mds_BodyCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *pDe
 		if (SizeLeft) {
 			buffer = TargetBuffer + Size; /* Get the next 4n start address */
 			memcpy( buffer, TargetBuffer, 32 ); /* Copy 8B USB +24B 802.11 */
-			pT00 = (PT00_DESCRIPTOR)buffer;
+			pT00 = (struct T00_descriptor *)buffer;
 			pT00->T00_first_mpdu = 0;
 		}
 
@@ -322,8 +322,8 @@ static void Mds_HeaderCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *
 {
 	struct wb35_mds *pMds = &adapter->Mds;
 	u8	*src_buffer = pDes->buffer_address[0]; /* 931130.5.g */
-	PT00_DESCRIPTOR	pT00;
-	PT01_DESCRIPTOR	pT01;
+	struct T00_descriptor *pT00;
+	struct T01_descriptor *pT01;
 	u16	stmp;
 	u8	i, ctmp1, ctmp2, ctmpf;
 	u16	FragmentThreshold = CURRENT_FRAGMENT_THRESHOLD;
@@ -333,9 +333,9 @@ static void Mds_HeaderCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *
 	/*
 	 * Set USB header 8 byte
 	 */
-	pT00 = (PT00_DESCRIPTOR)TargetBuffer;
+	pT00 = (struct T00_descriptor *)TargetBuffer;
 	TargetBuffer += 4;
-	pT01 = (PT01_DESCRIPTOR)TargetBuffer;
+	pT01 = (struct T01_descriptor *)TargetBuffer;
 	TargetBuffer += 4;
 
 	pT00->value = 0; /* Clear */
@@ -550,7 +550,7 @@ Mds_Tx(struct wbsoft_priv *adapter)
 }
 
 void
-Mds_SendComplete(struct wbsoft_priv *adapter, PT02_DESCRIPTOR pT02)
+Mds_SendComplete(struct wbsoft_priv *adapter, struct T02_descriptor *pT02)
 {
 	struct wb35_mds *pMds = &adapter->Mds;
 	struct hw_data *pHwData = &adapter->sHwData;
diff --git a/drivers/staging/winbond/mds_f.h b/drivers/staging/winbond/mds_f.h
index 20e97bf..7f68dea 100644
--- a/drivers/staging/winbond/mds_f.h
+++ b/drivers/staging/winbond/mds_f.h
@@ -7,7 +7,7 @@
 unsigned char Mds_initial(struct wbsoft_priv *adapter);
 void Mds_Destroy(struct wbsoft_priv *adapter);
 void Mds_Tx(struct wbsoft_priv *adapter);
-void Mds_SendComplete(struct wbsoft_priv *adapter, PT02_DESCRIPTOR pt02);
+void Mds_SendComplete(struct wbsoft_priv *adapter, struct T02_descriptor *pt02);
 void Mds_MpduProcess(struct wbsoft_priv *adapter, struct wb35_descriptor *prxdes);
 extern void DataDmp(u8 *pdata, u32 len, u32 offset);
 
diff --git a/drivers/staging/winbond/mlme_s.h b/drivers/staging/winbond/mlme_s.h
index a7ef3c7..d5b6364 100644
--- a/drivers/staging/winbond/mlme_s.h
+++ b/drivers/staging/winbond/mlme_s.h
@@ -132,7 +132,7 @@
 #define boMLME_IdleScanState(_BB_)	(_BB_->wState == IDLE_SCAN)
 #define boMLME_FoundSTAinfo(_CC_)	(_CC_->wState >= IDLE_SCAN)
 
-typedef struct _MLME_FRAME {
+struct mlme_frame {
 	s8		*pMMPDU;
 	u16		len;
 	u8		DataType;
@@ -155,34 +155,6 @@ typedef struct _MLME_FRAME {
 	u16		wNumRxMMPDUInMLME;	/* Number of the Rx MMPDU */
 	u16		reserved_1;		/*  in MLME. */
 						/*  excluding the discarded */
-} MLME_FRAME, *psMLME_FRAME;
-
-typedef struct _AUTHREQ {
-
-	u8		peerMACaddr[MAC_ADDR_LENGTH];
-	u16		wAuthAlgorithm;
-} MLME_AUTHREQ_PARA, *psMLME_AUTHREQ_PARA;
-
-typedef struct _ASSOCREQ {
-	u8		PeerSTAAddr[MAC_ADDR_LENGTH];
-	u16		CapabilityInfo;
-	u16		ListenInterval;
-} __attribute__ ((packed)) MLME_ASSOCREQ_PARA, *psMLME_ASSOCREQ_PARA;
-
-typedef struct _REASSOCREQ {
-	u8		NewAPAddr[MAC_ADDR_LENGTH];
-	u16		CapabilityInfo;
-	u16		ListenInterval;
-} __attribute__ ((packed)) MLME_REASSOCREQ_PARA, *psMLME_REASSOCREQ_PARA;
-
-typedef struct _MLMECALLBACK {
-	u8		*psFramePtr;
-	u8		bResult;
-} MLME_TXCALLBACK, *psMLME_TXCALLBACK;
-
-typedef struct _RXDATA {
-	s32		FrameLength;
-	u8		__attribute__ ((packed)) *pbFramePtr;
-} __attribute__ ((packed)) RXDATA, *psRXDATA;
+};
 
 #endif
diff --git a/drivers/staging/winbond/mlmetxrx.c b/drivers/staging/winbond/mlmetxrx.c
index dcd8a11..74488c2 100644
--- a/drivers/staging/winbond/mlmetxrx.c
+++ b/drivers/staging/winbond/mlmetxrx.c
@@ -76,15 +76,10 @@ static void MLMEfreeMMPDUBuffer(struct wbsoft_priv *adapter, s8 *pData)
 void
 MLME_SendComplete(struct wbsoft_priv *adapter, u8 PacketID, unsigned char SendOK)
 {
-	MLME_TXCALLBACK	TxCallback;
-
     /* Reclaim the data buffer */
 	adapter->sMlmeFrame.len = 0;
 	MLMEfreeMMPDUBuffer(adapter, adapter->sMlmeFrame.pMMPDU);
 
-
-	TxCallback.bResult = MLME_SUCCESS;
-
 	/* Return resource */
 	adapter->sMlmeFrame.IsInUsed = PACKET_FREE_TO_USE;
 }
diff --git a/drivers/staging/winbond/scan_s.h b/drivers/staging/winbond/scan_s.h
index 85e7523..85cdf3b 100644
--- a/drivers/staging/winbond/scan_s.h
+++ b/drivers/staging/winbond/scan_s.h
@@ -30,59 +30,6 @@
 #define ACTIVE_SCAN			0
 #define PASSIVE_SCAN			1
 
-/* Global data structures, Initial Scan & Background Scan */
-typedef struct _SCAN_REQ_PARA {	/* mandatory parameters for SCAN request */
-
-	u32			ScanType;	/* passive/active scan */
-
-	u8			reserved_1[2];
-
-	struct SSID_Element	sSSID; /* 34B. scan only for this SSID */
-	u8			reserved_2[2];
-
-} SCAN_REQ_PARA, *psSCAN_REQ_PARA;
-
-typedef struct _SCAN_PARAMETERS {
-	u16		wState;
-	u16		iCurrentChannelIndex;
-
-	SCAN_REQ_PARA	sScanReq;
-
-	u8		BSSID[MAC_ADDR_LENGTH + 2]; /* scan only for this BSSID */
-
-	u32		BssType;	/* scan only for this BSS type */
-
-	u16		ProbeDelay;
-	u16		MinChannelTime;
-
-	u16		MaxChannelTime;
-	u16		reserved_1;
-
-	s32		iBgScanPeriod;	/* XP: 5 sec */
-
-	u8		boBgScan;	/* Wb: enable BG scan, For XP, this value must be FALSE */
-	u8		boFastScan;	/* Wb: reserved */
-	u8		boCCAbusy;	/* Wb: HWMAC CCA busy status */
-	u8		reserved_2;
-
-	struct timer_list timer;
-
-	u32		ScanTimeStamp;	/* Increase 1 per background scan(1 minute) */
-	u32		BssTimeStamp;	/* Increase 1 per connect status check */
-	u32		RxNumPerAntenna[2];
-
-	u8		AntennaToggle;
-	u8		boInTimerHandler;
-	u8		boTimerActive;	/* Wb: reserved */
-	u8		boSave;
-
-	u32		BScanEnable; /* Background scan enable. Default is On */
-} SCAN_PARAMETERS, *psSCAN_PARAMETERS;
-
-/* Encapsulate 'adapter' data structure */
-#define psSCAN		(&(adapter->sScanPara))
-#define psSCANREQ	(&(adapter->sScanPara.sScanReq))
-
 /*
  * ===========================================================
  *	scan.h
diff --git a/drivers/staging/winbond/wb35rx.c b/drivers/staging/winbond/wb35rx.c
index efe82b1..448514a 100644
--- a/drivers/staging/winbond/wb35rx.c
+++ b/drivers/staging/winbond/wb35rx.c
@@ -160,7 +160,7 @@ static void Wb35Rx_Complete(struct urb *urb)
 	u32			SizeCheck;
 	u16			BulkLength;
 	u32			RxBufferId;
-	R00_DESCRIPTOR		R00;
+	struct R00_descriptor		R00;
 
 	/* Variable setting */
 	pWb35Rx->EP3vm_state = VM_COMPLETED;
diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
index bda7a91..2a9d055 100644
--- a/drivers/staging/winbond/wb35tx.c
+++ b/drivers/staging/winbond/wb35tx.c
@@ -210,7 +210,7 @@ static void Wb35Tx_EP2VM_complete(struct urb * pUrb)
 {
 	struct wbsoft_priv *adapter = pUrb->context;
 	struct hw_data *	pHwData = &adapter->sHwData;
-	T02_DESCRIPTOR	T02, TSTATUS;
+	struct T02_descriptor	T02, TSTATUS;
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 	u32 *		pltmp = (u32 *)pWb35Tx->EP2_buf;
 	u32		i;
diff --git a/drivers/staging/winbond/wbhal_s.h b/drivers/staging/winbond/wbhal_s.h
index 33457c2..821a1b3 100644
--- a/drivers/staging/winbond/wbhal_s.h
+++ b/drivers/staging/winbond/wbhal_s.h
@@ -105,7 +105,7 @@ enum {
 
 #define FLAG_BAND_RX_MASK		0x10000000 /* Bit 28 */
 
-typedef struct _R00_DESCRIPTOR {
+struct R00_descriptor {
 	union {
 		u32	value;
 #ifdef _BIG_ENDIAN_
@@ -126,9 +126,9 @@ typedef struct _R00_DESCRIPTOR {
 		};
 #endif
 	};
-} R00_DESCRIPTOR, *PR00_DESCRIPTOR;
+};
 
-typedef struct _T00_DESCRIPTOR {
+struct T00_descriptor {
 	union {
 		u32	value;
 #ifdef _BIG_ENDIAN_
@@ -157,9 +157,9 @@ typedef struct _T00_DESCRIPTOR {
 		};
 #endif
 	};
-} T00_DESCRIPTOR, *PT00_DESCRIPTOR;
+};
 
-typedef struct _R01_DESCRIPTOR {
+struct R01_descriptor {
 	union {
 		u32	value;
 #ifdef _BIG_ENDIAN_
@@ -208,9 +208,9 @@ typedef struct _R01_DESCRIPTOR {
 		};
 #endif
 	};
-} R01_DESCRIPTOR, *PR01_DESCRIPTOR;
+};
 
-typedef struct _T01_DESCRIPTOR {
+struct T01_descriptor {
 	union {
 		u32	value;
 #ifdef _BIG_ENDIAN_
@@ -245,9 +245,9 @@ typedef struct _T01_DESCRIPTOR {
 		};
 #endif
 	};
-} T01_DESCRIPTOR, *PT01_DESCRIPTOR;
+};
 
-typedef struct _T02_DESCRIPTOR {
+struct T02_descriptor {
 	union {
 		u32	value;
 #ifdef _BIG_ENDIAN_
@@ -290,7 +290,7 @@ typedef struct _T02_DESCRIPTOR {
 		};
 #endif
 	};
-} T02_DESCRIPTOR, *PT02_DESCRIPTOR;
+};
 
 struct wb35_descriptor { /* Skip length = 8 DWORD */
 	/* ID for descriptor ---, The field doesn't be cleard in the operation of Descriptor definition */
@@ -309,20 +309,20 @@ struct wb35_descriptor { /* Skip length = 8 DWORD */
 
 	/* For R00 and T00 ------------------------------ */
 	union {
-		R00_DESCRIPTOR	R00;
-		T00_DESCRIPTOR	T00;
+		struct R00_descriptor	R00;
+		struct T00_descriptor	T00;
 	};
 
 	/* For R01 and T01 ------------------------------ */
 	union {
-		R01_DESCRIPTOR	R01;
-		T01_DESCRIPTOR	T01;
+		struct R01_descriptor	R01;
+		struct T01_descriptor	T01;
 	};
 
 	/* For R02 and T02 ------------------------------ */
 	union {
 		u32		R02;
-		T02_DESCRIPTOR	T02;
+		struct T02_descriptor	T02;
 	};
 
 	/* For R03 and T03 ------------------------------ */
@@ -348,11 +348,10 @@ struct wb35_descriptor { /* Skip length = 8 DWORD */
 #define MAX_TXVGA_EEPROM		9	/* How many word(u16) of EEPROM will be used for TxVGA */
 #define MAX_RF_PARAMETER		32
 
-typedef struct _TXVGA_FOR_50 {
+struct txvga_for_50 {
 	u8	ChanNo;
 	u8	TxVgaValue;
-} TXVGA_FOR_50;
-
+};
 
 /*
  * ==============================================
@@ -479,7 +478,7 @@ struct hw_data {
 
 	u8			TxVgaSettingInEEPROM[(((MAX_TXVGA_EEPROM * 2) + 3) & ~0x03)]; /* For EEPROM value */
 	u8			TxVgaFor24[16]; /* Max is 14, 2 for alignment */
-	TXVGA_FOR_50		TxVgaFor50[36];	/* 35 channels in 5G. 35x2 = 70 byte. 2 for alignments */
+	struct txvga_for_50		TxVgaFor50[36];	/* 35 channels in 5G. 35x2 = 70 byte. 2 for alignments */
 
 	u16			Scan_Interval;
 	u16			RESERVED6;
-- 
1.6.3.3

