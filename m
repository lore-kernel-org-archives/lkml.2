Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab2DEXNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 19:13:11 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:44102 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab2DEXNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 19:13:09 -0400
Date: Thu, 5 Apr 2012 16:13:06 -0700
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Mike Galbraith <mgalbraith@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [patch 0/2] cpusets, cpu_cgroup: disallow attaching kthreadd
Message-ID: <20120405231306.GF29517@google.com>
References: <alpine.DEB.2.00.1204042344090.8991@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1204050011550.9466@chino.kir.corp.google.com>
 <20120405160829.GA12854@google.com>
 <alpine.DEB.2.00.1204051417490.17852@chino.kir.corp.google.com>
 <20120405213704.GA29517@google.com>
 <alpine.DEB.2.00.1204051454070.17852@chino.kir.corp.google.com>
 <20120405222400.GC29517@google.com>
 <alpine.DEB.2.00.1204051542280.25838@chino.kir.corp.google.com>
 <20120405225854.GE29517@google.com>
 <alpine.DEB.2.00.1204051559480.25838@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1204051559480.25838@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, David.

On Thu, Apr 05, 2012 at 04:05:43PM -0700, David Rientjes wrote:
> The cgroups of interest here, cpusets and cpu, which have restrictions for 
> PF_THREAD_BOUND threads is disjoint from memcg and cpuacct, which I'm 
> saying it's useful for.  There's no requirement to mount them all.  But if 
> you do try to do memory accounting in the presence of cpusets, though, it 
> should be restricted.
> 
> We could still move to a single hierarchy, though, if we introduced a 
> change to allow PF_THREAD_BOUND to attach to both cpusets and cpu iff 
> its bound cpu is allowed and then do -EINVAL if its changed while still 
> attached.

Yeah, making the affected controllers to deal with them somehow
definitely is an option and will probably have to be chosen for some
other cases too (e.g. rt tasks).  I still feel lukewarm about the
ability to put kthreadd to !root cgroup tho.  I mean, for any kind of
sane accounting, forked kthreads would have to be further classified
and where kthreadd lives and fork happens wouldn't matter all that
much.  It feels like we're fussing over stuff which isn't that
significant either way.

Thanks.

-- 
tejun
