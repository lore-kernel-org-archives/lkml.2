Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab1EQVcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 17:32:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:3648 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269Ab1EQVcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 17:32:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,227,1304319600"; 
   d="scan'208";a="437835286"
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH v4 0/6] Micro-optimize vclock_gettime
References: <20110516160943.GC25898@one.firstfloor.org>
	<alpine.LFD.2.02.1105161817120.3078@ionos>
	<20110516164939.GD25898@one.firstfloor.org>
	<BANLkTintkmnkN3kW06oa+TjT7W0Q1yQQGA@mail.gmail.com>
	<m2fwoeo0pf.fsf@firstfloor.org>
	<alpine.LFD.2.02.1105162345110.3078@ionos>
	<BANLkTinVnr1ZM2wOxuH-rHZGh+_SBWT-+g@mail.gmail.com>
	<alpine.LFD.2.02.1105170022430.3078@ionos>
	<20110517080029.GB22093@elte.hu>
	<BANLkTimpEfb3P9FWgrCDwSSVr6RA8nXb5w@mail.gmail.com>
	<20110517113634.GC13475@elte.hu> <4DD2BEFB.6070609@mit.edu>
Date: Tue, 17 May 2011 14:31:26 -0700
In-Reply-To: <4DD2BEFB.6070609@mit.edu> (Andy Lutomirski's message of "Tue, 17
	May 2011 14:31:23 -0400")
Message-ID: <m2hb8typxt.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@MIT.EDU> writes:
>
> On KVM on Sandy Bridge, I can emulate a vsyscall that does nothing in 400ns or so.  I'll try to make this code emulate real vsyscalls over the weekend.  This was much easier than I expected.

How about the performance of all the statically linked programs? I guess
you just declared they don't matter? gettimeofday is quite critical
and adding a exception into it is just a performance desaster.

Also it's always a dangerous assumption to think that all
programs on Linux use glibc ("all world is a Vax")

In fact more and more of Linux users are using different libcs these
days (like Android or embedded systems or languages with special runtime
systems) Who knows if all those other libraries use vDSO?

And then there are of course the old glibcs. A lot of people
(including me) use new kernels with old userland.

For me this seems like a very risky move -- breaking performance of
previously perfectly good set ups for very little reason.

Given the old vsyscall code is somewhat ugly -- I wouldn't argue that --
but compatibility (including performance compatibility) has always
been importand in Linux and we have far uglier code around in the name of 
compatibility..

And the "security problem" you keep talking about can be fixed
much easier and more compatible as I pointed out.

As far as I'm concered the change is a bad idea.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
