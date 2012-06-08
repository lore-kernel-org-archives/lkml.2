Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762009Ab2FHF04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:26:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43163 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760278Ab2FHFHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:16 -0400
Message-Id: <20120608041843.688487854@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 21/82] iwlwifi: update BT traffic load states correctly
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

commit 882dde8eb0d49ce0f853f8f4084dde56a21fe55f upstream.

When BT traffic load changes from its
previous state, a new LQ command needs to be
sent down to the firmware. This needs to
be done only once per change. The state
variable that keeps track of this change is
last_bt_traffic_load. However, it was not
being updated when the change had been
handled. Not updating this variable was
causing a flood of advanced BT config
commands to be sent to the firmware. Fix
this.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 51e1a69..8cebd7c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -884,6 +884,7 @@ static void rs_bt_update_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	if ((priv->bt_traffic_load != priv->last_bt_traffic_load) ||
 	    (priv->bt_full_concurrent != full_concurrent)) {
 		priv->bt_full_concurrent = full_concurrent;
+		priv->last_bt_traffic_load = priv->bt_traffic_load;
 
 		/* Update uCode's rate table. */
 		tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);


