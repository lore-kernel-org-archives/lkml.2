Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab0ILLL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 07:11:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52496 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab0ILLL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 07:11:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=rPQPkAX+dK1dQOR/ODoebY3ik0Wf381k2PXvs2JE/Gw1W+EAjW+kzb9AgRm7ZK7wNz
         +Bqrjqxt8Z9/i3U4czk6ErW+y8BU59BLljoLDEsjBGoqaD7OUmMOQ7Za/sM+IoViOmVG
         GilJ8kOOh2BkPZQb2yTGKs51Da4s1RNpi/Q9Y=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kalle.valo@iki.fi>, Felix Fietkau <nbd@openwrt.org>,
        Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 2/2] mac80211: fix compilation warning
Date: Sun, 12 Sep 2010 14:10:29 +0300
Message-Id: <1284289829-25425-3-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1284289829-25425-1-git-send-email-felipe.contreras@gmail.com>
References: <1284289829-25425-1-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

net/mac80211/tx.c: In function ‘ieee80211_subif_start_xmit’:
net/mac80211/tx.c:1702: warning: unused variable ‘mesh_hdr’

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 net/mac80211/tx.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c54db96..323a6b5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1699,7 +1699,6 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	u16 ethertype, hdrlen,  meshhdrlen = 0;
 	__le16 fc;
 	struct ieee80211_hdr hdr;
-	struct ieee80211s_hdr mesh_hdr;
 	const u8 *encaps_data;
 	int encaps_len, skip_header_bytes;
 	int nh_pos, h_pos;
@@ -1755,7 +1754,9 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		hdrlen = 30;
 		break;
 #ifdef CONFIG_MAC80211_MESH
-	case NL80211_IFTYPE_MESH_POINT:
+	case NL80211_IFTYPE_MESH_POINT: {
+		struct ieee80211s_hdr mesh_hdr;
+
 		if (!sdata->u.mesh.mshcfg.dot11MeshTTL) {
 			/* Do not send frames with mesh_ttl == 0 */
 			sdata->u.mesh.mshstats.dropped_frames_ttl++;
@@ -1813,6 +1814,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 
 		}
 		break;
+	}
 #endif
 	case NL80211_IFTYPE_STATION:
 		memcpy(hdr.addr1, sdata->u.mgd.bssid, ETH_ALEN);
-- 
1.7.2.3

