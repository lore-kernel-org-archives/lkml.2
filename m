Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab2K0MKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 07:10:23 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:41024 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab2K0MKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 07:10:19 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 8/8] staging/rtl8187se: Use netdev_ printks in ieee80211/ieee80211_softmac_wx.c
Date: Tue, 27 Nov 2012 21:10:14 +0900
Message-Id: <1354018214-18374-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354018065-18134-1-git-send-email-yamanetoshi@gmail.com>
References: <1354018065-18134-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warning fixed.
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
index c71fb63..d9add53 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
@@ -419,8 +419,8 @@ int ieee80211_wx_set_rawtx(struct ieee80211_device *ieee,
 	else
 		ieee->raw_tx = 0;
 
-	printk(KERN_INFO"raw TX is %s\n",
-	      ieee->raw_tx ? "enabled" : "disabled");
+	netdev_info(ieee->dev, "raw TX is %s\n",
+		    ieee->raw_tx ? "enabled" : "disabled");
 
 	if (ieee->iw_mode == IW_MODE_MONITOR) {
 		if (prev == 0 && ieee->raw_tx) {
-- 
1.7.9.5

