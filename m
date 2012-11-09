Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab2KIPP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:15:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60365 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2KIPP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:15:57 -0500
Message-ID: <509D1E29.1030204@gmail.com>
Date: Fri, 09 Nov 2012 16:15:53 +0100
From: Mehdi Maache <mehdi.maache@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: greg@kroah.com
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: rtl8187se: fixed some checkpatch warnings and errors
 in r8180_wx.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the r8180_wx.c file that fixes up some warnings and 
errors found by the checkpatch.pl tool
- WARNING: line over 80 characters
- ERROR: "(foo*)" should be "(foo *)"
- ERROR: "foo* bar" should be "foo *bar"
- ERROR: trailing whitespace
- ERROR: that open brace { should be on the previous line

Signed-off-by MAACHE Mehdi <mehdi.maache@gmail.com>
---
  drivers/staging/rtl8187se/r8180_wx.c |   95 
+++++++++++++++++++---------------
  1 files changed, 53 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_wx.c 
b/drivers/staging/rtl8187se/r8180_wx.c
index 52f63d7..805c253 100644
--- a/drivers/staging/rtl8187se/r8180_wx.c
+++ b/drivers/staging/rtl8187se/r8180_wx.c
@@ -11,7 +11,8 @@
  	Parts of this driver are based on the rtl8180 driver skeleton
  	from Patric Schenke & Andres Salomon.
  -	Parts of this driver are based on the Intel Pro Wireless 2100 GPL 
driver.
+	Parts of this driver are based on the
+	Intel Pro Wireless 2100 GPL driver.
   	We want to thanks the Authors of those projects and the Ndiswrapper
  	project Authors.
@@ -24,7 +25,8 @@
  #include "ieee80211/dot11d.h"
   u32 rtl8180_rates[] = {1000000, 2000000, 5500000, 11000000,
-	6000000, 9000000, 12000000, 18000000, 24000000, 36000000, 48000000, 
54000000};
+	6000000, 9000000, 12000000, 18000000, 24000000, 36000000,
+	48000000, 54000000};
   #define RATE_COUNT ARRAY_SIZE(rtl8180_rates)
  @@ -59,10 +61,8 @@ int r8180_wx_set_key(struct net_device *dev, struct 
iw_request_info *info,
  	if (priv->ieee80211->bHwRadioOff)
  		return 0;
  -	if (erq->flags & IW_ENCODE_DISABLED)
-
-	if (erq->length > 0) {
-		u32* tkey = (u32*) key;
+	if ((erq->flags & IW_ENCODE_DISABLED) && erq->length > 0) {
+		u32 *tkey = (u32 *) key;
  		priv->key0[0] = tkey[0];
  		priv->key0[1] = tkey[1];
  		priv->key0[2] = tkey[2];
@@ -75,8 +75,9 @@ int r8180_wx_set_key(struct net_device *dev, struct 
iw_request_info *info,
  }
   -static int r8180_wx_set_beaconinterval(struct net_device *dev, 
struct iw_request_info *aa,
-			  union iwreq_data *wrqu, char *b)
+static int r8180_wx_set_beaconinterval(struct net_device *dev,
+					struct iw_request_info *aa,
+					union iwreq_data *wrqu, char *b)
  {
  	int *parms = (int *)b;
  	int bi = parms[0];
@@ -208,7 +209,7 @@ struct  iw_range_with_scan_capa	{
   		/* NWID (or domain id)	*/
  		__u32           min_nwid; /* Minimal NWID we are able to set */
-		__u32			max_nwid; /* Maximal NWID we are able to set */
+		__u32		max_nwid; /* Maximal NWID we are able to set */
   		/* Old Frequency (backward compat - moved lower ) */
  		__u16			old_num_channels;
@@ -296,12 +297,12 @@ static int rtl8180_wx_get_range(struct net_device 
*dev,
  		}
   		if (val == IW_MAX_FREQUENCIES)
-		break;
+			break;
  	}
   	range->num_frequency = val;
  	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
-						IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
+			IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
   	return 0;
  }
@@ -312,26 +313,28 @@ static int r8180_wx_set_scan(struct net_device 
*dev, struct iw_request_info *a,
  {
  	struct r8180_priv *priv = ieee80211_priv(dev);
  	int ret;
-	struct ieee80211_device* ieee = priv->ieee80211;
+	struct ieee80211_device *ieee = priv->ieee80211;
    	if (priv->ieee80211->bHwRadioOff)
  		return 0;
   	if (wrqu->data.flags & IW_SCAN_THIS_ESSID)	{
-		struct iw_scan_req* req = (struct iw_scan_req*)b;
+		struct iw_scan_req *req = (struct iw_scan_req *)b;
  		if (req->essid_len)		{
  			ieee->current_network.ssid_len = req->essid_len;
-			memcpy(ieee->current_network.ssid, req->essid, req->essid_len);
+			memcpy(ieee->current_network.ssid,
+					req->essid, req->essid_len);
  		}
  	}
   	down(&priv->wx_sem);
  	if (priv->up)	{
  		priv->ieee80211->actscanning = true;
-		if (priv->bInactivePs && (priv->ieee80211->state != IEEE80211_LINKED))	{
+		if (priv->bInactivePs &&
+			(priv->ieee80211->state != IEEE80211_LINKED))	{
  			IPSLeave(dev);
-		ieee80211_softmac_ips_scan_syncro(priv->ieee80211);
+			ieee80211_softmac_ips_scan_syncro(priv->ieee80211);
  			ret = 0;
  		}	else	{
  			/* prevent scan in BusyTraffic */
@@ -341,7 +344,8 @@ static int r8180_wx_set_scan(struct net_device *dev, 
struct iw_request_info *a,
  				printk("Now traffic is busy, please try later!\n");
  			}	else
  				/* prevent scan in BusyTraffic,end */
-				ret = ieee80211_wx_set_scan(priv->ieee80211, a, wrqu, b);
+				ret = ieee80211_wx_set_scan(priv->ieee80211,
+						a, wrqu, b);
  		}
  	}	else
  			ret = -1;
@@ -517,10 +521,12 @@ static int r8180_wx_set_enc(struct net_device *dev,
   	down(&priv->wx_sem);
  -	if (priv->hw_wep) ret = r8180_wx_set_key(dev, info, wrqu, key);
+	if (priv->hw_wep)
+		ret = r8180_wx_set_key(dev, info, wrqu, key);
  	else	{
  		DMESG("Setting SW wep key");
-		ret = ieee80211_wx_set_encode(priv->ieee80211, info, wrqu, key);
+		ret = ieee80211_wx_set_encode(priv->ieee80211,
+						info, wrqu, key);
  	}
   	up(&priv->wx_sem);
@@ -538,11 +544,12 @@ static int r8180_wx_get_enc(struct net_device *dev,
  }
   -static int r8180_wx_set_scan_type(struct net_device *dev, struct 
iw_request_info *aa, union
-	iwreq_data *wrqu, char *p)	{
+static int r8180_wx_set_scan_type(struct net_device *dev,
+		struct iw_request_info *aa, union iwreq_data *wrqu, char *p)
+{
   	struct r8180_priv *priv = ieee80211_priv(dev);
-	int *parms = (int*)p;
+	int *parms = (int *)p;
  	int mode = parms[0];
   	if (priv->ieee80211->bHwRadioOff)
@@ -581,11 +588,12 @@ static int r8180_wx_set_retry(struct net_device *dev,
  	}
  	if (wrqu->retry.flags & IW_RETRY_MAX) {
  		priv->retry_rts = wrqu->retry.value;
-		DMESG("Setting retry for RTS/CTS data to %d", wrqu->retry.value);
-
+		DMESG("Setting retry for RTS/CTS data to %d",
+				wrqu->retry.value);
  	}	else {
  		priv->retry_data = wrqu->retry.value;
-		DMESG("Setting retry for non RTS/CTS data to %d", wrqu->retry.value);
+		DMESG("Setting retry for non RTS/CTS data to %d",
+				wrqu->retry.value);
  	}
   	/* FIXME !
@@ -853,7 +861,7 @@ static int r8180_wx_get_preamble(struct net_device *dev,
    -	*extra = (char) priv->plcp_preamble_mode;	/* 0:auto 1:short 2:long */
+	*extra = (char) priv->plcp_preamble_mode; /* 0:auto 1:short 2:long */
  	up(&priv->wx_sem);
   	return 0;
@@ -1036,7 +1044,6 @@ static int r8180_wx_set_channelplan(struct 
net_device *dev,
  		/* Set new channel map */
  		for (i = 1; i <= DefaultChannelPlan[*val].Len; i++)
  		 
GET_DOT11D_INFO(priv->ieee80211)->channel_map[DefaultChannelPlan[*val].Channel[i-1]] 
= 1;
-		
  	}
  	up(&priv->wx_sem);
  @@ -1058,7 +1065,8 @@ static int r8180_wx_get_version(struct 
net_device *dev,
  }
   /* added by amy 080818 */
-/*receive datarate from user typing valid rate is from 2 to 108 (1 - 
54M), if input 0, return to normal rate adaptive. */
+/*receive datarate from user typing valid rate is from 2 to 108 (1 - 54M),
+ *  if input 0, return to normal rate adaptive. */
  static int r8180_wx_set_forcerate(struct net_device *dev,
  			     struct iw_request_info *info,
  			     union iwreq_data *wrqu, char *extra)
@@ -1069,10 +1077,10 @@ static int r8180_wx_set_forcerate(struct 
net_device *dev,
  	down(&priv->wx_sem);
   	printk("==============>%s(): forcerate is %d\n", __func__, forcerate);
-	if ((forcerate == 2) || (forcerate == 4) || (forcerate == 11) || 
(forcerate == 22) || (forcerate == 12) ||
-		(forcerate == 18) || (forcerate == 24) || (forcerate == 36) || 
(forcerate == 48) || (forcerate == 72) ||
-		(forcerate == 96) || (forcerate == 108))
-	{
+	if ((forcerate == 2) || (forcerate == 4) || (forcerate == 11) ||
+		(forcerate == 22) || (forcerate == 12) || (forcerate == 18) ||
+		(forcerate == 24) || (forcerate == 36) || (forcerate == 48) ||
+		(forcerate == 72) || (forcerate == 96) || (forcerate == 108)) {
  		priv->ForcedDataRate = 1;
  		priv->ieee80211->rate = forcerate * 5;
  	}	else if (forcerate == 0)	{
@@ -1085,8 +1093,8 @@ static int r8180_wx_set_forcerate(struct 
net_device *dev,
  }
   static int r8180_wx_set_enc_ext(struct net_device *dev,
-										struct iw_request_info *info,
-										union iwreq_data *wrqu, char *extra)
+				struct iw_request_info *info,
+				union iwreq_data *wrqu, char *extra)
  {
   	struct r8180_priv *priv = ieee80211_priv(dev);
@@ -1119,8 +1127,8 @@ static int r8180_wx_set_auth(struct net_device *dev,
  }
   static int r8180_wx_set_mlme(struct net_device *dev,
-										struct iw_request_info *info,
-										union iwreq_data *wrqu, char *extra)
+				struct iw_request_info *info,
+				union iwreq_data *wrqu, char *extra)
  {
  	int ret = 0;
  	struct r8180_priv *priv = ieee80211_priv(dev);
@@ -1150,7 +1158,8 @@ static int r8180_wx_set_gen_ie(struct net_device *dev,
   		down(&priv->wx_sem);
  #if 1
-		ret = ieee80211_wx_set_gen_ie(priv->ieee80211, extra, wrqu->data.length);
+		ret = ieee80211_wx_set_gen_ie(priv->ieee80211, extra,
+						wrqu->data.length);
  #endif
  		up(&priv->wx_sem);
  		return ret;
@@ -1351,7 +1360,7 @@ static iw_handler r8180_private_handler[] = {
  };
   static inline int is_same_network(struct ieee80211_network *src,
-									struct ieee80211_network *dst,
+				  struct ieee80211_network *dst,
  				  struct ieee80211_device *ieee)
  {
  		/* A network is only a duplicate if the channel, BSSID, ESSID
@@ -1359,10 +1368,12 @@ static inline int is_same_network(struct 
ieee80211_network *src,
  		 * We treat all <hidden> with the same BSSID and channel
  		 * as one network
  		 */
-		return (((src->ssid_len == dst->ssid_len) || (ieee->iw_mode == 
IW_MODE_INFRA)) && /* YJ,mod, 080819,for hidden ap */
+		return (((src->ssid_len == dst->ssid_len) ||
+			(ieee->iw_mode == IW_MODE_INFRA)) && /* YJ,mod, 080819,for hidden ap */
  			(src->channel == dst->channel) &&
  			!memcmp(src->bssid, dst->bssid, ETH_ALEN) &&
-			(!memcmp(src->ssid, dst->ssid, src->ssid_len) || (ieee->iw_mode == 
IW_MODE_INFRA)) &&  /* YJ,mod, 080819,for hidden ap */
+			(!memcmp(src->ssid, dst->ssid, src->ssid_len) ||
+			(ieee->iw_mode == IW_MODE_INFRA)) &&  /* YJ,mod, 080819,for hidden ap */
  			((src->capability & WLAN_CAPABILITY_IBSS) ==
  			(dst->capability & WLAN_CAPABILITY_IBSS)) &&
  			((src->capability & WLAN_CAPABILITY_BSS) ==
@@ -1373,8 +1384,8 @@ static inline int is_same_network(struct 
ieee80211_network *src,
  static struct iw_statistics *r8180_get_wireless_stats(struct 
net_device *dev)
  {
  	struct r8180_priv *priv = ieee80211_priv(dev);
-	struct ieee80211_device* ieee = priv->ieee80211;
-	struct iw_statistics* wstats = &priv->wstats;
+	struct ieee80211_device *ieee = priv->ieee80211;
+	struct iw_statistics *wstats = &priv->wstats;
  	int tmp_level = 0;
  	int tmp_qual = 0;
  	int tmp_noise = 0;
-- 
1.7.1

