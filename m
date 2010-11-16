Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab0KPU3C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:29:02 -0500
Received: from tango.0pointer.de ([85.214.72.216]:41362 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab0KPU27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:28:59 -0500
Date: Tue, 16 Nov 2010 21:28:39 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101116202839.GC27235@tango.0pointer.de>
References: <20101115125716.GA22422@redhat.com>
 <1289856350.14719.135.camel@maggy.simson.net>
 <20101116015648.GA11534@redhat.com>
 <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop>
 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de>
 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de>
 <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16.11.10 10:49, Linus Torvalds (torvalds@linux-foundation.org) wrote:

> Because it's something we want to do it for all users, and for all
> shells, and make sure it gets done automatically. Including for users
> that have old distributions etc, and make it easy to do in one place.
> And then you do it for all the other heuristics we can see easily in
> the kernel. And then you do it magically without users even having to
> _notice_.

Well, this feature is pretty much interesting only for kernel hackers
anyway. It is completely irrelevant for normal desktop people. Because
a) normal users don't use many terminals anyway and that very seldom and
b) if they do that they do not create gazillion of processes from one of
the terminals and only very few in the other. Because only then this
patch becomes relevant.

Heck, the patch wouldn't even have any effect on my machine (and I am
hacker), because I tend to run my builds from within emacs. And since
emacs has no TTY (since it is a X11/gtk build) it wouldn't be in its own
scheduling group.

So, this patch only has an effect of people who build kernels from an
xterm with make -j all day, and at the same time want to watch a movie,
from a player they also start from a terminal, but from another one.

Only in such a setup this patch matters. And for everybody else it is
completely irrelevant. If you don't use terminals it has no effect. If
you don't run massivily parallel CPU hoggers it has no effect. If you do
not run your mplayer from a terminal it has no effect. 

The kernel bears your name, but that doesn't mean your own use of it was
typical for more than you and a number kernel hackers like you.

Also, this implicit assumption that nobody would ever see this because
people upgrade their kernels often and userspace seldom is just nonsense
anyway. That's how *you* do it. But in reality userspace is updated for
most folks way more often then the kernel is.

Or to turn this around: think how awesome that would be if we did this
in userspace, then we could support older kernels too and wouldn't have
to upgrade everything to your not-yet-released new kernel.

Suddenly it doesn't seem that wonderful anymore to play with the kernel
to add this, does it?

> Suddenly it doesn't seem that wonderful any more to play with bashrc,
> does it?

Well, I have no plans in pushing anybody to do this in bash really. All
I am saying that tying this to a tty is crazy. And this is policy, and
should be done in userspace, and we are almost there to do this in
userspace.

In fact, I just prepped a patch to systemd to move every service and
every user session into its own cgroup in the 'cpu' hierarchy (in
addition to the group it already creates in the 'systemd' hierarchy). On
a system that runs systemd for both managing users and sessions this
means you are already half-way at what you want. 

> User-level configuration for something that should just work is
> annoying. We can do better.

Well, that says you, as a kernel hacker. For you it is easier to hack
the kernel than to fiddle with the rest of the stack. Doesn't make it the
right fix. You know, there are a lot of userspace folsk being afraid of
and too lazy to hacking the kernel and hence rather workaround kernel
fuckups in userspace then fixing it properly. But you are doing it the
other way round, since userspace gives you the creeps you want to add
something to the kernel that doesn't really have any value for anybody
but a number of kernel folks, and is policy anyway, and what userspace
people are working on anyway.

> Put another way: if we find a better way to do something, we should
> _not_ say "well, if users want it, they can do this <technical thing
> here>". If it really is a better way to do something, we should just
> do it. Requiring user setup is _not_ a feature.

Well, if I make behaviour like this default in systemd, then this means
there won't be user setup for this. Because the distros shipping systemd
will get this as default behaviour.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
