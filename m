Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2JENr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 09:47:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab2JENr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 09:47:27 -0400
Date: Fri, 5 Oct 2012 15:47:23 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Message-ID: <20121005134723.GD27757@dhcp22.suse.cz>
References: <20120926195648.GA20342@google.com>
 <50635F46.7000700@parallels.com>
 <20120926201629.GB20342@google.com>
 <50637298.2090904@parallels.com>
 <20120927120806.GA29104@dhcp22.suse.cz>
 <20120927143300.GA4251@mtj.dyndns.org>
 <20120927150950.GG29104@dhcp22.suse.cz>
 <20120930084750.GI10383@mtj.dyndns.org>
 <20121001092756.GA8622@dhcp22.suse.cz>
 <20121003224316.GD19248@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003224316.GD19248@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 04-10-12 07:43:16, Tejun Heo wrote:
[...]
> > That is right but I think that the current discussion shows that a mixed
> > (kmem disabled and kmem enabled hierarchies) workloads are far from
> > being theoretical and a global knob is just too coarse. I am afraid we
> 
> I'm not sure there's much evidence in this thread.  The strongest upto
> this point seems to be performance overhead / difficulty of general
> enough implementation.  As for "trusted" workload, what are the
> inherent benefits of trusting if you don't have to?

One advantage is that you do _not have_ to consider kernel memory
allocations (which are inherently bound to the kernel version) so the
sizing is much easier and version independent. If you set a limit to XY
because you know what you are doing you certainly do not want to regress
(e.g. because of unnecessary reclaim) just because a certain kernel
allocation got bigger, right?

> > will see "we want that per hierarchy" requests shortly and that would
> > just add a new confusion where global knob would complicate it
> > considerably (do we really want on/off/per_hierarchy global knob?).
> 
> Hmmm?  The global knob is just the same per_hierarchy knob at the
> root.  It's hierarchical after all.

When you said global knob I imagined mount or boot option. If you want
to have yet another memory.enable_kmem then IMHO it is much easier to
use set-accounted semantic (which is hierarchical as well).

> Anyways, as long as the "we silently ignore what happened before being
> enabled" is gone, I won't fight this anymore.  It isn't broken after
> all.  

OK, it is good that we settled this.

> But, please think about making things simpler in general, cgroup
> is riddled with mis-designed complexities and memcg seems to be
> leading the charge at times.

Yes this is an evolution and it seems that we are slowly getting there.

> 
> Thanks.

-- 
Michal Hocko
SUSE Labs
