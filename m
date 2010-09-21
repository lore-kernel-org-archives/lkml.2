Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab0IUBUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 21:20:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42259 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab0IUBT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 21:19:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FA6PJ+VczZ3JQlgStYukC4GB/5/0MJKomtBrV/HaTitJzoeqHFVJ5Reov9tZfftBZx
         89DbFqAaKkVOR7UZ+aqwPN/2OacsrdRs+OaNrfY1I85z0w5U92Ex+HBIIte2JAHwl7hB
         hcz1euiQ4G6YnxGGI/MXBPH3zyibu9ttVsRPY=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com, linux-kernel@vger.kernel.org
Cc: Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 4/5] Staging: rtl8187se: r8180_wx: fixed a lot of checkptahc.pl issues
Date: Mon, 20 Sep 2010 21:19:41 -0400
Message-Id: <1285031982-3870-4-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285031982-3870-1-git-send-email-tdent48227@gmail.com>
References: <1285031982-3870-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed numerous coding style issues using checkpatch.pl

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8187se/r8180_wx.c |  722 +++++++++++++++++-----------------
 1 files changed, 354 insertions(+), 368 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_wx.c b/drivers/staging/rtl8187se/r8180_wx.c
index 124cde3..39ef7e0 100644
--- a/drivers/staging/rtl8187se/r8180_wx.c
+++ b/drivers/staging/rtl8187se/r8180_wx.c
@@ -1,20 +1,20 @@
 /*
-   This file contains wireless extension handlers.
+	This file contains wireless extension handlers.
 
-   This is part of rtl8180 OpenSource driver.
-   Copyright (C) Andrea Merello 2004-2005  <andreamrl@tiscali.it>
-   Released under the terms of GPL (General Public Licence)
+	This is part of rtl8180 OpenSource driver.
+	Copyright (C) Andrea Merello 2004-2005  <andreamrl@tiscali.it>
+	Released under the terms of GPL (General Public Licence)
 
-   Parts of this driver are based on the GPL part
-   of the official realtek driver.
+	Parts of this driver are based on the GPL part
+	of the official realtek driver.
 
-   Parts of this driver are based on the rtl8180 driver skeleton
-   from Patric Schenke & Andres Salomon.
+	Parts of this driver are based on the rtl8180 driver skeleton
+	from Patric Schenke & Andres Salomon.
 
-   Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver.
+	Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver.
 
-   We want to tanks the Authors of those projects and the Ndiswrapper
-   project Authors.
+	We want to tanks the Authors of those projects and the Ndiswrapper
+	project Authors.
 */
 
 
@@ -23,24 +23,24 @@
 
 #include "ieee80211/dot11d.h"
 
-//#define RATE_COUNT 4
-u32 rtl8180_rates[] = {1000000,2000000,5500000,11000000,
-	6000000,9000000,12000000,18000000,24000000,36000000,48000000,54000000};
+/* #define RATE_COUNT 4 */
+u32 rtl8180_rates[] = {1000000, 2000000, 5500000, 11000000,
+	6000000, 9000000, 12000000, 18000000, 24000000, 36000000, 48000000, 54000000};
 
 #define RATE_COUNT ARRAY_SIZE(rtl8180_rates)
 
 static CHANNEL_LIST DefaultChannelPlan[] = {
-//	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14},14},			//Default channel plan
-	{{1,2,3,4,5,6,7,8,9,10,11,36,40,44,48,52,56,60,64},19},  		//FCC
-	{{1,2,3,4,5,6,7,8,9,10,11},11},                    				//IC
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},  	//ETSI
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},    //Spain. Change to ETSI.
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},  	//France. Change to ETSI.
-	{{14,36,40,44,48,52,56,60,64},9},						//MKK
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14, 36,40,44,48,52,56,60,64},22},//MKK1
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},	//Israel.
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,34,38,42,46},17},			// For 11a , TELEC
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14},14}					//For Global Domain. 1-11:active scan, 12-14 passive scan. //+YJ, 080626
+/*	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14},14},	*/	/*Default channel plan	*/
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 36, 40, 44, 48, 52, 56, 60, 64}, 19},			/*FCC							*/
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, 11},											/*IC							*/
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21},	/*ETSI							*/
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21},	/*Spain. Change to ETSI.		*/
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21},	/*France. Change to ETSI.		*/
+	{{14, 36, 40, 44, 48, 52, 56, 60, 64}, 9},											/*MKK							*/
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 36, 40, 44, 48, 52, 56, 60, 64}, 22},/*MKK1						*/
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 36, 40, 44, 48, 52, 56, 60, 64}, 21},	/*Israel.						*/
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 34, 38, 42, 46}, 17},					/*For 11a , TELEC				*/
+	{{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14}, 14}								/*For Global Domain. 1-11:active scan, 12-14 passive scan.*/	/* +YJ, 080626 */
 };
 static int r8180_wx_get_freq(struct net_device *dev,
 			     struct iw_request_info *a,
@@ -58,12 +58,10 @@ int r8180_wx_set_key(struct net_device *dev, struct iw_request_info *info,
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	struct iw_point *erq = &(wrqu->encoding);
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
-	if (erq->flags & IW_ENCODE_DISABLED) {
-	}
-
+	if (erq->flags & IW_ENCODE_DISABLED)
 
 /*	i = erq->flags & IW_ENCODE_INDEX;
 	if (i < 1 || i > 4)
@@ -71,15 +69,15 @@ int r8180_wx_set_key(struct net_device *dev, struct iw_request_info *info,
 
 	if (erq->length > 0) {
 
-		//int len = erq->length <= 5 ? 5 : 13;
+		/*int len = erq->length <= 5 ? 5 : 13;	*/
 
-		u32* tkey= (u32*) key;
+		u32* tkey = (u32*) key;
 		priv->key0[0] = tkey[0];
 		priv->key0[1] = tkey[1];
 		priv->key0[2] = tkey[2];
-		priv->key0[3] = tkey[3] &0xff;
+		priv->key0[3] = tkey[3] & 0xff;
 		DMESG("Setting wep key to %x %x %x %x",
-		      tkey[0],tkey[1],tkey[2],tkey[3]);
+		      tkey[0], tkey[1], tkey[2], tkey[3]);
 		rtl8180_set_hw_wep(dev);
 	}
 	return 0;
@@ -94,13 +92,13 @@ static int r8180_wx_set_beaconinterval(struct net_device *dev, struct iw_request
 
 	struct r8180_priv *priv = ieee80211_priv(dev);
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 	down(&priv->wx_sem);
-	DMESG("setting beacon interval to %x",bi);
+	DMESG("setting beacon interval to %x", bi);
 
-	priv->ieee80211->current_network.beacon_interval=bi;
+	priv->ieee80211->current_network.beacon_interval = bi;
 	rtl8180_commit(dev);
 	up(&priv->wx_sem);
 
@@ -113,7 +111,7 @@ static int r8180_wx_get_mode(struct net_device *dev, struct iw_request_info *a,
 			     union iwreq_data *wrqu, char *b)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
-	return ieee80211_wx_get_mode(priv->ieee80211,a,wrqu,b);
+	return ieee80211_wx_get_mode(priv->ieee80211, a, wrqu, b);
 }
 
 
@@ -123,7 +121,7 @@ static int r8180_wx_get_rate(struct net_device *dev,
 			     union iwreq_data *wrqu, char *extra)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
