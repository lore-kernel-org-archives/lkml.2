Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab2KNFw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:52:57 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55318 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756509Ab2KNFvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:51:15 -0500
Message-Id: <20121114053937.496099557@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:39:59 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Javier Cardona <javier@cozybit.com>, Javier Lopez <jlopex@cozybit.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 26/82] mac80211: dont inspect Sequence Control field on control frames
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Cardona <javier@cozybit.com>

commit f7fbf70ee9db6da6033ae50d100e017ac1f26555 upstream.

Per IEEE Std. 802.11-2012, Sec 8.2.4.4.1, the sequence Control field is
not present in control frames.  We noticed this problem when processing
Block Ack Requests.

Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Javier Lopez <jlopex@cozybit.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/rx.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f73e0dd..c6865f2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1462,6 +1462,10 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 
 	hdr = (struct ieee80211_hdr *)rx->skb->data;
 	fc = hdr->frame_control;
+
+	if (ieee80211_is_ctl(fc))
+		return RX_CONTINUE;
+
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	frag = sc & IEEE80211_SCTL_FRAG;
 


