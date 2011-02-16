Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab1BPJKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 04:10:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36858 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167Ab1BPJKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 04:10:31 -0500
Date: Wed, 16 Feb 2011 10:10:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/14] [GIT PULL][v2.6.39] tracing/filter: More robust
 filtering
Message-ID: <20110216091007.GC18842@elte.hu>
References: <20110208015617.902200587@goodmis.org>
 <20110215044425.GA9994@elte.hu>
 <1297776787.23343.104.camel@gandalf.stny.rr.com>
 <20110215184200.GA7335@elte.hu>
 <1297796375.23343.118.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297796375.23343.118.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Let me apologize again. [...]

No need to apologize - you raised valid questions that have come up in the past and 
i am pretty good at ignoring early-in-the-morning aspect of mails ;-)

> > Anyway, there's certainly encouraging responses in this thread so i'm hopeful 
> > that it's getting fixed and improved and we can push the generic bits upstream.
> 
> Yes, I'm hopeful too ;)

Great! :-)

If someone wants to dust off the 'trace' utility patches that are still in 
tip:tmp.perf/trace that would be fantastic. Thomas and Peter prototyped an 
ftrace-esque buffering model there, to have all events associated with a
single fd (and hence a single [per cpu] buffer).

Warning, they conflict left and right with the current code:

 kernel/sched.c
 kernel/trace/trace.c
 tools/perf/Makefile
 tools/perf/builtin-record.c
 tools/perf/util/event.c
 tools/perf/util/header.c
 tools/perf/util/parse-events.c
 tools/perf/util/session.c
 tools/perf/util/session.h

So it's quite a bit of work - and of course it was all very unfinished, not even 
reaching prototype stage really.

Thanks,

	Ingo
