Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab1JTCCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 22:02:36 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:56828 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab1JTCCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 22:02:35 -0400
Date: Thu, 20 Oct 2011 11:02:25 +0900
From: Norbert Preining <preining@logic.at>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111020020225.GO11060@gamma.logic.tuwien.ac.at>
References: <20111019064818.GB14817@gamma.logic.tuwien.ac.at> <1319004938.31823.59.camel@wwguy-huron> <20111019060108.GA11588@gamma.logic.tuwien.ac.at> <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com> <20111019062517.GC11588@gamma.logic.tuwien.ac.at> <1319003304.31823.46.camel@wwguy-huron> <20111019064628.GA14817@gamma.logic.tuwien.ac.at> <1319004836.31823.57.camel@wwguy-huron> <20111019124931.GC3963@gamma.logic.tuwien.ac.at> <1319038282.25023.21.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319038282.25023.21.camel@wwguy-ubuntu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mi, 19 Okt 2011, wwguy wrote:
> instead of having you to revert the patch I ask you to do, could you
> please just apply the patch I attach here and see if it make any
> differences? it is also for debugging purpose, so please check the dmesg
> log.

Do you mean the patch you send with a strange date:
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 863c43f..5a87071 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -812,8 +812,13 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct
iwl_rx_mem_buffer *rxb,
                        if (status == TX_STATUS_FAIL_PASSIVE_NO_RX &&
                            iwl_is_associated_ctx(ctx) && ctx->vif &&
                            ctx->vif->type == NL80211_IFTYPE_STATION) {
+#if 0
                                ctx->last_tx_rejected = true;
                                iwl_trans_stop_queue(trans(priv), txq_id);
+#endif
+IWL_ERR(priv,
+       "Encounter TX_STATUS_FAIL_PASSIVE_NO_RX, am I on 5.2G band? (%d)\n",
+       txq_id);

                                IWL_DEBUG_TX_REPLY(priv,
                                           "TXQ %d status %s (0x%08x) "
--
1.7.0.4

It does not apply at all, I cannot even find
	rejected
in iwl-agn-tx.c.

On which tree is that based, can you provide a patch against main
git branch of Linus.

Thanks.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
BROMPTON
A bromton is that which is said to have been committed when you are
convinced you are about to blow off with a resounding trumpeting noise
in a public place and all that actually slips out is a tiny 'pfpt'.
			--- Douglas Adams, The Meaning of Liff
