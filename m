Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab1LYRqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 12:46:37 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:46303 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab1LYRqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 12:46:35 -0500
Date: Sun, 25 Dec 2011 12:46:13 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
        devel@driverdev.osuosl.org, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: Perf ABI (was: Re: [lttng-dev] [PATCH 09/11] sched: export
 task_prio to GPL modules)
Message-ID: <20111225174613.GA12732@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
	devel@driverdev.osuosl.org, Peter Zijlstra <peterz@infradead.org>,
	linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
References: <20111205141749.GC28866@elte.hu>
 <20111206214446.GD1247@kroah.com>
 <20111208052354.GC9485@elte.hu>
 <20111208232709.GA19820@kroah.com>
 <20111219104915.GA19861@elte.hu>
 <20111219153053.GA21548@Krystal>
 <20111220110813.GA19105@elte.hu>
 <20111223164629.GA30474@Krystal>
 <20111223172155.GA14117@thunk.org>
 <20111223181641.GA12681@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111223181641.GA12681@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 01:16:41PM -0500, Mathieu Desnoyers wrote:
> 
> (note that ABI to control the tracer and ABI to transport data could
> share the same version numbering if the control tools and transport
> tools happen to reside in the same user-level packages)

Being able to control the tracer but then not being able to look at
the trace output is useless.  So they might as well be the same
thing....

> - The trace data format
>   - Both versioned _and_ self-described.
>   Self-description of the event/field layout allows the same tools to
>   understand traces gathered on different kernel versions, on different
>   architectures, with different tracer configurations.
>   Versioning on top of the self-described trace format allows changes
>   to what the trace self-description can express.

So there are two ways to do this.  One is to make changes be backwards
compatible, so that the trace data format only breaks if you use the
new feature; if it doesn't you encode things the old fashioned way.
The other way of doing things is to randomly break users whenever the
tracing developers decide to add some random new feature, regardless
of whether or not a partiuclar user finds that new feature to be
useful.

The first is acceptable.  The second, IMHO, is not.  Linus has said
quite strongly that WE DO NOT BREAK USERSPACE.   Period.

Regards,

					- Ted
