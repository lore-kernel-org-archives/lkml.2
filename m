Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab2K2Nfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 08:35:43 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34637 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab2K2Nfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 08:35:42 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 2/4] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_wx.c
Date: Thu, 29 Nov 2012 22:35:37 +0900
Message-Id: <1354196137-12001-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354196079-11726-1-git-send-email-yamanetoshi@gmail.com>
References: <1354196079-11726-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors fixed.
-ERROR: that open brace { should be on the previous line
-ERROR: space required before the open parenthesis '('
-ERROR: else should follow close brace '}'
-ERROR: space required before the open brace '{'

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |   25 +++++++-------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
index 9185a21..e37555b 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
@@ -217,22 +217,18 @@ int ieee80211_wx_get_scan(struct ieee80211_device *ieee,
 	down(&ieee->wx_sem);
 	spin_lock_irqsave(&ieee->lock, flags);
 
-	if(!ieee->bHwRadioOff)
-	{
+	if (!ieee->bHwRadioOff) {
 		list_for_each_entry(network, &ieee->network_list, list) {
 			i++;
 
-			if((stop-ev)<200)
-			{
+			if ((stop-ev)<200) {
 				err = -E2BIG;
 				break;
 			}
 			if (ieee->scan_age == 0 ||
-			    time_after(network->last_scanned + ieee->scan_age, jiffies))
-			{
+			    time_after(network->last_scanned + ieee->scan_age, jiffies)) {
 				ev = rtl818x_translate_scan(ieee, ev, stop, network, info);
-			}
-			else
+			} else
 				IEEE80211_DEBUG_SCAN(
 					"Not showing network '%s ("
 					"%pM)' due to age (%lums).\n",
@@ -430,7 +426,7 @@ int ieee80211_wx_get_encode(struct ieee80211_device *ieee,
 
 	IEEE80211_DEBUG_WX("GET_ENCODE\n");
 
-	if(ieee->iw_mode == IW_MODE_MONITOR)
+	if (ieee->iw_mode == IW_MODE_MONITOR)
 		return -1;
 
 	key = erq->flags & IW_ENCODE_INDEX;
@@ -715,15 +711,13 @@ int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len)
 {
 	u8 *buf = NULL;
 
-	if (len>MAX_WPA_IE_LEN || (len && ie == NULL))
-	{
+	if (len>MAX_WPA_IE_LEN || (len && ie == NULL)) {
 		printk("return error out, len:%zu\n", len);
 	return -EINVAL;
 	}
 
-	if (len)
-	{
-		if (len != ie[1]+2){
+	if (len) {
+		if (len != ie[1]+2) {
 			printk("len:%zu, ie:%d\n", len, ie[1]);
 			return -EINVAL;
 		}
@@ -733,8 +727,7 @@ int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len)
 		kfree(ieee->wpa_ie);
 		ieee->wpa_ie = buf;
 		ieee->wpa_ie_len = len;
-	}
-	else{
+	} else {
 		kfree(ieee->wpa_ie);
 		ieee->wpa_ie = NULL;
 		ieee->wpa_ie_len = 0;
-- 
1.7.9.5

