Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab1C2Cw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 22:52:28 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41626 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab1C2Cw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 22:52:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 29 Mar 2011 11:45:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ying Han <yinghan@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [RFC 0/3] Implementation of cgroup isolation
Message-Id: <20110329114555.cb5d5c51.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <BANLkTikgop4m9ngX6Dd1K6Jk7jsMMU0xig@mail.gmail.com>
References: <20110328093957.089007035@suse.cz>
	<AANLkTi=CPMxOg3juDiD-_hnBsXKdZ+at+i9c1YYM=vv1@mail.gmail.com>
	<20110329091254.20c7cfcb.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTin4J5kiysPdQD2aTC52U4-dy04C1g@mail.gmail.com>
	<20110329094756.49af153d.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTikgop4m9ngX6Dd1K6Jk7jsMMU0xig@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 19:46:41 -0700
Ying Han <yinghan@google.com> wrote:

> On Mon, Mar 28, 2011 at 5:47 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> >
> >> By saying that, memcg simplified the memory accounting per-cgroup but
> >> the memory isolation is broken. This is one of examples where pages
> >> are shared between global LRU and per-memcg LRU. It is easy to get
> >> cgroup-A's page evicted by adding memory pressure to cgroup-B.
> >>
> > If you overcommit....Right ?
> 
> yes, we want to support the configuration of over-committing the
> machine w/ limit_in_bytes.
> 

Then, soft_limit is a feature for fixing the problem. If you have problem
with soft_limit, let's fix it.


> >
> >
> >> The approach we are thinking to make the page->lru exclusive solve the
> >> problem. and also we should be able to break the zone->lru_lock
> >> sharing.
> >>
> > Is zone->lru_lock is a problem even with the help of pagevecs ?
> 
> > If LRU management guys acks you to isolate LRUs and to make kswapd etc..
> > more complex, okay, we'll go that way.
> 
> I would assume the change only apply to memcg users , otherwise
> everything is leaving in the global LRU list.
> 
> This will _change_ the whole memcg design and concepts Maybe memcg
> should have some kind of balloon driver to
> > work happy with isolated lru.
> 
> We have soft_limit hierarchical reclaim for system memory pressure,
> and also we will add per-memcg background reclaim. Both of them do
> targeting reclaim on per-memcg LRUs, and where is the balloon driver
> needed?
> 

If soft_limit is _not_ enough. And I think you background reclaim should
be work with soft_limit and be triggered by global memory pressure. 

As wrote in other mail, it's not called via direct reclaim.
Maybe its the 1st point to be shooted rather than trying big change.




Thanks,
-Kame

