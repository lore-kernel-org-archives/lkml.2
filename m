Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab0KPUvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:51:08 -0500
Received: from tango.0pointer.de ([85.214.72.216]:42087 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758203Ab0KPUvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:51:04 -0500
Date: Tue, 16 Nov 2010 21:50:43 +0100
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
Message-ID: <20101116205043.GG27235@tango.0pointer.de>
References: <20101116015648.GA11534@redhat.com>
 <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop>
 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de>
 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de>
 <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
 <AANLkTikjQKmo0j5xbvPiS=eriAUUZPMGKkcxt8w_z8XB@mail.gmail.com>
 <AANLkTikKdjH-ZM0eXTQMvzJjYkpyfKZR2OK06tNtCGFs@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikKdjH-ZM0eXTQMvzJjYkpyfKZR2OK06tNtCGFs@mail.gmail.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16.11.10 11:45, Linus Torvalds (torvalds@linux-foundation.org) wrote:

> 
> On Tue, Nov 16, 2010 at 11:27 AM, Dhaval Giani <dhaval.giani@gmail.com> wrote:
> >
> > So what do you think about something like systemd handling it. systemd
> > already does a lot of this stuff already in the form of process
> > tracking, so it is quite trivial to do this. And more happily avoids
> > all this complexity in the kernel.
> 
> What complexity? Have you looked at the patch? It has no complexity anywhere.
> 
> It's a _lot_ less complex than having system daemons you don't
> control. We have not had good results with that approach in the past.
> System daemons tend to cause nasty problems, and debugging them is a
> nightmare.

Well, userspace doesn't bite.

> For example: how do you do reference counting for a cgroup in user
> space, when processes fork and exit without you even knowing it? In
> kernel space, it's _trivial_. That's what kernel/autogroup.c does, and
> it has lots of support for it, because that kind of reference counting
> is exactly what the kernel does.

You can just do an rmdir from the cgroup release handler. Heck, "rmdir"
is a pretty good GC in itself, since it deletes a cgroup only if it is
empty.

> In a system daemon? Good luck with that. It's a nightmare. Maybe you
> could just poll all the cgroups, and try to remove them once a minute,
> and if they are empty it works. Or something like that. But what a
> hacky thing it would be.

Well, that nightmare already exists. It's systemd. We use the cgroup
release handler. If you ask me it's an aweful interface, but works
fine.

> And more importantly: I don't run systemd. Neither do a lot of other
> people. The way the patch does things, "it just works".

So this basically boils down to the fact that this is useful for your
particular usecase. Because you don't want to update userspace. But
don't claim this would be useful for anybody but you. It is definitely
irrelevant for the usual desktop usecase. 

> Did you go to the phoronix forum to look at how people reacted to the
> phoronix article about the patch? There were a number of testers. It
> was just so _easy_ to test and set up. If you want people to run some
> specific system daemon, it immediately gets much harder to set up and
> do.

Jeez. Phoronix!

If you truly believe that the Phoronix usecase of running "make -j64"
over the kernel tree was in any way relevant in real life for anybody
but kernel developers, then I can't help you.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
