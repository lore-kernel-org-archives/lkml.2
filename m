Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933672Ab0KQO6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 09:58:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757404Ab0KQO6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 09:58:35 -0500
Date: Wed, 17 Nov 2010 09:57:13 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Ted Ts'o" <tytso@mit.edu>, Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101117145712.GA29892@redhat.com>
References: <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de>
 <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
 <20101116202839.GC27235@tango.0pointer.de>
 <20101116205243.64e4a67a@lxorguk.ukuu.org.uk>
 <AANLkTinSXM5RMH+1FHtkYJiehcyZaxZGs0z4ycLGGE9u@mail.gmail.com>
 <20101116211909.GB16589@tango.0pointer.de>
 <20101116233934.GC1568@thunk.org>
 <20101117002159.GA3184@tango.0pointer.de>
 <20101117020626.GB3290@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117020626.GB3290@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 09:06:26PM -0500, Ted Ts'o wrote:
> On Wed, Nov 17, 2010 at 01:21:59AM +0100, Lennart Poettering wrote:
> > > I think you really want to make this be something which the
> > > application can specify by default that they should start in their own
> > > cgroup.  One idea might be to it to the applications menu entry:
> > > 
> > > http://standards.freedesktop.org/desktop-entry-spec/latest/
> > > 
> > > ... so there would be a new key value pair, "start_in_cgroup", that
> > > would allow the user to start an application in their own cgroup.  It
> > > would be up to the desktop launcher to honor that if it was present.
> > 
> > This is pretty much in line with what I want to do, except I want
> > opt-out, not opt-in behaviour here.
> 
> That works for me.  One suggestion is that in addition to "opt-out",
> it should be also possible for an application launcher file to specify
> a specific cgroup name that should be used.  That would allow multiple
> applications in a group to assigned to the same cgroup.

Being able to specify cgroup name/path is a good idea. That way one can
make use of cgroup hierarchy also.

Thinking more about opt-in vs opt-out issue. Generally cgroups provide
some kind of isolation between application groups and in the process
can be somewhat expensive. More memory allocation, more accounting overhead
and for CFQ block controller it can also mean additional idling and can result
in overall reduced throughput.

Keeping that in mind, is it really a good idea to launch each application
in a separate group. Will it be better to let user decide if the
application should be launched in a separate cgroup? 

The flip side is that how many people will really know about the functionality
and will really launch application in a separate group. And may be it is
a good idea to put everybody in a seprate cgroup by default even it means
some cost so that if a application starts consuming too much of resources
(make -j64), then its impact on rest of the groups can be contained.

I really don't have strong inclination for one over other. Just thinking
loud...

Vivek
