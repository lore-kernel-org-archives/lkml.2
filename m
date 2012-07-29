Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab2G2MPA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 08:15:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:53783 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab2G2MO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 08:14:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="189367689"
Date: Sun, 29 Jul 2012 20:14:49 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: walter harms <wharms@bfs.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] netfilter: PTR_RET can be used
Message-ID: <20120729121449.GA16489@localhost>
References: <20120729004550.GA7049@localhost>
 <5015280A.6000105@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5015280A.6000105@bfs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > --- linux.orig/net/bridge/netfilter/ebtable_filter.c	2012-07-29 08:41:09.703759534 +0800
> > +++ linux/net/bridge/netfilter/ebtable_filter.c	2012-07-29 08:41:14.255759643 +0800
> > @@ -100,9 +100,7 @@ static struct nf_hook_ops ebt_ops_filter
> >  static int __net_init frame_filter_net_init(struct net *net)
> >  {
> >  	net->xt.frame_filter = ebt_register_table(net, &frame_filter);
> > -	if (IS_ERR(net->xt.frame_filter))
> > -		return PTR_ERR(net->xt.frame_filter);
> > -	return 0;
> > +	return PTR_RET(net->xt.frame_filter);
> >  }
> >  
> 
> i do not understand this,
> ebt_register_table() return (struct ebt_table *) on success
> 
> Does PTR_RET really return 0 if this is a propper pointer ?

Right. Here is how PTR_RET defined. This patch does not change any behavior.

static inline int __must_check PTR_RET(const void *ptr)
{      
        if (IS_ERR(ptr))
                return PTR_ERR(ptr);
        else   
                return 0;
}

Thanks,
Fengguang
