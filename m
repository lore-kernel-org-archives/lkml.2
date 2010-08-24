Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab0HXW7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:59:23 -0400
Received: from kroah.org ([198.145.64.141]:40482 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932971Ab0HXW7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:59:10 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:16 2010
Message-Id: <20100824224216.705515426@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:42:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Changli Gao <xiaosuo@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [54/91] act_nat: the checksum of ICMP doesnt have pseudo header
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Changli Gao <xiaosuo@gmail.com>

[ Upstream commit 3a3dfb062c2e086c202d34f09ce29634515ad256 ]

after updating the value of the ICMP payload, inet_proto_csum_replace4() should
be called with zero pseudohdr.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sched/act_nat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -240,7 +240,7 @@ static int tcf_nat(struct sk_buff *skb,
 			iph->saddr = new_addr;
 
 		inet_proto_csum_replace4(&icmph->checksum, skb, addr, new_addr,
-					 1);
+					 0);
 		break;
 	}
 	default:


