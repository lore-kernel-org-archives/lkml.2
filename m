Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423187Ab2KNSdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:33:53 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:34283 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423150Ab2KNSdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:33:51 -0500
Date: Wed, 14 Nov 2012 13:33:30 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH v3 3/6] memcg: Simplify mem_cgroup_force_empty_list error
 handling
Message-ID: <20121114183330.GA32421@cmpxchg.org>
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz>
 <1351251453-6140-4-git-send-email-mhocko@suse.cz>
 <508E8B95.406@parallels.com>
 <20121029150022.a595b866.akpm@linux-foundation.org>
 <20121030103559.GA7394@dhcp22.suse.cz>
 <20121113211041.GB1543@cmpxchg.org>
 <20121114135930.GE4929@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114135930.GE4929@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 02:59:30PM +0100, Michal Hocko wrote:
> On Tue 13-11-12 16:10:41, Johannes Weiner wrote:
> > Would it make sense to stick a wait_on_page_locked() in there just so
> > that we don't busy spin on a page under migration/reclaim?
> 
> Hmm, this would also mean that get_page_unless_zero would fail as well
> and so we would schedule in mem_cgroup_force_empty_list. It is true that
> there might be no other runnable task so we can busy loop so yes this
> would help. Care to cook the patch?

Eventually get_page_unless_zero() would fail but we could still spin
on a page while it's off the LRU and migration performs writeback on
it e.g.  cond_resched() does not necessarily schedule just because
there is another runnable task, I think, it's voluntary preemption
when the task needs rescheduling anyway, not yield.

Maybe not worth bothering...
