Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab2K1NUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:20:07 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44112 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab2K1NUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:20:05 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 3/8] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_rx.c
Date: Wed, 28 Nov 2012 22:19:59 +0900
Message-Id: <1354108799-17626-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354108550-17553-1-git-send-email-yamanetoshi@gmail.com>
References: <1354108550-17553-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings fixed.
-- ERROR: space required after that ',' (ctx:VxV)
-- ERROR: spaces required around that '&&' (ctx:VxV)
-- ERROR: space prohibited before that '++' (ctx:WxO)
-- ERROR: spaces required around that '?' (ctx:VxV)
-- ERROR: spaces required around that ':' (ctx:VxV)
-- ERROR: spaces required around that '!=' (ctx:VxW)
-- ERROR: need consistent spacing around '-' (ctx:WxV)
-- ERROR: spaces required around that '=' (ctx:VxW)
-- ERROR: spaces required around that '||' (ctx:ExV)

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |   64 ++++++++++----------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
index c932e31..64f3c02 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -65,7 +65,7 @@ static inline void ieee80211_monitor_rx(struct ieee80211_device *ieee,
 /* Called only as a tasklet (software IRQ) */
 static struct ieee80211_frag_entry *
 ieee80211_frag_cache_find(struct ieee80211_device *ieee, unsigned int seq,
-			  unsigned int frag, u8 tid,u8 *src, u8 *dst)
+			  unsigned int frag, u8 tid, u8 *src, u8 *dst)
 {
 	struct ieee80211_frag_entry *entry;
 	int i;
@@ -107,16 +107,16 @@ ieee80211_frag_cache_get(struct ieee80211_device *ieee,
 	struct ieee80211_hdr_4addrqos *hdr_4addrqos;
 	u8 tid;
 
-	if (((fc & IEEE80211_FCTL_DSTODS) == IEEE80211_FCTL_DSTODS)&&IEEE80211_QOS_HAS_SEQ(fc)) {
+	if (((fc & IEEE80211_FCTL_DSTODS) == IEEE80211_FCTL_DSTODS) && IEEE80211_QOS_HAS_SEQ(fc)) {
 		hdr_4addrqos = (struct ieee80211_hdr_4addrqos *)hdr;
 		tid = le16_to_cpu(hdr_4addrqos->qos_ctl) & IEEE80211_QOS_TID;
 		tid = UP2AC(tid);
-		tid ++;
+		tid++;
 	} else if (IEEE80211_QOS_HAS_SEQ(fc)) {
 		hdr_3addrqos = (struct ieee80211_hdr_3addrqos *)hdr;
 		tid = le16_to_cpu(hdr_3addrqos->qos_ctl) & IEEE80211_QOS_TID;
 		tid = UP2AC(tid);
-		tid ++;
+		tid++;
 	} else {
 		tid = 0;
 	}
@@ -129,7 +129,7 @@ ieee80211_frag_cache_get(struct ieee80211_device *ieee,
 				    2 /* alignment */ +
 				    8 /* WEP */ +
 				    ETH_ALEN /* WDS */ +
-				    (IEEE80211_QOS_HAS_SEQ(fc)?2:0) /* QOS Control */);
+				    (IEEE80211_QOS_HAS_SEQ(fc) ? 2 : 0) /* QOS Control */);
 		if (skb == NULL)
 			return NULL;
 
@@ -150,7 +150,7 @@ ieee80211_frag_cache_get(struct ieee80211_device *ieee,
 	} else {
 		/* received a fragment of a frame for which the head fragment
 		 * should have already been received */
-		entry = ieee80211_frag_cache_find(ieee, seq, frag, tid,hdr->addr2,
+		entry = ieee80211_frag_cache_find(ieee, seq, frag, tid, hdr->addr2,
 						  hdr->addr1);
 		if (entry != NULL) {
 			entry->last_frag = frag;
@@ -174,21 +174,21 @@ static int ieee80211_frag_cache_invalidate(struct ieee80211_device *ieee,
 	struct ieee80211_hdr_4addrqos *hdr_4addrqos;
 	u8 tid;
 
-	if(((fc & IEEE80211_FCTL_DSTODS) == IEEE80211_FCTL_DSTODS)&&IEEE80211_QOS_HAS_SEQ(fc)) {
+	if(((fc & IEEE80211_FCTL_DSTODS) == IEEE80211_FCTL_DSTODS) && IEEE80211_QOS_HAS_SEQ(fc)) {
 		hdr_4addrqos = (struct ieee80211_hdr_4addrqos *)hdr;
 		tid = le16_to_cpu(hdr_4addrqos->qos_ctl) & IEEE80211_QOS_TID;
 		tid = UP2AC(tid);
-		tid ++;
+		tid++;
 	} else if (IEEE80211_QOS_HAS_SEQ(fc)) {
 		hdr_3addrqos = (struct ieee80211_hdr_3addrqos *)hdr;
 		tid = le16_to_cpu(hdr_3addrqos->qos_ctl) & IEEE80211_QOS_TID;
 		tid = UP2AC(tid);
-		tid ++;
+		tid++;
 	} else {
 		tid = 0;
 	}
 
-	entry = ieee80211_frag_cache_find(ieee, seq, -1, tid,hdr->addr2,
+	entry = ieee80211_frag_cache_find(ieee, seq, -1, tid, hdr->addr2,
 					  hdr->addr1);
 
 	if (entry == NULL) {
@@ -227,7 +227,7 @@ ieee80211_rx_frame_mgmt(struct ieee80211_device *ieee, struct sk_buff *skb,
 	ieee80211_rx_mgt(ieee, (struct ieee80211_hdr_4addr *)skb->data,
 			 rx_stats);
 
-	if((ieee->state == IEEE80211_LINKED)&&(memcmp(hdr->addr3,ieee->current_network.bssid,ETH_ALEN))) {
+	if((ieee->state == IEEE80211_LINKED) && (memcmp(hdr->addr3, ieee->current_network.bssid, ETH_ALEN))) {
 		dev_kfree_skb_any(skb);
 		return 0;
 	}
@@ -381,16 +381,16 @@ static int is_duplicate_packet(struct ieee80211_device *ieee,
 	u8 tid;
 
 	//TO2DS and QoS
-	if(((fc & IEEE80211_FCTL_DSTODS) == IEEE80211_FCTL_DSTODS)&&IEEE80211_QOS_HAS_SEQ(fc)) {
+	if(((fc & IEEE80211_FCTL_DSTODS) == IEEE80211_FCTL_DSTODS) && IEEE80211_QOS_HAS_SEQ(fc)) {
 		hdr_4addrqos = (struct ieee80211_hdr_4addrqos *)header;
 		tid = le16_to_cpu(hdr_4addrqos->qos_ctl) & IEEE80211_QOS_TID;
 		tid = UP2AC(tid);
-		tid ++;
+		tid++;
 	} else if(IEEE80211_QOS_HAS_SEQ(fc)) { //QoS
 		hdr_3addrqos = (struct ieee80211_hdr_3addrqos *)header;
 		tid = le16_to_cpu(hdr_3addrqos->qos_ctl) & IEEE80211_QOS_TID;
 		tid = UP2AC(tid);
-		tid ++;
+		tid++;
 	} else { // no QoS
 		tid = 0;
 	}
@@ -508,7 +508,7 @@ int ieee80211_rtl_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 //YJ,add,080828,for keep alive
 	if((fc & IEEE80211_FCTL_TODS) != IEEE80211_FCTL_TODS)
 	{
-		if(!memcmp(hdr->addr1,dev->dev_addr, ETH_ALEN))
+		if(!memcmp(hdr->addr1, dev->dev_addr, ETH_ALEN))
 		{
 			ieee->NumRxUnicast++;
 		}
@@ -577,12 +577,12 @@ int ieee80211_rtl_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 	case IEEE80211_FCTL_FROMDS:
 		memcpy(dst, hdr->addr1, ETH_ALEN);
 		memcpy(src, hdr->addr3, ETH_ALEN);
-		memcpy(bssid,hdr->addr2,ETH_ALEN);
+		memcpy(bssid, hdr->addr2, ETH_ALEN);
 		break;
 	case IEEE80211_FCTL_TODS:
 		memcpy(dst, hdr->addr3, ETH_ALEN);
 		memcpy(src, hdr->addr2, ETH_ALEN);
-		memcpy(bssid,hdr->addr1,ETH_ALEN);
+		memcpy(bssid, hdr->addr1, ETH_ALEN);
 		break;
 	case IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS:
 		if (skb->len < IEEE80211_DATA_HDR4_LEN)
@@ -594,7 +594,7 @@ int ieee80211_rtl_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 	case 0:
 		memcpy(dst, hdr->addr1, ETH_ALEN);
 		memcpy(src, hdr->addr2, ETH_ALEN);
-		memcpy(bssid,hdr->addr3,ETH_ALEN);
+		memcpy(bssid, hdr->addr3, ETH_ALEN);
 		break;
 	}
 
@@ -607,7 +607,7 @@ int ieee80211_rtl_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 	if (stype != IEEE80211_STYPE_DATA &&
 	    stype != IEEE80211_STYPE_DATA_CFACK &&
 	    stype != IEEE80211_STYPE_DATA_CFPOLL &&
-	    stype != IEEE80211_STYPE_DATA_CFACKPOLL&&
+	    stype != IEEE80211_STYPE_DATA_CFACKPOLL &&
 	    stype != IEEE80211_STYPE_QOS_DATA//add by David,2006.8.4
 	    ) {
 		if (stype != IEEE80211_STYPE_NULLFUNC)
@@ -618,7 +618,7 @@ int ieee80211_rtl_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 				type, stype, skb->len);
 		goto rx_dropped;
 	}
-	if(memcmp(bssid,ieee->current_network.bssid,ETH_ALEN)) {
+	if(memcmp(bssid, ieee->current_network.bssid, ETH_ALEN)) {
 		goto rx_dropped;
 	}
 
@@ -872,7 +872,7 @@ static inline void ieee80211_extract_country_ie(
 {
 	if(IS_DOT11D_ENABLE(ieee))
 	{
-		if(info_element->len!= 0)
+		if(info_element->len != 0)
 		{
 			memcpy(network->CountryIeBuf, info_element->data, info_element->len);
 			network->CountryIeLen = info_element->len;
@@ -923,7 +923,7 @@ inline int ieee80211_network_init(
  	u16 left;
 	u8 i;
 	short offset;
-	u8 curRate = 0,hOpRate = 0,curRate_ex = 0;
+	u8 curRate = 0, hOpRate = 0, curRate_ex = 0;
 
 	/* Pull out fixed field data */
 	memcpy(network->bssid, beacon->header.addr3, ETH_ALEN);
@@ -1079,7 +1079,7 @@ inline int ieee80211_network_init(
 
 			/* add and modified for ps 2008.1.22 */
 			if(ieee->assoc_id < 8*offset ||
-				ieee->assoc_id > 8*(offset + info_element->len -3)) {
+				ieee->assoc_id > 8*(offset + info_element->len - 3)) {
 				break;
 			}
 
@@ -1152,7 +1152,7 @@ inline int ieee80211_network_init(
 				//printk(KERN_WARNING "wmm info&param updated: %x\n", info_element->data[6]);
 				network->wmm_info = info_element->data[6];
 				//WMM Parameter Element
-				memcpy(network->wmm_param, (u8 *)(info_element->data + 8),(info_element->len - 8));
+				memcpy(network->wmm_param, (u8 *)(info_element->data + 8), (info_element->len - 8));
 				network->QoS_Enable = 1;
 			}
 			break;
@@ -1262,7 +1262,7 @@ inline void update_network(struct ieee80211_network *dst,
 	dst->rates_len = src->rates_len;
 	memcpy(dst->rates_ex, src->rates_ex, src->rates_ex_len);
 	dst->rates_ex_len = src->rates_ex_len;
-	dst->HighestOperaRate= src->HighestOperaRate;
+	dst->HighestOperaRate = src->HighestOperaRate;
 	//printk("==========>in %s: src->ssid is %s,chan is %d\n",__func__,src->ssid,src->channel);
 
 	//YJ,add,080819,for hidden ap
@@ -1305,9 +1305,9 @@ inline void update_network(struct ieee80211_network *dst,
 	  memcpy(dst->wmm_param, src->wmm_param, IEEE80211_AC_PRAM_LEN);
 	}
 */
-	if(src->wmm_param[0].ac_aci_acm_aifsn|| \
-	   src->wmm_param[1].ac_aci_acm_aifsn|| \
-	   src->wmm_param[2].ac_aci_acm_aifsn|| \
+	if(src->wmm_param[0].ac_aci_acm_aifsn || \
+	   src->wmm_param[1].ac_aci_acm_aifsn || \
+	   src->wmm_param[2].ac_aci_acm_aifsn || \
 	   src->wmm_param[3].ac_aci_acm_aifsn) {
 		memcpy(dst->wmm_param, src->wmm_param, WME_AC_PRAM_LEN);
 	}
@@ -1336,7 +1336,7 @@ inline void ieee80211_process_probe_response(
 	unsigned long flags;
 	short renew;
 	u8 wmm_info;
-	u8 is_beacon = (WLAN_FC_GET_STYPE(beacon->header.frame_ctl) == IEEE80211_STYPE_BEACON)? 1:0;  //YJ,add,080819,for hidden ap
+	u8 is_beacon = (WLAN_FC_GET_STYPE(beacon->header.frame_ctl) == IEEE80211_STYPE_BEACON) ? 1 : 0;  //YJ,add,080819,for hidden ap
 
 	memset(&network, 0, sizeof(struct ieee80211_network));
 
@@ -1409,7 +1409,7 @@ inline void ieee80211_process_probe_response(
 			{
 				if( !IsLegalChannel(ieee, network.channel) )
 				{
-					printk("GetScanInfo(): For Country code, filter beacon at channel(%d).\n",network.channel);
+					printk("GetScanInfo(): For Country code, filter beacon at channel(%d).\n", network.channel);
 					return;
 				}
 			}
@@ -1419,7 +1419,7 @@ inline void ieee80211_process_probe_response(
 				// Filter over channel ch12~14
 				if(network.channel > 14)
 				{
-					printk("GetScanInfo(): For Global Domain, filter beacon at channel(%d).\n",network.channel);
+					printk("GetScanInfo(): For Global Domain, filter beacon at channel(%d).\n", network.channel);
 					return;
 				}
 			}
@@ -1510,7 +1510,7 @@ inline void ieee80211_process_probe_response(
 		//	printk("====>2 network.ssid=%s FLAG=%d target.ssid=%s FLAG=%d\n", network.ssid, network.flags, target->ssid, target->flags);
 		if(((network.flags & NETWORK_EMPTY_ESSID) == NETWORK_EMPTY_ESSID) \
 		    && (((network.ssid_len > 0) && (strncmp(target->ssid, network.ssid, network.ssid_len)))\
-		    ||((ieee->current_network.ssid_len == network.ssid_len)&&(strncmp(ieee->current_network.ssid, network.ssid, network.ssid_len) == 0)&&(ieee->state == IEEE80211_NOLINK))))
+		    || ((ieee->current_network.ssid_len == network.ssid_len) && (strncmp(ieee->current_network.ssid, network.ssid, network.ssid_len) == 0) && (ieee->state == IEEE80211_NOLINK))))
 			renew = 1;
 		//YJ,add,080819,for hidden ap,end
 		update_network(target, &network);
-- 
1.7.9.5

