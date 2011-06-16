Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab1FPHCC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:02:02 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:32965 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756161Ab1FPHBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:55 -0400
X-Sasl-enc: QtJdbLoTloHwRtcGKzrrAn6tatoJ9DwKxntD69c0EQag 1308207714
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:37 2011
Message-Id: <20110616000237.482912901@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [87/89] iwlagn: send tx power command if defer cause by RXON not
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 match

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit 43e4e0b94984b45d52048e3ac027cac15c718b65 upstream.

During channge channel, tx power will not send to uCode, the tx power command
should send after scan complete. but should also can send after RXON command.

Stable fix identified by Stanislaw Gruszka <sgruszka@redhat.com>.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -218,6 +218,11 @@ int iwlagn_commit_rxon(struct iwl_priv *
 
 		memcpy(active, &ctx->staging, sizeof(*active));
 		iwl_print_rx_config_cmd(priv, ctx);
+		/*
+		 * We do not commit tx power settings while channel changing,
+		 * do it now if after settings changed.
+		 */
+		iwl_set_tx_power(priv, priv->tx_power_next, false);
 		return 0;
 	}
 


