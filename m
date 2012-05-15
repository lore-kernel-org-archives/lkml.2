Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab2EOLDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:03:21 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:59622 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575Ab2EOLDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:03:19 -0400
Date: Tue, 15 May 2012 13:03:02 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/6] mm: memcg: statistics implementation cleanups
Message-ID: <20120515110302.GH1406@cmpxchg.org>
References: <1337018451-27359-1-git-send-email-hannes@cmpxchg.org>
 <4FB1A115.2080303@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB1A115.2080303@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 09:19:33AM +0900, KAMEZAWA Hiroyuki wrote:
> (2012/05/15 3:00), Johannes Weiner wrote:
> 
> > Before piling more things (reclaim stats) on top of the current mess,
> > I thought it'd be better to clean up a bit.
> > 
> > The biggest change is printing statistics directly from live counters,
> > it has always been annoying to declare a new counter in two separate
> > enums and corresponding name string arrays.  After this series we are
> > down to one of each.
> > 
> >  mm/memcontrol.c |  223 +++++++++++++++++------------------------------
> >  1 file changed, 82 insertions(+), 141 deletions(-)
> 
> to all 1-6. Thank you.
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks!

> One excuse for my old implementation of mem_cgroup_get_total_stat(),
> which is fixed in patch 6, is that I thought it's better to touch all counters
> in a cachineline at once and avoiding long distance for-each loop.
> 
> What number of performance difference with some big hierarchy(100+children) tree ?
> (But I agree your code is cleaner. I'm just curious.)

I set up a parental group with hierarchy enabled, then created 512
children and did a 4-job kernel bench in one of them.  Every 0.1
seconds, I read the stats of the parent, which requires reading each
stat/event/lru item from 512 groups before moving to the next one:

                        512stats-vanilla        512stats-patched
Walltime (s)            62.61 (  +0.00%)        62.88 (  +0.43%)
Walltime (stddev)        0.17 (  +0.00%)         0.14 (  -3.17%)

That should be acceptable, I think.
