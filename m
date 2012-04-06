Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab2DFUtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 16:49:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59543 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757590Ab2DFUtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 16:49:41 -0400
Date: Fri, 6 Apr 2012 13:49:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Tejun Heo <tj@kernel.org>, Mike Galbraith <mgalbraith@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Menage <paul@paulmenage.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: [patch 0/2] cpusets, cpu_cgroup: disallow attaching kthreadd
In-Reply-To: <1333736770.2960.114.camel@laptop>
Message-ID: <alpine.DEB.2.00.1204061347180.23328@chino.kir.corp.google.com>
References: <20120405160829.GA12854@google.com> <alpine.DEB.2.00.1204051417490.17852@chino.kir.corp.google.com> <20120405213704.GA29517@google.com> <alpine.DEB.2.00.1204051454070.17852@chino.kir.corp.google.com> <20120405222400.GC29517@google.com>
 <alpine.DEB.2.00.1204051542280.25838@chino.kir.corp.google.com> <20120405225854.GE29517@google.com> <alpine.DEB.2.00.1204051559480.25838@chino.kir.corp.google.com> <20120405231306.GF29517@google.com> <alpine.DEB.2.00.1204051630400.25838@chino.kir.corp.google.com>
 <20120406155203.GA4798@dhcp-172-17-108-109.mtv.corp.google.com> <1333736770.2960.114.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2012, Peter Zijlstra wrote:

> Furthermore, the whole point of kthreadd's existence is so that we could
> create kthreads without context. Placing it in a cgroup will ensure all
> subsequently created kthreads do have context (including possible idle
> threads). This seems like a particularly bad idea.
> 

I don't see it as context if the only thing you're doing is accounting 
with memcg (for slab) or or cpu.  We're simply collecting statistics for a 
set of threads (possibly all kthreads, including kthreadd) and the best 
way to do this is leveraging the existing functionality of cgroups to 
setup the threads we want to collect for and the memcg kmem accounting is 
particularly a good indicator of kernel vs userjob-triggered slab 
allocation.
