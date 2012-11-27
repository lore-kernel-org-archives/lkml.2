Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab2K0MIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 07:08:55 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab2K0MIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 07:08:53 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 2/8] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_softmac_wx.c
Date: Tue, 27 Nov 2012 21:08:47 +0900
Message-Id: <1354018127-18168-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354018065-18134-1-git-send-email-yamanetoshi@gmail.com>
References: <1354018065-18134-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors fixed.
- ERROR: space required before the open brace '{'
- ERROR: space required before the open parenthesis '('
- ERROR: space prohibited before that close parenthesis ')'
- ERROR: space required after that close brace '}'

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |   73 ++++++++++----------
 1 file changed, 35 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
index f38519e..0b82c600 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
@@ -36,7 +36,7 @@ int ieee80211_wx_set_freq(struct ieee80211_device *ieee, struct iw_request_info
 //	printk("in %s\n",__func__);
 	down(&ieee->wx_sem);
 
-	if(ieee->iw_mode == IW_MODE_INFRA){
+	if (ieee->iw_mode == IW_MODE_INFRA) {
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
@@ -57,18 +57,18 @@ int ieee80211_wx_set_freq(struct ieee80211_device *ieee, struct iw_request_info
 		}
 	}
 
-	if (fwrq->e > 0 || fwrq->m > 14 || fwrq->m < 1 ){
+	if (fwrq->e > 0 || fwrq->m > 14 || fwrq->m < 1) {
 		ret = -EOPNOTSUPP;
 		goto out;
 
-	}else { /* Set the channel */
+	} else { /* Set the channel */
 
 
 		ieee->current_network.channel = fwrq->m;
 		ieee->set_chan(ieee->dev, ieee->current_network.channel);
 
-		if(ieee->iw_mode == IW_MODE_ADHOC || ieee->iw_mode == IW_MODE_MASTER)
-			if(ieee->state == IEEE80211_LINKED){
+		if (ieee->iw_mode == IW_MODE_ADHOC || ieee->iw_mode == IW_MODE_MASTER)
+			if (ieee->state == IEEE80211_LINKED) {
 
 			ieee80211_stop_send_beacons(ieee);
 			ieee80211_start_send_beacons(ieee);
@@ -143,12 +143,12 @@ int ieee80211_wx_set_wap(struct ieee80211_device *ieee,
 
 	down(&ieee->wx_sem);
 	/* use ifconfig hw ether */
-	if (ieee->iw_mode == IW_MODE_MASTER){
+	if (ieee->iw_mode == IW_MODE_MASTER) {
 		ret = -1;
 		goto out;
 	}
 
-	if (temp->sa_family != ARPHRD_ETHER){
+	if (temp->sa_family != ARPHRD_ETHER) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -218,7 +218,7 @@ int ieee80211_wx_set_rate(struct ieee80211_device *ieee,
 	u32 target_rate = wrqu->bitrate.value;
 
 	//added by lizhaoming for auto mode
-	if(target_rate == -1){
+	if (target_rate == -1) {
 	ieee->rate = 110;
 	} else {
 	ieee->rate = target_rate/100000;
@@ -250,16 +250,16 @@ int ieee80211_wx_set_mode(struct ieee80211_device *ieee, struct iw_request_info
 	if (wrqu->mode == ieee->iw_mode)
 		goto out;
 
-	if (wrqu->mode == IW_MODE_MONITOR){
+	if (wrqu->mode == IW_MODE_MONITOR) {
 
 		ieee->dev->type = ARPHRD_IEEE80211;
-	}else{
+	} else {
 		ieee->dev->type = ARPHRD_ETHER;
 	}
 
-	if (!ieee->proto_started){
+	if (!ieee->proto_started) {
 		ieee->iw_mode = wrqu->mode;
-	}else{
+	} else {
 		ieee80211_stop_protocol(ieee);
 		ieee->iw_mode = wrqu->mode;
 		ieee80211_start_protocol(ieee);
@@ -296,7 +296,7 @@ void ieee80211_wx_sync_scan_wq(struct work_struct *work)
 	if (ieee->data_hard_resume)
 		ieee->data_hard_resume(ieee->dev);
 
-	if(ieee->iw_mode == IW_MODE_ADHOC || ieee->iw_mode == IW_MODE_MASTER)
+	if (ieee->iw_mode == IW_MODE_ADHOC || ieee->iw_mode == IW_MODE_MASTER)
 		ieee80211_start_send_beacons(ieee);
 
 	//YJ,add,080828, In prevent of lossing ping packet during scanning
@@ -314,7 +314,7 @@ int ieee80211_wx_set_scan(struct ieee80211_device *ieee, struct iw_request_info
 
 	down(&ieee->wx_sem);
 
-	if (ieee->iw_mode == IW_MODE_MONITOR || !(ieee->proto_started)){
+	if (ieee->iw_mode == IW_MODE_MONITOR || !(ieee->proto_started)) {
 		ret = -1;
 		goto out;
 	}
@@ -323,7 +323,7 @@ int ieee80211_wx_set_scan(struct ieee80211_device *ieee, struct iw_request_info
 	//ieee80211_sta_ps_send_null_frame(ieee, true);
 	//YJ,add,080828,end
 
-	if ( ieee->state == IEEE80211_LINKED){
+	if (ieee->state == IEEE80211_LINKED) {
 		queue_work(ieee->wq, &ieee->wx_sync_scan_wq);
 		/* intentionally forget to up sem */
 		return 0;
@@ -349,17 +349,17 @@ int ieee80211_wx_set_essid(struct ieee80211_device *ieee,
 
 	proto_started = ieee->proto_started;
 
-	if (wrqu->essid.length > IW_ESSID_MAX_SIZE){
+	if (wrqu->essid.length > IW_ESSID_MAX_SIZE) {
 		ret= -E2BIG;
 		goto out;
 	}
 
-	if (ieee->iw_mode == IW_MODE_MONITOR){
+	if (ieee->iw_mode == IW_MODE_MONITOR) {
 		ret= -1;
 		goto out;
 	}
 
-	if(proto_started)
+	if (proto_started)
 		ieee80211_stop_protocol(ieee);
 
 	/* this is just to be sure that the GET wx callback
@@ -377,13 +377,12 @@ int ieee80211_wx_set_essid(struct ieee80211_device *ieee,
 //YJ,modified,080819,end
 
 		//YJ,add,080819,for hidden ap
-		if(len == 0){
+		if (len == 0) {
 			memset(ieee->current_network.bssid, 0, ETH_ALEN);
 			ieee->current_network.capability = 0;
 		}
 		//YJ,add,080819,for hidden ap,end
-	}
-	else{
+	} else {
 		ieee->ssid_set = 0;
 		ieee->current_network.ssid[0] = '\0';
 		ieee->current_network.ssid_len = 0;
@@ -417,7 +416,7 @@ out:
 
 	down(&ieee->wx_sem);
 
-	if(enable)
+	if (enable)
 		ieee->raw_tx = 1;
 	else
 		ieee->raw_tx = 0;
@@ -425,16 +424,15 @@ out:
 	printk(KERN_INFO"raw TX is %s\n",
 	      ieee->raw_tx ? "enabled" : "disabled");
 
-	if(ieee->iw_mode == IW_MODE_MONITOR)
-	{
-		if(prev == 0 && ieee->raw_tx){
+	if (ieee->iw_mode == IW_MODE_MONITOR) {
+		if (prev == 0 && ieee->raw_tx) {
 			if (ieee->data_hard_resume)
 				ieee->data_hard_resume(ieee->dev);
 
 			netif_carrier_on(ieee->dev);
 		}
 
-		if(prev && ieee->raw_tx == 1)
+		if (prev && ieee->raw_tx == 1)
 			netif_carrier_off(ieee->dev);
 	}
 
@@ -448,17 +446,17 @@ int ieee80211_wx_get_name(struct ieee80211_device *ieee,
 			     union iwreq_data *wrqu, char *extra)
 {
 	strlcpy(wrqu->name, "802.11", IFNAMSIZ);
-	if(ieee->modulation & IEEE80211_CCK_MODULATION){
+	if (ieee->modulation & IEEE80211_CCK_MODULATION) {
 		strlcat(wrqu->name, "b", IFNAMSIZ);
-		if(ieee->modulation & IEEE80211_OFDM_MODULATION)
+		if (ieee->modulation & IEEE80211_OFDM_MODULATION)
 			strlcat(wrqu->name, "/g", IFNAMSIZ);
-	}else if(ieee->modulation & IEEE80211_OFDM_MODULATION)
+	} else if (ieee->modulation & IEEE80211_OFDM_MODULATION)
 		strlcat(wrqu->name, "g", IFNAMSIZ);
 
-	if((ieee->state == IEEE80211_LINKED) ||
+	if ((ieee->state == IEEE80211_LINKED) ||
 		(ieee->state == IEEE80211_LINKED_SCANNING))
 		strlcat(wrqu->name,"  link", IFNAMSIZ);
-	else if(ieee->state != IEEE80211_NOLINK)
+	else if (ieee->state != IEEE80211_NOLINK)
 		strlcat(wrqu->name," .....", IFNAMSIZ);
 
 
@@ -473,11 +471,10 @@ int ieee80211_wx_set_power(struct ieee80211_device *ieee,
 {
 	int ret = 0;
 
-	if(
-		(!ieee->sta_wake_up) ||
-		(!ieee->ps_request_tx_ack) ||
-		(!ieee->enter_sleep_state) ||
-		(!ieee->ps_is_queue_empty)){
+	if ((!ieee->sta_wake_up) ||
+	    (!ieee->ps_request_tx_ack) ||
+	    (!ieee->enter_sleep_state) ||
+	    (!ieee->ps_is_queue_empty)) {
 
 		printk("ERROR. PS mode tried to be use but driver missed a callback\n\n");
 
@@ -486,7 +483,7 @@ int ieee80211_wx_set_power(struct ieee80211_device *ieee,
 
 	down(&ieee->wx_sem);
 
-	if (wrqu->power.disabled){
+	if (wrqu->power.disabled) {
 		ieee->ps = IEEE80211_PS_DISABLED;
 
 		goto exit;
@@ -537,7 +534,7 @@ int ieee80211_wx_get_power(struct ieee80211_device *ieee,
 
 	down(&ieee->wx_sem);
 
-	if(ieee->ps == IEEE80211_PS_DISABLED){
+	if (ieee->ps == IEEE80211_PS_DISABLED) {
 		wrqu->power.disabled = 1;
 		goto exit;
 	}
-- 
1.7.9.5

