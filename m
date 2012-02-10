Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487Ab2BJQzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 11:55:06 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:52329 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab2BJQzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 11:55:03 -0500
Date: Fri, 10 Feb 2012 08:53:38 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        paul@paulmenage.org, rjw@sisk.pl, tj@kernel.org,
        frank.rowand@am.sony.com, pjt@google.com, tglx@linutronix.de,
        lizf@cn.fujitsu.com, prashanth@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] CPU hotplug, cpusets: Fix CPU online handling
 related to cpusets
Message-ID: <20120210165338.GI2458@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120207185411.7482.43576.stgit@srivatsabhat.in.ibm.com>
 <1328671335.2482.72.camel@laptop>
 <4F32174E.2050207@linux.vnet.ibm.com>
 <20120209075701.GE18387@elte.hu>
 <4F3386E9.7090606@linux.vnet.ibm.com>
 <20120209151158.GA22489@elte.hu>
 <1328889127.25989.14.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328889127.25989.14.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021016-3352-0000-0000-00000288B788
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 04:52:07PM +0100, Peter Zijlstra wrote:
> On Thu, 2012-02-09 at 16:11 +0100, Ingo Molnar wrote:
> 
> > > My understanding of the code is that when a CPU is taken 
> > > offline, it is removed from all the cpusets and then the 
> > > scan_for_empty_cpusets() function is run to move tasks from 
> > > empty cpusets to their parent cpusets.
> > 
> > Why is that done that way? offlining a CPU should be an 
> > invariant as far as cpusets are concerned.
> 
> Can't, tasks need to run someplace. There's two choices, add a still
> online cpu to the now empty cpuset or move the tasks to a parent that
> still has online cpus.
> 
> Both are destructive.

OK, I will ask the stupid question...  Hey, somebody has to!  ;-)

Would it make sense for offlining the last CPU in a cpuset to be
destructive, but to allow offlining of a non-last CPU to be reversible?

For example, assume that cpuset A has CPUs 0 and 1, and cpuset B has
1, 2, and 3.  Then offlining any single CPU and then onlining it would
restore the cpusets to their original state.  Offlining both CPUs 0 and 1
would be destructive to cpuset A, so that onlining those two CPUs would
leave any tasks in cpuset A in some ancestor of cpuset A, and would
leave cpuset A with no assigned CPUs.  However, that same operation
(offlining both CPUs 0 and 1, then onlining them) would restore cpuset
B to its original state, covering CPUs 1, 2, and 3.

/me ducks.  ;-)

							Thanx, Paul

