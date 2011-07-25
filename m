Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab1GYTih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 15:38:37 -0400
Received: from home.keithp.com ([63.227.221.253]:53390 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab1GYTie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 15:38:34 -0400
From: Keith Packard <keithp@keithp.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH] iwlagn: check for !priv->txq in iwlagn_wait_tx_queue_empty
Date: Mon, 25 Jul 2011 12:38:22 -0700
Message-Id: <1311622702-4807-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the interface is down, txq is NULL. iwlagn_wait_tx_queue_empty
needs to check for this case to avoid dereferencing that pointer.

Signed-off-by: Keith Packard <keithp@keithp.com>
---

This is on top of v3.0

 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index f803fb6..d6ae444 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1487,6 +1487,9 @@ int iwlagn_wait_tx_queue_empty(struct iwl_priv *priv)
 	unsigned long now = jiffies;
 	int ret = 0;
 
+	if (!priv->txq)
+		return 0;
+
 	/* waiting for all the tx frames complete might take a while */
 	for (cnt = 0; cnt < priv->hw_params.max_txq_num; cnt++) {
 		if (cnt == priv->cmd_queue)
-- 
1.7.5.4

