Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab0DVUnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:43:08 -0400
Received: from kroah.org ([198.145.64.141]:37318 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756100Ab0DVT1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:52 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:10 2010
Message-Id: <20100422190910.327251286@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Stefan Bader <stefan.bader@canonical.com>
Subject: [033/197] iwlwifi: fix nfreed--
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

During backporting of a120e912eb51e347f36c71b60a1d13af74d30e83
("iwlwifi: sanity check before counting number of tfds can be free")
we forget one hunk, what make lot of messages "free more than
tfds_in_queue" show up in dmesg.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Tested-by: Adel Gadllah <adel.gadllah@gmail.com>
(picked from https://patchwork.kernel.org/patch/86722/)
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1097,7 +1097,6 @@ int iwl_tx_queue_reclaim(struct iwl_priv
 			priv->cfg->ops->lib->txq_inval_byte_cnt_tbl(priv, txq);
 
 		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
-		nfreed++;
 	}
 	return nfreed;
 }


