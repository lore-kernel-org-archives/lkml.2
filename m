Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149Ab1I1Wrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:47:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933135Ab1I1Wrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:47:32 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:45 2011
Message-Id: <20110928220145.051087831@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Pirko <jpirko@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [187/244] vlan: reset headers on accel emulation path
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Jiri Pirko <jpirko@redhat.com>

[ Upstream commit c5114cd59d2664f258b0d021d79b1532d94bdc2b ]

It's after all necessary to do reset headers here. The reason is we
cannot depend that it gets reseted in __netif_receive_skb once skb is
reinjected. For incoming vlanids without vlan_dev, vlan_do_receive()
returns false with skb != NULL and __netif_reveive_skb continues, skb is
not reinjected.

This might be good material for 3.0-stable as well

Reported-by: Mike Auty <mike.auty@gmail.com>
Signed-off-by: Jiri Pirko <jpirko@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/8021q/vlan_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -171,6 +171,8 @@ struct sk_buff *vlan_untag(struct sk_buf
 	if (unlikely(!skb))
 		goto err_free;
 
+	skb_reset_network_header(skb);
+	skb_reset_transport_header(skb);
 	return skb;
 
 err_free:


