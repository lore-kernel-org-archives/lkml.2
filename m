Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab0KPUgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:36:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755180Ab0KPUgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:36:06 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikJoeOOAJco_y8pF0Qa9K239oEWh_p8q1605chx@mail.gmail.com>
References: <1289820766.16406.45.camel@maggy.simson.net> <1289821590.16406.47.camel@maggy.simson.net>
 <20101115125716.GA22422@redhat.com> <1289856350.14719.135.camel@maggy.simson.net>
 <20101116015648.GA11534@redhat.com> <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop> <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de> <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de> <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
 <AANLkTi=Z5CK3fOgXNs9odKnQNFHsbavpOvw8c3kh6zEG@mail.gmail.com> <AANLkTikJoeOOAJco_y8pF0Qa9K239oEWh_p8q1605chx@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Nov 2010 12:35:13 -0800
Message-ID: <AANLkTikW==rTHa5DPABfJ6m_-68cQBNV3m6BayJqvd0=@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Pekka Enberg <penberg@kernel.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
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

On Tue, Nov 16, 2010 at 12:21 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>
> The only problem is that *desktop* users use *desktop* apps, which
> never have a controlling tty.

Yes. And have you noticed people complaining about stuttering while
they run just their desktop app? No.

That's the thing. If you run a web browser and you use a flash player
to view youtube or whatever in it, and only use other interactive
desktop apps anyway, you won't see any problems _regardless_. It's not
like the other desktop app you have open (and is idle, because you're
not touching it) will matter.

Ask yourself who is complaining? _I_ have been complaining for years
about desktop latency. I usually do it in private to developers, but
trust me, I do it. Much of it has been about IO (the whole fsync
fiasco), but some of it has been about the scheduler.

Look at who were trying out Con's patches. They were compiling things
and running games at the same time. That's literally the kind of loads
that people were looking at. Partly because that's the kinds of loads
we haven't been good at. And it's the kind of load that this helps
with.

Anyway, I find it depressing that now that this is solved, people come
out of the woodwork and say "hey you could do this". Where were you
guys a year ago or more?

Tough. I found out that I can solve it using cgroups, I asked people
to comment and help, and I think the kernel approach is wonderful and
_way_ simpler than the scripts I've seen. Yes, I'm biased ("kernels
are easy - user space maintenance is a big pain").

                   Linus
