Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab2LJIql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:46:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab2LJIqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:46:39 -0500
Date: Mon, 10 Dec 2012 08:46:35 +0000
From: Mel Gorman <mgorman@suse.de>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Hillf Danton <dhillf@gmail.com>, David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/49] Automatic NUMA Balancing v10
Message-ID: <20121210084635.GE1009@suse.de>
References: <1354875832-9700-1-git-send-email-mgorman@suse.de>
 <20121207110113.GB21482@gmail.com>
 <20121209203630.GC1009@suse.de>
 <20121210050710.GC22164@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121210050710.GC22164@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 10:37:10AM +0530, Srikar Dronamraju wrote:
> > 
> > Either way, last night I applied a patch on top of latest tip/master to
> > remove the nr_cpus_allowed check so that numacore would be enabled again
> > and tested that. In some places it has indeed much improved. In others
> > it is still regressing badly and in two case, it's corrupting memory --
> > specjbb when THP is enabled crashes when running for single or multiple
> > JVMs. It is likely that a zero page is being inserted due to a race with
> > migration and causes the JVM to throw a null pointer exception. Here is
> > the comparison on the rough off-chance you actually read it this time.
> 
> I see this failure when running with THP and KSM enabled on 
> Friday's Tip master. Not sure if Mel was talking about the same issue.
> 
> ------------[ cut here ]------------
> kernel BUG at ../kernel/sched/fair.c:2371!

I'm not, this is new to me. I grepped the console logs I have and the closest
I see is a WARN_ON triggered in numacore v17 which is no longer relevant.

-- 
Mel Gorman
SUSE Labs
