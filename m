Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716Ab1DMQBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:01:12 -0400
Received: from kroah.org ([198.145.64.141]:54498 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab1DMPzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:51 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:48 2011
Message-Id: <20110413155148.755876325@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:51:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Brandon Philips <bphilips@suse.de>
Subject: [54/74] gro: reset skb_iif on reuse
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Andy Gospodarek <andy@greyhouse.net>

commit 6d152e23ad1a7a5b40fef1f42e017d66e6115159 upstream.

Like Herbert's change from a few days ago:

66c46d741e2e60f0e8b625b80edb0ab820c46d7a gro: Reset dev pointer on reuse

this may not be necessary at this point, but we should still clean up
the skb->skb_iif.  If not we may end up with an invalid valid for
skb->skb_iif when the skb is reused and the check is done in
__netif_receive_skb.

Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Brandon Philips <bphilips@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2615,6 +2615,7 @@ void napi_reuse_skb(struct napi_struct *
 	__skb_pull(skb, skb_headlen(skb));
 	skb_reserve(skb, NET_IP_ALIGN - skb_headroom(skb));
 	skb->dev = napi->dev;
+	skb->iif = 0;
 
 	napi->skb = skb;
 }


