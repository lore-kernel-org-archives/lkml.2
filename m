Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab0KPTl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:41:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756145Ab0KPTl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:41:57 -0500
Date: Tue, 16 Nov 2010 14:40:36 -0500
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
Message-ID: <20101116194036.GH13092@redhat.com>
References: <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de>
 <1289931715.2109.648.camel@laptop>
 <AANLkTik7cR_5JJWfk8SEf3Dngfe7yZvuivJ66dVDOuAk@mail.gmail.com>
 <alpine.DEB.2.00.1011161047060.3718@asgard.lang.hm>
 <1289933965.2109.652.camel@laptop>
 <20101116190916.GD13092@redhat.com>
 <1289934800.2109.653.camel@laptop>
 <20101116192206.GG13092@redhat.com>
 <1289935527.2109.655.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289935527.2109.655.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 08:25:27PM +0100, Peter Zijlstra wrote:
> On Tue, 2010-11-16 at 14:22 -0500, Vivek Goyal wrote:
> > In this thread there are already mentions of extending it to block
> > controller also which now supports the upper limit.
> > 
> > Secondly I am assuming at some point of time, cpu controller will also
> > support throttling (including SCHED_OTHER class). 
> 
> Possibly, but in both cases its voluntary -- that is, unless explicitly
> configured a cgroup can use as much as possible. These auto groups will
> use that.
> 
> If you want more control, create your own cgroup so you can poke at the
> parameters at will.

I can create my own cgroups and control these. But one would like to
control these hidden groups also. For example, in a clustered environment
one might not want allow more than certain IOPS from machine X. In such
scenario one would like to see all the groups and possibly put the limit.

Now one can argue that thse groups are under root and put overall limit
on root and these groups get automatically controlled. But controllers
like block and memory also support flat mode where all the groups are
at same level.

		  pivot	
	        /   |   \
	       root  g2 g3

Here g2 and g3 are hidden auto groups and because it is flat configuration
putting limit on root will not help and one can not limit g2 and g3 and
one can not control total amount of IO from the system.

Now one can say use hierarchy and not flat setup. I am writting patches
to enable hierarchy but that is disabled by default as flat setup came
first and also there are concerns of accounting overhead etc.

So point being that these autogroups being hidden is a concern. Can we
do something so that these groups show up in cgroup hierarchy and are
then user controllable.

Thanks
Vivek
