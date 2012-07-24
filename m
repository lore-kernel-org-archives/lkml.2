Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab2GXBTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 21:19:22 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60507 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755064Ab2GXBTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 21:19:20 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/SAdtobbfSparAkifteABKkLVQdPaB51UQPQD6UU
	rTZ3nL6sBIqWMf
Message-ID: <1343092755.7412.6.camel@marge.simpson.net>
Subject: Re: Attaching a process to cgroups
From: Mike Galbraith <efault@gmx.de>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Alexey Vlasov <renton@renton.name>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 24 Jul 2012 03:19:15 +0200
In-Reply-To: <20120723204159.GB6379@thinkpad>
References: <20120619185856.GC31797@beaver>
	 <1340195298.15707.3.camel@marge.simpson.net>
	 <20120621075428.GE31797@beaver>
	 <1340266982.29752.37.camel@marge.simpson.net>
	 <20120723204159.GB6379@thinkpad>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-23 at 22:41 +0200, Andrea Righi wrote: 
> On Thu, Jun 21, 2012 at 10:23:02AM +0200, Mike Galbraith wrote:
> > On Thu, 2012-06-21 at 11:54 +0400, Alexey Vlasov wrote: 
> > > On Wed, Jun 20, 2012 at 02:28:18PM +0200, Mike Galbraith wrote:
> > > > 
> > > > kernel/cgroup.c::cgroup_attach_task()
> > > > {
> > > > ...
> > > > 	synchronize_rcu();
> > > > ...
> > > > }
> > > 
> > > So nothing can be done here? (I mean if only I knew how to fix it I
> > > wouldn't ask about it ;)
> > 
> > Sure, kill the obnoxious thing, it's sitting right in the middle of the
> > userspace interface.
> > 
> > I banged on it a while back (wrt explosive android patches), extracted
> > RCU from the userspace interface.  It seemed to work great, much faster,
> > couldn't make it explode.  I wouldn't bet anything I wasn't willing to
> > immediately part with that the result was really really safe though ;-)
> > 
> > -Mike
> 
> JFYI,
> 
> I'm testing the following patch in a bunch of hosts and I wasn't able to
> make any of them to explode, even running a multi-threaded
> cgroup-intensive workload, but probably I was just lucky (or unlucky,
> depending on the point of view).
> 
> It is basically the same Not-signed-off-by work posted by Mike a while
> ago: https://lkml.org/lkml/2011/4/12/599.
> 
> In addition, I totally removed the synchronize_rcu() call from
> cgroup_attach_task() and added the call_rcu -> schedule_work removal
> also for css_set. The latter looks unnecessary to me from a logical
> point of view, or maybe I'm missing something, because I can't explain
> why with it I can't trigger any BUG / oops.
> 
> Mike, did you make any progress from your old patch?

No, it worked, but I couldn't prove it was really safe, so let it drop.

-Mike

