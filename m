Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030592Ab2CAKXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 05:23:50 -0500
Received: from mail.us.es ([193.147.175.20]:34724 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030548Ab2CAKXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 05:23:48 -0500
Date: Thu, 1 Mar 2012 11:23:41 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: bart.de.schuymer@pandora.be, kaber@trash.net, shemminger@vyatta.com,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/3] netfilter: Remove redundant code.
Message-ID: <20120301102341.GC6488@1984>
References: <1330593466-19317-1-git-send-email-santoshprasadnayak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330593466-19317-1-git-send-email-santoshprasadnayak@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 02:47:46PM +0530, santosh nayak wrote:
> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> Remove the redundant code.
> 
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
> ---
>  net/bridge/netfilter/ebtables.c |   18 ++++++------------
>  1 files changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
> index 9c0f177..1efc234 100644
> --- a/net/bridge/netfilter/ebtables.c
> +++ b/net/bridge/netfilter/ebtables.c
> @@ -226,10 +226,8 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
>  
>  		if (EBT_MATCH_ITERATE(point, ebt_do_match, skb, &acpar) != 0)
>  			goto letscontinue;
> -		if (acpar.hotdrop) {
> -			read_unlock_bh(&table->lock);
> -			return NF_DROP;
> -		}
> +		if (acpar.hotdrop)
> +			goto out;

This is really broken! there's no "out" label in ebt_do_table as in
the previous patch!
