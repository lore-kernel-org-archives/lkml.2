Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab2FQS0o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:26:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50387 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758584Ab2FQSXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:23:00 -0400
Message-Id: <20120617175945.299872050@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:09 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes.berg@intel.com>,
        Sebastian Kemper <sebastian_ml@gmx.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 28/69] iwlwifi: disable WoWLAN if !CONFIG_PM_SLEEP
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit fcb6ff5e2cb83e1de10631f6621f45ca3401bf61 upstream.

If CONFIG_PM_SLEEP is disabled, then iwlwifi doesn't
support suspend/resume handlers and thus mac80211
(correctly) refuses advertising WoWLAN. Disable
WoWLAN in the driver in this case.

Reported-by: Sebastian Kemper <sebastian_ml@gmx.net>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1696,6 +1696,7 @@
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
 			    WIPHY_FLAG_IBSS_RSN;
 
+#ifdef CONFIG_PM_SLEEP
 	if (priv->ucode_wowlan.code.len && device_can_wakeup(bus(priv)->dev)) {
 		hw->wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
 					  WIPHY_WOWLAN_DISCONNECT |
@@ -1712,6 +1713,7 @@
 		hw->wiphy->wowlan.pattern_max_len =
 					IWLAGN_WOWLAN_MAX_PATTERN_LEN;
 	}
+#endif
 
 	if (iwlagn_mod_params.power_save)
 		hw->wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;


