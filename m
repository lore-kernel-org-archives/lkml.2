Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab0ETL3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 07:29:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35670 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab0ETL3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 07:29:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DIIANjfOYX56ffsKYrjuNraZ9ePj/1HRqDSISG4G3l4tyMYFbeixeQVi1wYyH0+rh5
         JbRg6ljpveYc3toHxt8m+WvPSI22uUJsgKSVJnzTy94To4hoIDILGsLLRVrpWloUygOr
         DhjHKWkqIv/XjgPAj3qv/ZjuufhPFItDJu9LI=
From: Neil Munro <neilmunro@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Niadh <neilmunro@gmail.com>
Subject: [PATCH 1586/1586] Staging: RT2860: Fixed my previous patch.
Date: Thu, 20 May 2010 12:28:53 +0100
Message-Id: <1274354933-24377-1-git-send-email-neilmunro@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Niadh <neilmunro@gmail.com>

I have corrected the confusion between braces and parethesis. In addition I have removed a few warnings where the lines were over 80 lines and finaly have implemented a few suggestions Joe Perches suggested (thanks Joe).

Signed-off-by: Neil Munro <neilmunro@gmail.com>
---
 drivers/staging/rt2860/mlme.h |   89 +++++++++++++++++++++++++----------------
 1 files changed, 55 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/rt2860/mlme.h b/drivers/staging/rt2860/mlme.h
index 63cada3..02cbe9a 100644
--- a/drivers/staging/rt2860/mlme.h
+++ b/drivers/staging/rt2860/mlme.h
@@ -31,7 +31,7 @@

 	Revision History:
 	Who			When			What
-	--------	----------		----------------------------------------------
+	--------	----------		------------
 	John Chang	2003-08-28		Created
 	John Chang  2004-09-06      modified for RT2600

@@ -49,8 +49,9 @@
 #define LFSR_MASK                   0x80000057
 #define MLME_TASK_EXEC_INTV         100/*200*/	/* */
 #define LEAD_TIME                   5
-#define MLME_TASK_EXEC_MULTIPLE       10  /*5*/	/* MLME_TASK_EXEC_MULTIPLE * MLME_TASK_EXEC_INTV = 1 sec */
-#define REORDER_EXEC_INTV         	100	/* 0.1 sec */
+#define MLME_TASK_EXEC_MULTIPLE       10
+/*5*/	/* MLME_TASK_EXEC_MULTIPLE * MLME_TASK_EXEC_INTV = 1 sec */
+#define REORDER_EXEC_INTV		100	/* 0.1 sec */

 /* The definition of Radar detection duration region */
 #define CE		0
@@ -60,7 +61,7 @@
 #define JAP_W56	4
 #define MAX_RD_REGION 5

-#define BEACON_LOST_TIME            { 4 * OS_HZ }	/* 2048 msec = 2 sec */
+#define BEACON_LOST_TIME            (4 * OS_HZ)	/* 2048 msec = 2 sec */

 #define DLS_TIMEOUT                 1200	/* unit: msec */
 #define AUTH_TIMEOUT                300	/* unit: msec */
@@ -69,23 +70,30 @@
 #define SHORT_CHANNEL_TIME          90	/* unit: msec */
 #define MIN_CHANNEL_TIME            110	/* unit: msec, for dual band scan */
 #define MAX_CHANNEL_TIME            140	/* unit: msec, for single band scan */
-#define	FAST_ACTIVE_SCAN_TIME	    30	/* Active scan waiting for probe response time */
-#define CW_MIN_IN_BITS              4	/* actual CwMin = 2^CW_MIN_IN_BITS - 1 */
+#define	FAST_ACTIVE_SCAN_TIME	    30
+/* Active scan waiting for probe response time */
+#define CW_MIN_IN_BITS              4
+/* actual CwMin = 2^CW_MIN_IN_BITS - 1 */
 #define LINK_DOWN_TIMEOUT           20000	/* unit: msec */
-#define AUTO_WAKEUP_TIMEOUT			70	/*unit: msec */
+#define AUTO_WAKEUP_TIMEOUT		70	/*unit: msec */
+#define CW_MAX_IN_BITS              10
+/* actual CwMax = 2^CW_MAX_IN_BITS - 1 */
+/* Note: RSSI_TO_DBM_OFFSET has been changed
+to variable for new RF (2004-0720). */

