Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933628Ab1JYOQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 10:16:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57757 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933550Ab1JYOQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 10:16:31 -0400
Message-ID: <1319552170.10883.19.camel@edumazet-laptop>
Subject: Re: linux-next: build failure after merge of the net-next tree
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Date: Tue, 25 Oct 2011 16:16:10 +0200
In-Reply-To: <20111026005530.a4bd779e1a8182ea57dbf99f@canb.auug.org.au>
References: <20111026005530.a4bd779e1a8182ea57dbf99f@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 26 octobre 2011 à 00:55 +1100, Stephen Rothwell a écrit :
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (powerpc
> pseries_defconfig) failed like this:
> 
> drivers/net/ethernet/ibm/ehea/ehea_main.c: In function 'write_swqe2_data':
> drivers/net/ethernet/ibm/ehea/ehea_main.c:1692: error: implicit declaration of function 'frag_size'
> 
> Presumably caused by commit 9e903e085262 ("net: add skb frag size
> accessors").  I guess it should have been "skb_frag_size()".

My bad, sorry

[PATCH] ehea: fix skb_frag_size typo

commit 9e903e085262 (net: add skb frag size accessors) introduced a typo
in ehea driver.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 drivers/net/ethernet/ibm/ehea/ehea_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 0d4d4f6..37b70f7 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -1689,7 +1689,7 @@ static inline void write_swqe2_data(struct sk_buff *skb, struct net_device *dev,
 			sgentry = &sg_list[i - sg1entry_contains_frag_data];
 
 			sgentry->l_key = lkey;
-			sgentry->len = frag_size(frag);
+			sgentry->len = skb_frag_size(frag);
 			sgentry->vaddr = ehea_map_vaddr(skb_frag_address(frag));
 			swqe->descriptors++;
 		}


