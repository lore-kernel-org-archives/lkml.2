Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab2DTPmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:42:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35235 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab2DTPmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:42:08 -0400
Date: Fri, 20 Apr 2012 08:42:02 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [patch 00/18] SMP: Boot and CPU hotplug refactoring - Part 1
Message-ID: <20120420154202.GB32324@google.com>
References: <20120420122120.097464672@linutronix.de>
 <1334928098.2463.56.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334928098.2463.56.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Apr 20, 2012 at 03:21:38PM +0200, Peter Zijlstra wrote:
> On Fri, 2012-04-20 at 13:05 +0000, Thomas Gleixner wrote:
> > This first part moves the idle thread management for non-boot cpus
> > into the core. fork_idle() is called in a workqueue as it is
> > implemented in a few architectures already. This is necessary when not
> > all cpus are brought up by the early boot code as otherwise we would
> > take a ref on the user task VM of the thread which brings the cpu up
> > via the sysfs interface. 
> 
> So I was thinking about this and I think we should make that kthreadd
> instead of a random workqueue thread due to all that cgroup crap. People
> are wanting to place all sorts of kernel threads in cgroups and I'm
> still arguing that kthreadd should not be allowed in cgroups.
>
> Tejun, what's the status of that patch? Afaict David Rientjes's use-case
> is insane and mostly a side effect of memcg broken-ness.

I'm still leaning towards restricting kthreadd and any PF_THREAD_BOUND
threads in the root cgroup.  I'm not sure about !BOUND kthreads tho.
It doesn't make sense for the most part but there are cases
(e.g. crypto kthreads) which might make some sense.

Thanks.

-- 
tejun
