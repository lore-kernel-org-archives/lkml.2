Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab0LaFve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 00:51:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52549 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab0LaFsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 00:48:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=H8+Qz9wNy6gLJwSvfMOn4taK8/76LAvfcNmwQYp6aG9iPaFc8FFKkvDZNAFjpQ4Svg
         YRZwoQ78ek4jRnjmUIyJ6Y/uJuaD+VeOh0OcyaHiGsX/ahOaIAsAv3zN4s9P3aEBiNfy
         t1V7i3qsfh8uj+GTINyfRhOd4Unr1nIoVPiLM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 02/15]drivers:staging:rtl8187se:r8180_core.c Fix some comments.
Date: Thu, 30 Dec 2010 21:48:38 -0800
Message-Id: <1293774531-5294-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293774531-5294-2-git-send-email-justinmattock@gmail.com>
References: <1293774531-5294-1-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-2-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below are some patches that either fix a typo in a comment and/or fixes a
comment altogether to make more sense. If there is anything I missed let me know
and I'll resend.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/rtl8187se/r8180_core.c |   38 ++++++++++++++++----------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 70ab008..d688679 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -17,7 +17,7 @@
 
    Some ideas borrowed from the 8139too.c driver included in linux kernel.
 
-   We (I?) want to thanks the Authors of those projecs and also the
+   We (I?) want to thanks the Authors of those projects and also the
    Ndiswrapper's project Authors.
 
    A big big thanks goes also to Realtek corp. for their help in my attempt to
@@ -1380,7 +1380,7 @@ long TranslateToDbm8185(u8 SignalStrengthIndex)
 
 /*
  * Perform signal smoothing for dynamic mechanism.
- * This is different with PerformSignalSmoothing8185 in smoothing fomula.
+ * This is different with PerformSignalSmoothing8185 in smoothing formula.
  * No dramatic adjustion is apply because dynamic mechanism need some degree
  * of correctness. Ported from 8187B.
  */
@@ -1591,7 +1591,7 @@ void rtl8180_rx(struct net_device *dev)
 		priv->RSSI = RSSI;
 		/* SQ translation formula is provided by SD3 DZ. 2006.06.27 */
 		if (quality >= 127)
-			quality = 1; /*0; */ /* 0 will cause epc to show signal zero , walk aroud now; */
+			quality = 1; /*0; */ /* 0 will cause epc to show signal zero , workaround for now; */
 		else if (quality < 27)
 			quality = 100;
 		else
@@ -1620,7 +1620,7 @@ void rtl8180_rx(struct net_device *dev)
 				/* Perform signal smoothing for dynamic
 				 * mechanism on demand. This is different
 				 * with PerformSignalSmoothing8185 in smoothing
-				 * fomula. No dramatic adjustion is apply
+				 * formula. No dramatic adjustion is apply
 				 * because dynamic mechanism need some degree
 				 * of correctness. */
 				PerformUndecoratedSignalSmoothing8185(priv, bCckRate);
