Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab1FPHay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:30:54 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34462 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755978Ab1FPHBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:40 -0400
X-Sasl-enc: W9uQrD/X8BwksLDT7LwqE/sYKSovXBsOK1O9VQMIWZYj 1308207699
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:36 2011
Message-Id: <20110616000236.558594752@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [77/89] iwl4965: set tx power after rxon_assoc
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 51892dbbd511911c0f965a36b431fc3e8f1e4f8a upstream.

Setting tx power can be deferred during scan or changing channel.
If after that correct tx power settings will not be sent to device,
we can observe transmission problems and timeouts. Force to send
tx power settings also after partial rxon change, to assure device
always be configured with up-to-date settings.

Resolves:
https://bugzilla.kernel.org/show_bug.cgi?id=36492

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlegacy/iwl-4965.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -1237,7 +1237,7 @@ static int iwl4965_commit_rxon(struct iw
 
 		memcpy(active_rxon, &ctx->staging, sizeof(*active_rxon));
 		iwl_legacy_print_rx_config_cmd(priv, ctx);
-		return 0;
+		goto set_tx_power;
 	}
 
 	/* If we are currently associated and the new config requires
@@ -1317,6 +1317,7 @@ static int iwl4965_commit_rxon(struct iw
 
 	iwl4965_init_sensitivity(priv);
 
+set_tx_power:
 	/* If we issue a new RXON command which required a tune then we must
 	 * send a new TXPOWER command or we won't be able to Tx any frames */
 	ret = iwl_legacy_set_tx_power(priv, priv->tx_power_next, true);


