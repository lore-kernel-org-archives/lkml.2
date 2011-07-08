Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab1GHFFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:05:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42541 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034Ab1GHFFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:05:35 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:01 2011
Message-Id: <20110708001701.763821466@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:17:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [093/107] iwlagn: fix change_interface for P2P types
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 5306c0807491e891125f4fb08b04340c91530f57 upstream.

When an interface changes type to a P2P type,
iwlagn will erroneously set vif->type to the
P2P type and not the reduced/split type. Fix
this by keeping "newtype" in another variable
for the assignment to vif->type.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1772,6 +1772,7 @@ int iwl_mac_change_interface(struct ieee
 	struct iwl_priv *priv = hw->priv;
 	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
 	struct iwl_rxon_context *tmp;
+	enum nl80211_iftype newviftype = newtype;
 	u32 interface_modes;
 	int err;
 
@@ -1814,7 +1815,7 @@ int iwl_mac_change_interface(struct ieee
 
 	/* success */
 	iwl_teardown_interface(priv, vif, true);
-	vif->type = newtype;
+	vif->type = newviftype;
 	vif->p2p = newp2p;
 	err = iwl_setup_interface(priv, ctx);
 	WARN_ON(err);


