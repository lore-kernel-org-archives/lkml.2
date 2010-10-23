Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab0JWTJs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 15:09:48 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59531 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab0JWTJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 15:09:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mbEdYjvAJgrup1/rdZXk+XoatCG3ClGuGxk15uzcwE1Bk2YyuSfMXZMVpghICzN1R7
         53lB7lP7vFbAcJk/56JL0E0XisnEGSxuexTGtKI5ZYhEVk60XdxOvU1+heXEEjSmUNHJ
         f8fMQWMuliovDRCcMGwSX1+52HJQMdjR0tFO4=
From: Neil Munro <neilmunro@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Neil Munro <neilmunro@gmail.com>
Subject: [PATCH 2/2] Staging: RT2860: Fixed multiple errors in rtusb_io.h
Date: Sat, 23 Oct 2010 20:12:17 +0100
Message-Id: <1287861137-4272-1-git-send-email-neilmunro@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the errors in rtusb_io.h

Signed-off-by: Neil Munro <neilmunro@gmail.com>
---
 drivers/staging/rt2860/rtusb_io.h |   44 +++++++++++++++++++-----------------
 1 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/rt2860/rtusb_io.h b/drivers/staging/rt2860/rtusb_io.h
index 64a2fe4..bbb34d2 100644
--- a/drivers/staging/rt2860/rtusb_io.h
+++ b/drivers/staging/rt2860/rtusb_io.h
@@ -144,42 +144,44 @@ struct rt_cmdq {

 /* add Client security information into ASIC WCID table and IVEIV table */
 #define RTMP_STA_SECURITY_INFO_ADD(pAd, apidx, KeyID, pEntry)						\
-	{	RTMP_STA_ENTRY_MAC_RESET(pAd, pEntry->Aid);								\
-		if (pEntry->Aid >= 1) {														\
-			struct rt_set_asic_wcid_attri	SetAsicWcidAttri;								\
-			SetAsicWcidAttri.WCID = pEntry->Aid;									\
-			if ((pEntry->AuthMode <= Ndis802_11AuthModeAutoSwitch) &&				\
-				(pEntry->WepStatus == Ndis802_11Encryption1Enabled))				\
-			{																		\
-				SetAsicWcidAttri.Cipher = pAd->SharedKey[apidx][KeyID].CipherAlg;	\
-			}																		\
-			else if (pEntry->AuthMode == Ndis802_11AuthModeWPANone)					\
-			{																		\
-				SetAsicWcidAttri.Cipher = pAd->SharedKey[apidx][KeyID].CipherAlg;	\
-			}																		\
-			else SetAsicWcidAttri.Cipher = 0;										\
-            DBGPRINT(RT_DEBUG_TRACE, ("aid cipher = %ld\n",SetAsicWcidAttri.Cipher));       \
+{
+	RTMP_STA_ENTRY_MAC_RESET(pAd, pEntry->Aid);								\
+	if (pEntry->Aid >= 1) {														\
+		struct rt_set_asic_wcid_attri	SetAsicWcidAttri;								\
+		SetAsicWcidAttri.WCID = pEntry->Aid;									\
+		if ((pEntry->AuthMode <= Ndis802_11AuthModeAutoSwitch) &&				\
+			(pEntry->WepStatus == Ndis802_11Encryption1Enabled)) {	\
+			SetAsicWcidAttri.Cipher = pAd->SharedKey[apidx][KeyID].CipherAlg;	\
+		}																		\
+		else if (pEntry->AuthMode == Ndis802_11AuthModeWPANone)	{	\
+			SetAsicWcidAttri.Cipher = pAd->SharedKey[apidx][KeyID].CipherAlg;	\
+		}																		\
+		else
+			SetAsicWcidAttri.Cipher = 0;										\
+			DBGPRINT(RT_DEBUG_TRACE, ("aid cipher = %ld\n", SetAsicWcidAttri.Cipher));       \
 			RTUSBEnqueueInternalCmd(pAd, CMDTHREAD_SET_ASIC_WCID_CIPHER,			\
-							&SetAsicWcidAttri, sizeof(struct rt_set_asic_wcid_attri)); } }
+						&SetAsicWcidAttri, sizeof(struct rt_set_asic_wcid_attri));
+	}
+}

 /* Insert the BA bitmap to ASIC for the Wcid entry */
 #define RTMP_ADD_BA_SESSION_TO_ASIC(_pAd, _Aid, _TID)					\
-		do{																\
+		do {																\
 			struct rt_set_asic_wcid	SetAsicWcid;							\
 			SetAsicWcid.WCID = (_Aid);									\
 			SetAsicWcid.SetTid = (0x10000<<(_TID));						\
 			SetAsicWcid.DeleteTid = 0xffffffff;							\
 			RTUSBEnqueueInternalCmd((_pAd), CMDTHREAD_SET_ASIC_WCID, &SetAsicWcid, sizeof(struct rt_set_asic_wcid));	\
-		}while(0)
+		} while (0)

 /* Remove the BA bitmap from ASIC for the Wcid entry */
 #define RTMP_DEL_BA_SESSION_FROM_ASIC(_pAd, _Wcid, _TID)				\
-		do{																\
+		do {																\
 			struct rt_set_asic_wcid	SetAsicWcid;							\
 			SetAsicWcid.WCID = (_Wcid);									\
 			SetAsicWcid.SetTid = (0xffffffff);							\
-			SetAsicWcid.DeleteTid = (0x10000<<(_TID) );					\
+			SetAsicWcid.DeleteTid = (0x10000<<(_TID));					\
 			RTUSBEnqueueInternalCmd((_pAd), CMDTHREAD_SET_ASIC_WCID, &SetAsicWcid, sizeof(struct rt_set_asic_wcid));	\
-		}while(0)
+		} while (0)

 #endif /* __RTUSB_IO_H__ // */
--
1.7.3.2

