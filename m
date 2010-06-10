Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348Ab0FJOzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:55:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:28063 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759337Ab0FJOzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:55:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,398,1272870000"; 
   d="scan'208";a="806653047"
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 2/3] Staging: rtl8192e: Do not autoconnect based on probe response
Date: Thu, 10 Jun 2010 16:54:17 +0200
Message-Id: <1276181658-20379-2-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1276181658-20379-1-git-send-email-sameo@linux.intel.com>
References: <1276181658-20379-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Getting a probe response after sending a probe request to a specific SSID
doesnt mean we're trying to associate with this SSID.
wpa_supplicant should be the only one deciding when to join an SSID, not the
kernel.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
index da10067..d33ed64 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
@@ -2793,8 +2793,6 @@ static inline void ieee80211_process_probe_response(
 #endif
 		memcpy(target, &network, sizeof(*target));
 		list_add_tail(&target->list, &ieee->network_list);
-		if(ieee->softmac_features & IEEE_SOFTMAC_ASSOCIATE)
-			ieee80211_softmac_new_net(ieee,&network);
 	} else {
 		IEEE80211_DEBUG_SCAN("Updating '%s' (%pM) via %s.\n",
 				     escape_essid(target->ssid,
@@ -2821,8 +2819,6 @@ static inline void ieee80211_process_probe_response(
 		//YJ,add,080819,for hidden ap,end
 
 		update_network(target, &network);
-		if(renew && (ieee->softmac_features & IEEE_SOFTMAC_ASSOCIATE))
-			ieee80211_softmac_new_net(ieee,&network);
 	}
 
 	spin_unlock_irqrestore(&ieee->lock, flags);
-- 
1.7.0

