Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272Ab2CNA75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:59:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39406 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759272Ab2CNA7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:59:55 -0400
From: Andrew Miller <amiller@amilx.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        amiller@amilx.com
Subject: [PATCH] Staging: rtl8187se: r8180_core.c: Fix coding style issue
Date: Tue, 13 Mar 2012 20:58:09 -0400
Message-Id: <1331686689-6763-1-git-send-email-amiller@amilx.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix long line coding style issue

Signed-off-by: Andrew Miller <amiller@amilx.com>
---
 drivers/staging/rtl8187se/r8180_core.c |   32 ++++++++++++++++++++------------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 04c2391..9ef78f0 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1392,11 +1392,13 @@ void PerformUndecoratedSignalSmoothing8185(struct r8180_priv *priv,
 	priv->bCurCCKPkt = bCckRate;
 
 	if (priv->UndecoratedSmoothedSS >= 0)
-		priv->UndecoratedSmoothedSS = ((priv->UndecoratedSmoothedSS * 5) + (priv->SignalStrength * 10)) / 6;
+		priv->UndecoratedSmoothedSS = ((priv->UndecoratedSmoothedSS * 5) +
+					      (priv->SignalStrength * 10)) / 6;
 	else
 		priv->UndecoratedSmoothedSS = priv->SignalStrength * 10;
 
-	priv->UndercorateSmoothedRxPower = ((priv->UndercorateSmoothedRxPower * 50) + (priv->RxPower * 11)) / 60;
+	priv->UndercorateSmoothedRxPower = ((priv->UndercorateSmoothedRxPower * 50) +
+	                                   (priv->RxPower * 11)) / 60;
 
 	if (bCckRate)
 		priv->CurCCKRSSI = priv->RSSI;
@@ -1607,17 +1609,20 @@ void rtl8180_rx(struct net_device *dev)
 		/* printk("==========================>rx : RXAGC is %d,signalstrength is %d\n",RXAGC,stats.signalstrength); */
 		stats.rssi = priv->wstats.qual.qual = priv->SignalQuality;
 		stats.noise = priv->wstats.qual.noise = 100 - priv->wstats.qual.qual;
-		bHwError = (((*(priv->rxringtail)) & (0x00000fff)) == 4080) | (((*(priv->rxringtail)) & (0x04000000)) != 0)
-			| (((*(priv->rxringtail)) & (0x08000000)) != 0) | (((~(*(priv->rxringtail))) & (0x10000000)) != 0) | (((~(*(priv->rxringtail))) & (0x20000000)) != 0);
+		bHwError = (((*(priv->rxringtail)) & (0x00000fff)) == 4080) |
+			   (((*(priv->rxringtail)) & (0x04000000)) != 0) |
+			   (((*(priv->rxringtail)) & (0x08000000)) != 0) |
+			   (((~(*(priv->rxringtail))) & (0x10000000)) != 0) |
+			   (((~(*(priv->rxringtail))) & (0x20000000)) != 0);
 		bCRC = ((*(priv->rxringtail)) & (0x00002000)) >> 13;
 		bICV = ((*(priv->rxringtail)) & (0x00001000)) >> 12;
 		hdr = (struct ieee80211_hdr_4addr *)priv->rxbuffer->buf;
 		    fc = le16_to_cpu(hdr->frame_ctl);
 		type = WLAN_FC_GET_TYPE(fc);
 
-			if ((IEEE80211_FTYPE_CTL != type) &&
-				(eqMacAddr(priv->ieee80211->current_network.bssid, (fc & IEEE80211_FCTL_TODS) ? hdr->addr1 : (fc & IEEE80211_FCTL_FROMDS) ? hdr->addr2 : hdr->addr3))
-				 && (!bHwError) && (!bCRC) && (!bICV)) {
+			if ((IEEE80211_FTYPE_CTL != type) && (eqMacAddr(priv->ieee80211->current_network.bssid,
+			    (fc & IEEE80211_FCTL_TODS) ? hdr->addr1 : (fc & IEEE80211_FCTL_FROMDS) ? hdr->addr2 : hdr->addr3))
+			    && (!bHwError) && (!bCRC) && (!bICV)) {
 				/* Perform signal smoothing for dynamic
 				 * mechanism on demand. This is different
 				 * with PerformSignalSmoothing8185 in smoothing
@@ -2112,7 +2117,7 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 		/* Use short preamble or not */
 		if (priv->ieee80211->current_network.capability&WLAN_CAPABILITY_SHORT_PREAMBLE)
 			if (priv->plcp_preamble_mode == 1 && rate != 0)	/*  short mode now, not long! */
-			; /* *tail |= (1<<16); */				/* enable short preamble mode. */
+			; /* *tail |= (1<<16); */			/* enable short preamble mode. */
 
 		if (bCTSEnable)
 			*tail |= (1<<18);
@@ -2325,8 +2330,9 @@ void rtl8180_hw_sleep(struct net_device *dev, u32 th, u32 tl)
 		u32 tmp = (tl > rb) ? (tl-rb) : (rb-tl);
 
 		priv->DozePeriodInPast2Sec += jiffies_to_msecs(tmp);
-
-		queue_delayed_work(priv->ieee80211->wq, &priv->ieee80211->hw_wakeup_wq, tmp); /* as tl may be less than rb */
+		
+		/* as tl may be less than rb */
+		queue_delayed_work(priv->ieee80211->wq, &priv->ieee80211->hw_wakeup_wq, tmp);
 	}
 	/* 
 	 * If we suspect the TimerInt is gone beyond tl
@@ -3227,7 +3233,8 @@ void LeisurePSEnter(struct r8180_priv *priv)
 {
 	if (priv->bLeisurePs) {
 		if (priv->ieee80211->ps == IEEE80211_PS_DISABLED)
-			MgntActSet_802_11_PowerSaveMode(priv, IEEE80211_PS_MBCAST|IEEE80211_PS_UNICAST); /* IEEE80211_PS_ENABLE */
+			/* IEEE80211_PS_ENABLE */
+			MgntActSet_802_11_PowerSaveMode(priv, IEEE80211_PS_MBCAST|IEEE80211_PS_UNICAST);
 	}
 }
 
@@ -3299,7 +3306,8 @@ void rtl8180_watch_dog(struct net_device *dev)
 	u16 SlotIndex = 0;
 	u16 i = 0;
 	if (priv->ieee80211->actscanning == false) {
-		if ((priv->ieee80211->iw_mode != IW_MODE_ADHOC) && (priv->ieee80211->state == IEEE80211_NOLINK) && (priv->ieee80211->beinretry == false) && (priv->eRFPowerState == eRfOn))
+		if ((priv->ieee80211->iw_mode != IW_MODE_ADHOC) && (priv->ieee80211->state ==
+		    IEEE80211_NOLINK) && (priv->ieee80211->beinretry == false) && (priv->eRFPowerState == eRfOn))
 			IPSEnter(dev);
 	}
 	/* YJ,add,080828,for link state check */
-- 
1.7.7.6

