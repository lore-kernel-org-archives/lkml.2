Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab0LHOQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 09:16:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:44058 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab0LHOQ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 09:16:28 -0500
Subject: Re: [RFC][PATCH 2/2 v2] tracing: Only trace sched_wakeup if it
 actually work something up
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>
In-Reply-To: <1291817184.5015.866.camel@gandalf.stny.rr.com>
References: <20101203040358.955427199@goodmis.org>
	 <20101203040822.473086528@goodmis.org>  <1291810330.28378.6.camel@laptop>
	 <1291817184.5015.866.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Dec 2010 15:16:11 +0100
Message-ID: <1291817771.28378.35.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 09:06 -0500, Steven Rostedt wrote:
> On Wed, 2010-12-08 at 13:12 +0100, Peter Zijlstra wrote:
> > On Thu, 2010-12-02 at 23:04 -0500, Steven Rostedt wrote:
> > > Currently the tracepoint sched_wakeup traces the wakeup event even
> > > if the wakeup failed to wake anything up. This is quite stupid
> > > but it happens because we did not want to add a conditional
> > > to the core kernel code that would just slow down the wakeup events.
> > > 
> > Its actually quite useful at times, so no, I don't much like this.
> 
> OK, I'll remove this patch. This is why I kept it at the end of the
> queue.
> 
> But I'm curious. Linus ripped into me about the uselessness of this
> event when success was not true. What use do you see of this tracepoint
> when a wake up does not happen? I, personally, just filter these out.

Oh, some wake-up race like scenarios. Either when there's multiple
wakeups or things where the task was preempted and didn't need the full
wakeup.

There's also a sleep race, where the wakeup came before we went to
sleep, etc..

The success=0 wakeup is lots faster than the full wakeup (for obvious
reasons), so when analyzing performance related things, one of the
things I look at is the ratio of wakeup success. If the faster case got
lots of unsuccessful wakeups you know there's probably some (wakeup)
preemption like thing gone wrong with the slower case.

In all those cases its nice to see _that_ a wakeup was attempted and
when it was, even if it was unsuccessful.


