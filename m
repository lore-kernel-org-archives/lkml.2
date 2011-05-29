Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab1E2XXo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 19:23:44 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:38800 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab1E2XXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 19:23:42 -0400
Date: Mon, 30 May 2011 08:23:37 +0900
From: Simon Horman <horms@verge.net.au>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>, Julian Anastasov <ja@ssi.bg>,
        Wensong Zhang <wensong@linux-vs.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter, ipvs: Avoid undefined order of evaluation in
 assignments to struct nf_conn *
Message-ID: <20110529232337.GD5856@verge.net.au>
References: <alpine.LNX.2.00.1105292011450.4411@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1105292011450.4411@swampdragon.chaosbits.net>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 08:22:56PM +0200, Jesper Juhl wrote:
> In net/netfilter/ipvs/ip_vs_nfct.c::ip_vs_update_conntrack(),
> net/netfilter/ipvs/ip_vs_xmit.c::ip_vs_nat_xmit(), 
> net/netfilter/ipvs/ip_vs_xmit.c::ip_vs_nat_xmit_v6(), 
> net/netfilter/ipvs/ip_vs_xmit.c::ip_vs_icmp_xmit)() 
> net/netfilter/ipvs/ip_vs_xmit.c::and ip_vs_icmp_xmit_v6() we do this:
> 	...
> 	struct nf_conn *ct = ct = nf_ct_get(skb, &ctinfo);
> 	...
> 
> Since '=' is not a sequence point the order of these assignments happening 
> is undefined. Luckily it's easy to avoid by just doing what is obviously 
> the intended thing:
> 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: Simon Horman <horms@verge.net.au>
