Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161589Ab1FAILY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:11:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:43430 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161196Ab1FAILT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:11:19 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:18 2011
Message-Id: <20110601080317.958414653@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:53 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [057/146] Revert "bridge: Forward reserved group addresses if !STP"
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit f01cb5fbea1c1613621f9f32f385e12c1a29dde0 ]

This reverts commit 1e253c3b8a1aeed51eef6fc366812f219b97de65.

It breaks 802.3ad bonding inside of a bridge.

The commit was meant to support transport bridging, and specifically
virtual machines bridged to an ethernet interface connected to a
switch port wiht 802.1x enabled.

But this isn't the way to do it, it breaks too many other things.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/bridge/br_input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -163,7 +163,7 @@ struct sk_buff *br_handle_frame(struct s
 			goto drop;
 
 		/* If STP is turned off, then forward */
-		if (p->br->stp_enabled == BR_NO_STP)
+		if (p->br->stp_enabled == BR_NO_STP && dest[5] == 0)
 			goto forward;
 
 		if (NF_HOOK(NFPROTO_BRIDGE, NF_BR_LOCAL_IN, skb, skb->dev,