@@ -1646,7 +1646,7 @@ void rtl8180_rx(struct net_device *dev)
 
 		if (first) {
 			if (!priv->rx_skb_complete) {
-				/* seems that HW sometimes fails to reiceve and
+				/* seems that HW sometimes fails to receive and
 				   doesn't provide the last descriptor */
 				dev_kfree_skb_any(priv->rx_skb);
 				priv->stats.rxnolast++;
@@ -1784,9 +1784,9 @@ rate) {
 	/*
 	 * This function doesn't require lock because we make
 	 * sure it's called with the tx_lock already acquired.
-	 * this come from the kernel's hard_xmit callback (through
-	 * the ieee stack, or from the try_wake_queue (again through
-	 * the ieee stack.
+	 * this comes from the kernel's hard_xmit callback through
+	 * the ieee stack, or from the try_wake_queue(again through
+	 * the ieee stack).
 	 */
 	priority = AC2Q(skb->priority);
 	spin_lock_irqsave(&priv->tx_lock, flags);
@@ -1815,7 +1815,7 @@ rate) {
  * If the ring is full packet are dropped (for data frame the queue
  * is stopped before this can happen). For this reason it is better
  * if the descriptors are larger than the largest management frame
- * we intend to TX: i'm unsure what the HW does if it will not found
+ * we intend to TX: i'm unsure what the HW does if it has not found
  * the last fragment of a frame because it has been dropped...
  * Since queues for Management and Data frames are different we
  * might use a different lock than tx_lock (for example mgmt_tx_lock)
@@ -1916,8 +1916,8 @@ void rtl8180_prepare_beacon(struct net_device *dev)
 }
 
 /* 
- * This function do the real dirty work: it enqueues a TX command
- * descriptor in the ring buffer, copyes the frame in a TX buffer
+ * This function does the real dirty work: it enqueues a TX command
+ * descriptor in the ring buffer, copies the frame in a TX buffer
  * and kicks the NIC to ensure it does the DMA transfer.
  */
 short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
@@ -2092,7 +2092,7 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 
 		if (remain == len && !descfrag) {
 			ownbit_flag = false;
-			*tail = *tail | (1<<29) ; /* fist segment of the packet */
+			*tail = *tail | (1<<29) ; /* first segment of the packet */
 			*tail = *tail | (len);
 		} else {
 			ownbit_flag = true;
@@ -2367,7 +2367,7 @@ void rtl8180_wmm_param_update(struct work_struct *work)
 				u8		u1bAIFS;
 				u32		u4bAcParam;
 				pAcParam = (PAC_PARAM)(&AcParam);
-				/* Retrive paramters to udpate. */
+				/* Retrieve paramters to update. */
 				u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN * (((mode&IEEE_G) == IEEE_G) ? 9 : 20) + aSifsTime;
 				u4bAcParam = ((((u32)(pAcParam->f.TXOPLimit))<<AC_PARAM_TXOP_LIMIT_OFFSET)|
 					      (((u32)(pAcParam->f.Ecw.f.ECWmax))<<AC_PARAM_ECW_MAX_OFFSET)|
@@ -2403,7 +2403,7 @@ void rtl8180_wmm_param_update(struct work_struct *work)
 			u8		u1bAIFS;
 			u32		u4bAcParam;
 
-			/* Retrive paramters to udpate. */
+			/* Retrieve paramters to update. */
 			eACI = pAcParam->f.AciAifsn.f.ACI;
 			/* Mode G/A: slotTimeTimer = 9; Mode B: 20 */
 			u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN * (((mode&IEEE_G) == IEEE_G) ? 9 : 20) + aSifsTime;
@@ -2613,7 +2613,7 @@ short rtl8180_init(struct net_device *dev)
 	DMESG("Channel plan is %d\n", priv->channel_plan);
 	rtl8180_set_channel_map(priv->channel_plan, priv->ieee80211);
 
-	/* FIXME: these constants are placed in a bad pleace. */
+	/* FIXME: these constants are placed in a bad place. */
 	priv->txbuffsize = 2048;	/* 1024; */
 	priv->txringcount = 32;		/* 32; */
 	priv->rxbuffersize = 2048;	/* 1024; */
@@ -2689,7 +2689,7 @@ short rtl8180_init(struct net_device *dev)
 	priv->bTxPowerTrack = false;
 	priv->ThermalMeter = 0;
 	priv->FalseAlarmRegValue = 0;
-	priv->RegDigOfdmFaUpTh = 0xc; /* Upper threhold of OFDM false alarm, which is used in DIG. */
+	priv->RegDigOfdmFaUpTh = 0xc; /* Upper threshold of OFDM false alarm, which is used in DIG. */
 	priv->DIG_NumberFallbackVote = 0;
 	priv->DIG_NumberUpgradeVote = 0;
 	priv->LastSignalStrengthInPercent = 0;
@@ -2885,7 +2885,7 @@ short rtl8180_init(struct net_device *dev)
 		priv->chtxpwr_ofdm[i+1] = (word & 0xff00) >> 8;
 	}
 
-	/* 3Read crystal calibtration and thermal meter indication on 87SE. */
+	/* 3Read crystal calibration and thermal meter indication on 87SE. */
 	eeprom_93cx6_read(&eeprom, EEPROM_RSV>>1, &tmpu16);
 
 	/* Crystal calibration for Xin and Xout resp. */
@@ -3128,7 +3128,7 @@ void rtl8180_adapter_start(struct net_device *dev)
 
 	/*
 	 * The following is very strange. seems to be that 1 means test mode,
-	 * but we need to acknolwledges the nic when a packet is ready
+	 * but we need to acknowledge the nic when a packet is ready
 	 * although we set it to 0
 	 */
 
@@ -3883,7 +3883,7 @@ void rtl8180_tx_isr(struct net_device *dev, int pri, short error)
 	 * If the packet previous of the nic pointer has been
 	 * processed this doesn't matter: it will be checked
 	 * here at the next round. Anyway if no more packet are
-	 * TXed no memory leak occour at all.
+	 * TXed no memory leak occur at all.
 	 */
 
 	switch (pri) {
-- 
1.6.5.2.180.gc5b3e

