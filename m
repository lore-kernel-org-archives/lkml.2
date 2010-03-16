Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab0CPMol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 08:44:41 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:50133 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab0CPMoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 08:44:39 -0400
X-SENDER-IP: [83.226.249.95]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AitDAPkZn0tT4vlfPGdsb2JhbACHYZMcDAEBAQE3LasujWiEfAQ
X-IronPort-AV: E=Sophos;i="4.49,650,1262559600"; 
   d="scan'208";a="51033550"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, greg@kroah.com, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: winbond: mac_structures.h Fix remaining whitespace and comment issues.
Date: Tue, 16 Mar 2010 13:44:33 +0100
Message-Id: <1268743473-3493-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <20100315191804.GA23292@elf.ucw.cz>
References: <20100315191804.GA23292@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed the things Pavel Machek commented on my last patch.
Removed rev. history and comments, fixed some ind. and ws. I missed and
removed "commented out" code.
This patch applies after the old one: Message-Id:
<1268674900-9663-1-git-send-email-lindley@coyote.org>

Signed-off-by: Lars Lindley <lindley@coyote.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/staging/winbond/mac_structures.h |  177 +++++++++++-------------------
 1 files changed, 64 insertions(+), 113 deletions(-)

diff --git a/drivers/staging/winbond/mac_structures.h b/drivers/staging/winbond/mac_structures.h
index ebef821..eadd106 100644
--- a/drivers/staging/winbond/mac_structures.h
+++ b/drivers/staging/winbond/mac_structures.h
@@ -1,22 +1,9 @@
-/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
- * MAC_Structures.h
- *
- * This file contains the definitions and data structures used by SW-MAC.
+/*
+ * =================================================
+ *  MAC_Structures.h
  *
- * Revision Histoy
- * =================
- * 0.1      2002        UN00
- * 0.2      20021004    PD43 CCLiu6
- *          20021018    PD43 CCLiu6
- *                      Add enum_TxRate type
- *                      Modify enum_STAState type
- * 0.3      20021023    PE23 CYLiu update MAC session struct
- *          20021108
- *          20021122    PD43 Austin
- *                      Deleted some unused.
- *          20021129    PD43 Austin
- *			20030617	increase the 802.11g definition
- * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ *  This file contains the definitions and data structures used by SW-MAC.
+ * =================================================
  */
 
 #ifndef _MAC_Structures_H_
@@ -28,7 +15,7 @@
 #define MAX_CHANNELS				30
 #define MAC_ADDR_LENGTH				6
 #define MAX_WEP_KEY_SIZE			16  /* 128 bits */
-#define	MAX_802_11_FRAGMENT_NUMBER		10  /* By spec */
+#define MAX_802_11_FRAGMENT_NUMBER		10  /* By spec */
 
 /*----- 802.11 Frame define */
 #define MASK_PROTOCOL_VERSION_TYPE		0x0F
@@ -39,8 +26,10 @@
 #define DOT_11_SNAP_SIZE			6
 #define DOT_11_DURATION_OFFSET			2
 #define DOT_11_SEQUENCE_OFFSET			22 /* Sequence control offset */
-#define DOT_11_TYPE_OFFSET			30 /* The start offset
-						    * of 802.11 Frame */
+#define DOT_11_TYPE_OFFSET			30 /*
+						    * The start offset
+						    * of 802.11 Frame
+						    */
 #define DOT_11_DATA_OFFSET			24
 #define DOT_11_DA_OFFSET			4
 #define DOT_3_TYPE_ARP				0x80F3
@@ -97,7 +86,8 @@
 #define ELEMENT_ID_IBSS_PARAMETER_SET		6
 /* 7~15 reserverd */
 #define ELEMENT_ID_CHALLENGE_TEXT		16
-/* 17~31 reserved for challenge text extension
+/*
+ * 17~31 reserved for challenge text extension
  * 32~255 reserved
  * --  11G  --
  */