-	return ieee80211_wx_get_rate(priv->ieee80211,info,wrqu,extra);
+	return ieee80211_wx_get_rate(priv->ieee80211, info, wrqu, extra);
 }
 
 
@@ -136,12 +134,12 @@ static int r8180_wx_set_rate(struct net_device *dev,
 	struct r8180_priv *priv = ieee80211_priv(dev);
 
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 	down(&priv->wx_sem);
 
-	ret = ieee80211_wx_set_rate(priv->ieee80211,info,wrqu,extra);
+	ret = ieee80211_wx_set_rate(priv->ieee80211, info, wrqu, extra);
 
 	up(&priv->wx_sem);
 
@@ -159,20 +157,20 @@ static int r8180_wx_set_crcmon(struct net_device *dev,
 	short prev = priv->crcmon;
 
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 	down(&priv->wx_sem);
 
-	if(enable)
-		priv->crcmon=1;
+	if (enable)
+		priv->crcmon = 1;
 	else
-		priv->crcmon=0;
+		priv->crcmon = 0;
 
 	DMESG("bad CRC in monitor mode are %s",
 	      priv->crcmon ? "accepted" : "rejected");
 
-	if(prev != priv->crcmon && priv->up){
+	if (prev != priv->crcmon && priv->up)	{
 		rtl8180_down(dev);
 		rtl8180_up(dev);
 	}
@@ -190,47 +188,46 @@ static int r8180_wx_set_mode(struct net_device *dev, struct iw_request_info *a,
 	int ret;
 
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 	down(&priv->wx_sem);
-//	printk("set mode ENABLE_IPS\n");
-	if(priv->bInactivePs){
-		if(wrqu->mode == IW_MODE_ADHOC)
+/*	printk("set mode ENABLE_IPS\n");	*/
+	if (priv->bInactivePs)	{
+		if (wrqu->mode == IW_MODE_ADHOC)
 			IPSLeave(dev);
 	}
-	ret = ieee80211_wx_set_mode(priv->ieee80211,a,wrqu,b);
+	ret = ieee80211_wx_set_mode(priv->ieee80211, a, wrqu, b);
 
-	//rtl8180_commit(dev);
+/*	rtl8180_commit(dev);	*/
 
 	up(&priv->wx_sem);
 	return ret;
 }
 
-//YJ,add,080819,for hidden ap
-struct  iw_range_with_scan_capa
-{
-        /* Informative stuff (to choose between different interface) */
-        __u32           throughput;     /* To give an idea... */
-        /* In theory this value should be the maximum benchmarked
-         * TCP/IP throughput, because with most of these devices the
-         * bit rate is meaningless (overhead an co) to estimate how
-         * fast the connection will go and pick the fastest one.
-         * I suggest people to play with Netperf or any benchmark...
-         */
-
-        /* NWID (or domain id) */
-        __u32           min_nwid;       /* Minimal NWID we are able to set */
-        __u32           max_nwid;       /* Maximal NWID we are able to set */
-
-        /* Old Frequency (backward compat - moved lower ) */
-        __u16           old_num_channels;
-        __u8            old_num_frequency;
-
-        /* Scan capabilities */
-        __u8            scan_capa;
+/* YJ,add,080819,for hidden ap */
+struct  iw_range_with_scan_capa	{
+		/* Informative stuff (to choose between different interface)	*/
+		__u32		throughput;		/* To give an idea...				*/
+		/* In theory this value should be the maximum benchmarked
+		* TCP/IP throughput, because with most of these devices the
+		* bit rate is meaningless (overhead an co) to estimate how
+		* fast the connection will go and pick the fastest one.
+		* I suggest people to play with Netperf or any benchmark...
+		*/
+
+		/* NWID (or domain id)	*/
+		__u32           min_nwid;       /* Minimal NWID we are able to set */
+		__u32			max_nwid;		/* Maximal NWID we are able to set */
+
+		/* Old Frequency (backward compat - moved lower ) */
+		__u16			old_num_channels;
+		__u8			old_num_frequency;
+
+		/* Scan capabilities */
+		__u8			scan_capa;
 };
-//YJ,add,080819,for hidden ap
+/* YJ,add,080819,for hidden ap */
 
 
 static int rtl8180_wx_get_range(struct net_device *dev,
@@ -241,7 +238,7 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	u16 val;
 	int i;
-	//struct iw_range_with_scan_capa* tmp = (struct iw_range_with_scan_capa*)range; //YJ,add,080819,for hidden ap
+	/*struct iw_range_with_scan_capa* tmp = (struct iw_range_with_scan_capa*)range; */ /*YJ,add,080819,for hidden ap */
 
 	wrqu->data.length = sizeof(*range);
 	memset(range, 0, sizeof(*range));
@@ -257,16 +254,16 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 	/* ~5 Mb/s real (802.11b) */
 	range->throughput = 5 * 1000 * 1000;
 
-	// TODO: Not used in 802.11b?
-//	range->min_nwid;	/* Minimal NWID we are able to set */
-	// TODO: Not used in 802.11b?
-//	range->max_nwid;	/* Maximal NWID we are able to set */
+	/* TODO: Not used in 802.11b?	*/
+/*	range->min_nwid; */	/* Minimal NWID we are able to set */
+	/* TODO: Not used in 802.11b?	*/
+/*	range->max_nwid; */	/* Maximal NWID we are able to set */
 
-        /* Old Frequency (backward compat - moved lower ) */
-//	range->old_num_channels;
-//	range->old_num_frequency;
-//	range->old_freq[6]; /* Filler to keep "version" at the same offset */
-	if(priv->rf_set_sens != NULL)
+		/* Old Frequency (backward compat - moved lower ) */
+/*	range->old_num_channels; */
+/*	range->old_num_frequency; */
+/*	range->old_freq[6]; */ /* Filler to keep "version" at the same offset */
+	if (priv->rf_set_sens != NULL)
 		range->sensitivity = priv->max_sens;	/* signal level threshold range */
 
 	range->max_qual.qual = 100;
@@ -283,9 +280,8 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 
 	range->num_bitrates = RATE_COUNT;
 
-	for (i = 0; i < RATE_COUNT && i < IW_MAX_BITRATES; i++) {
+	for (i = 0; i < RATE_COUNT && i < IW_MAX_BITRATES; i++)
 		range->bitrate[i] = rtl8180_rates[i];
-	}
 
 	range->min_frag = MIN_FRAG_THRESHOLD;
 	range->max_frag = MAX_FRAG_THRESHOLD;
@@ -295,27 +291,27 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 	range->we_version_compiled = WIRELESS_EXT;
 	range->we_version_source = 16;
 
-//	range->retry_capa;	/* What retry options are supported */
-//	range->retry_flags;	/* How to decode max/min retry limit */
-//	range->r_time_flags;	/* How to decode max/min retry life */
-//	range->min_retry;	/* Minimal number of retries */
-//	range->max_retry;	/* Maximal number of retries */
-//	range->min_r_time;	/* Minimal retry lifetime */
-//	range->max_r_time;	/* Maximal retry lifetime */
+/*	range->retry_capa;	*/	/* What retry options are supported */
+/*	range->retry_flags;	*/	/* How to decode max/min retry limit */
+/*	range->r_time_flags;*/	/* How to decode max/min retry life */
+/*	range->min_retry;	*/	/* Minimal number of retries */
+/*	range->max_retry;	*/	/* Maximal number of retries */
+/*	range->min_r_time;	*/	/* Minimal retry lifetime */
+/*	range->max_r_time;	*/	/* Maximal retry lifetime */
 
-        range->num_channels = 14;
+		range->num_channels = 14;
 
 	for (i = 0, val = 0; i < 14; i++) {
 
-		// Include only legal frequencies for some countries
+		/* Include only legal frequencies for some countries */
 		if ((GET_DOT11D_INFO(priv->ieee80211)->channel_map)[i+1]) {
-		        range->freq[val].i = i + 1;
+				range->freq[val].i = i + 1;
 			range->freq[val].m = ieee80211_wlan_frequencies[i] * 100000;
 			range->freq[val].e = 1;
 			val++;
 		} else {
-			// FIXME: do we need to set anything for channels
-			// we don't use ?
+			/* FIXME: do we need to set anything for channels	*/
+			/* we don't use ?	*/
 		}
 
 		if (val == IW_MAX_FREQUENCIES)
@@ -324,9 +320,9 @@ static int rtl8180_wx_get_range(struct net_device *dev,
 
 	range->num_frequency = val;
 	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
-                          IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
+						IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
 
-	//tmp->scan_capa = 0x01; //YJ,add,080819,for hidden ap
+	/*tmp->scan_capa = 0x01;	*/	/*YJ,add,080819,for hidden ap	*/
 
 	return 0;
 }
@@ -340,64 +336,57 @@ static int r8180_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
 	struct ieee80211_device* ieee = priv->ieee80211;
 
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
-//YJ,add,080819, for hidden ap
-	//printk("==*&*&*&==>%s in\n", __func__);
-	//printk("=*&*&*&*===>flag:%x, %x\n", wrqu->data.flags, IW_SCAN_THIS_ESSID);
-	if (wrqu->data.flags & IW_SCAN_THIS_ESSID)
-	{
+/*YJ,add,080819, for hidden ap	*/
+	/*printk("==*&*&*&==>%s in\n", __func__);	*/
+	/*printk("=*&*&*&*===>flag:%x, %x\n", wrqu->data.flags, IW_SCAN_THIS_ESSID);	*/
+	if (wrqu->data.flags & IW_SCAN_THIS_ESSID)	{
 		struct iw_scan_req* req = (struct iw_scan_req*)b;
-		if (req->essid_len)
-		{
-			//printk("==**&*&*&**===>scan set ssid:%s\n", req->essid);
+		if (req->essid_len)		{
+			/*printk("==**&*&*&**===>scan set ssid:%s\n", req->essid); */
 			ieee->current_network.ssid_len = req->essid_len;
 			memcpy(ieee->current_network.ssid, req->essid, req->essid_len);
-			//printk("=====>network ssid:%s\n", ieee->current_network.ssid);
+			/*printk("=====>network ssid:%s\n", ieee->current_network.ssid); */
 		}
 	}
-//YJ,add,080819, for hidden ap, end
+/*YJ,add,080819, for hidden ap, end */
 
 	down(&priv->wx_sem);
-	if(priv->up){
-//		printk("set scan ENABLE_IPS\n");
+	if (priv->up)	{
+/*		printk("set scan ENABLE_IPS\n");	*/
 		priv->ieee80211->actscanning = true;
-		if(priv->bInactivePs && (priv->ieee80211->state != IEEE80211_LINKED)){
+		if (priv->bInactivePs && (priv->ieee80211->state != IEEE80211_LINKED))	{
 			IPSLeave(dev);
-//			down(&priv->ieee80211->wx_sem);
-
-//			if (priv->ieee80211->iw_mode == IW_MODE_MONITOR || !(priv->ieee80211->proto_started)){
-//				ret = -1;
-//				up(&priv->ieee80211->wx_sem);
-//				up(&priv->wx_sem);
-//				return ret;
-//			}
-
-	//	queue_work(priv->ieee80211->wq, &priv->ieee80211->wx_sync_scan_wq);
-		//printk("start scan============================>\n");
+			/*down(&priv->ieee80211->wx_sem);	*/
+/*
+			if (priv->ieee80211->iw_mode == IW_MODE_MONITOR || !(priv->ieee80211->proto_started)){
+				ret = -1;
+				up(&priv->ieee80211->wx_sem);
+				up(&priv->wx_sem);
+				return ret;
+			}
+*/
+	/*	queue_work(priv->ieee80211->wq, &priv->ieee80211->wx_sync_scan_wq); */
+		/* printk("start scan============================>\n"); */
 		ieee80211_softmac_ips_scan_syncro(priv->ieee80211);
-//ieee80211_rtl_start_scan(priv->ieee80211);
+/* ieee80211_rtl_start_scan(priv->ieee80211); */
 		/* intentionally forget to up sem */
-//			up(&priv->ieee80211->wx_sem);
+/*			up(&priv->ieee80211->wx_sem); */
 			ret = 0;
-		}
-		else
-		{
-			//YJ,add,080828, prevent scan in BusyTraffic
-			//FIXME: Need to consider last scan time
-			if ((priv->link_detect.bBusyTraffic) && (true))
-			{
+		}	else	{
+			/* YJ,add,080828, prevent scan in BusyTraffic */
+			/* FIXME: Need to consider last scan time */
+			if ((priv->link_detect.bBusyTraffic) && (true))	{
 				ret = 0;
 				printk("Now traffic is busy, please try later!\n");
-			}
-			else
-			//YJ,add,080828, prevent scan in BusyTraffic,end
-				ret = ieee80211_wx_set_scan(priv->ieee80211,a,wrqu,b);
+			}	else
+				/* YJ,add,080828, prevent scan in BusyTraffic,end */
+				ret = ieee80211_wx_set_scan(priv->ieee80211, a, wrqu, b);
 		}
-	}
-	else
-		ret = -1;
+	}	else
+			ret = -1;
 
 	up(&priv->wx_sem);
 
@@ -413,8 +402,8 @@ static int r8180_wx_get_scan(struct net_device *dev, struct iw_request_info *a,
 	struct r8180_priv *priv = ieee80211_priv(dev);
 
 	down(&priv->wx_sem);
-	if(priv->up)
-		ret = ieee80211_wx_get_scan(priv->ieee80211,a,wrqu,b);
+	if (priv->up)
+		ret = ieee80211_wx_get_scan(priv->ieee80211, a, wrqu, b);
 	else
 		ret = -1;
 
@@ -431,16 +420,16 @@ static int r8180_wx_set_essid(struct net_device *dev,
 
 	int ret;
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 	down(&priv->wx_sem);
-	//printk("set essid ENABLE_IPS\n");
-	if(priv->bInactivePs)
+	/* printk("set essid ENABLE_IPS\n"); */
+	if (priv->bInactivePs)
 		IPSLeave(dev);
-//	printk("haha:set essid %s essid_len = %d essid_flgs = %d\n",b,  wrqu->essid.length, wrqu->essid.flags);
+/*	printk("haha:set essid %s essid_len = %d essid_flgs = %d\n",b,  wrqu->essid.length, wrqu->essid.flags);	*/
 
-	ret = ieee80211_wx_set_essid(priv->ieee80211,a,wrqu,b);
+	ret = ieee80211_wx_set_essid(priv->ieee80211, a, wrqu, b);
 
 	up(&priv->wx_sem);
 	return ret;
@@ -471,7 +460,7 @@ static int r8180_wx_set_freq(struct net_device *dev, struct iw_request_info *a,
 	struct r8180_priv *priv = ieee80211_priv(dev);
 
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 	down(&priv->wx_sem);
@@ -497,7 +486,7 @@ static int r8180_wx_set_frag(struct net_device *dev,
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 	if (wrqu->frag.disabled)
@@ -536,12 +525,12 @@ static int r8180_wx_set_wap(struct net_device *dev,
 	int ret;
 	struct r8180_priv *priv = ieee80211_priv(dev);
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 	down(&priv->wx_sem);
 
-	ret = ieee80211_wx_set_wap(priv->ieee80211,info,awrq,extra);
+	ret = ieee80211_wx_set_wap(priv->ieee80211, info, awrq, extra);
 
 	up(&priv->wx_sem);
 	return ret;
@@ -555,7 +544,7 @@ static int r8180_wx_get_wap(struct net_device *dev,
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
 
-	return ieee80211_wx_get_wap(priv->ieee80211,info,wrqu,extra);
+	return ieee80211_wx_get_wap(priv->ieee80211, info, wrqu, extra);
 }
 
 
@@ -566,16 +555,16 @@ static int r8180_wx_set_enc(struct net_device *dev,
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	int ret;
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 
 	down(&priv->wx_sem);
 
-	if(priv->hw_wep) ret = r8180_wx_set_key(dev,info,wrqu,key);
-	else{
+	if (priv->hw_wep) ret = r8180_wx_set_key(dev, info, wrqu, key);
+	else	{
 		DMESG("Setting SW wep key");
-		ret = ieee80211_wx_set_encode(priv->ieee80211,info,wrqu,key);
+		ret = ieee80211_wx_set_encode(priv->ieee80211, info, wrqu, key);
 	}
 
 	up(&priv->wx_sem);
@@ -594,13 +583,13 @@ static int r8180_wx_get_enc(struct net_device *dev,
 
 
 static int r8180_wx_set_scan_type(struct net_device *dev, struct iw_request_info *aa, union
- iwreq_data *wrqu, char *p){
+	iwreq_data *wrqu, char *p)	{
 
- 	struct r8180_priv *priv = ieee80211_priv(dev);
-	int *parms=(int*)p;
-	int mode=parms[0];
+	struct r8180_priv *priv = ieee80211_priv(dev);
+	int *parms = (int*)p;
+	int mode = parms[0];
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 	priv->ieee80211->active_scan = mode;
@@ -612,14 +601,14 @@ static int r8180_wx_set_scan_type(struct net_device *dev, struct iw_request_info
 /* added by christian */
 /*
 static int r8180_wx_set_monitor_type(struct net_device *dev, struct iw_request_info *aa, union
- iwreq_data *wrqu, char *p){
+	iwreq_data *wrqu, char *p){
 
- 	struct r8180_priv *priv = ieee80211_priv(dev);
+	struct r8180_priv *priv = ieee80211_priv(dev);
 	int *parms=(int*)p;
 	int mode=parms[0];
 
 	if(priv->ieee80211->iw_mode != IW_MODE_MONITOR) return -1;
-  	priv->prism_hdr = mode;
+	priv->prism_hdr = mode;
 	if(!mode)dev->type=ARPHRD_IEEE80211;
 	else dev->type=ARPHRD_IEEE80211_PRISM;
 	DMESG("using %s RX encap", mode ? "AVS":"80211");
@@ -627,7 +616,7 @@ static int r8180_wx_set_monitor_type(struct net_device *dev, struct iw_request_i
 
 }
 */
-//of         r8180_wx_set_monitor_type
+/*of         r8180_wx_set_monitor_type */
 /* end added christian */
 
 static int r8180_wx_set_retry(struct net_device *dev,
@@ -637,30 +626,30 @@ static int r8180_wx_set_retry(struct net_device *dev,
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	int err = 0;
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 	down(&priv->wx_sem);
 
 	if (wrqu->retry.flags & IW_RETRY_LIFETIME ||
-	    wrqu->retry.disabled){
+	    wrqu->retry.disabled)	{
 		err = -EINVAL;
 		goto exit;
 	}
-	if (!(wrqu->retry.flags & IW_RETRY_LIMIT)){
+	if (!(wrqu->retry.flags & IW_RETRY_LIMIT))	{
 		err = -EINVAL;
 		goto exit;
 	}
 
-	if(wrqu->retry.value > R8180_MAX_RETRY){
-		err= -EINVAL;
+	if (wrqu->retry.value > R8180_MAX_RETRY)	{
+		err = -EINVAL;
 		goto exit;
 	}
 	if (wrqu->retry.flags & IW_RETRY_MAX) {
 		priv->retry_rts = wrqu->retry.value;
 		DMESG("Setting retry for RTS/CTS data to %d", wrqu->retry.value);
 
-	}else {
+	}	else {
 		priv->retry_data = wrqu->retry.value;
 		DMESG("Setting retry for non RTS/CTS data to %d", wrqu->retry.value);
 	}
@@ -671,7 +660,7 @@ static int r8180_wx_set_retry(struct net_device *dev,
 	 * I'm unsure if whole reset is really needed
 	 */
 
- 	rtl8180_commit(dev);
+	rtl8180_commit(dev);
 	/*
 	if(priv->up){
 		rtl8180_rtx_disable(dev);
@@ -706,7 +695,7 @@ static int r8180_wx_get_retry(struct net_device *dev,
 		wrqu->retry.flags = IW_RETRY_LIMIT & IW_RETRY_MIN;
 		wrqu->retry.value = priv->retry_data;
 	}
-	//DMESG("returning %d",wrqu->retry.value);
+	/* DMESG("returning %d",wrqu->retry.value); */
 
 
 	return 0;
@@ -717,7 +706,7 @@ static int r8180_wx_get_sens(struct net_device *dev,
 				union iwreq_data *wrqu, char *extra)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
-	if(priv->rf_set_sens == NULL)
+	if (priv->rf_set_sens == NULL)
 		return -1; /* we have not this support for this radio */
 	wrqu->sens.value = priv->sens;
 	return 0;
@@ -733,19 +722,19 @@ static int r8180_wx_set_sens(struct net_device *dev,
 
 	short err = 0;
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 	down(&priv->wx_sem);
-	//DMESG("attempt to set sensivity to %ddb",wrqu->sens.value);
-	if(priv->rf_set_sens == NULL) {
-		err= -1; /* we have not this support for this radio */
+	/* DMESG("attempt to set sensivity to %ddb",wrqu->sens.value); */
+	if (priv->rf_set_sens == NULL) {
+		err = -1; /* we have not this support for this radio */
 		goto exit;
 	}
-	if(priv->rf_set_sens(dev, wrqu->sens.value) == 0)
+	if (priv->rf_set_sens(dev, wrqu->sens.value) == 0)
 		priv->sens = wrqu->sens.value;
 	else
-		err= -EINVAL;
+		err = -EINVAL;
 
 exit:
 	up(&priv->wx_sem);
@@ -761,7 +750,7 @@ static int r8180_wx_set_rawtx(struct net_device *dev,
 	struct r8180_priv *priv = ieee80211_priv(dev);
 	int ret;
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 	down(&priv->wx_sem);
@@ -798,15 +787,15 @@ static int r8180_wx_set_power(struct net_device *dev,
 	struct r8180_priv *priv = ieee80211_priv(dev);
 
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 	down(&priv->wx_sem);
-	printk("=>>>>>>>>>>=============================>set power:%d,%d!\n",wrqu->power.disabled, wrqu->power.flags);
-	if (wrqu->power.disabled==0) {
-		wrqu->power.flags|=IW_POWER_ALL_R;
-		wrqu->power.flags|=IW_POWER_TIMEOUT;
-		wrqu->power.value =1000;
+	printk("=>>>>>>>>>>=============================>set power:%d, %d!\n", wrqu->power.disabled, wrqu->power.flags);
+	if (wrqu->power.disabled == 0) {
+		wrqu->power.flags |= IW_POWER_ALL_R;
+		wrqu->power.flags |= IW_POWER_TIMEOUT;
+		wrqu->power.value = 1000;
 	}
 
 	ret = ieee80211_wx_set_power(priv->ieee80211, info, wrqu, extra);
@@ -823,7 +812,7 @@ static int r8180_wx_set_rts(struct net_device *dev,
 	struct r8180_priv *priv = ieee80211_priv(dev);
 
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 	if (wrqu->rts.disabled)
@@ -853,7 +842,7 @@ static int r8180_wx_get_rts(struct net_device *dev,
 	return 0;
 }
 static int dummy(struct net_device *dev, struct iw_request_info *a,
-		 union iwreq_data *wrqu,char *b)
+		 union iwreq_data *wrqu, char *b)
 {
 	return -1;
 }
@@ -878,7 +867,7 @@ static int r8180_wx_get_psmode(struct net_device *dev,
 			goto exit;
 		}
 		*((unsigned int *)extra) = IW_POWER_TIMEOUT;
- 	if (ieee->ps & IEEE80211_PS_MBCAST)
+	if (ieee->ps & IEEE80211_PS_MBCAST)
 			*((unsigned int *)extra) |= IW_POWER_ALL_R;
 		else
 			*((unsigned int *)extra) |= IW_POWER_UNICAST_R;
@@ -925,11 +914,11 @@ static int r8180_wx_get_iwmode(struct net_device *dev,
 	ieee = priv->ieee80211;
 
 	strcpy(extra, "802.11");
-	if(ieee->modulation & IEEE80211_CCK_MODULATION) {
+	if (ieee->modulation & IEEE80211_CCK_MODULATION) {
 		strcat(extra, "b");
-		if(ieee->modulation & IEEE80211_OFDM_MODULATION)
+		if (ieee->modulation & IEEE80211_OFDM_MODULATION)
 			strcat(extra, "/g");
-	} else if(ieee->modulation & IEEE80211_OFDM_MODULATION)
+	} else if (ieee->modulation & IEEE80211_OFDM_MODULATION)
 		strcat(extra, "g");
 
 	up(&priv->wx_sem);
@@ -947,7 +936,7 @@ static int r8180_wx_set_iwmode(struct net_device *dev,
 	int modulation = 0, mode = 0;
 
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 	down(&priv->wx_sem);
@@ -967,7 +956,7 @@ static int r8180_wx_set_iwmode(struct net_device *dev,
 	printk(KERN_INFO "B/G mode!\n");
 	}
 
-	if(ieee->proto_started) {
+	if (ieee->proto_started) {
 		ieee80211_stop_protocol(ieee);
 		ieee->mode = mode;
 		ieee->modulation = modulation;
@@ -975,7 +964,7 @@ static int r8180_wx_set_iwmode(struct net_device *dev,
 	} else {
 		ieee->mode = mode;
 		ieee->modulation = modulation;
-//		ieee80211_start_protocol(ieee);
+/*		ieee80211_start_protocol(ieee); */
 	}
 
 	up(&priv->wx_sem);
@@ -994,7 +983,7 @@ static int r8180_wx_get_preamble(struct net_device *dev,
 
 
 
-	*extra = (char) priv->plcp_preamble_mode; 	// 0:auto 1:short 2:long
+	*extra = (char) priv->plcp_preamble_mode;	/* 0:auto 1:short 2:long */
 	up(&priv->wx_sem);
 
 	return 0;
@@ -1007,11 +996,11 @@ static int r8180_wx_set_preamble(struct net_device *dev,
 	int ret = 0;
 
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 	down(&priv->wx_sem);
-	if (*extra<0||*extra>2)
+	if (*extra < 0 || *extra > 2)
 		ret = -1;
 	else
 		priv->plcp_preamble_mode = *((short *)extra) ;
@@ -1027,14 +1016,14 @@ static int r8180_wx_get_siglevel(struct net_device *dev,
 			       union iwreq_data *wrqu, char *extra)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
-	//struct ieee80211_network *network = &(priv->ieee80211->current_network);
+	/* struct ieee80211_network *network = &(priv->ieee80211->current_network); */
 	int ret = 0;
 
 
 
 	down(&priv->wx_sem);
-	// Modify by hikaru 6.5
-	*((int *)extra) = priv->wstats.qual.level;//for interface test ,it should be the priv->wstats.qual.level;
+	/* Modify by hikaru 6.5 */
+	*((int *)extra) = priv->wstats.qual.level;/*for interface test ,it should be the priv->wstats.qual.level; */
 
 
 
@@ -1047,14 +1036,14 @@ static int r8180_wx_get_sigqual(struct net_device *dev,
 			       union iwreq_data *wrqu, char *extra)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
-	//struct ieee80211_network *network = &(priv->ieee80211->current_network);
+	/* struct ieee80211_network *network = &(priv->ieee80211->current_network); */
 	int ret = 0;
 
 
 
 	down(&priv->wx_sem);
-	// Modify by hikaru 6.5
-	*((int *)extra) = priv->wstats.qual.qual;//for interface test ,it should be the priv->wstats.qual.qual;
+	/* Modify by hikaru 6.5	*/
+	*((int *)extra) = priv->wstats.qual.qual;/* for interface test ,it should be the priv->wstats.qual.qual; */
 
 
 
@@ -1066,7 +1055,7 @@ static int r8180_wx_reset_stats(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct r8180_priv *priv =ieee80211_priv(dev);
+	struct r8180_priv *priv = ieee80211_priv(dev);
 	down(&priv->wx_sem);
 
 	priv->stats.txrdu = 0;
@@ -1091,11 +1080,11 @@ static int r8180_wx_reset_stats(struct net_device *dev,
 	priv->stats.txbeaconerr = 0;
 	priv->stats.txlpokint = 0;
 	priv->stats.txlperr = 0;
-	priv->stats.txretry =0;//20060601
-	priv->stats.rxcrcerrmin=0;
-	priv->stats.rxcrcerrmid=0;
-	priv->stats.rxcrcerrmax=0;
-	priv->stats.rxicverr=0;
+	priv->stats.txretry = 0;/* 20060601 */
+	priv->stats.rxcrcerrmin = 0 ;
+	priv->stats.rxcrcerrmid = 0;
+	priv->stats.rxcrcerrmax = 0;
+	priv->stats.rxicverr = 0;
 
 	up(&priv->wx_sem);
 
@@ -1106,9 +1095,9 @@ static int r8180_wx_radio_on(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct r8180_priv *priv =ieee80211_priv(dev);
+	struct r8180_priv *priv = ieee80211_priv(dev);
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 
@@ -1125,9 +1114,9 @@ static int r8180_wx_radio_off(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct r8180_priv *priv =ieee80211_priv(dev);
+	struct r8180_priv *priv = ieee80211_priv(dev);
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 
@@ -1161,28 +1150,26 @@ static int r8180_wx_set_channelplan(struct net_device *dev,
 			     union iwreq_data *wrqu, char *extra)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
-	//struct ieee80211_device *ieee = netdev_priv(dev);
+	/* struct ieee80211_device *ieee = netdev_priv(dev); */
 	int *val = (int *)extra;
 	int i;
 	printk("-----in fun %s\n", __func__);
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
-	//unsigned long flags;
+	/* unsigned long flags; */
 	down(&priv->wx_sem);
-	if (DefaultChannelPlan[*val].Len != 0){
-		priv ->channel_plan = *val;
-		// Clear old channel map
-		for (i=1;i<=MAX_CHANNEL_NUMBER;i++)
-		{
+	if (DefaultChannelPlan[*val].Len != 0)	{
+		priv->channel_plan = *val;
+		/* Clear old channel map 8 */
+		for (i = 1; i <= MAX_CHANNEL_NUMBER; i++)
 			GET_DOT11D_INFO(priv->ieee80211)->channel_map[i] = 0;
-		}
-		// Set new channel map
-		for (i=1;i<=DefaultChannelPlan[*val].Len;i++)
-		{
+
+		/* Set new channel map */
+		for (i = 1; i <= DefaultChannelPlan[*val].Len; i++)
 			GET_DOT11D_INFO(priv->ieee80211)->channel_map[DefaultChannelPlan[*val].Channel[i-1]] = 1;
-		}
+		
 	}
 	up(&priv->wx_sem);
 
@@ -1194,7 +1181,7 @@ static int r8180_wx_get_version(struct net_device *dev,
 			       union iwreq_data *wrqu, char *extra)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
-	//struct ieee80211_device *ieee;
+	/* struct ieee80211_device *ieee; */
 
 	down(&priv->wx_sem);
 	strcpy(extra, "1020.0808");
@@ -1203,8 +1190,8 @@ static int r8180_wx_get_version(struct net_device *dev,
 	return 0;
 }
 
-//added by amy 080818
-//receive datarate from user typing valid rate is from 2 to 108 (1 - 54M), if input 0, return to normal rate adaptive.
+/* added by amy 080818 */
+/*receive datarate from user typing valid rate is from 2 to 108 (1 - 54M), if input 0, return to normal rate adaptive. */
 static int r8180_wx_set_forcerate(struct net_device *dev,
 			     struct iw_request_info *info,
 			     union iwreq_data *wrqu, char *extra)
@@ -1214,36 +1201,33 @@ static int r8180_wx_set_forcerate(struct net_device *dev,
 
 	down(&priv->wx_sem);
 
-	printk("==============>%s(): forcerate is %d\n",__func__,forcerate);
-	if((forcerate == 2) || (forcerate == 4) || (forcerate == 11) || (forcerate == 22) || (forcerate == 12) ||
+	printk("==============>%s(): forcerate is %d\n", __func__, forcerate);
+	if ((forcerate == 2) || (forcerate == 4) || (forcerate == 11) || (forcerate == 22) || (forcerate == 12) ||
 		(forcerate == 18) || (forcerate == 24) || (forcerate == 36) || (forcerate == 48) || (forcerate == 72) ||
 		(forcerate == 96) || (forcerate == 108))
 	{
 		priv->ForcedDataRate = 1;
 		priv->ieee80211->rate = forcerate * 5;
-	}
-	else if(forcerate == 0)
-	{
+	}	else if (forcerate == 0)	{
 		priv->ForcedDataRate = 0;
 		printk("OK! return rate adaptive\n");
-	}
-	else
-		printk("ERR: wrong rate\n");
+	}	else
+			printk("ERR: wrong rate\n");
 	up(&priv->wx_sem);
 	return 0;
 }
 
 static int r8180_wx_set_enc_ext(struct net_device *dev,
-                                        struct iw_request_info *info,
-                                        union iwreq_data *wrqu, char *extra)
+										struct iw_request_info *info,
+										union iwreq_data *wrqu, char *extra)
 {
 
 	struct r8180_priv *priv = ieee80211_priv(dev);
-	//printk("===>%s()\n", __func__);
+	/* printk("===>%s()\n", __func__); */
 
-	int ret=0;
+	int ret = 0;
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 	down(&priv->wx_sem);
@@ -1256,11 +1240,11 @@ static int r8180_wx_set_auth(struct net_device *dev,
 			     struct iw_request_info *info,
 			     union iwreq_data *wrqu, char *extra)
 {
-	//printk("====>%s()\n", __func__);
+	/* printk("====>%s()\n", __func__); */
 	struct r8180_priv *priv = ieee80211_priv(dev);
-	int ret=0;
+	int ret = 0;
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 	down(&priv->wx_sem);
@@ -1270,16 +1254,16 @@ static int r8180_wx_set_auth(struct net_device *dev,
 }
 
 static int r8180_wx_set_mlme(struct net_device *dev,
-                                        struct iw_request_info *info,
-                                        union iwreq_data *wrqu, char *extra)
+										struct iw_request_info *info,
+										union iwreq_data *wrqu, char *extra)
 {
-	//printk("====>%s()\n", __func__);
+	/* printk("====>%s()\n", __func__); */
 
-	int ret=0;
+	int ret = 0;
 	struct r8180_priv *priv = ieee80211_priv(dev);
 
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
 
@@ -1294,82 +1278,81 @@ static int r8180_wx_set_gen_ie(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-//	printk("====>%s(), len:%d\n", __func__, data->length);
-	int ret=0;
-        struct r8180_priv *priv = ieee80211_priv(dev);
+/*	printk("====>%s(), len:%d\n", __func__, data->length); */
+	int ret = 0;
+		struct r8180_priv *priv = ieee80211_priv(dev);
 
 
-	if(priv->ieee80211->bHwRadioOff)
+	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
-        down(&priv->wx_sem);
+		down(&priv->wx_sem);
 #if 1
-        ret = ieee80211_wx_set_gen_ie(priv->ieee80211, extra, wrqu->data.length);
+		ret = ieee80211_wx_set_gen_ie(priv->ieee80211, extra, wrqu->data.length);
 #endif
-        up(&priv->wx_sem);
-	//printk("<======%s(), ret:%d\n", __func__, ret);
-        return ret;
+		up(&priv->wx_sem);
+	/* printk("<======%s(), ret:%d\n", __func__, ret); */
+		return ret;
 
 
 }
-static iw_handler r8180_wx_handlers[] =
-{
-        NULL,                     /* SIOCSIWCOMMIT */
-        r8180_wx_get_name,   	  /* SIOCGIWNAME */
-        dummy,                    /* SIOCSIWNWID */
-        dummy,                    /* SIOCGIWNWID */
-        r8180_wx_set_freq,        /* SIOCSIWFREQ */
-        r8180_wx_get_freq,        /* SIOCGIWFREQ */
-        r8180_wx_set_mode,        /* SIOCSIWMODE */
-        r8180_wx_get_mode,        /* SIOCGIWMODE */
-        r8180_wx_set_sens,        /* SIOCSIWSENS */
-        r8180_wx_get_sens,        /* SIOCGIWSENS */
-        NULL,                     /* SIOCSIWRANGE */
-        rtl8180_wx_get_range,	  /* SIOCGIWRANGE */
-        NULL,                     /* SIOCSIWPRIV */
-        NULL,                     /* SIOCGIWPRIV */
-        NULL,                     /* SIOCSIWSTATS */
-        NULL,                     /* SIOCGIWSTATS */
-        dummy,                    /* SIOCSIWSPY */
-        dummy,                    /* SIOCGIWSPY */
-        NULL,                     /* SIOCGIWTHRSPY */
-        NULL,                     /* SIOCWIWTHRSPY */
-        r8180_wx_set_wap,      	  /* SIOCSIWAP */
-        r8180_wx_get_wap,         /* SIOCGIWAP */
-	r8180_wx_set_mlme,        /* SIOCSIWMLME*/
-        dummy,                    /* SIOCGIWAPLIST -- depricated */
-        r8180_wx_set_scan,        /* SIOCSIWSCAN */
-        r8180_wx_get_scan,        /* SIOCGIWSCAN */
-        r8180_wx_set_essid,       /* SIOCSIWESSID */
-        r8180_wx_get_essid,       /* SIOCGIWESSID */
-        dummy,                    /* SIOCSIWNICKN */
-        dummy,                    /* SIOCGIWNICKN */
-        NULL,                     /* -- hole -- */
-        NULL,                     /* -- hole -- */
-        r8180_wx_set_rate,        /* SIOCSIWRATE */
-        r8180_wx_get_rate,        /* SIOCGIWRATE */
-        r8180_wx_set_rts,         /* SIOCSIWRTS */
-        r8180_wx_get_rts,         /* SIOCGIWRTS */
-        r8180_wx_set_frag,        /* SIOCSIWFRAG */
-        r8180_wx_get_frag,        /* SIOCGIWFRAG */
-        dummy,                    /* SIOCSIWTXPOW */
-        dummy,                    /* SIOCGIWTXPOW */
-        r8180_wx_set_retry,       /* SIOCSIWRETRY */
-        r8180_wx_get_retry,       /* SIOCGIWRETRY */
-        r8180_wx_set_enc,         /* SIOCSIWENCODE */
-        r8180_wx_get_enc,         /* SIOCGIWENCODE */
-        r8180_wx_set_power,       /* SIOCSIWPOWER */
-        r8180_wx_get_power,       /* SIOCGIWPOWER */
-        NULL,			  /*---hole---*/
-	NULL, 			  /*---hole---*/
-	r8180_wx_set_gen_ie,      /* SIOCSIWGENIE */
-	NULL, 			  /* SIOCSIWGENIE */
-	r8180_wx_set_auth,	  /* SIOCSIWAUTH */
-	NULL,                     /* SIOCSIWAUTH */
-	r8180_wx_set_enc_ext, 	  /* SIOCSIWENCODEEXT */
-	NULL,                  	  /* SIOCSIWENCODEEXT */
-	NULL, 			 /* SIOCSIWPMKSA */
-	NULL, 			  /*---hole---*/
+static iw_handler r8180_wx_handlers[] =	{
+		NULL,						/* SIOCSIWCOMMIT */
+		r8180_wx_get_name,			/* SIOCGIWNAME */
+		dummy,						/* SIOCSIWNWID */
+		dummy,						/* SIOCGIWNWID */
+		r8180_wx_set_freq,			/* SIOCSIWFREQ */
+		r8180_wx_get_freq,			/* SIOCGIWFREQ */
+		r8180_wx_set_mode,			/* SIOCSIWMODE */
+		r8180_wx_get_mode,			/* SIOCGIWMODE */
+		r8180_wx_set_sens,			/* SIOCSIWSENS */
+		r8180_wx_get_sens,			/* SIOCGIWSENS */
+		NULL,						/* SIOCSIWRANGE */
+		rtl8180_wx_get_range,		/* SIOCGIWRANGE */
+		NULL,						/* SIOCSIWPRIV */
+		NULL,						/* SIOCGIWPRIV */
+		NULL,						/* SIOCSIWSTATS */
+		NULL,						/* SIOCGIWSTATS */
+		dummy,						/* SIOCSIWSPY */
+		dummy,						/* SIOCGIWSPY */
+		NULL,						/* SIOCGIWTHRSPY */
+		NULL,						/* SIOCWIWTHRSPY */
+		r8180_wx_set_wap,			/* SIOCSIWAP */
+		r8180_wx_get_wap,			/* SIOCGIWAP */
+		r8180_wx_set_mlme,			/* SIOCSIWMLME*/
+		dummy,						/* SIOCGIWAPLIST -- depricated */
+		r8180_wx_set_scan,			/* SIOCSIWSCAN */
+		r8180_wx_get_scan,			/* SIOCGIWSCAN */
+		r8180_wx_set_essid,			/* SIOCSIWESSID */
+		r8180_wx_get_essid,			/* SIOCGIWESSID */
+		dummy,						/* SIOCSIWNICKN */
+		dummy,						/* SIOCGIWNICKN */
+		NULL,						/* -- hole -- */
+		NULL,						/* -- hole -- */
+		r8180_wx_set_rate,			/* SIOCSIWRATE */
+		r8180_wx_get_rate,			/* SIOCGIWRATE */
+		r8180_wx_set_rts,			/* SIOCSIWRTS */
+		r8180_wx_get_rts,			/* SIOCGIWRTS */
+		r8180_wx_set_frag,			/* SIOCSIWFRAG */
+		r8180_wx_get_frag,			/* SIOCGIWFRAG */
+		dummy,						/* SIOCSIWTXPOW */
+		dummy,						/* SIOCGIWTXPOW */
+		r8180_wx_set_retry,			/* SIOCSIWRETRY */
+		r8180_wx_get_retry,			/* SIOCGIWRETRY */
+		r8180_wx_set_enc,			/* SIOCSIWENCODE */
+		r8180_wx_get_enc,			/* SIOCGIWENCODE */
+		r8180_wx_set_power,			/* SIOCSIWPOWER */
+		r8180_wx_get_power,			/* SIOCGIWPOWER */
+		NULL,						/*---hole---*/
+		NULL,						/*---hole---*/
+		r8180_wx_set_gen_ie,		/* SIOCSIWGENIE */
+		NULL,						/* SIOCSIWGENIE */
+		r8180_wx_set_auth,			/* SIOCSIWAUTH */
+		NULL,						/* SIOCSIWAUTH */
+		r8180_wx_set_enc_ext,		/* SIOCSIWENCODEEXT */
+		NULL,						/* SIOCSIWENCODEEXT */
+		NULL,						/* SIOCSIWPMKSA */
+		NULL,						/*---hole---*/
 };
 
 
@@ -1391,10 +1374,12 @@ static const struct iw_priv_args r8180_private_args[] = {
 
 	},
 	/* added by christian */
-	//{
-	//	SIOCIWFIRSTPRIV + 0x2,
-	//	IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "prismhdr"
-	//},
+	/*
+	{
+		SIOCIWFIRSTPRIV + 0x2,
+		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "prismhdr"
+	},
+	*/
 	/* end added by christian */
 	{
 		SIOCIWFIRSTPRIV + 0x4,
@@ -1414,15 +1399,17 @@ static const struct iw_priv_args r8180_private_args[] = {
 		0, 0, "dummy"
 
 	},
-//	{
-//		SIOCIWFIRSTPRIV + 0x5,
-//		0, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "getpsmode"
-//	},
-//	{
-//		SIOCIWFIRSTPRIV + 0x6,
-//		IW_PRIV_SIZE_FIXED, 0, "setpsmode"
-//	},
-//set/get mode have been realized in public handlers
+/*
+	{
+		SIOCIWFIRSTPRIV + 0x5,
+		0, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "getpsmode"
+	},
+	{
+		SIOCIWFIRSTPRIV + 0x6,
+		IW_PRIV_SIZE_FIXED, 0, "setpsmode"
+	},
+*/
+/* set/get mode have been realized in public handlers */
 
 	{
 		SIOCIWFIRSTPRIV + 0x8,
@@ -1453,39 +1440,39 @@ static const struct iw_priv_args r8180_private_args[] = {
 	{
 		SIOCIWFIRSTPRIV + 0xF,
 		0, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "getlinkqual"
- 	},
+	},
 	{
 		SIOCIWFIRSTPRIV + 0x10,
 		0, 0, "resetstats"
- 	},
+	},
 	{
 		SIOCIWFIRSTPRIV + 0x11,
-		0,0, "dummy"
- 	},
+		0, 0, "dummy"
+	},
 	{
 		SIOCIWFIRSTPRIV + 0x12,
 		0, 0, "radioon"
- 	},
+	},
 	{
 		SIOCIWFIRSTPRIV + 0x13,
 		0, 0, "radiooff"
- 	},
- 	{
+	},
+	{
 		SIOCIWFIRSTPRIV + 0x14,
 		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "setchannel"
- 	},
+	},
 	{
 		SIOCIWFIRSTPRIV + 0x15,
 		0, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "getchannel"
- 	},
+	},
 	{
 		SIOCIWFIRSTPRIV + 0x16,
-		0,0, "dummy"
- 	},
+		0, 0, "dummy"
+	},
 	{
 		SIOCIWFIRSTPRIV + 0x17,
-		0,IW_PRIV_TYPE_CHAR | IW_PRIV_SIZE_FIXED | 32, "getversion"
- 	},
+		0, IW_PRIV_TYPE_CHAR | IW_PRIV_SIZE_FIXED | 32, "getversion"
+	},
 	{
 		SIOCIWFIRSTPRIV + 0x18,
 		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "setrate"
@@ -1498,7 +1485,7 @@ static iw_handler r8180_private_handler[] = {
 	dummy,
 	r8180_wx_set_beaconinterval,
 	dummy,
-	//r8180_wx_set_monitor_type,
+	/* r8180_wx_set_monitor_type, */
 	r8180_wx_set_scan_type,
 	dummy,
 	r8180_wx_set_rawtx,
@@ -1512,7 +1499,7 @@ static iw_handler r8180_private_handler[] = {
 	dummy,
 	r8180_wx_get_sigqual,
 	r8180_wx_reset_stats,
-	dummy,//r8180_wx_get_stats
+	dummy,/* r8180_wx_get_stats */
 	r8180_wx_radio_on,
 	r8180_wx_radio_off,
 	r8180_wx_set_channelplan,
@@ -1523,39 +1510,38 @@ static iw_handler r8180_private_handler[] = {
 };
 
 static inline int is_same_network(struct ieee80211_network *src,
-                                  struct ieee80211_network *dst,
+									struct ieee80211_network *dst,
 				  struct ieee80211_device *ieee)
 {
-        /* A network is only a duplicate if the channel, BSSID, ESSID
-         * and the capability field (in particular IBSS and BSS) all match.
-         * We treat all <hidden> with the same BSSID and channel
-         * as one network */
-        return (((src->ssid_len == dst->ssid_len)||(ieee->iw_mode == IW_MODE_INFRA)) &&  //YJ,mod, 080819,for hidden ap
-			//((src->ssid_len == dst->ssid_len) &&
+		/*		A network is only a duplicate if the channel, BSSID, ESSID
+		* and the capability field (in particular IBSS and BSS) all match.
+		* We treat all <hidden> with the same BSSID and channel
+		* as one network		*/
+		return (((src->ssid_len == dst->ssid_len) || (ieee->iw_mode == IW_MODE_INFRA)) &&	/* YJ,mod, 080819,for hidden ap	*/
+			/* ((src->ssid_len == dst->ssid_len) && */
 			(src->channel == dst->channel) &&
 			!memcmp(src->bssid, dst->bssid, ETH_ALEN) &&
-			(!memcmp(src->ssid, dst->ssid, src->ssid_len)||(ieee->iw_mode == IW_MODE_INFRA)) &&  //YJ,mod, 080819,for hidden ap
-			//!memcmp(src->ssid, dst->ssid, src->ssid_len) &&
+			(!memcmp(src->ssid, dst->ssid, src->ssid_len) || (ieee->iw_mode == IW_MODE_INFRA)) &&  /* YJ,mod, 080819,for hidden ap */
+			/*!memcmp(src->ssid, dst->ssid, src->ssid_len) && */
 			((src->capability & WLAN_CAPABILITY_IBSS) ==
 			(dst->capability & WLAN_CAPABILITY_IBSS)) &&
 			((src->capability & WLAN_CAPABILITY_BSS) ==
 			(dst->capability & WLAN_CAPABILITY_BSS)));
 }
 
-//WB modefied to show signal to GUI on 18-01-2008
+/* WB modefied to show signal to GUI on 18-01-2008 */
 static struct iw_statistics *r8180_get_wireless_stats(struct net_device *dev)
 {
-       struct r8180_priv *priv = ieee80211_priv(dev);
+	struct r8180_priv *priv = ieee80211_priv(dev);
 	struct ieee80211_device* ieee = priv->ieee80211;
 	struct iw_statistics* wstats = &priv->wstats;
-	//struct ieee80211_network* target = NULL;
+	/* struct ieee80211_network* target = NULL; */
 	int tmp_level = 0;
 	int tmp_qual = 0;
 	int tmp_noise = 0;
-	//unsigned long flag;
+	/* unsigned long flag; */
 
-	if (ieee->state < IEEE80211_LINKED)
-	{
+	if (ieee->state < IEEE80211_LINKED)	{
 		wstats->qual.qual = 0;
 		wstats->qual.level = 0;
 		wstats->qual.noise = 0;
@@ -1566,22 +1552,22 @@ static struct iw_statistics *r8180_get_wireless_stats(struct net_device *dev)
 	tmp_level = (&ieee->current_network)->stats.signal;
 	tmp_qual = (&ieee->current_network)->stats.signalstrength;
 	tmp_noise = (&ieee->current_network)->stats.noise;
-	//printk("level:%d, qual:%d, noise:%d\n", tmp_level, tmp_qual, tmp_noise);
+	/* printk("level:%d, qual:%d, noise:%d\n", tmp_level, tmp_qual, tmp_noise); */
 
-//	printk("level:%d\n", tmp_level);
+/*	printk("level:%d\n", tmp_level);	*/
 	wstats->qual.level = tmp_level;
 	wstats->qual.qual = tmp_qual;
 	wstats->qual.noise = tmp_noise;
-	wstats->qual.updated = IW_QUAL_ALL_UPDATED| IW_QUAL_DBM;
+	wstats->qual.updated = IW_QUAL_ALL_UPDATED | IW_QUAL_DBM;
 	return wstats;
 }
 
-struct iw_handler_def  r8180_wx_handlers_def={
+struct iw_handler_def  r8180_wx_handlers_def = {
 	.standard = r8180_wx_handlers,
 	.num_standard = ARRAY_SIZE(r8180_wx_handlers),
 	.private = r8180_private_handler,
 	.num_private = ARRAY_SIZE(r8180_private_handler),
- 	.num_private_args = sizeof(r8180_private_args) / sizeof(struct iw_priv_args),
+	.num_private_args = sizeof(r8180_private_args) / sizeof(struct iw_priv_args),
 	.get_wireless_stats = r8180_get_wireless_stats,
 	.private_args = (struct iw_priv_args *)r8180_private_args,
 };
-- 
1.7.3

