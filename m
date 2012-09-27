Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab2I0OnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:43:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab2I0OnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:43:13 -0400
Date: Thu, 27 Sep 2012 15:43:07 +0100
From: Mel Gorman <mgorman@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@parallels.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Message-ID: <20120927144307.GH3429@suse.de>
References: <20120926180124.GA12544@google.com>
 <50634FC9.4090609@parallels.com>
 <20120926193417.GJ12544@google.com>
 <50635B9D.8020205@parallels.com>
 <20120926195648.GA20342@google.com>
 <50635F46.7000700@parallels.com>
 <20120926201629.GB20342@google.com>
 <50637298.2090904@parallels.com>
 <20120927120806.GA29104@dhcp22.suse.cz>
 <20120927143300.GA4251@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120927143300.GA4251@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 07:33:00AM -0700, Tejun Heo wrote:
> Hello, Michal.
> 
> On Thu, Sep 27, 2012 at 02:08:06PM +0200, Michal Hocko wrote:
> > Yes, because we have many users (basically almost all) who care only
> > about the user memory because that's what occupies the vast majority of
> > the memory. They usually want to isolate workload which would disrupt
> > the global memory otherwise (e.g. backup process vs. database). You
> > really do not want to pay an additional overhead for kmem accounting
> > here.
> 
> I'm not too convinced.  First of all, the overhead added by kmemcg
> isn't big. 

Really?

If kmemcg was globally accounted then every __GFP_KMEMCG allocation in
the page allocator potentially ends up down in
__memcg_kmem_newpage_charge which

1. takes RCU read lock
2. looks up cgroup from task
3. takes a reference count
4. memcg_charge_kmem -> __mem_cgroup_try_charge
5. release reference count

That's a *LOT* of work to incur for cgroups that do not care about kernel
accounting. This is why I thought it was reasonable that the kmem accounting
not be global.

-- 
Mel Gorman
SUSE Labs
