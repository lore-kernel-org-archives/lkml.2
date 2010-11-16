Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab0KPTJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:09:19 -0500
Received: from mail.lang.hm ([64.81.33.126]:55607 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280Ab0KPTJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:09:18 -0500
Date: Tue, 16 Nov 2010 11:08:28 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Lennart Poettering <mzxreary@0pointer.de>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
In-Reply-To: <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1011161058180.3718@asgard.lang.hm>
References: <1289820766.16406.45.camel@maggy.simson.net> <1289821590.16406.47.camel@maggy.simson.net> <20101115125716.GA22422@redhat.com> <1289856350.14719.135.camel@maggy.simson.net> <20101116015648.GA11534@redhat.com> <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop> <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com> <20101116170312.GA19327@tango.0pointer.de> <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com> <20101116181603.GC19327@tango.0pointer.de>
 <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010, Linus Torvalds wrote:

> On Tue, Nov 16, 2010 at 10:16 AM, Lennart Poettering
> <mzxreary@0pointer.de> wrote:
>>
>> Here's my super-complex patch btw, to achieve exactly the same thing
>> from userspace without involving any kernel or systemd patching and
>> kernel-side logic. Simply edit your own ~/.bashrc and add this to the end:
>
> Right. And that's basically how this "patch" was actually tested
> originally - by doing this by hand, without actually having a patch in
> hand. I told people: this seems to work really well. Mike made it work
> automatically.
>
> Because it's something we want to do it for all users, and for all
> shells, and make sure it gets done automatically. Including for users
> that have old distributions etc, and make it easy to do in one place.
> And then you do it for all the other heuristics we can see easily in
> the kernel. And then you do it magically without users even having to
> _notice_.
>
> Suddenly it doesn't seem that wonderful any more to play with bashrc, does it?

agreed

> That's the point. We can push out the kernel change, and everything
> will "just work". We can make that feature we already have in the
> kernel actually be _useful_.
>
> User-level configuration for something that should just work is
> annoying. We can do better.
>
> Put another way: if we find a better way to do something, we should
> _not_ say "well, if users want it, they can do this <technical thing
> here>". If it really is a better way to do something, we should just
> do it. Requiring user setup is _not_ a feature.

agreed, the question is if this really is a better way. It's definantly a 
change.

> Now, I'm not saying that we shouldn't allow users to use cgroups. Of
> course they can do things manually too. But we shouldn't require users
> to do silly things that we can more easily do ourselves.
>
> If the choice is between telling everybody "you should do this", and
> "we should just do this for you", I'll take the second one every time.
> We know it should be done. Why should we then tell somebody else to do
> it for us?

this is good for desktop interactivity because it no longer treats all 
processes equally, it give more CPU to processes that are running 
'stand-alone' then it will to processes that are forked off from one 
master process.

In the desktop case where you really want something like 'make -j64' to be 
in the background and not interfere with the other tasks, but what about 
the situation of a dedicated web server? on that box the apache processes 
will get less CPU because they will all be in one group, and other things 
that happen on the box will get more CPU as they will be in different 
groups.

Is this really the right change to make?

having an option to do this sounds like a wonderful idea, and I would 
expect that desktop distros would want to have it default to 'on', but 
should it really be a default?

David Lang
