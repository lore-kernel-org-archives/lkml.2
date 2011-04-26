Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823Ab1DZVdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:33:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:44123 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161Ab1DZVOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="425951090"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: andy@greyhouse.net, davem@davemloft.net, bphilips@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [41/106] gro: reset skb_iif on reuse
Message-Id: <20110426211320.DFE183E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/core/dev.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/net/core/dev.c
===================================================================
--- linux-2.6.35.y.orig/net/core/dev.c
+++ linux-2.6.35.y/net/core/dev.c
@@ -3232,6 +3232,7 @@ void napi_reuse_skb(struct napi_struct *
 	__skb_pull(skb, skb_headlen(skb));
 	skb_reserve(skb, NET_IP_ALIGN - skb_headroom(skb));
 	skb->dev = napi->dev;
+	skb->skb_iif = 0;
 
 	napi->skb = skb;
 }
