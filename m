Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab2KTMMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:12:03 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55427 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2KTML7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:11:59 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 07/16] staging/rtl8187se: Use netdev_ printks in ieee80211/ieee80211_module.c
Date: Tue, 20 Nov 2012 21:11:54 +0900
Message-Id: <1353413514-24649-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353413395-24444-1-git-send-email-yamanetoshi@gmail.com>
References: <1353413395-24444-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warning fixed.
- WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 .../staging/rtl8187se/ieee80211/ieee80211_module.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
index 0ed4c93..66b4833 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
@@ -69,8 +69,7 @@ static inline int ieee80211_networks_allocate(struct ieee80211_device *ieee)
 		MAX_NETWORK_COUNT, sizeof(struct ieee80211_network),
 		GFP_KERNEL);
 	if (!ieee->networks) {
-		printk(KERN_WARNING "%s: Out of memory allocating beacons\n",
-		       ieee->dev->name);
+		netdev_warn(ieee->dev,  "Out of memory allocating beacons\n");
 		return -ENOMEM;
 	}
 
-- 
1.7.9.5

