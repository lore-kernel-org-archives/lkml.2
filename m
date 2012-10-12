Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881Ab2JLQht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:37:49 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:53171 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759867Ab2JLQhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:37:47 -0400
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 1/9] Staging: winbond: wbusb: Fixed coding style issue
Date: Fri, 12 Oct 2012 22:07:07 +0530
Message-Id: <1350059835-5408-2-git-send-email-mujeeb.adil@gmail.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
In-Reply-To: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
References: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unnecessary printk and pr_debug tracing calls

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.6-rc7/drivers/staging/winbond/wbusb.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/linux-3.6-rc7/drivers/staging/winbond/wbusb.c b/linux-3.6-rc7/drivers/staging/winbond/wbusb.c
index 0ca857a..a0497ea 100644
--- a/linux-3.6-rc7/drivers/staging/winbond/wbusb.c
+++ b/linux-3.6-rc7/drivers/staging/winbond/wbusb.c
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
 
@@ -177,12 +174,9 @@ static void hal_set_current_channel_ex(struct hw_data *pHwData, struct chan_info
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
@@ -262,8 +256,6 @@ static int wbsoft_config(struct ieee80211_hw *dev, u32 changed)
 	struct wbsoft_priv *priv = dev->priv;
 	struct chan_info ch;
 
-	printk("wbsoft_config called\n");
-
 	/* Should use channel_num, or something, as that is already pre-translated */
 	ch.band = 1;
 	ch.ChanNo = 1;
@@ -280,7 +272,6 @@ static int wbsoft_config(struct ieee80211_hw *dev, u32 changed)
 
 static u64 wbsoft_get_tsf(struct ieee80211_hw *dev, struct ieee80211_vif *vif)
 {
-	printk("wbsoft_get_tsf called\n");
 	return 0;
 }
 
@@ -714,7 +705,6 @@ static int wb35_hw_init(struct ieee80211_hw *hw)
 	}
 
 	priv->sLocalPara.bAntennaNo = hal_get_antenna_number(pHwData);
-	pr_debug("Driver init, antenna no = %d\n", priv->sLocalPara.bAntennaNo);
 	hal_get_hw_radio_off(pHwData);
 
 	/* Waiting for HAL setting OK */
@@ -780,9 +770,6 @@ static int wb35_probe(struct usb_interface *intf,
 	interface = intf->cur_altsetting;
 	endpoint = &interface->endpoint[0].desc;
 
-	if (endpoint[2].wMaxPacketSize == 512)
-		printk("[w35und] Working on USB 2.0\n");
-
 	err = wb35_hw_init(dev);
 	if (err)
 		goto error_free_hw;
@@ -834,7 +821,6 @@ static void wb35_hw_halt(struct wbsoft_priv *adapter)
 {
 	/* Turn off Rx and Tx hardware ability */
 	hal_stop(&adapter->sHwData);
-	pr_debug("[w35und] Hal_stop O.K.\n");
 	/* Waiting Irp completed */
 	msleep(100);
 
-- 
1.7.7.3

