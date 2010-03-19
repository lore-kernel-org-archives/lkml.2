Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab0CSUlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:41:50 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63504 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab0CSUls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:41:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xL8mnIkWVQqBTCChkIolpdOG5Tr3ywScmrZX5NdEq3z1HzxqRT6yNqWyEY9G1Mf/uU
         i0vnjzOWmhYRrLQMngvTM8tRO1C6coYH3eVrhR/LZdDJ3sWaVBYm8GbkDhbbBuwpy8fe
         fCBYwtPICc6v5ydhnWUx/nD1X06nfjVza6cUk=
From: Sankar P <sankar.curiosity@gmail.com>
To: gregkh@suse.de, pavel@ucw.cz, penberg@cs.helsinki.fi,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       sankar.curiosity@gmail.com
Subject: [PATCH 3/6] staging: winbond: Convert typedef struct _STRUCT_SELECTOR
Date: Sat, 20 Mar 2010 02:11:01 +0530
Message-Id: <1269031264-2327-4-git-send-email-sankar.curiosity@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269031264-2327-3-git-send-email-sankar.curiosity@gmail.com>
References: <1269031264-2327-1-git-send-email-sankar.curiosity@gmail.com>
 <1269031264-2327-2-git-send-email-sankar.curiosity@gmail.com>
 <1269031264-2327-3-git-send-email-sankar.curiosity@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the declaration typedef struct _STRUCT_SELECTOR
to struct struct_selector and also the places where it was used.

Signed-off-by: Sankar P <sankar.curiosity@gmail.com>
---
 drivers/staging/winbond/mac_structures.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/winbond/mac_structures.h b/drivers/staging/winbond/mac_structures.h
index 7eb0e57..4130cf6 100644
--- a/drivers/staging/winbond/mac_structures.h
+++ b/drivers/staging/winbond/mac_structures.h
@@ -436,7 +436,7 @@ struct Extended_Supported_Rates_Element
 #define OUI_CIPHER_CCMP				0x04
 #define OUI_CIPHER_WEP_104			0x05
 
-typedef struct _SUITE_SELECTOR_
+struct suite_selector
 {
 	union
 	{
@@ -447,23 +447,23 @@ typedef struct _SUITE_SELECTOR_
 			u8	Type;
 		}SuitSelector;
 	};
-}SUITE_SELECTOR;
+};
 
 //--  WPA  --
 struct	RSN_Information_Element
 {
 	u8					Element_ID;
 	u8					Length;
-	SUITE_SELECTOR	OuiWPAAdditional;//WPA version 2.0 additional field, and should be 00:50:F2:01
+	struct suite_selector	OuiWPAAdditional; /* WPA version 2.0 additional field, and should be 00:50:F2:01 */
 	u16					Version;
-	SUITE_SELECTOR		GroupKeySuite;
+	struct suite_selector		GroupKeySuite;
 	u16					PairwiseKeySuiteCount;
-	SUITE_SELECTOR		PairwiseKeySuite[1];
+	struct suite_selector		PairwiseKeySuite[1];
 }__attribute__ ((packed));
 struct RSN_Auth_Sub_Information_Element
 {
 	u16				AuthKeyMngtSuiteCount;
-	SUITE_SELECTOR	AuthKeyMngtSuite[1];
+	struct suite_selector	AuthKeyMngtSuite[1];
 }__attribute__ ((packed));
 
 //--  WPA2  --
@@ -508,16 +508,16 @@ struct	WPA2_RSN_Information_Element
 	u8					Element_ID;
 	u8					Length;
 	u16					Version;
-	SUITE_SELECTOR		GroupKeySuite;
+	struct suite_selector		GroupKeySuite;
 	u16					PairwiseKeySuiteCount;
-	SUITE_SELECTOR		PairwiseKeySuite[1];
+	struct suite_selector		PairwiseKeySuite[1];
 
 }__attribute__ ((packed));
 
 struct WPA2_RSN_Auth_Sub_Information_Element
 {
 	u16				AuthKeyMngtSuiteCount;
-	SUITE_SELECTOR	AuthKeyMngtSuite[1];
+	struct suite_selector	AuthKeyMngtSuite[1];
 }__attribute__ ((packed));
 
 
-- 
1.6.4.2

