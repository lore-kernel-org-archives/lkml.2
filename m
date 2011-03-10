Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab1CJVWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:22:21 -0500
Received: from blu0-omc1-s20.blu0.hotmail.com ([65.55.116.31]:8131 "EHLO
	blu0-omc1-s20.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751077Ab1CJVWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:22:20 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP58EC26791F850066BFEAE996C80@phx.gbl>
Date: Thu, 10 Mar 2011 16:22:14 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
CC: David Daney <ddaney@caviumnetworks.com>, Jason Baron <jbaron@redhat.com>,
        peterz@infradead.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 0/2] jump label: update for .39
References: <1299771504.15854.347.camel@gandalf.stny.rr.com> <4D790A13.4060705@caviumnetworks.com> <1299780241.15854.393.camel@gandalf.stny.rr.com> <20110310182000.GB2906@redhat.com> <1299782143.15854.402.camel@gandalf.stny.rr.com> <4D791CAA.7090108@caviumnetworks.com> <1299783236.15854.405.camel@gandalf.stny.rr.com> <4D791F31.6040100@caviumnetworks.com> <1299785143.15854.407.camel@gandalf.stny.rr.com> <1299786329.15854.409.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1299786329.15854.409.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 16:20:52 up 337 days,  7:10,  3 users,  load average: 0.54, 0.34,
	0.28
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 10 Mar 2011 21:22:19.0360 (UTC) FILETIME=[3CBA6600:01CBDF69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2011-03-10 at 14:25 -0500, Steven Rostedt wrote:
> > On Thu, 2011-03-10 at 10:57 -0800, David Daney wrote:
> > > On 03/10/2011 10:53 AM, Steven Rostedt wrote:
> > > > On Thu, 2011-03-10 at 10:47 -0800, David Daney wrote:
> > > >
> > > >> The alignment requested by the assembler will have to satisfy *all* the
> > > >> requested alignments, so manually forcing everything to .align 8 (or
> > > >> .align 4 for 32-bit) should ensure that the linker doesn't put in any holes.
> > > >
> > > > I would agree with the assessment although, I don't know that it is
> > > > documented anywhere that this is what happens. As the previous "bug"
> > > > with the trace_events was solved by me adding .align(4) everywhere, I
> > > > would think that .align(sizeof(long)) would work here too.
> > > >
> > > > It may be a good ideal to force this alignment, and not add wasted
> > > > space. If anything, if this (hypothetical) bug appears, it will most
> > > > likely show up as a crash on boot up. I'm not too concerned about it.
> > > >
> > > 
> > > If the linker put in gratuitous holes, things like  __ex_table would 
> > > break too.
> > 
> > Again, as I have said (although I said extable not __ex_table), there
> > seems to be no problem when the data is of a power of 2 as well. As
> > __ex_table size is a power of 2. We just don't know if the linker will
> > add holes when the size is something other than power of 2.
> 
> Anyway, I think the best thing for now is to have Jason add
> the .align(sizeof(long)) in the inline assembly for all locations and be
> done with it.

You seem to be contradicting yourself here. I'm concerned about having
"structures" of a size not power of two. Can we simply either

- Add a padding element at the end
or
- use .align 4*sizeof(long) at the beginning

to make sure the linker won't put any holes when it puts objects 
together ?

Thanks,

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
