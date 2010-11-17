Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab0KQSmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 13:42:39 -0500
Received: from thunk.org ([69.25.196.29]:40813 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758394Ab0KQSmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 13:42:38 -0500
Date: Wed, 17 Nov 2010 13:42:31 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 1/5] [PATCH 1/5] events: Add EVENT_FS the event
 filesystem
Message-ID: <20101117184231.GI3290@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Steven Rostedt <rostedt@goodmis.org>, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lin Ming <ming.m.lin@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20101117005357.024472450@goodmis.org>
 <20101117005939.600541101@goodmis.org>
 <20101117033242.GB31335@suse.de>
 <20101117103914.GA21976@elte.hu>
 <1289996753.30543.35.camel@gandalf.stny.rr.com>
 <20101117150332.GA7603@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117150332.GA7603@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 04:03:32PM +0100, Ingo Molnar wrote:
> 
> I think Arjan's complaints at the KS stemmed from prior sporadic
> declarations on lkml that there is no tracepoint ABI _at all_, and
> that powertop/latencytop could break anytime.
> 
> But in reality i strongly disagree with such declarations, and
> tracepoint data that is used by PowerTop/timechart/latencytop or
> perf is and was an ABI, simple as that - and i've been enforcing
> that for two years. (We have so few good instrumentation tools that
> we _really_ dont want to break them.)

There was general consensus at the kernel summit that the tracepoints,
being deliberately in /sys/kernel/debug was unstable and today exposes
internal implementation details --- and that that people putting
different traceponts in Documentation/ABI/{testing,stable,unstable}
simply doesn't work.

Heck, I've recently had to make changes to tracepoints because
otherwise perf would fall over dead when it tripped over an ext4
tracepoint, due to its limitations dealing with what we could put into
TP_PRINTK().  Saying that tracepoints are stable ABI that must never
change, forever and ever, amen, is simply a non-starter.

> I simply dont see the 'problem' that is being solved here. We had a
> stable ABI and we didnt break sysprof or powertop/latencytop in the
> past and wont break it in the future either.

I think the general consensus is that we didn't have a stable ABI, and
the tension between what kernel developers need for debugging, which
of necessity is kernel version specific, and what gets exposed as a
stable ABI that tools can depend upon, is not one that can be
resolved.

Regards,

						- Ted
