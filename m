Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab0HYTua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 15:50:30 -0400
Received: from ja.ssi.bg ([178.16.129.10]:57976 "EHLO u.domain.uli"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751604Ab0HYTu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 15:50:27 -0400
Date: Wed, 25 Aug 2010 22:55:29 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
X-X-Sender: ja@u.domain.uli
To: Simon Horman <horms@verge.net.au>
cc: lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Patrick McHardy <kaber@trash.net>, David Miller <davem@davemloft.net>,
        Xiaoyu Du <tingsrain@gmail.com>
Subject: Re: [patch nf-next v2] IPVS: ICMPv6 checksum calculation
In-Reply-To: <20100825080832.GA24863@verge.net.au>
Message-ID: <Pine.LNX.4.58.1008252253180.2907@u.domain.uli>
References: <20100825080832.GA24863@verge.net.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Wed, 25 Aug 2010, Simon Horman wrote:

> Cc: Xiaoyu Du <tingsrain@gmail.com>
> Cc: Julian Anastasov <ja@ssi.bg>

Signed-off-by: Julian Anastasov <ja@ssi.bg>

should be enough

> Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> --
> 
> Xiaoyu, is this the change that you tested?
> If so could you give me a Tested-by line?
> 
> Julian, could I get an ack from you?
> Alternatively, if you want to take ownership of the patch,
> can I get a signed-off-by from you? In that case I'll change
> the From accordingly.
> 
> Index: nf-next-2.6/net/netfilter/ipvs/ip_vs_core.c
> ===================================================================
> --- nf-next-2.6.orig/net/netfilter/ipvs/ip_vs_core.c	2010-08-25 16:57:37.000000000 +0900
> +++ nf-next-2.6/net/netfilter/ipvs/ip_vs_core.c	2010-08-25 17:02:35.000000000 +0900
> @@ -637,9 +637,11 @@ void ip_vs_nat_icmp_v6(struct sk_buff *s
>  	}
>  
>  	/* And finally the ICMP checksum */
> -	icmph->icmp6_cksum = 0;
> -	/* TODO IPv6: is this correct for ICMPv6? */
> -	ip_vs_checksum_complete(skb, icmp_offset);
> +	icmph->icmp6_cksum = ~csum_ipv6_magic(&iph->saddr, &iph->daddr,
> +					      skb->len - icmp_offset,
> +					      IPPROTO_ICMPV6, 0);
> +	skb->csum_start = skb_network_header(skb) - skb->head + icmp_offset;
> +	skb->csum_offset = offsetof(struct icmp6hdr, icmp6_cksum);
>  	skb->ip_summed = CHECKSUM_UNNECESSARY;
>  
>  	if (inout)
> 

Regards

--
Julian Anastasov <ja@ssi.bg>
