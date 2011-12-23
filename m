Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab1LWRWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 12:22:17 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:40083 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757499Ab1LWRWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 12:22:13 -0500
Date: Fri, 23 Dec 2011 12:21:55 -0500
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
Message-ID: <20111223172155.GA14117@thunk.org>
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
References: <1322780830.4699.62.camel@twins>
 <20111201231751.GA4961@kroah.com>
 <20111205141749.GC28866@elte.hu>
 <20111206214446.GD1247@kroah.com>
 <20111208052354.GC9485@elte.hu>
 <20111208232709.GA19820@kroah.com>
 <20111219104915.GA19861@elte.hu>
 <20111219153053.GA21548@Krystal>
 <20111220110813.GA19105@elte.hu>
 <20111223164629.GA30474@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111223164629.GA30474@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 11:46:29AM -0500, Mathieu Desnoyers wrote:
> - It's doing so without even needing it: Perf is using an ABI versioning
>   scheme designed for filesystems, when it is not in fact driven by the
>   same constraints.

Well, there are *some* constraints.  I've been assured that despite
the fact that the perf client is in the kernel sources (something
which I still think is a bad idea, since it's leading to other bad
choices like kvm-tool wanting to be bundled with kernel sources), that
it is *not* a license to jerk the format around wildly --- that people
will have installed userspace binaries that shouldn't randomly break
they boot a new kernel.

So I'm *glad* that Perf is using an ABI versioning scheme that accepts
the same restraints as file systems.  It means we don't randomly break
userspace tools.

So Mathieu, if you think it is the current standards of backwards
compatibility are too rigid, what level of tool breakage do you think
is acceptable?  It's not just about the backwards compatibility of the
trace files, it's also about compatibility of userspace utilities.

For example, systemtap, where you had to recompile from source at
each kernel revision, and pray it would still build goes too far in
the other direction, wouldn't you agree?  What is the correct level of
kernel developer annoyance you think is appropriate to inflict on
ourselves?

Regards,


						- Ted
