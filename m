Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab2HGW3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:29:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596Ab2HGW32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:29:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 048/122] mac80211: fix read outside array bounds
Date: Tue,  7 Aug 2012 15:25:36 -0700
Message-Id: <20120807221952.533581233@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit 353d09c6ceedc1cb0c54fe5002c0ca80b6ee6e4f upstream.

ieee802_1d_to_ac is defined as a const int[8],
but the tid parameter has a range from 0 to 15.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2733,7 +2733,7 @@ EXPORT_SYMBOL(ieee80211_get_buffered_bc)
 void ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata,
 			  struct sk_buff *skb, int tid)
 {
-	int ac = ieee802_1d_to_ac[tid];
+	int ac = ieee802_1d_to_ac[tid & 7];
 
 	skb_set_mac_header(skb, 0);
 	skb_set_network_header(skb, 0);


