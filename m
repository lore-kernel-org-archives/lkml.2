Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab2I3Khn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 06:37:43 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54267 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab2I3Khl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 06:37:41 -0400
Date: Sun, 30 Sep 2012 19:37:32 +0900
From: Tejun Heo <tj@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Glauber Costa <glommer@parallels.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Message-ID: <20120930103732.GK10383@mtj.dyndns.org>
References: <50638793.7060806@parallels.com>
 <20120926230807.GC10453@mtj.dyndns.org>
 <20120927142822.GG3429@suse.de>
 <20120927144942.GB4251@mtj.dyndns.org>
 <50646977.40300@parallels.com>
 <20120927174605.GA2713@localhost>
 <50649EAD.2050306@parallels.com>
 <20120930075700.GE10383@mtj.dyndns.org>
 <20120930080249.GF10383@mtj.dyndns.org>
 <1348995388.2458.8.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348995388.2458.8.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, James.

On Sun, Sep 30, 2012 at 09:56:28AM +0100, James Bottomley wrote:
> The beancounter approach originally used by OpenVZ does exactly this.
> There are two specific problems, though, firstly you can't count
> references in generic code, so now you have to extend the cgroup
> tentacles into every object, an invasiveness which people didn't really
> like.

Yeah, it will need some hooks.  For dentry and inode, I think it would
be pretty well isolated tho.  Wasn't it?

> Secondly split accounting causes oddities too, like your total
> kernel memory usage can appear to go down even though you do nothing
> just because someone else added a share.  Worse, if someone drops the
> reference, your usage can go up, even though you did nothing, and push
> you over your limit, at which point action gets taken against the
> container.  This leads to nasty system unpredictability (The whole point
> of cgroup isolation is supposed to be preventing resource usage in one
> cgroup from affecting that in another).

In a sense, the fluctuating amount is the actual resource burden the
cgroup is putting on the system, so maybe it just needs to be handled
better or maybe we should charge fixed amount per refcnt?  I don't
know.

> We discussed this pretty heavily at the Containers Mini Summit in Santa
> Rosa.  The emergent consensus was that no-one really likes first use
> accounting, but it does solve all the problems and it has the fewest
> unexpected side effects.

But that's like fitting the problem to the mechanism.  Maybe that is
the best which can be done, but the side effect there is way-off
accounting under pretty common workload, which sounds pretty nasty to
me.

Thanks.

-- 
tejun
