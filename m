Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab1JSPhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 11:37:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:23496 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab1JSPhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 11:37:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,372,1315206000"; 
   d="scan'208,223";a="79677000"
Subject: Re: iwlagn is getting very shaky
From: wwguy <wey-yi.w.guy@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <20111019124931.GC3963@gamma.logic.tuwien.ac.at>
References: <CAOJsxLFXBQXDtjGkuHV8fpxSy4U0dOdzBm6=4xfy2dMQo7NvOg@mail.gmail.com>
	 <1319003710.31823.53.camel@wwguy-huron>
	 <20111019064818.GB14817@gamma.logic.tuwien.ac.at>
	 <1319004938.31823.59.camel@wwguy-huron>
	 <20111019060108.GA11588@gamma.logic.tuwien.ac.at>
	 <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com>
	 <20111019062517.GC11588@gamma.logic.tuwien.ac.at>
	 <1319003304.31823.46.camel@wwguy-huron>
	 <20111019064628.GA14817@gamma.logic.tuwien.ac.at>
	 <1319004836.31823.57.camel@wwguy-huron>
	 <20111019124931.GC3963@gamma.logic.tuwien.ac.at>
Content-Type: multipart/mixed; boundary="=-cUDhd+zcP0UnhbzSAkY6"
Date: Wed, 19 Oct 2011 08:31:22 -0700
Message-ID: <1319038282.25023.21.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cUDhd+zcP0UnhbzSAkY6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi Norbert,

On Wed, 2011-10-19 at 05:49 -0700, Norbert Preining wrote:
> Hi Wey,
> 
> On Di, 18 Okt 2011, Guy, Wey-Yi wrote:
> > Could you please let me know the brand/model of the AP which having
> > problem. Also the configuration of your NIC also help.
> 
> I will try to find out as many information as possible tomorrow
> when I am back at university. I think the routers are hanging on
> the ceiling, so I can somehow check what they are.
> 
> > also, when you say you don't have problem with other router, could you
> > please be more clear, are those APs having the similar functions as the
> > one you have in university, or different? 
> 
> Well, at home I have a normal WLAN router, one where you plug on
> the one side some upstream cable and then you have several downstream
> cable (eth) and wlan.
> 
> On the university there is probably much more system since there are many
> APs and one can easily wander around. I will try to find out as
> much as possible.
> 
> Anything one can to wiht iwconfig, ethercap or similar tools?
> 
> > just got a idea, could you try to revert
> > commit#68b993118f715cc631b62b6a50574e4701fe9ace
> 
> I try it tomorrow and let you know. I tried for now to revert it
> directly without success, but I will try to do it by hand. If
> I have problems I let you know. Tomorrow, now is break time ;-)
> 
Are you connect on 5.2GHz? looks to me there were only one place can
stop the queue which is for radar channel detection.

instead of having you to revert the patch I ask you to do, could you
please just apply the patch I attach here and see if it make any
differences? it is also for debugging purpose, so please check the dmesg
log.

Thanks
Wey 

--=-cUDhd+zcP0UnhbzSAkY6
Content-Disposition: attachment; filename="0001-iwlwifi-stop-queue-testing.patch"
Content-Type: text/x-patch; name="0001-iwlwifi-stop-queue-testing.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 2a5d4b0e917948b403957b57d053d74063a2b8ff Mon Sep 17 00:00:00 2001
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date: Wed, 19 Oct 2011 08:28:02 -0700
Subject: [PATCH 1/1] iwlwifi: stop queue testing

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 863c43f..5a87071 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -812,8 +812,13 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 			if (status == TX_STATUS_FAIL_PASSIVE_NO_RX &&
 			    iwl_is_associated_ctx(ctx) && ctx->vif &&
 			    ctx->vif->type == NL80211_IFTYPE_STATION) {
+#if 0
 				ctx->last_tx_rejected = true;
 				iwl_trans_stop_queue(trans(priv), txq_id);
+#endif
+IWL_ERR(priv,
+	"Encounter TX_STATUS_FAIL_PASSIVE_NO_RX, am I on 5.2G band? (%d)\n",
+	txq_id);
 
 				IWL_DEBUG_TX_REPLY(priv,
 					   "TXQ %d status %s (0x%08x) "
-- 
1.7.0.4


--=-cUDhd+zcP0UnhbzSAkY6--

