Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab2H0U3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 16:29:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286Ab2H0U27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 16:28:59 -0400
Date: Mon, 27 Aug 2012 17:28:35 -0300
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
Subject: Re: [PATCH v9 1/5] mm: introduce a common interface for balloon
 pages mobility
Message-ID: <20120827202834.GC6517@t510.redhat.com>
References: <cover.1345869378.git.aquini@redhat.com>
 <aa4af6e819584cb05fc0dba44594ae23ab761d03.1345869378.git.aquini@redhat.com>
 <20120826075557.GD19551@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120826075557.GD19551@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 10:55:58AM +0300, Michael S. Tsirkin wrote:
> On Sat, Aug 25, 2012 at 02:24:56AM -0300, Rafael Aquini wrote:
> > Memory fragmentation introduced by ballooning might reduce significantly
> > the number of 2MB contiguous memory blocks that can be used within a guest,
> > thus imposing performance penalties associated with the reduced number of
> > transparent huge pages that could be used by the guest workload.
> > 
> > This patch introduces a common interface to help a balloon driver on
> > making its page set movable to compaction, and thus allowing the system
> > to better leverage the compation efforts on memory defragmentation.
> > 
> > Signed-off-by: Rafael Aquini <aquini@redhat.com>
> 
> Tons of rcu uses but not sync in sight. This looks suspicious.

There's no critical section marked with rcu_read_lock/rcu_read_unlock. that's
why there's no call for sync anywhere. As we are behaving mostly as updaters,
the hole rcu usage is awkward and it's placed basically to enforce the proper
order. To avoid hurting the RCU API usage with this awk approach I'll drop it
for the next series submission (it will use barriers instead).

