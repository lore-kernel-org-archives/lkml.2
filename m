Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab1BPBR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:17:27 -0500
Received: from kroah.org ([198.145.64.141]:45439 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932926Ab1BPAs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:48:27 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:03 2011
Message-Id: <20110216002103.518789186@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:20:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Milton Miller <miltonm@bga.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 044/176] mac80211: fix mesh forwarding when ratelimited too
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Milton Miller <miltonm@bga.com>

commit 919bbad580445801c22ef6ccbe624551fee652bd upstream.

Commit b51aff057c9d0ef6c529dc25fd9f775faf7b6c63 said:

    Under memory pressure, the mac80211 mesh code
    may helpfully print a message that it failed
    to clone a mesh frame and then will proceed
    to crash trying to use it anyway. Fix that.

Avoid the reference whenever the frame copy is unsuccessful
regardless of the debug message being suppressed or printed.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/rx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1712,11 +1712,11 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 
 			fwd_skb = skb_copy(skb, GFP_ATOMIC);
 
-			if (!fwd_skb && net_ratelimit()) {
+			if (!fwd_skb && net_ratelimit())
 				printk(KERN_DEBUG "%s: failed to clone mesh frame\n",
 						   sdata->name);
+			if (!fwd_skb)
 				goto out;
-			}
 
 			fwd_hdr =  (struct ieee80211_hdr *) fwd_skb->data;
 			memcpy(fwd_hdr->addr2, sdata->vif.addr, ETH_ALEN);


