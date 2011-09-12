Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab1ILHZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 03:25:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33727 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab1ILHZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 03:25:30 -0400
Date: Mon, 12 Sep 2011 10:25:24 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Alex Bligh <alex@alex.org.uk>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH] Fix repeatable Oops on container destroy with conntrack
Message-ID: <20110912072524.GA2996@p183.telecom.by>
References: <2184C0CE5A5EDC94CDDA5053@Ximines.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2184C0CE5A5EDC94CDDA5053@Ximines.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 10, 2011 at 07:48:43PM +0100, Alex Bligh wrote:
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -570,6 +570,11 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
>  		return 0;
> 
>  	net = nf_ct_net(ct);
> +
> +	/* container deinit, netlink may have died before death_by_timeout */
> +	if (!net->nfnl)
> +		return 0;
> +
>  	if (!item->report && !nfnetlink_has_listeners(net, group))
>  		return 0;

If this is correct fix, ->nfnl check should be folded into
nfnetlink_has_listeners(), otherwise expectations aren't covered.
