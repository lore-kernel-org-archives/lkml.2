Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab0GDBq0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 21:46:26 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47095 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab0GDBqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 21:46:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=O4AVdtIto0PRYHdMAeZ2aQK/Xs1iVNDMsXmlgmPMY35mDyN3jp5iRSvak52Qx6ZVOO
         AZA192tEm0HENYruNhRItMmFOl0YWnUQSdC+egmYq67n98QTU62ytWPgacKL/C21+oHg
         3es0uZcLUG/UhgzIWdgRr1ONeIo15HyS2ugj4=
From: Edgardo Hames <ehames@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, ehames@gmail.com
Subject: [PATCH 1/2] Staging: wlan-ng: fix checkpatch warnings in hfa384x.h
Date: Sat,  3 Jul 2010 22:46:25 -0300
Message-Id: <1278207986-14309-1-git-send-email-ehames@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed spaces before tabs, removed unused variables and all typedefs.

Signed-off-by: Edgardo Hames <ehames@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x.h     |  651 ++++++++++++++++-----------------
 drivers/staging/wlan-ng/hfa384x_usb.c |  316 ++++++++--------
 drivers/staging/wlan-ng/p80211wext.c  |    3 -
 drivers/staging/wlan-ng/prism2fw.c    |   22 +-
 drivers/staging/wlan-ng/prism2mgmt.c  |   30 +-
 drivers/staging/wlan-ng/prism2mgmt.h  |   10 +-
 drivers/staging/wlan-ng/prism2mib.c   |   42 +-
 drivers/staging/wlan-ng/prism2sta.c   |  140 ++++----
 drivers/staging/wlan-ng/prism2usb.c   |   16 +-
 9 files changed, 612 insertions(+), 618 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x.h b/drivers/staging/wlan-ng/hfa384x.h
index 1fa42e0..d917021 100644
--- a/drivers/staging/wlan-ng/hfa384x.h
+++ b/drivers/staging/wlan-ng/hfa384x.h
@@ -81,8 +81,8 @@
 #define		HFA384x_WEPFLAGS_EXCLUDE		((u16)BIT(1))
 #define		HFA384x_WEPFLAGS_DISABLE_TXCRYPT	((u16)BIT(4))
 #define		HFA384x_WEPFLAGS_DISABLE_RXCRYPT	((u16)BIT(7))
-#define 	HFA384x_ROAMMODE_HOSTSCAN_HOSTROAM	((u16)3)
-#define 	HFA384x_PORTSTATUS_DISABLED		((u16)1)
+#define		HFA384x_ROAMMODE_HOSTSCAN_HOSTROAM	((u16)3)
+#define		HFA384x_PORTSTATUS_DISABLED		((u16)1)
 #define		HFA384x_RATEBIT_1			((u16)1)
 #define		HFA384x_RATEBIT_2			((u16)2)
 #define		HFA384x_RATEBIT_5dot5			((u16)4)
@@ -164,7 +164,7 @@
 #define		HFA384x_CMDCODE_DOWNLD		((u16)0x22)
 
 /*--- Debugging Commands -----------------------------*/
-#define 	HFA384x_CMDCODE_MONITOR		((u16)(0x38))
+#define		HFA384x_CMDCODE_MONITOR		((u16)(0x38))
 #define		HFA384x_MONITOR_ENABLE		((u16)(0x0b))
 #define		HFA384x_MONITOR_DISABLE		((u16)(0x0f))
 
@@ -254,9 +254,9 @@ Information RID Lengths:  MAC Information
   include the len or code fields)
 --------------------------------------------------------------------*/
 #define		HFA384x_RID_DBMCOMMSQUALITY_LEN	 \
-	((u16) sizeof(hfa384x_dbmcommsquality_t))
+	((u16) sizeof(struct hfa384x_dbmcommsquality))
 #define		HFA384x_RID_JOINREQUEST_LEN \
-	((u16)sizeof(hfa384x_JoinRequest_data_t))
+	((u16)sizeof(struct hfa384x_JoinRequest_data))
 
 /*--------------------------------------------------------------------
 Information RIDs:  Modem Information
@@ -275,15 +275,15 @@ API ENHANCEMENTS (NOT ALREADY IMPLEMENTED)
 #define		HFA384x_RID_CNFAUTHENTICATION	((u16)0xFC2A)
 #define		HFA384x_RID_CNFROAMINGMODE	((u16)0xFC2D)
 #define		HFA384x_RID_CNFAPBCNint		((u16)0xFC33)
-#define		HFA384x_RID_CNFDBMADJUST  	((u16)0xFC46)
-#define		HFA384x_RID_CNFWPADATA       	((u16)0xFC48)
+#define		HFA384x_RID_CNFDBMADJUST	((u16)0xFC46)
+#define		HFA384x_RID_CNFWPADATA		((u16)0xFC48)
 #define		HFA384x_RID_CNFBASICRATES	((u16)0xFCB3)
 #define		HFA384x_RID_CNFSUPPRATES	((u16)0xFCB4)
 #define		HFA384x_RID_CNFPASSIVESCANCTRL	((u16)0xFCBA)
-#define		HFA384x_RID_TXPOWERMAX        	((u16)0xFCBE)
+#define		HFA384x_RID_TXPOWERMAX		((u16)0xFCBE)
 #define		HFA384x_RID_JOINREQUEST		((u16)0xFCE2)
 #define		HFA384x_RID_AUTHENTICATESTA	((u16)0xFCE3)
-#define		HFA384x_RID_HOSTSCAN          	((u16)0xFCE5)
+#define		HFA384x_RID_HOSTSCAN		((u16)0xFCE5)
 
 #define		HFA384x_RID_CNFWEPDEFAULTKEY_LEN	((u16)6)
 #define		HFA384x_RID_CNFWEP128DEFAULTKEY_LEN	((u16)14)
@@ -311,7 +311,7 @@ PD Record codes
 #define HFA384x_PDR_HFA3861_IFRF	((u16)0x0204)
 #define HFA384x_PDR_HFA3861_CHCALSP	((u16)0x0300)
 #define HFA384x_PDR_HFA3861_CHCALI	((u16)0x0301)
-#define HFA384x_PDR_MAX_TX_POWER  	((u16)0x0302)
+#define HFA384x_PDR_MAX_TX_POWER	((u16)0x0302)
 #define HFA384x_PDR_MASTER_CHAN_LIST	((u16)0x0303)
 #define HFA384x_PDR_3842_NIC_CONFIG	((u16)0x0400)
 #define HFA384x_PDR_USB_ID		((u16)0x0401)
@@ -322,10 +322,10 @@ PD Record codes
 #define HFA384x_PDR_USB_POWER_TYPE      ((u16)0x0407)
 #define HFA384x_PDR_USB_MAX_POWER	((u16)0x0409)
 #define HFA384x_PDR_USB_MANUFACTURER	((u16)0x0410)
-#define HFA384x_PDR_USB_PRODUCT  	((u16)0x0411)
-#define HFA384x_PDR_ANT_DIVERSITY   	((u16)0x0412)
-#define HFA384x_PDR_HFO_DELAY       	((u16)0x0413)
-#define HFA384x_PDR_SCALE_THRESH 	((u16)0x0414)
+#define HFA384x_PDR_USB_PRODUCT		((u16)0x0411)
+#define HFA384x_PDR_ANT_DIVERSITY	((u16)0x0412)
+#define HFA384x_PDR_HFO_DELAY		((u16)0x0413)
+#define HFA384x_PDR_SCALE_THRESH	((u16)0x0414)
 
 #define HFA384x_PDR_HFA3861_MANF_TESTSP	((u16)0x0900)
 #define HFA384x_PDR_HFA3861_MANF_TESTI	((u16)0x0901)
@@ -349,15 +349,15 @@ PD Record codes
 
 /*-------------------------------------------------------------*/
 /* Commonly used basic types */
