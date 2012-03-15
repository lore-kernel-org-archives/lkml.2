Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161794Ab2COXdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 19:33:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38915 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161309Ab2COXdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 19:33:44 -0400
From: Andrew Miller <amiller@amilx.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        amiller@amilx.com
Subject: [PATCH 1/2] Staging: rtl8187se: r8180_wx.c: Removed old comments
Date: Thu, 15 Mar 2012 19:32:07 -0400
Message-Id: <1331854328-21794-2-git-send-email-amiller@amilx.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331854328-21794-1-git-send-email-amiller@amilx.com>
References: <1331854328-21794-1-git-send-email-amiller@amilx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed old comments that were not needed.

Signed-off-by: Andrew Miller <amiller@amilx.com>
---
 drivers/staging/rtl8187se/r8180_wx.c |  165 +---------------------------------
 1 files changed, 2 insertions(+), 163 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_wx.c b/drivers/staging/rtl8187se/r8180_wx.c
index 39ef7e0..9d03cfb 100644
--- a/drivers/staging/rtl8187se/r8180_wx.c
+++ b/drivers/staging/rtl8187se/r8180_wx.c
@@ -23,14 +23,12 @@
 
 #include "ieee80211/dot11d.h"
 
-/* #define RATE_COUNT 4 */
 u32 rtl8180_rates[] = {1000000, 2000000, 5500000, 11000000,
 	6000000, 9000000, 12000000, 18000000, 24000000, 36000000, 48000000, 54000000};
 
 #define RATE_COUNT ARRAY_SIZE(rtl8180_rates)
 
 static CHANNEL_LIST DefaultChannelPlan[] = {
-/*	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14},14},	*/	/*Default channel plan	*/
 	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 36, 40, 44, 48, 52, 56, 60, 64}, 19},			/*FCC							*/
 	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, 11},											/*IC							*/
 	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21},	/*ETSI							*/
