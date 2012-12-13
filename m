Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab2LMOBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:01:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43970 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab2LMOBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:01:09 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Javier Cardona <javier@cozybit.com>, Javier Lopez <jlopex@cozybit.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 007/241] mac80211: don't inspect Sequence Control field on control frames
Date: Thu, 13 Dec 2012 11:56:12 -0200
Message-Id: <1355407206-17100-8-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Cardona <javier@cozybit.com>

commit f7fbf70ee9db6da6033ae50d100e017ac1f26555 upstream.

Per IEEE Std. 802.11-2012, Sec 8.2.4.4.1, the sequence Control field is
not present in control frames.  We noticed this problem when processing
Block Ack Requests.

Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Javier Lopez <jlopex@cozybit.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/mac80211/rx.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 33c49d5..4e4fc93 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1465,6 +1465,10 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 
 	hdr = (struct ieee80211_hdr *)rx->skb->data;
 	fc = hdr->frame_control;
+
+	if (ieee80211_is_ctl(fc))
+		return RX_CONTINUE;
+
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	frag = sc & IEEE80211_SCTL_FRAG;
 
-- 
1.7.9.5

