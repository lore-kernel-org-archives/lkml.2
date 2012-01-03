Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab2ACWpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:45:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40519 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112Ab2ACWmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:42:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:27 2012
Message-Id: <20120103223327.333831691@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:33:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [74/75] iwlwifi: update SCD BC table for all SCD queues
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 96f1f05af76b601ab21a7dc603ae0a1cea4efc3d upstream.

Since we configure all the queues as CHAINABLE, we need to update the
byte count for all the queues, not only the AGGREGATABLE ones.

Not doing so can confuse the SCD and make the fw assert.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-trans.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -1068,9 +1068,7 @@ static int iwl_trans_tx(struct iwl_priv
 	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
 
 	/* Set up entry for this TFD in Tx byte-count array */
-	if (ampdu)
-		iwl_trans_txq_update_byte_cnt_tbl(priv, txq,
-					       le16_to_cpu(tx_cmd->len));
+	iwl_trans_txq_update_byte_cnt_tbl(priv, txq, le16_to_cpu(tx_cmd->len));
 
 	dma_sync_single_for_device(priv->bus->dev, txcmd_phys, firstlen,
 			DMA_BIDIRECTIONAL);