@@ -63,14 +61,7 @@ int r8180_wx_set_key(struct net_device *dev, struct iw_request_info *info,
 
 	if (erq->flags & IW_ENCODE_DISABLED)
 
-/*	i = erq->flags & IW_ENCODE_INDEX;
-	if (i < 1 || i > 4)
-*/
-
 	if (erq->length > 0) {
-
-		/*int len = erq->length <= 5 ? 5 : 13;	*/
-
 		u32* tkey = (u32*) key;
 		priv->key0[0] = tkey[0];
 		priv->key0[1] = tkey[1];
@@ -192,15 +183,12 @@ static int r8180_wx_set_mode(struct net_device *dev, struct iw_request_info *a,
 		return 0;
 
 	down(&priv->wx_sem);
-/*	printk("set mode ENABLE_IPS\n");	*/
 	if (priv->bInactivePs)	{
 		if (wrqu->mode == IW_MODE_ADHOC)
 			IPSLeave(dev);
 	}
 	ret = ieee80211_wx_set_mode(priv->ieee80211, a, wrqu, b);
 
-/*	rtl8180_commit(dev);	*/
-
 	up(&priv->wx_sem);
 	return ret;
 }
@@ -238,7 +226,6 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	u16 val;
 	int i;
-	/*struct iw_range_with_scan_capa* tmp = (struct iw_range_with_scan_capa*)range; */ /*YJ,add,080819,for hidden ap */
 
 	wrqu->data.length = sizeof(*range);
 	memset(range, 0, sizeof(*range));
@@ -291,14 +278,6 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 	range->we_version_compiled = WIRELESS_EXT;
 	range->we_version_source = 16;
 
-/*	range->retry_capa;	*/	/* What retry options are supported */
-/*	range->retry_flags;	*/	/* How to decode max/min retry limit */
-/*	range->r_time_flags;*/	/* How to decode max/min retry life */
-/*	range->min_retry;	*/	/* Minimal number of retries */
-/*	range->max_retry;	*/	/* Maximal number of retries */
-/*	range->min_r_time;	*/	/* Minimal retry lifetime */
-/*	range->max_r_time;	*/	/* Maximal retry lifetime */
-
 		range->num_channels = 14;
 
 	for (i = 0, val = 0; i < 14; i++) {
@@ -322,8 +301,6 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
 						IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
 
-	/*tmp->scan_capa = 0x01;	*/	/*YJ,add,080819,for hidden ap	*/
-
 	return 0;
 }
 
@@ -339,50 +316,29 @@ static int r8180_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
 	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
-/*YJ,add,080819, for hidden ap	*/
-	/*printk("==*&*&*&==>%s in\n", __func__);	*/
-	/*printk("=*&*&*&*===>flag:%x, %x\n", wrqu->data.flags, IW_SCAN_THIS_ESSID);	*/
 	if (wrqu->data.flags & IW_SCAN_THIS_ESSID)	{
 		struct iw_scan_req* req = (struct iw_scan_req*)b;
 		if (req->essid_len)		{
-			/*printk("==**&*&*&**===>scan set ssid:%s\n", req->essid); */
 			ieee->current_network.ssid_len = req->essid_len;
 			memcpy(ieee->current_network.ssid, req->essid, req->essid_len);
-			/*printk("=====>network ssid:%s\n", ieee->current_network.ssid); */
 		}
 	}
-/*YJ,add,080819, for hidden ap, end */
 
 	down(&priv->wx_sem);
 	if (priv->up)	{
-/*		printk("set scan ENABLE_IPS\n");	*/
 		priv->ieee80211->actscanning = true;
 		if (priv->bInactivePs && (priv->ieee80211->state != IEEE80211_LINKED))	{
 			IPSLeave(dev);
-			/*down(&priv->ieee80211->wx_sem);	*/
-/*
-			if (priv->ieee80211->iw_mode == IW_MODE_MONITOR || !(priv->ieee80211->proto_started)){
-				ret = -1;
-				up(&priv->ieee80211->wx_sem);
-				up(&priv->wx_sem);
-				return ret;
-			}
-*/
-	/*	queue_work(priv->ieee80211->wq, &priv->ieee80211->wx_sync_scan_wq); */
-		/* printk("start scan============================>\n"); */
 		ieee80211_softmac_ips_scan_syncro(priv->ieee80211);
-/* ieee80211_rtl_start_scan(priv->ieee80211); */
-		/* intentionally forget to up sem */
-/*			up(&priv->ieee80211->wx_sem); */
 			ret = 0;
 		}	else	{
-			/* YJ,add,080828, prevent scan in BusyTraffic */
+			/* prevent scan in BusyTraffic */
 			/* FIXME: Need to consider last scan time */
 			if ((priv->link_detect.bBusyTraffic) && (true))	{
 				ret = 0;
 				printk("Now traffic is busy, please try later!\n");
 			}	else
-				/* YJ,add,080828, prevent scan in BusyTraffic,end */
+				/* prevent scan in BusyTraffic,end */
 				ret = ieee80211_wx_set_scan(priv->ieee80211, a, wrqu, b);
 		}
 	}	else
@@ -424,10 +380,8 @@ static int r8180_wx_set_essid(struct net_device *dev,
 		return 0;
 
 	down(&priv->wx_sem);
-	/* printk("set essid ENABLE_IPS\n"); */
 	if (priv->bInactivePs)
 		IPSLeave(dev);
-/*	printk("haha:set essid %s essid_len = %d essid_flgs = %d\n",b,  wrqu->essid.length, wrqu->essid.flags);	*/
 
 	ret = ieee80211_wx_set_essid(priv->ieee80211, a, wrqu, b);
 
@@ -597,28 +551,6 @@ static int r8180_wx_set_scan_type(struct net_device *dev, struct iw_request_info
 	return 1;
 }
 
-
-/* added by christian */
-/*
-static int r8180_wx_set_monitor_type(struct net_device *dev, struct iw_request_info *aa, union
-	iwreq_data *wrqu, char *p){
-
-	struct r8180_priv *priv = ieee80211_priv(dev);
-	int *parms=(int*)p;
-	int mode=parms[0];
-
-	if(priv->ieee80211->iw_mode != IW_MODE_MONITOR) return -1;
-	priv->prism_hdr = mode;
-	if(!mode)dev->type=ARPHRD_IEEE80211;
-	else dev->type=ARPHRD_IEEE80211_PRISM;
-	DMESG("using %s RX encap", mode ? "AVS":"80211");
-	return 0;
-
-}
-*/
-/*of         r8180_wx_set_monitor_type */
-/* end added christian */
-
 static int r8180_wx_set_retry(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
@@ -661,14 +593,6 @@ static int r8180_wx_set_retry(struct net_device *dev,
 	 */
 
 	rtl8180_commit(dev);
-	/*
-	if(priv->up){
-		rtl8180_rtx_disable(dev);
-		rtl8180_rx_enable(dev);
-		rtl8180_tx_enable(dev);
-
-	}
-	*/
 exit:
 	up(&priv->wx_sem);
 
@@ -695,8 +619,6 @@ static int r8180_wx_get_retry(struct net_device *dev,
 		wrqu->retry.flags = IW_RETRY_LIMIT & IW_RETRY_MIN;
 		wrqu->retry.value = priv->retry_data;
 	}
-	/* DMESG("returning %d",wrqu->retry.value); */
-
 
 	return 0;
 }
@@ -726,7 +648,6 @@ static int r8180_wx_set_sens(struct net_device *dev,
 		return 0;
 
 	down(&priv->wx_sem);
-	/* DMESG("attempt to set sensivity to %ddb",wrqu->sens.value); */
 	if (priv->rf_set_sens == NULL) {
 		err = -1; /* we have not this support for this radio */
 		goto exit;
@@ -847,58 +768,6 @@ static int dummy(struct net_device *dev, struct iw_request_info *a,
 	return -1;
 }
 
-/*
-static int r8180_wx_get_psmode(struct net_device *dev,
-			       struct iw_request_info *info,
-			       union iwreq_data *wrqu, char *extra)
-{
-	struct r8180_priv *priv = ieee80211_priv(dev);
-	struct ieee80211_device *ieee;
-	int ret = 0;
-
-
-
-	down(&priv->wx_sem);
-
-	if(priv) {
-		ieee = priv->ieee80211;
-		if(ieee->ps == IEEE80211_PS_DISABLED) {
-			*((unsigned int *)extra) = IEEE80211_PS_DISABLED;
-			goto exit;
-		}
-		*((unsigned int *)extra) = IW_POWER_TIMEOUT;
-	if (ieee->ps & IEEE80211_PS_MBCAST)
-			*((unsigned int *)extra) |= IW_POWER_ALL_R;
-		else
-			*((unsigned int *)extra) |= IW_POWER_UNICAST_R;
-	} else
-		ret = -1;
-exit:
-	up(&priv->wx_sem);
-
-	return ret;
-}
-static int r8180_wx_set_psmode(struct net_device *dev,
-			       struct iw_request_info *info,
-			       union iwreq_data *wrqu, char *extra)
-{
-	struct r8180_priv *priv = ieee80211_priv(dev);
-	//struct ieee80211_device *ieee;
-	int ret = 0;
-
-
-
-	down(&priv->wx_sem);
-
-	ret = ieee80211_wx_set_power(priv->ieee80211, info, wrqu, extra);
-
-	up(&priv->wx_sem);
-
-	return ret;
-
-}
-*/
-
 static int r8180_wx_get_iwmode(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
@@ -964,7 +833,6 @@ static int r8180_wx_set_iwmode(struct net_device *dev,
 	} else {
 		ieee->mode = mode;
 		ieee->modulation = modulation;
-/*		ieee80211_start_protocol(ieee); */
 	}
 
 	up(&priv->wx_sem);
@@ -1016,7 +884,6 @@ static int r8180_wx_get_siglevel(struct net_device *dev,
 			       union iwreq_data *wrqu, char *extra)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
-	/* struct ieee80211_network *network = &(priv->ieee80211->current_network); */
 	int ret = 0;
 
 
@@ -1036,7 +903,6 @@ static int r8180_wx_get_sigqual(struct net_device *dev,
 			       union iwreq_data *wrqu, char *extra)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
-	/* struct ieee80211_network *network = &(priv->ieee80211->current_network); */
 	int ret = 0;
 
 
@@ -1223,7 +1089,6 @@ static int r8180_wx_set_enc_ext(struct net_device *dev,
 {
 
 	struct r8180_priv *priv = ieee80211_priv(dev);
-	/* printk("===>%s()\n", __func__); */
 
 	int ret = 0;
 
@@ -1257,8 +1122,6 @@ static int r8180_wx_set_mlme(struct net_device *dev,
 										struct iw_request_info *info,
 										union iwreq_data *wrqu, char *extra)
 {
-	/* printk("====>%s()\n", __func__); */
-
 	int ret = 0;
 	struct r8180_priv *priv = ieee80211_priv(dev);
 
@@ -1278,7 +1141,6 @@ static int r8180_wx_set_gen_ie(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-/*	printk("====>%s(), len:%d\n", __func__, data->length); */
 	int ret = 0;
 		struct r8180_priv *priv = ieee80211_priv(dev);
 
@@ -1291,7 +1153,6 @@ static int r8180_wx_set_gen_ie(struct net_device *dev,
 		ret = ieee80211_wx_set_gen_ie(priv->ieee80211, extra, wrqu->data.length);
 #endif
 		up(&priv->wx_sem);
-	/* printk("<======%s(), ret:%d\n", __func__, ret); */
 		return ret;
 
 
@@ -1373,14 +1234,6 @@ static const struct iw_priv_args r8180_private_args[] = {
 		0, 0, "dummy"
 
 	},
-	/* added by christian */
-	/*
-	{
-		SIOCIWFIRSTPRIV + 0x2,
-		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "prismhdr"
-	},
-	*/
-	/* end added by christian */
 	{
 		SIOCIWFIRSTPRIV + 0x4,
 		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "activescan"
@@ -1399,18 +1252,6 @@ static const struct iw_priv_args r8180_private_args[] = {
 		0, 0, "dummy"
 
 	},
-/*
-	{
-		SIOCIWFIRSTPRIV + 0x5,
-		0, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "getpsmode"
-	},
-	{
-		SIOCIWFIRSTPRIV + 0x6,
-		IW_PRIV_SIZE_FIXED, 0, "setpsmode"
-	},
-*/
-/* set/get mode have been realized in public handlers */
-
 	{
 		SIOCIWFIRSTPRIV + 0x8,
 		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "setiwmode"
@@ -1552,9 +1393,7 @@ static struct iw_statistics *r8180_get_wireless_stats(struct net_device *dev)
 	tmp_level = (&ieee->current_network)->stats.signal;
 	tmp_qual = (&ieee->current_network)->stats.signalstrength;
 	tmp_noise = (&ieee->current_network)->stats.noise;
-	/* printk("level:%d, qual:%d, noise:%d\n", tmp_level, tmp_qual, tmp_noise); */
 
-/*	printk("level:%d\n", tmp_level);	*/
 	wstats->qual.level = tmp_level;
 	wstats->qual.qual = tmp_qual;
 	wstats->qual.noise = tmp_noise;
-- 
1.7.7.6

