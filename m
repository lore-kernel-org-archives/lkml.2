Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab2DEXFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 19:05:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44054 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab2DEXFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 19:05:45 -0400
Date: Thu, 5 Apr 2012 16:05:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: Mike Galbraith <mgalbraith@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [patch 0/2] cpusets, cpu_cgroup: disallow attaching kthreadd
In-Reply-To: <20120405225854.GE29517@google.com>
Message-ID: <alpine.DEB.2.00.1204051559480.25838@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1204042303510.7035@chino.kir.corp.google.com> <1333608177.7783.106.camel@marge.simpson.net> <alpine.DEB.2.00.1204042344090.8991@chino.kir.corp.google.com> <alpine.DEB.2.00.1204050011550.9466@chino.kir.corp.google.com>
 <20120405160829.GA12854@google.com> <alpine.DEB.2.00.1204051417490.17852@chino.kir.corp.google.com> <20120405213704.GA29517@google.com> <alpine.DEB.2.00.1204051454070.17852@chino.kir.corp.google.com> <20120405222400.GC29517@google.com>
 <alpine.DEB.2.00.1204051542280.25838@chino.kir.corp.google.com> <20120405225854.GE29517@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2012, Tejun Heo wrote:

> > > I can see your point but the problem is that it conflicts with the
> > > long term direction cgroup is taking and that cgroup seems generally
> > > over-engineered to allow too many things which aren't too necessary to
> > > the point where it's a giant pain in the ass for the subsystems and
> > > people involved, so I'm far more likely to go for chopping down and
> > > restricting stuff if it's not strictly necessary.
> > 
> > How does kthreadd's placement conflict with the long-term direction of 
> > cgroups?
> 
> Because there's only single hierarchy, random subsystem saying no on
> ->can_attach() doesn't work.
> 

The cgroups of interest here, cpusets and cpu, which have restrictions for 
PF_THREAD_BOUND threads is disjoint from memcg and cpuacct, which I'm 
saying it's useful for.  There's no requirement to mount them all.  But if 
you do try to do memory accounting in the presence of cpusets, though, it 
should be restricted.

We could still move to a single hierarchy, though, if we introduced a 
change to allow PF_THREAD_BOUND to attach to both cpusets and cpu iff 
its bound cpu is allowed and then do -EINVAL if its changed while still 
attached.
