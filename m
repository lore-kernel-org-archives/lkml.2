Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab2GJLMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:12:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab2GJLMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:12:45 -0400
Date: Tue, 10 Jul 2012 12:12:42 +0100
From: Mel Gorman <mgorman@suse.de>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 11/16] netvm: Propagate page->pfmemalloc from
 skb_alloc_page to skb
Message-ID: <20120710111242.GD14154@suse.de>
References: <1340375443-22455-1-git-send-email-mgorman@suse.de>
 <1340375443-22455-12-git-send-email-mgorman@suse.de>
 <20120626201328.GI6509@breakpoint.cc>
 <20120627084348.GG8271@suse.de>
 <20120709191856.GD3515@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120709191856.GD3515@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 09:18:56PM +0200, Sebastian Andrzej Siewior wrote:
> 
> > I can update e1000 if you like but it's not critical
> > to do so and in fact getting a bug reporting saying that network swap
> > was slow on e1000 would be useful to me in its own way :)
> No, leave as it, I was just curious.
> One thing: Do you think it makes sense to you introduce
> 	#define GFP_NET_RX     (GFP_ATOMIC | __GFP_MEMALLOC)
> 
> and use it within the receive path instead of GFP_ATOMIC?
> 

For now, I'd prefer to keep the __GFP_MEMALLOC flag at the different
callsites because it forces people to think about what it means.  I fear
that GFP_NET_RX may be too easy to misuse without thinking about what the
consequences are.

-- 
Mel Gorman
SUSE Labs
