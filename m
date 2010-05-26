Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102Ab0EZXkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:40:46 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:33626 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758217Ab0EZXkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:40:45 -0400
From: Mike Sheldon <mike@mikeasoft.com>
To: greg@kroah.com, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Sheldon <mike@mikeasoft.com>
Subject: [PATCH 01/15] Staging: winbond: Fix spacing around brackets and colons
Date: Thu, 27 May 2010 00:39:38 +0100
Message-Id: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches mac_structures.h to correct the spacing around brackets and colons as reported by checkpatch.pl

Signed-off-by: Mike Sheldon <mike@mikeasoft.com>
---
 drivers/staging/winbond/mac_structures.h |   86 ++++++++++++-----------------
 1 files changed, 36 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/winbond/mac_structures.h b/drivers/staging/winbond/mac_structures.h
index 7441015..84ab290 100644
--- a/drivers/staging/winbond/mac_structures.h
+++ b/drivers/staging/winbond/mac_structures.h
@@ -420,22 +420,18 @@ struct Extended_Supported_Rates_Element {
 #define OUI_CIPHER_CCMP				0x04
 #define OUI_CIPHER_WEP_104			0x05
 
-struct suite_selector
-{
-	union
-	{
+struct suite_selector {
+	union {
 		u8	Value[4];
-		struct _SUIT_
-		{
+		struct _SUIT_ {
 			u8	OUI[3];
 			u8	Type;
-		}SuitSelector;
+		} SuitSelector;
 	};
 };
 
 //--  WPA  --
-struct	RSN_Information_Element
-{
+struct	RSN_Information_Element {
 	u8					Element_ID;
 	u8					Length;
 	struct suite_selector	OuiWPAAdditional; /* WPA version 2.0 additional field, and should be 00:50:F2:01 */
@@ -443,52 +439,45 @@ struct	RSN_Information_Element
 	struct suite_selector		GroupKeySuite;
 	u16					PairwiseKeySuiteCount;
 	struct suite_selector		PairwiseKeySuite[1];
-}__attribute__ ((packed));
-struct RSN_Auth_Sub_Information_Element
-{
+} __attribute__ ((packed));
+struct RSN_Auth_Sub_Information_Element {
 	u16				AuthKeyMngtSuiteCount;
 	struct suite_selector	AuthKeyMngtSuite[1];
-}__attribute__ ((packed));
+} __attribute__ ((packed));
 
 /* --  WPA2  -- */
-struct RSN_Capability_Element
-{
-  union
-  {
+struct RSN_Capability_Element {
+  union {
 	u16	__attribute__ ((packed))	wValue;
     #ifdef _BIG_ENDIAN_	 /* 20060927 add by anson's endian */
-    struct _RSN_Capability
-    {
-    	u16   __attribute__ ((packed))  Reserved2 : 8; /* 20051201 */
-	u16   __attribute__ ((packed))  Reserved1 : 2;
-	u16   __attribute__ ((packed))  GTK_Replay_Counter : 2;
-	u16   __attribute__ ((packed))  PTK_Replay_Counter : 2;
-	u16   __attribute__ ((packed))  No_Pairwise : 1;
-        u16   __attribute__ ((packed))  Pre_Auth : 1;
-    }__attribute__ ((packed))  RSN_Capability;
+    struct _RSN_Capability {
+        u16   __attribute__ ((packed))  Reserved2:8; /* 20051201 */
+	u16   __attribute__ ((packed))  Reserved1:2;
+	u16   __attribute__ ((packed))  GTK_Replay_Counter:2;
+	u16   __attribute__ ((packed))  PTK_Replay_Counter:2;
+	u16   __attribute__ ((packed))  No_Pairwise:1;
+        u16   __attribute__ ((packed))  Pre_Auth:1;
+    } __attribute__ ((packed))  RSN_Capability;
     #else
-    struct _RSN_Capability
-    {
-        u16   __attribute__ ((packed))  Pre_Auth : 1;
-        u16   __attribute__ ((packed))  No_Pairwise : 1;
-        u16   __attribute__ ((packed))  PTK_Replay_Counter : 2;
-	    u16   __attribute__ ((packed))  GTK_Replay_Counter : 2;
-	    u16   __attribute__ ((packed))  Reserved1 : 2;
-	    u16   __attribute__ ((packed))  Reserved2 : 8; /* 20051201 */
-    }__attribute__ ((packed))  RSN_Capability;
+    struct _RSN_Capability {
+        u16   __attribute__ ((packed))  Pre_Auth:1;
+        u16   __attribute__ ((packed))  No_Pairwise:1;
+        u16   __attribute__ ((packed))  PTK_Replay_Counter:2;
+	    u16   __attribute__ ((packed))  GTK_Replay_Counter:2;
+	    u16   __attribute__ ((packed))  Reserved1:2;
+	    u16   __attribute__ ((packed))  Reserved2:8; /* 20051201 */
+    } __attribute__ ((packed))  RSN_Capability;
     #endif
 
-  }__attribute__ ((packed)) ;
-}__attribute__ ((packed)) ;
+  } __attribute__ ((packed)) ;
+} __attribute__ ((packed)) ;
 
 #ifdef _WPA2_
-struct pmkid
-{
+struct pmkid {
   u8 pValue[16];
 };
 
-struct	WPA2_RSN_Information_Element
-{
+struct	WPA2_RSN_Information_Element {
 	u8					Element_ID;
 	u8					Length;
 	u16					Version;
@@ -496,27 +485,24 @@ struct	WPA2_RSN_Information_Element
 	u16					PairwiseKeySuiteCount;
 	struct suite_selector		PairwiseKeySuite[1];
 
-}__attribute__ ((packed));
+} __attribute__ ((packed));
 
-struct WPA2_RSN_Auth_Sub_Information_Element
-{
+struct WPA2_RSN_Auth_Sub_Information_Element {
 	u16				AuthKeyMngtSuiteCount;
 	struct suite_selector	AuthKeyMngtSuite[1];
-}__attribute__ ((packed));
+} __attribute__ ((packed));
 
 
-struct PMKID_Information_Element
-{
+struct PMKID_Information_Element {
 	u16				PMKID_Count;
 	struct pmkid pmkid[16];
-}__attribute__ ((packed));
+} __attribute__ ((packed));
 
 #endif /* enddef _WPA2_ */
 /*============================================================
 // MAC Frame structure (different type) and subfield structure
 //============================================================*/
-struct MAC_frame_control
-{
+struct MAC_frame_control {
     u8    mac_frame_info; /* a combination of the [Protocol Version, Control Type, Control Subtype]*/
     #ifdef _BIG_ENDIAN_ /* 20060927 add by anson's endian */
     u8    order:1;
-- 
1.7.0.4

