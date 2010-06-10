Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396Ab0FJBRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 21:17:53 -0400
Received: from outbound-mail04.westnet.com.au ([203.10.1.245]:16331 "EHLO
	outbound-mail04.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755986Ab0FJBRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 21:17:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvUxAGjaD0w6B9paPGdsb2JhbACHcJZrDAEBAQE1LbEyjWuFGASDRw
X-IronPort-AV: E=Sophos;i="4.53,395,1272816000"; 
   d="scan'208";a="44446487"
From: Mike Gilks <mike.kernel@gilksonline.com>
To: gregkh@suse.de, mchehab@redhat.com, julia@diku.dk, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Gilks <mike.kernel@gilksonline.com>
Subject: [PATCH 1/4] staging: rtl8192u: fix checkpatch.pl issues to line 3100 Fix most problems pointed out by checkpatch.pl in file r8192U_core.c up to line 3100
Date: Thu, 10 Jun 2010 09:18:02 +0800
Message-Id: <1276132685-26713-2-git-send-email-mike.kernel@gilksonline.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1276132685-26713-1-git-send-email-mike.kernel@gilksonline.com>
References: <1276132685-26713-1-git-send-email-mike.kernel@gilksonline.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Gilks <mike.kernel@gilksonline.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |   42 ++++++++++++++++----------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 0f852ad..8b6aacb 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -3023,43 +3023,40 @@ static void rtl8192_init_priv_variable(struct net_device *dev)
 		 * 2005.07.07, by rcnjko.
 		 */
 		RCR_AB | RCR_AM | RCR_APM |	/* accept BC/MC/UC */
-		/* RCR_AICV | RCR_ACRC32 | 	accept ICV/CRC error packet */
+		/* RCR_AICV | RCR_ACRC32 |	accept ICV/CRC error packet */
 		((u32)7<<RCR_MXDMA_OFFSET)|
 		/* Max DMA Burst Size per Rx DMA Burst, 7: unlimited. */
 		(priv->EarlyRxThreshold<<RX_FIFO_THRESHOLD_SHIFT) |
 		/* Rx FIFO Threshold, 7: No Rx threshold. */
-		(priv->EarlyRxThreshold == 7 ? RCR_ONLYERLPKT:0);
+		(priv->EarlyRxThreshold == 7 ? RCR_ONLYERLPKT : 0);
 
 	priv->AcmControl = 0;
 	priv->pFirmware = kmalloc(sizeof(rt_firmware), GFP_KERNEL);
 	if (priv->pFirmware)
-	memset(priv->pFirmware, 0, sizeof(rt_firmware));
+		memset(priv->pFirmware, 0, sizeof(rt_firmware));
 
 	/* rx related queue */
 	skb_queue_head_init(&priv->rx_queue);
 	skb_queue_head_init(&priv->skb_queue);
 
 	/* Tx related queue */
-	for(i = 0; i < MAX_QUEUE_SIZE; i++) {
-		skb_queue_head_init(&priv->ieee80211->skb_waitQ [i]);
-	}
-	for(i = 0; i < MAX_QUEUE_SIZE; i++) {
-		skb_queue_head_init(&priv->ieee80211->skb_aggQ [i]);
-	}
-	for(i = 0; i < MAX_QUEUE_SIZE; i++) {
-		skb_queue_head_init(&priv->ieee80211->skb_drv_aggQ [i]);
-	}
+	for (i = 0; i < MAX_QUEUE_SIZE; i++)
+		skb_queue_head_init(&priv->ieee80211->skb_waitQ[i]);
+	for (i = 0; i < MAX_QUEUE_SIZE; i++)
+		skb_queue_head_init(&priv->ieee80211->skb_aggQ[i]);
+	for (i = 0; i < MAX_QUEUE_SIZE; i++)
+		skb_queue_head_init(&priv->ieee80211->skb_drv_aggQ[i]);
 	priv->rf_set_chan = rtl8192_phy_SwChnl;
 }
 
 /* init lock here */
-static void rtl8192_init_priv_lock(struct r8192_priv* priv)
+static void rtl8192_init_priv_lock(struct r8192_priv *priv)
 {
 	spin_lock_init(&priv->tx_lock);
 	spin_lock_init(&priv->irq_lock);		/* added by thomas */
 	/* spin_lock_init(&priv->rf_lock); */
-	sema_init(&priv->wx_sem,1);
-	sema_init(&priv->rf_sem,1);
+	sema_init(&priv->wx_sem, 1);
+	sema_init(&priv->rf_sem, 1);
 	mutex_init(&priv->mutex);
 }
 
@@ -3068,12 +3065,12 @@ extern  void    rtl819x_watchdog_wqcallback(struct work_struct *work);
 void rtl8192_irq_rx_tasklet(struct r8192_priv *priv);
 /* init tasklet and wait_queue here. only 2.6 above kernel is considered */
 #define DRV_NAME "wlan0"
-static void rtl8192_init_priv_task(struct net_device* dev)
+static void rtl8192_init_priv_task(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
 #ifdef PF_SYNCTHREAD
-	priv->priv_wq = create_workqueue(DRV_NAME,0);
+	priv->priv_wq = create_workqueue(DRV_NAME, 0);
 #else
 	priv->priv_wq = create_workqueue(DRV_NAME);
 #endif
@@ -3082,13 +3079,16 @@ static void rtl8192_init_priv_task(struct net_device* dev)
 
 	/* INIT_DELAYED_WORK(&priv->watch_dog_wq, hal_dm_watchdog); */
 	INIT_DELAYED_WORK(&priv->watch_dog_wq, rtl819x_watchdog_wqcallback);
-	INIT_DELAYED_WORK(&priv->txpower_tracking_wq, dm_txpower_trackingcallback);
+	INIT_DELAYED_WORK(&priv->txpower_tracking_wq,
+				dm_txpower_trackingcallback);
 	/* INIT_DELAYED_WORK(&priv->gpio_change_rf_wq,
 	 * dm_gpio_change_rf_callback);
 	 */
-	INIT_DELAYED_WORK(&priv->rfpath_check_wq,  dm_rf_pathcheck_workitemcallback);
+	INIT_DELAYED_WORK(&priv->rfpath_check_wq,
+				dm_rf_pathcheck_workitemcallback);
 	INIT_DELAYED_WORK(&priv->update_beacon_wq, rtl8192_update_beacon);
-	INIT_DELAYED_WORK(&priv->initialgain_operate_wq, InitialGainOperateWorkItemCallBack);
+	INIT_DELAYED_WORK(&priv->initialgain_operate_wq,
+				InitialGainOperateWorkItemCallBack);
 	/* INIT_WORK(&priv->SwChnlWorkItem,  rtl8192_SwChnl_WorkItem); */
 	/* INIT_WORK(&priv->SetBWModeWorkItem,  rtl8192_SetBWModeWorkItem); */
 	INIT_WORK(&priv->qos_activate, rtl8192_qos_activate);
@@ -3098,7 +3098,7 @@ static void rtl8192_init_priv_task(struct net_device* dev)
 	     (unsigned long)priv);
 }
 
-static void rtl8192_get_eeprom_size(struct net_device* dev)
+static void rtl8192_get_eeprom_size(struct net_device *dev)
 {
 	u16 curCR = 0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
-- 
1.6.3.3

