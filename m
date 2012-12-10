Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab2LJXW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 18:22:27 -0500
Received: from wren.arvixe.com ([50.97.138.99]:55119 "EHLO wren.arvixe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402Ab2LJXW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 18:22:26 -0500
From: Przemo Firszt <przemo@firszt.eu>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH 1/9] rtl8712: code clean up
Date: Mon, 10 Dec 2012 23:21:19 +0000
Message-Id: <1355181685-4444-1-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.8.0.1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - wren.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
X-Get-Message-Sender-Via: wren.arvixe.com: authenticated_id: przemo@firszt.eu
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean some trivial formating problems in rtl8712 from staging tree. This patch
also changes the way preprocessor macros are defined to keep checkpatch.pl
quiet.

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 drivers/staging/rtl8712/ieee80211.h        |   2 +-
 drivers/staging/rtl8712/rtl871x_cmd.h      |   2 +-
 drivers/staging/rtl8712/rtl871x_security.h |   6 +-
 drivers/staging/rtl8712/sta_info.h         |   2 +-
 drivers/staging/rtl8712/wifi.h             | 167 +++++++++++++----------------
 5 files changed, 79 insertions(+), 100 deletions(-)

diff --git a/drivers/staging/rtl8712/ieee80211.h b/drivers/staging/rtl8712/ieee80211.h
index 21515c3..da4000e 100644
--- a/drivers/staging/rtl8712/ieee80211.h
+++ b/drivers/staging/rtl8712/ieee80211.h
@@ -777,7 +777,7 @@ extern inline int ieee80211_get_hdrlen(u16 fc)
 struct registry_priv;
 
 u8 *r8712_set_ie(u8 *pbuf, sint index, uint len, u8 *source, uint *frlen);
-u8 *r8712_get_ie(u8*pbuf, sint index, sint *len, sint limit);
+u8 *r8712_get_ie(u8 *pbuf, sint index, sint *len, sint limit);
 unsigned char *r8712_get_wpa_ie(unsigned char *pie, int *rsn_ie_len, int limit);
 unsigned char *r8712_get_wpa2_ie(unsigned char *pie, int *rsn_ie_len,
 				 int limit);
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.h b/drivers/staging/rtl8712/rtl871x_cmd.h
index 9d93189..0ce79b1 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.h
+++ b/drivers/staging/rtl8712/rtl871x_cmd.h
@@ -749,7 +749,7 @@ u8 r8712_setopmode_cmd(struct _adapter *padapter,
 u8 r8712_setdatarate_cmd(struct _adapter *padapter, u8 *rateset);
 u8 r8712_set_chplan_cmd(struct _adapter  *padapter, int chplan);
 u8 r8712_setbasicrate_cmd(struct _adapter *padapter, u8 *rateset);
-u8 r8712_getrfreg_cmd(struct _adapter *padapter, u8 offset, u8 * pval);
+u8 r8712_getrfreg_cmd(struct _adapter *padapter, u8 offset, u8 *pval);
 u8 r8712_setrfintfs_cmd(struct _adapter *padapter, u8 mode);
 u8 r8712_setrfreg_cmd(struct _adapter  *padapter, u8 offset, u32 val);
 u8 r8712_setrttbl_cmd(struct _adapter  *padapter,
diff --git a/drivers/staging/rtl8712/rtl871x_security.h b/drivers/staging/rtl8712/rtl871x_security.h
index a13395f..c732aea 100644
--- a/drivers/staging/rtl8712/rtl871x_security.h
+++ b/drivers/staging/rtl8712/rtl871x_security.h
@@ -207,9 +207,9 @@ void seccalctkipmic(
 	u8  *Miccode,
 	u8   priority);
 
-void r8712_secmicsetkey(struct mic_data *pmicdata, u8 * key);
-void r8712_secmicappend(struct mic_data *pmicdata, u8 * src, u32 nBytes);
-void r8712_secgetmic(struct mic_data *pmicdata, u8 * dst);
+void r8712_secmicsetkey(struct mic_data *pmicdata, u8 *key);
+void r8712_secmicappend(struct mic_data *pmicdata, u8 *src, u32 nBytes);
+void r8712_secgetmic(struct mic_data *pmicdata, u8 *dst);
 u32 r8712_aes_encrypt(struct _adapter *padapter, u8 *pxmitframe);
 u32 r8712_tkip_encrypt(struct _adapter *padapter, u8 *pxmitframe);
 void r8712_wep_encrypt(struct _adapter *padapter, u8  *pxmitframe);
diff --git a/drivers/staging/rtl8712/sta_info.h b/drivers/staging/rtl8712/sta_info.h
index f8016e9..c4e0ef2 100644
--- a/drivers/staging/rtl8712/sta_info.h
+++ b/drivers/staging/rtl8712/sta_info.h
@@ -140,7 +140,7 @@ void r8712_free_all_stainfo(struct _adapter *padapter);
 struct sta_info *r8712_get_stainfo(struct sta_priv *pstapriv, u8 *hwaddr);
 void r8712_init_bcmc_stainfo(struct _adapter *padapter);
 struct sta_info *r8712_get_bcmc_stainfo(struct _adapter *padapter);
-u8 r8712_access_ctrl(struct wlan_acl_pool *pacl_list, u8 * mac_addr);
+u8 r8712_access_ctrl(struct wlan_acl_pool *pacl_list, u8 *mac_addr);
 
 #endif /* _STA_INFO_H_ */
 
diff --git a/drivers/staging/rtl8712/wifi.h b/drivers/staging/rtl8712/wifi.h
index 793443e..c08ed2a 100644
--- a/drivers/staging/rtl8712/wifi.h
+++ b/drivers/staging/rtl8712/wifi.h
@@ -159,99 +159,85 @@ enum WIFI_REG_DOMAIN {
 #define _PRIVACY_	BIT(14)
 #define _ORDER_		BIT(15)
 
-#define SetToDs(pbuf)	\
-	do	{	\
-		*(unsigned short *)(pbuf) |= cpu_to_le16(_TO_DS_); \
-	} while (0)
+#define SetToDs(pbuf) ({ \
+	*(unsigned short *)(pbuf) |= cpu_to_le16(_TO_DS_); \
+})
 
 #define GetToDs(pbuf)	(((*(unsigned short *)(pbuf)) & \
 			le16_to_cpu(_TO_DS_)) != 0)
 
