Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab1INDFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 23:05:47 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:41930 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab1INDFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 23:05:46 -0400
Date: Wed, 14 Sep 2011 13:05:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        "Wey-Yi Guy" <wey-yi.w.guy@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: linux-next: manual merge of the wireless tree with the
 wireless-current tree
Message-Id: <20110914130542.7a5af71c56a545bff8996690@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c between commit
282cdb325aea ("iwlagn: fix command queue timeout") from the
wireless-current tree and commit 6d8f6eeb3506 ("iwlagn: transport layer
should receive iwl_trans") from the wireless tree.

Just context changes.  I fixed ti up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 222d410,ea6a0bc..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@@ -771,9 -921,8 +921,10 @@@ void iwl_tx_cmd_complete(struct iwl_pri
  	cmd = txq->cmd[cmd_index];
  	meta = &txq->meta[cmd_index];
  
 +	txq->time_stamp = jiffies;
 +
- 	iwlagn_unmap_tfd(priv, meta, &txq->tfds[index], DMA_BIDIRECTIONAL);
+ 	iwlagn_unmap_tfd(trans, meta, &txq->tfds[index],
+ 			 DMA_BIDIRECTIONAL);
  
  	/* Input error checking is done when commands are added to queue. */
  	if (meta->flags & CMD_WANT_SKB) {
