Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab2DFPwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 11:52:11 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:43820 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793Ab2DFPwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 11:52:09 -0400
Date: Fri, 6 Apr 2012 08:52:03 -0700
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Mike Galbraith <mgalbraith@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [patch 0/2] cpusets, cpu_cgroup: disallow attaching kthreadd
Message-ID: <20120406155203.GA4798@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120405160829.GA12854@google.com>
 <alpine.DEB.2.00.1204051417490.17852@chino.kir.corp.google.com>
 <20120405213704.GA29517@google.com>
 <alpine.DEB.2.00.1204051454070.17852@chino.kir.corp.google.com>
 <20120405222400.GC29517@google.com>
 <alpine.DEB.2.00.1204051542280.25838@chino.kir.corp.google.com>
 <20120405225854.GE29517@google.com>
 <alpine.DEB.2.00.1204051559480.25838@chino.kir.corp.google.com>
 <20120405231306.GF29517@google.com>
 <alpine.DEB.2.00.1204051630400.25838@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1204051630400.25838@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David.

On Thu, Apr 05, 2012 at 04:40:06PM -0700, David Rientjes wrote:
> Well, I'm fussing over it because the patch being considered unnecessary 
> requires that kthreadd can't be moved anywhere and I know one company is 
> trying to move in a direction where nothing is in the root memcg.

"Nothing in the root memcg" can't be a goal in and of itself.  You
want that to achieve some functional goal and I'm trying to say this
specific kthreadd change doesn't necessarily affect the goal - better
accounting - all that much.  If root group is gonna be completely
empty otherwise, just combine information from it.  Even if that
doesn't work, assigning specific kthreads to appropriate cgroups after
the creation wouldn't be too far off.  I just don't see how relevant
it actually would be.

If we want all controlles to play by the same rules, which is
necessary for having a unified hierarchy, I wanna keep those rules
simple.  If bound kthreads in !root cgroups cause issues for some and
there aren't quite strong reasons to do otherwise, I would just
restrict them in the root.  It's not like those kthreads are
cgroup-aware in any form anyway.

I don't know.  Just proceed without kthreadd in the root.  If the
fallouts are big enough and can't be easily worked around, let's talk
then.

Thanks.

-- 
tejun
