Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab0DIWc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:32:57 -0400
Received: from mga07.intel.com ([143.182.124.22]:39076 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751685Ab0DIWcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:32:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,179,1270450800"; 
   d="scan'208";a="264031534"
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 1/3] rtl8187se: Do not autoconnect based on probe response
Date: Sat, 10 Apr 2010 00:33:17 +0200
Message-Id: <88c95ee97a6c78f2175c6f6b2bda7b617540de31.1270851261.git.sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Getting a probe response after sending a probe request to a specific SSID
doesnt mean we're trying to associate with this SSID.
wpa_supplicant should be the only one deciding when to join an SSID, not the
kernel.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
index 2b7080c..3a72449 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -1489,8 +1489,6 @@ inline void ieee80211_process_probe_response(
 
 		memcpy(target, &network, sizeof(*target));
 		list_add_tail(&target->list, &ieee->network_list);
-		if(ieee->softmac_features & IEEE_SOFTMAC_ASSOCIATE)
-			ieee80211_softmac_new_net(ieee,&network);
 	} else {
 		IEEE80211_DEBUG_SCAN("Updating '%s' (%pM) via %s.\n",
 				     escape_essid(target->ssid,
@@ -1516,8 +1514,6 @@ inline void ieee80211_process_probe_response(
 			renew = 1;
 		//YJ,add,080819,for hidden ap,end
 		update_network(target, &network);
-		if(renew && (ieee->softmac_features & IEEE_SOFTMAC_ASSOCIATE))
-			ieee80211_softmac_new_net(ieee,&network);
 	}
 
 	spin_unlock_irqrestore(&ieee->lock, flags);
-- 
1.7.0

