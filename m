Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab0GDH1y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 03:27:54 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:40911 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab0GDH1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 03:27:53 -0400
Date: Sun, 4 Jul 2010 16:05:16 +0900
From: Simon Horman <horms@verge.net.au>
To: Michal Marek <mmarek@suse.cz>
Cc: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
       Julian Anastasov <ja@ssi.bg>, Wensong Zhang <wensong@linux-vs.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: Kconfig cleanup
Message-ID: <20100704070516.GA9437@verge.net.au>
References: <1278102728-20217-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278102728-20217-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 10:32:08PM +0200, Michal Marek wrote:
> IP_VS_PROTO_AH_ESP should be set iff either of IP_VS_PROTO_{AH,ESP} is
> selected. Express this with standard kconfig syntax.
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>

Acked-by: Simon Horman <horms@verge.net.au>

> ---
>  net/netfilter/ipvs/Kconfig |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/Kconfig b/net/netfilter/ipvs/Kconfig
> index f2d7623..91e7373 100644
> --- a/net/netfilter/ipvs/Kconfig
> +++ b/net/netfilter/ipvs/Kconfig
> @@ -83,19 +83,16 @@ config	IP_VS_PROTO_UDP
>  	  protocol. Say Y if unsure.
>  
>  config	IP_VS_PROTO_AH_ESP
> -	bool
> -	depends on UNDEFINED
> +	def_bool IP_VS_PROTO_ESP || IP_VS_PROTO_AH
>  
>  config	IP_VS_PROTO_ESP
>  	bool "ESP load balancing support"
> -	select IP_VS_PROTO_AH_ESP
>  	---help---
>  	  This option enables support for load balancing ESP (Encapsulation
>  	  Security Payload) transport protocol. Say Y if unsure.
>  
>  config	IP_VS_PROTO_AH
>  	bool "AH load balancing support"
> -	select IP_VS_PROTO_AH_ESP
>  	---help---
>  	  This option enables support for load balancing AH (Authentication
>  	  Header) transport protocol. Say Y if unsure.
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe lvs-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
