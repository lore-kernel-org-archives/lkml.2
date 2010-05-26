Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab0EZSdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 14:33:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42200 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757509Ab0EZSda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 14:33:30 -0400
From: Bashlykov Arthur <madness@xakep.ru>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Bashlykov Arthur <madness@xakep.ru>
Subject: [PATCH 2/2] Staging: rtl8192su: ieee80211: fix brace coding style issue and other issues in ieee80211_tx.c Signed-off-by: Bashlykov Arthur <madness@xakep.ru>
Date: Wed, 26 May 2010 22:32:55 +0400
Message-Id: <1274898775-9402-1-git-send-email-madness@xakep.ru>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c |  429 ++++++++++----------
 1 files changed, 206 insertions(+), 223 deletions(-)

diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c
index 484c3ab..1a41809 100644
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c
@@ -32,7 +32,7 @@
 ******************************************************************************/
 
 #include <linux/compiler.h>
-//#include <linux/config.h>
+/* #include <linux/config.h> */
 #include <linux/errno.h>
 #include <linux/if_arp.h>
 #include <linux/in6.h>
@@ -49,7 +49,7 @@
 #include <linux/types.h>
 #include <linux/wireless.h>
 #include <linux/etherdevice.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/if_vlan.h>
 
 #include "ieee80211.h"
@@ -70,11 +70,11 @@ val  | 0  |  0  |  0  |  1  |  x  |  0  |  0  |  0  |  1  |  0  |  x  |  x  |  x
 desc | ^-ver-^  |  ^type-^  |  ^-----subtype-----^  | to  |from |more |retry| pwr |more |wep   |
      |          |           | x=0 data,x=1 data+ack | DS  | DS  |frag |     | mgm |data |      |
      '-----------------------------------------------------------------------------------------'
-		                                    /\
-                                                    |
+						    /\
+						    |
 802.11 Data Frame                                   |
-           ,--------- 'ctrl' expands to >-----------'
-          |
+	  ,--------- 'ctrl' expands to >-----------'
+	  |
       ,--'---,-------------------------------------------------------------.
 Bytes |  2   |  2   |    6    |    6    |    6    |  2   | 0..2312 |   4  |
       |------|------|---------|---------|---------|------|---------|------|
@@ -82,7 +82,7 @@ Desc. | ctrl | dura |  DA/RA  |   TA    |    SA   | Sequ |  Frame  |  fcs |
       |      | tion | (BSSID) |         |         | ence |  data   |      |
       `--------------------------------------------------|         |------'
 Total: 28 non-data bytes                                 `----.----'
-                                                              |
+							      |
        .- 'Frame data' expands to <---------------------------'
        |
        V
@@ -94,7 +94,7 @@ Desc. | SNAP | SNAP | Control |Eth Tunnel| Type | IP      |
       | 0xAA | 0xAA |0x03 (UI)|0x00-00-F8|      |         |
       `-----------------------------------------|         |
 Total: 8 non-data bytes                         `----.----'
-                                                     |
+						     |
        .- 'IP Packet' expands, if WEP enabled, to <--'
        |
        V
