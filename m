Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab0GHMNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 08:13:24 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42255 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab0GHMNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 08:13:22 -0400
Date: Thu, 8 Jul 2010 21:13:19 +0900
From: Simon Horman <horms@verge.net.au>
To: xiaoyu Du <tingsrain@gmail.com>
Cc: linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
       wensong@linux-vs.org, NetDev <netdev@vger.kernel.org>,
       Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] lvs sctp protocol handler is incorrectly invoked
 ip_vs_app_pkt_out
Message-ID: <20100708121319.GC17985@verge.net.au>
References: <AANLkTikS9SSVT5soWZYmzxeJkR5vO__cuedk7ZgmTx5y@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikS9SSVT5soWZYmzxeJkR5vO__cuedk7ZgmTx5y@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 09:55:04AM +0800, xiaoyu Du wrote:
> lvs sctp protocol handler is incorrectly invoked ip_vs_app_pkt_out
> Since there's no sctp helpers at present, it does the same thing as
> ip_vs_app_pkt_in.
> 
> Signed-off-by: Xiaoyu Du <tingsrain@gmail.com>

Thanks Xiaoyu.

Acked-by: Simon Horman <horms@verge.net.au>

Patrick, please consider applying this.
nf-next should be sufficient, as according
to Xiaoyu there aren't actually helpers
that exercise this code at the moment.

> ---
>  net/netfilter/ipvs/ip_vs_proto_sctp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c
> b/net/netfilter/ipvs/ip_vs_proto_sctp.c
> index c9a3f7a..db55759 100644
> --- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
> +++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
> @@ -173,7 +173,7 @@ sctp_dnat_handler(struct sk_buff *skb,
>  			return 0;
> 
>  		/* Call application helper if needed */
> -		if (!ip_vs_app_pkt_out(cp, skb))
> +		if (!ip_vs_app_pkt_in(cp, skb))
>  			return 0;
>  	}
> 
> --