-typedef struct hfa384x_bytestr {
+struct hfa384x_bytestr {
 	u16 len;
 	u8 data[0];
-} __attribute__ ((packed)) hfa384x_bytestr_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_bytestr32 {
+struct hfa384x_bytestr32 {
 	u16 len;
 	u8 data[32];
-} __attribute__ ((packed)) hfa384x_bytestr32_t;
+} __attribute__ ((packed));
 
 /*--------------------------------------------------------------------
 Configuration Record Structures:
@@ -365,25 +365,25 @@ Configuration Record Structures:
 --------------------------------------------------------------------*/
 
 /*-- Hardware/Firmware Component Information ----------*/
-typedef struct hfa384x_compident {
+struct hfa384x_compident {
 	u16 id;
 	u16 variant;
 	u16 major;
 	u16 minor;
-} __attribute__ ((packed)) hfa384x_compident_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_caplevel {
+struct hfa384x_caplevel {
 	u16 role;
 	u16 id;
 	u16 variant;
 	u16 bottom;
 	u16 top;
-} __attribute__ ((packed)) hfa384x_caplevel_t;
+} __attribute__ ((packed));
 
 /*-- Configuration Record: cnfAuthentication --*/
 #define HFA384x_CNFAUTHENTICATION_OPENSYSTEM	0x0001
 #define HFA384x_CNFAUTHENTICATION_SHAREDKEY	0x0002
-#define HFA384x_CNFAUTHENTICATION_LEAP     	0x0004
+#define HFA384x_CNFAUTHENTICATION_LEAP		0x0004
 
 /*--------------------------------------------------------------------
 Configuration Record Structures:
@@ -393,30 +393,30 @@ Configuration Record Structures:
 #define HFA384x_CREATEIBSS_JOINCREATEIBSS          0
 
 /*-- Configuration Record: HostScanRequest (data portion only) --*/
-typedef struct hfa384x_HostScanRequest_data {
+struct hfa384x_HostScanRequest_data {
 	u16 channelList;
 	u16 txRate;
-	hfa384x_bytestr32_t ssid;
-} __attribute__ ((packed)) hfa384x_HostScanRequest_data_t;
+	struct hfa384x_bytestr32 ssid;
+} __attribute__ ((packed));
 
 /*-- Configuration Record: JoinRequest (data portion only) --*/
-typedef struct hfa384x_JoinRequest_data {
+struct hfa384x_JoinRequest_data {
 	u8 bssid[WLAN_BSSID_LEN];
 	u16 channel;
-} __attribute__ ((packed)) hfa384x_JoinRequest_data_t;
+} __attribute__ ((packed));
 
 /*-- Configuration Record: authenticateStation (data portion only) --*/
-typedef struct hfa384x_authenticateStation_data {
+struct hfa384x_authenticateStation_data {
 	u8 address[ETH_ALEN];
 	u16 status;
 	u16 algorithm;
-} __attribute__ ((packed)) hfa384x_authenticateStation_data_t;
+} __attribute__ ((packed));
 
 /*-- Configuration Record: WPAData       (data portion only) --*/
-typedef struct hfa384x_WPAData {
+struct hfa384x_WPAData {
 	u16 datalen;
 	u8 data[0];		/* max 80 */
-} __attribute__ ((packed)) hfa384x_WPAData_t;
+} __attribute__ ((packed));
 
 /*--------------------------------------------------------------------
 Information Record Structures: NIC Information
@@ -424,11 +424,11 @@ Information Record Structures: NIC Information
 
 /*-- Information Record: DownLoadBuffer --*/
 /* NOTE: The page and offset are in AUX format */
-typedef struct hfa384x_downloadbuffer {
+struct hfa384x_downloadbuffer {
 	u16 page;
 	u16 offset;
 	u16 len;
-} __attribute__ ((packed)) hfa384x_downloadbuffer_t;
+} __attribute__ ((packed));
 
 /*--------------------------------------------------------------------
 Information Record Structures: NIC Information
@@ -437,18 +437,18 @@ Information Record Structures: NIC Information
 #define HFA384x_PSTATUS_CONN_IBSS	((u16)3)
 
 /*-- Information Record: commsquality --*/
-typedef struct hfa384x_commsquality {
+struct hfa384x_commsquality {
 	u16 CQ_currBSS;
 	u16 ASL_currBSS;
 	u16 ANL_currFC;
-} __attribute__ ((packed)) hfa384x_commsquality_t;
+} __attribute__ ((packed));
 
 /*-- Information Record: dmbcommsquality --*/
-typedef struct hfa384x_dbmcommsquality {
+struct hfa384x_dbmcommsquality {
 	u16 CQdbm_currBSS;
 	u16 ASLdbm_currBSS;
 	u16 ANLdbm_currFC;
-} __attribute__ ((packed)) hfa384x_dbmcommsquality_t;
+} __attribute__ ((packed));
 
 /*--------------------------------------------------------------------
 FRAME STRUCTURES: Communication Frames
@@ -456,7 +456,7 @@ FRAME STRUCTURES: Communication Frames
 Communication Frames: Transmit Frames
 --------------------------------------------------------------------*/
 /*-- Communication Frame: Transmit Frame Structure --*/
-typedef struct hfa384x_tx_frame {
+struct hfa384x_tx_frame {
 	u16 status;
 	u16 reserved1;
 	u16 reserved2;
@@ -481,7 +481,7 @@ typedef struct hfa384x_tx_frame {
 	u8 dest_addr[6];
 	u8 src_addr[6];
 	u16 data_length;	/* big endian format */
-} __attribute__ ((packed)) hfa384x_tx_frame_t;
+} __attribute__ ((packed));
 /*--------------------------------------------------------------------
 Communication Frames: Field Masks for Transmit Frames
 --------------------------------------------------------------------*/
@@ -518,7 +518,7 @@ Communication Frames: Test/Get/Set Field Values for Transmit Frames
 Communication Frames: Receive Frames
 --------------------------------------------------------------------*/
 /*-- Communication Frame: Receive Frame Structure --*/
-typedef struct hfa384x_rx_frame {
+struct hfa384x_rx_frame {
 	/*-- MAC rx descriptor (hfa384x byte order) --*/
 	u16 status;
 	u32 time;
@@ -543,7 +543,7 @@ typedef struct hfa384x_rx_frame {
 	u8 dest_addr[6];
 	u8 src_addr[6];
 	u16 data_length;	/* IEEE? (big endian) format */
-} __attribute__ ((packed)) hfa384x_rx_frame_t;
+} __attribute__ ((packed));
 /*--------------------------------------------------------------------
 Communication Frames: Field Masks for Receive Frames
 --------------------------------------------------------------------*/
@@ -575,8 +575,8 @@ Information Types
 #define		HFA384x_IT_AUTHREQ			((u16)0xF202UL)
 #define		HFA384x_IT_PSUSERCNT			((u16)0xF203UL)
 #define		HFA384x_IT_KEYIDCHANGED			((u16)0xF204UL)
-#define		HFA384x_IT_ASSOCREQ    			((u16)0xF205UL)
-#define		HFA384x_IT_MICFAILURE  			((u16)0xF206UL)
+#define		HFA384x_IT_ASSOCREQ			((u16)0xF205UL)
+#define		HFA384x_IT_MICFAILURE			((u16)0xF206UL)
 
 /*--------------------------------------------------------------------
 Information Frames Structures
@@ -585,7 +585,7 @@ Information Frames: Notification Frame Structures
 --------------------------------------------------------------------*/
 
 /*--  Inquiry Frame, Diagnose: Communication Tallies --*/
-typedef struct hfa384x_CommTallies16 {
+struct hfa384x_CommTallies16 {
 	u16 txunicastframes;
 	u16 txmulticastframes;
 	u16 txfragments;
@@ -607,9 +607,9 @@ typedef struct hfa384x_CommTallies16 {
 	u16 rxdiscardswepundecr;
 	u16 rxmsginmsgfrag;
 	u16 rxmsginbadmsgfrag;
-} __attribute__ ((packed)) hfa384x_CommTallies16_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_CommTallies32 {
+struct hfa384x_CommTallies32 {
 	u32 txunicastframes;
 	u32 txmulticastframes;
 	u32 txfragments;
@@ -631,62 +631,62 @@ typedef struct hfa384x_CommTallies32 {
 	u32 rxdiscardswepundecr;
 	u32 rxmsginmsgfrag;
 	u32 rxmsginbadmsgfrag;
-} __attribute__ ((packed)) hfa384x_CommTallies32_t;
+} __attribute__ ((packed));
 
 /*--  Inquiry Frame, Diagnose: Scan Results & Subfields--*/
-typedef struct hfa384x_ScanResultSub {
+struct hfa384x_ScanResultSub {
 	u16 chid;
 	u16 anl;
 	u16 sl;
 	u8 bssid[WLAN_BSSID_LEN];
 	u16 bcnint;
 	u16 capinfo;
-	hfa384x_bytestr32_t ssid;
+	struct hfa384x_bytestr32 ssid;
 	u8 supprates[10];	/* 802.11 info element */
 	u16 proberesp_rate;
-} __attribute__ ((packed)) hfa384x_ScanResultSub_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_ScanResult {
+struct hfa384x_ScanResult {
 	u16 rsvd;
 	u16 scanreason;
-	hfa384x_ScanResultSub_t result[HFA384x_SCANRESULT_MAX];
-} __attribute__ ((packed)) hfa384x_ScanResult_t;
+	struct hfa384x_ScanResultSub result[HFA384x_SCANRESULT_MAX];
+} __attribute__ ((packed));
 
 /*--  Inquiry Frame, Diagnose: ChInfo Results & Subfields--*/
-typedef struct hfa384x_ChInfoResultSub {
+struct hfa384x_ChInfoResultSub {
 	u16 chid;
 	u16 anl;
 	u16 pnl;
 	u16 active;
-} __attribute__ ((packed)) hfa384x_ChInfoResultSub_t;
+} __attribute__ ((packed));
 
 #define HFA384x_CHINFORESULT_BSSACTIVE	BIT(0)
 #define HFA384x_CHINFORESULT_PCFACTIVE	BIT(1)
 
-typedef struct hfa384x_ChInfoResult {
+struct hfa384x_ChInfoResult {
 	u16 scanchannels;
-	hfa384x_ChInfoResultSub_t result[HFA384x_CHINFORESULT_MAX];
-} __attribute__ ((packed)) hfa384x_ChInfoResult_t;
+	struct hfa384x_ChInfoResultSub result[HFA384x_CHINFORESULT_MAX];
+} __attribute__ ((packed));
 
 /*--  Inquiry Frame, Diagnose: Host Scan Results & Subfields--*/
-typedef struct hfa384x_HScanResultSub {
+struct hfa384x_HScanResultSub {
 	u16 chid;
 	u16 anl;
 	u16 sl;
 	u8 bssid[WLAN_BSSID_LEN];
 	u16 bcnint;
 	u16 capinfo;
-	hfa384x_bytestr32_t ssid;
+	struct hfa384x_bytestr32 ssid;
 	u8 supprates[10];	/* 802.11 info element */
 	u16 proberesp_rate;
 	u16 atim;
-} __attribute__ ((packed)) hfa384x_HScanResultSub_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_HScanResult {
+struct hfa384x_HScanResult {
 	u16 nresult;
 	u16 rsvd;
-	hfa384x_HScanResultSub_t result[HFA384x_HSCANRESULT_MAX];
-} __attribute__ ((packed)) hfa384x_HScanResult_t;
+	struct hfa384x_HScanResultSub result[HFA384x_HSCANRESULT_MAX];
+} __attribute__ ((packed));
 
 /*--  Unsolicited Frame, MAC Mgmt: LinkStatus --*/
 
@@ -698,9 +698,9 @@ typedef struct hfa384x_HScanResult {
 #define HFA384x_LINK_AP_INRANGE		((u16)5)
 #define HFA384x_LINK_ASSOCFAIL		((u16)6)
 
-typedef struct hfa384x_LinkStatus {
+struct hfa384x_LinkStatus {
 	u16 linkstatus;
-} __attribute__ ((packed)) hfa384x_LinkStatus_t;
+} __attribute__ ((packed));
 
 /*--  Unsolicited Frame, MAC Mgmt: AssociationStatus (--*/
 
@@ -708,52 +708,52 @@ typedef struct hfa384x_LinkStatus {
 #define HFA384x_ASSOCSTATUS_REASSOC	((u16)2)
 #define HFA384x_ASSOCSTATUS_AUTHFAIL	((u16)5)
 
-typedef struct hfa384x_AssocStatus {
+struct hfa384x_AssocStatus {
 	u16 assocstatus;
 	u8 sta_addr[ETH_ALEN];
 	/* old_ap_addr is only valid if assocstatus == 2 */
 	u8 old_ap_addr[ETH_ALEN];
 	u16 reason;
 	u16 reserved;
-} __attribute__ ((packed)) hfa384x_AssocStatus_t;
+} __attribute__ ((packed));
 
 /*--  Unsolicited Frame, MAC Mgmt: AuthRequest (AP Only) --*/
 
-typedef struct hfa384x_AuthRequest {
+struct hfa384x_AuthRequest {
 	u8 sta_addr[ETH_ALEN];
 	u16 algorithm;
-} __attribute__ ((packed)) hfa384x_AuthReq_t;
+} __attribute__ ((packed));
 
 /*--  Unsolicited Frame, MAC Mgmt: PSUserCount (AP Only) --*/
 
-typedef struct hfa384x_PSUserCount {
+struct hfa384x_PSUserCount {
 	u16 usercnt;
-} __attribute__ ((packed)) hfa384x_PSUserCount_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_KeyIDChanged {
+struct hfa384x_KeyIDChanged {
 	u8 sta_addr[ETH_ALEN];
 	u16 keyid;
-} __attribute__ ((packed)) hfa384x_KeyIDChanged_t;
+} __attribute__ ((packed));
 
 /*--  Collection of all Inf frames ---------------*/
-typedef union hfa384x_infodata {
-	hfa384x_CommTallies16_t commtallies16;
-	hfa384x_CommTallies32_t commtallies32;
-	hfa384x_ScanResult_t scanresult;
-	hfa384x_ChInfoResult_t chinforesult;
-	hfa384x_HScanResult_t hscanresult;
-	hfa384x_LinkStatus_t linkstatus;
-	hfa384x_AssocStatus_t assocstatus;
-	hfa384x_AuthReq_t authreq;
-	hfa384x_PSUserCount_t psusercnt;
-	hfa384x_KeyIDChanged_t keyidchanged;
-} __attribute__ ((packed)) hfa384x_infodata_t;
-
-typedef struct hfa384x_InfFrame {
+union hfa384x_infodata {
+	struct hfa384x_CommTallies16 commtallies16;
+	struct hfa384x_CommTallies32 commtallies32;
+	struct hfa384x_ScanResult scanresult;
+	struct hfa384x_ChInfoResult chinforesult;
+	struct hfa384x_HScanResult hscanresult;
+	struct hfa384x_LinkStatus linkstatus;
+	struct hfa384x_AssocStatus assocstatus;
+	struct hfa384x_AuthRequest authreq;
+	struct hfa384x_PSUserCount psusercnt;
+	struct hfa384x_KeyIDChanged keyidchanged;
+} __attribute__ ((packed));
+
+struct hfa384x_InfFrame {
 	u16 framelen;
 	u16 infotype;
-	hfa384x_infodata_t info;
-} __attribute__ ((packed)) hfa384x_InfFrame_t;
+	union hfa384x_infodata info;
+} __attribute__ ((packed));
 
 /*--------------------------------------------------------------------
 USB Packet structures and constants.
@@ -782,143 +782,139 @@ USB Packet structures and constants.
 /*------------------------------------*/
 /* Request (bulk OUT) packet contents */
 
-typedef struct hfa384x_usb_txfrm {
-	hfa384x_tx_frame_t desc;
+struct hfa384x_usb_txfrm {
+	struct hfa384x_tx_frame desc;
 	u8 data[WLAN_DATA_MAXLEN];
-} __attribute__ ((packed)) hfa384x_usb_txfrm_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_usb_cmdreq {
+struct hfa384x_usb_cmdreq {
 	u16 type;
 	u16 cmd;
 	u16 parm0;
 	u16 parm1;
 	u16 parm2;
 	u8 pad[54];
-} __attribute__ ((packed)) hfa384x_usb_cmdreq_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_usb_wridreq {
+struct hfa384x_usb_wridreq {
 	u16 type;
 	u16 frmlen;
 	u16 rid;
 	u8 data[HFA384x_RIDDATA_MAXLEN];
-} __attribute__ ((packed)) hfa384x_usb_wridreq_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_usb_rridreq {
+struct hfa384x_usb_rridreq {
 	u16 type;
 	u16 frmlen;
 	u16 rid;
 	u8 pad[58];
-} __attribute__ ((packed)) hfa384x_usb_rridreq_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_usb_wmemreq {
+struct hfa384x_usb_wmemreq {
 	u16 type;
 	u16 frmlen;
 	u16 offset;
 	u16 page;
 	u8 data[HFA384x_USB_RWMEM_MAXLEN];
-} __attribute__ ((packed)) hfa384x_usb_wmemreq_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_usb_rmemreq {
+struct hfa384x_usb_rmemreq {
 	u16 type;
 	u16 frmlen;
 	u16 offset;
 	u16 page;
 	u8 pad[56];
-} __attribute__ ((packed)) hfa384x_usb_rmemreq_t;
+} __attribute__ ((packed));
 
 /*------------------------------------*/
 /* Response (bulk IN) packet contents */
 
-typedef struct hfa384x_usb_rxfrm {
-	hfa384x_rx_frame_t desc;
+struct hfa384x_usb_rxfrm {
+	struct hfa384x_rx_frame desc;
 	u8 data[WLAN_DATA_MAXLEN];
-} __attribute__ ((packed)) hfa384x_usb_rxfrm_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_usb_infofrm {
+struct hfa384x_usb_infofrm {
 	u16 type;
-	hfa384x_InfFrame_t info;
-} __attribute__ ((packed)) hfa384x_usb_infofrm_t;
+	struct hfa384x_InfFrame info;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_usb_statusresp {
+struct hfa384x_usb_statusresp {
 	u16 type;
 	u16 status;
 	u16 resp0;
 	u16 resp1;
 	u16 resp2;
-} __attribute__ ((packed)) hfa384x_usb_cmdresp_t;
+} __attribute__ ((packed));
 
-typedef hfa384x_usb_cmdresp_t hfa384x_usb_wridresp_t;
-
-typedef struct hfa384x_usb_rridresp {
+struct hfa384x_usb_rridresp {
 	u16 type;
 	u16 frmlen;
 	u16 rid;
 	u8 data[HFA384x_RIDDATA_MAXLEN];
-} __attribute__ ((packed)) hfa384x_usb_rridresp_t;
-
-typedef hfa384x_usb_cmdresp_t hfa384x_usb_wmemresp_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_usb_rmemresp {
+struct hfa384x_usb_rmemresp {
 	u16 type;
 	u16 frmlen;
 	u8 data[HFA384x_USB_RWMEM_MAXLEN];
-} __attribute__ ((packed)) hfa384x_usb_rmemresp_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_usb_bufavail {
+struct hfa384x_usb_bufavail {
 	u16 type;
 	u16 frmlen;
-} __attribute__ ((packed)) hfa384x_usb_bufavail_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_usb_error {
+struct hfa384x_usb_error {
 	u16 type;
 	u16 errortype;
-} __attribute__ ((packed)) hfa384x_usb_error_t;
+} __attribute__ ((packed));
 
 /*----------------------------------------------------------*/
 /* Unions for packaging all the known packet types together */
 
-typedef union hfa384x_usbout {
+union hfa384x_usbout {
 	u16 type;
-	hfa384x_usb_txfrm_t txfrm;
-	hfa384x_usb_cmdreq_t cmdreq;
-	hfa384x_usb_wridreq_t wridreq;
-	hfa384x_usb_rridreq_t rridreq;
-	hfa384x_usb_wmemreq_t wmemreq;
-	hfa384x_usb_rmemreq_t rmemreq;
-} __attribute__ ((packed)) hfa384x_usbout_t;
-
-typedef union hfa384x_usbin {
+	struct hfa384x_usb_txfrm txfrm;
+	struct hfa384x_usb_cmdreq cmdreq;
+	struct hfa384x_usb_wridreq wridreq;
+	struct hfa384x_usb_rridreq rridreq;
+	struct hfa384x_usb_wmemreq wmemreq;
+	struct hfa384x_usb_rmemreq rmemreq;
+} __attribute__ ((packed));
+
+union hfa384x_usbin {
 	u16 type;
-	hfa384x_usb_rxfrm_t rxfrm;
-	hfa384x_usb_txfrm_t txfrm;
-	hfa384x_usb_infofrm_t infofrm;
-	hfa384x_usb_cmdresp_t cmdresp;
-	hfa384x_usb_wridresp_t wridresp;
-	hfa384x_usb_rridresp_t rridresp;
-	hfa384x_usb_wmemresp_t wmemresp;
-	hfa384x_usb_rmemresp_t rmemresp;
-	hfa384x_usb_bufavail_t bufavail;
-	hfa384x_usb_error_t usberror;
+	struct hfa384x_usb_rxfrm rxfrm;
+	struct hfa384x_usb_txfrm txfrm;
+	struct hfa384x_usb_infofrm infofrm;
+	struct hfa384x_usb_statusresp cmdresp;
+	struct hfa384x_usb_statusresp wridresp;
+	struct hfa384x_usb_rridresp rridresp;
+	struct hfa384x_usb_statusresp wmemresp;
+	struct hfa384x_usb_rmemresp rmemresp;
+	struct hfa384x_usb_bufavail bufavail;
+	struct hfa384x_usb_error usberror;
 	u8 boguspad[3000];
-} __attribute__ ((packed)) hfa384x_usbin_t;
+} __attribute__ ((packed));
 
 /*--------------------------------------------------------------------
 PD record structures.
 --------------------------------------------------------------------*/
 
-typedef struct hfa384x_pdr_pcb_partnum {
+struct hfa384x_pdr_pcb_partnum {
 	u8 num[8];
-} __attribute__ ((packed)) hfa384x_pdr_pcb_partnum_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_pcb_tracenum {
+struct hfa384x_pdr_pcb_tracenum {
 	u8 num[8];
-} __attribute__ ((packed)) hfa384x_pdr_pcb_tracenum_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_nic_serial {
+struct hfa384x_pdr_nic_serial {
 	u8 num[12];
-} __attribute__ ((packed)) hfa384x_pdr_nic_serial_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_mkk_measurements {
+struct hfa384x_pdr_mkk_measurements {
 	double carrier_freq;
 	double occupied_band;
 	double power_density;
@@ -934,192 +930,192 @@ typedef struct hfa384x_pdr_mkk_measurements {
 	double rx_spur_f2;
 	double rx_spur_l1;
 	double rx_spur_l2;
-} __attribute__ ((packed)) hfa384x_pdr_mkk_measurements_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_nic_ramsize {
+struct hfa384x_pdr_nic_ramsize {
 	u8 size[12];		/* units of KB */
-} __attribute__ ((packed)) hfa384x_pdr_nic_ramsize_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_mfisuprange {
+struct hfa384x_pdr_mfisuprange {
 	u16 id;
 	u16 variant;
 	u16 bottom;
 	u16 top;
-} __attribute__ ((packed)) hfa384x_pdr_mfisuprange_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_cfisuprange {
+struct hfa384x_pdr_cfisuprange {
 	u16 id;
 	u16 variant;
 	u16 bottom;
 	u16 top;
-} __attribute__ ((packed)) hfa384x_pdr_cfisuprange_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_nicid {
+struct hfa384x_pdr_nicid {
 	u16 id;
 	u16 variant;
 	u16 major;
 	u16 minor;
-} __attribute__ ((packed)) hfa384x_pdr_nicid_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_refdac_measurements {
+struct hfa384x_pdr_refdac_measurements {
 	u16 value[0];
-} __attribute__ ((packed)) hfa384x_pdr_refdac_measurements_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_vgdac_measurements {
+struct hfa384x_pdr_vgdac_measurements {
 	u16 value[0];
-} __attribute__ ((packed)) hfa384x_pdr_vgdac_measurements_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_level_comp_measurements {
+struct hfa384x_pdr_level_comp_measurements {
 	u16 value[0];
-} __attribute__ ((packed)) hfa384x_pdr_level_compc_measurements_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_mac_address {
+struct hfa384x_pdr_mac_address {
 	u8 addr[6];
-} __attribute__ ((packed)) hfa384x_pdr_mac_address_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_mkk_callname {
+struct hfa384x_pdr_mkk_callname {
 	u8 callname[8];
-} __attribute__ ((packed)) hfa384x_pdr_mkk_callname_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_regdomain {
+struct hfa384x_pdr_regdomain {
 	u16 numdomains;
 	u16 domain[5];
-} __attribute__ ((packed)) hfa384x_pdr_regdomain_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_allowed_channel {
+struct hfa384x_pdr_allowed_channel {
 	u16 ch_bitmap;
-} __attribute__ ((packed)) hfa384x_pdr_allowed_channel_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_default_channel {
+struct hfa384x_pdr_default_channel {
 	u16 channel;
-} __attribute__ ((packed)) hfa384x_pdr_default_channel_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_privacy_option {
+struct hfa384x_pdr_privacy_option {
 	u16 available;
-} __attribute__ ((packed)) hfa384x_pdr_privacy_option_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_temptype {
+struct hfa384x_pdr_temptype {
 	u16 type;
-} __attribute__ ((packed)) hfa384x_pdr_temptype_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_refdac_setup {
+struct hfa384x_pdr_refdac_setup {
 	u16 ch_value[14];
-} __attribute__ ((packed)) hfa384x_pdr_refdac_setup_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_vgdac_setup {
+struct hfa384x_pdr_vgdac_setup {
 	u16 ch_value[14];
-} __attribute__ ((packed)) hfa384x_pdr_vgdac_setup_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_level_comp_setup {
+struct hfa384x_pdr_level_comp_setup {
 	u16 ch_value[14];
-} __attribute__ ((packed)) hfa384x_pdr_level_comp_setup_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_trimdac_setup {
+struct hfa384x_pdr_trimdac_setup {
 	u16 trimidac;
 	u16 trimqdac;
-} __attribute__ ((packed)) hfa384x_pdr_trimdac_setup_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_ifr_setting {
+struct hfa384x_pdr_ifr_setting {
 	u16 value[3];
-} __attribute__ ((packed)) hfa384x_pdr_ifr_setting_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_rfr_setting {
+struct hfa384x_pdr_rfr_setting {
 	u16 value[3];
-} __attribute__ ((packed)) hfa384x_pdr_rfr_setting_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_hfa3861_baseline {
+struct hfa384x_pdr_hfa3861_baseline {
 	u16 value[50];
-} __attribute__ ((packed)) hfa384x_pdr_hfa3861_baseline_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_hfa3861_shadow {
+struct hfa384x_pdr_hfa3861_shadow {
 	u32 value[32];
-} __attribute__ ((packed)) hfa384x_pdr_hfa3861_shadow_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_hfa3861_ifrf {
+struct hfa384x_pdr_hfa3861_ifrf {
 	u32 value[20];
-} __attribute__ ((packed)) hfa384x_pdr_hfa3861_ifrf_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_hfa3861_chcalsp {
+struct hfa384x_pdr_hfa3861_chcalsp {
 	u16 value[14];
-} __attribute__ ((packed)) hfa384x_pdr_hfa3861_chcalsp_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_hfa3861_chcali {
+struct hfa384x_pdr_hfa3861_chcali {
 	u16 value[17];
-} __attribute__ ((packed)) hfa384x_pdr_hfa3861_chcali_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_hfa3861_nic_config {
+struct hfa384x_pdr_hfa3861_nic_config {
 	u16 config_bitmap;
-} __attribute__ ((packed)) hfa384x_pdr_nic_config_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_hfo_delay {
+struct hfa384x_pdr_hfo_delay {
 	u8 hfo_delay;
-} __attribute__ ((packed)) hfa384x_hfo_delay_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_hfa3861_manf_testsp {
+struct hfa384x_pdr_hfa3861_manf_testsp {
 	u16 value[30];
-} __attribute__ ((packed)) hfa384x_pdr_hfa3861_manf_testsp_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdr_hfa3861_manf_testi {
+struct hfa384x_pdr_hfa3861_manf_testi {
 	u16 value[30];
-} __attribute__ ((packed)) hfa384x_pdr_hfa3861_manf_testi_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_end_of_pda {
+struct hfa384x_end_of_pda {
 	u16 crc;
-} __attribute__ ((packed)) hfa384x_pdr_end_of_pda_t;
+} __attribute__ ((packed));
 
-typedef struct hfa384x_pdrec {
+struct hfa384x_pdrec {
 	u16 len;		/* in words */
 	u16 code;
 	union pdr {
-		hfa384x_pdr_pcb_partnum_t pcb_partnum;
-		hfa384x_pdr_pcb_tracenum_t pcb_tracenum;
-		hfa384x_pdr_nic_serial_t nic_serial;
-		hfa384x_pdr_mkk_measurements_t mkk_measurements;
-		hfa384x_pdr_nic_ramsize_t nic_ramsize;
-		hfa384x_pdr_mfisuprange_t mfisuprange;
-		hfa384x_pdr_cfisuprange_t cfisuprange;
-		hfa384x_pdr_nicid_t nicid;
-		hfa384x_pdr_refdac_measurements_t refdac_measurements;
-		hfa384x_pdr_vgdac_measurements_t vgdac_measurements;
-		hfa384x_pdr_level_compc_measurements_t level_compc_measurements;
-		hfa384x_pdr_mac_address_t mac_address;
-		hfa384x_pdr_mkk_callname_t mkk_callname;
-		hfa384x_pdr_regdomain_t regdomain;
-		hfa384x_pdr_allowed_channel_t allowed_channel;
-		hfa384x_pdr_default_channel_t default_channel;
-		hfa384x_pdr_privacy_option_t privacy_option;
-		hfa384x_pdr_temptype_t temptype;
-		hfa384x_pdr_refdac_setup_t refdac_setup;
-		hfa384x_pdr_vgdac_setup_t vgdac_setup;
-		hfa384x_pdr_level_comp_setup_t level_comp_setup;
-		hfa384x_pdr_trimdac_setup_t trimdac_setup;
-		hfa384x_pdr_ifr_setting_t ifr_setting;
-		hfa384x_pdr_rfr_setting_t rfr_setting;
-		hfa384x_pdr_hfa3861_baseline_t hfa3861_baseline;
-		hfa384x_pdr_hfa3861_shadow_t hfa3861_shadow;
-		hfa384x_pdr_hfa3861_ifrf_t hfa3861_ifrf;
-		hfa384x_pdr_hfa3861_chcalsp_t hfa3861_chcalsp;
-		hfa384x_pdr_hfa3861_chcali_t hfa3861_chcali;
-		hfa384x_pdr_nic_config_t nic_config;
-		hfa384x_hfo_delay_t hfo_delay;
-		hfa384x_pdr_hfa3861_manf_testsp_t hfa3861_manf_testsp;
-		hfa384x_pdr_hfa3861_manf_testi_t hfa3861_manf_testi;
-		hfa384x_pdr_end_of_pda_t end_of_pda;
+		struct hfa384x_pdr_pcb_partnum pcb_partnum;
+		struct hfa384x_pdr_pcb_tracenum pcb_tracenum;
+		struct hfa384x_pdr_nic_serial nic_serial;
+		struct hfa384x_pdr_mkk_measurements mkk_measurements;
+		struct hfa384x_pdr_nic_ramsize nic_ramsize;
+		struct hfa384x_pdr_mfisuprange mfisuprange;
+		struct hfa384x_pdr_cfisuprange cfisuprange;
+		struct hfa384x_pdr_nicid nicid;
+		struct hfa384x_pdr_refdac_measurements refdac_measurements;
+		struct hfa384x_pdr_vgdac_measurements vgdac_measurements;
+		struct hfa384x_pdr_level_comp_measurements level_compc_measurements;
+		struct hfa384x_pdr_mac_address mac_address;
+		struct hfa384x_pdr_mkk_callname mkk_callname;
+		struct hfa384x_pdr_regdomain regdomain;
+		struct hfa384x_pdr_allowed_channel allowed_channel;
+		struct hfa384x_pdr_default_channel default_channel;
+		struct hfa384x_pdr_privacy_option privacy_option;
+		struct hfa384x_pdr_temptype temptype;
+		struct hfa384x_pdr_refdac_setup refdac_setup;
+		struct hfa384x_pdr_vgdac_setup vgdac_setup;
+		struct hfa384x_pdr_level_comp_setup level_comp_setup;
+		struct hfa384x_pdr_trimdac_setup trimdac_setup;
+		struct hfa384x_pdr_ifr_setting ifr_setting;
+		struct hfa384x_pdr_rfr_setting rfr_setting;
+		struct hfa384x_pdr_hfa3861_baseline hfa3861_baseline;
+		struct hfa384x_pdr_hfa3861_shadow hfa3861_shadow;
+		struct hfa384x_pdr_hfa3861_ifrf hfa3861_ifrf;
+		struct hfa384x_pdr_hfa3861_chcalsp hfa3861_chcalsp;
+		struct hfa384x_pdr_hfa3861_chcali hfa3861_chcali;
+		struct hfa384x_pdr_hfa3861_nic_config nic_config;
+		struct hfa384x_pdr_hfo_delay hfo_delay;
+		struct hfa384x_pdr_hfa3861_manf_testsp hfa3861_manf_testsp;
+		struct hfa384x_pdr_hfa3861_manf_testi hfa3861_manf_testi;
+		struct hfa384x_end_of_pda end_of_pda;
 
 	} data;
-} __attribute__ ((packed)) hfa384x_pdrec_t;
+} __attribute__ ((packed));
 
 #ifdef __KERNEL__
 /*--------------------------------------------------------------------
 ---  MAC state structure, argument to all functions --
 ---  Also, a collection of support types --
 --------------------------------------------------------------------*/
-typedef struct hfa384x_statusresult {
+struct hfa384x_statusresult {
 	u16 status;
 	u16 resp0;
 	u16 resp1;
 	u16 resp2;
-} hfa384x_cmdresult_t;
+};
 
 /* USB Control Exchange (CTLX):
  *  A queue of the structure below is maintained for all of the
@@ -1128,11 +1124,11 @@ typedef struct hfa384x_statusresult {
 /* The following hfa384x_* structures are arguments to
  * the usercb() for the different CTLX types.
  */
-typedef struct hfa384x_rridresult {
+struct hfa384x_rridresult {
 	u16 rid;
 	const void *riddata;
 	unsigned int riddata_len;
-} hfa384x_rridresult_t;
+};
 
 enum ctlx_state {
 	CTLX_START = 0,		/* Start state, not queued */
@@ -1145,7 +1141,6 @@ enum ctlx_state {
 	CTLX_REQ_COMPLETE,	/* OUT URB complete */
 	CTLX_RESP_COMPLETE	/* IN URB received */
 };
-typedef enum ctlx_state CTLX_STATE;
 
 struct hfa384x_usbctlx;
 struct hfa384x;
@@ -1155,14 +1150,14 @@ typedef void (*ctlx_cmdcb_t) (struct hfa384x *, const struct hfa384x_usbctlx *);
 typedef void (*ctlx_usercb_t) (struct hfa384x *hw,
 			       void *ctlxresult, void *usercb_data);
 
-typedef struct hfa384x_usbctlx {
+struct hfa384x_usbctlx {
 	struct list_head list;
 
 	size_t outbufsize;
-	hfa384x_usbout_t outbuf;	/* pkt buf for OUT */
-	hfa384x_usbin_t inbuf;	/* pkt buf for IN(a copy) */
+	union hfa384x_usbout outbuf;	/* pkt buf for OUT */
+	union hfa384x_usbin inbuf;	/* pkt buf for IN(a copy) */
 
-	CTLX_STATE state;	/* Tracks running state */
+	enum ctlx_state state;	/* Tracks running state */
 
 	struct completion done;
 	volatile int reapable;	/* Food for the reaper task */
@@ -1172,25 +1167,25 @@ typedef struct hfa384x_usbctlx {
 	void *usercb_data;	/*  at CTLX completion  */
 
 	int variant;		/* Identifies cmd variant */
-} hfa384x_usbctlx_t;
+};
 
-typedef struct hfa384x_usbctlxq {
+struct hfa384x_usbctlxq {
 	spinlock_t lock;
 	struct list_head pending;
 	struct list_head active;
 	struct list_head completing;
 	struct list_head reapable;
-} hfa384x_usbctlxq_t;
+};
 
-typedef struct hfa484x_metacmd {
+struct hfa384x_metacmd {
 	u16 cmd;
 
 	u16 parm0;
 	u16 parm1;
 	u16 parm2;
 
-	hfa384x_cmdresult_t result;
-} hfa384x_metacmd_t;
+	struct hfa384x_statusresult result;
+};
 
 #define	MAX_GRP_ADDR		32
 #define WLAN_COMMENT_MAX	80  /* Max. length of user comment string. */
@@ -1203,29 +1198,29 @@ typedef struct hfa484x_metacmd {
 #define WLAN_ACCESS_DENY	3   /* Do not authenticate "denied" stations. */
 
 /* XXX These are going away ASAP */
-typedef struct prism2sta_authlist {
+struct prism2sta_authlist {
 	unsigned int cnt;
 	u8 addr[WLAN_AUTH_MAX][ETH_ALEN];
 	u8 assoc[WLAN_AUTH_MAX];
-} prism2sta_authlist_t;
+};
 
-typedef struct prism2sta_accesslist {
+struct prism2sta_accesslist {
 	unsigned int modify;
 	unsigned int cnt;
 	u8 addr[WLAN_ACCESS_MAX][ETH_ALEN];
 	unsigned int cnt1;
 	u8 addr1[WLAN_ACCESS_MAX][ETH_ALEN];
-} prism2sta_accesslist_t;
+};
 
-typedef struct hfa384x {
+struct hfa384x {
 	/* USB support data */
 	struct usb_device *usb;
 	struct urb rx_urb;
 	struct sk_buff *rx_urb_skb;
 	struct urb tx_urb;
 	struct urb ctlx_urb;
-	hfa384x_usbout_t txbuff;
-	hfa384x_usbctlxq_t ctlxq;
+	union hfa384x_usbout txbuff;
+	struct hfa384x_usbctlxq ctlxq;
 	struct timer_list reqtimer;
 	struct timer_list resptimer;
 
@@ -1264,20 +1259,20 @@ typedef struct hfa384x {
 
 	/* Download support */
 	unsigned int dlstate;
-	hfa384x_downloadbuffer_t bufinfo;
+	struct hfa384x_downloadbuffer bufinfo;
 	u16 dltimeout;
 
 	int scanflag;		/* to signal scan comlete */
 	int join_ap;		/* are we joined to a specific ap */
 	int join_retries;	/* number of join retries till we fail */
-	hfa384x_JoinRequest_data_t joinreq;	/* join request saved data */
+	struct hfa384x_JoinRequest_data joinreq; /* join request saved data */
 
 	wlandevice_t *wlandev;
 	/* Timer to allow for the deferred processing of linkstatus messages */
 	struct work_struct link_bh;
 
 	struct work_struct commsqual_bh;
-	hfa384x_commsquality_t qual;
+	struct hfa384x_commsquality qual;
 	struct timer_list commsqual_timer;
 
 	u16 link_status;
@@ -1299,78 +1294,80 @@ typedef struct hfa384x {
 	unsigned int dot11_grpcnt;
 
 	/* Component Identities */
-	hfa384x_compident_t ident_nic;
-	hfa384x_compident_t ident_pri_fw;
-	hfa384x_compident_t ident_sta_fw;
-	hfa384x_compident_t ident_ap_fw;
+	struct hfa384x_compident ident_nic;
+	struct hfa384x_compident ident_pri_fw;
+	struct hfa384x_compident ident_sta_fw;
+	struct hfa384x_compident ident_ap_fw;
 	u16 mm_mods;
 
 	/* Supplier compatibility ranges */
-	hfa384x_caplevel_t cap_sup_mfi;
-	hfa384x_caplevel_t cap_sup_cfi;
-	hfa384x_caplevel_t cap_sup_pri;
-	hfa384x_caplevel_t cap_sup_sta;
-	hfa384x_caplevel_t cap_sup_ap;
+	struct hfa384x_caplevel cap_sup_mfi;
+	struct hfa384x_caplevel cap_sup_cfi;
+	struct hfa384x_caplevel cap_sup_pri;
+	struct hfa384x_caplevel cap_sup_sta;
+	struct hfa384x_caplevel cap_sup_ap;
 
 	/* Actor compatibility ranges */
-	hfa384x_caplevel_t cap_act_pri_cfi;	/*
+	struct hfa384x_caplevel cap_act_pri_cfi;	/*
 						 * pri f/w to controller
 						 * interface
 						 */
 
-	hfa384x_caplevel_t cap_act_sta_cfi;	/*
+	struct hfa384x_caplevel cap_act_sta_cfi;	/*
 						 * sta f/w to controller
 						 * interface
 						 */
 
-	hfa384x_caplevel_t cap_act_sta_mfi;	/* sta f/w to modem interface */
+	struct hfa384x_caplevel cap_act_sta_mfi; /* sta f/w to modem interface */
 
-	hfa384x_caplevel_t cap_act_ap_cfi;	/*
+	struct hfa384x_caplevel cap_act_ap_cfi;	/*
 						 * ap f/w to controller
 						 * interface
 						 */
 
-	hfa384x_caplevel_t cap_act_ap_mfi;	/* ap f/w to modem interface */
+	struct hfa384x_caplevel cap_act_ap_mfi;	/* ap f/w to modem interface */
 
 	u32 psusercount;	/* Power save user count. */
-	hfa384x_CommTallies32_t tallies;	/* Communication tallies. */
+	struct hfa384x_CommTallies32 tallies;	/* Communication tallies. */
 	u8 comment[WLAN_COMMENT_MAX + 1];	/* User comment */
 
 	/* Channel Info request results (AP only) */
 	struct {
 		atomic_t done;
 		u8 count;
-		hfa384x_ChInfoResult_t results;
+		struct hfa384x_ChInfoResult results;
 	} channel_info;
 
-	hfa384x_InfFrame_t *scanresults;
+	struct hfa384x_InfFrame *scanresults;
 
-	prism2sta_authlist_t authlist;	/* Authenticated station list. */
+	struct prism2sta_authlist authlist; /* Authenticated station list. */
 	unsigned int accessmode;	/* Access mode. */
-	prism2sta_accesslist_t allow;	/* Allowed station list. */
-	prism2sta_accesslist_t deny;	/* Denied station list. */
+	struct prism2sta_accesslist allow;	/* Allowed station list. */
+	struct prism2sta_accesslist deny;	/* Denied station list. */
 
-} hfa384x_t;
-
-void hfa384x_create(hfa384x_t *hw, struct usb_device *usb);
-void hfa384x_destroy(hfa384x_t *hw);
+};
 
-int
-hfa384x_corereset(hfa384x_t *hw, int holdtime, int settletime, int genesis);
-int hfa384x_drvr_commtallies(hfa384x_t *hw);
-int hfa384x_drvr_disable(hfa384x_t *hw, u16 macport);
-int hfa384x_drvr_enable(hfa384x_t *hw, u16 macport);
-int hfa384x_drvr_flashdl_enable(hfa384x_t *hw);
-int hfa384x_drvr_flashdl_disable(hfa384x_t *hw);
-int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len);
-int hfa384x_drvr_getconfig(hfa384x_t *hw, u16 rid, void *buf, u16 len);
-int hfa384x_drvr_ramdl_enable(hfa384x_t *hw, u32 exeaddr);
-int hfa384x_drvr_ramdl_disable(hfa384x_t *hw);
-int hfa384x_drvr_ramdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len);
-int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len);
-int hfa384x_drvr_setconfig(hfa384x_t *hw, u16 rid, void *buf, u16 len);
-
-static inline int hfa384x_drvr_getconfig16(hfa384x_t *hw, u16 rid, void *val)
+void hfa384x_create(struct hfa384x *hw, struct usb_device *usb);
+void hfa384x_destroy(struct hfa384x *hw);
+
+int hfa384x_corereset(struct hfa384x *hw, int holdtime, int settletime,
+		      int genesis);
+int hfa384x_drvr_commtallies(struct hfa384x *hw);
+int hfa384x_drvr_disable(struct hfa384x *hw, u16 macport);
+int hfa384x_drvr_enable(struct hfa384x *hw, u16 macport);
+int hfa384x_drvr_flashdl_enable(struct hfa384x *hw);
+int hfa384x_drvr_flashdl_disable(struct hfa384x *hw);
+int hfa384x_drvr_flashdl_write(struct hfa384x *hw, u32 daddr, void *buf,
+			       u32 len);
+int hfa384x_drvr_getconfig(struct hfa384x *hw, u16 rid, void *buf, u16 len);
+int hfa384x_drvr_ramdl_enable(struct hfa384x *hw, u32 exeaddr);
+int hfa384x_drvr_ramdl_disable(struct hfa384x *hw);
+int hfa384x_drvr_ramdl_write(struct hfa384x *hw, u32 daddr, void *buf, u32 len);
+int hfa384x_drvr_readpda(struct hfa384x *hw, void *buf, unsigned int len);
+int hfa384x_drvr_setconfig(struct hfa384x *hw, u16 rid, void *buf, u16 len);
+
+static inline int hfa384x_drvr_getconfig16(struct hfa384x *hw, u16 rid,
+					   void *val)
 {
 	int result = 0;
 	result = hfa384x_drvr_getconfig(hw, rid, val, sizeof(u16));
@@ -1379,44 +1376,44 @@ static inline int hfa384x_drvr_getconfig16(hfa384x_t *hw, u16 rid, void *val)
 	return result;
 }
 
-static inline int hfa384x_drvr_setconfig16(hfa384x_t *hw, u16 rid, u16 val)
+static inline int hfa384x_drvr_setconfig16(struct hfa384x *hw, u16 rid, u16 val)
 {
 	u16 value = cpu_to_le16(val);
 	return hfa384x_drvr_setconfig(hw, rid, &value, sizeof(value));
 }
 
 int
-hfa384x_drvr_getconfig_async(hfa384x_t *hw,
+hfa384x_drvr_getconfig_async(struct hfa384x *hw,
 			     u16 rid, ctlx_usercb_t usercb, void *usercb_data);
 
 int
-hfa384x_drvr_setconfig_async(hfa384x_t *hw,
+hfa384x_drvr_setconfig_async(struct hfa384x *hw,
 			     u16 rid,
 			     void *buf,
 			     u16 len, ctlx_usercb_t usercb, void *usercb_data);
 
 static inline int
-hfa384x_drvr_setconfig16_async(hfa384x_t *hw, u16 rid, u16 val)
+hfa384x_drvr_setconfig16_async(struct hfa384x *hw, u16 rid, u16 val)
 {
 	u16 value = cpu_to_le16(val);
 	return hfa384x_drvr_setconfig_async(hw, rid, &value, sizeof(value),
 					    NULL, NULL);
 }
 
-int hfa384x_drvr_start(hfa384x_t *hw);
-int hfa384x_drvr_stop(hfa384x_t *hw);
+int hfa384x_drvr_start(struct hfa384x *hw);
+int hfa384x_drvr_stop(struct hfa384x *hw);
 int
-hfa384x_drvr_txframe(hfa384x_t *hw, struct sk_buff *skb,
+hfa384x_drvr_txframe(struct hfa384x *hw, struct sk_buff *skb,
 		     p80211_hdr_t *p80211_hdr, p80211_metawep_t *p80211_wep);
 void hfa384x_tx_timeout(wlandevice_t *wlandev);
 
-int hfa384x_cmd_initialize(hfa384x_t *hw);
-int hfa384x_cmd_enable(hfa384x_t *hw, u16 macport);
-int hfa384x_cmd_disable(hfa384x_t *hw, u16 macport);
-int hfa384x_cmd_allocate(hfa384x_t *hw, u16 len);
-int hfa384x_cmd_monitor(hfa384x_t *hw, u16 enable);
+int hfa384x_cmd_initialize(struct hfa384x *hw);
+int hfa384x_cmd_enable(struct hfa384x *hw, u16 macport);
+int hfa384x_cmd_disable(struct hfa384x *hw, u16 macport);
+int hfa384x_cmd_allocate(struct hfa384x *hw, u16 len);
+int hfa384x_cmd_monitor(struct hfa384x *hw, u16 enable);
 int
-hfa384x_cmd_download(hfa384x_t *hw,
+hfa384x_cmd_download(struct hfa384x *hw,
 		     u16 mode, u16 lowaddr, u16 highaddr, u16 codelen);
 
 #endif /*__KERNEL__ */
diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index a41db5d..25bfb42 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -156,13 +156,13 @@ static void dbprint_urb(struct urb *urb);
 #endif
 
 static void
-hfa384x_int_rxmonitor(wlandevice_t *wlandev, hfa384x_usb_rxfrm_t *rxfrm);
+hfa384x_int_rxmonitor(wlandevice_t *wlandev, struct hfa384x_usb_rxfrm *rxfrm);
 
 static void hfa384x_usb_defer(struct work_struct *data);
 
-static int submit_rx_urb(hfa384x_t *hw, gfp_t flags);
+static int submit_rx_urb(struct hfa384x *hw, gfp_t flags);
 
-static int submit_tx_urb(hfa384x_t *hw, struct urb *tx_urb, gfp_t flags);
+static int submit_tx_urb(struct hfa384x *hw, struct urb *tx_urb, gfp_t flags);
 
 /*---------------------------------------------------*/
 /* Callbacks */
@@ -171,22 +171,22 @@ static void hfa384x_ctlxout_callback(struct urb *urb);
 static void hfa384x_usbin_callback(struct urb *urb);
 
 static void
-hfa384x_usbin_txcompl(wlandevice_t *wlandev, hfa384x_usbin_t * usbin);
+hfa384x_usbin_txcompl(wlandevice_t *wlandev, union hfa384x_usbin * usbin);
 
 static void hfa384x_usbin_rx(wlandevice_t *wlandev, struct sk_buff *skb);
 
-static void hfa384x_usbin_info(wlandevice_t *wlandev, hfa384x_usbin_t * usbin);
+static void hfa384x_usbin_info(wlandevice_t *wlandev, union hfa384x_usbin * usbin);
 
 static void
-hfa384x_usbout_tx(wlandevice_t *wlandev, hfa384x_usbout_t *usbout);
+hfa384x_usbout_tx(wlandevice_t *wlandev, union hfa384x_usbout *usbout);
 
-static void hfa384x_usbin_ctlx(hfa384x_t *hw, hfa384x_usbin_t *usbin,
+static void hfa384x_usbin_ctlx(struct hfa384x *hw, union hfa384x_usbin *usbin,
 			       int urb_status);
 
 /*---------------------------------------------------*/
 /* Functions to support the prism2 usb command queue */
 
-static void hfa384x_usbctlxq_run(hfa384x_t *hw);
+static void hfa384x_usbctlxq_run(struct hfa384x *hw);
 
 static void hfa384x_usbctlx_reqtimerfn(unsigned long data);
 
@@ -198,44 +198,44 @@ static void hfa384x_usbctlx_completion_task(unsigned long data);
 
 static void hfa384x_usbctlx_reaper_task(unsigned long data);
 
-static int hfa384x_usbctlx_submit(hfa384x_t *hw, hfa384x_usbctlx_t *ctlx);
+static int hfa384x_usbctlx_submit(struct hfa384x *hw, struct hfa384x_usbctlx *ctlx);
 
-static void unlocked_usbctlx_complete(hfa384x_t *hw, hfa384x_usbctlx_t *ctlx);
+static void unlocked_usbctlx_complete(struct hfa384x *hw, struct hfa384x_usbctlx *ctlx);
 
 struct usbctlx_completor {
 	int (*complete) (struct usbctlx_completor *);
 };
 
 static int
-hfa384x_usbctlx_complete_sync(hfa384x_t *hw,
-			      hfa384x_usbctlx_t *ctlx,
+hfa384x_usbctlx_complete_sync(struct hfa384x *hw,
+			      struct hfa384x_usbctlx *ctlx,
 			      struct usbctlx_completor *completor);
 
 static int
-unlocked_usbctlx_cancel_async(hfa384x_t *hw, hfa384x_usbctlx_t *ctlx);
+unlocked_usbctlx_cancel_async(struct hfa384x *hw, struct hfa384x_usbctlx *ctlx);
 
-static void hfa384x_cb_status(hfa384x_t *hw, const hfa384x_usbctlx_t *ctlx);
+static void hfa384x_cb_status(struct hfa384x *hw, const struct hfa384x_usbctlx *ctlx);
 
-static void hfa384x_cb_rrid(hfa384x_t *hw, const hfa384x_usbctlx_t *ctlx);
+static void hfa384x_cb_rrid(struct hfa384x *hw, const struct hfa384x_usbctlx *ctlx);
 
 static int
-usbctlx_get_status(const hfa384x_usb_cmdresp_t *cmdresp,
-		   hfa384x_cmdresult_t *result);
+usbctlx_get_status(const struct hfa384x_usb_statusresp *cmdresp,
+		   struct hfa384x_statusresult *result);
 
 static void
-usbctlx_get_rridresult(const hfa384x_usb_rridresp_t *rridresp,
-		       hfa384x_rridresult_t *result);
+usbctlx_get_rridresult(const struct hfa384x_usb_rridresp *rridresp,
+		       struct hfa384x_rridresult *result);
 
 /*---------------------------------------------------*/
 /* Low level req/resp CTLX formatters and submitters */
 static int
-hfa384x_docmd(hfa384x_t *hw,
+hfa384x_docmd(struct hfa384x *hw,
 	      enum cmd_mode mode,
-	      hfa384x_metacmd_t *cmd,
+	      struct hfa384x_metacmd *cmd,
 	      ctlx_cmdcb_t cmdcb, ctlx_usercb_t usercb, void *usercb_data);
 
 static int
-hfa384x_dorrid(hfa384x_t *hw,
+hfa384x_dorrid(struct hfa384x *hw,
 	       enum cmd_mode mode,
 	       u16 rid,
 	       void *riddata,
@@ -243,7 +243,7 @@ hfa384x_dorrid(hfa384x_t *hw,
 	       ctlx_cmdcb_t cmdcb, ctlx_usercb_t usercb, void *usercb_data);
 
 static int
-hfa384x_dowrid(hfa384x_t *hw,
+hfa384x_dowrid(struct hfa384x *hw,
 	       enum cmd_mode mode,
 	       u16 rid,
 	       void *riddata,
@@ -251,7 +251,7 @@ hfa384x_dowrid(hfa384x_t *hw,
 	       ctlx_cmdcb_t cmdcb, ctlx_usercb_t usercb, void *usercb_data);
 
 static int
-hfa384x_dormem(hfa384x_t *hw,
+hfa384x_dormem(struct hfa384x *hw,
 	       enum cmd_mode mode,
 	       u16 page,
 	       u16 offset,
@@ -260,7 +260,7 @@ hfa384x_dormem(hfa384x_t *hw,
 	       ctlx_cmdcb_t cmdcb, ctlx_usercb_t usercb, void *usercb_data);
 
 static int
-hfa384x_dowmem(hfa384x_t *hw,
+hfa384x_dowmem(struct hfa384x *hw,
 	       enum cmd_mode mode,
 	       u16 page,
 	       u16 offset,
@@ -270,7 +270,7 @@ hfa384x_dowmem(hfa384x_t *hw,
 
 static int hfa384x_isgood_pdrcode(u16 pdrcode);
 
-static inline const char *ctlxstr(CTLX_STATE s)
+static inline const char *ctlxstr(enum ctlx_state s)
 {
 	static const char *ctlx_str[] = {
 		"Initial state",
@@ -285,9 +285,9 @@ static inline const char *ctlxstr(CTLX_STATE s)
 	return ctlx_str[s];
 };
 
-static inline hfa384x_usbctlx_t *get_active_ctlx(hfa384x_t * hw)
+static inline struct hfa384x_usbctlx *get_active_ctlx(struct hfa384x * hw)
 {
-	return list_entry(hw->ctlxq.active.next, hfa384x_usbctlx_t, list);
+	return list_entry(hw->ctlxq.active.next, struct hfa384x_usbctlx, list);
 }
 
 #ifdef DEBUG_USB
@@ -329,12 +329,12 @@ void dbprint_urb(struct urb *urb)
 * Call context:
 *	Any
 ----------------------------------------------------------------*/
-static int submit_rx_urb(hfa384x_t *hw, gfp_t memflags)
+static int submit_rx_urb(struct hfa384x *hw, gfp_t memflags)
 {
 	struct sk_buff *skb;
 	int result;
 
-	skb = dev_alloc_skb(sizeof(hfa384x_usbin_t));
+	skb = dev_alloc_skb(sizeof(union hfa384x_usbin));
 	if (skb == NULL) {
 		result = -ENOMEM;
 		goto done;
@@ -343,7 +343,7 @@ static int submit_rx_urb(hfa384x_t *hw, gfp_t memflags)
 	/* Post the IN urb */
 	usb_fill_bulk_urb(&hw->rx_urb, hw->usb,
 			  hw->endp_in,
-			  skb->data, sizeof(hfa384x_usbin_t),
+			  skb->data, sizeof(union hfa384x_usbin),
 			  hfa384x_usbin_callback, hw->wlandev);
 
 	hw->rx_urb_skb = skb;
@@ -391,7 +391,7 @@ done:
 * Call context:
 *	Any
 ----------------------------------------------------------------*/
-static int submit_tx_urb(hfa384x_t *hw, struct urb *tx_urb, gfp_t memflags)
+static int submit_tx_urb(struct hfa384x *hw, struct urb *tx_urb, gfp_t memflags)
 {
 	struct net_device *netdev = hw->wlandev->netdev;
 	int result;
@@ -437,7 +437,7 @@ static int submit_tx_urb(hfa384x_t *hw, struct urb *tx_urb, gfp_t memflags)
 ----------------------------------------------------------------*/
 static void hfa384x_usb_defer(struct work_struct *data)
 {
-	hfa384x_t *hw = container_of(data, struct hfa384x, usb_work);
+	struct hfa384x *hw = container_of(data, struct hfa384x, usb_work);
 	struct net_device *netdev = hw->wlandev->netdev;
 
 	/* Don't bother trying to reset anything if the plug
@@ -510,7 +510,7 @@ static void hfa384x_usb_defer(struct work_struct *data)
 /*----------------------------------------------------------------
 * hfa384x_create
 *
-* Sets up the hfa384x_t data structure for use.  Note this
+* Sets up the struct hfa384x data structure for use.  Note this
 * does _not_ intialize the actual hardware, just the data structures
 * we use to keep track of its state.
 *
@@ -528,9 +528,9 @@ static void hfa384x_usb_defer(struct work_struct *data)
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-void hfa384x_create(hfa384x_t *hw, struct usb_device *usb)
+void hfa384x_create(struct hfa384x *hw, struct usb_device *usb)
 {
-	memset(hw, 0, sizeof(hfa384x_t));
+	memset(hw, 0, sizeof(struct hfa384x));
 	hw->usb = usb;
 
 	/* set up the endpoints */
@@ -604,7 +604,7 @@ void hfa384x_create(hfa384x_t *hw, struct usb_device *usb)
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-void hfa384x_destroy(hfa384x_t *hw)
+void hfa384x_destroy(struct hfa384x *hw)
 {
 	struct sk_buff *skb;
 
@@ -622,9 +622,9 @@ void hfa384x_destroy(hfa384x_t *hw)
 		dev_kfree_skb(skb);
 }
 
-static hfa384x_usbctlx_t *usbctlx_alloc(void)
+static struct hfa384x_usbctlx *usbctlx_alloc(void)
 {
-	hfa384x_usbctlx_t *ctlx;
+	struct hfa384x_usbctlx *ctlx;
 
 	ctlx = kmalloc(sizeof(*ctlx), in_interrupt() ? GFP_ATOMIC : GFP_KERNEL);
 	if (ctlx != NULL) {
@@ -636,8 +636,8 @@ static hfa384x_usbctlx_t *usbctlx_alloc(void)
 }
 
 static int
-usbctlx_get_status(const hfa384x_usb_cmdresp_t *cmdresp,
-		   hfa384x_cmdresult_t *result)
+usbctlx_get_status(const struct hfa384x_usb_statusresp *cmdresp,
+		   struct hfa384x_statusresult *result)
 {
 	result->status = le16_to_cpu(cmdresp->status);
 	result->resp0 = le16_to_cpu(cmdresp->resp0);
@@ -652,8 +652,8 @@ usbctlx_get_status(const hfa384x_usb_cmdresp_t *cmdresp,
 }
 
 static void
-usbctlx_get_rridresult(const hfa384x_usb_rridresp_t *rridresp,
-		       hfa384x_rridresult_t *result)
+usbctlx_get_rridresult(const struct hfa384x_usb_rridresp *rridresp,
+		       struct hfa384x_rridresult *result)
 {
 	result->rid = le16_to_cpu(rridresp->rid);
 	result->riddata = rridresp->data;
@@ -664,13 +664,13 @@ usbctlx_get_rridresult(const hfa384x_usb_rridresp_t *rridresp,
 /*----------------------------------------------------------------
 * Completor object:
 * This completor must be passed to hfa384x_usbctlx_complete_sync()
-* when processing a CTLX that returns a hfa384x_cmdresult_t structure.
+* when processing a CTLX that returns a struct hfa384x_statusresult structure.
 ----------------------------------------------------------------*/
 struct usbctlx_cmd_completor {
 	struct usbctlx_completor head;
 
-	const hfa384x_usb_cmdresp_t *cmdresp;
-	hfa384x_cmdresult_t *result;
+	const struct hfa384x_usb_statusresp *cmdresp;
+	struct hfa384x_statusresult *result;
 };
 
 static inline int usbctlx_cmd_completor_fn(struct usbctlx_completor *head)
@@ -684,9 +684,9 @@ static inline int usbctlx_cmd_completor_fn(struct usbctlx_completor *head)
 static inline struct usbctlx_completor *init_cmd_completor(
 						struct usbctlx_cmd_completor
 							*completor,
-						const hfa384x_usb_cmdresp_t
+						const struct hfa384x_usb_statusresp
 							*cmdresp,
-						hfa384x_cmdresult_t *result)
+						struct hfa384x_statusresult *result)
 {
 	completor->head.complete = usbctlx_cmd_completor_fn;
 	completor->cmdresp = cmdresp;
@@ -702,7 +702,7 @@ static inline struct usbctlx_completor *init_cmd_completor(
 struct usbctlx_rrid_completor {
 	struct usbctlx_completor head;
 
-	const hfa384x_usb_rridresp_t *rridresp;
+	const struct hfa384x_usb_rridresp *rridresp;
 	void *riddata;
 	unsigned int riddatalen;
 };
@@ -710,7 +710,7 @@ struct usbctlx_rrid_completor {
 static int usbctlx_rrid_completor_fn(struct usbctlx_completor *head)
 {
 	struct usbctlx_rrid_completor *complete;
-	hfa384x_rridresult_t rridresult;
+	struct hfa384x_rridresult rridresult;
 
 	complete = (struct usbctlx_rrid_completor *) head;
 	usbctlx_get_rridresult(complete->rridresp, &rridresult);
@@ -731,7 +731,7 @@ static int usbctlx_rrid_completor_fn(struct usbctlx_completor *head)
 static inline struct usbctlx_completor *init_rrid_completor(
 						struct usbctlx_rrid_completor
 							*completor,
-						const hfa384x_usb_rridresp_t
+						const struct hfa384x_usb_rridresp
 							*rridresp,
 						void *riddata,
 						unsigned int riddatalen)
@@ -764,7 +764,7 @@ typedef struct usbctlx_cmd_completor usbctlx_wmem_completor_t;
 struct usbctlx_rmem_completor {
 	struct usbctlx_completor head;
 
-	const hfa384x_usb_rmemresp_t *rmemresp;
+	const struct hfa384x_usb_rmemresp *rmemresp;
 	void *data;
 	unsigned int len;
 };
@@ -782,7 +782,7 @@ static int usbctlx_rmem_completor_fn(struct usbctlx_completor *head)
 static inline struct usbctlx_completor *init_rmem_completor(
 						usbctlx_rmem_completor_t
 							*completor,
-						hfa384x_usb_rmemresp_t
+						struct hfa384x_usb_rmemresp
 							*rmemresp,
 						void *data,
 						unsigned int len)
@@ -815,10 +815,10 @@ static inline struct usbctlx_completor *init_rmem_completor(
 * Call context:
 *	interrupt
 ----------------------------------------------------------------*/
-static void hfa384x_cb_status(hfa384x_t *hw, const hfa384x_usbctlx_t *ctlx)
+static void hfa384x_cb_status(struct hfa384x *hw, const struct hfa384x_usbctlx *ctlx)
 {
 	if (ctlx->usercb != NULL) {
-		hfa384x_cmdresult_t cmdresult;
+		struct hfa384x_statusresult cmdresult;
 
 		if (ctlx->state != CTLX_COMPLETE) {
 			memset(&cmdresult, 0, sizeof(cmdresult));
@@ -852,10 +852,10 @@ static void hfa384x_cb_status(hfa384x_t *hw, const hfa384x_usbctlx_t *ctlx)
 * Call context:
 *	interrupt
 ----------------------------------------------------------------*/
-static void hfa384x_cb_rrid(hfa384x_t *hw, const hfa384x_usbctlx_t *ctlx)
+static void hfa384x_cb_rrid(struct hfa384x *hw, const struct hfa384x_usbctlx *ctlx)
 {
 	if (ctlx->usercb != NULL) {
-		hfa384x_rridresult_t rridresult;
+		struct hfa384x_rridresult rridresult;
 
 		if (ctlx->state != CTLX_COMPLETE) {
 			memset(&rridresult, 0, sizeof(rridresult));
@@ -869,21 +869,21 @@ static void hfa384x_cb_rrid(hfa384x_t *hw, const hfa384x_usbctlx_t *ctlx)
 	}
 }
 
-static inline int hfa384x_docmd_wait(hfa384x_t *hw, hfa384x_metacmd_t *cmd)
+static inline int hfa384x_docmd_wait(struct hfa384x *hw, struct hfa384x_metacmd *cmd)
 {
 	return hfa384x_docmd(hw, DOWAIT, cmd, NULL, NULL, NULL);
 }
 
 static inline int
-hfa384x_docmd_async(hfa384x_t *hw,
-		    hfa384x_metacmd_t *cmd,
+hfa384x_docmd_async(struct hfa384x *hw,
+		    struct hfa384x_metacmd *cmd,
 		    ctlx_cmdcb_t cmdcb, ctlx_usercb_t usercb, void *usercb_data)
 {
 	return hfa384x_docmd(hw, DOASYNC, cmd, cmdcb, usercb, usercb_data);
 }
 
 static inline int
-hfa384x_dorrid_wait(hfa384x_t *hw, u16 rid, void *riddata,
+hfa384x_dorrid_wait(struct hfa384x *hw, u16 rid, void *riddata,
 		    unsigned int riddatalen)
 {
 	return hfa384x_dorrid(hw, DOWAIT,
@@ -891,7 +891,7 @@ hfa384x_dorrid_wait(hfa384x_t *hw, u16 rid, void *riddata,
 }
 
 static inline int
-hfa384x_dorrid_async(hfa384x_t *hw,
+hfa384x_dorrid_async(struct hfa384x *hw,
 		     u16 rid, void *riddata, unsigned int riddatalen,
 		     ctlx_cmdcb_t cmdcb,
 		     ctlx_usercb_t usercb, void *usercb_data)
@@ -902,7 +902,7 @@ hfa384x_dorrid_async(hfa384x_t *hw,
 }
 
 static inline int
-hfa384x_dowrid_wait(hfa384x_t *hw, u16 rid, void *riddata,
+hfa384x_dowrid_wait(struct hfa384x *hw, u16 rid, void *riddata,
 		    unsigned int riddatalen)
 {
 	return hfa384x_dowrid(hw, DOWAIT,
@@ -910,7 +910,7 @@ hfa384x_dowrid_wait(hfa384x_t *hw, u16 rid, void *riddata,
 }
 
 static inline int
-hfa384x_dowrid_async(hfa384x_t *hw,
+hfa384x_dowrid_async(struct hfa384x *hw,
 		     u16 rid, void *riddata, unsigned int riddatalen,
 		     ctlx_cmdcb_t cmdcb,
 		     ctlx_usercb_t usercb, void *usercb_data)
@@ -921,7 +921,7 @@ hfa384x_dowrid_async(hfa384x_t *hw,
 }
 
 static inline int
-hfa384x_dormem_wait(hfa384x_t *hw,
+hfa384x_dormem_wait(struct hfa384x *hw,
 		    u16 page, u16 offset, void *data, unsigned int len)
 {
 	return hfa384x_dormem(hw, DOWAIT,
@@ -929,7 +929,7 @@ hfa384x_dormem_wait(hfa384x_t *hw,
 }
 
 static inline int
-hfa384x_dormem_async(hfa384x_t *hw,
+hfa384x_dormem_async(struct hfa384x *hw,
 		     u16 page, u16 offset, void *data, unsigned int len,
 		     ctlx_cmdcb_t cmdcb,
 		     ctlx_usercb_t usercb, void *usercb_data)
@@ -940,7 +940,7 @@ hfa384x_dormem_async(hfa384x_t *hw,
 }
 
 static inline int
-hfa384x_dowmem_wait(hfa384x_t *hw,
+hfa384x_dowmem_wait(struct hfa384x *hw,
 		    u16 page, u16 offset, void *data, unsigned int len)
 {
 	return hfa384x_dowmem(hw, DOWAIT,
@@ -948,7 +948,7 @@ hfa384x_dowmem_wait(hfa384x_t *hw,
 }
 
 static inline int
-hfa384x_dowmem_async(hfa384x_t *hw,
+hfa384x_dowmem_async(struct hfa384x *hw,
 		     u16 page,
 		     u16 offset,
 		     void *data,
@@ -980,11 +980,11 @@ hfa384x_dowmem_async(hfa384x_t *hw,
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-int hfa384x_cmd_initialize(hfa384x_t *hw)
+int hfa384x_cmd_initialize(struct hfa384x *hw)
 {
 	int result = 0;
 	int i;
-	hfa384x_metacmd_t cmd;
+	struct hfa384x_metacmd cmd;
 
 	cmd.cmd = HFA384x_CMDCODE_INIT;
 	cmd.parm0 = 0;
@@ -1028,10 +1028,10 @@ int hfa384x_cmd_initialize(hfa384x_t *hw)
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-int hfa384x_cmd_disable(hfa384x_t *hw, u16 macport)
+int hfa384x_cmd_disable(struct hfa384x *hw, u16 macport)
 {
 	int result = 0;
-	hfa384x_metacmd_t cmd;
+	struct hfa384x_metacmd cmd;
 
 	cmd.cmd = HFA384x_CMD_CMDCODE_SET(HFA384x_CMDCODE_DISABLE) |
 	    HFA384x_CMD_MACPORT_SET(macport);
@@ -1064,10 +1064,10 @@ int hfa384x_cmd_disable(hfa384x_t *hw, u16 macport)
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-int hfa384x_cmd_enable(hfa384x_t *hw, u16 macport)
+int hfa384x_cmd_enable(struct hfa384x *hw, u16 macport)
 {
 	int result = 0;
-	hfa384x_metacmd_t cmd;
+	struct hfa384x_metacmd cmd;
 
 	cmd.cmd = HFA384x_CMD_CMDCODE_SET(HFA384x_CMDCODE_ENABLE) |
 	    HFA384x_CMD_MACPORT_SET(macport);
@@ -1109,10 +1109,10 @@ int hfa384x_cmd_enable(hfa384x_t *hw, u16 macport)
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-int hfa384x_cmd_monitor(hfa384x_t *hw, u16 enable)
+int hfa384x_cmd_monitor(struct hfa384x *hw, u16 enable)
 {
 	int result = 0;
-	hfa384x_metacmd_t cmd;
+	struct hfa384x_metacmd cmd;
 
 	cmd.cmd = HFA384x_CMD_CMDCODE_SET(HFA384x_CMDCODE_MONITOR) |
 	    HFA384x_CMD_AINFO_SET(enable);
@@ -1163,11 +1163,11 @@ int hfa384x_cmd_monitor(hfa384x_t *hw, u16 enable)
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-int hfa384x_cmd_download(hfa384x_t *hw, u16 mode, u16 lowaddr,
+int hfa384x_cmd_download(struct hfa384x *hw, u16 mode, u16 lowaddr,
 			 u16 highaddr, u16 codelen)
 {
 	int result = 0;
-	hfa384x_metacmd_t cmd;
+	struct hfa384x_metacmd cmd;
 
 	pr_debug("mode=%d, lowaddr=0x%04x, highaddr=0x%04x, codelen=%d\n",
 		 mode, lowaddr, highaddr, codelen);
@@ -1207,7 +1207,7 @@ int hfa384x_cmd_download(hfa384x_t *hw, u16 mode, u16 lowaddr,
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-int hfa384x_corereset(hfa384x_t *hw, int holdtime, int settletime, int genesis)
+int hfa384x_corereset(struct hfa384x *hw, int holdtime, int settletime, int genesis)
 {
 	int result = 0;
 
@@ -1244,8 +1244,8 @@ int hfa384x_corereset(hfa384x_t *hw, int holdtime, int settletime, int genesis)
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-static int hfa384x_usbctlx_complete_sync(hfa384x_t *hw,
-					 hfa384x_usbctlx_t *ctlx,
+static int hfa384x_usbctlx_complete_sync(struct hfa384x *hw,
+					 struct hfa384x_usbctlx *ctlx,
 					 struct usbctlx_completor *completor)
 {
 	unsigned long flags;
@@ -1360,13 +1360,13 @@ cleanup:
 *	process
 ----------------------------------------------------------------*/
 static int
-hfa384x_docmd(hfa384x_t *hw,
+hfa384x_docmd(struct hfa384x *hw,
 	      enum cmd_mode mode,
-	      hfa384x_metacmd_t *cmd,
+	      struct hfa384x_metacmd *cmd,
 	      ctlx_cmdcb_t cmdcb, ctlx_usercb_t usercb, void *usercb_data)
 {
 	int result;
-	hfa384x_usbctlx_t *ctlx;
+	struct hfa384x_usbctlx *ctlx;
 
 	ctlx = usbctlx_alloc();
 	if (ctlx == NULL) {
@@ -1449,7 +1449,7 @@ done:
 *	process (DOWAIT or DOASYNC)
 ----------------------------------------------------------------*/
 static int
-hfa384x_dorrid(hfa384x_t *hw,
+hfa384x_dorrid(struct hfa384x *hw,
 	       enum cmd_mode mode,
 	       u16 rid,
 	       void *riddata,
@@ -1457,7 +1457,7 @@ hfa384x_dorrid(hfa384x_t *hw,
 	       ctlx_cmdcb_t cmdcb, ctlx_usercb_t usercb, void *usercb_data)
 {
 	int result;
-	hfa384x_usbctlx_t *ctlx;
+	struct hfa384x_usbctlx *ctlx;
 
 	ctlx = usbctlx_alloc();
 	if (ctlx == NULL) {
@@ -1530,7 +1530,7 @@ done:
 *	process (DOWAIT or DOASYNC)
 ----------------------------------------------------------------*/
 static int
-hfa384x_dowrid(hfa384x_t *hw,
+hfa384x_dowrid(struct hfa384x *hw,
 	       enum cmd_mode mode,
 	       u16 rid,
 	       void *riddata,
@@ -1538,7 +1538,7 @@ hfa384x_dowrid(hfa384x_t *hw,
 	       ctlx_cmdcb_t cmdcb, ctlx_usercb_t usercb, void *usercb_data)
 {
 	int result;
-	hfa384x_usbctlx_t *ctlx;
+	struct hfa384x_usbctlx *ctlx;
 
 	ctlx = usbctlx_alloc();
 	if (ctlx == NULL) {
@@ -1569,7 +1569,7 @@ hfa384x_dowrid(hfa384x_t *hw,
 		kfree(ctlx);
 	} else if (mode == DOWAIT) {
 		usbctlx_wrid_completor_t completor;
-		hfa384x_cmdresult_t wridresult;
+		struct hfa384x_statusresult wridresult;
 
 		result = hfa384x_usbctlx_complete_sync(hw,
 						       ctlx,
@@ -1617,7 +1617,7 @@ done:
 *	process (DOWAIT or DOASYNC)
 ----------------------------------------------------------------*/
 static int
-hfa384x_dormem(hfa384x_t *hw,
+hfa384x_dormem(struct hfa384x *hw,
 	       enum cmd_mode mode,
 	       u16 page,
 	       u16 offset,
@@ -1626,7 +1626,7 @@ hfa384x_dormem(hfa384x_t *hw,
 	       ctlx_cmdcb_t cmdcb, ctlx_usercb_t usercb, void *usercb_data)
 {
 	int result;
-	hfa384x_usbctlx_t *ctlx;
+	struct hfa384x_usbctlx *ctlx;
 
 	ctlx = usbctlx_alloc();
 	if (ctlx == NULL) {
@@ -1708,7 +1708,7 @@ done:
 *	process (DOWAIT or DOASYNC)
 ----------------------------------------------------------------*/
 static int
-hfa384x_dowmem(hfa384x_t *hw,
+hfa384x_dowmem(struct hfa384x *hw,
 	       enum cmd_mode mode,
 	       u16 page,
 	       u16 offset,
@@ -1717,7 +1717,7 @@ hfa384x_dowmem(hfa384x_t *hw,
 	       ctlx_cmdcb_t cmdcb, ctlx_usercb_t usercb, void *usercb_data)
 {
 	int result;
-	hfa384x_usbctlx_t *ctlx;
+	struct hfa384x_usbctlx *ctlx;
 
 	pr_debug("page=0x%04x offset=0x%04x len=%d\n", page, offset, len);
 
@@ -1751,7 +1751,7 @@ hfa384x_dowmem(hfa384x_t *hw,
 		kfree(ctlx);
 	} else if (mode == DOWAIT) {
 		usbctlx_wmem_completor_t completor;
-		hfa384x_cmdresult_t wmemresult;
+		struct hfa384x_statusresult wmemresult;
 
 		result = hfa384x_usbctlx_complete_sync(hw,
 						       ctlx,
@@ -1782,9 +1782,9 @@ done:
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-int hfa384x_drvr_commtallies(hfa384x_t *hw)
+int hfa384x_drvr_commtallies(struct hfa384x *hw)
 {
-	hfa384x_metacmd_t cmd;
+	struct hfa384x_metacmd cmd;
 
 	cmd.cmd = HFA384x_CMDCODE_INQ;
 	cmd.parm0 = HFA384x_IT_COMMTALLIES;
@@ -1818,7 +1818,7 @@ int hfa384x_drvr_commtallies(hfa384x_t *hw)
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-int hfa384x_drvr_disable(hfa384x_t *hw, u16 macport)
+int hfa384x_drvr_disable(struct hfa384x *hw, u16 macport)
 {
 	int result = 0;
 
@@ -1856,7 +1856,7 @@ int hfa384x_drvr_disable(hfa384x_t *hw, u16 macport)
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-int hfa384x_drvr_enable(hfa384x_t *hw, u16 macport)
+int hfa384x_drvr_enable(struct hfa384x *hw, u16 macport)
 {
 	int result = 0;
 
@@ -1893,7 +1893,7 @@ int hfa384x_drvr_enable(hfa384x_t *hw, u16 macport)
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-int hfa384x_drvr_flashdl_enable(hfa384x_t *hw)
+int hfa384x_drvr_flashdl_enable(struct hfa384x *hw)
 {
 	int result = 0;
 	int i;
@@ -1952,7 +1952,7 @@ int hfa384x_drvr_flashdl_enable(hfa384x_t *hw)
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-int hfa384x_drvr_flashdl_disable(hfa384x_t *hw)
+int hfa384x_drvr_flashdl_disable(struct hfa384x *hw)
 {
 	/* Check that we're already in the download state */
 	if (hw->dlstate != HFA384x_DLSTATE_FLASHENABLED)
@@ -1997,7 +1997,7 @@ int hfa384x_drvr_flashdl_disable(hfa384x_t *hw)
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
+int hfa384x_drvr_flashdl_write(struct hfa384x *hw, u32 daddr, void *buf, u32 len)
 {
 	int result = 0;
 	u32 dlbufaddr;
@@ -2140,7 +2140,7 @@ exit_proc:
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-int hfa384x_drvr_getconfig(hfa384x_t *hw, u16 rid, void *buf, u16 len)
+int hfa384x_drvr_getconfig(struct hfa384x *hw, u16 rid, void *buf, u16 len)
 {
 	int result;
 
@@ -2177,7 +2177,7 @@ int hfa384x_drvr_getconfig(hfa384x_t *hw, u16 rid, void *buf, u16 len)
  *       Any
  ----------------------------------------------------------------*/
 int
-hfa384x_drvr_getconfig_async(hfa384x_t *hw,
+hfa384x_drvr_getconfig_async(struct hfa384x *hw,
 			     u16 rid, ctlx_usercb_t usercb, void *usercb_data)
 {
 	return hfa384x_dorrid_async(hw, rid, NULL, 0,
@@ -2208,7 +2208,7 @@ hfa384x_drvr_getconfig_async(hfa384x_t *hw,
  *       process
  ----------------------------------------------------------------*/
 int
-hfa384x_drvr_setconfig_async(hfa384x_t *hw,
+hfa384x_drvr_setconfig_async(struct hfa384x *hw,
 			     u16 rid,
 			     void *buf,
 			     u16 len, ctlx_usercb_t usercb, void *usercb_data)
@@ -2235,7 +2235,7 @@ hfa384x_drvr_setconfig_async(hfa384x_t *hw,
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-int hfa384x_drvr_ramdl_disable(hfa384x_t *hw)
+int hfa384x_drvr_ramdl_disable(struct hfa384x *hw)
 {
 	/* Check that we're already in the download state */
 	if (hw->dlstate != HFA384x_DLSTATE_RAMENABLED)
@@ -2275,7 +2275,7 @@ int hfa384x_drvr_ramdl_disable(hfa384x_t *hw)
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-int hfa384x_drvr_ramdl_enable(hfa384x_t *hw, u32 exeaddr)
+int hfa384x_drvr_ramdl_enable(struct hfa384x *hw, u32 exeaddr)
 {
 	int result = 0;
 	u16 lowaddr;
@@ -2343,7 +2343,7 @@ int hfa384x_drvr_ramdl_enable(hfa384x_t *hw, u32 exeaddr)
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-int hfa384x_drvr_ramdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
+int hfa384x_drvr_ramdl_write(struct hfa384x *hw, u32 daddr, void *buf, u32 len)
 {
 	int result = 0;
 	int nwrites;
@@ -2422,7 +2422,7 @@ int hfa384x_drvr_ramdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 * Call context:
 *	process or non-card interrupt.
 ----------------------------------------------------------------*/
-int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len)
+int hfa384x_drvr_readpda(struct hfa384x *hw, void *buf, unsigned int len)
 {
 	int result = 0;
 	u16 *pda = buf;
@@ -2530,7 +2530,7 @@ int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len)
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-int hfa384x_drvr_setconfig(hfa384x_t *hw, u16 rid, void *buf, u16 len)
+int hfa384x_drvr_setconfig(struct hfa384x *hw, u16 rid, void *buf, u16 len)
 {
 	return hfa384x_dowrid_wait(hw, rid, buf, len);
 }
@@ -2555,7 +2555,7 @@ int hfa384x_drvr_setconfig(hfa384x_t *hw, u16 rid, void *buf, u16 len)
 *	process
 ----------------------------------------------------------------*/
 
-int hfa384x_drvr_start(hfa384x_t *hw)
+int hfa384x_drvr_start(struct hfa384x *hw)
 {
 	int result, result1, result2;
 	u16 status;
@@ -2654,7 +2654,7 @@ done:
 * Call context:
 *	process
 ----------------------------------------------------------------*/
-int hfa384x_drvr_stop(hfa384x_t *hw)
+int hfa384x_drvr_stop(struct hfa384x *hw)
 {
 	int result = 0;
 	int i;
@@ -2705,11 +2705,11 @@ int hfa384x_drvr_stop(hfa384x_t *hw)
 * Call context:
 *	interrupt
 ----------------------------------------------------------------*/
-int hfa384x_drvr_txframe(hfa384x_t *hw, struct sk_buff *skb,
+int hfa384x_drvr_txframe(struct hfa384x *hw, struct sk_buff *skb,
 			 p80211_hdr_t *p80211_hdr,
 			 p80211_metawep_t *p80211_wep)
 {
-	int usbpktlen = sizeof(hfa384x_tx_frame_t);
+	int usbpktlen = sizeof(struct hfa384x);
 	int result;
 	int ret;
 	char *ptr;
@@ -2800,7 +2800,7 @@ exit:
 
 void hfa384x_tx_timeout(wlandevice_t *wlandev)
 {
-	hfa384x_t *hw = wlandev->priv;
+	struct hfa384x *hw = wlandev->priv;
 	unsigned long flags;
 
 	spin_lock_irqsave(&hw->ctlxq.lock, flags);
@@ -2821,7 +2821,7 @@ void hfa384x_tx_timeout(wlandevice_t *wlandev)
 * Tasklet to delete dead CTLX objects
 *
 * Arguments:
-*	data	ptr to a hfa384x_t
+*	data	ptr to a struct hfa384x
 *
 * Returns:
 *
@@ -2830,7 +2830,7 @@ void hfa384x_tx_timeout(wlandevice_t *wlandev)
 ----------------------------------------------------------------*/
 static void hfa384x_usbctlx_reaper_task(unsigned long data)
 {
-	hfa384x_t *hw = (hfa384x_t *) data;
+	struct hfa384x *hw = (struct hfa384x *) data;
 	struct list_head *entry;
 	struct list_head *temp;
 	unsigned long flags;
@@ -2841,9 +2841,9 @@ static void hfa384x_usbctlx_reaper_task(unsigned long data)
 	 * has unplugged the adapter.
 	 */
 	list_for_each_safe(entry, temp, &hw->ctlxq.reapable) {
-		hfa384x_usbctlx_t *ctlx;
+		struct hfa384x_usbctlx *ctlx;
 
-		ctlx = list_entry(entry, hfa384x_usbctlx_t, list);
+		ctlx = list_entry(entry, struct hfa384x_usbctlx, list);
 		list_del(&ctlx->list);
 		kfree(ctlx);
 	}
@@ -2858,7 +2858,7 @@ static void hfa384x_usbctlx_reaper_task(unsigned long data)
 * Tasklet to call completion handlers for returned CTLXs
 *
 * Arguments:
-*	data	ptr to hfa384x_t
+*	data	ptr to struct hfa384x
 *
 * Returns:
 *	Nothing
@@ -2868,7 +2868,7 @@ static void hfa384x_usbctlx_reaper_task(unsigned long data)
 ----------------------------------------------------------------*/
 static void hfa384x_usbctlx_completion_task(unsigned long data)
 {
-	hfa384x_t *hw = (hfa384x_t *) data;
+	struct hfa384x *hw = (struct hfa384x *) data;
 	struct list_head *entry;
 	struct list_head *temp;
 	unsigned long flags;
@@ -2881,9 +2881,9 @@ static void hfa384x_usbctlx_completion_task(unsigned long data)
 	 * has unplugged the adapter ...
 	 */
 	list_for_each_safe(entry, temp, &hw->ctlxq.completing) {
-		hfa384x_usbctlx_t *ctlx;
+		struct hfa384x_usbctlx *ctlx;
 
-		ctlx = list_entry(entry, hfa384x_usbctlx_t, list);
+		ctlx = list_entry(entry, struct hfa384x_usbctlx, list);
 
 		/* Call the completion function that this
 		 * command was assigned, assuming it has one.
@@ -2937,7 +2937,7 @@ static void hfa384x_usbctlx_completion_task(unsigned long data)
 * next command on the queue is run afterwards.
 *
 * Arguments:
-*	hw	ptr to the hfa384x_t structure
+*	hw	ptr to the struct hfa384x structure
 *	ctlx	ptr to a CTLX structure
 *
 * Returns:
@@ -2947,8 +2947,8 @@ static void hfa384x_usbctlx_completion_task(unsigned long data)
 * Call context:
 *	Either process or interrupt, but presumably interrupt
 ----------------------------------------------------------------*/
-static int unlocked_usbctlx_cancel_async(hfa384x_t *hw,
-					 hfa384x_usbctlx_t *ctlx)
+static int unlocked_usbctlx_cancel_async(struct hfa384x *hw,
+					 struct hfa384x_usbctlx *ctlx)
 {
 	int ret;
 
@@ -2986,7 +2986,7 @@ static int unlocked_usbctlx_cancel_async(hfa384x_t *hw,
 * tasklet is scheduled.
 *
 * Arguments:
-*	hw		ptr to a hfa384x_t structure
+*	hw		ptr to a struct hfa384x structure
 *	ctlx		ptr to a ctlx structure
 *
 * Returns:
@@ -2997,7 +2997,7 @@ static int unlocked_usbctlx_cancel_async(hfa384x_t *hw,
 * Call context:
 *	Either, assume interrupt
 ----------------------------------------------------------------*/
-static void unlocked_usbctlx_complete(hfa384x_t *hw, hfa384x_usbctlx_t *ctlx)
+static void unlocked_usbctlx_complete(struct hfa384x *hw, struct hfa384x_usbctlx *ctlx)
 {
 	/* Timers have been stopped, and ctlx should be in
 	 * a terminal state. Retire it from the "active"
@@ -3025,7 +3025,7 @@ static void unlocked_usbctlx_complete(hfa384x_t *hw, hfa384x_usbctlx_t *ctlx)
 * Checks to see if the head item is running.  If not, starts it.
 *
 * Arguments:
-*	hw	ptr to hfa384x_t
+*	hw	ptr to struct hfa384x
 *
 * Returns:
 *	nothing
@@ -3035,7 +3035,7 @@ static void unlocked_usbctlx_complete(hfa384x_t *hw, hfa384x_usbctlx_t *ctlx)
 * Call context:
 *	any
 ----------------------------------------------------------------*/
-static void hfa384x_usbctlxq_run(hfa384x_t *hw)
+static void hfa384x_usbctlxq_run(struct hfa384x *hw)
 {
 	unsigned long flags;
 
@@ -3054,12 +3054,12 @@ static void hfa384x_usbctlxq_run(hfa384x_t *hw)
 		goto unlock;
 
 	while (!list_empty(&hw->ctlxq.pending)) {
-		hfa384x_usbctlx_t *head;
+		struct hfa384x_usbctlx *head;
 		int result;
 
 		/* This is the first pending command */
 		head = list_entry(hw->ctlxq.pending.next,
-				  hfa384x_usbctlx_t, list);
+				  struct hfa384x_usbctlx, list);
 
 		/* We need to split this off to avoid a race condition */
 		list_move_tail(&head->list, &hw->ctlxq.active);
@@ -3138,8 +3138,8 @@ unlock:
 static void hfa384x_usbin_callback(struct urb *urb)
 {
 	wlandevice_t *wlandev = urb->context;
-	hfa384x_t *hw;
-	hfa384x_usbin_t *usbin = (hfa384x_usbin_t *) urb->transfer_buffer;
+	struct hfa384x *hw;
+	union hfa384x_usbin *usbin = (union hfa384x_usbin *) urb->transfer_buffer;
 	struct sk_buff *skb = NULL;
 	int result;
 	int urb_status;
@@ -3303,7 +3303,7 @@ exit:
 * queue and our state updated accordingly.
 *
 * Arguments:
-*	hw		ptr to hfa384x_t
+*	hw		ptr to struct hfa384x
 *	usbin		ptr to USB IN packet
 *	urb_status	status of this Bulk-In URB
 *
@@ -3315,10 +3315,10 @@ exit:
 * Call context:
 *	interrupt
 ----------------------------------------------------------------*/
-static void hfa384x_usbin_ctlx(hfa384x_t *hw, hfa384x_usbin_t *usbin,
+static void hfa384x_usbin_ctlx(struct hfa384x *hw, union hfa384x_usbin *usbin,
 			       int urb_status)
 {
-	hfa384x_usbctlx_t *ctlx;
+	struct hfa384x_usbctlx *ctlx;
 	int run_queue = 0;
 	unsigned long flags;
 
@@ -3436,7 +3436,7 @@ unlock:
 *	interrupt
 ----------------------------------------------------------------*/
 static void hfa384x_usbin_txcompl(wlandevice_t *wlandev,
-				  hfa384x_usbin_t *usbin)
+				  union hfa384x_usbin *usbin)
 {
 	u16 status;
 
@@ -3468,8 +3468,8 @@ static void hfa384x_usbin_txcompl(wlandevice_t *wlandev,
 ----------------------------------------------------------------*/
 static void hfa384x_usbin_rx(wlandevice_t *wlandev, struct sk_buff *skb)
 {
-	hfa384x_usbin_t *usbin = (hfa384x_usbin_t *) skb->data;
-	hfa384x_t *hw = wlandev->priv;
+	union hfa384x_usbin *usbin = (union hfa384x_usbin *) skb->data;
+	struct hfa384x *hw = wlandev->priv;
 	int hdrlen;
 	p80211_rxmeta_t *rxmeta;
 	u16 data_len;
@@ -3496,7 +3496,7 @@ static void hfa384x_usbin_rx(wlandevice_t *wlandev, struct sk_buff *skb)
 		hdrlen = p80211_headerlen(fc);
 
 		/* Pull off the descriptor */
-		skb_pull(skb, sizeof(hfa384x_rx_frame_t));
+		skb_pull(skb, sizeof(struct hfa384x_rx_frame));
 
 		/* Now shunt the header block up against the data block
 		 * with an "overlapping" copy
@@ -3570,16 +3570,16 @@ done:
 *	interrupt
 ----------------------------------------------------------------*/
 static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
-				  hfa384x_usb_rxfrm_t *rxfrm)
+				  struct hfa384x_usb_rxfrm *rxfrm)
 {
-	hfa384x_rx_frame_t *rxdesc = &(rxfrm->desc);
+	struct hfa384x_rx_frame *rxdesc = &(rxfrm->desc);
 	unsigned int hdrlen = 0;
 	unsigned int datalen = 0;
 	unsigned int skblen = 0;
 	u8 *datap;
 	u16 fc;
 	struct sk_buff *skb;
-	hfa384x_t *hw = wlandev->priv;
+	struct hfa384x *hw = wlandev->priv;
 
 	/* Remember the status, time, and data_len fields are in host order */
 	/* Figure out how big the frame is */
@@ -3676,7 +3676,7 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 * Call context:
 *	interrupt
 ----------------------------------------------------------------*/
-static void hfa384x_usbin_info(wlandevice_t *wlandev, hfa384x_usbin_t *usbin)
+static void hfa384x_usbin_info(wlandevice_t *wlandev, union hfa384x_usbin *usbin)
 {
 	usbin->infofrm.info.framelen =
 	    le16_to_cpu(usbin->infofrm.info.framelen);
@@ -3702,7 +3702,7 @@ static void hfa384x_usbin_info(wlandevice_t *wlandev, hfa384x_usbin_t *usbin)
 static void hfa384x_usbout_callback(struct urb *urb)
 {
 	wlandevice_t *wlandev = urb->context;
-	hfa384x_usbout_t *usbout = urb->transfer_buffer;
+	union hfa384x_usbout *usbout = urb->transfer_buffer;
 
 #ifdef DEBUG_USB
 	dbprint_urb(urb);
@@ -3717,7 +3717,7 @@ static void hfa384x_usbout_callback(struct urb *urb)
 
 		case -EPIPE:
 			{
-				hfa384x_t *hw = wlandev->priv;
+				struct hfa384x *hw = wlandev->priv;
 				printk(KERN_WARNING
 				       "%s tx pipe stalled: requesting reset\n",
 				       wlandev->netdev->name);
@@ -3732,7 +3732,7 @@ static void hfa384x_usbout_callback(struct urb *urb)
 		case -ETIMEDOUT:
 		case -EILSEQ:
 			{
-				hfa384x_t *hw = wlandev->priv;
+				struct hfa384x *hw = wlandev->priv;
 
 				if (!test_and_set_bit
 				    (THROTTLE_TX, &hw->usb_flags)
@@ -3777,11 +3777,11 @@ static void hfa384x_usbout_callback(struct urb *urb)
 ----------------------------------------------------------------*/
 static void hfa384x_ctlxout_callback(struct urb *urb)
 {
-	hfa384x_t *hw = urb->context;
+	struct hfa384x *hw = urb->context;
 	int delete_resptimer = 0;
 	int timer_ok = 1;
 	int run_queue = 0;
-	hfa384x_usbctlx_t *ctlx;
+	struct hfa384x_usbctlx *ctlx;
 	unsigned long flags;
 
 	pr_debug("urb->status=%d\n", urb->status);
@@ -3899,7 +3899,7 @@ done:
 * URB containing a Prism2.x XXX_Request was never called.
 *
 * Arguments:
-*	data		a ptr to the hfa384x_t
+*	data		a ptr to the struct hfa384x
 *
 * Returns:
 *	nothing
@@ -3911,7 +3911,7 @@ done:
 ----------------------------------------------------------------*/
 static void hfa384x_usbctlx_reqtimerfn(unsigned long data)
 {
-	hfa384x_t *hw = (hfa384x_t *) data;
+	struct hfa384x *hw = (struct hfa384x *) data;
 	unsigned long flags;
 
 	spin_lock_irqsave(&hw->ctlxq.lock, flags);
@@ -3928,7 +3928,7 @@ static void hfa384x_usbctlx_reqtimerfn(unsigned long data)
 		 */
 		hw->ctlx_urb.transfer_flags |= URB_ASYNC_UNLINK;
 		if (usb_unlink_urb(&hw->ctlx_urb) == -EINPROGRESS) {
-			hfa384x_usbctlx_t *ctlx = get_active_ctlx(hw);
+			struct hfa384x_usbctlx *ctlx = get_active_ctlx(hw);
 
 			ctlx->state = CTLX_REQ_FAILED;
 
@@ -3957,7 +3957,7 @@ static void hfa384x_usbctlx_reqtimerfn(unsigned long data)
 * URB containing a Prism2.x XXX_Response was never called.
 *
 * Arguments:
-*	data		a ptr to the hfa384x_t
+*	data		a ptr to the struct hfa384x
 *
 * Returns:
 *	nothing
@@ -3969,7 +3969,7 @@ static void hfa384x_usbctlx_reqtimerfn(unsigned long data)
 ----------------------------------------------------------------*/
 static void hfa384x_usbctlx_resptimerfn(unsigned long data)
 {
-	hfa384x_t *hw = (hfa384x_t *) data;
+	struct hfa384x *hw = (struct hfa384x *) data;
 	unsigned long flags;
 
 	spin_lock_irqsave(&hw->ctlxq.lock, flags);
@@ -3980,7 +3980,7 @@ static void hfa384x_usbctlx_resptimerfn(unsigned long data)
 	 * adapter has been unplugged ...
 	 */
 	if (!list_empty(&hw->ctlxq.active)) {
-		hfa384x_usbctlx_t *ctlx = get_active_ctlx(hw);
+		struct hfa384x_usbctlx *ctlx = get_active_ctlx(hw);
 
 		if (unlocked_usbctlx_cancel_async(hw, ctlx) == 0) {
 			spin_unlock_irqrestore(&hw->ctlxq.lock, flags);
@@ -4013,7 +4013,7 @@ done:
 ----------------------------------------------------------------*/
 static void hfa384x_usb_throttlefn(unsigned long data)
 {
-	hfa384x_t *hw = (hfa384x_t *) data;
+	struct hfa384x *hw = (struct hfa384x *) data;
 	unsigned long flags;
 
 	spin_lock_irqsave(&hw->ctlxq.lock, flags);
@@ -4054,7 +4054,7 @@ static void hfa384x_usb_throttlefn(unsigned long data)
 * Call context:
 *	process or interrupt
 ----------------------------------------------------------------*/
-static int hfa384x_usbctlx_submit(hfa384x_t *hw, hfa384x_usbctlx_t *ctlx)
+static int hfa384x_usbctlx_submit(struct hfa384x *hw, struct hfa384x_usbctlx *ctlx)
 {
 	unsigned long flags;
 	int ret;
@@ -4095,7 +4095,7 @@ static int hfa384x_usbctlx_submit(hfa384x_t *hw, hfa384x_usbctlx_t *ctlx)
 * Call context:
 *	interrupt
 ----------------------------------------------------------------*/
-static void hfa384x_usbout_tx(wlandevice_t *wlandev, hfa384x_usbout_t *usbout)
+static void hfa384x_usbout_tx(wlandevice_t *wlandev, union hfa384x_usbout *usbout)
 {
 	prism2sta_ev_alloc(wlandev);
 }
diff --git a/drivers/staging/wlan-ng/p80211wext.c b/drivers/staging/wlan-ng/p80211wext.c
index 387194d..ab8f827 100644
--- a/drivers/staging/wlan-ng/p80211wext.c
+++ b/drivers/staging/wlan-ng/p80211wext.c
@@ -995,7 +995,6 @@ static int p80211wext_siwretry(netdevice_t *dev,
 			       struct iw_param *rrq, char *extra)
 {
 	wlandevice_t *wlandev = dev->ml_priv;
-	p80211item_uint32_t mibitem;
 	p80211msg_dot11req_mibset_t msg;
 	int result;
 	int err = 0;
@@ -1057,8 +1056,6 @@ static int p80211wext_siwtxpow(netdevice_t *dev,
 			       struct iw_param *rrq, char *extra)
 {
 	wlandevice_t *wlandev = dev->ml_priv;
-	p80211item_uint32_t mibitem;
-	p80211msg_dot11req_mibset_t msg;
 	int result;
 	int err = 0;
 	unsigned int value;
diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
index d20c879..5ee9836 100644
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -96,16 +96,16 @@ typedef struct s3inforec {
 	u16 len;
 	u16 type;
 	union {
-		hfa384x_compident_t version;
-		hfa384x_caplevel_t compat;
+		struct hfa384x_compident version;
+		struct hfa384x_caplevel compat;
 		u16 buildseq;
-		hfa384x_compident_t platform;
+		struct hfa384x_compident platform;
 	} info;
 } s3inforec_t;
 
 typedef struct pda {
 	u8 buf[HFA384x_PDA_LEN_MAX];
-	hfa384x_pdrec_t *rec[HFA384x_PDA_RECS_MAX];
+	struct hfa384x_pdrec *rec[HFA384x_PDA_RECS_MAX];
 	unsigned int nrec;
 } pda_t;
 
@@ -152,10 +152,10 @@ imgchunk_t fchunk[CHUNKS_MAX];
 /* PDA, built from [card|newfile]+[addfile1+addfile2...] */
 
 pda_t pda;
-hfa384x_compident_t nicid;
-hfa384x_caplevel_t rfid;
-hfa384x_caplevel_t macid;
-hfa384x_caplevel_t priid;
+struct hfa384x_compident nicid;
+struct hfa384x_caplevel rfid;
+struct hfa384x_caplevel macid;
+struct hfa384x_caplevel priid;
 
 /*================================================================*/
 /* Local Function Declarations */
@@ -263,7 +263,7 @@ int prism2_fwapply(const struct ihex_binrec *rfptr, wlandevice_t *wlandev)
 
 	/* clear the pda and add an initial END record */
 	memset(&pda, 0, sizeof(pda));
-	pda.rec[0] = (hfa384x_pdrec_t *) pda.buf;
+	pda.rec[0] = (struct hfa384x_pdrec *) pda.buf;
 	pda.rec[0]->len = cpu_to_le16(2);	/* len in words */
 	pda.rec[0]->code = cpu_to_le16(HFA384x_PDR_END_OF_PDA);
 	pda.nrec = 1;
@@ -593,7 +593,7 @@ int mkpdrlist(pda_t *pda)
 	curroff = 0;
 	while (curroff < (HFA384x_PDA_LEN_MAX / 2) &&
 	       le16_to_cpu(pda16[curroff + 1]) != HFA384x_PDR_END_OF_PDA) {
-		pda->rec[pda->nrec] = (hfa384x_pdrec_t *) &(pda16[curroff]);
+		pda->rec[pda->nrec] = (struct hfa384x_pdrec *) &(pda16[curroff]);
 
 		if (le16_to_cpu(pda->rec[pda->nrec]->code) == HFA384x_PDR_NICID) {
 			memcpy(&nicid, &pda->rec[pda->nrec]->data.nicid,
@@ -633,7 +633,7 @@ int mkpdrlist(pda_t *pda)
 		return 1;
 	}
 	if (le16_to_cpu(pda16[curroff + 1]) == HFA384x_PDR_END_OF_PDA) {
-		pda->rec[pda->nrec] = (hfa384x_pdrec_t *) &(pda16[curroff]);
+		pda->rec[pda->nrec] = (struct hfa384x_pdrec *) &(pda16[curroff]);
 		(pda->nrec)++;
 	}
 	return result;
diff --git a/drivers/staging/wlan-ng/prism2mgmt.c b/drivers/staging/wlan-ng/prism2mgmt.c
index 4d1cdfc..f2cc381 100644
--- a/drivers/staging/wlan-ng/prism2mgmt.c
+++ b/drivers/staging/wlan-ng/prism2mgmt.c
@@ -116,13 +116,13 @@
 int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 {
 	int result = 0;
-	hfa384x_t *hw = wlandev->priv;
+	struct hfa384x *hw = wlandev->priv;
 	p80211msg_dot11req_scan_t *msg = msgp;
 	u16 roamingmode, word;
 	int i, timeout;
 	int istmpenable = 0;
 
-	hfa384x_HostScanRequest_data_t scanreq;
+	struct hfa384x_HostScanRequest_data scanreq;
 
 	/* gatekeeper check */
 	if (HFA384x_FIRMWARE_VERSION(hw->ident_sta_fw.major,
@@ -286,7 +286,7 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 
 	result = hfa384x_drvr_setconfig(hw,
 					HFA384x_RID_HOSTSCAN, &scanreq,
-					sizeof(hfa384x_HostScanRequest_data_t));
+					sizeof(struct hfa384x_HostScanRequest_data));
 	if (result) {
 		printk(KERN_ERR "setconfig(SCANREQUEST) failed. result=%d\n",
 		       result);
@@ -362,8 +362,8 @@ int prism2mgmt_scan_results(wlandevice_t *wlandev, void *msgp)
 {
 	int result = 0;
 	p80211msg_dot11req_scan_results_t *req;
-	hfa384x_t *hw = wlandev->priv;
-	hfa384x_HScanResultSub_t *item = NULL;
+	struct hfa384x *hw = wlandev->priv;
+	struct hfa384x_HScanResultSub *item = NULL;
 
 	int count;
 
@@ -510,12 +510,12 @@ exit:
 int prism2mgmt_start(wlandevice_t *wlandev, void *msgp)
 {
 	int result = 0;
-	hfa384x_t *hw = wlandev->priv;
+	struct hfa384x *hw = wlandev->priv;
 	p80211msg_dot11req_start_t *msg = msgp;
 
 	p80211pstrd_t *pstr;
 	u8 bytebuf[80];
-	hfa384x_bytestr_t *p2bytestr = (hfa384x_bytestr_t *) bytebuf;
+	struct hfa384x_bytestr *p2bytestr = (struct hfa384x_bytestr *) bytebuf;
 	u16 word;
 
 	wlandev->macmode = WLAN_MACMODE_NONE;
@@ -686,7 +686,7 @@ done:
 ----------------------------------------------------------------*/
 int prism2mgmt_readpda(wlandevice_t *wlandev, void *msgp)
 {
-	hfa384x_t *hw = wlandev->priv;
+	struct hfa384x *hw = wlandev->priv;
 	p80211msg_p2req_readpda_t *msg = msgp;
 	int result;
 
@@ -752,7 +752,7 @@ int prism2mgmt_readpda(wlandevice_t *wlandev, void *msgp)
 ----------------------------------------------------------------*/
 int prism2mgmt_ramdl_state(wlandevice_t *wlandev, void *msgp)
 {
-	hfa384x_t *hw = wlandev->priv;
+	struct hfa384x *hw = wlandev->priv;
 	p80211msg_p2req_ramdl_state_t *msg = msgp;
 
 	if (wlandev->msdstate != WLAN_MSD_FWLOAD) {
@@ -808,7 +808,7 @@ int prism2mgmt_ramdl_state(wlandevice_t *wlandev, void *msgp)
 ----------------------------------------------------------------*/
 int prism2mgmt_ramdl_write(wlandevice_t *wlandev, void *msgp)
 {
-	hfa384x_t *hw = wlandev->priv;
+	struct hfa384x *hw = wlandev->priv;
 	p80211msg_p2req_ramdl_write_t *msg = msgp;
 	u32 addr;
 	u32 len;
@@ -871,7 +871,7 @@ int prism2mgmt_ramdl_write(wlandevice_t *wlandev, void *msgp)
 int prism2mgmt_flashdl_state(wlandevice_t *wlandev, void *msgp)
 {
 	int result = 0;
-	hfa384x_t *hw = wlandev->priv;
+	struct hfa384x *hw = wlandev->priv;
 	p80211msg_p2req_flashdl_state_t *msg = msgp;
 
 	if (wlandev->msdstate != WLAN_MSD_FWLOAD) {
@@ -941,7 +941,7 @@ int prism2mgmt_flashdl_state(wlandevice_t *wlandev, void *msgp)
 ----------------------------------------------------------------*/
 int prism2mgmt_flashdl_write(wlandevice_t *wlandev, void *msgp)
 {
-	hfa384x_t *hw = wlandev->priv;
+	struct hfa384x *hw = wlandev->priv;
 	p80211msg_p2req_flashdl_write_t *msg = msgp;
 	u32 addr;
 	u32 len;
@@ -1002,14 +1002,14 @@ int prism2mgmt_flashdl_write(wlandevice_t *wlandev, void *msgp)
 ----------------------------------------------------------------*/
 int prism2mgmt_autojoin(wlandevice_t *wlandev, void *msgp)
 {
-	hfa384x_t *hw = wlandev->priv;
+	struct hfa384x *hw = wlandev->priv;
 	int result = 0;
 	u16 reg;
 	u16 port_type;
 	p80211msg_lnxreq_autojoin_t *msg = msgp;
 	p80211pstrd_t *pstr;
 	u8 bytebuf[256];
-	hfa384x_bytestr_t *p2bytestr = (hfa384x_bytestr_t *) bytebuf;
+	struct hfa384x_bytestr *p2bytestr = (struct hfa384x_bytestr *) bytebuf;
 
 	wlandev->macmode = WLAN_MACMODE_NONE;
 
@@ -1076,7 +1076,7 @@ int prism2mgmt_wlansniff(wlandevice_t *wlandev, void *msgp)
 	int result = 0;
 	p80211msg_lnxreq_wlansniff_t *msg = msgp;
 
-	hfa384x_t *hw = wlandev->priv;
+	struct hfa384x *hw = wlandev->priv;
 	u16 word;
 
 	msg->resultcode.status = P80211ENUM_msgitem_status_data_ok;
diff --git a/drivers/staging/wlan-ng/prism2mgmt.h b/drivers/staging/wlan-ng/prism2mgmt.h
index 07eeceb..b6b0eed 100644
--- a/drivers/staging/wlan-ng/prism2mgmt.h
+++ b/drivers/staging/wlan-ng/prism2mgmt.h
@@ -65,7 +65,7 @@ extern int prism2_reset_settletime;
 
 u32 prism2sta_ifstate(wlandevice_t *wlandev, u32 ifstate);
 
-void prism2sta_ev_info(wlandevice_t *wlandev, hfa384x_InfFrame_t *inf);
+void prism2sta_ev_info(wlandevice_t *wlandev, struct hfa384x_InfFrame *inf);
 void prism2sta_ev_txexc(wlandevice_t *wlandev, u16 status);
 void prism2sta_ev_tx(wlandevice_t *wlandev, u16 status);
 void prism2sta_ev_rx(wlandevice_t *wlandev, struct sk_buff *skb);
@@ -92,14 +92,14 @@ void prism2mgmt_pstr2bytearea(u8 *bytearea, p80211pstrd_t *pstr);
 void prism2mgmt_bytearea2pstr(u8 *bytearea, p80211pstrd_t *pstr, int len);
 
 /* byte string conversion functions*/
-void prism2mgmt_pstr2bytestr(hfa384x_bytestr_t *bytestr, p80211pstrd_t *pstr);
-void prism2mgmt_bytestr2pstr(hfa384x_bytestr_t *bytestr, p80211pstrd_t *pstr);
+void prism2mgmt_pstr2bytestr(struct hfa384x_bytestr *bytestr, p80211pstrd_t *pstr);
+void prism2mgmt_bytestr2pstr(struct hfa384x_bytestr *bytestr, p80211pstrd_t *pstr);
 
 /* functions to convert Group Addresses */
-void prism2mgmt_get_grpaddr(u32 did, p80211pstrd_t *pstr, hfa384x_t *priv);
+void prism2mgmt_get_grpaddr(u32 did, p80211pstrd_t *pstr, struct hfa384x *priv);
 int prism2mgmt_set_grpaddr(u32 did,
 			   u8 *prism2buf, p80211pstrd_t *pstr,
-			   hfa384x_t *priv);
+			   struct hfa384x *priv);
 int prism2mgmt_get_grpaddr_index(u32 did);
 
 void prism2sta_processing_defer(struct work_struct *data);
diff --git a/drivers/staging/wlan-ng/prism2mib.c b/drivers/staging/wlan-ng/prism2mib.c
index 0b0ec9c..80e9928 100644
--- a/drivers/staging/wlan-ng/prism2mib.c
+++ b/drivers/staging/wlan-ng/prism2mib.c
@@ -88,61 +88,61 @@ typedef struct mibrec {
 	int (*func) (struct mibrec *mib,
 		     int isget,
 		     wlandevice_t *wlandev,
-		     hfa384x_t *hw,
+		     struct hfa384x *hw,
 		     p80211msg_dot11req_mibset_t *msg, void *data);
 } mibrec_t;
 
 static int prism2mib_bytearea2pstr(mibrec_t *mib,
 				   int isget,
 				   wlandevice_t *wlandev,
-				   hfa384x_t *hw,
+				   struct hfa384x *hw,
 				   p80211msg_dot11req_mibset_t *msg,
 				   void *data);
 
 static int prism2mib_uint32(mibrec_t *mib,
 			    int isget,
 			    wlandevice_t *wlandev,
-			    hfa384x_t *hw,
+			    struct hfa384x *hw,
 			    p80211msg_dot11req_mibset_t *msg, void *data);
 
 static int prism2mib_flag(mibrec_t *mib,
 			  int isget,
 			  wlandevice_t *wlandev,
-			  hfa384x_t *hw,
+			  struct hfa384x *hw,
 			  p80211msg_dot11req_mibset_t *msg, void *data);
 
 static int prism2mib_wepdefaultkey(mibrec_t *mib,
 				   int isget,
 				   wlandevice_t *wlandev,
-				   hfa384x_t *hw,
+				   struct hfa384x *hw,
 				   p80211msg_dot11req_mibset_t *msg,
 				   void *data);
 
 static int prism2mib_privacyinvoked(mibrec_t *mib,
 				    int isget,
 				    wlandevice_t *wlandev,
-				    hfa384x_t *hw,
+				    struct hfa384x *hw,
 				    p80211msg_dot11req_mibset_t *msg,
 				    void *data);
 
 static int prism2mib_excludeunencrypted(mibrec_t *mib,
 					int isget,
 					wlandevice_t *wlandev,
-					hfa384x_t *hw,
+					struct hfa384x *hw,
 					p80211msg_dot11req_mibset_t *msg,
 					void *data);
 
 static int prism2mib_fragmentationthreshold(mibrec_t *mib,
 					    int isget,
 					    wlandevice_t *wlandev,
-					    hfa384x_t *hw,
+					    struct hfa384x *hw,
 					    p80211msg_dot11req_mibset_t *msg,
 					    void *data);
 
 static int prism2mib_priv(mibrec_t *mib,
 			  int isget,
 			  wlandevice_t *wlandev,
-			  hfa384x_t *hw,
+			  struct hfa384x *hw,
 			  p80211msg_dot11req_mibset_t *msg, void *data);
 
 static mibrec_t mibtab[] = {
@@ -259,7 +259,7 @@ static mibrec_t mibtab[] = {
 
 int prism2mgmt_mibset_mibget(wlandevice_t *wlandev, void *msgp)
 {
-	hfa384x_t *hw = wlandev->priv;
+	struct hfa384x *hw = wlandev->priv;
 	int result, isget;
 	mibrec_t *mib;
 
@@ -374,7 +374,7 @@ done:
 static int prism2mib_bytearea2pstr(mibrec_t *mib,
 				   int isget,
 				   wlandevice_t *wlandev,
-				   hfa384x_t *hw,
+				   struct hfa384x *hw,
 				   p80211msg_dot11req_mibset_t *msg,
 				   void *data)
 {
@@ -424,7 +424,7 @@ static int prism2mib_bytearea2pstr(mibrec_t *mib,
 static int prism2mib_uint32(mibrec_t *mib,
 			    int isget,
 			    wlandevice_t *wlandev,
-			    hfa384x_t *hw,
+			    struct hfa384x *hw,
 			    p80211msg_dot11req_mibset_t *msg, void *data)
 {
 	int result;
@@ -471,7 +471,7 @@ static int prism2mib_uint32(mibrec_t *mib,
 static int prism2mib_flag(mibrec_t *mib,
 			  int isget,
 			  wlandevice_t *wlandev,
-			  hfa384x_t *hw,
+			  struct hfa384x *hw,
 			  p80211msg_dot11req_mibset_t *msg, void *data)
 {
 	int result;
@@ -528,7 +528,7 @@ static int prism2mib_flag(mibrec_t *mib,
 static int prism2mib_wepdefaultkey(mibrec_t *mib,
 				   int isget,
 				   wlandevice_t *wlandev,
-				   hfa384x_t *hw,
+				   struct hfa384x *hw,
 				   p80211msg_dot11req_mibset_t *msg,
 				   void *data)
 {
@@ -578,7 +578,7 @@ static int prism2mib_wepdefaultkey(mibrec_t *mib,
 static int prism2mib_privacyinvoked(mibrec_t *mib,
 				    int isget,
 				    wlandevice_t *wlandev,
-				    hfa384x_t *hw,
+				    struct hfa384x *hw,
 				    p80211msg_dot11req_mibset_t *msg,
 				    void *data)
 {
@@ -624,7 +624,7 @@ static int prism2mib_privacyinvoked(mibrec_t *mib,
 static int prism2mib_excludeunencrypted(mibrec_t *mib,
 					int isget,
 					wlandevice_t *wlandev,
-					hfa384x_t *hw,
+					struct hfa384x *hw,
 					p80211msg_dot11req_mibset_t *msg,
 					void *data)
 {
@@ -663,7 +663,7 @@ static int prism2mib_excludeunencrypted(mibrec_t *mib,
 static int prism2mib_fragmentationthreshold(mibrec_t *mib,
 					    int isget,
 					    wlandevice_t *wlandev,
-					    hfa384x_t *hw,
+					    struct hfa384x *hw,
 					    p80211msg_dot11req_mibset_t *msg,
 					    void *data)
 {
@@ -712,7 +712,7 @@ static int prism2mib_fragmentationthreshold(mibrec_t *mib,
 static int prism2mib_priv(mibrec_t *mib,
 			  int isget,
 			  wlandevice_t *wlandev,
-			  hfa384x_t *hw,
+			  struct hfa384x *hw,
 			  p80211msg_dot11req_mibset_t *msg, void *data)
 {
 	p80211pstrd_t *pstr = (p80211pstrd_t *) data;
@@ -721,7 +721,7 @@ static int prism2mib_priv(mibrec_t *mib,
 
 	switch (mib->did) {
 	case DIDmib_lnx_lnxConfigTable_lnxRSNAIE:{
-			hfa384x_WPAData_t wpa;
+			struct hfa384x_WPAData wpa;
 			if (isget) {
 				hfa384x_drvr_getconfig(hw,
 						       HFA384x_RID_CNFWPADATA,
@@ -763,7 +763,7 @@ static int prism2mib_priv(mibrec_t *mib,
 *
 ----------------------------------------------------------------*/
 
-void prism2mgmt_pstr2bytestr(hfa384x_bytestr_t *bytestr, p80211pstrd_t *pstr)
+void prism2mgmt_pstr2bytestr(struct hfa384x_bytestr *bytestr, p80211pstrd_t *pstr)
 {
 	bytestr->len = cpu_to_le16((u16) (pstr->len));
 	memcpy(bytestr->data, pstr->data, pstr->len);
@@ -804,7 +804,7 @@ void prism2mgmt_pstr2bytearea(u8 *bytearea, p80211pstrd_t *pstr)
 *
 ----------------------------------------------------------------*/
 
-void prism2mgmt_bytestr2pstr(hfa384x_bytestr_t *bytestr, p80211pstrd_t *pstr)
+void prism2mgmt_bytestr2pstr(struct hfa384x_bytestr *bytestr, p80211pstrd_t *pstr)
 {
 	pstr->len = (u8) (le16_to_cpu((u16) (bytestr->len)));
 	memcpy(pstr->data, bytestr->data, pstr->len);
diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index 6cd0935..6e5c20c 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -136,25 +136,25 @@ static int prism2sta_globalsetup(wlandevice_t *wlandev);
 static int prism2sta_setmulticast(wlandevice_t *wlandev, netdevice_t *dev);
 
 static void prism2sta_inf_handover(wlandevice_t *wlandev,
-				   hfa384x_InfFrame_t *inf);
+				   struct hfa384x_InfFrame *inf);
 static void prism2sta_inf_tallies(wlandevice_t *wlandev,
-				  hfa384x_InfFrame_t *inf);
+				  struct hfa384x_InfFrame *inf);
 static void prism2sta_inf_hostscanresults(wlandevice_t *wlandev,
-					  hfa384x_InfFrame_t *inf);
+					  struct hfa384x_InfFrame *inf);
 static void prism2sta_inf_scanresults(wlandevice_t *wlandev,
-				      hfa384x_InfFrame_t *inf);
+				      struct hfa384x_InfFrame *inf);
 static void prism2sta_inf_chinforesults(wlandevice_t *wlandev,
-					hfa384x_InfFrame_t *inf);
+					struct hfa384x_InfFrame *inf);
 static void prism2sta_inf_linkstatus(wlandevice_t *wlandev,
-				     hfa384x_InfFrame_t *inf);
+				     struct hfa384x_InfFrame *inf);
 static void prism2sta_inf_assocstatus(wlandevice_t *wlandev,
-				      hfa384x_InfFrame_t *inf);
+				      struct hfa384x_InfFrame *inf);
 static void prism2sta_inf_authreq(wlandevice_t *wlandev,
-				  hfa384x_InfFrame_t *inf);
+				  struct hfa384x_InfFrame *inf);
 static void prism2sta_inf_authreq_defer(wlandevice_t *wlandev,
-					hfa384x_InfFrame_t *inf);
+					struct hfa384x_InfFrame *inf);
 static void prism2sta_inf_psusercnt(wlandevice_t *wlandev,
-				    hfa384x_InfFrame_t *inf);
+				    struct hfa384x_InfFrame *inf);
 
 /*----------------------------------------------------------------
 * prism2sta_open
@@ -269,7 +269,7 @@ static int prism2sta_txframe(wlandevice_t *wlandev, struct sk_buff *skb,
 			     p80211_hdr_t *p80211_hdr,
 			     p80211_metawep_t *p80211_wep)
 {
-	hfa384x_t *hw = (hfa384x_t *) wlandev->priv;
+	struct hfa384x *hw = (struct hfa384x *) wlandev->priv;
 	int result;
 
 	/* If necessary, set the 802.11 WEP bit */
@@ -309,7 +309,7 @@ static int prism2sta_txframe(wlandevice_t *wlandev, struct sk_buff *skb,
 ----------------------------------------------------------------*/
 static int prism2sta_mlmerequest(wlandevice_t *wlandev, p80211msg_t *msg)
 {
-	hfa384x_t *hw = (hfa384x_t *) wlandev->priv;
+	struct hfa384x *hw = (struct hfa384x *) wlandev->priv;
 
 	int result = 0;
 
@@ -436,7 +436,7 @@ static int prism2sta_mlmerequest(wlandevice_t *wlandev, p80211msg_t *msg)
 ----------------------------------------------------------------*/
 u32 prism2sta_ifstate(wlandevice_t *wlandev, u32 ifstate)
 {
-	hfa384x_t *hw = (hfa384x_t *) wlandev->priv;
+	struct hfa384x *hw = (struct hfa384x *) wlandev->priv;
 	u32 result;
 
 	result = P80211ENUM_resultcode_implementation_failure;
@@ -611,7 +611,7 @@ u32 prism2sta_ifstate(wlandevice_t *wlandev, u32 ifstate)
 static int prism2sta_getcardinfo(wlandevice_t *wlandev)
 {
 	int result = 0;
-	hfa384x_t *hw = (hfa384x_t *) wlandev->priv;
+	struct hfa384x *hw = (struct hfa384x *) wlandev->priv;
 	u16 temp;
 	u8 snum[HFA384x_RID_NICSERIALNUMBER_LEN];
 	char pstr[(HFA384x_RID_NICSERIALNUMBER_LEN * 4) + 1];
@@ -621,7 +621,7 @@ static int prism2sta_getcardinfo(wlandevice_t *wlandev)
 	/* NIC identity */
 	result = hfa384x_drvr_getconfig(hw, HFA384x_RID_NICIDENTITY,
 					&hw->ident_nic,
-					sizeof(hfa384x_compident_t));
+					sizeof(struct hfa384x_compident));
 	if (result) {
 		printk(KERN_ERR "Failed to retrieve NICIDENTITY\n");
 		goto failed;
@@ -640,7 +640,7 @@ static int prism2sta_getcardinfo(wlandevice_t *wlandev)
 	/* Primary f/w identity */
 	result = hfa384x_drvr_getconfig(hw, HFA384x_RID_PRIIDENTITY,
 					&hw->ident_pri_fw,
-					sizeof(hfa384x_compident_t));
+					sizeof(struct hfa384x_compident));
 	if (result) {
 		printk(KERN_ERR "Failed to retrieve PRIIDENTITY\n");
 		goto failed;
@@ -659,7 +659,7 @@ static int prism2sta_getcardinfo(wlandevice_t *wlandev)
 	/* Station (Secondary?) f/w identity */
 	result = hfa384x_drvr_getconfig(hw, HFA384x_RID_STAIDENTITY,
 					&hw->ident_sta_fw,
-					sizeof(hfa384x_compident_t));
+					sizeof(struct hfa384x_compident));
 	if (result) {
 		printk(KERN_ERR "Failed to retrieve STAIDENTITY\n");
 		goto failed;
@@ -699,7 +699,7 @@ static int prism2sta_getcardinfo(wlandevice_t *wlandev)
 	/* Compatibility range, Modem supplier */
 	result = hfa384x_drvr_getconfig(hw, HFA384x_RID_MFISUPRANGE,
 					&hw->cap_sup_mfi,
-					sizeof(hfa384x_caplevel_t));
+					sizeof(struct hfa384x_caplevel));
 	if (result) {
 		printk(KERN_ERR "Failed to retrieve MFISUPRANGE\n");
 		goto failed;
@@ -722,7 +722,7 @@ static int prism2sta_getcardinfo(wlandevice_t *wlandev)
 	/* Compatibility range, Controller supplier */
 	result = hfa384x_drvr_getconfig(hw, HFA384x_RID_CFISUPRANGE,
 					&hw->cap_sup_cfi,
-					sizeof(hfa384x_caplevel_t));
+					sizeof(struct hfa384x_caplevel));
 	if (result) {
 		printk(KERN_ERR "Failed to retrieve CFISUPRANGE\n");
 		goto failed;
@@ -745,7 +745,7 @@ static int prism2sta_getcardinfo(wlandevice_t *wlandev)
 	/* Compatibility range, Primary f/w supplier */
 	result = hfa384x_drvr_getconfig(hw, HFA384x_RID_PRISUPRANGE,
 					&hw->cap_sup_pri,
-					sizeof(hfa384x_caplevel_t));
+					sizeof(struct hfa384x_caplevel));
 	if (result) {
 		printk(KERN_ERR "Failed to retrieve PRISUPRANGE\n");
 		goto failed;
@@ -768,7 +768,7 @@ static int prism2sta_getcardinfo(wlandevice_t *wlandev)
 	/* Compatibility range, Station f/w supplier */
 	result = hfa384x_drvr_getconfig(hw, HFA384x_RID_STASUPRANGE,
 					&hw->cap_sup_sta,
-					sizeof(hfa384x_caplevel_t));
+					sizeof(struct hfa384x_caplevel));
 	if (result) {
 		printk(KERN_ERR "Failed to retrieve STASUPRANGE\n");
 		goto failed;
@@ -799,7 +799,7 @@ static int prism2sta_getcardinfo(wlandevice_t *wlandev)
 	/* Compatibility range, primary f/w actor, CFI supplier */
 	result = hfa384x_drvr_getconfig(hw, HFA384x_RID_PRI_CFIACTRANGES,
 					&hw->cap_act_pri_cfi,
-					sizeof(hfa384x_caplevel_t));
+					sizeof(struct hfa384x_caplevel));
 	if (result) {
 		printk(KERN_ERR "Failed to retrieve PRI_CFIACTRANGES\n");
 		goto failed;
@@ -822,7 +822,7 @@ static int prism2sta_getcardinfo(wlandevice_t *wlandev)
 	/* Compatibility range, sta f/w actor, CFI supplier */
 	result = hfa384x_drvr_getconfig(hw, HFA384x_RID_STA_CFIACTRANGES,
 					&hw->cap_act_sta_cfi,
-					sizeof(hfa384x_caplevel_t));
+					sizeof(struct hfa384x_caplevel));
 	if (result) {
 		printk(KERN_ERR "Failed to retrieve STA_CFIACTRANGES\n");
 		goto failed;
@@ -845,7 +845,7 @@ static int prism2sta_getcardinfo(wlandevice_t *wlandev)
 	/* Compatibility range, sta f/w actor, MFI supplier */
 	result = hfa384x_drvr_getconfig(hw, HFA384x_RID_STA_MFIACTRANGES,
 					&hw->cap_act_sta_mfi,
-					sizeof(hfa384x_caplevel_t));
+					sizeof(struct hfa384x_caplevel));
 	if (result) {
 		printk(KERN_ERR "Failed to retrieve STA_MFIACTRANGES\n");
 		goto failed;
@@ -934,7 +934,7 @@ done:
 ----------------------------------------------------------------*/
 static int prism2sta_globalsetup(wlandevice_t *wlandev)
 {
-	hfa384x_t *hw = (hfa384x_t *) wlandev->priv;
+	struct hfa384x *hw = (struct hfa384x *) wlandev->priv;
 
 	/* Set the maximum frame size */
 	return hfa384x_drvr_setconfig16(hw, HFA384x_RID_CNFMAXDATALEN,
@@ -944,7 +944,7 @@ static int prism2sta_globalsetup(wlandevice_t *wlandev)
 static int prism2sta_setmulticast(wlandevice_t *wlandev, netdevice_t *dev)
 {
 	int result = 0;
-	hfa384x_t *hw = (hfa384x_t *) wlandev->priv;
+	struct hfa384x *hw = (struct hfa384x *) wlandev->priv;
 
 	u16 promisc;
 
@@ -983,7 +983,7 @@ exit:
 *	interrupt
 ----------------------------------------------------------------*/
 static void prism2sta_inf_handover(wlandevice_t *wlandev,
-				   hfa384x_InfFrame_t *inf)
+				   struct hfa384x_InfFrame *inf)
 {
 	pr_debug("received infoframe:HANDOVER (unhandled)\n");
 	return;
@@ -1007,9 +1007,9 @@ static void prism2sta_inf_handover(wlandevice_t *wlandev,
 *	interrupt
 ----------------------------------------------------------------*/
 static void prism2sta_inf_tallies(wlandevice_t *wlandev,
-				  hfa384x_InfFrame_t *inf)
+				  struct hfa384x_InfFrame *inf)
 {
-	hfa384x_t *hw = (hfa384x_t *) wlandev->priv;
+	struct hfa384x *hw = (struct hfa384x *) wlandev->priv;
 	u16 *src16;
 	u32 *dst;
 	u32 *src32;
@@ -1021,7 +1021,7 @@ static void prism2sta_inf_tallies(wlandevice_t *wlandev,
 	 ** record length of the info record.
 	 */
 
-	cnt = sizeof(hfa384x_CommTallies32_t) / sizeof(u32);
+	cnt = sizeof(struct hfa384x_CommTallies32) / sizeof(u32);
 	if (inf->framelen > 22) {
 		dst = (u32 *) &hw->tallies;
 		src32 = (u32 *) &inf->info.commtallies32;
@@ -1055,20 +1055,20 @@ static void prism2sta_inf_tallies(wlandevice_t *wlandev,
 *	interrupt
 ----------------------------------------------------------------*/
 static void prism2sta_inf_scanresults(wlandevice_t *wlandev,
-				      hfa384x_InfFrame_t *inf)
+				      struct hfa384x_InfFrame *inf)
 {
 
-	hfa384x_t *hw = (hfa384x_t *) wlandev->priv;
+	struct hfa384x *hw = (struct hfa384x *) wlandev->priv;
 	int nbss;
-	hfa384x_ScanResult_t *sr = &(inf->info.scanresult);
+	struct hfa384x_ScanResult *sr = &(inf->info.scanresult);
 	int i;
-	hfa384x_JoinRequest_data_t joinreq;
+	struct hfa384x_JoinRequest_data joinreq;
 	int result;
 
 	/* Get the number of results, first in bytes, then in results */
 	nbss = (inf->framelen * sizeof(u16)) -
 	    sizeof(inf->infotype) - sizeof(inf->info.scanresult.scanreason);
-	nbss /= sizeof(hfa384x_ScanResultSub_t);
+	nbss /= sizeof(struct hfa384x_ScanResultSub);
 
 	/* Print em */
 	pr_debug("rx scanresults, reason=%d, nbss=%d:\n",
@@ -1113,9 +1113,9 @@ static void prism2sta_inf_scanresults(wlandevice_t *wlandev,
 *	interrupt
 ----------------------------------------------------------------*/
 static void prism2sta_inf_hostscanresults(wlandevice_t *wlandev,
-					  hfa384x_InfFrame_t *inf)
+					  struct hfa384x_InfFrame *inf)
 {
-	hfa384x_t *hw = (hfa384x_t *) wlandev->priv;
+	struct hfa384x *hw = (struct hfa384x *) wlandev->priv;
 	int nbss;
 
 	nbss = (inf->framelen - 3) / 32;
@@ -1126,8 +1126,8 @@ static void prism2sta_inf_hostscanresults(wlandevice_t *wlandev,
 
 	kfree(hw->scanresults);
 
-	hw->scanresults = kmalloc(sizeof(hfa384x_InfFrame_t), GFP_ATOMIC);
-	memcpy(hw->scanresults, inf, sizeof(hfa384x_InfFrame_t));
+	hw->scanresults = kmalloc(sizeof(struct hfa384x_InfFrame), GFP_ATOMIC);
+	memcpy(hw->scanresults, inf, sizeof(struct hfa384x_InfFrame));
 
 	if (nbss == 0)
 		nbss = -1;
@@ -1155,9 +1155,9 @@ static void prism2sta_inf_hostscanresults(wlandevice_t *wlandev,
 *	interrupt
 ----------------------------------------------------------------*/
 static void prism2sta_inf_chinforesults(wlandevice_t *wlandev,
-					hfa384x_InfFrame_t *inf)
+					struct hfa384x_InfFrame *inf)
 {
-	hfa384x_t *hw = (hfa384x_t *) wlandev->priv;
+	struct hfa384x *hw = (struct hfa384x *) wlandev->priv;
 	unsigned int i, n;
 
 	hw->channel_info.results.scanchannels =
@@ -1168,7 +1168,7 @@ static void prism2sta_inf_chinforesults(wlandevice_t *wlandev,
 			int channel =
 			    le16_to_cpu(inf->info.chinforesult.result[n].chid) -
 			    1;
-			hfa384x_ChInfoResultSub_t *chinforesult =
+			struct hfa384x_ChInfoResultSub *chinforesult =
 			    &hw->channel_info.results.result[channel];
 			chinforesult->chid = channel;
 			chinforesult->anl =
@@ -1197,18 +1197,18 @@ static void prism2sta_inf_chinforesults(wlandevice_t *wlandev,
 
 void prism2sta_processing_defer(struct work_struct *data)
 {
-	hfa384x_t *hw = container_of(data, struct hfa384x, link_bh);
+	struct hfa384x *hw = container_of(data, struct hfa384x, link_bh);
 	wlandevice_t *wlandev = hw->wlandev;
-	hfa384x_bytestr32_t ssid;
+	struct hfa384x_bytestr32 ssid;
 	int result;
 
 	/* First let's process the auth frames */
 	{
 		struct sk_buff *skb;
-		hfa384x_InfFrame_t *inf;
+		struct hfa384x_InfFrame *inf;
 
 		while ((skb = skb_dequeue(&hw->authq))) {
-			inf = (hfa384x_InfFrame_t *) skb->data;
+			inf = (struct hfa384x_InfFrame *) skb->data;
 			prism2sta_inf_authreq_defer(wlandev, inf);
 		}
 
@@ -1282,7 +1282,7 @@ void prism2sta_processing_defer(struct work_struct *data)
 				     HFA384x_RID_CURRENTSSID, result);
 				goto failed;
 			}
-			prism2mgmt_bytestr2pstr((hfa384x_bytestr_t *) &ssid,
+			prism2mgmt_bytestr2pstr((struct hfa384x_bytestr *) &ssid,
 						(p80211pstrd_t *) &
 						wlandev->ssid);
 
@@ -1316,7 +1316,7 @@ void prism2sta_processing_defer(struct work_struct *data)
 		 * Block Transmits, Ignore receives of data frames
 		 */
 		if (hw->join_ap == 2) {
-			hfa384x_JoinRequest_data_t joinreq;
+			struct hfa384x_JoinRequest_data joinreq;
 			joinreq = hw->joinreq;
 			/* Send the join request */
 			hfa384x_drvr_setconfig(hw,
@@ -1370,7 +1370,7 @@ void prism2sta_processing_defer(struct work_struct *data)
 				 HFA384x_RID_CURRENTSSID, result);
 			goto failed;
 		}
-		prism2mgmt_bytestr2pstr((hfa384x_bytestr_t *) &ssid,
+		prism2mgmt_bytestr2pstr((struct hfa384x_bytestr *) &ssid,
 					(p80211pstrd_t *) &wlandev->ssid);
 
 		hw->link_status = HFA384x_LINK_CONNECTED;
@@ -1420,7 +1420,7 @@ void prism2sta_processing_defer(struct work_struct *data)
 		 * Disable Transmits, Ignore receives of data frames
 		 */
 		if (hw->join_ap && --hw->join_retries > 0) {
-			hfa384x_JoinRequest_data_t joinreq;
+			struct hfa384x_JoinRequest_data joinreq;
 			joinreq = hw->joinreq;
 			/* Send the join request */
 			hfa384x_drvr_setconfig(hw,
@@ -1470,9 +1470,9 @@ failed:
 *	interrupt
 ----------------------------------------------------------------*/
 static void prism2sta_inf_linkstatus(wlandevice_t *wlandev,
-				     hfa384x_InfFrame_t *inf)
+				     struct hfa384x_InfFrame *inf)
 {
-	hfa384x_t *hw = (hfa384x_t *) wlandev->priv;
+	struct hfa384x *hw = (struct hfa384x *) wlandev->priv;
 
 	hw->link_status_new = le16_to_cpu(inf->info.linkstatus.linkstatus);
 
@@ -1500,10 +1500,10 @@ static void prism2sta_inf_linkstatus(wlandevice_t *wlandev,
 *	interrupt
 ----------------------------------------------------------------*/
 static void prism2sta_inf_assocstatus(wlandevice_t *wlandev,
-				      hfa384x_InfFrame_t *inf)
+				      struct hfa384x_InfFrame *inf)
 {
-	hfa384x_t *hw = (hfa384x_t *) wlandev->priv;
-	hfa384x_AssocStatus_t rec;
+	struct hfa384x *hw = (struct hfa384x *) wlandev->priv;
+	struct hfa384x_AssocStatus rec;
 	int i;
 
 	memcpy(&rec, &inf->info.assocstatus, sizeof(rec));
@@ -1563,9 +1563,9 @@ static void prism2sta_inf_assocstatus(wlandevice_t *wlandev,
 *
 ----------------------------------------------------------------*/
 static void prism2sta_inf_authreq(wlandevice_t *wlandev,
-				  hfa384x_InfFrame_t *inf)
+				  struct hfa384x_InfFrame *inf)
 {
-	hfa384x_t *hw = (hfa384x_t *) wlandev->priv;
+	struct hfa384x *hw = (struct hfa384x *) wlandev->priv;
 	struct sk_buff *skb;
 
 	skb = dev_alloc_skb(sizeof(*inf));
@@ -1578,10 +1578,10 @@ static void prism2sta_inf_authreq(wlandevice_t *wlandev,
 }
 
 static void prism2sta_inf_authreq_defer(wlandevice_t *wlandev,
-					hfa384x_InfFrame_t *inf)
+					struct hfa384x_InfFrame *inf)
 {
-	hfa384x_t *hw = (hfa384x_t *) wlandev->priv;
-	hfa384x_authenticateStation_data_t rec;
+	struct hfa384x *hw = (struct hfa384x *) wlandev->priv;
+	struct hfa384x_authenticateStation_data rec;
 
 	int i, added, result, cnt;
 	u8 *addr;
@@ -1752,9 +1752,9 @@ static void prism2sta_inf_authreq_defer(wlandevice_t *wlandev,
 *	interrupt
 ----------------------------------------------------------------*/
 static void prism2sta_inf_psusercnt(wlandevice_t *wlandev,
-				    hfa384x_InfFrame_t *inf)
+				    struct hfa384x_InfFrame *inf)
 {
-	hfa384x_t *hw = (hfa384x_t *) wlandev->priv;
+	struct hfa384x *hw = (struct hfa384x *) wlandev->priv;
 
 	hw->psusercount = le16_to_cpu(inf->info.psusercnt.usercnt);
 
@@ -1778,7 +1778,7 @@ static void prism2sta_inf_psusercnt(wlandevice_t *wlandev,
 * Call context:
 *	interrupt
 ----------------------------------------------------------------*/
-void prism2sta_ev_info(wlandevice_t *wlandev, hfa384x_InfFrame_t *inf)
+void prism2sta_ev_info(wlandevice_t *wlandev, struct hfa384x_InfFrame *inf)
 {
 	inf->infotype = le16_to_cpu(inf->infotype);
 	/* Dispatch */
@@ -1943,11 +1943,11 @@ void prism2sta_ev_alloc(wlandevice_t *wlandev)
 static wlandevice_t *create_wlan(void)
 {
 	wlandevice_t *wlandev = NULL;
-	hfa384x_t *hw = NULL;
+	struct hfa384x *hw = NULL;
 
 	/* Alloc our structures */
 	wlandev = kmalloc(sizeof(wlandevice_t), GFP_KERNEL);
-	hw = kmalloc(sizeof(hfa384x_t), GFP_KERNEL);
+	hw = kmalloc(sizeof(struct hfa384x), GFP_KERNEL);
 
 	if (!wlandev || !hw) {
 		printk(KERN_ERR "%s: Memory allocation failure.\n", dev_info);
@@ -1958,7 +1958,7 @@ static wlandevice_t *create_wlan(void)
 
 	/* Clear all the structs */
 	memset(wlandev, 0, sizeof(wlandevice_t));
-	memset(hw, 0, sizeof(hfa384x_t));
+	memset(hw, 0, sizeof(struct hfa384x));
 
 	/* Initialize the network device object. */
 	wlandev->nsdname = dev_info;
@@ -1982,9 +1982,9 @@ static wlandevice_t *create_wlan(void)
 
 void prism2sta_commsqual_defer(struct work_struct *data)
 {
-	hfa384x_t *hw = container_of(data, struct hfa384x, commsqual_bh);
+	struct hfa384x *hw = container_of(data, struct hfa384x, commsqual_bh);
 	wlandevice_t *wlandev = hw->wlandev;
-	hfa384x_bytestr32_t ssid;
+	struct hfa384x_bytestr32 ssid;
 	int result = 0;
 
 	if (hw->wlandev->hwremoved)
@@ -2031,7 +2031,7 @@ void prism2sta_commsqual_defer(struct work_struct *data)
 			 HFA384x_RID_CURRENTSSID, result);
 		goto done;
 	}
-	prism2mgmt_bytestr2pstr((hfa384x_bytestr_t *) &ssid,
+	prism2mgmt_bytestr2pstr((struct hfa384x_bytestr *) &ssid,
 				(p80211pstrd_t *) &wlandev->ssid);
 
 	/* Reschedule timer */
@@ -2043,7 +2043,7 @@ done:
 
 void prism2sta_commsqual_timer(unsigned long data)
 {
-	hfa384x_t *hw = (hfa384x_t *) data;
+	struct hfa384x *hw = (struct hfa384x *) data;
 
 	schedule_work(&hw->commsqual_bh);
 }
diff --git a/drivers/staging/wlan-ng/prism2usb.c b/drivers/staging/wlan-ng/prism2usb.c
index f5cff75..1dd7e16 100644
--- a/drivers/staging/wlan-ng/prism2usb.c
+++ b/drivers/staging/wlan-ng/prism2usb.c
@@ -107,7 +107,7 @@ static int prism2sta_probe_usb(struct usb_interface *interface,
 	struct usb_device *dev;
 
 	wlandevice_t *wlandev = NULL;
-	hfa384x_t *hw = NULL;
+	struct hfa384x *hw = NULL;
 	int result = 0;
 
 	dev = interface_to_usbdev(interface);
@@ -206,7 +206,7 @@ static void prism2sta_disconnect_usb(struct usb_interface *interface)
 		struct list_head *temp;
 		unsigned long flags;
 
-		hfa384x_t *hw = wlandev->priv;
+		struct hfa384x *hw = wlandev->priv;
 
 		if (!hw)
 			goto exit;
@@ -248,9 +248,9 @@ static void prism2sta_disconnect_usb(struct usb_interface *interface)
 		 * responses that we have shut down.
 		 */
 		list_for_each(entry, &cleanlist) {
-			hfa384x_usbctlx_t *ctlx;
+			struct hfa384x_usbctlx *ctlx;
 
-			ctlx = list_entry(entry, hfa384x_usbctlx_t, list);
+			ctlx = list_entry(entry, struct hfa384x_usbctlx, list);
 			complete(&ctlx->done);
 		}
 
@@ -263,9 +263,9 @@ static void prism2sta_disconnect_usb(struct usb_interface *interface)
 
 		/* Now delete the CTLXs, because no-one else can now. */
 		list_for_each_safe(entry, temp, &cleanlist) {
-			hfa384x_usbctlx_t *ctlx;
+			struct hfa384x_usbctlx *ctlx;
 
-			ctlx = list_entry(entry, hfa384x_usbctlx_t, list);
+			ctlx = list_entry(entry, struct hfa384x_usbctlx, list);
 			kfree(ctlx);
 		}
 
@@ -289,7 +289,7 @@ exit:
 static int prism2sta_suspend(struct usb_interface *interface,
 				pm_message_t message)
 {
-	hfa384x_t *hw = NULL;
+	struct hfa384x *hw = NULL;
 	wlandevice_t *wlandev;
 	wlandev = (wlandevice_t *) usb_get_intfdata(interface);
 	if (!wlandev)
@@ -311,7 +311,7 @@ static int prism2sta_suspend(struct usb_interface *interface,
 static int prism2sta_resume(struct usb_interface *interface)
 {
 	int result = 0;
-	hfa384x_t *hw = NULL;
+	struct hfa384x *hw = NULL;
 	wlandevice_t *wlandev;
 	wlandev = (wlandevice_t *) usb_get_intfdata(interface);
 	if (!wlandev)
-- 
1.6.3.3

