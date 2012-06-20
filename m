Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2FTNhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 09:37:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab2FTNhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 09:37:01 -0400
Date: Wed, 20 Jun 2012 14:36:56 +0100
From: Mel Gorman <mgorman@suse.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH 08/17] net: Do not coalesce skbs belonging to PFMEMALLOC
 sockets
Message-ID: <20120620133656.GH4011@suse.de>
References: <1340192652-31658-1-git-send-email-mgorman@suse.de>
 <1340192652-31658-9-git-send-email-mgorman@suse.de>
 <1340193892.4604.865.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1340193892.4604.865.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 02:04:52PM +0200, Eric Dumazet wrote:
> On Wed, 2012-06-20 at 12:44 +0100, Mel Gorman wrote:
> > Commit [bad43ca8: net: introduce skb_try_coalesce()] introduced an
> > optimisation to coalesce skbs to reduce memory usage and cache line
> > misses. In the case where the socket is used for swapping this can result
> > in a warning like the following.
> > 
> > [  110.476565] nbd0: page allocation failure: order:0, mode:0x20
> > [  110.476568] Pid: 2714, comm: nbd0 Not tainted 3.5.0-rc2-swapnbd-v12r2-slab #3
> > [  110.476569] Call Trace:
> > [  110.476573]  [<ffffffff811042d3>] warn_alloc_failed+0xf3/0x160
> > [  110.476578]  [<ffffffff81107c92>] __alloc_pages_nodemask+0x6e2/0x930
> >
> > <SNIP
> >  
> 
> 
> This makes absolutely no sense to me.
> 
> This patch changes input path, while your stack trace is about output
> path and a packet being fragmented.
> 

The intention was to avoid any coalescing in the input path due to avoid
packets that "were held back due to TCP_CORK or attempt at coalescing
tiny packet". I recognise that it is clumsy and will take the approach
instead of having __tcp_push_pending_frames() use sk_gfp_atomic() in the
output path.

Thanks.

-- 
Mel Gorman
SUSE Labs
