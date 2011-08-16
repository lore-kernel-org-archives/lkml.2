Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab1HPCuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:50:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab1HPCut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:50:49 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Mon Aug 15 19:44:54 2011
Message-Id: <20110816024454.261099716@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 15 Aug 2011 19:42:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chas Williams <chas@cmf.nrl.navy.mil>,
        "David S. Miller" <davem@davemloft.net>
Subject: [14/26] atm: br2864: sent packets truncated in VC routed mode
In-Reply-To: <20110816024553.GA5631@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chas Williams <chas@cmf.nrl.navy.mil>

commit a08af810cdc29d2ca930e8a869d3d01744c392d8 upstream.

Reported-by: Pascal Hambourg <pascal@plouf.fr.eu.org>
Signed-off-by: Chas Williams <chas@cmf.nrl.navy.mil>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/atm/br2684.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/atm/br2684.c
+++ b/net/atm/br2684.c
@@ -242,8 +242,6 @@ static int br2684_xmit_vcc(struct sk_buf
 		if (brdev->payload == p_bridged) {
 			skb_push(skb, 2);
 			memset(skb->data, 0, 2);
-		} else { /* p_routed */
-			skb_pull(skb, ETH_HLEN);
 		}
 	}
 	skb_debug(skb);