@@ -146,40 +136,10 @@ typedef enum enum_PowerManagementMode {
 #define REASON_UNSUPPORTED_RSNIE_VERSION	21
 #define REASON_INVALID_RSNIE_CAPABILITY		22
 #define REASON_802_1X_AUTH_FAIL			23
-#define	REASON_CIPHER_REJECT_PER_SEC_POLICY	14
+#define REASON_CIPHER_REJECT_PER_SEC_POLICY	14
 
 /*
-// *===========================================================
-// * enum_MMPDUResultCode --
-// *   Status code (2 Octs) in the MMPDU's frame body. Table.19
-// *
-// *===========================================================
-enum enum_MMPDUResultCode
-{
-	// SUCCESS   = 0,      **** Redefined
-	UNSPECIFIED_FAILURE				= 1,
-
-	// 2 - 9 Reserved
-
-	NOT_SUPPROT_CAPABILITIES			= 10,
-
-	// REASSOCIATION_DENIED
-
-	REASSOC_DENIED_UNABLE_CFM_ASSOC_EXIST		= 11,
-
-	// ASSOCIATION_DENIED_NOT_IN_STANDARD
-
-	ASSOC_DENIED_REASON_NOT_IN_STANDARD		= 12,
-	PEER_NOT_SUPPORT_AUTH_ALGORITHM			= 13,
-	AUTH_SEQNUM_OUT_OF_EXPECT			= 14,
-	AUTH_REJECT_REASON_CHALLENGE_FAIL		= 15,
-	AUTH_REJECT_REASON_WAIT_TIMEOUT			= 16,
-	ASSOC_DENIED_REASON_AP_BUSY			= 17,
-	ASSOC_DENIED_REASON_NOT_SUPPORT_BASIC_RATE	= 18
-} WB_MMPDURESULTCODE, *PWB_MMPDURESULTCODE;
-*/
-
-/* ===========================================================
+ * ===========================================================
  * enum_TxRate --
  *   Define the transmission constants based on W89C32 MAC
  *   target specification.
@@ -193,13 +153,13 @@ typedef enum enum_TxRate {
 	TXRATE_55MSHORT		= 5,
 	TXRATE_11MLONG		= 6,
 	TXRATE_11MSHORT		= 7,
-	TXRATE_AUTO		= 255           /* PD43 20021108 */
+	TXRATE_AUTO		= 255
 } WB_TXRATE, *PWB_TXRATE;
 
 
-#define	RATE_BITMAP_1M				1
-#define	RATE_BITMAP_2M				2
-#define	RATE_BITMAP_5dot5M			5
+#define RATE_BITMAP_1M				1
+#define RATE_BITMAP_2M				2
+#define RATE_BITMAP_5dot5M			5
 #define RATE_BITMAP_6M				6
 #define RATE_BITMAP_9M				9
 #define RATE_BITMAP_11M				11
