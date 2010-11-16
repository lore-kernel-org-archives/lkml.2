Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab0KPTKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:10:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756706Ab0KPTJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:09:59 -0500
Date: Tue, 16 Nov 2010 14:09:16 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: david@lang.hm, Paul Menage <menage@google.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dhaval Giani <dhaval.giani@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101116190916.GD13092@redhat.com>
References: <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop>
 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de>
 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de>
 <1289931715.2109.648.camel@laptop>
 <AANLkTik7cR_5JJWfk8SEf3Dngfe7yZvuivJ66dVDOuAk@mail.gmail.com>
 <alpine.DEB.2.00.1011161047060.3718@asgard.lang.hm>
 <1289933965.2109.652.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289933965.2109.652.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 07:59:25PM +0100, Peter Zijlstra wrote:
> On Tue, 2010-11-16 at 10:55 -0800, david@lang.hm wrote:
> > On Tue, 16 Nov 2010, Paul Menage wrote:
> > 
> > > On Tue, Nov 16, 2010 at 10:21 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > >>
> > >> Not quite the same, you're nesting one level deeper. But the reality is,
> > >> not a lot of people will change their userspace.
> > >
> > > That's a weak argument - not a lot of people will (explicitly) change
> > > their kernel either - they'll get a fresh kernel via their distro
> > > updates, as they would get userspace updates. So it's only a few
> > > people (distros) that actually need to make such a change.
> > 
> > what is the downside of this patch going to be?
> > 
> > people who currently expect all the processes to compete equally will now 
> > find that they no longer do so. If I am understanding this correctly, this 
> > could mean that a box that was dedicated to running one application will 
> > now have that application no longer dominate the system, instead it will 
> > 'share equally' with the housekeeping apps on the system.
> > 
> > what would need to be done to revert to the prior situation?
> 
> build with: CONFIG_SCHED_AUTOGROUP=n, 
> boot with: noautogroup or 
> runtime: echo 0 > /proc/sysctl/kernel/sched_autogroup_enabled
> 
> (although the latter is a lazy one, it won't force existing tasks back
> to the root group)

I think this might create some issues with controllers which support some
kind of upper limit on resource usage. These hidden group can practically
consume any amount of resource and because use space tools can't see these,
they will not be able to place a limit or control it.

If it is done from user space and cgroups are visible, then user can 
atleast monitor the resource usage and do something about it.

Thanks
Vivek
