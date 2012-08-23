Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595Ab2HWHTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 03:19:39 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64283 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab2HWHTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 03:19:37 -0400
MIME-Version: 1.0
Date: Thu, 23 Aug 2012 15:19:37 +0800
Message-ID: <CAPgLHd_3TGQDN3o-y8Kc=7wFjSYPWkLkBqi26fyckp4JY7YQ7Q@mail.gmail.com>
Subject: [PATCH] Staging: rtl8192u: use is_zero_ether_addr() instead of memcmp()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using is_zero_ether_addr() instead of directly use
memcmp() to determine if the ethernet address is all
zeros.

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
index cb5a3c3..421da8a 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
@@ -14,6 +14,8 @@
  */
 
 
+#include <linux/etherdevice.h>
+
 #include "ieee80211.h"
 #include "dot11d.h"
 /* FIXME: add A freqs */
@@ -136,7 +138,6 @@ int ieee80211_wx_set_wap(struct ieee80211_device *ieee,
 {
 
 	int ret = 0;
-	u8 zero[] = {0,0,0,0,0,0};
 	unsigned long flags;
 
 	short ifup = ieee->proto_started;//dev->flags & IFF_UP;
@@ -165,7 +166,7 @@ int ieee80211_wx_set_wap(struct ieee80211_device *ieee,
 	spin_lock_irqsave(&ieee->lock, flags);
 
 	memcpy(ieee->current_network.bssid, temp->sa_data, ETH_ALEN);
-	ieee->wap_set = memcmp(temp->sa_data, zero,ETH_ALEN)!=0;
+	ieee->wap_set = !is_zero_ether_addr(temp->sa_data);
 
 	spin_unlock_irqrestore(&ieee->lock, flags);
 


