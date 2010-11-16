Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab0KPTXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:23:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab0KPTX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:23:29 -0500
Date: Tue, 16 Nov 2010 14:22:06 -0500
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
Message-ID: <20101116192206.GG13092@redhat.com>
References: <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de>
 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de>
 <1289931715.2109.648.camel@laptop>
 <AANLkTik7cR_5JJWfk8SEf3Dngfe7yZvuivJ66dVDOuAk@mail.gmail.com>
 <alpine.DEB.2.00.1011161047060.3718@asgard.lang.hm>
 <1289933965.2109.652.camel@laptop>
 <20101116190916.GD13092@redhat.com>
 <1289934800.2109.653.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289934800.2109.653.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 08:13:20PM +0100, Peter Zijlstra wrote:
> On Tue, 2010-11-16 at 14:09 -0500, Vivek Goyal wrote:
> 
> > I think this might create some issues with controllers which support some
> > kind of upper limit on resource usage. These hidden group can practically
> > consume any amount of resource and because use space tools can't see these,
> > they will not be able to place a limit or control it.
> > 
> > If it is done from user space and cgroups are visible, then user can 
> > atleast monitor the resource usage and do something about it.
> 
> Its cpu-controller only, and then only for SCHED_OTHER tasks which are
> proportionally fair.

In this thread there are already mentions of extending it to block
controller also which now supports the upper limit.

Secondly I am assuming at some point of time, cpu controller will also
support throttling (including SCHED_OTHER class).

So as it is not a problem but the moment we start extending this logic
to other controllers supporting upper limits it does pose the question
that how do we handle it.

Even if we automatically create groups inside the kernel (because for all the
reasons that why user space can't do it), it probably should create cgroups
also so that these are visible to user space and not hidden.

Thanks
Vivek
