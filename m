Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab2LJP3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 10:29:35 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49888 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2LJP3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 10:29:34 -0500
MIME-Version: 1.0
In-Reply-To: <20121210151934.GS2516@linux.vnet.ibm.com>
References: <20121204130503.GA13878@linux.vnet.ibm.com>
	<20121208143757.GB12011@gmail.com>
	<20121210151934.GS2516@linux.vnet.ibm.com>
Date: Mon, 10 Dec 2012 17:29:33 +0200
Message-ID: <CAFTL4hxv0pd5xQh8oXM7dSKUAOHEYf1EugV=dnN++yYczV4ZWw@mail.gmail.com>
Subject: Re: [context tracking subsystem] Re: [GIT PULL rcu/next] One more RCU
 commit for 3.8
From: Frederic Weisbecker <fweisbec@gmail.com>
To: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/10 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Sat, Dec 08, 2012 at 03:37:57PM +0100, Ingo Molnar wrote:
>>
>> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
>>
>> > Hello, Ingo,
>> >
>> > Could you please pull one more commit?  This is an update to Frederic
>> > Weisbecker's context-tracking subsystem that is another stepping stone
>> > towards adaptive-idle and tickless userspace execution.  This has been
>> > subjected to -next testing.  It does give two checkpatch.pl errors,
>> > but these are on cpp macro definitions used within assembly code -- and
>> > following checkpatch.pl's suggestions would result in assembler errors.
>> > (I have reported this to Andy Whitcroft, checkpatch.pl's maintainer.)
>> >
>> > These changes are available in the git repository at:
>> >   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next
>> >
>> >                                                     Thanx, Paul
>> >
>> > ---------------->
>> > Frederic Weisbecker (1):
>> >       context_tracking: New context tracking susbsystem
>> >
>> >  arch/Kconfig                                       |   15 ++--
>> >  arch/x86/Kconfig                                   |    2 +-
>> >  arch/x86/include/asm/{rcu.h => context_tracking.h} |   15 ++--
>> >  arch/x86/kernel/entry_64.S                         |    2 +-
>> >  arch/x86/kernel/ptrace.c                           |    8 +-
>> >  arch/x86/kernel/signal.c                           |    5 +-
>> >  arch/x86/kernel/traps.c                            |    2 +-
>> >  arch/x86/mm/fault.c                                |    2 +-
>> >  include/linux/context_tracking.h                   |   18 ++++
>> >  include/linux/rcupdate.h                           |    2 -
>> >  init/Kconfig                                       |   28 ++++----
>> >  kernel/Makefile                                    |    1 +
>> >  kernel/context_tracking.c                          |   83 ++++++++++++++++++++
>> >  kernel/rcutree.c                                   |   64 +---------------
>> >  kernel/sched/core.c                                |   11 ++-
>> >  15 files changed, 150 insertions(+), 108 deletions(-)
>> >  rename arch/x86/include/asm/{rcu.h => context_tracking.h} (63%)
>> >  create mode 100644 include/linux/context_tracking.h
>> >  create mode 100644 kernel/context_tracking.c
>>
>> Pulled it and pushed it out earlier this week.
>>
>> One issue I wanted to raise on a bit wider forum was the
>> introduction of the (small) kernel/context_tracking.c subsystem.
>>
>> It makes sense to me, but I've Cc:-ed Linus and Andrew, in case
>> they have a different opinion.
>
> And it does appear that Frederic and I have a bit more explaining to do.  ;-)

Right :-)

Andrew strongly suggested us to give some more description of that
thing and the role and semantics of the new APIs. I indeed overlooked
that part. I'll send a patch soon.
