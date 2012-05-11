Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760546Ab2EKOqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 10:46:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757393Ab2EKOqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 10:46:31 -0400
Date: Fri, 11 May 2012 15:46:20 +0100
From: Mel Gorman <mgorman@suse.de>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, a.p.zijlstra@chello.nl,
        michaelc@cs.wisc.edu, emunson@mgebm.net
Subject: Re: [PATCH 12/17] netvm: Propagate page->pfmemalloc from
 netdev_alloc_page to skb
Message-ID: <20120511144620.GT11435@suse.de>
References: <1336657510-24378-1-git-send-email-mgorman@suse.de>
 <1336657510-24378-13-git-send-email-mgorman@suse.de>
 <20120511.010109.1698578316660207883.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120511.010109.1698578316660207883.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 01:01:09AM -0400, David Miller wrote:
> From: Mel Gorman <mgorman@suse.de>
> Date: Thu, 10 May 2012 14:45:05 +0100
> 
> > +/**
> > + *	propagate_pfmemalloc_skb - Propagate pfmemalloc if skb is allocated after RX page
> > + *	@page: The page that was allocated from netdev_alloc_page
> > + *	@skb: The skb that may need pfmemalloc set
> > + */
> > +static inline void propagate_pfmemalloc_skb(struct page *page,
> > +						struct sk_buff *skb)
> 
> Please use consistent prefixes in the names for new interfaces.
> 

Understood.

> This one should probably be named "skb_propagate_pfmemalloc()" and
> go into skbuff.h since it needs no knowledge of netdevices.
> 

I used a netdev prefix and placed it in skbuff.h which was stupid. The
screw-up was because I was partially reverting a patch that deleted
netdev_alloc_page but I didn't need any device information so the naming
was poor. I renamed netdev_alloc_page to skb_alloc_page and will fix up
the documentation appropriately.

Thanks.

-- 
Mel Gorman
SUSE Labs
