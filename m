Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab0EXX0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:26:44 -0400
Received: from kroah.org ([198.145.64.141]:59503 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932655Ab0EXXXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:53 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:16 2010
Message-Id: <20100524231816.247809931@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>
Subject: [34/39] iwlwifi: clear all the stop_queue flag after load firmware
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit a9e10fb9b1c6ad16e73cf2656951fce3a817611e upstream.

All the queues are awake and ready to use after loading firmware,
for firmware reload case, if any queues was stopped before
reload, mac80211 will wake those queues after restart hardware, so make
sure all the flag used to keep track of the queue status are
reset correctly.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-5000.c |    5 +++++
 2 files changed, 10 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -581,6 +581,11 @@ static int iwl4965_alive_notify(struct i
 
 	iwl4965_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
 
+	/* make sure all queue are not stopped */
+	memset(&priv->queue_stopped[0], 0, sizeof(priv->queue_stopped));
+	for (i = 0; i < 4; i++)
+		atomic_set(&priv->queue_stop_count[i], 0);
+
 	/* reset to 0 to enable all the queue first */
 	priv->txq_ctx_active_msk = 0;
 	/* Map each Tx/cmd queue to its corresponding fifo */
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -657,6 +657,11 @@ int iwl5000_alive_notify(struct iwl_priv
 
 	iwl5000_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
 
+	/* make sure all queue are not stopped */
+	memset(&priv->queue_stopped[0], 0, sizeof(priv->queue_stopped));
+	for (i = 0; i < 4; i++)
+		atomic_set(&priv->queue_stop_count[i], 0);
+
 	/* reset to 0 to enable all the queue first */
 	priv->txq_ctx_active_msk = 0;
 	/* map qos queues to fifos one-to-one */


