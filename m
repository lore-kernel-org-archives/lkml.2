Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab0KRODB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:03:01 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47699 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757981Ab0KRODA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:03:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mbhLWsM3MtxKLrpAFhwv1ZZyHhk2SvynOf9sJaEjrIHuFGkB/ibbe2UzHzBrKErcez
         2YE2hpUJ04FAD4x/fiKlynXGc6AfS7KRDAqeOpCqA8BpTgGlDCf1KjXemIP+IMXhTnqY
         F/+C1JOVTdFUAwUUINqb+vCbHrxy4PXQ9aVTo=
Date: Thu, 18 Nov 2010 15:02:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "jason.wessel" <jason.wessel@windriver.com>,
        "Ted Ts'o" <tytso@mit.edu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC][PATCH 0/2] tracing: Have trace_printk()s in the events/
	directory
Message-ID: <20101118140252.GD5344@nowhere>
References: <20101118035803.453609353@goodmis.org> <1290076866.2109.1305.camel@laptop> <20101118125307.GB5344@nowhere> <1290085596.30543.112.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290085596.30543.112.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 08:06:36AM -0500, Steven Rostedt wrote:
> On Thu, 2010-11-18 at 13:53 +0100, Frederic Weisbecker wrote:
> > n other solution, which have been talking with Thomas yesterday, would be
> > to allow having a single fd for several perf_events at once. That would
> > solve some problems when you have hundreds of events opened (think about
> > wide tracing, or use of all individual syscalls).
> 
> I would highly recommend this. One type of tracing I do all the time is
> to enable all events (over 600). I don't think that is currently
> possible with trace and/or perf.


Yep.



> Ftrace has no issue simple because it just stores all the events into a
> single buffer (per cpu though). It does not care if there's one event or
> 1000.
> 
> You need to figure out how to do this as well with the function tracer.


Yeah for the function (and graph) tracers, I really plan to make it a single
event. I mean one for the function tracer and one for the function graph.
Although we may want two for the function graph tracer actually. One for
entry, one for exit.