-#define ClearToDs(pbuf)	\
-	do	{	\
-		*(unsigned short *)(pbuf) &= (~cpu_to_le16(_TO_DS_)); \
-	} while (0)
+#define ClearToDs(pbuf)	({ \
+	*(unsigned short *)(pbuf) &= (~cpu_to_le16(_TO_DS_)); \
+})
 
-#define SetFrDs(pbuf)	\
-	do	{	\
-		*(unsigned short *)(pbuf) |= cpu_to_le16(_FROM_DS_); \
-	} while (0)
+#define SetFrDs(pbuf) ({ \
+	*(unsigned short *)(pbuf) |= cpu_to_le16(_FROM_DS_); \
+})
 
 #define GetFrDs(pbuf)	(((*(unsigned short *)(pbuf)) & \
 			le16_to_cpu(_FROM_DS_)) != 0)
 
-#define ClearFrDs(pbuf)	\
-	do	{	\
-		*(unsigned short *)(pbuf) &= (~cpu_to_le16(_FROM_DS_)); \
-	} while (0)
+#define ClearFrDs(pbuf)	({ \
+	*(unsigned short *)(pbuf) &= (~cpu_to_le16(_FROM_DS_)); \
+})
 
 #define get_tofr_ds(pframe)	((GetToDs(pframe) << 1) | GetFrDs(pframe))
 
 
-#define SetMFrag(pbuf)	\
-	do	{	\
-		*(unsigned short *)(pbuf) |= cpu_to_le16(_MORE_FRAG_); \
-	} while (0)
+#define SetMFrag(pbuf) ({ \
+	*(unsigned short *)(pbuf) |= cpu_to_le16(_MORE_FRAG_); \
+})
 
 #define GetMFrag(pbuf)	(((*(unsigned short *)(pbuf)) & \
 			le16_to_cpu(_MORE_FRAG_)) != 0)
 
