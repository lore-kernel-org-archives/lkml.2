Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1CJVkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:40:03 -0500
Received: from blu0-omc1-s15.blu0.hotmail.com ([65.55.116.26]:4632 "EHLO
	blu0-omc1-s15.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751606Ab1CJVkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:40:01 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP797B5FD4BF58605204369796C80@phx.gbl>
Date: Thu, 10 Mar 2011 16:39:54 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
CC: David Daney <ddaney@caviumnetworks.com>, Jason Baron <jbaron@redhat.com>,
        peterz@infradead.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 0/2] jump label: update for .39
References: <cover.1299702291.git.jbaron@redhat.com> <1299728191.15854.319.camel@gandalf.stny.rr.com> <BLU0-SMTP690BB959832A97E002293396C80@phx.gbl> <1299771504.15854.347.camel@gandalf.stny.rr.com> <4D790A13.4060705@caviumnetworks.com> <1299780241.15854.393.camel@gandalf.stny.rr.com> <20110310182000.GB2906@redhat.com> <1299782143.15854.402.camel@gandalf.stny.rr.com> <4D791CAA.7090108@caviumnetworks.com> <1299783236.15854.405.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1299783236.15854.405.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 16:22:39 up 337 days,  7:12,  3 users,  load average: 0.18, 0.29,
	0.27
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 10 Mar 2011 21:40:00.0381 (UTC) FILETIME=[B5255AD0:01CBDF6B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2011-03-10 at 10:47 -0800, David Daney wrote:
> 
> > The alignment requested by the assembler will have to satisfy *all* the 
> > requested alignments, so manually forcing everything to .align 8 (or 
> > .align 4 for 32-bit) should ensure that the linker doesn't put in any holes.
> 
> I would agree with the assessment although, I don't know that it is
> documented anywhere that this is what happens. As the previous "bug"
> with the trace_events was solved by me adding .align(4) everywhere, I
> would think that .align(sizeof(long)) would work here too.
> 
> It may be a good ideal to force this alignment, and not add wasted
> space. If anything, if this (hypothetical) bug appears, it will most
> likely show up as a crash on boot up. I'm not too concerned about it.

How can you be so sure it will trigger a crash on boot up ?

The sorting phase only compare key values, so NULL pointers will be
thought as valid. Following that, there is the initial no-op'ing phrase
that might crash (on the architectures using it). Then a NULL code
pointer is considered as the discarded "init" section. A NULL key will
just be a non-match, and thus skipped.

So I can very much see scenarios where this bug would silently skip jump
labels without a crash. This is what I am concerned about. Using the
approach that "a crash will happen" as a safety net to tell us that we
missed something seems very risky to me.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
