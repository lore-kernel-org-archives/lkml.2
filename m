Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110Ab1KWAkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:40:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227Ab1KWAkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:40:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:05 2011
Message-Id: <20111123002405.637602310@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [11/53] mac80211: fix bug in ieee80211_build_probe_req
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 5b2bbf75a24d6b06afff6de0eb4819413fd81971 upstream.

ieee80211_probereq_get() can return NULL in
which case we should clean up & return NULL
in ieee80211_build_probe_req() as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/util.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1047,6 +1047,8 @@ struct sk_buff *ieee80211_build_probe_re
 	skb = ieee80211_probereq_get(&local->hw, &sdata->vif,
 				     ssid, ssid_len,
 				     buf, buf_len);
+	if (!skb)
+		goto out;
 
 	if (dst) {
 		mgmt = (struct ieee80211_mgmt *) skb->data;
@@ -1055,6 +1057,8 @@ struct sk_buff *ieee80211_build_probe_re
 	}
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+
+ out:
 	kfree(buf);
 
 	return skb;


