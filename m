Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab2ACWht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:37:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666Ab2ACWhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:37:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:36 2012
Message-Id: <20120103223036.543211022@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:30:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [62/67] iwlwifi: update SCD BC table for all SCD queues
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 96f1f05af76b601ab21a7dc603ae0a1cea4efc3d upstream.

Since we configure all the queues as CHAINABLE, we need to update the
byte count for all the queues, not only the AGGREGATABLE ones.

Not doing so can confuse the SCD and make the fw assert.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>

---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -778,10 +778,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv,
 	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd, sizeof(*tx_cmd));
 	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
 
-	/* Set up entry for this TFD in Tx byte-count array */
-	if (info->flags & IEEE80211_TX_CTL_AMPDU)
-		iwlagn_txq_update_byte_cnt_tbl(priv, txq,
-					       le16_to_cpu(tx_cmd->len));
+	iwlagn_txq_update_byte_cnt_tbl(priv, txq, le16_to_cpu(tx_cmd->len));
 
 	pci_dma_sync_single_for_device(priv->pci_dev, txcmd_phys,
 				       firstlen, PCI_DMA_BIDIRECTIONAL);


