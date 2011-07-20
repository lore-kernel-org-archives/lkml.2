Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab1GTAhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 20:37:39 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53438 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab1GTAhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 20:37:38 -0400
Date: Wed, 20 Jul 2011 02:36:53 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ying Han <yinghan@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 7/8] vmscan: memcg-aware unevictable page rescue scanner
Message-ID: <20110720003653.GA667@cmpxchg.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
 <1306909519-7286-8-git-send-email-hannes@cmpxchg.org>
 <CALWz4iwDGD8xoUbzi=9Sy7C-njcYqmka_25rQL8RhkN_ArLgDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALWz4iwDGD8xoUbzi=9Sy7C-njcYqmka_25rQL8RhkN_ArLgDw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 03:47:43PM -0700, Ying Han wrote:
> On Tue, May 31, 2011 at 11:25 PM, Johannes Weiner <hannes@cmpxchg.org>wrote:
> 
> > Once the per-memcg lru lists are exclusive, the unevictable page
> > rescue scanner can no longer work on the global zone lru lists.
> >
> > This converts it to go through all memcgs and scan their respective
> > unevictable lists instead.
> >
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > ---
> >  include/linux/memcontrol.h |    2 +
> >  mm/memcontrol.c            |   11 +++++++++
> >  mm/vmscan.c                |   53
> > +++++++++++++++++++++++++++----------------
> >  3 files changed, 46 insertions(+), 20 deletions(-)
> >
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index cb02c00..56c1def 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -60,6 +60,8 @@ extern void mem_cgroup_cancel_charge_swapin(struct
> > mem_cgroup *ptr);
> >
> >  extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct
> > *mm,
> >                                        gfp_t gfp_mask);
> > +struct page *mem_cgroup_lru_to_page(struct zone *, struct mem_cgroup *,
> > +                                   enum lru_list);
> >
> 
> Did we miss a #ifdef case for this function? I got compile error by
> disabling memcg.

I assume it's because the call to it is not optimized away properly in
the disabled case.  I'll have it fixed in the next round, thanks for
letting me know.
