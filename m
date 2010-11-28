Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab0K1VAP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 16:00:15 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:37385 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab0K1VAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 16:00:11 -0500
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 03/13] w35und: Kill WPA2 definitions
Date: Sun, 28 Nov 2010 22:59:58 +0200
Message-Id: <1290978008-29095-3-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1290978008-29095-1-git-send-email-penberg@kernel.org>
References: <1290978008-29095-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The _WPA2_ macro is always defined but the data structures that are wrapped by
it are never used. Kill them.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/mac_structures.h |   46 ------------------------------
 drivers/staging/winbond/sysdef.h         |    2 -
 2 files changed, 0 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/winbond/mac_structures.h b/drivers/staging/winbond/mac_structures.h
index ed3df29..91c550e 100644
--- a/drivers/staging/winbond/mac_structures.h
+++ b/drivers/staging/winbond/mac_structures.h
@@ -111,9 +111,6 @@
 /* --  WPA  -- */
 
 #define ELEMENT_ID_RSN_WPA					221
-#ifdef _WPA2_
-#define ELEMENT_ID_RSN_WPA2				    48
-#endif /* endif WPA2 */
 
 #define WLAN_MAX_PAIRWISE_CIPHER_SUITE_COUNT    ((u16) 6)
 #define WLAN_MAX_AUTH_KEY_MGT_SUITE_LIST_COUNT  ((u16) 2)
@@ -367,21 +364,11 @@ struct Extended_Supported_Rates_Element {
 
 /* WPA(802.11i draft 3.0) */
 #define VERSION_WPA				1
-#ifdef _WPA2_
-#define VERSION_WPA2            1
-#endif /* end def  _WPA2_ */
 /* WPA2.0 OUI=00:50:F2, the MSB is reserved for suite type */
 #define OUI_WPA					0x00F25000
-#ifdef _WPA2_
-/* for wpa2 change to 0x00ACOF04 by Ws 26/04/04 */
-#define OUI_WPA2				0x00AC0F00
-#endif /* end def _WPA2_ */
 
 #define OUI_WPA_ADDITIONAL		0x01
 #define WLAN_MIN_RSN_WPA_LENGTH                 6 /* added by ws 09/10/04 */
-#ifdef _WPA2_
-#define WLAN_MIN_RSN_WPA2_LENGTH                2 /* Fix to 2 09/14/05 */
-#endif /* end def _WPA2_ */
 
 #define oui_wpa                  (u32)(OUI_WPA|OUI_WPA_ADDITIONAL)
 
@@ -390,12 +377,6 @@ struct Extended_Supported_Rates_Element {
 /* 20061108 For WPS. It's little endian. Big endian is 0x0050F204 */
 #define WPA_WPS_OUI				cpu_to_le32(0x04F25000)
 
-/* -----WPA2----- */
-#ifdef _WPA2_
-#define WPA2_OUI_BIG    ((u32)0x01AC0F00)
-#define WPA2_OUI_LITTLE ((u32)0x01AC0F01)
-#endif /* end def _WPA2_ */
-
 /* Authentication suite */
 #define OUI_AUTH_WPA_NONE           0x00 /* for WPA_NONE */
 #define OUI_AUTH_8021X				0x01
@@ -460,33 +441,6 @@ struct RSN_Capability_Element {
   } __attribute__ ((packed)) ;
 } __attribute__ ((packed)) ;
 
-#ifdef _WPA2_
-struct pmkid {
-  u8 pValue[16];
-};
-
-struct	WPA2_RSN_Information_Element {
-	u8					Element_ID;
-	u8					Length;
-	u16					Version;
-	struct suite_selector		GroupKeySuite;
-	u16					PairwiseKeySuiteCount;
-	struct suite_selector		PairwiseKeySuite[1];
-
-} __attribute__ ((packed));
-
-struct WPA2_RSN_Auth_Sub_Information_Element {
-	u16				AuthKeyMngtSuiteCount;
-	struct suite_selector	AuthKeyMngtSuite[1];
-} __attribute__ ((packed));
-
-
-struct PMKID_Information_Element {
-	u16				PMKID_Count;
-	struct pmkid pmkid[16];
-} __attribute__ ((packed));
-
-#endif /* enddef _WPA2_ */
 /*============================================================
 // MAC Frame structure (different type) and subfield structure
 //============================================================*/
diff --git a/drivers/staging/winbond/sysdef.h b/drivers/staging/winbond/sysdef.h
index f8d8606..8d4ebe1 100644
--- a/drivers/staging/winbond/sysdef.h
+++ b/drivers/staging/winbond/sysdef.h
@@ -3,8 +3,6 @@
 #ifndef SYS_DEF_H
 #define SYS_DEF_H
 
-#define _WPA2_
-
 /* debug print options, mark what debug you don't need */
 
 #ifdef FULL_DEBUG
-- 
1.7.0.4

