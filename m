Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab1EFAZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:25:30 -0400
Received: from kroah.org ([198.145.64.141]:37018 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210Ab1EFAZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:24 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:13 2011
Message-Id: <20110506002213.848589964@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [088/143] mac80211: Add define for TX headroom reserved by mac80211 itself.
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Gertjan van Wingerde <gwingerde@gmail.com>

commit d24deb2580823ab0b8425790c6f5d18e2ff749d8 upstream.

Add a definition of the amount of TX headroom reserved by mac80211 itself
for its own purposes. Also add BUILD_BUG_ON to validate the value.
This define can then be used by drivers to request additional TX headroom
in the most efficient manner.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Adjust context for 2.6.32]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/net/mac80211.h |    6 ++++++
 net/mac80211/main.c    |    2 ++
 2 files changed, 8 insertions(+)

--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1700,6 +1700,12 @@ void ieee80211_rx(struct ieee80211_hw *h
  */
 void ieee80211_rx_irqsafe(struct ieee80211_hw *hw, struct sk_buff *skb);
 
+/*
+ * The TX headroom reserved by mac80211 for its own tx_status functions.
+ * This is enough for the radiotap header.
+ */
+#define IEEE80211_TX_STATUS_HEADROOM	13
+
 /**
  * ieee80211_tx_status - transmit status callback
  *
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -859,6 +859,8 @@ int ieee80211_register_hw(struct ieee802
 	 * and we need some headroom for passing the frame to monitor
 	 * interfaces, but never both at the same time.
 	 */
+	BUILD_BUG_ON(IEEE80211_TX_STATUS_HEADROOM !=
+			sizeof(struct ieee80211_tx_status_rtap_hdr));
 	local->tx_headroom = max_t(unsigned int , local->hw.extra_tx_headroom,
 				   sizeof(struct ieee80211_tx_status_rtap_hdr));
 


