Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab2F0Iny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 04:43:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36372 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab2F0Inx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 04:43:53 -0400
Date: Wed, 27 Jun 2012 09:43:48 +0100
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
Message-ID: <20120627084348.GG8271@suse.de>
References: <1340375443-22455-1-git-send-email-mgorman@suse.de>
 <1340375443-22455-12-git-send-email-mgorman@suse.de>
 <20120626201328.GI6509@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120626201328.GI6509@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 10:13:28PM +0200, Sebastian Andrzej Siewior wrote:
> On Fri, Jun 22, 2012 at 03:30:38PM +0100, Mel Gorman wrote:
> >  drivers/net/ethernet/chelsio/cxgb4/sge.c          |    2 +-
> >  drivers/net/ethernet/chelsio/cxgb4vf/sge.c        |    2 +-
> >  drivers/net/ethernet/intel/igb/igb_main.c         |    2 +-
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     |    4 +-
> >  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |    3 +-
> >  drivers/net/usb/cdc-phonet.c                      |    2 +-
> >  drivers/usb/gadget/f_phonet.c                     |    2 +-
> 
> You did not touch all drivers which use alloc_page(s)() like e1000(e). Was
> this on purpose?
> 

Yes. The ones I changed were the semi-obvious ones and carried over from
when the patches were completely out of tree.  As the changelog notes
it is not critical that these annotation happens and can be fixed on a
per-driver basis if there are complains about network swapping being slow.

In the e1000 case, alloc_page is called from e1000_alloc_jumbo_rx_buffers
and I would not have paid quite as close attention to jumbo configurations
even though e1000 does not depend on high-order allocations like some
other drivers do. I can update e1000 if you like but it's not critical
to do so and in fact getting a bug reporting saying that network swap
was slow on e1000 would be useful to me in its own way :)

-- 
Mel Gorman
SUSE Labs
