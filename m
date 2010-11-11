Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab0KKQeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 11:34:18 -0500
Received: from mail.openrapids.net ([64.15.138.104]:42168 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753064Ab0KKQeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 11:34:17 -0500
Date: Thu, 11 Nov 2010 11:34:15 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        ying.huang@intel.com, bp@alien8.de, tglx@linutronix.de,
        akpm@linux-foundation.org, mchehab@redhat.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: Tracing Requirements (was: [RFC/Requirements/Design] h/w error
	reporting)
Message-ID: <20101111163415.GB11348@Krystal>
References: <20101110174852.GB4001@elte.hu> <1289412329.12418.177.camel@gandalf.stny.rr.com> <1289413460.2084.27.camel@laptop> <20101110184105.GH22410@elte.hu> <1289415645.12418.180.camel@gandalf.stny.rr.com> <20101110191127.GA6190@nowhere> <20101110202316.GA32396@Krystal> <20101110213033.GA7682@nowhere> <20101111001110.GA32564@Krystal> <1289491816.12418.255.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289491816.12418.255.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:30:33 up 49 days, 20:32,  4 users,  load average: 0.25, 0.23,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2010-11-10 at 19:11 -0500, Mathieu Desnoyers wrote:
> 
> > > There are also the other common fields:
> > > 
> > > 	struct trace_entry {
> > > 		unsigned short		type;
> > > 
> > > 
> > > Type is needed by perf. If we have one buffer per event, we could
> > > retrieve which event we are dealing with. But if buffers are
> > > multiplexed per cpu, we need this.
> > 
> > Agreed, although 65536 types ID is probably overkill for the common case.
> > I prefer to go for approaches with a header that contains a smaller number of
> > bits, and use an extended header for those rare cases that need it.
> 
> Note, ftrace currently has over 600 event types. Unless we compact it
> down into bits, using two bytes is fine.

I understand that overall the numer of events overflows 256. However, this does
not mean they are typically all activated. Moreover, if we add multiple buffer
support, these events don't necessarily have to end up in the same buffer. This
numeric identifier is only there to distinguish between events ending in the
same buffer after all.

So the number of available events does not count as an argument for choosing the
typical number of bytes to represent the event IDs. The number of events
typically activated for a trace session does.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
