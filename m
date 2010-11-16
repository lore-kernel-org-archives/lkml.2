Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab0KPVJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:09:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758905Ab0KPVJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:09:45 -0500
MIME-Version: 1.0
In-Reply-To: <20101116205243.64e4a67a@lxorguk.ukuu.org.uk>
References: <20101115125716.GA22422@redhat.com> <1289856350.14719.135.camel@maggy.simson.net>
 <20101116015648.GA11534@redhat.com> <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop> <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de> <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de> <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
 <20101116202839.GC27235@tango.0pointer.de> <20101116205243.64e4a67a@lxorguk.ukuu.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Nov 2010 13:08:49 -0800
Message-ID: <AANLkTinSXM5RMH+1FHtkYJiehcyZaxZGs0z4ycLGGE9u@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Lennart Poettering <mzxreary@0pointer.de>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 12:52 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Well, if I make behaviour like this default in systemd, then this means
>> there won't be user setup for this. Because the distros shipping systemd
>> will get this as default behaviour.
>
> And within the desktop where would you put this - in the window manager
> on the basis of top level windows or in the app startup ?

Btw, I suspect either of these are reasonable. In fact, I don't think
it would be at all wrong to have the desktop launcher have an option
to "launch in a group" (although I think it would need to be named
better than that). Right now, when you create desktop launchers under
at least gnome, it allows you to specify a "type" for the application
("Application" or "Application in Terminal"), and maybe there could be
a "CPU-bound application" choice that would set it in a CPU group of
its own. Or whatever.

So I do _not_ believe that the autogroup feature should necessarily
mean that you cannot do other grouping decisions too. I just do think
that the whole notion of "it got started from a tty" is actually a
very useful thing for legacy applications, and one where it's just
simpler to do it in the kernel than build up any extra infrastructure
for it.

So it's not necessarily at all an "either-or" thing.

                           Linus
