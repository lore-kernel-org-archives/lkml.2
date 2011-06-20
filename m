Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab1FTDkE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 23:40:04 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42414 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab1FTDkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 23:40:00 -0400
Date: Mon, 20 Jun 2011 12:39:52 +0900
From: Simon Horman <horms@verge.net.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Schillstrom <hans.schillstrom@ericsson.com>
Subject: Re: linux-next: manual merge of the net tree with the net-current
 tree
Message-ID: <20110620033951.GA2457@verge.net.au>
References: <20110620125616.e319c55c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110620125616.e319c55c.sfr@canb.auug.org.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 12:56:16PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in
> net/netfilter/ipvs/ip_vs_core.c between commit 8f4e0a18682d ("IPVS netns
> exit causes crash in conntrack") from the net-current tree and commit
> 503cf15a5ecc ("IPVS: rename of netns init and cleanup functions") from
> the net tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Thanks.

I think this should all come out in the wash
when Dave merges net-2.6 into net-next-2.6.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc net/netfilter/ipvs/ip_vs_core.c
> index 24c28d2,2200bae..0000000
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@@ -1945,8 -1945,7 +1945,8 @@@ static void __net_exit __ip_vs_dev_clea
>   {
>   	EnterFunction(2);
>   	net_ipvs(net)->enable = 0;	/* Disable packet reception */
>  +	smp_wmb();
> - 	__ip_vs_sync_cleanup(net);
> + 	ip_vs_sync_net_cleanup(net);
>   	LeaveFunction(2);
>   }
>   
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
