Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419Ab2EIPH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:07:58 -0400
Received: from mail.vyatta.com ([76.74.103.46]:37374 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445Ab2EIPHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:07:55 -0400
Date: Wed, 9 May 2012 08:07:52 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Joe Perches <joe@perches.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Bart De Schuymer <bart.de.schuymer@pandora.be>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/13] bridge: netfilter: Convert compare_ether_addr to
 ether_addr_equal
Message-ID: <20120509080752.43489fb0@nehalam.linuxnetplumber.net>
In-Reply-To: <5a91d328db3393320170723cdfc9395ad59182c6.1336538938.git.joe@perches.com>
References: <cover.1336538937.git.joe@perches.com>
	<5a91d328db3393320170723cdfc9395ad59182c6.1336538938.git.joe@perches.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 May 2012 21:56:48 -0700
Joe Perches <joe@perches.com> wrote:

> Use the new bool function ether_addr_equal to add
> some clarity and reduce the likelihood for misuse
> of compare_ether_addr for sorting.
> 
> Done via cocci script:
> 
> $ cat compare_ether_addr.cocci
> @@
> expression a,b;
> @@
> -	!compare_ether_addr(a, b)
> +	ether_addr_equal(a, b)
> 
> @@
> expression a,b;
> @@
> -	compare_ether_addr(a, b)
> +	!ether_addr_equal(a, b)
> 
> @@
> expression a,b;
> @@
> -	!ether_addr_equal(a, b) == 0
> +	ether_addr_equal(a, b)
> 
> @@
> expression a,b;
> @@
> -	!ether_addr_equal(a, b) != 0
> +	!ether_addr_equal(a, b)
> 
> @@
> expression a,b;
> @@
> -	ether_addr_equal(a, b) == 0
> +	!ether_addr_equal(a, b)
> 
> @@
> expression a,b;
> @@
> -	ether_addr_equal(a, b) != 0
> +	ether_addr_equal(a, b)
> 
> @@
> expression a,b;
> @@
> -	!!ether_addr_equal(a, b)
> +	ether_addr_equal(a, b)
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  net/bridge/netfilter/ebt_stp.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
> index 5b33a2e..071d872 100644
> --- a/net/bridge/netfilter/ebt_stp.c
> +++ b/net/bridge/netfilter/ebt_stp.c
> @@ -164,8 +164,8 @@ static int ebt_stp_mt_check(const struct xt_mtchk_param *par)
>  	    !(info->bitmask & EBT_STP_MASK))
>  		return -EINVAL;
>  	/* Make sure the match only receives stp frames */
> -	if (compare_ether_addr(e->destmac, bridge_ula) ||
> -	    compare_ether_addr(e->destmsk, msk) || !(e->bitmask & EBT_DESTMAC))
> +	if (!ether_addr_equal(e->destmac, bridge_ula) ||
> +	    !ether_addr_equal(e->destmsk, msk) || !(e->bitmask & EBT_DESTMAC))
>  		return -EINVAL;
>  
>  	return 0;

All look good.
Acked-by: Stephen Hemminger <shemminger@vyatta.com>

