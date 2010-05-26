Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934984Ab0EZXlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:41:55 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:44452 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934987Ab0EZXlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:41:20 -0400
From: Mike Sheldon <mike@mikeasoft.com>
To: greg@kroah.com, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Sheldon <mike@mikeasoft.com>
Subject: [PATCH 15/15] Staging: winbond: Replace printk usage with pr_info
Date: Thu, 27 May 2010 00:39:52 +0100
Message-Id: <1274917192-16962-15-git-send-email-mike@mikeasoft.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
References: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches wbusb.c to replace printk usage (missing KERN_ levels) with pr_info.

Signed-off-by: Mike Sheldon <mike@mikeasoft.com>
---
 drivers/staging/winbond/wbusb.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 681419d..1bad709 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -77,18 +77,18 @@ static int wbsoft_add_interface(struct ieee80211_hw *dev,
 static void wbsoft_remove_interface(struct ieee80211_hw *dev,
 				    struct ieee80211_vif *vif)
 {
-	printk("wbsoft_remove interface called\n");
+	pr_info("wbsoft_remove interface called\n");
 }
 
 static void wbsoft_stop(struct ieee80211_hw *hw)
 {
-	printk(KERN_INFO "%s called\n", __func__);
+	pr_info("%s called\n", __func__);
 }
 
 static int wbsoft_get_stats(struct ieee80211_hw *hw,
 			    struct ieee80211_low_level_stats *stats)
 {
-	printk(KERN_INFO "%s called\n", __func__);
+	pr_info("%s called\n", __func__);
 	return 0;
 }
 
@@ -159,13 +159,13 @@ static void hal_set_current_channel_ex(struct hw_data *pHwData, struct chan_info
 	if (pHwData->SurpriseRemove)
 		return;
 
-	printk("Going to channel: %d/%d\n", channel.band, channel.ChanNo);
+	pr_info("Going to channel: %d/%d\n", channel.band, channel.ChanNo);
 
 	RFSynthesizer_SwitchingChannel(pHwData, channel); /* Switch channel */
 	pHwData->Channel = channel.ChanNo;
 	pHwData->band = channel.band;
 #ifdef _PE_STATE_DUMP_
-	printk("Set channel is %d, band =%d\n", pHwData->Channel,
+	pr_info("Set channel is %d, band =%d\n", pHwData->Channel,
 	       pHwData->band);
 #endif
 	reg->M28_MacControl &= ~0xff;	/* Clean channel information field */
@@ -247,7 +247,7 @@ static int wbsoft_config(struct ieee80211_hw *dev, u32 changed)
 	struct wbsoft_priv *priv = dev->priv;
 	struct chan_info ch;
 
-	printk("wbsoft_config called\n");
+	pr_info("wbsoft_config called\n");
 
 	/* Should use channel_num, or something, as that is already pre-translated */
 	ch.band = 1;
@@ -265,7 +265,7 @@ static int wbsoft_config(struct ieee80211_hw *dev, u32 changed)
 
 static u64 wbsoft_get_tsf(struct ieee80211_hw *dev)
 {
-	printk("wbsoft_get_tsf called\n");
+	pr_info("wbsoft_get_tsf called\n");
 	return 0;
 }
 
@@ -718,7 +718,7 @@ static int wb35_hw_init(struct ieee80211_hw *hw)
 
 	priv->sLocalPara.bAntennaNo = hal_get_antenna_number(pHwData);
 #ifdef _PE_STATE_DUMP_
-	printk("Driver init, antenna no = %d\n", psLOCAL->bAntennaNo);
+	pr_info("Driver init, antenna no = %d\n", psLOCAL->bAntennaNo);
 #endif
 	hal_get_hw_radio_off(pHwData);
 
@@ -792,7 +792,7 @@ static int wb35_probe(struct usb_interface *intf,
 	endpoint = &interface->endpoint[0].desc;
 
 	if (endpoint[2].wMaxPacketSize == 512) {
-		printk("[w35und] Working on USB 2.0\n");
+		pr_info("[w35und] Working on USB 2.0\n");
 		pWbUsb->IsUsb20 = 1;
 	}
 
@@ -850,7 +850,7 @@ static void wb35_hw_halt(struct wbsoft_priv *adapter)
 	/* Turn off Rx and Tx hardware ability */
 	hal_stop(&adapter->sHwData);
 #ifdef _PE_USB_INI_DUMP_
-	printk("[w35und] Hal_stop O.K.\n");
+	pr_info("[w35und] Hal_stop O.K.\n");
 #endif
 	/* Waiting Irp completed */
 	msleep(100);
-- 
1.7.0.4

