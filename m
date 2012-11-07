Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab2KGSuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 13:50:37 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43342 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab2KGSuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 13:50:35 -0500
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 1/4] Staging: winbond: wbusb: Fixed coding style issue
Date: Thu,  8 Nov 2012 00:20:00 +0530
Message-Id: <1352314203-8092-2-git-send-email-mujeeb.adil@gmail.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
In-Reply-To: <1352314203-8092-1-git-send-email-mujeeb.adil@gmail.com>
References: <1352314203-8092-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unnecessary printk and pr_debug tracing calls

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 drivers/staging/winbond/wbusb.c |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 48aa136..3fa1ae4 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -79,18 +79,15 @@ static int wbsoft_add_interface(struct ieee80211_hw *dev,
 static void wbsoft_remove_interface(struct ieee80211_hw *dev,
 				    struct ieee80211_vif *vif)
 {
-	printk("wbsoft_remove interface called\n");
 }
 
 static void wbsoft_stop(struct ieee80211_hw *hw)
 {
-	printk(KERN_INFO "%s called\n", __func__);
 }
 
 static int wbsoft_get_stats(struct ieee80211_hw *hw,
 			    struct ieee80211_low_level_stats *stats)
 {
-	printk(KERN_INFO "%s called\n", __func__);
 	return 0;
 }
 
@@ -179,12 +176,9 @@ static void hal_set_current_channel_ex(struct hw_data *pHwData, struct chan_info
 	if (pHwData->SurpriseRemove)
 		return;
 
-	printk("Going to channel: %d/%d\n", channel.band, channel.ChanNo);
-
 	RFSynthesizer_SwitchingChannel(pHwData, channel); /* Switch channel */
 	pHwData->Channel = channel.ChanNo;
 	pHwData->band = channel.band;
-	pr_debug("Set channel is %d, band =%d\n", pHwData->Channel, pHwData->band);
 	reg->M28_MacControl &= ~0xff;	/* Clean channel information field */
 	reg->M28_MacControl |= channel.ChanNo;
 	Wb35Reg_WriteWithCallbackValue(pHwData, 0x0828, reg->M28_MacControl,
@@ -264,8 +258,6 @@ static int wbsoft_config(struct ieee80211_hw *dev, u32 changed)
 	struct wbsoft_priv *priv = dev->priv;
 	struct chan_info ch;
 
-	printk("wbsoft_config called\n");
-
 	/* Should use channel_num, or something, as that is already pre-translated */
 	ch.band = 1;
 	ch.ChanNo = 1;
@@ -282,7 +274,6 @@ static int wbsoft_config(struct ieee80211_hw *dev, u32 changed)
 
 static u64 wbsoft_get_tsf(struct ieee80211_hw *dev, struct ieee80211_vif *vif)
 {
-	printk("wbsoft_get_tsf called\n");
 	return 0;
 }
 
@@ -716,7 +707,6 @@ static int wb35_hw_init(struct ieee80211_hw *hw)
 	}
 
 	priv->sLocalPara.bAntennaNo = hal_get_antenna_number(pHwData);
-	pr_debug("Driver init, antenna no = %d\n", priv->sLocalPara.bAntennaNo);
 	hal_get_hw_radio_off(pHwData);
 
 	/* Waiting for HAL setting OK */
@@ -782,9 +772,6 @@ static int wb35_probe(struct usb_interface *intf,
 	interface = intf->cur_altsetting;
 	endpoint = &interface->endpoint[0].desc;
 
-	if (endpoint[2].wMaxPacketSize == 512)
-		printk("[w35und] Working on USB 2.0\n");
-
 	err = wb35_hw_init(dev);
 	if (err)
 		goto error_free_hw;
@@ -836,7 +823,6 @@ static void wb35_hw_halt(struct wbsoft_priv *adapter)
 {
 	/* Turn off Rx and Tx hardware ability */
 	hal_stop(&adapter->sHwData);
-	pr_debug("[w35und] Hal_stop O.K.\n");
 	/* Waiting Irp completed */
 	msleep(100);
 
-- 
1.7.10.2

