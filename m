Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab1C2CgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 22:36:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41468 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab1C2CgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 22:36:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 29 Mar 2011 11:29:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [RFC 0/3] Implementation of cgroup isolation
Message-Id: <20110329112940.fcccd175.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110329094756.49af153d.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110328093957.089007035@suse.cz>
	<AANLkTi=CPMxOg3juDiD-_hnBsXKdZ+at+i9c1YYM=vv1@mail.gmail.com>
	<20110329091254.20c7cfcb.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTin4J5kiysPdQD2aTC52U4-dy04C1g@mail.gmail.com>
	<20110329094756.49af153d.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011 09:47:56 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Mon, 28 Mar 2011 17:37:02 -0700
> Ying Han <yinghan@google.com> wrote:

> > The approach we are thinking to make the page->lru exclusive solve the
> > problem. and also we should be able to break the zone->lru_lock
> > sharing.
> > 
> Is zone->lru_lock is a problem even with the help of pagevecs ?
> 
> If LRU management guys acks you to isolate LRUs and to make kswapd etc..
> more complex, okay, we'll go that way. This will _change_ the whole
> memcg design and concepts Maybe memcg should have some kind of balloon driver to
> work happy with isolated lru.
> 
> But my current standing position is "never bad effects global reclaim".
> So, I'm not very happy with the solution.
> 
> If we go that way, I guess we'll think we should have pseudo nodes/zones, which
> was proposed in early days of resource controls.(not cgroup).
> 

BTW, against isolation, I have one thought.

Now, soft_limit_reclaim is not called in direct-reclaim path just because we thought
kswapd works enough well. If necessary, I think we can put soft-reclaim call in
generic do_try_to_free_pages(order=0). 

So, isolation problem can be reduced to some extent, isn't it ?
Algorithm of softlimit _should_ be updated. I guess it's not heavily tested feature.

About ROOT cgroup, I think some daemon application should put _all_ process to
some controled cgroup. So, I don't want to think about limiting on ROOT cgroup
without any justification.

I'd like you to devide 'the talk on performance' and 'the talk on feature'.

"This makes makes performance better! ...and add an feature" sounds bad to me.

Thanks,
-Kame