@@ -183,12 +183,11 @@ int ieee80211_encrypt_fragment(
 	struct sk_buff *frag,
 	int hdr_len)
 {
-	struct ieee80211_crypt_data* crypt = ieee->crypt[ieee->tx_keyidx];
+	struct ieee80211_crypt_data *crypt = ieee->crypt[ieee->tx_keyidx];
 	int res;
 
-	if (!(crypt && crypt->ops))
-	{
-		printk("=========>%s(), crypt is null\n", __FUNCTION__);
+	if (!(crypt && crypt->ops)) {
+		printk(KERN_INFO "%s(), crypt is null\n", __func__);
 		return -1;
 	}
 #ifdef CONFIG_IEEE80211_CRYPT_TKIP
@@ -208,8 +207,10 @@ int ieee80211_encrypt_fragment(
 	/* To encrypt, frame format is:
 	 * IV (4 bytes), clear payload (including SNAP), ICV (4 bytes) */
 
-	// PR: FIXME: Copied from hostap. Check fragmentation/MSDU/MPDU encryption.
-	/* Host-based IEEE 802.11 fragmentation for TX is not yet supported, so
+	/* PR: FIXME: Copied from hostap. Check
+	 * fragmentation/MSDU/MPDU encryption. */
+	/* Host-based IEEE 802.11 fragmentation
+	 * for TX is not yet supported, so
 	 * call both MSDU and MPDU encryption functions from here. */
 	atomic_inc(&crypt->refcnt);
 	res = 0;
@@ -230,8 +231,9 @@ int ieee80211_encrypt_fragment(
 }
 
 
-void ieee80211_txb_free(struct ieee80211_txb *txb) {
-	//int i;
+void ieee80211_txb_free(struct ieee80211_txb *txb)
+{
+	/* int i; */
 	if (unlikely(!txb))
 		return;
 	kfree(txb);
@@ -243,7 +245,7 @@ struct ieee80211_txb *ieee80211_alloc_txb(int nr_frags, int txb_size,
 	struct ieee80211_txb *txb;
 	int i;
 	txb = kmalloc(
-		sizeof(struct ieee80211_txb) + (sizeof(u8*) * nr_frags),
+		sizeof(struct ieee80211_txb) + (sizeof(u8 *) * nr_frags),
 		gfp_mask);
 	if (!txb)
 		return NULL;
@@ -269,8 +271,8 @@ struct ieee80211_txb *ieee80211_alloc_txb(int nr_frags, int txb_size,
 	return txb;
 }
 
-// Classify the to-be send data packet
-// Need to acquire the sent queue index.
+/* Classify the to-be send data packet
+ * Need to acquire the sent queue index. */
 static int
 ieee80211_classify(struct sk_buff *skb, struct ieee80211_network *network)
 {
@@ -280,124 +282,112 @@ ieee80211_classify(struct sk_buff *skb, struct ieee80211_network *network)
 	if (eth->h_proto != htons(ETH_P_IP))
 		return 0;
 
-//	IEEE80211_DEBUG_DATA(IEEE80211_DL_DATA, skb->data, skb->len);
+/*	IEEE80211_DEBUG_DATA(IEEE80211_DL_DATA, skb->data, skb->len); */
 	ip = ip_hdr(skb);
 
 	switch (ip->tos & 0xfc) {
-		case 0x20:
-			return 2;
-		case 0x40:
-			return 1;
-		case 0x60:
-			return 3;
-		case 0x80:
-			return 4;
-		case 0xa0:
-			return 5;
-		case 0xc0:
-			return 6;
-		case 0xe0:
-			return 7;
-		default:
-			return 0;
+	case 0x20:
+		return 2;
+	case 0x40:
+		return 1;
+	case 0x60:
+		return 3;
+	case 0x80:
+		return 4;
+	case 0xa0:
+		return 5;
+	case 0xc0:
+		return 6;
+	case 0xe0:
+		return 7;
+	default:
+		return 0;
 	}
 }
 
-void ieee80211_tx_query_agg_cap(struct ieee80211_device* ieee, struct sk_buff* skb, cb_desc* tcb_desc)
+void ieee80211_tx_query_agg_cap(struct ieee80211_device *ieee, struct sk_buff *skb, cb_desc *tcb_desc)
 {
 	PRT_HIGH_THROUGHPUT	pHTInfo = ieee->pHTInfo;
 	PTX_TS_RECORD			pTxTs = NULL;
-	struct ieee80211_hdr_1addr* hdr = (struct ieee80211_hdr_1addr*)skb->data;
+	struct ieee80211_hdr_1addr* hdr = (struct ieee80211_hdr_1addr *)skb->data;
 
-	if (!pHTInfo->bCurrentHTSupport||!pHTInfo->bEnableHT)
+	if (!pHTInfo->bCurrentHTSupport || !pHTInfo->bEnableHT)
 		return;
 	if (!IsQoSDataFrame(skb->data))
 		return;
 
 	if (is_multicast_ether_addr(hdr->addr1) || is_broadcast_ether_addr(hdr->addr1))
 		return;
-	//check packet and mode later
+	/* check packet and mode later */
 #ifdef TO_DO_LIST
-	if(pTcb->PacketLength >= 4096)
+	if (pTcb->PacketLength >= 4096)
 		return;
-	// For RTL819X, if pairwisekey = wep/tkip, we don't aggrregation.
-	if(!Adapter->HalFunc.GetNmodeSupportBySecCfgHandler(Adapter))
+	/* For RTL819X, if pairwisekey = wep/tkip, we don't aggrregation. */
+	if (!Adapter->HalFunc.GetNmodeSupportBySecCfgHandler(Adapter))
 		return;
 #endif
 
-	if(pHTInfo->IOTAction & HT_IOT_ACT_TX_NO_AGGREGATION)
+	if (pHTInfo->IOTAction & HT_IOT_ACT_TX_NO_AGGREGATION)
 		return;
 
 #if 1
-	if(!ieee->GetNmodeSupportBySecCfg(ieee->dev))
-	{
+	if (!ieee->GetNmodeSupportBySecCfg(ieee->dev))
 		return;
-	}
 #endif
-	if(pHTInfo->bCurrentAMPDUEnable)
-	{
-		if (!GetTs(ieee, (PTS_COMMON_INFO*)(&pTxTs), hdr->addr1, skb->priority, TX_DIR, true))
-		{
-			printk("===>can't get TS\n");
+	if (pHTInfo->bCurrentAMPDUEnable) {
+		if (!GetTs(ieee, (PTS_COMMON_INFO *)(&pTxTs), hdr->addr1, skb->priority, TX_DIR, true)) {
+			printk(KERN_INFO "can't get TS\n");
 			return;
 		}
-		if (pTxTs->TxAdmittedBARecord.bValid == false)
-		{
-			//as some AP will refuse our action frame until key handshake has been finished. WB
+		if (pTxTs->TxAdmittedBARecord.bValid == false) {
+			/* as some AP will refuse our action frame
+			 * until key handshake has been finished. WB */
 			if (ieee->wpa_ie_len && (ieee->pairwise_key_type == KEY_TYPE_NA))
-			;
-			else
+				else
 			TsStartAddBaProcess(ieee, pTxTs);
 			goto FORCED_AGG_SETTING;
-		}
-		else if (pTxTs->bUsingBa == false)
-		{
+		} else if (pTxTs->bUsingBa == false) {
 			if (SN_LESS(pTxTs->TxAdmittedBARecord.BaStartSeqCtrl.field.SeqNum, (pTxTs->TxCurSeq+1)%4096))
 				pTxTs->bUsingBa = true;
 			else
 				goto FORCED_AGG_SETTING;
 		}
 
-		if (ieee->iw_mode == IW_MODE_INFRA)
-		{
+		if (ieee->iw_mode == IW_MODE_INFRA) {
 			tcb_desc->bAMPDUEnable = true;
 			tcb_desc->ampdu_factor = pHTInfo->CurrentAMPDUFactor;
 			tcb_desc->ampdu_density = pHTInfo->CurrentMPDUDensity;
 		}
 	}
 FORCED_AGG_SETTING:
-	switch(pHTInfo->ForcedAMPDUMode )
-	{
-		case HT_AGG_AUTO:
-			break;
+	switch (pHTInfo->ForcedAMPDUMode) {
+	case HT_AGG_AUTO:
+		break;
 
-		case HT_AGG_FORCE_ENABLE:
+	case HT_AGG_FORCE_ENABLE:
 			tcb_desc->bAMPDUEnable = true;
 			tcb_desc->ampdu_density = pHTInfo->ForcedMPDUDensity;
 			tcb_desc->ampdu_factor = pHTInfo->ForcedAMPDUFactor;
-			break;
+		break;
 
-		case HT_AGG_FORCE_DISABLE:
+	case HT_AGG_FORCE_DISABLE:
 			tcb_desc->bAMPDUEnable = false;
 			tcb_desc->ampdu_density = 0;
 			tcb_desc->ampdu_factor = 0;
-			break;
+		break;
 
 	}
-		return;
+	return;
 }
 
-extern void ieee80211_qurey_ShortPreambleMode(struct ieee80211_device* ieee, cb_desc* tcb_desc)
+extern void ieee80211_qurey_ShortPreambleMode(struct ieee80211_device *ieee, cb_desc *tcb_desc)
 {
 	tcb_desc->bUseShortPreamble = false;
 	if (tcb_desc->data_rate == 2)
-	{//// 1M can only use Long Preamble. 11B spec
 		return;
-	}
+	/* 1M can only use Long Preamble. 11B spec */
 	else if (ieee->current_network.capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
-	{
 		tcb_desc->bUseShortPreamble = true;
-	}
 	return;
 }
 extern	void
@@ -405,145 +395,145 @@ ieee80211_query_HTCapShortGI(struct ieee80211_device *ieee, cb_desc *tcb_desc)
 {
 	PRT_HIGH_THROUGHPUT		pHTInfo = ieee->pHTInfo;
 
-	tcb_desc->bUseShortGI 		= false;
+	tcb_desc->bUseShortGI = false;
 
-	if(!pHTInfo->bCurrentHTSupport||!pHTInfo->bEnableHT)
+	if (!pHTInfo->bCurrentHTSupport || !pHTInfo->bEnableHT)
 		return;
 
-	if(pHTInfo->bForcedShortGI)
-	{
+	if (pHTInfo->bForcedShortGI) {
 		tcb_desc->bUseShortGI = true;
 		return;
 	}
 
-	if((pHTInfo->bCurBW40MHz==true) && pHTInfo->bCurShortGI40MHz)
+	if ((pHTInfo->bCurBW40MHz == true) && pHTInfo->bCurShortGI40MHz)
 		tcb_desc->bUseShortGI = true;
-	else if((pHTInfo->bCurBW40MHz==false) && pHTInfo->bCurShortGI20MHz)
+	else if ((pHTInfo->bCurBW40MHz == false) && pHTInfo->bCurShortGI20MHz)
 		tcb_desc->bUseShortGI = true;
 }
 
-void ieee80211_query_BandwidthMode(struct ieee80211_device* ieee, cb_desc *tcb_desc)
+void ieee80211_query_BandwidthMode(struct ieee80211_device *ieee, cb_desc *tcb_desc)
 {
 	PRT_HIGH_THROUGHPUT	pHTInfo = ieee->pHTInfo;
 
 	tcb_desc->bPacketBW = false;
 
-	if(!pHTInfo->bCurrentHTSupport||!pHTInfo->bEnableHT)
+	if (!pHTInfo->bCurrentHTSupport || !pHTInfo->bEnableHT)
 		return;
 
-	if(tcb_desc->bMulticast || tcb_desc->bBroadcast)
+	if (tcb_desc->bMulticast || tcb_desc->bBroadcast)
 		return;
 
-	if((tcb_desc->data_rate & 0x80)==0) // If using legacy rate, it shall use 20MHz channel.
+	if ((tcb_desc->data_rate & 0x80) == 0) /* If using legacy rate, it shall use 20MHz channel. */
 		return;
-	//BandWidthAutoSwitch is for auto switch to 20 or 40 in long distance
-	if(pHTInfo->bCurBW40MHz && pHTInfo->bCurTxBW40MHz && !ieee->bandwidth_auto_switch.bforced_tx20Mhz)
+	/* BandWidthAutoSwitch is for auto
+	 * switch to 20 or 40 in long distance */
+	if (pHTInfo->bCurBW40MHz && pHTInfo->bCurTxBW40MHz && !ieee->bandwidth_auto_switch.bforced_tx20Mhz)
 		tcb_desc->bPacketBW = true;
 	return;
 }
 
-void ieee80211_query_protectionmode(struct ieee80211_device* ieee, cb_desc* tcb_desc, struct sk_buff* skb)
+void ieee80211_query_protectionmode(struct ieee80211_device *ieee, cb_desc *tcb_desc, struct sk_buff *skb)
 {
-	// Common Settings
+	/* Common Settings */
 	tcb_desc->bRTSSTBC			= false;
-	tcb_desc->bRTSUseShortGI		= false; // Since protection frames are always sent by legacy rate, ShortGI will never be used.
-	tcb_desc->bCTSEnable			= false; // Most of protection using RTS/CTS
-	tcb_desc->RTSSC				= 0;		// 20MHz: Don't care;  40MHz: Duplicate.
-	tcb_desc->bRTSBW			= false; // RTS frame bandwidth is always 20MHz
-
-	if(tcb_desc->bBroadcast || tcb_desc->bMulticast)//only unicast frame will use rts/cts
+	tcb_desc->bRTSUseShortGI		= false;
+	/* Since protection frames are always sent by
+	 * legacy rate, ShortGI will never be used. */
+	tcb_desc->bCTSEnable			= false;
+	/* Most of protection using RTS/CTS */
+	tcb_desc->RTSSC				= 0;
+	/* 20MHz: Don't care;  40MHz: Duplicate. */
+	tcb_desc->bRTSBW			= false;
+	/* RTS frame bandwidth is always 20MHz */
+
+	if (tcb_desc->bBroadcast || tcb_desc->bMulticast)
 		return;
+	/* only unicast frame will use rts/cts */
 
-	if (is_broadcast_ether_addr(skb->data+16))  //check addr3 as infrastructure add3 is DA.
+	if (is_broadcast_ether_addr(skb->data+16))
 		return;
-
-	if (ieee->mode < IEEE_N_24G) //b, g mode
-	{
-			// (1) RTS_Threshold is compared to the MPDU, not MSDU.
-			// (2) If there are more than one frag in  this MSDU, only the first frag uses protection frame.
-			//		Other fragments are protected by previous fragment.
-			//		So we only need to check the length of first fragment.
-		if (skb->len > ieee->rts)
-		{
+		/*check addr3 as infrastructure add3 is DA. */
+
+	if (ieee->mode < IEEE_N_24G) {
+			/* b, g mode
+			/* (1) RTS_Threshold is compared to the MPDU, not MSDU.
+			   (2) If there are more than one frag in  this MSDU,
+			 *only the first frag uses protection frame.
+			 * Other fragments are protected by previous fragment.
+			 * So we only need to check
+			 * the length of first fragment. */
+		if (skb->len > ieee->rts) {
 			tcb_desc->bRTSEnable = true;
 			tcb_desc->rts_rate = MGN_24M;
-		}
-		else if (ieee->current_network.buseprotection)
-		{
-			// Use CTS-to-SELF in protection mode.
+		} else if (ieee->current_network.buseprotection) {
+			/* Use CTS-to-SELF in protection mode. */
 			tcb_desc->bRTSEnable = true;
 			tcb_desc->bCTSEnable = true;
 			tcb_desc->rts_rate = MGN_24M;
 		}
-		//otherwise return;
+		/* otherwise return; */
 		return;
-	}
-	else
-	{// 11n High throughput case.
+	} else {
+		/* 11n High throughput case. */
 		PRT_HIGH_THROUGHPUT pHTInfo = ieee->pHTInfo;
-		while (true)
-		{
-			//check IOT action
-			if(pHTInfo->IOTAction & HT_IOT_ACT_FORCED_CTS2SELF)
-			{
-				tcb_desc->bCTSEnable	= true;
-				tcb_desc->rts_rate  = 	MGN_24M;
+		while (true) {
+			/* check IOT action */
+			if (pHTInfo->IOTAction & HT_IOT_ACT_FORCED_CTS2SELF) {
+				tcb_desc->bCTSEnable = true;
+				tcb_desc->rts_rate = MGN_24M;
 				tcb_desc->bRTSEnable = false;
 				break;
-			}
-			else if(pHTInfo->IOTAction & (HT_IOT_ACT_FORCED_RTS|HT_IOT_ACT_PURE_N_MODE))
-			{
+			} else if (pHTInfo->IOTAction & (HT_IOT_ACT_FORCED_RTS|HT_IOT_ACT_PURE_N_MODE)) {
 				tcb_desc->bRTSEnable = true;
-				tcb_desc->rts_rate  = 	MGN_24M;
+				tcb_desc->rts_rate = MGN_24M;
 				break;
 			}
-			//check ERP protection
-			if (ieee->current_network.buseprotection)
-			{// CTS-to-SELF
+			/* check ERP protection */
+			if (ieee->current_network.buseprotection) {
 				tcb_desc->bRTSEnable = true;
 				tcb_desc->bCTSEnable = true;
 				tcb_desc->rts_rate = MGN_24M;
 				break;
 			}
-			//check HT op mode
-			if(pHTInfo->bCurrentHTSupport  && pHTInfo->bEnableHT)
-			{
+			/* check HT op mode */
+			if (pHTInfo->bCurrentHTSupport  && pHTInfo->bEnableHT) {
 				u8 HTOpMode = pHTInfo->CurrentOpMode;
-				if((pHTInfo->bCurBW40MHz && (HTOpMode == 2 || HTOpMode == 3)) ||
-							(!pHTInfo->bCurBW40MHz && HTOpMode == 3) )
-				{
-					tcb_desc->rts_rate = MGN_24M; // Rate is 24Mbps.
+				if ((pHTInfo->bCurBW40MHz && (HTOpMode == 2 || HTOpMode == 3)) ||
+							(!pHTInfo->bCurBW40MHz && HTOpMode == 3)) {
+					tcb_desc->rts_rate = MGN_24M;
+					/* Rate is 24Mbps. */
 					tcb_desc->bRTSEnable = true;
 					break;
 				}
 			}
-			//check rts
-			if (skb->len > ieee->rts)
-			{
-				tcb_desc->rts_rate = MGN_24M; // Rate is 24Mbps.
+			/* check rts */
+			if (skb->len > ieee->rts) {
+				tcb_desc->rts_rate = MGN_24M;
+				/* Rate is 24Mbps. */
 				tcb_desc->bRTSEnable = true;
 				break;
 			}
-			//to do list: check MIMO power save condition.
-			//check AMPDU aggregation for TXOP
-			if(tcb_desc->bAMPDUEnable)
-			{
-				tcb_desc->rts_rate = MGN_24M; // Rate is 24Mbps.
-				// According to 8190 design, firmware sends CF-End only if RTS/CTS is enabled. However, it degrads
-				// throughput around 10M, so we disable of this mechanism. 2007.08.03 by Emily
+			/* to do list: check MIMO power save condition.
+			 * check AMPDU aggregation for TXOP */
+			if (tcb_desc->bAMPDUEnable) {
+				tcb_desc->rts_rate = MGN_24M;
+				/* According to 8190 design,
+				 * firmware sends CF-End only
+				 * if RTS/CTS is enabled. However, it degrads
+				 * throughput around 10M, so we disable
+				 * of this mechanism. 2007.08.03 by Emily */
 				tcb_desc->bRTSEnable = false;
 				break;
 			}
-			// Totally no protection case!!
+			/* Totally no protection case!! */
 			goto NO_PROTECTION;
 		}
 		}
-	// For test , CTS replace with RTS
-	if( 0 )
-	{
-		tcb_desc->bCTSEnable	= true;
+	/* For test , CTS replace with RTS */
+	if (0) {
+		tcb_desc->bCTSEnabl = true;
 		tcb_desc->rts_rate = MGN_24M;
-		tcb_desc->bRTSEnable 	= true;
+		tcb_desc->bRTSEnable = true;
 	}
 	if (ieee->current_network.capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
 		tcb_desc->bUseShortPreamble = true;
@@ -553,53 +543,48 @@ void ieee80211_query_protectionmode(struct ieee80211_device* ieee, cb_desc* tcb_
 NO_PROTECTION:
 	tcb_desc->bRTSEnable	= false;
 	tcb_desc->bCTSEnable	= false;
-	tcb_desc->rts_rate		= 0;
+	tcb_desc->rts_rate	= 0;
 	tcb_desc->RTSSC		= 0;
-	tcb_desc->bRTSBW		= false;
+	tcb_desc->bRTSBW	= false;
 }
 
 
-void ieee80211_txrate_selectmode(struct ieee80211_device* ieee, cb_desc* tcb_desc)
+void ieee80211_txrate_selectmode(struct ieee80211_device *ieee, cb_desc *tcb_desc)
 {
 #ifdef TO_DO_LIST
-	if(!IsDataFrame(pFrame))
-	{
+	if (!IsDataFrame(pFrame)) {
 		pTcb->bTxDisableRateFallBack = TRUE;
 		pTcb->bTxUseDriverAssingedRate = TRUE;
 		pTcb->RATRIndex = 7;
 		return;
 	}
 
-	if(pMgntInfo->ForcedDataRate!= 0)
-	{
+	if (pMgntInfo->ForcedDataRate != 0) {
 		pTcb->bTxDisableRateFallBack = TRUE;
 		pTcb->bTxUseDriverAssingedRate = TRUE;
 		return;
 	}
 #endif
-	if(ieee->bTxDisableRateFallBack)
+	if (ieee->bTxDisableRateFallBack)
 		tcb_desc->bTxDisableRateFallBack = true;
 
-	if(ieee->bTxUseDriverAssingedRate)
+	if (ieee->bTxUseDriverAssingedRate)
 		tcb_desc->bTxUseDriverAssingedRate = true;
-	if(!tcb_desc->bTxDisableRateFallBack || !tcb_desc->bTxUseDriverAssingedRate)
-	{
+	if (!tcb_desc->bTxDisableRateFallBack || !tcb_desc->bTxUseDriverAssingedRate) {
 		if (ieee->iw_mode == IW_MODE_INFRA || ieee->iw_mode == IW_MODE_ADHOC)
 			tcb_desc->RATRIndex = 0;
 	}
 }
 
-void ieee80211_query_seqnum(struct ieee80211_device*ieee, struct sk_buff* skb, u8* dst)
+void ieee80211_query_seqnum(struct ieee80211_device *ieee, struct sk_buff *skb, u8 *dst)
 {
 	if (is_multicast_ether_addr(dst) || is_broadcast_ether_addr(dst))
 		return;
-	if (IsQoSDataFrame(skb->data)) //we deal qos data only
-	{
+	if (IsQoSDataFrame(skb->data)) {
+	/* ^^^ we deal qos data only ^^^*/
 		PTX_TS_RECORD pTS = NULL;
-		if (!GetTs(ieee, (PTS_COMMON_INFO*)(&pTS), dst, skb->priority, TX_DIR, true))
-		{
+		if (!GetTs(ieee, (PTS_COMMON_INFO *)(&pTS), dst, skb->priority, TX_DIR, true))
 			return;
-		}
 		pTS->TxCurSeq = (pTS->TxCurSeq+1)%4096;
 	}
 }
@@ -623,7 +608,7 @@ int rtl8192_ieee80211_rtl_xmit(struct sk_buff *skb, struct net_device *dev)
 	u8 dest[ETH_ALEN], src[ETH_ALEN];
 	int qos_actived = ieee->current_network.qos_data.active;
 
-	struct ieee80211_crypt_data* crypt;
+	struct ieee80211_crypt_data *crypt;
 
 	cb_desc *tcb_desc;
 
@@ -631,7 +616,7 @@ int rtl8192_ieee80211_rtl_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	/* If there is no driver handler to take the TXB, dont' bother
 	 * creating it... */
-	if ((!ieee->hard_start_xmit && !(ieee->softmac_features & IEEE_SOFTMAC_TX_QUEUE))||
+	if ((!ieee->hard_start_xmit && !(ieee->softmac_features & IEEE_SOFTMAC_TX_QUEUE)) ||
 	   ((!ieee->softmac_data_hard_start_xmit && (ieee->softmac_features & IEEE_SOFTMAC_TX_QUEUE)))) {
 		printk(KERN_WARNING "%s: No xmit handler.\n",
 		       ieee->dev->name);
@@ -639,7 +624,7 @@ int rtl8192_ieee80211_rtl_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 
-	if(likely(ieee->raw_tx == 0)){
+	if (likely(ieee->raw_tx == 0)) {
 		if (unlikely(skb->len < SNAP_SIZE + sizeof(u16))) {
 			printk(KERN_WARNING "%s: skb too small (%d).\n",
 			ieee->dev->name, skb->len);
@@ -674,18 +659,14 @@ int rtl8192_ieee80211_rtl_xmit(struct sk_buff *skb, struct net_device *dev)
 
                 /* Advance the SKB to the start of the payload */
                 skb_pull(skb, sizeof(struct ethhdr));
-
                 /* Determine total amount of storage required for TXB packets */
                 bytes = skb->len + SNAP_SIZE + sizeof(u16);
-
 		if (encrypt)
 			fc = IEEE80211_FTYPE_DATA | IEEE80211_FCTL_WEP;
 		else
-
                         fc = IEEE80211_FTYPE_DATA;
-
-		//if(ieee->current_network.QoS_Enable)
-		if(qos_actived)
+		/* if(ieee->current_network.QoS_Enable) */
+		if (qos_actived)
 			fc |= IEEE80211_STYPE_QOS_DATA;
 		else
 			fc |= IEEE80211_STYPE_DATA;
@@ -708,44 +689,45 @@ int rtl8192_ieee80211_rtl_xmit(struct sk_buff *skb, struct net_device *dev)
                 header.frame_ctl = cpu_to_le16(fc);
 
 		/* Determine fragmentation size based on destination (multicast
-		* and broadcast are not fragmented) */
+		 * and broadcast are not fragmented) */
 		if (is_multicast_ether_addr(header.addr1) ||
 		is_broadcast_ether_addr(header.addr1)) {
 			frag_size = MAX_FRAG_THRESHOLD;
 			qos_ctl |= QOS_CTL_NOTCONTAIN_ACK;
-		}
-		else {
-			frag_size = ieee->fts;//default:392
+		} else {
+			frag_size = ieee->fts; /*default:392*/
 			qos_ctl = 0;
 		}
 
-		//if (ieee->current_network.QoS_Enable)
-		if(qos_actived)
-		{
+		/* if (ieee->current_network.QoS_Enable) */
+		if (qos_actived) {
 			hdr_len = IEEE80211_3ADDR_LEN + 2;
 
 			skb->priority = ieee80211_classify(skb, &ieee->current_network);
-			qos_ctl |= skb->priority; //set in the ieee80211_classify
+			qos_ctl |= skb->priority;
+			/* ^^^ set in the ieee80211_classify ^^^*/
 			header.qos_ctl = cpu_to_le16(qos_ctl & IEEE80211_QOS_TID);
 		} else {
 			hdr_len = IEEE80211_3ADDR_LEN;
 		}
 		/* Determine amount of payload per fragment.  Regardless of if
 		* this stack is providing the full 802.11 header, one will
-		* eventually be affixed to this fragment -- so we must account for
+		* eventually be affixed to this
+		* fragment -- so we must account for
 		* it when determining the amount of payload space. */
 		bytes_per_frag = frag_size - hdr_len;
 		if (ieee->config &
 		(CFG_IEEE80211_COMPUTE_FCS | CFG_IEEE80211_RESERVE_FCS))
 			bytes_per_frag -= IEEE80211_FCS_LEN;
 
-		/* Each fragment may need to have room for encryptiong pre/postfix */
+		/* Each fragment may need to
+		 * have room for encryptiong pre/postfix */
 		if (encrypt)
 			bytes_per_frag -= crypt->ops->extra_prefix_len +
 				crypt->ops->extra_postfix_len;
 
 		/* Number of fragments is the total bytes_per_frag /
-		* payload_per_fragment */
+		 * payload_per_fragment */
 		nr_frags = bytes / bytes_per_frag;
 		bytes_last_frag = bytes % bytes_per_frag;
 		if (bytes_last_frag)
@@ -753,8 +735,10 @@ int rtl8192_ieee80211_rtl_xmit(struct sk_buff *skb, struct net_device *dev)
 		else
 			bytes_last_frag = bytes_per_frag;
 
-		/* When we allocate the TXB we allocate enough space for the reserve
-		* and full fragment bytes (bytes_per_frag doesn't include prefix,
+		/* When we allocate the TXB we
+		 * allocate enough space for the reserve
+		* and full fragment bytes (
+		* bytes_per_frag doesn't include prefix,
 		* postfix, header, FCS, etc.) */
 		txb = ieee80211_alloc_txb(nr_frags, frag_size + ieee->tx_headroom, GFP_ATOMIC);
 		if (unlikely(!txb)) {
@@ -765,21 +749,20 @@ int rtl8192_ieee80211_rtl_xmit(struct sk_buff *skb, struct net_device *dev)
 		txb->encrypted = encrypt;
 		txb->payload_size = bytes;
 
-		//if (ieee->current_network.QoS_Enable)
-		if(qos_actived)
-		{
+		/* if (ieee->current_network.QoS_Enable) */
+		if (qos_actived)
 			txb->queue_index = UP2AC(skb->priority);
-		} else {
+		else
 			txb->queue_index = WME_AC_BK;;
-		}
 
 
 
 		for (i = 0; i < nr_frags; i++) {
 			skb_frag = txb->fragments[i];
 			tcb_desc = (cb_desc *)(skb_frag->cb + MAX_DEV_ADDR_SIZE);
-			if(qos_actived){
-				skb_frag->priority = skb->priority;//UP2AC(skb->priority);
+			if (qos_actived) {
+				skb_frag->priority = skb->priority;
+				/* ^^ UP2AC(skb->priority); ^^ */
 				tcb_desc->queue_index =  UP2AC(skb->priority);
 			} else {
 				skb_frag->priority = WME_AC_BK;
@@ -787,21 +770,20 @@ int rtl8192_ieee80211_rtl_xmit(struct sk_buff *skb, struct net_device *dev)
 			}
 			skb_reserve(skb_frag, ieee->tx_headroom);
 
-			if (encrypt){
+			if (encrypt) {
 				if (ieee->hwsec_active)
 					tcb_desc->bHwSec = 1;
 				else
 					tcb_desc->bHwSec = 0;
 				skb_reserve(skb_frag, crypt->ops->extra_prefix_len);
-			}
-			else
-			{
+			} else {
 				tcb_desc->bHwSec = 0;
 			}
 			frag_hdr = (struct ieee80211_hdr_3addrqos *)skb_put(skb_frag, hdr_len);
 			memcpy(frag_hdr, &header, hdr_len);
 
-			/* If this is not the last fragment, then add the MOREFRAGS
+			/* If this is not the last fragment,
+			* then add the MOREFRAGS
 			* bit to the frame control */
 			if (i != nr_frags - 1) {
 				frag_hdr->frame_ctl = cpu_to_le16(
@@ -809,13 +791,14 @@ int rtl8192_ieee80211_rtl_xmit(struct sk_buff *skb, struct net_device *dev)
 				bytes = bytes_per_frag;
 
 			} else {
-				/* The last fragment takes the remaining length */
+				/* The last fragment takes
+				*the remaining length */
 				bytes = bytes_last_frag;
 			}
-			//if(ieee->current_network.QoS_Enable)
-			if(qos_actived)
-			{
-				// add 1 only indicate to corresponding seq number control 2006/7/12
+			/* if(ieee->current_network.QoS_Enable) */
+			if (qos_actived) {
+				/* add 1 only indicate to corresponding 
+				* seq number control 2006/7/12 */
 				frag_hdr->seq_ctl = cpu_to_le16(ieee->seq_ctrl[UP2AC(skb->priority)+1]<<4 | i);
 			} else {
 				frag_hdr->seq_ctl = cpu_to_le16(ieee->seq_ctrl[0]<<4 | i);
@@ -843,19 +826,18 @@ int rtl8192_ieee80211_rtl_xmit(struct sk_buff *skb, struct net_device *dev)
 				skb_put(skb_frag, 4);
 		}
 
-		if(qos_actived)
-		{
+		if (qos_actived) {
 		  if (ieee->seq_ctrl[UP2AC(skb->priority) + 1] == 0xFFF)
 			ieee->seq_ctrl[UP2AC(skb->priority) + 1] = 0;
 		  else
 			ieee->seq_ctrl[UP2AC(skb->priority) + 1]++;
 		} else {
-  		  if (ieee->seq_ctrl[0] == 0xFFF)
+		if (ieee->seq_ctrl[0] == 0xFFF)
 			ieee->seq_ctrl[0] = 0;
 		  else
 			ieee->seq_ctrl[0]++;
 		}
-	}else{
+	} else {
 		if (unlikely(skb->len < sizeof(struct ieee80211_hdr_3addr))) {
 			printk(KERN_WARNING "%s: skb too small (%d).\n",
 			ieee->dev->name, skb->len);
@@ -863,7 +845,7 @@ int rtl8192_ieee80211_rtl_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 
 		txb = ieee80211_alloc_txb(1, skb->len, GFP_ATOMIC);
-		if(!txb){
+		if (!txb) {
 			printk(KERN_WARNING "%s: Could not allocate TXB\n",
 			ieee->dev->name);
 			goto failed;
@@ -871,13 +853,14 @@ int rtl8192_ieee80211_rtl_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		txb->encrypted = 0;
 		txb->payload_size = skb->len;
-		memcpy(skb_put(txb->fragments[0],skb->len), skb->data, skb->len);
+		memcpy(skb_put(txb->fragments[0], skb->len), skb->data, skb->len);
 	}
 
  success:
-//WB add to fill data tcb_desc here. only first fragment is considered, need to change, and you may remove to other place.
-	if (txb)
-	{
+	/*WB add to fill data tcb_desc here.
+	*only first fragment is considered, need to change,
+	* and you may remove to other place. */
+	if (txb) {
 #if 1
 		cb_desc *tcb_desc = (cb_desc *)(txb->fragments[0]->cb + MAX_DEV_ADDR_SIZE);
 		tcb_desc->bTxEnableFwCalcDur = 1;
@@ -886,10 +869,10 @@ int rtl8192_ieee80211_rtl_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (is_broadcast_ether_addr(header.addr1))
 			tcb_desc->bBroadcast = 1;
 		ieee80211_txrate_selectmode(ieee, tcb_desc);
-		if ( tcb_desc->bMulticast ||  tcb_desc->bBroadcast)
+		if (tcb_desc->bMulticast ||  tcb_desc->bBroadcast)
 			tcb_desc->data_rate = ieee->basic_rate;
 		else
-			//tcb_desc->data_rate = CURRENT_RATE(ieee->current_network.mode, ieee->rate, ieee->HTCurrentOperaRate);
+			/* tcb_desc->data_rate = CURRENT_RATE(ieee->current_network.mode, ieee->rate, ieee->HTCurrentOperaRate); */
 			tcb_desc->data_rate = CURRENT_RATE(ieee->mode, ieee->rate, ieee->HTCurrentOperaRate);
 		ieee80211_qurey_ShortPreambleMode(ieee, tcb_desc);
 		ieee80211_tx_query_agg_cap(ieee, txb->fragments[0], tcb_desc);
@@ -897,16 +880,16 @@ int rtl8192_ieee80211_rtl_xmit(struct sk_buff *skb, struct net_device *dev)
 		ieee80211_query_BandwidthMode(ieee, tcb_desc);
 		ieee80211_query_protectionmode(ieee, tcb_desc, txb->fragments[0]);
 		ieee80211_query_seqnum(ieee, txb->fragments[0], header.addr1);
-//		IEEE80211_DEBUG_DATA(IEEE80211_DL_DATA, txb->fragments[0]->data, txb->fragments[0]->len);
-		//IEEE80211_DEBUG_DATA(IEEE80211_DL_DATA, tcb_desc, sizeof(cb_desc));
+/*		IEEE80211_DEBUG_DATA(IEEE80211_DL_DATA, txb->fragments[0]->data, txb->fragments[0]->len);
+		IEEE80211_DEBUG_DATA(IEEE80211_DL_DATA, tcb_desc, sizeof(cb_desc)); */
 #endif
 	}
 	spin_unlock_irqrestore(&ieee->lock, flags);
 	dev_kfree_skb_any(skb);
 	if (txb) {
-		if (ieee->softmac_features & IEEE_SOFTMAC_TX_QUEUE){
+		if (ieee->softmac_features & IEEE_SOFTMAC_TX_QUEUE) {
 			ieee80211_softmac_xmit(txb, ieee);
-		}else{
+		} else {
 			if ((*ieee->hard_start_xmit)(txb, dev) == 0) {
 				stats->tx_packets++;
 				stats->tx_bytes += txb->payload_size;
-- 
1.7.0.4

