Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab2GIOvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:51:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38115 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754318Ab2GIOh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:37:58 -0400
Message-Id: <20120709143118.065729395@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:26 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 10/48] mac80211: correct behaviour on unrecognised action frames
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 4b5ebccc40843104d980f0714bc86bfcd5568941 upstream.

When receiving an "individually addressed" action frame, the
receiver is required to return it to the sender. mac80211
gets this wrong as it also returns group addressed (mcast)
frames to the sender. Fix this and update the reference to
the new 802.11 standards version since things were shuffled
around significantly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/rx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 7bcecf7..965e6ec 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2455,7 +2455,7 @@ ieee80211_rx_h_action_return(struct ieee80211_rx_data *rx)
 	 * frames that we didn't handle, including returning unknown
 	 * ones. For all other modes we will return them to the sender,
 	 * setting the 0x80 bit in the action category, as required by
-	 * 802.11-2007 7.3.1.11.
+	 * 802.11-2012 9.24.4.
 	 * Newer versions of hostapd shall also use the management frame
 	 * registration mechanisms, but older ones still use cooked
 	 * monitor interfaces so push all frames there.
@@ -2465,6 +2465,9 @@ ieee80211_rx_h_action_return(struct ieee80211_rx_data *rx)
 	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN))
 		return RX_DROP_MONITOR;
 
+	if (is_multicast_ether_addr(mgmt->da))
+		return RX_DROP_MONITOR;
+
 	/* do not return rejected action frames */
 	if (mgmt->u.action.category & 0x80)
 		return RX_DROP_UNUSABLE;


