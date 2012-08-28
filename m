Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab2H1SGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 14:06:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab2H1SGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 14:06:13 -0400
Date: Tue, 28 Aug 2012 15:05:39 -0300
From: Rafael Aquini <aquini@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v9 3/5] virtio_balloon: introduce migration primitives to
 balloon pages
Message-ID: <20120828180539.GB1750@t510.redhat.com>
References: <cover.1345869378.git.aquini@redhat.com>
 <a1ceca79d95bc7de2a6b62a2e565b95286dbdf75.1345869378.git.aquini@redhat.com>
 <20120826074244.GC19551@redhat.com>
 <20120827194713.GA6517@t510.redhat.com>
 <20120828155410.GE2903@redhat.com>
 <20120828173713.GA1750@t510.redhat.com>
 <20120828175716.GA4595@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120828175716.GA4595@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 08:57:16PM +0300, Michael S. Tsirkin wrote:
> Sorry I do not understand what you are saying here. So find
> a different locking strategy.
> 
> For example something like:
> 
>          wait_event(vb->config_change,
> 		({ 
> 		   lock
> 		   if (target <= (num_pages - isolated_pages))
> 			   leak balloon
> 		   cond = target <= (num_pages - isolated_pages));
> 		   unlock;
> 		   cond;
> 		})
> 		)
> 
> seems to have no issues?

Ok, I see what you mean. I'll change it.

