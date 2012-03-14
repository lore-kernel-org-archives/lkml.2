Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761659Ab2CNW3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 18:29:19 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54054 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761600Ab2CNW3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 18:29:14 -0400
From: Andrew Miller <amiller@amilx.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        amiller@amilx.com
Subject: [PATCH 3/3] Staging: rtl8187se: r8180_core.c: Fix some long line issues
Date: Wed, 14 Mar 2012 18:26:59 -0400
Message-Id: <1331764019-5808-4-git-send-email-amiller@amilx.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331764019-5808-1-git-send-email-amiller@amilx.com>
References: <1331764019-5808-1-git-send-email-amiller@amilx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some lines that where fairly long judging off the
code around it.

Signed-off-by: Andrew Miller <amiller@amilx.com>
---
 drivers/staging/rtl8187se/r8180_core.c |   34 +++++++++++++++++++++----------
 1 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 42307a3..e4ade55 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1391,11 +1391,13 @@ void PerformUndecoratedSignalSmoothing8185(struct r8180_priv *priv,
 	priv->bCurCCKPkt = bCckRate;
 
 	if (priv->UndecoratedSmoothedSS >= 0)
-		priv->UndecoratedSmoothedSS = ((priv->UndecoratedSmoothedSS * 5) + (priv->SignalStrength * 10)) / 6;
+		priv->UndecoratedSmoothedSS = ((priv->UndecoratedSmoothedSS * 5) +
+					       (priv->SignalStrength * 10)) / 6;
 	else
 		priv->UndecoratedSmoothedSS = priv->SignalStrength * 10;
 
-	priv->UndercorateSmoothedRxPower = ((priv->UndercorateSmoothedRxPower * 50) + (priv->RxPower * 11)) / 60;
+	priv->UndercorateSmoothedRxPower = ((priv->UndercorateSmoothedRxPower * 50) +
+					    (priv->RxPower * 11)) / 60;
 
 	if (bCckRate)
 		priv->CurCCKRSSI = priv->RSSI;
@@ -1606,8 +1608,11 @@ void rtl8180_rx(struct net_device *dev)
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
@@ -2005,7 +2010,8 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 			bRTSEnable = 0;
 			bCTSEnable = 0;
 
-			ThisFrameTime = ComputeTxTime(len + sCrcLng, rtl8180_rate2rate(rate), 0, bUseShortPreamble);
+			ThisFrameTime = ComputeTxTime(len + sCrcLng, rtl8180_rate2rate(rate),
+						      0, bUseShortPreamble);
 			TxDescDuration = ThisFrameTime;
 		} else { /* Unicast packet */
 			u16 AckTime;
@@ -2043,7 +2049,8 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 				bRTSEnable = 0;
 				RtsDur = 0;
 
-				ThisFrameTime = ComputeTxTime(len + sCrcLng, rtl8180_rate2rate(rate), 0, bUseShortPreamble);
+				ThisFrameTime = ComputeTxTime(len + sCrcLng, rtl8180_rate2rate(rate),
+							      0, bUseShortPreamble);
 				TxDescDuration = ThisFrameTime + aSifsTime + AckTime;
 			}
 
@@ -2328,8 +2335,8 @@ void rtl8180_hw_sleep(struct net_device *dev, u32 th, u32 tl)
 		u32 tmp = (tl > rb) ? (tl-rb) : (rb-tl);
 
 		priv->DozePeriodInPast2Sec += jiffies_to_msecs(tmp);
-
-		queue_delayed_work(priv->ieee80211->wq, &priv->ieee80211->hw_wakeup_wq, tmp); /* as tl may be less than rb */
+		/* as tl may be less than rb */
+		queue_delayed_work(priv->ieee80211->wq, &priv->ieee80211->hw_wakeup_wq, tmp);
 	}
 	/*
 	 * If we suspect the TimerInt is gone beyond tl
@@ -3089,7 +3096,8 @@ void rtl8185_set_rate(struct net_device *dev)
 	max_rr_rate = ieeerate2rtlrate(240);
 
 	write_nic_byte(dev, RESP_RATE,
-			max_rr_rate<<MAX_RESP_RATE_SHIFT | min_rr_rate<<MIN_RESP_RATE_SHIFT);
+		       max_rr_rate<<MAX_RESP_RATE_SHIFT |
+		       min_rr_rate<<MIN_RESP_RATE_SHIFT);
 
 	word  = read_nic_word(dev, BRSR);
 	word &= ~BRSR_MBR_8185;
@@ -3230,7 +3238,8 @@ void LeisurePSEnter(struct r8180_priv *priv)
 {
 	if (priv->bLeisurePs) {
 		if (priv->ieee80211->ps == IEEE80211_PS_DISABLED)
-			MgntActSet_802_11_PowerSaveMode(priv, IEEE80211_PS_MBCAST|IEEE80211_PS_UNICAST); /* IEEE80211_PS_ENABLE */
+			/* IEEE80211_PS_ENABLE */
+			MgntActSet_802_11_PowerSaveMode(priv, IEEE80211_PS_MBCAST|IEEE80211_PS_UNICAST);
 	}
 }
 
@@ -3302,7 +3311,10 @@ void rtl8180_watch_dog(struct net_device *dev)
 	u16 SlotIndex = 0;
 	u16 i = 0;
 	if (priv->ieee80211->actscanning == false) {
-		if ((priv->ieee80211->iw_mode != IW_MODE_ADHOC) && (priv->ieee80211->state == IEEE80211_NOLINK) && (priv->ieee80211->beinretry == false) && (priv->eRFPowerState == eRfOn))
+		if ((priv->ieee80211->iw_mode != IW_MODE_ADHOC) &&
+		    (priv->ieee80211->state == IEEE80211_NOLINK) &&
+		    (priv->ieee80211->beinretry == false) &&
+		    (priv->eRFPowerState == eRfOn))
 			IPSEnter(dev);
 	}
 	/* YJ,add,080828,for link state check */
-- 
1.7.7.6

