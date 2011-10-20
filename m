Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab1JTCW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 22:22:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:42874 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab1JTCWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 22:22:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208,223";a="64884452"
Subject: Re: iwlagn is getting very shaky
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <20111020020225.GO11060@gamma.logic.tuwien.ac.at>
References: <20111019064818.GB14817@gamma.logic.tuwien.ac.at>
	 <1319004938.31823.59.camel@wwguy-huron>
	 <20111019060108.GA11588@gamma.logic.tuwien.ac.at>
	 <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com>
	 <20111019062517.GC11588@gamma.logic.tuwien.ac.at>
	 <1319003304.31823.46.camel@wwguy-huron>
	 <20111019064628.GA14817@gamma.logic.tuwien.ac.at>
	 <1319004836.31823.57.camel@wwguy-huron>
	 <20111019124931.GC3963@gamma.logic.tuwien.ac.at>
	 <1319038282.25023.21.camel@wwguy-ubuntu>
	 <20111020020225.GO11060@gamma.logic.tuwien.ac.at>
Content-Type: multipart/mixed; boundary="=-Ne6W6dbUGApePatbqTax"
Date: Wed, 19 Oct 2011 18:32:19 -0700
Message-ID: <1319074339.31823.68.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ne6W6dbUGApePatbqTax
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2011-10-19 at 19:02 -0700, Norbert Preining wrote:
> On Mi, 19 Okt 2011, wwguy wrote:
> > instead of having you to revert the patch I ask you to do, could you
> > please just apply the patch I attach here and see if it make any
> > differences? it is also for debugging purpose, so please check the dmesg
> > log.
> 
> Do you mean the patch you send with a strange date:
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
> b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
> index 863c43f..5a87071 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
> @@ -812,8 +812,13 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct
> iwl_rx_mem_buffer *rxb,
>                         if (status == TX_STATUS_FAIL_PASSIVE_NO_RX &&
>                             iwl_is_associated_ctx(ctx) && ctx->vif &&
>                             ctx->vif->type == NL80211_IFTYPE_STATION) {
> +#if 0
>                                 ctx->last_tx_rejected = true;
>                                 iwl_trans_stop_queue(trans(priv), txq_id);
> +#endif
> +IWL_ERR(priv,
> +       "Encounter TX_STATUS_FAIL_PASSIVE_NO_RX, am I on 5.2G band? (%d)\n",
> +       txq_id);
> 
>                                 IWL_DEBUG_TX_REPLY(priv,
>                                            "TXQ %d status %s (0x%08x) "
> --
> 1.7.0.4
> 
> It does not apply at all, I cannot even find
> 	rejected
> in iwl-agn-tx.c.
> 
> On which tree is that based, can you provide a patch against main
> git branch of Linus.
> 
> Thanks.
> 
Let's try this and see if apply. btw, are you on 5GHz?

Thanks
Wey


--=-Ne6W6dbUGApePatbqTax
Content-Disposition: attachment; filename="0001-iwlagn-stop-queue-testing.patch"
Content-Type: text/x-patch; name="0001-iwlagn-stop-queue-testing.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 78e955b90a8e259d180bfb962ef4558645d74a91 Mon Sep 17 00:00:00 2001
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date: Wed, 19 Oct 2011 18:27:41 -0700
Subject: [PATCH 1/1] iwlagn: stop queue testing

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 3bee0f1..d543686 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -191,8 +191,14 @@ static void iwlagn_set_tx_status(struct iwl_priv *priv,
 	if (status == TX_STATUS_FAIL_PASSIVE_NO_RX &&
 	    iwl_is_associated_ctx(ctx) && ctx->vif &&
 	    ctx->vif->type == NL80211_IFTYPE_STATION) {
+#if 0
 		ctx->last_tx_rejected = true;
 		iwl_stop_queue(priv, &priv->txq[txq_id]);
+#endif
+IWL_ERR(priv,
+       "Encounter TX_STATUS_FAIL_PASSIVE_NO_RX, am I on 5.2G band? (%d)\n",
+       txq_id);
+
 	}
 
 	IWL_DEBUG_TX_REPLY(priv, "TXQ %d status %s (0x%08x) rate_n_flags "
-- 
1.7.0.4


--=-Ne6W6dbUGApePatbqTax--