-#define CW_MAX_IN_BITS              10	/* actual CwMax = 2^CW_MAX_IN_BITS - 1 */
-
-/* Note: RSSI_TO_DBM_OFFSET has been changed to variable for new RF (2004-0720). */
 /* SHould not refer to this constant anymore */
 /*#define RSSI_TO_DBM_OFFSET          120 // for RT2530 RSSI-115 = dBm */
 #define RSSI_FOR_MID_TX_POWER       -55	/* -55 db is considered mid-distance */
-#define RSSI_FOR_LOW_TX_POWER       -45	/* -45 db is considered very short distance and */
-				/* eligible to use a lower TX power */
+#define RSSI_FOR_LOW_TX_POWER       -45
+/* -45 db is considered very short distance and eligible to use a
+lower TX power */
 #define RSSI_FOR_LOWEST_TX_POWER    -30
-/*#define MID_TX_POWER_DELTA          0   // 0 db from full TX power upon mid-distance to AP */
-#define LOW_TX_POWER_DELTA          6	/* -3 db from full TX power upon very short distance. 1 grade is 0.5 db */
-#define LOWEST_TX_POWER_DELTA       16	/* -8 db from full TX power upon shortest distance. 1 grade is 0.5 db */
+/*#define MID_TX_POWER_DELTA          0
+0 db from full TX power upon mid-distance to AP*/
+#define LOW_TX_POWER_DELTA          6
+/* -3 db from full TX power upon very short distance. 1 grade is 0.5 db */
+#define LOWEST_TX_POWER_DELTA       16
+/* -8 db from full TX power upon shortest distance. 1 grade is 0.5 db */

 #define RSSI_TRIGGERED_UPON_BELOW_THRESHOLD     0
 #define RSSI_TRIGGERED_UPON_EXCCEED_THRESHOLD   1
@@ -95,7 +103,8 @@
 /* Channel Quality Indication */
 #define CQI_IS_GOOD(cqi)            ((cqi) >= 50)
 /*#define CQI_IS_FAIR(cqi)          (((cqi) >= 20) && ((cqi) < 50)) */
-#define CQI_IS_POOR(cqi)            (cqi < 50)	/*(((cqi) >= 5) && ((cqi) < 20)) */
+#define CQI_IS_POOR(cqi)            (cqi < 50)
+/*(((cqi) >= 5) && ((cqi) < 20)) */
 #define CQI_IS_BAD(cqi)             (cqi < 5)
 #define CQI_IS_DEAD(cqi)            (cqi == 0)

@@ -107,14 +116,20 @@
 #define BSS_NOT_FOUND                    0xFFFFFFFF

 #define MAX_LEN_OF_MLME_QUEUE            40	/*10 */
-
-#define SCAN_PASSIVE                     18	/* scan with no probe request, only wait beacon and probe response */
-#define SCAN_ACTIVE                      19	/* scan with probe request, and wait beacon and probe response */
-#define	SCAN_CISCO_PASSIVE				 20	/* Single channel passive scan */
-#define	SCAN_CISCO_ACTIVE				 21	/* Single channel active scan */
-#define	SCAN_CISCO_NOISE				 22	/* Single channel passive scan for noise histogram collection */
-#define	SCAN_CISCO_CHANNEL_LOAD			 23	/* Single channel passive scan for channel load collection */
-#define FAST_SCAN_ACTIVE                 24	/* scan with probe request, and wait beacon and probe response */
+#define SCAN_PASSIVE                     18
+/* scan with no probe request, only wait beacon and probe response */
+#define SCAN_ACTIVE                      19
+/* scan with probe request, and wait beacon and probe response */
+#define	SCAN_CISCO_PASSIVE				 20
+/* Single channel passive scan */
+#define	SCAN_CISCO_ACTIVE				 21
+/* Single channel active scan */
+#define	SCAN_CISCO_NOISE				 22
+/* Single channel passive scan for noise histogram collection */
+#define	SCAN_CISCO_CHANNEL_LOAD			 23
+/* Single channel passive scan for channel load collection */
+#define FAST_SCAN_ACTIVE                 24
+/* scan with probe request, and wait beacon and probe response */

 #define MAC_ADDR_IS_GROUP(Addr)       (((Addr[0]) & 0x01))
 #define MAC_ADDR_HASH(Addr)            (Addr[0] ^ Addr[1] ^ Addr[2] ^ Addr[3] ^ Addr[4] ^ Addr[5])
@@ -145,7 +160,13 @@
 #define CAP_IS_DSSS_OFDM(x)              (((x) & 0x2000) != 0)
 #define CAP_IS_DELAY_BA(x)               (((x) & 0x4000) != 0)	/* 802.11e d9 */

