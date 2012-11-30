Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993396Ab2K3TMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:12:14 -0500
Received: from mail.kernel.org ([198.145.19.201]:59542 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992968Ab2K3TCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:02:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 06/54] iwlwifi: dont WARN when a non empty queue is disabled
Date: Fri, 30 Nov 2012 10:55:37 -0800
Message-Id: <20121130185208.531458071@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit e1b69fdf33f63cfa600b992172d7376f9d9ef2e9 upstream.

This can happen when we shut down suddenly an interface.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/pcie/tx.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -480,20 +480,12 @@ void iwl_trans_pcie_txq_enable(struct iw
 void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	u16 rd_ptr, wr_ptr;
-	int n_bd = trans_pcie->txq[txq_id].q.n_bd;
 
 	if (!test_and_clear_bit(txq_id, trans_pcie->queue_used)) {
 		WARN_ONCE(1, "queue %d not used", txq_id);
 		return;
 	}
 
-	rd_ptr = iwl_read_prph(trans, SCD_QUEUE_RDPTR(txq_id)) & (n_bd - 1);
-	wr_ptr = iwl_read_prph(trans, SCD_QUEUE_WRPTR(txq_id));
-
-	WARN_ONCE(rd_ptr != wr_ptr, "queue %d isn't empty: [%d,%d]",
-		  txq_id, rd_ptr, wr_ptr);
-
 	iwl_txq_set_inactive(trans, txq_id);
 	IWL_DEBUG_TX_QUEUES(trans, "Deactivate queue %d\n", txq_id);
 }


