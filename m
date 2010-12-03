Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab0LCPqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:46:36 -0500
Received: from mail.openrapids.net ([64.15.138.104]:48193 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751045Ab0LCPqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:46:35 -0500
Date: Fri, 3 Dec 2010 10:46:33 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC][PATCH 1/2 v2] tracing: Add TRACE_EVENT_CONDITIONAL()
Message-ID: <20101203154633.GA25790@Krystal>
References: <20101203040358.955427199@goodmis.org> <20101203040822.144348122@goodmis.org> <20101203045402.GA29609@Krystal> <1291385344.3228.4.camel@gandalf.stny.rr.com> <20101203152733.GA25580@Krystal> <1291390727.3228.10.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291390727.3228.10.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:44:37 up 9 days, 20:47,  3 users,  load average: 0.12, 0.03,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Fri, 2010-12-03 at 10:27 -0500, Mathieu Desnoyers wrote:
> 
> > > >   TP_CONDITION(unlikely(someparam)),
> > > 
> > > I actually think this is an abuse of "unlikely".
> > 
> > Why are you considering this an abuse ?
> 
> Because it is overused. I would rather get rid of most unlikely()'s
> because they are mostly meaningless. Just run the unlikely profiler, and
> you will see a large number of them are just plain incorrect.
> 
> Adding them here probably doesn't do any good. The only reason for this
> TP_CONDITION() is to ignore those cases that it just does not make sense
> to trace. Like a wake up tracepoint that does not wake anything up. No
> need for "unlikely" or "likely", by trying to do that, you will most
> likely get it wrong.
> 
> 	unlikely(use_likely_correctly)

Ah OK. You are afraid that people will misuse it, not saying that it would be
technically incorrect. Fair enough. It sounds like a good enough reason for not
documenting this use-case.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
