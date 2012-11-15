Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499Ab2KOEYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:24:20 -0500
Received: from mail.kernel.org ([198.145.19.201]:49718 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993202Ab2KOEMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:12:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Javier Cardona <javier@cozybit.com>, Javier Lopez <jlopex@cozybit.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 15/57] mac80211: dont inspect Sequence Control field on control frames
Date: Wed, 14 Nov 2012 20:11:23 -0800
Message-Id: <20121115040934.156198828@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040933.223998671@linuxfoundation.org>
References: <20121115040933.223998671@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Cardona <javier@cozybit.com>

commit f7fbf70ee9db6da6033ae50d100e017ac1f26555 upstream.

Per IEEE Std. 802.11-2012, Sec 8.2.4.4.1, the sequence Control field is
not present in control frames.  We noticed this problem when processing
Block Ack Requests.

Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Javier Lopez <jlopex@cozybit.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/rx.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1465,6 +1465,10 @@ ieee80211_rx_h_defragment(struct ieee802
 
 	hdr = (struct ieee80211_hdr *)rx->skb->data;
 	fc = hdr->frame_control;
+
+	if (ieee80211_is_ctl(fc))
+		return RX_CONTINUE;
+
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	frag = sc & IEEE80211_SCTL_FRAG;
 