-#define ClearMFrag(pbuf)	\
-	do	{	\
-		*(unsigned short *)(pbuf) &= (~cpu_to_le16(_MORE_FRAG_)); \
-	} while (0)
+#define ClearMFrag(pbuf) ({ \
+	*(unsigned short *)(pbuf) &= (~cpu_to_le16(_MORE_FRAG_)); \
+})
 
-#define SetRetry(pbuf)	\
-	do	{	\
-		*(unsigned short *)(pbuf) |= cpu_to_le16(_RETRY_); \
-	} while (0)
+#define SetRetry(pbuf) ({ \
+	*(unsigned short *)(pbuf) |= cpu_to_le16(_RETRY_); \
+})
 
 #define GetRetry(pbuf)	(((*(unsigned short *)(pbuf)) & \
 			le16_to_cpu(_RETRY_)) != 0)
 
-#define ClearRetry(pbuf)	\
-	do	{	\
-		*(unsigned short *)(pbuf) &= (~cpu_to_le16(_RETRY_)); \
-	} while (0)
+#define ClearRetry(pbuf) ({ \
+	*(unsigned short *)(pbuf) &= (~cpu_to_le16(_RETRY_)); \
+})
 
-#define SetPwrMgt(pbuf)	\
-	do	{	\
-		*(unsigned short *)(pbuf) |= cpu_to_le16(_PWRMGT_); \
-	} while (0)
+#define SetPwrMgt(pbuf) ({ \
+	*(unsigned short *)(pbuf) |= cpu_to_le16(_PWRMGT_); \
+})
 
 #define GetPwrMgt(pbuf)	(((*(unsigned short *)(pbuf)) & \
 			le16_to_cpu(_PWRMGT_)) != 0)
 
-#define ClearPwrMgt(pbuf)	\
-	do	{	\
-		*(unsigned short *)(pbuf) &= (~cpu_to_le16(_PWRMGT_)); \
-	} while (0)
+#define ClearPwrMgt(pbuf) ({ \
+	*(unsigned short *)(pbuf) &= (~cpu_to_le16(_PWRMGT_)); \
+})
 
-#define SetMData(pbuf)	\
-	do	{	\
-		*(unsigned short *)(pbuf) |= cpu_to_le16(_MORE_DATA_); \
-	} while (0)
+#define SetMData(pbuf) ({ \
+	*(unsigned short *)(pbuf) |= cpu_to_le16(_MORE_DATA_); \
+})
 
 #define GetMData(pbuf)	(((*(unsigned short *)(pbuf)) & \
 			le16_to_cpu(_MORE_DATA_)) != 0)
 
-#define ClearMData(pbuf)	\
-	do	{	\
-		*(unsigned short *)(pbuf) &= (~cpu_to_le16(_MORE_DATA_)); \
-	} while (0)
+#define ClearMData(pbuf) ({ \
+	*(unsigned short *)(pbuf) &= (~cpu_to_le16(_MORE_DATA_)); \
+})
 
-#define SetPrivacy(pbuf)	\
-	do	{	\
-		*(unsigned short *)(pbuf) |= cpu_to_le16(_PRIVACY_); \
-	} while (0)
+#define SetPrivacy(pbuf) ({ \
+	*(unsigned short *)(pbuf) |= cpu_to_le16(_PRIVACY_); \
+})
 
 #define GetPrivacy(pbuf)	(((*(unsigned short *)(pbuf)) & \
 				le16_to_cpu(_PRIVACY_)) != 0)
 
-#define ClearPrivacy(pbuf)	\
-	do	{	\
-		*(unsigned short *)(pbuf) &= (~cpu_to_le16(_PRIVACY_)); \
-	} while (0)
+#define ClearPrivacy(pbuf) ({ \
+	*(unsigned short *)(pbuf) &= (~cpu_to_le16(_PRIVACY_)); \
+})
 
 
 #define GetOrder(pbuf)	(((*(unsigned short *)(pbuf)) & \
@@ -287,48 +273,42 @@ enum WIFI_REG_DOMAIN {
 #define GetTupleCache(pbuf)	(cpu_to_le16(*(unsigned short *)\
 				((addr_t)(pbuf) + 22)))
 
