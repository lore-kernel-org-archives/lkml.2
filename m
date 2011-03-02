Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab1CEJku (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 04:40:50 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64190 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab1CEJks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 04:40:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=U5own8TOrfdpEcysyoxZV1yrOFyFCf24caB8IbTHwhclPbg9lS4UZXkcQ/Z/2QGIzF
         TgVjuOahXatl0UfGrpfqUGnrrODbcaokXRpoDaABXJ4lajIql6XYYnMRApnqmh8yNwU4
         /47sXrZIpeTR+Xc2ULBdeXYMt7zGCWdUQi6P4=
From: bookjovi@gmail.com
To: bookjovi@gmail.com
Cc: "John W. Linville" <linville@tuxdriver.com> (maintainer:NETWORKING
	[WIREL...),
        Johannes Berg <johannes@sipsolutions.net> (maintainer:MAC80211),
        "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING
	[GENERAL]),
        linux-wireless@vger.kernel.org (open list:NETWORKING [WIREL...),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] net: mac80211: fix compilation warning
Date: Wed,  2 Mar 2011 18:32:33 -0500
Message-Id: <1299108754-5492-1-git-send-email-bookjovi@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jovi Zhang <bookjovi@gmail.com>

this commit fix compilation warning as following:
net/mac80211/tx.c:1753: warning: unused variable mppath

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 net/mac80211/tx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index b0beaa5..e87b07f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1750,7 +1750,6 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	__le16 fc;
 	struct ieee80211_hdr hdr;
 	struct ieee80211s_hdr mesh_hdr __maybe_unused;
-	struct mesh_path *mppath = NULL;
 	const u8 *encaps_data;
 	int encaps_len, skip_header_bytes;
 	int nh_pos, h_pos;
@@ -1805,6 +1804,8 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
+		struct mesh_path *mppath = NULL;
+
 		if (!sdata->u.mesh.mshcfg.dot11MeshTTL) {
 			/* Do not send frames with mesh_ttl == 0 */
 			sdata->u.mesh.mshstats.dropped_frames_ttl++;
-- 
1.7.2.3

