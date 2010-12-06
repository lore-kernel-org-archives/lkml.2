Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab0LFWF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:05:56 -0500
Received: from mail.perches.com ([173.55.12.10]:2335 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449Ab0LFWFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:24 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 27/29] net/mac80211: Update WARN uses
Date: Mon,  6 Dec 2010 14:05:17 -0800
Message-Id: <4fcf6716dfd9d67e2d1d369c35ab5e23a2b9e13b.1291670106.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coalesce long formats.
Add missing newlines.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/mac80211/agg-tx.c |    5 +++--
 net/mac80211/iface.c  |    4 ++--
 net/mac80211/mlme.c   |    2 +-
 net/mac80211/rx.c     |    4 +---
 net/mac80211/tx.c     |    4 +---
 net/mac80211/util.c   |    4 +---
 net/mac80211/work.c   |    4 ++--
 7 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index d4679b2..9f2c3f6 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -454,8 +454,9 @@ ieee80211_agg_splice_packets(struct ieee80211_local *local,
 
 	ieee80211_stop_queue_agg(local, tid);
 
-	if (WARN(!tid_tx, "TID %d gone but expected when splicing aggregates"
-			  " from the pending queue\n", tid))
+	if (WARN(!tid_tx,
+		 "TID %d gone but expected when splicing aggregates from the pending queue\n",
+		 tid))
 		return;
 
 	if (!skb_queue_empty(&tid_tx->pending)) {
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 7aa8559..795dbf4 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -820,7 +820,7 @@ static void ieee80211_iface_work(struct work_struct *work)
 			ieee80211_mesh_rx_queued_mgmt(sdata, skb);
 			break;
 		default:
-			WARN(1, "frame for unexpected interface type");
+			WARN(1, "frame for unexpected interface type\n");
 			break;
 		}
 
@@ -979,7 +979,7 @@ static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 	ieee80211_setup_sdata(sdata, type);
 
 	err = ieee80211_do_open(sdata->dev, false);
-	WARN(err, "type change: do_open returned %d", err);
+	WARN(err, "type change: do_open returned %d\n", err);
 
 	return ret;
 }
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7948079..62cc3c5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1848,7 +1848,7 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 			cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len);
 			break;
 		default:
-			WARN(1, "unexpected: %d", rma);
+			WARN(1, "unexpected: %d\n", rma);
 		}
 		return;
 	}
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6289525..e801a06 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2852,9 +2852,7 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
 			 */
 			if (WARN((status->rate_idx < 0 ||
 				 status->rate_idx > 76),
-				 "Rate marked as an HT rate but passed "
-				 "status->rate_idx is not "
-				 "an MCS index [0-76]: %d (0x%02x)\n",
+				 "Rate marked as an HT rate but passed status->rate_idx is not an MCS index [0-76]: %d (0x%02x)\n",
 				 status->rate_idx,
 				 status->rate_idx))
 				goto drop;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2ba7426..aed6cac 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -650,9 +650,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	if (WARN(test_bit(SCAN_SW_SCANNING, &tx->local->scanning) &&
 		 (sta_flags & WLAN_STA_ASSOC) &&
 		 !rate_usable_index_exists(sband, &tx->sta->sta),
-		 "%s: Dropped data frame as no usable bitrate found while "
-		 "scanning and associated. Target station: "
-		 "%pM on %d GHz band\n",
+		 "%s: Dropped data frame as no usable bitrate found while scanning and associated. Target station: %pM on %d GHz band\n",
 		 tx->sdata->name, hdr->addr1,
 		 tx->channel->band ? 5 : 2))
 		return TX_DROP;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index e497476..93b0f78 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1143,9 +1143,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		 */
 		res = drv_start(local);
 		if (res) {
-			WARN(local->suspended, "Hardware became unavailable "
-			     "upon resume. This could be a software issue "
-			     "prior to suspend or a hardware issue.\n");
+			WARN(local->suspended, "Hardware became unavailable upon resume. This could be a software issue prior to suspend or a hardware issue.\n");
 			return res;
 		}
 
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 2b5c3f2..c1d774a 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -849,7 +849,7 @@ static void ieee80211_work_rx_queued_mgmt(struct ieee80211_local *local,
 		list_del_rcu(&wk->list);
 		break;
 	default:
-		WARN(1, "unexpected: %d", rma);
+		WARN(1, "unexpected: %d\n", rma);
 	}
 
 	mutex_unlock(&local->mtx);
@@ -995,7 +995,7 @@ static void ieee80211_work_work(struct work_struct *work)
 			list_add(&wk->list, &free_work);
 			break;
 		default:
-			WARN(1, "unexpected: %d", rma);
+			WARN(1, "unexpected: %d\n", rma);
 		}
 	}
 
-- 
1.7.3.2.245.g03276.dirty

