Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284Ab2FGEWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:22:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235Ab2FGEWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:22:34 -0400
Message-Id: <20120607041358.910470464@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:14:03 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 05/47] iwlwifi: update BT traffic load states correctly
In-Reply-To: <20120607041504.GA13819@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -878,6 +878,7 @@ static void rs_bt_update_lq(struct iwl_p
 	if ((priv->bt_traffic_load != priv->last_bt_traffic_load) ||
 	    (priv->bt_full_concurrent != full_concurrent)) {
 		priv->bt_full_concurrent = full_concurrent;
+		priv->last_bt_traffic_load = priv->bt_traffic_load;
 
 		/* Update uCode's rate table. */
 		tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);