-#define SetFragNum(pbuf, num) \
-	do {    \
-		*(unsigned short *)((addr_t)(pbuf) + 22) = \
-			((*(unsigned short *)((addr_t)(pbuf) + 22)) & \
-			le16_to_cpu(~(0x000f))) | \
-			cpu_to_le16(0x0f & (num));     \
-	} while (0)
-
-#define SetSeqNum(pbuf, num) \
-	do {    \
-		*(unsigned short *)((addr_t)(pbuf) + 22) = \
-			((*(unsigned short *)((addr_t)(pbuf) + 22)) & \
-			le16_to_cpu((unsigned short)0x000f)) | \
-			le16_to_cpu((unsigned short)(0xfff0 & (num << 4))); \
-	} while (0)
-
-#define SetDuration(pbuf, dur) \
-	do {    \
-		*(unsigned short *)((addr_t)(pbuf) + 2) |= \
-			cpu_to_le16(0xffff & (dur)); \
-	} while (0)
-
-#define SetPriority(pbuf, tid)	\
-	do	{	\
-		*(unsigned short *)(pbuf) |= cpu_to_le16(tid & 0xf); \
-	} while (0)
+#define SetFragNum(pbuf, num) ({ \
+	*(unsigned short *)((addr_t)(pbuf) + 22) = \
+	((*(unsigned short *)((addr_t)(pbuf) + 22)) & \
+	le16_to_cpu(~(0x000f))) | \
+	cpu_to_le16(0x0f & (num));     \
+})
+
+#define SetSeqNum(pbuf, num) ({ \
+	*(unsigned short *)((addr_t)(pbuf) + 22) = \
+	((*(unsigned short *)((addr_t)(pbuf) + 22)) & \
+	le16_to_cpu((unsigned short)0x000f)) | \
+	le16_to_cpu((unsigned short)(0xfff0 & (num << 4))); \
+})
+
+#define SetDuration(pbuf, dur) ({ \
+	*(unsigned short *)((addr_t)(pbuf) + 2) |= \
+	cpu_to_le16(0xffff & (dur)); \
+})
+
+#define SetPriority(pbuf, tid) ({ \
+	*(unsigned short *)(pbuf) |= cpu_to_le16(tid & 0xf); \
+})
 
 #define GetPriority(pbuf)	((le16_to_cpu(*(unsigned short *)(pbuf))) & 0xf)
 
-#define SetAckpolicy(pbuf, ack)	\
-	do	{	\
-		*(unsigned short *)(pbuf) |= cpu_to_le16((ack & 3) << 5); \
-	} while (0)
+#define SetAckpolicy(pbuf, ack) ({ \
+	*(unsigned short *)(pbuf) |= cpu_to_le16((ack & 3) << 5); \
+})
 
 #define GetAckpolicy(pbuf) (((le16_to_cpu(*(unsigned short *)pbuf)) >> 5) & 0x3)
 
 #define GetAMsdu(pbuf) (((le16_to_cpu(*(unsigned short *)pbuf)) >> 7) & 0x1)
 
-#define SetAMsdu(pbuf, amsdu)	\
-	do	{	\
-		*(unsigned short *)(pbuf) |= cpu_to_le16((amsdu & 1) << 7); \
-	} while (0)
+#define SetAMsdu(pbuf, amsdu) ({ \
+	*(unsigned short *)(pbuf) |= cpu_to_le16((amsdu & 1) << 7); \
+})
 
 #define GetAid(pbuf)	(cpu_to_le16(*(unsigned short *)((addr_t)(pbuf) + 2)) \
 			& 0x3fff)
@@ -526,10 +506,9 @@ static inline unsigned char *get_hdr_bssid(unsigned char *pframe)
 #define IEEE80211_DELBA_PARAM_TID_MASK 0xF000
 #define IEEE80211_DELBA_PARAM_INITIATOR_MASK 0x0800
 
-#define SetOrderBit(pbuf)	\
-	do	{	\
-		*(unsigned short *)(pbuf) |= cpu_to_le16(_ORDER_); \
-	} while (0)
+#define SetOrderBit(pbuf) ({ \
+	*(unsigned short *)(pbuf) |= cpu_to_le16(_ORDER_); \
+})
 
 #define GetOrderBit(pbuf)	(((*(unsigned short *)(pbuf)) & \
 				le16_to_cpu(_ORDER_)) != 0)
-- 
1.8.0.1

