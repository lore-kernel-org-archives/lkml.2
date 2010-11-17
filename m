Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934742Ab0KQPRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:17:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:42574 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933782Ab0KQPRA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:17:00 -0500
Subject: Re: [RFC][PATCH 1/5] [PATCH 1/5] events: Add EVENT_FS the event
 filesystem
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20101117150332.GA7603@elte.hu>
References: <20101117005357.024472450@goodmis.org>
	 <20101117005939.600541101@goodmis.org> <20101117033242.GB31335@suse.de>
	 <20101117103914.GA21976@elte.hu>
	 <1289996753.30543.35.camel@gandalf.stny.rr.com>
	 <20101117150332.GA7603@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 16:16:49 +0100
Message-ID: <1290007009.2109.926.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 16:03 +0100, Ingo Molnar wrote:
> I think Arjan's complaints at the KS stemmed from prior sporadic declarations on 
> lkml that there is no tracepoint ABI _at all_, and that powertop/latencytop could 
> break anytime. 

And it will, afaik Arjan refused to even parse the format file which is
part of the tracepoint abi and I'll be changing those for the scheduler.

I really object to not being able to make sane changes just because some
tool is too lazy to even implement the full ABI that was exposed.


> I think Arjan's complaints at the KS stemmed from prior sporadic declarations on 
> lkml that there is no tracepoint ABI _at all_, and that powertop/latencytop could 
> break anytime. 

I fully intent to break powertop/latencytop if they refuse to use the
format file, deal with it.

Also, in the unlikely event we need to re-order the task->state bits
I'll do so without a moments hesitation, regardless of who consumes them
through the scheduler tracepoints, that's simply not stuff that should
be tied down.

The same for anything that tries to interpret task->prio through the
tracepoints.