@@ -245,7 +205,7 @@ typedef enum enum_TxRate {
 struct Capability_Information_Element {
 	union {
 		u16 __attribute__ ((packed)) wValue;
-		#ifdef _BIG_ENDIAN_  /* 20060926 add by anson's endian */
+		#ifdef _BIG_ENDIAN_
 		struct _Capability {
 			/* --  11G  -- */
 			u8	Reserved3:2;
@@ -341,8 +301,6 @@ struct Challenge_Text_Element {
 };
 
 struct PHY_Parameter_Set_Element {
-/*	int	aSlotTime; */
-/*	int	aSifsTime; */
 	s32	aCCATime;
 	s32	aRxTxTurnaroundTime;
 	s32	aTxPLCPDelay;
@@ -358,16 +316,14 @@ struct PHY_Parameter_Set_Element {
 	s32	aPLCPHeaderLength;
 	s32	aMPDUDurationFactor;
 	s32	aMPDUMaxLength;
-/*	int	aCWmin; */
-/*	int	aCWmax; */
 };
 
 /* --  11G  -- */
 struct ERP_Information_Element {
 	u8	Element_ID;
 	u8	Length;
-	#ifdef _BIG_ENDIAN_ /* 20060926 add by anson's endian */
-		u8	Reserved:5;   /* 20060926 add by anson */
+	#ifdef _BIG_ENDIAN_
+		u8	Reserved:5;
 		u8	Barker_Preamble_Mode:1;
 		u8	Use_Protection:1;
 		u8	NonERP_Present:1;
@@ -386,33 +342,34 @@ struct Extended_Supported_Rates_Element {
 } __attribute__ ((packed));
 
 /* WPA(802.11i draft 3.0) */
-#define VERSION_WPA			1
-#ifdef _WPA2_
-#define VERSION_WPA2			1
-#endif /* end def  _WPA2_ */
-#define OUI_WPA				0x00F25000	/* WPA2.0 OUI=00:50:F2,
+#define	VERSION_WPA			1
+#ifdef	_WPA2_
+#define	VERSION_WPA2			1
+#endif /* end def _WPA2_ */
+#define	OUI_WPA				0x00F25000	/*
+							 * WPA2.0 OUI=00:50:F2,
 							 * the MSB is reserved
 							 * for suite type
 							 */
 #ifdef _WPA2_
-#define OUI_WPA2			0x00AC0F00	/* for wpa2 change to
-							 * 0x00ACOF04 by Ws
-							 * 26/04/04
+#define OUI_WPA2			0x00AC0F00	/*
+							 * for wpa2 change to
+							 * 0x00ACOF04
 							 */
 #endif /* end def _WPA2_ */
 
 #define OUI_WPA_ADDITIONAL		0x01
-#define WLAN_MIN_RSN_WPA_LENGTH		6 /* added by ws 09/10/04 */
+#define WLAN_MIN_RSN_WPA_LENGTH		6
 #ifdef _WPA2_
-#define WLAN_MIN_RSN_WPA2_LENGTH	2 /* Fix to 2 09/14/05 */
+#define WLAN_MIN_RSN_WPA2_LENGTH	2
 #endif /* end def _WPA2_ */
 
-#define oui_wpa			(u32)(OUI_WPA|OUI_WPA_ADDITIONAL)
+#define oui_wpa			(u32)(OUI_WPA | OUI_WPA_ADDITIONAL)
 
-#define WPA_OUI_BIG		((u32) 0x01F25000)/* added by ws 09/23/04 */
-#define WPA_OUI_LITTLE		((u32) 0x01F25001)/* added by ws 09/23/04 */
+#define WPA_OUI_BIG		((u32) 0x01F25000)
+#define WPA_OUI_LITTLE		((u32) 0x01F25001)
 
-#define WPA_WPS_OUI		cpu_to_le32(0x04F25000) /* 20061108 For WPS.
+#define WPA_WPS_OUI		cpu_to_le32(0x04F25000) /*
 							 * It's little endian.
 							 * Big endian is
 							 * 0x0050F204
@@ -420,16 +377,16 @@ struct Extended_Supported_Rates_Element {
 
 /* -----WPA2----- */
 #ifdef _WPA2_
-#define WPA2_OUI_BIG		((u32)0x01AC0F00)
-#define WPA2_OUI_LITTLE		((u32)0x01AC0F01)
+#define WPA2_OUI_BIG		((u32) 0x01AC0F00)
+#define WPA2_OUI_LITTLE		((u32) 0x01AC0F01)
 #endif /* end def _WPA2_ */
 
-/*Authentication suite*/
+/* Authentication suite */
 #define OUI_AUTH_WPA_NONE	0x00 /* for WPA_NONE */
 #define OUI_AUTH_8021X		0x01
 #define OUI_AUTH_PSK		0x02
 /* Cipher suite */
-#define OUI_CIPHER_GROUP_KEY	0x00 /* added by ws 05/21/04 */
+#define OUI_CIPHER_GROUP_KEY	0x00
 #define OUI_CIPHER_WEP_40	0x01
 #define OUI_CIPHER_TKIP		0x02
 #define OUI_CIPHER_CCMP		0x04
@@ -449,7 +406,8 @@ typedef struct _SUITE_SELECTOR_ {
 struct	RSN_Information_Element {
 	u8		Element_ID;
 	u8		Length;
-	SUITE_SELECTOR	OuiWPAAdditional;/* WPA version 2.0 additional field,
+	SUITE_SELECTOR	OuiWPAAdditional;/*
+					  * WPA version 2.0 additional field,
 					  * and should be 00:50:F2:01
 					  */
 	u16		Version;
@@ -467,9 +425,9 @@ struct RSN_Auth_Sub_Information_Element {
 struct RSN_Capability_Element {
   union {
 	u16	__attribute__ ((packed))	wValue;
-	#ifdef _BIG_ENDIAN_	 /* 20060927 add by anson's endian */
+	#ifdef _BIG_ENDIAN_
 	struct _RSN_Capability {
-		u16   __attribute__ ((packed))  Reserved2:8; /* 20051201 */
+		u16   __attribute__ ((packed))  Reserved2:8;
 		u16   __attribute__ ((packed))  Reserved1:2;
 		u16   __attribute__ ((packed))  GTK_Replay_Counter:2;
 		u16   __attribute__ ((packed))  PTK_Replay_Counter:2;
@@ -483,7 +441,7 @@ struct RSN_Capability_Element {
 		u16   __attribute__ ((packed))  PTK_Replay_Counter:2;
 		u16   __attribute__ ((packed))  GTK_Replay_Counter:2;
 		u16   __attribute__ ((packed))  Reserved1:2;
-		u16   __attribute__ ((packed))  Reserved2:8; /* 20051201 */
+		u16   __attribute__ ((packed))  Reserved2:8;
 	} __attribute__ ((packed))  RSN_Capability;
 	#endif
   } __attribute__ ((packed));
@@ -494,7 +452,7 @@ typedef struct _PMKID {
 	u8	pValue[16];
 } PMKID;
 
-struct	WPA2_RSN_Information_Element {
+struct WPA2_RSN_Information_Element {
 	u8			Element_ID;
 	u8			Length;
 	u16			Version;
@@ -514,15 +472,18 @@ struct PMKID_Information_Element {
 } __attribute__ ((packed));
 
 #endif /* enddef _WPA2_ */
-/* ============================================================
+
+/*
+ * ============================================================
  * MAC Frame structure (different type) and subfield structure
  * ============================================================
  */
 struct MAC_frame_control {
-	u8	mac_frame_info; /* a combination of the [Protocol Version,
+	u8	mac_frame_info; /*
+				 * a combination of the [Protocol Version,
 				 * Control Type, Control Subtype]
 				 */
-	#ifdef _BIG_ENDIAN_	/* 20060927 add by anson's endian */
+	#ifdef _BIG_ENDIAN_
 	u8	order:1;
 	u8	WEP:1;
 	u8	more_data:1;
@@ -544,8 +505,9 @@ struct MAC_frame_control {
 } __attribute__ ((packed));
 
 struct Management_Frame {
-	struct MAC_frame_control frame_control; /* 2B, ToDS,FromDS,MoreFrag,
-						 * MoreData,Order=0
+	struct MAC_frame_control frame_control; /*
+						 * 2B, ToDS, FromDS, MoreFrag,
+						 * MoreData, Order = 0
 						 */
 	u16	duration;
 	u8	DA[MAC_ADDR_LENGTH];			/* Addr1 */
@@ -558,8 +520,10 @@ struct Management_Frame {
 
 /* SW-MAC don't Tx/Rx Control-Frame, HW-MAC do it. */
 struct Control_Frame {
-	struct MAC_frame_control frame_control; /* ToDS,FromDS,MoreFrag,Retry,
-						 * MoreData,WEP,Order=0
+	struct MAC_frame_control frame_control; /*
+						 * ToDS, FromDS, MoreFrag,
+						 * Retry, MoreData, WEP,
+						 * Order = 0
 						 */
 	u16	duration;
 	u8	RA[MAC_ADDR_LENGTH];
@@ -574,7 +538,7 @@ struct Data_Frame {
 	u8	Addr2[MAC_ADDR_LENGTH];
 	u8	Addr3[MAC_ADDR_LENGTH];
 	u16	Sequence_Control;
-	u8	Addr4[MAC_ADDR_LENGTH]; /* only exist when ToDS=FromDS=1 */
+	u8	Addr4[MAC_ADDR_LENGTH]; /* only exist when ToDS = FromDS = 1 */
 	/* Data Frame Body <= 2312 */
 	/* FCS */
 } __attribute__ ((packed));
@@ -587,8 +551,8 @@ struct Association_Request_Frame_Body {
 	u16	capability_information;
 	u16	listenInterval;
 	u8	Current_AP_Address[MAC_ADDR_LENGTH];/* for reassociation only */
-	/* SSID (2+32 bytes) */
-	/* Supported_Rates (2+8 bytes) */
+	/* SSID (2 + 32 bytes) */
+	/* Supported_Rates (2 + 8 bytes) */
 } __attribute__ ((packed));
 
 struct Association_Response_Frame_Body {
@@ -598,15 +562,6 @@ struct Association_Response_Frame_Body {
 	struct Supported_Rates_Element supportedRates;
 } __attribute__ ((packed));
 
-/*struct Reassociation_Request_Frame_Body {
-    u16    capability_information;
-    u16    listenInterval;
-    u8     Current_AP_Address[MAC_ADDR_LENGTH];
-    // SSID (2+32 bytes)
-    // Supported_Rates (2+8 bytes)
-};*/
-/* eliminated by WS 07/22/04 comboined with associateion request frame. */
-
 struct Reassociation_Response_Frame_Body {
 	u16	capability_information;
 	u16	statusCode;
@@ -622,7 +577,8 @@ struct Probe_Response_Frame_Body {
 	u16	Timestamp;
 	u16	Beacon_Interval;
 	u16	Capability_Information;
-	/* SSID
+	/*
+	 * SSID
 	 * Supported_Rates
 	 * PHY parameter Set (DS Parameters)
 	 * CF parameter Set
@@ -634,12 +590,7 @@ struct Authentication_Frame_Body {
 	u16	algorithmNumber;
 	u16	sequenceNumber;
 	u16	statusCode;
-	/* NB: don't include ChallengeText in this structure
-	 * struct Challenge_Text_Element sChallengeTextElement; /wkchen added
-	 */
 } __attribute__ ((packed));
 
 
 #endif /* _MAC_Structure_H_ */
-
-
-- 
1.7.0.2