-#define CAP_GENERATE(ess, ibss, priv, s_pre, s_slot, spectrum)  (((ess) ? 0x0001 : 0x0000) | ((ibss) ? 0x0002 : 0x0000) | ((priv) ? 0x0010 : 0x0000) | ((s_pre) ? 0x0020 : 0x0000) | ((s_slot) ? 0x0400 : 0x0000) | ((spectrum) ? 0x0100 : 0x0000))
+#define CAP_GENERATE(ess, ibss, priv, s_pre, s_slot, spectrum) \
+(((ess) ? 0x0001 : 0x0000) | \
+((ibss) ? 0x0002 : 0x0000) | \
+((priv) ? 0x0010 : 0x0000) | \
+((s_pre) ? 0x0020 : 0x0000) | \
+((s_slot) ? 0x0400 : 0x0000) | \
+((spectrum) ? 0x0100 : 0x0000))

 #define ERP_IS_NON_ERP_PRESENT(x)        (((x) & 0x01) != 0)	/* 802.11g */
 #define ERP_IS_USE_PROTECTION(x)         (((x) & 0x02) != 0)	/* 802.11g */
@@ -154,9 +175,9 @@
 #define DRS_TX_QUALITY_WORST_BOUND       8	/* 3  // just test by gary */
 #define DRS_PENALTY                      8

-#define BA_NOTUSE 	2
+#define BA_NOTUSE	2
 /*BA Policy subfiled value in ADDBA frame */
-#define IMMED_BA 	1
+#define IMMED_BA	1
 #define DELAY_BA	0

 /* BA Initiator subfield in DELBA frame */
@@ -306,7 +327,7 @@ struct PACKED rt_overlap_bss_scan_ie {
 };

 /*  7.3.2.56. 20/40 Coexistence element used in  Element ID = 72 = IE_2040_BSS_COEXIST */
-typedef union PACKED _BSS_2040_COEXIST_IE {
+union PACKED _BSS_2040_COEXIST_IE {
 	struct PACKED {
 		u8 InfoReq:1;
 		u8 Intolerant40:1;	/* Inter-BSS. set 1 when prohibits a receiving BSS from operating as a 20/40 Mhz BSS. */
@@ -485,7 +506,7 @@ struct PACKED rt_ba_parm {
 };

 /* 2-byte BA Starting Seq CONTROL field */
-typedef union PACKED _BASEQ_CONTROL {
+union PACKED _BASEQ_CONTROL {
 	struct PACKED {
 		u16 FragNum:4;	/* always set to 0 */
 		u16 StartSeq:12;	/* sequence number of the 1st MSDU for which this BAR is sent */
@@ -1000,14 +1021,14 @@ struct PACKED rt_rtmp_tx_rate_switch {
 #define MAC_ENTRY_LIFE_CHECK_CNT		20	/* packet cnt. */

 /* Value domain of pMacEntry->Sst */
-typedef enum _Sst {
+enum _Sst {
 	SST_NOT_AUTH,		/* 0: equivalent to IEEE 802.11/1999 state 1 */
 	SST_AUTH,		/* 1: equivalent to IEEE 802.11/1999 state 2 */
 	SST_ASSOC		/* 2: equivalent to IEEE 802.11/1999 state 3 */
 } SST;

 /* value domain of pMacEntry->AuthState */
-typedef enum _AuthState {
+enum _AuthState {
 	AS_NOT_AUTH,
 	AS_AUTH_OPEN,		/* STA has been authenticated using OPEN SYSTEM */
 	AS_AUTH_KEY,		/* STA has been authenticated using SHARED KEY */
@@ -1015,7 +1036,7 @@ typedef enum _AuthState {
 } AUTH_STATE;

 /*for-wpa value domain of pMacEntry->WpaState  802.1i D3   p.114 */
-typedef enum _ApWpaState {
+enum _ApWpaState {
 	AS_NOTUSE,		/* 0 */
 	AS_DISCONNECT,		/* 1 */
 	AS_DISCONNECTED,	/* 2 */
@@ -1033,14 +1054,14 @@ typedef enum _ApWpaState {
 } AP_WPA_STATE;

 /* for-wpa value domain of pMacEntry->WpaState  802.1i D3   p.114 */
-typedef enum _GTKState {
+enum _GTKState {
 	REKEY_NEGOTIATING,
 	REKEY_ESTABLISHED,
 	KEYERROR,
 } GTK_STATE;

 /*  for-wpa  value domain of pMacEntry->WpaState  802.1i D3   p.114 */
-typedef enum _WpaGTKState {
+enum _WpaGTKState {
 	SETKEYS,
 	SETKEYS_DONE,
 } WPA_GTK_STATE;
--
1.7.1

