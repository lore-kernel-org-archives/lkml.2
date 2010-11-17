Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934797Ab0KQPgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:36:09 -0500
Received: from canuck.infradead.org ([134.117.69.58]:44420 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757672Ab0KQPgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:36:06 -0500
Subject: Re: [RFC][PATCH 1/5] [PATCH 1/5] events: Add EVENT_FS the event
 filesystem
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Christoph Hellwig <hch@lst.de>
In-Reply-To: <1290007019.30543.65.camel@gandalf.stny.rr.com>
References: <20101117005357.024472450@goodmis.org>
	 <20101117005939.600541101@goodmis.org> <20101117033242.GB31335@suse.de>
	 <20101117103914.GA21976@elte.hu>
	 <1289996753.30543.35.camel@gandalf.stny.rr.com>
	 <20101117150332.GA7603@elte.hu>
	 <1290007019.30543.65.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 16:35:50 +0100
Message-ID: <1290008150.2109.953.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 10:16 -0500, Steven Rostedt wrote:
> What about a tool that picks up tracepoints that were only used by a
> developer for in-field debugging, and then that tracepoint disappears
> because of a design change. Is it OK for that tool to break with it?
> 
> Do all tools that use tracepoints require a "check" feature?

Not sure what you mean with a 'check' feature, but I do think its useful
to tools authors to clearly delineate between stable and debug
tracepoints, that also facilitates

> I guess the problem is that creators of the tools to analyze the kernel
> have no idea of what they can count on and what they can't. Do we need a
> process to have these tool creators request to developers to "keep this
> tracepoint"? 

the process mentioned here, if they cannot find the data they want
through existing stable tracepoints they have to request it, or
otherwise clearly suffer breakage whenever we feel like changing stuff.

A nice aspect of devs coming to us and requesting data is that we get a
fairly good idea of what tools are available and get to discuss the
problem they're trying to solve.

Esp. that latter point is a very good one imho, we might have a totally
different view on some of the problems :-)
