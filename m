Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709Ab0E0JeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 05:34:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49486 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883Ab0E0Jd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 05:33:59 -0400
From: Bashlykov Arthur <madness@xakep.ru>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Bashlykov Arthur <madness@xakep.ru>
Subject: [PATCH 3/4] Staging: rtl8192su: ieee80211: fix brace coding style issue and other issues in ieee80211_softmac_wx.c Signed-off-by: Bashlykov Arthur <madness@xakep.ru>
Date: Thu, 27 May 2010 13:33:52 +0400
Message-Id: <1274952832-4308-1-git-send-email-madness@xakep.ru>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 .../rtl8192su/ieee80211/ieee80211_softmac_wx.c     |   22 ++-----------------
 1 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac_wx.c
index 3e0527c..5743bcd 100644
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac_wx.c
@@ -94,8 +94,6 @@ int ieee80211_wx_get_freq(struct ieee80211_device *ieee,
 	/* NM 0.7.0 will not accept channel any more. */
 	fwrq->m = ieee80211_wlan_frequencies[ieee->current_network.channel-1] * 100000;
 	fwrq->e = 1;
-	/* fwrq->m = ieee->current_network.channel; */
-	/* fwrq->e = 0; */
 
 	return 0;
 }
@@ -230,7 +228,6 @@ int ieee80211_wx_get_rate(struct ieee80211_device *ieee,
 			     union iwreq_data *wrqu, char *extra)
 {
 	u32 tmp_rate = 0;
-	/* printk("===>mode:%d, halfNmode:%d\n", ieee->mode, ieee->bHalfWirelessN24GMode); */
 	if (ieee->mode & (IEEE_A | IEEE_B | IEEE_G))
 		tmp_rate = ieee->rate;
 	else if (ieee->mode & IEEE_N_5G)
@@ -521,13 +518,10 @@ int ieee80211_wx_set_power(struct ieee80211_device *ieee,
 	int ret = 0;
 #if 1
 	if {
-		(!ieee->sta_wake_up) ||
-	/*	(!ieee->ps_request_tx_ack) || */
+		((!ieee->sta_wake_up) ||
 		(!ieee->enter_sleep_state) ||
 		(!ieee->ps_is_queue_empty)) {
 
-	/* printk("ERROR. PS mode is tryied to be use but driver missed a callback\n\n"); */
-
 		return -1;
 	}
 #endif
@@ -537,18 +531,12 @@ int ieee80211_wx_set_power(struct ieee80211_device *ieee,
 		ieee->ps = IEEE80211_PS_DISABLED;
 		goto exit;
 	}
-	if (wrqu->power.flags & IW_POWER_TIMEOUT) {
-		/*ieee->ps_period = wrqu->power.value / 1000; */
+	if (wrqu->power.flags & IW_POWER_TIMEOUT)
 		ieee->ps_timeout = wrqu->power.value / 1000;
-	}
 
-	if (wrqu->power.flags & IW_POWER_PERIOD) {
-
-		/* ieee->ps_timeout = wrqu->power.value / 1000; */
+	if (wrqu->power.flags & IW_POWER_PERIOD)
 		ieee->ps_period = wrqu->power.value / 1000;
-		/* wrq->value / 1024; */
 
-	}
 	switch (wrqu->power.flags & IW_POWER_MODE) {
 	case IW_POWER_UNICAST_R:
 		ieee->ps = IEEE80211_PS_UNICAST;
@@ -561,7 +549,6 @@ int ieee80211_wx_set_power(struct ieee80211_device *ieee,
 		break;
 
 	case IW_POWER_ON:
-	 /* ieee->ps = IEEE80211_PS_DISABLED; */
 		break;
 
 	default:
@@ -595,11 +582,8 @@ int ieee80211_wx_get_power(struct ieee80211_device *ieee,
 		wrqu->power.flags = IW_POWER_TIMEOUT;
 		wrqu->power.value = ieee->ps_timeout * 1000;
 	} else {
-		/* ret = -EOPNOTSUPP; */
-		/* goto exit; */
 		wrqu->power.flags = IW_POWER_PERIOD;
 		wrqu->power.value = ieee->ps_period * 1000;
-/*ieee->current_network.dtim_period * ieee->current_network.beacon_interval * 1024; */
 	}
 
        if ((ieee->ps & (IEEE80211_PS_MBCAST | IEEE80211_PS_UNICAST)) == (IEEE80211_PS_MBCAST | IEEE80211_PS_UNICAST))
-- 
1.7.0.4

