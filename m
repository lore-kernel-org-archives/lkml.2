Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab2K1NUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:20:23 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:61055 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab2K1NUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:20:18 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 4/8] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_rx.c
Date: Wed, 28 Nov 2012 22:20:13 +0900
Message-Id: <1354108813-17660-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354108550-17553-1-git-send-email-yamanetoshi@gmail.com>
References: <1354108550-17553-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings fixed.
- ERROR: space required before the open parenthesis '('
- ERROR: that open brace { should be on the previous line
- ERROR: space required before the open brace '{'
- ERROR: else should follow close brace '}'
- ERROR: space prohibited before that close parenthesis ')'

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |  151 +++++++-------------
 1 file changed, 54 insertions(+), 97 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
index 64f3c02..fb4b406 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -174,7 +174,7 @@ static int ieee80211_frag_cache_invalidate(struct ieee80211_device *ieee,
 	struct ieee80211_hdr_4addrqos *hdr_4addrqos;
 	u8 tid;
 
-	if(((fc & IEEE80211_FCTL_DSTODS) == IEEE80211_FCTL_DSTODS) && IEEE80211_QOS_HAS_SEQ(fc)) {
+	if (((fc & IEEE80211_FCTL_DSTODS) == IEEE80211_FCTL_DSTODS) && IEEE80211_QOS_HAS_SEQ(fc)) {
 		hdr_4addrqos = (struct ieee80211_hdr_4addrqos *)hdr;
 		tid = le16_to_cpu(hdr_4addrqos->qos_ctl) & IEEE80211_QOS_TID;
 		tid = UP2AC(tid);
@@ -227,7 +227,7 @@ ieee80211_rx_frame_mgmt(struct ieee80211_device *ieee, struct sk_buff *skb,
 	ieee80211_rx_mgt(ieee, (struct ieee80211_hdr_4addr *)skb->data,
 			 rx_stats);
 
-	if((ieee->state == IEEE80211_LINKED) && (memcmp(hdr->addr3, ieee->current_network.bssid, ETH_ALEN))) {
+	if ((ieee->state == IEEE80211_LINKED) && (memcmp(hdr->addr3, ieee->current_network.bssid, ETH_ALEN))) {
 		dev_kfree_skb_any(skb);
 		return 0;
 	}
@@ -244,11 +244,9 @@ ieee80211_rx_frame_mgmt(struct ieee80211_device *ieee, struct sk_buff *skb,
 
 /* See IEEE 802.1H for LLC/SNAP encapsulation/decapsulation */
 /* Ethernet-II snap header (RFC1042 for most EtherTypes) */
-static unsigned char rfc1042_header[] =
-{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
+static unsigned char rfc1042_header[] = { 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
 /* Bridge-Tunnel header (for EtherTypes ETH_P_AARP and ETH_P_IPX) */
-static unsigned char bridge_tunnel_header[] =
-{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
+static unsigned char bridge_tunnel_header[] = { 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
 /* No encapsulation header if EtherType < 0x600 (=length) */
 
 /* Called by ieee80211_rx_frame_decrypt */
@@ -381,12 +379,12 @@ static int is_duplicate_packet(struct ieee80211_device *ieee,
 	u8 tid;
 
 	//TO2DS and QoS
-	if(((fc & IEEE80211_FCTL_DSTODS) == IEEE80211_FCTL_DSTODS) && IEEE80211_QOS_HAS_SEQ(fc)) {
+	if (((fc & IEEE80211_FCTL_DSTODS) == IEEE80211_FCTL_DSTODS) && IEEE80211_QOS_HAS_SEQ(fc)) {
 		hdr_4addrqos = (struct ieee80211_hdr_4addrqos *)header;
 		tid = le16_to_cpu(hdr_4addrqos->qos_ctl) & IEEE80211_QOS_TID;
 		tid = UP2AC(tid);
 		tid++;
-	} else if(IEEE80211_QOS_HAS_SEQ(fc)) { //QoS
+	} else if (IEEE80211_QOS_HAS_SEQ(fc)) { //QoS
 		hdr_3addrqos = (struct ieee80211_hdr_3addrqos *)header;
 		tid = le16_to_cpu(hdr_3addrqos->qos_ctl) & IEEE80211_QOS_TID;
 		tid = UP2AC(tid);
@@ -442,7 +440,7 @@ static int is_duplicate_packet(struct ieee80211_device *ieee,
 //	}
 	if ((*last_seq == seq) &&
 	    time_after(*last_time + IEEE_PACKET_RETRY_TIME, jiffies)) {
-		if (*last_frag == frag){
+		if (*last_frag == frag) {
 			//printk(KERN_WARNING "[1] go drop!\n");
 			goto drop;
 
@@ -506,17 +504,12 @@ int ieee80211_rtl_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 	frag = WLAN_GET_SEQ_FRAG(sc);
 
 //YJ,add,080828,for keep alive
-	if((fc & IEEE80211_FCTL_TODS) != IEEE80211_FCTL_TODS)
-	{
-		if(!memcmp(hdr->addr1, dev->dev_addr, ETH_ALEN))
-		{
+	if ((fc & IEEE80211_FCTL_TODS) != IEEE80211_FCTL_TODS) {
+		if (!memcmp(hdr->addr1, dev->dev_addr, ETH_ALEN)) {
 			ieee->NumRxUnicast++;
 		}
-	}
-	else
-	{
-		if(!memcmp(hdr->addr3, dev->dev_addr, ETH_ALEN))
-		{
+	} else {
+		if (!memcmp(hdr->addr3, dev->dev_addr, ETH_ALEN)) {
 			ieee->NumRxUnicast++;
 		}
 	}
@@ -618,7 +611,7 @@ int ieee80211_rtl_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 				type, stype, skb->len);
 		goto rx_dropped;
 	}
-	if(memcmp(bssid, ieee->current_network.bssid, ETH_ALEN)) {
+	if (memcmp(bssid, ieee->current_network.bssid, ETH_ALEN)) {
 		goto rx_dropped;
 	}
 
@@ -814,44 +807,25 @@ static inline int ieee80211_SignalStrengthTranslate(
 	int RetSS;
 
 	// Step 1. Scale mapping.
-	if(CurrSS >= 71 && CurrSS <= 100)
-	{
+	if (CurrSS >= 71 && CurrSS <= 100) {
 		RetSS = 90 + ((CurrSS - 70) / 3);
-	}
-	else if(CurrSS >= 41 && CurrSS <= 70)
-	{
+	} else if (CurrSS >= 41 && CurrSS <= 70) {
 		RetSS = 78 + ((CurrSS - 40) / 3);
-	}
-	else if(CurrSS >= 31 && CurrSS <= 40)
-	{
+	} else if (CurrSS >= 31 && CurrSS <= 40) {
 		RetSS = 66 + (CurrSS - 30);
-	}
-	else if(CurrSS >= 21 && CurrSS <= 30)
-	{
+	} else if (CurrSS >= 21 && CurrSS <= 30) {
 		RetSS = 54 + (CurrSS - 20);
-	}
-	else if(CurrSS >= 5 && CurrSS <= 20)
-	{
+	} else if (CurrSS >= 5 && CurrSS <= 20) {
 		RetSS = 42 + (((CurrSS - 5) * 2) / 3);
-	}
-	else if(CurrSS == 4)
-	{
+	} else if (CurrSS == 4) {
 		RetSS = 36;
-	}
-	else if(CurrSS == 3)
-	{
+	} else if (CurrSS == 3) {
 		RetSS = 27;
-	}
-	else if(CurrSS == 2)
-	{
+	} else if (CurrSS == 2) {
 		RetSS = 18;
-	}
-	else if(CurrSS == 1)
-	{
+	} else if (CurrSS == 1) {
 		RetSS = 9;
-	}
-	else
-	{
+	} else {
 		RetSS = CurrSS;
 	}
 	//RT_TRACE(COMP_DBG, DBG_LOUD, ("##### After Mapping:  LastSS: %d, CurrSS: %d, RetSS: %d\n", LastSS, CurrSS, RetSS));
@@ -870,15 +844,12 @@ static inline void ieee80211_extract_country_ie(
 	u8 * addr2
 )
 {
-	if(IS_DOT11D_ENABLE(ieee))
-	{
-		if(info_element->len != 0)
-		{
+	if (IS_DOT11D_ENABLE(ieee)) {
+		if (info_element->len != 0) {
 			memcpy(network->CountryIeBuf, info_element->data, info_element->len);
 			network->CountryIeLen = info_element->len;
 
-			if(!IS_COUNTRY_IE_VALID(ieee))
-			{
+			if (!IS_COUNTRY_IE_VALID(ieee)) {
 				Dot11d_UpdateCountryIe(ieee, addr2, info_element->len, info_element->data);
 			}
 		}
@@ -888,8 +859,7 @@ static inline void ieee80211_extract_country_ie(
 		// some AP (e.g. Cisco 1242) don't include country IE in their
 		// probe response frame.
 		//
-		if(IS_EQUAL_CIE_SRC(ieee, addr2) )
-		{
+		if (IS_EQUAL_CIE_SRC(ieee, addr2)) {
 			UPDATE_CIE_WATCHDOG(ieee);
 		}
 	}
@@ -993,7 +963,7 @@ inline int ieee80211_network_init(
 			for (i = 0; i < network->rates_len; i++) {
 				network->rates[i] = info_element->data[i];
 				curRate = network->rates[i] & 0x7f;
-				if( hOpRate < curRate )
+				if (hOpRate < curRate)
 					hOpRate = curRate;
 #ifdef CONFIG_IEEE80211_DEBUG
 				p += snprintf(p, sizeof(rates_str) - (p - rates_str), "%02X ", network->rates[i]);
@@ -1019,7 +989,7 @@ inline int ieee80211_network_init(
 			for (i = 0; i < network->rates_ex_len; i++) {
 				network->rates_ex[i] = info_element->data[i];
 				curRate_ex = network->rates_ex[i] & 0x7f;
-				if( hOpRate < curRate_ex )
+				if (hOpRate < curRate_ex)
 					hOpRate = curRate_ex;
 #ifdef CONFIG_IEEE80211_DEBUG
 				p += snprintf(p, sizeof(rates_str) - (p - rates_str), "%02X ", network->rates[i]);
@@ -1054,12 +1024,12 @@ inline int ieee80211_network_init(
 
 		case MFIE_TYPE_TIM:
 
-			if(info_element->len < 4)
+			if (info_element->len < 4)
 				break;
 
 			network->dtim_period = info_element->data[1];
 
-			if(ieee->state != IEEE80211_LINKED)
+			if (ieee->state != IEEE80211_LINKED)
 				break;
 
 			network->last_dtim_sta_time[0] = jiffies;
@@ -1067,10 +1037,10 @@ inline int ieee80211_network_init(
 
 			network->dtim_data = IEEE80211_DTIM_VALID;
 
-			if(info_element->data[0] != 0)
+			if (info_element->data[0] != 0)
 				break;
 
-			if(info_element->data[2] & 1)
+			if (info_element->data[2] & 1)
 				network->dtim_data |= IEEE80211_DTIM_MBCAST;
 
 			offset = (info_element->data[2] >> 1)*2;
@@ -1078,7 +1048,7 @@ inline int ieee80211_network_init(
 			//printk("offset1:%x aid:%x\n",offset, ieee->assoc_id);
 
 			/* add and modified for ps 2008.1.22 */
-			if(ieee->assoc_id < 8*offset ||
+			if (ieee->assoc_id < 8*offset ||
 				ieee->assoc_id > 8*(offset + info_element->len - 3)) {
 				break;
 			}
@@ -1089,7 +1059,7 @@ inline int ieee80211_network_init(
 			//	info_element->data[3+offset] ,
 			//	info_element->data[3+offset] & (1<<(ieee->assoc_id%8)));
 
-			if(info_element->data[3+offset] & (1<<(ieee->assoc_id%8))) {
+			if (info_element->data[3+offset] & (1<<(ieee->assoc_id%8))) {
 				network->dtim_data |= IEEE80211_DTIM_UCAST;
 			}
 			break;
@@ -1241,12 +1211,12 @@ inline void update_network(struct ieee80211_network *dst,
 	unsigned char quality = src->stats.signalstrength;
 	unsigned char signal = 0;
 	unsigned char noise = 0;
-        if(dst->stats.signalstrength > 0) {
+        if (dst->stats.signalstrength > 0) {
                 quality = (dst->stats.signalstrength * 5 + src->stats.signalstrength + 5)/6;
         }
 	signal = ieee80211_TranslateToDbm(quality);
 	//noise = signal - src->stats.noise;
-	if(dst->stats.noise > 0)
+	if (dst->stats.noise > 0)
 		noise = (dst->stats.noise * 5 + src->stats.noise)/6;
         //if(strcmp(dst->ssid, "linksys_lzm000") == 0)
 //	printk("ssid:%s, quality:%d, signal:%d\n", dst->ssid, quality, signal);
@@ -1266,8 +1236,7 @@ inline void update_network(struct ieee80211_network *dst,
 	//printk("==========>in %s: src->ssid is %s,chan is %d\n",__func__,src->ssid,src->channel);
 
 	//YJ,add,080819,for hidden ap
-	if(src->ssid_len > 0)
-	{
+	if (src->ssid_len > 0) {
 		//if(src->ssid_len == 13)
 		//	printk("=====================>>>>>>>> Dst ssid: %s Src ssid: %s\n", dst->ssid, src->ssid);
 		memset(dst->ssid, 0, dst->ssid_len);
@@ -1305,7 +1274,7 @@ inline void update_network(struct ieee80211_network *dst,
 	  memcpy(dst->wmm_param, src->wmm_param, IEEE80211_AC_PRAM_LEN);
 	}
 */
-	if(src->wmm_param[0].ac_aci_acm_aifsn || \
+	if (src->wmm_param[0].ac_aci_acm_aifsn || \
 	   src->wmm_param[1].ac_aci_acm_aifsn || \
 	   src->wmm_param[2].ac_aci_acm_aifsn || \
 	   src->wmm_param[3].ac_aci_acm_aifsn) {
@@ -1378,47 +1347,35 @@ inline void ieee80211_process_probe_response(
 	// (2)  If there is no any country code in beacon,
 	//       then wireless adapter should do active scan from ch1~11 and
 	//       passive scan from ch12~14
-	if(ieee->bGlobalDomain)
-	{
-		if (WLAN_FC_GET_STYPE(beacon->header.frame_ctl) == IEEE80211_STYPE_PROBE_RESP)
-		{
+	if (ieee->bGlobalDomain) {
+		if (WLAN_FC_GET_STYPE(beacon->header.frame_ctl) == IEEE80211_STYPE_PROBE_RESP) {
 			// Case 1: Country code
-			if(IS_COUNTRY_IE_VALID(ieee) )
-			{
-				if( !IsLegalChannel(ieee, network.channel) )
-				{
+			if (IS_COUNTRY_IE_VALID(ieee)) {
+				if (!IsLegalChannel(ieee, network.channel)) {
 					printk("GetScanInfo(): For Country code, filter probe response at channel(%d).\n", network.channel);
 					return;
 				}
 			}
 			// Case 2: No any country code.
-			else
-			{
+			else {
 				// Filter over channel ch12~14
-				if(network.channel > 11)
-				{
+				if (network.channel > 11) {
 					printk("GetScanInfo(): For Global Domain, filter probe response at channel(%d).\n", network.channel);
 					return;
 				}
 			}
-		}
-		else
-		{
+		} else {
 			// Case 1: Country code
-			if(IS_COUNTRY_IE_VALID(ieee) )
-			{
-				if( !IsLegalChannel(ieee, network.channel) )
-				{
+			if (IS_COUNTRY_IE_VALID(ieee)) {
+				if (!IsLegalChannel(ieee, network.channel)) {
 					printk("GetScanInfo(): For Country code, filter beacon at channel(%d).\n", network.channel);
 					return;
 				}
 			}
 			// Case 2: No any country code.
-			else
-			{
+			else {
 				// Filter over channel ch12~14
-				if(network.channel > 14)
-				{
+				if (network.channel > 14) {
 					printk("GetScanInfo(): For Global Domain, filter beacon at channel(%d).\n", network.channel);
 					return;
 				}
@@ -1437,12 +1394,12 @@ inline void ieee80211_process_probe_response(
 
 	spin_lock_irqsave(&ieee->lock, flags);
 
-	if(is_same_network(&ieee->current_network, &network, ieee)) {
+	if (is_same_network(&ieee->current_network, &network, ieee)) {
 		wmm_info = ieee->current_network.wmm_info;
 		//YJ,add,080819,for hidden ap
-		if(is_beacon == 0)
+		if (is_beacon == 0)
 			network.flags = (~NETWORK_EMPTY_ESSID & network.flags)|(NETWORK_EMPTY_ESSID & ieee->current_network.flags);
-		else if(ieee->state == IEEE80211_LINKED)
+		else if (ieee->state == IEEE80211_LINKED)
 			ieee->NumRxBcnInPeriod++;
 		//YJ,add,080819,for hidden ap,end
 		//printk("====>network.ssid=%s cur_ssid=%s\n", network.ssid, ieee->current_network.ssid);
@@ -1504,11 +1461,11 @@ inline void ieee80211_process_probe_response(
 		 */
 		renew = !time_after(target->last_scanned + ieee->scan_age, jiffies);
 		//YJ,add,080819,for hidden ap
-		if(is_beacon == 0)
+		if (is_beacon == 0)
 			network.flags = (~NETWORK_EMPTY_ESSID & network.flags)|(NETWORK_EMPTY_ESSID & target->flags);
 		//if(strncmp(network.ssid, "linksys-c",9) == 0)
 		//	printk("====>2 network.ssid=%s FLAG=%d target.ssid=%s FLAG=%d\n", network.ssid, network.flags, target->ssid, target->flags);
-		if(((network.flags & NETWORK_EMPTY_ESSID) == NETWORK_EMPTY_ESSID) \
+		if (((network.flags & NETWORK_EMPTY_ESSID) == NETWORK_EMPTY_ESSID) \
 		    && (((network.ssid_len > 0) && (strncmp(target->ssid, network.ssid, network.ssid_len)))\
 		    || ((ieee->current_network.ssid_len == network.ssid_len) && (strncmp(ieee->current_network.ssid, network.ssid, network.ssid_len) == 0) && (ieee->state == IEEE80211_NOLINK))))
 			renew = 1;
-- 
1.7.9.5

