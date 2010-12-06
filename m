Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab0LFWHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:07:50 -0500
Received: from mail.perches.com ([173.55.12.10]:2347 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab0LFWFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:23 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/29] drivers/net/wireless/iwlwifi: Update WARN uses
Date: Mon,  6 Dec 2010 14:05:02 -0800
Message-Id: <a72e00ab35733f5b87a6d1c40f8e13974ad0b567.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Align arguments.
Add missing newlines.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    3 +--
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    6 +++---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 407f0bb..31544bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -2153,8 +2153,7 @@ static int iwl_get_idle_rx_chain_count(struct iwl_priv *priv, int active_cnt)
 	case IEEE80211_SMPS_OFF:
 		return active_cnt;
 	default:
-		WARN(1, "invalid SMPS mode %d",
-		     priv->current_ht_config.smps);
+		WARN(1, "invalid SMPS mode %d\n", priv->current_ht_config.smps);
 		return active_cnt;
 	}
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 35f085a..4c0cd09 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -284,7 +284,7 @@ static int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
 	 * in uCode. */
 
 	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
-		"no space for a new key");
+	     "no space for a new key\n");
 
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
@@ -334,7 +334,7 @@ static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 	 * in uCode. */
 
 	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
-		"no space for a new key");
+	     "no space for a new key\n");
 
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
@@ -378,7 +378,7 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 	 * in uCode. */
 
 	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
-		"no space for a new key");
+	     "no space for a new key\n");
 
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 90659bc..5e82466 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -602,9 +602,9 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	 * in the queue management code. */
 	if (WARN(txq_id != priv->cmd_queue,
 		 "wrong command queue %d (should be %d), sequence 0x%X readp=%d writep=%d\n",
-		  txq_id, priv->cmd_queue, sequence,
-		  priv->txq[priv->cmd_queue].q.read_ptr,
-		  priv->txq[priv->cmd_queue].q.write_ptr)) {
+		 txq_id, priv->cmd_queue, sequence,
+		 priv->txq[priv->cmd_queue].q.read_ptr,
+		 priv->txq[priv->cmd_queue].q.write_ptr)) {
 		iwl_print_hex_error(priv, pkt, 32);
 		return;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 8eb1393..1dbf87b 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -169,7 +169,7 @@ static int iwl3945_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 	* in uCode. */
 
 	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
-		"no space for a new key");
+	     "no space for a new key\n");
 
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
-- 
1.7.3.2.245.g03276.dirty

