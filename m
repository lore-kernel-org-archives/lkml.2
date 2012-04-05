Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab2DEWYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:24:07 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:42445 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab2DEWYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:24:05 -0400
Date: Thu, 5 Apr 2012 15:24:00 -0700
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Mike Galbraith <mgalbraith@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [patch 0/2] cpusets, cpu_cgroup: disallow attaching kthreadd
Message-ID: <20120405222400.GC29517@google.com>
References: <alpine.DEB.2.00.1204042157530.31186@chino.kir.corp.google.com>
 <1333604949.7783.76.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204042303510.7035@chino.kir.corp.google.com>
 <1333608177.7783.106.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204042344090.8991@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1204050011550.9466@chino.kir.corp.google.com>
 <20120405160829.GA12854@google.com>
 <alpine.DEB.2.00.1204051417490.17852@chino.kir.corp.google.com>
 <20120405213704.GA29517@google.com>
 <alpine.DEB.2.00.1204051454070.17852@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1204051454070.17852@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David.

On Thu, Apr 05, 2012 at 03:03:06PM -0700, David Rientjes wrote:
> Yes, they act system-wide but that doesn't mean their memory usage or cpu 
> need to be accounted together.  The key is that all cgroups, current or 
> future, aren't necessarily for limiting those system-wide resources but 
> rather can provide useful insight into their cost by monitoring either 
> their memory or cpu through these two cgroups.
> 
> kthreadd certainly is not the only system-wide resource on the kernel; so 
> why are you not arguing that all PF_KTHREAD threads not be allowed into 
> non-root cgroups?  We actually have many kthreads in a memcg that _is_ 
> limited to a specific amount of memory together with other system daemons 
> that are killable if it becomes oom.
> 
> The reason we're discussing kthreadd here is because it has the funny 
> ability to fork other kthreads that become PF_THREAD_BOUND.  Usually the 
> only PF_THREAD_BOUND threads are ones created at boot.  However, if a 
> kthread is started for a specific cpu, it gets this bit set to stay on 
> that cpu via kthread_bind().  That's what causes an inconsistency for only 
> two types of cgroups: cpusets and cpu and we don't allow them to move 
> amongst them because of that.

That and because ramifications of putting kthreadd is difficult to
predict it being the root of all kthreads.  It's fine to be able to
put specific kthreads into cgroups if doing such makes sense for that
type of kthreads.

> That's what this patch series addresses.  Please don't unnecessarily limit 
> our ability with kthreadd or kthreads in general for accounting of system 
> activity.

I can see your point but the problem is that it conflicts with the
long term direction cgroup is taking and that cgroup seems generally
over-engineered to allow too many things which aren't too necessary to
the point where it's a giant pain in the ass for the subsystems and
people involved, so I'm far more likely to go for chopping down and
restricting stuff if it's not strictly necessary.  Somethings are just
stupid to allow and constrict future development and maintenance
unnecessarily which tends to be more important than supporting some
acrobatic use cases.

It's not like we have concrete plan regarding single hierarchy thing
at the moment, so it could be possible to support the use case you're
describing but please bear in mind that such use case might not be of
high priority.  Hmm... I'll think more about it.

Thanks.

-- 
tejun
