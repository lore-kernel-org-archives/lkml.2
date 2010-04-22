Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534Ab0DVUbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:31:05 -0400
Received: from kroah.org ([198.145.64.141]:59461 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757906Ab0DVT7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:59:47 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:06 2010
Message-Id: <20100422195406.530319760@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>
Subject: [018/139] iwlwifi: counting number of tfds can be free for 4965
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit be6b38bcb175613f239e0b302607db346472c6b6 upstream.

Forget one hunk in 4965 during "iwlwifi: error checking for number of tfds
in queue" patch.

Reported-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2034,16 +2034,14 @@ static void iwl4965_rx_reply_tx(struct i
 				   tx_resp->failure_frame);
 
 		freed = iwl_tx_queue_reclaim(priv, txq_id, index);
-		if (qc && likely(sta_id != IWL_INVALID_STATION))
-			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
+		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
 		if (priv->mac80211_registered &&
 		    (iwl_queue_space(&txq->q) > txq->q.low_mark))
 			iwl_wake_queue(priv, txq_id);
 	}
 
-	if (qc && likely(sta_id != IWL_INVALID_STATION))
-		iwl_txq_check_empty(priv, sta_id, tid, txq_id);
+	iwl_txq_check_empty(priv, sta_id, tid, txq_id);
 
 	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
 		IWL_ERR(priv, "TODO:  Implement Tx ABORT REQUIRED!!!\n");


