Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab1JULgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 07:36:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43041 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab1JULge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 07:36:34 -0400
Subject: Re: [Patch] Idle balancer: cache align nohz structure to improve
 idle load balancing scalability
From: Peter Zijlstra <peterz@infradead.org>
To: Venki Pallipadi <venki@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Tim Chen <tim.c.chen@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <CABeCy1a20npBt=4ee38zLH+6Fi7nfASd0dL3od6pOccV=LJDkA@mail.gmail.com>
References: <1319060737.2604.38.camel@schen9-DESK>
	 <m2wrc0xpbg.fsf@firstfloor.org>
	 <CABeCy1a20npBt=4ee38zLH+6Fi7nfASd0dL3od6pOccV=LJDkA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 19:38:54 +0200
Message-ID: <1319132334.8653.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-20 at 05:26 -0700, Venki Pallipadi wrote:
> On Wed, Oct 19, 2011 at 9:24 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > Tim Chen <tim.c.chen@linux.intel.com> writes:
> >>   */
> >>  static struct {
> >> -     atomic_t load_balancer;
> >> -     atomic_t first_pick_cpu;
> >> -     atomic_t second_pick_cpu;
> >> -     cpumask_var_t idle_cpus_mask;
> >> +     atomic_t load_balancer ____cacheline_aligned;
> >> +     atomic_t first_pick_cpu ____cacheline_aligned;
> >> +     atomic_t second_pick_cpu ____cacheline_aligned;
> >> +     cpumask_var_t idle_cpus_mask ____cacheline_aligned;
> >
> > On large configs idle_cpu_masks may be allocated.  May need
> > more changes to tell the allocator to cache align/pad too?
> >
> 
> An alternate approach is to split this struct per node/socket and do
> the nohz idle balancing logic at that level. That should be more
> scalable in terms of nohz balancing (ensure one CPU wont be doing nohz
> balancing for huge number of idle CPUs). I had looked at that approach
> couple of years earlier and couldn't measure that much of a gain. May
> be it is time to revisit that with increased core count.

Yeah, that would be best, although I remember there was a problem with
your approach back then, a fully idle node would not balance at all or
something like that.

