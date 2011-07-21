Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab1GUMCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 08:02:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab1GUMCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 08:02:46 -0400
Date: Thu, 21 Jul 2011 14:02:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, coreteam@netfilter.org,
        netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        Patrick McHardy <kaber@trash.net>,
        Bart De Schuymer <bart.de.schuymer@pandora.be>
Subject: Re: [PATCH][TRIVIAL] net, netfilter: Remove redundant goto in
 ebt_ulog_packet
In-Reply-To: <alpine.LNX.2.00.1107171953500.32359@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1107211402210.7300@pobox.suse.cz>
References: <alpine.LNX.2.00.1107171953500.32359@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jul 2011, Jesper Juhl wrote:

> In net/bridge/netfilter/ebt_ulog.c:ebt_ulog_packet() the 'goto unlock'
> before the 'alloc_failure' label is completely redundant. This patch
> removes it.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  net/bridge/netfilter/ebt_ulog.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
> index 26377e9..bf2a333 100644
> --- a/net/bridge/netfilter/ebt_ulog.c
> +++ b/net/bridge/netfilter/ebt_ulog.c
> @@ -216,7 +216,6 @@ unlock:
>  nlmsg_failure:
>  	pr_debug("error during NLMSG_PUT. This should "
>  		 "not happen, please report to author.\n");
> -	goto unlock;
>  alloc_failure:
>  	goto unlock;
>  }
> -- 
> 1.7.6
> 
> 
> PS. Please CC me on replies since I'm not subscribed to all the lists 
> copied on this mail.

Doesn't seem to be present in linux-next as of today. I have picked it up.

-- 
Jiri Kosina
SUSE Labs
