Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab2I3H5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 03:57:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64532 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab2I3H5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 03:57:09 -0400
Date: Sun, 30 Sep 2012 16:57:00 +0900
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Message-ID: <20120930075700.GE10383@mtj.dyndns.org>
References: <20120926221046.GA10453@mtj.dyndns.org>
 <506381B2.2060806@parallels.com>
 <20120926224235.GB10453@mtj.dyndns.org>
 <50638793.7060806@parallels.com>
 <20120926230807.GC10453@mtj.dyndns.org>
 <20120927142822.GG3429@suse.de>
 <20120927144942.GB4251@mtj.dyndns.org>
 <50646977.40300@parallels.com>
 <20120927174605.GA2713@localhost>
 <50649EAD.2050306@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50649EAD.2050306@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Thu, Sep 27, 2012 at 10:45:01PM +0400, Glauber Costa wrote:
> > Can you please give other examples of cases where this type of issue
> > exists (plenty of shared kernel data structure which is inherent to
> > the workload at hand)?  Until now, this has been the only example for
> > this type of issues.
> 
> Yes. the namespace related caches (*), all kinds of sockets and network
> structures, other file system structures like file struct, vm areas, and
> pretty much everything a full container does.
> 
> (*) we run full userspace, so we have namespaces + cgroups combination.

This is probably me being dumb but wouldn't resources used by full
namespaces be mostly independent?  Which parts get shared?  Also, if
you do full namespace, isn't it more likely that you would want fuller
resource isolation too?

> >> Mel suggestion of not allowing this to happen once the cgroup has tasks
> >> takes care of this, and is something I thought of myself.
> > 
> > You mean Michal's?  It should also disallow switching if there are
> > children cgroups, right?
> 
> No, I meant Mel, quoting this:
> 
> "Further I would expect that an administrator would be aware of these
> limitations and set kmem_accounting at cgroup creation time before any
> processes start. Maybe that should be enforced but it's not a
> fundamental problem."
> 
> But I guess it is pretty much the same thing Michal proposes, in essence.
> 
> Or IOW, if your concern is with the fact that charges may have happened
> in the past before this is enabled, we can make sure this cannot happen
> by disallowing the limit to be set if currently unset (value changes are
> obviously fine) if you have children or any tasks already in the group.

Yeah, please do that.

Thanks.

-- 
tejun
