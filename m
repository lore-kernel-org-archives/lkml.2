Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab0DVT34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:29:56 -0400
Received: from kroah.org ([198.145.64.141]:41400 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756685Ab0DVT3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:37 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:21 2010
Message-Id: <20100422190921.620657869@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       maximilian attems <max@stro.at>
Subject: [159/197] iwlwifi: clear all tx queues when firmware ready
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit dff010ac8e57e43669518a14c0e945dfeb80c2a7 upstream.

Reset and clear all the tx queues when finished downloading runtime
uCode and ready to go into operation mode.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 ++
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -715,6 +715,8 @@ static int iwl4965_alive_notify(struct i
 
 	iwl4965_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
 
+	/* reset to 0 to enable all the queue first */
+	priv->txq_ctx_active_msk = 0;
 	/* Map each Tx/cmd queue to its corresponding fifo */
 	for (i = 0; i < ARRAY_SIZE(default_queue_to_tx_fifo); i++) {
 		int ac = default_queue_to_tx_fifo[i];
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -793,6 +793,8 @@ int iwl5000_alive_notify(struct iwl_priv
 
 	iwl5000_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
 
+	/* reset to 0 to enable all the queue first */
+	priv->txq_ctx_active_msk = 0;
 	/* map qos queues to fifos one-to-one */
 	for (i = 0; i < ARRAY_SIZE(iwl5000_default_queue_to_tx_fifo); i++) {
 		int ac = iwl5000_default_queue_to_tx_fifo[i];


