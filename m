Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934959Ab0KQVo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 16:44:59 -0500
Received: from www.tglx.de ([62.245.132.106]:60279 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758075Ab0KQVo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 16:44:57 -0500
Date: Wed, 17 Nov 2010 22:44:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Andre@firstfloor.org, ltt-dev@lists.casi.polymtl.ca,
        linux-kernel@vger.kernel.org, pierre-marc.fournier@polymtl.ca
Subject: Re: [ANNOUNCE] New tools: lttngtrace and lttngreport
In-Reply-To: <20101117173124.GB13717@Krystal>
Message-ID: <alpine.LFD.2.00.1011172146340.2900@localhost6.localdomain6>
References: <20101115134243.GA2772@Krystal> <20101115160745.GA7203@Krystal> <87y68sqiyb.fsf@basil.nowhere.org> <20101117173124.GB13717@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010, Mathieu Desnoyers wrote:

> * Andi Kleen (andi@firstfloor.org) wrote:
> > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
> > >
> > >         --> Blocked in RUNNING, SYSCALL 142 [sys_select+0x0/0xc0], ([...], dur: 0.029567)
> > >         |    --> Blocked in RUNNING, SYSCALL 168 [sys_poll+0x0/0xc0], ([...], dur: 1.187935)
> > >         |    --- Woken up by an IRQ: IRQ 0 [timer]
> > >         --- Woken up in context of 7401 [gnome-power-man] in high-level state RUNNING
> > 
> > Very nice! Now how can we get that with an unpatched kernel tree?
> 
> Well, I'm afraid the collection approach "trace" is currently taking won't allow
> this kind of dependency wakeup chain tracking, because they focus on tracing
> operations happening on a thread and its children, but the reality is that the
> wakeup chains often spread outside of this scope.

You are completely missing the point. There is no need to point out
that 'trace' does not do that. It is tracking a process (group)
context (though it can do system wide with the right permissions as
well).

And it's completely irrelevant for a user space programmer where the
kernel spends its time. What's not irrelevant is the information what
caused the kernel to spend time, i.e. which access to which data
resulted in a page fault or IO and how long did it take to come back.

It's completely irrelevant for him whether the kernel ran in circles
or not. If he sees a repeating pattern that a PF recovery or a
read/write to some file takes ages, he'll poke the sysadmin or the
kernel dude, which then will drill down into the gory details.

http://lwn.net/Articles/415760/

 "... Indeed I've been wishing for a tool which would easily tell me
 what pages I'm faulting in (and in what order) out of a 5GB mmaped
 file, in order to help debug performance issues with disk seeks when
 the file is totally paged out."

That's what relevant to user space developers, not the gory details
why the kernel took time X to retrieve that data from disk. Simply
because you can improve performance when you have such information by
rearranging your code and access patterns. The same applies for other
things like cache misses, which can be easily integrated into 'trace'.

> This is why lttngtrace gathers a system-wide trace even though we're mostly
> intested in the wait/wakeups of a specific PID.

Which results in a permission problem which you are completely
ignoring. Not a surprise though - I'm used to the academic way of
defining preliminaries and ignoring side effects just to get the paper
written.

> Wakeup dependency analysis depends on a few key events to track these chains.
> It's all described in Pierre-Marc Fournier's master thesis and implemented as

You seem to believe that kernel developers need to read a thesis to
understand wakeup chains and what it takes to trace them?

Dammit, we do that on a daily base and we did it even before we had
the ftrace/perf infrastructure in place without reading a thesis.

Stop this bullshit once and forever. You can do that in the lecture
room of your university and in the seminar for big corporate engineers
who are made to believe that this is important to improve their
productivity.

Your "DrTracing knows it better attitude" starts to be really annoying.

Thanks,

	tglx
