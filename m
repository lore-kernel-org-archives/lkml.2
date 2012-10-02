Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab2JBJei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 05:34:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab2JBJeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 05:34:36 -0400
Date: Tue, 2 Oct 2012 11:34:33 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        devel@openvz.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 1/4] memcg: provide root figures from system totals
Message-ID: <20121002093433.GA1293@dhcp22.suse.cz>
References: <1348563173-8952-1-git-send-email-glommer@parallels.com>
 <1348563173-8952-2-git-send-email-glommer@parallels.com>
 <20121001170046.GC24860@dhcp22.suse.cz>
 <506AB0BF.9030400@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506AB0BF.9030400@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 02-10-12 13:15:43, Glauber Costa wrote:
> On 10/01/2012 09:00 PM, Michal Hocko wrote:
> > On Tue 25-09-12 12:52:50, Glauber Costa wrote:
> >> > For the root memcg, there is no need to rely on the res_counters.
> > This is true only if there are no children groups but once there is at
> > least one we have to move global statistics into root res_counter and
> > start using it since then. This is a tricky part because it has to be
> > done atomically so that we do not miss anything.
> > 
> Why can't we shortcut it all the time?

Because it has its own tasks and we are still not at use_hierarchy := 1

> It makes a lot of sense to use the root cgroup as the sum of everything,
> IOW, global counters. Otherwise you are left in a situation where you
> had global statistics, and all of a sudden, when a group is created, you
> start having just a subset of that, excluding the tasks in root.

Yes because if there are no other tasks then, well, global == root. Once
you have more groups (with tasks of course) then it depends on our
favorite use_hierarchy buddy.

> If we can always assume root will have the sum of *all* tasks, including
> the ones in root, we should never need to rely on root res_counters.

but we are not there yet.

-- 
Michal Hocko
SUSE Labs
