Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab2K2NgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 08:36:13 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45860 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2K2NgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 08:36:12 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 4/4] staging/rtl8187se: Use netdev_ printks in ieee80211/ieee80211_wx.c
Date: Thu, 29 Nov 2012 22:36:07 +0900
Message-Id: <1354196167-12218-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354196079-11726-1-git-send-email-yamanetoshi@gmail.com>
References: <1354196079-11726-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings fixed.
-WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...
-WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
index 9d46087..e014f7e 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
@@ -336,9 +336,8 @@ int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 			kfree(new_crypt);
 			new_crypt = NULL;
 
-			printk(KERN_WARNING "%s: could not initialize WEP: "
-			       "load module ieee80211_crypt_wep\n",
-			       dev->name);
+			netdev_warn(ieee->dev,
+				    "could not initialize WEP: load module ieee80211_crypt_wep\n");
 			return -EOPNOTSUPP;
 		}
 		*crypt = new_crypt;
@@ -410,7 +409,7 @@ int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 	if (ieee->reset_on_keychange &&
 	    ieee->iw_mode != IW_MODE_INFRA &&
 	    ieee->reset_port && ieee->reset_port(dev)) {
-		printk(KERN_DEBUG "%s: reset_port failed\n", dev->name);
+		netdev_dbg(ieee->dev, "reset_port failed\n");
 		return -EINVAL;
 	}
 	return 0;
-- 
1.7.9.5

