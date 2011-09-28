Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab1I1Wu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:50:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978Ab1I1WuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:50:24 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:50 2011
Message-Id: <20110928220150.474305999@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:03:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [238/244] iwlegacy: fix command queue timeout
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 2e2a41d6ca07d1b2aa67015c35fd80701c98e867 upstream.

iwlegacy version of fix:

commit 282cdb325aea4ebbc42ce753b47cc96145eb54bc
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Mon Sep 12 12:09:10 2011 -0700

    iwlagn: fix command queue timeout

    If the command queue is constantly busy,
    which can happen in P2P, the hangcheck
    timer will frequently find a command in
    it and will eventually reset the device
    because nothing sets the timestamp for
    this queue when commands are processed.

    Fix this by setting the timestamp when
    a command completes.

iwlegacy does not support P2P, but this patch fix possible
unneeded hardware resets, hence is needed.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlegacy/iwl-tx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/iwlegacy/iwl-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-tx.c
@@ -625,6 +625,8 @@ iwl_legacy_tx_cmd_complete(struct iwl_pr
 	cmd = txq->cmd[cmd_index];
 	meta = &txq->meta[cmd_index];
 
+	txq->time_stamp = jiffies;
+
 	pci_unmap_single(priv->pci_dev,
 			 dma_unmap_addr(meta, mapping),
 			 dma_unmap_len(meta, len),


