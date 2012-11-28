Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab2K1NVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:21:00 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42785 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab2K1NU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:20:58 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 7/8] staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_rx.c
Date: Wed, 28 Nov 2012 22:20:53 +0900
Message-Id: <1354108853-17762-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354108550-17553-1-git-send-email-yamanetoshi@gmail.com>
References: <1354108550-17553-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings fixed.
- WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |   47 +++++++++-----------
 1 file changed, 20 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
index f14901d..7534d20 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -505,13 +505,11 @@ int ieee80211_rtl_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 
 //YJ,add,080828,for keep alive
 	if ((fc & IEEE80211_FCTL_TODS) != IEEE80211_FCTL_TODS) {
-		if (!memcmp(hdr->addr1, dev->dev_addr, ETH_ALEN)) {
+		if (!memcmp(hdr->addr1, dev->dev_addr, ETH_ALEN))
 			ieee->NumRxUnicast++;
-		}
 	} else {
-		if (!memcmp(hdr->addr3, dev->dev_addr, ETH_ALEN)) {
+		if (!memcmp(hdr->addr3, dev->dev_addr, ETH_ALEN))
 			ieee->NumRxUnicast++;
-		}
 	}
 //YJ,add,080828,for keep alive,end
 
@@ -611,9 +609,8 @@ int ieee80211_rtl_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 				type, stype, skb->len);
 		goto rx_dropped;
 	}
-	if (memcmp(bssid, ieee->current_network.bssid, ETH_ALEN)) {
+	if (memcmp(bssid, ieee->current_network.bssid, ETH_ALEN))
 		goto rx_dropped;
-	}
 
 	ieee->NumRxDataInPeriod++;
 	ieee->NumRxOkTotal++;
@@ -806,27 +803,27 @@ static inline int ieee80211_SignalStrengthTranslate(
 	int RetSS;
 
 	// Step 1. Scale mapping.
-	if (CurrSS >= 71 && CurrSS <= 100) {
+	if (CurrSS >= 71 && CurrSS <= 100)
 		RetSS = 90 + ((CurrSS - 70) / 3);
-	} else if (CurrSS >= 41 && CurrSS <= 70) {
+	else if (CurrSS >= 41 && CurrSS <= 70)
 		RetSS = 78 + ((CurrSS - 40) / 3);
-	} else if (CurrSS >= 31 && CurrSS <= 40) {
+	else if (CurrSS >= 31 && CurrSS <= 40)
 		RetSS = 66 + (CurrSS - 30);
-	} else if (CurrSS >= 21 && CurrSS <= 30) {
+	else if (CurrSS >= 21 && CurrSS <= 30)
 		RetSS = 54 + (CurrSS - 20);
-	} else if (CurrSS >= 5 && CurrSS <= 20) {
+	else if (CurrSS >= 5 && CurrSS <= 20)
 		RetSS = 42 + (((CurrSS - 5) * 2) / 3);
-	} else if (CurrSS == 4) {
+	else if (CurrSS == 4)
 		RetSS = 36;
-	} else if (CurrSS == 3) {
+	else if (CurrSS == 3)
 		RetSS = 27;
-	} else if (CurrSS == 2) {
+	else if (CurrSS == 2)
 		RetSS = 18;
-	} else if (CurrSS == 1) {
+	else if (CurrSS == 1)
 		RetSS = 9;
-	} else {
+	else
 		RetSS = CurrSS;
-	}
+
 	//RT_TRACE(COMP_DBG, DBG_LOUD, ("##### After Mapping:  LastSS: %d, CurrSS: %d, RetSS: %d\n", LastSS, CurrSS, RetSS));
 
 	// Step 2. Smoothing.
@@ -848,9 +845,8 @@ static inline void ieee80211_extract_country_ie(
 			memcpy(network->CountryIeBuf, info_element->data, info_element->len);
 			network->CountryIeLen = info_element->len;
 
-			if (!IS_COUNTRY_IE_VALID(ieee)) {
+			if (!IS_COUNTRY_IE_VALID(ieee))
 				Dot11d_UpdateCountryIe(ieee, addr2, info_element->len, info_element->data);
-			}
 		}
 
 		//
@@ -858,9 +854,8 @@ static inline void ieee80211_extract_country_ie(
 		// some AP (e.g. Cisco 1242) don't include country IE in their
 		// probe response frame.
 		//
-		if (IS_EQUAL_CIE_SRC(ieee, addr2)) {
+		if (IS_EQUAL_CIE_SRC(ieee, addr2))
 			UPDATE_CIE_WATCHDOG(ieee);
-		}
 	}
 
 }
@@ -1058,9 +1053,9 @@ inline int ieee80211_network_init(
 			//	info_element->data[3+offset] ,
 			//	info_element->data[3+offset] & (1<<(ieee->assoc_id%8)));
 
-			if (info_element->data[3+offset] & (1<<(ieee->assoc_id%8))) {
+			if (info_element->data[3+offset] & (1<<(ieee->assoc_id%8)))
 				network->dtim_data |= IEEE80211_DTIM_UCAST;
-			}
+
 			break;
 
 		case MFIE_TYPE_IBSS_SET:
@@ -1094,9 +1089,8 @@ inline int ieee80211_network_init(
 			    info_element->data[4] == 0x02) {
 				network->Turbo_Enable = 1;
 			}
-			if (1 == stats->nic_type) {//nic 87
+			if (1 == stats->nic_type) //nic 87
 				break;
-			}
 
 			if (info_element->len >= 5  &&
 			    info_element->data[0] == 0x00 &&
@@ -1210,9 +1204,8 @@ inline void update_network(struct ieee80211_network *dst,
 	unsigned char quality = src->stats.signalstrength;
 	unsigned char signal = 0;
 	unsigned char noise = 0;
-        if (dst->stats.signalstrength > 0) {
+        if (dst->stats.signalstrength > 0)
                 quality = (dst->stats.signalstrength * 5 + src->stats.signalstrength + 5)/6;
-        }
 	signal = ieee80211_TranslateToDbm(quality);
 	//noise = signal - src->stats.noise;
 	if (dst->stats.noise > 0)
-- 
1.7.9.5

