Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab2EULhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 07:37:04 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54304 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab2EULhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 07:37:02 -0400
Date: Mon, 21 May 2012 13:36:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Julia Lawall <julia@diku.dk>, Tom Zanussi <tzanussi@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 00/15] tools: Unify perf and trace-cmd trace event format
 parsing v3
Message-ID: <20120521113651.GA23687@somewhere>
References: <1335356819-16710-1-git-send-email-fweisbec@gmail.com>
 <20120521084422.GC31407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120521084422.GC31407@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 10:44:22AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Hi,
> > 
> > This is essentially a rebase against latest tip:perf/core updates.
> > Mostly due to conflicts against the perf Makefile updates.
> > 
> > I think we all agree that this library needs improvements but these
> > should rather be done incrementally. The current perf trace event parsing
> > is anyway much backward compared to that library.
> > 
> > Default target is a static library in tools/libtraceevent/libtraceevent.a
> > 
> > This can be pulled from:
> > 
> > git://github.com/fweisbec/tracing.git
> > 	perf/parse-events-4
> > 
> > Thanks.
> > 
> > Julia Lawall (1):
> >   perf/events: Correct size given to memset
> > 
> > Steven Rostedt (10):
> >   perf: Separate out trace-cmd parse-events from perf files
> >   tools/events: Add files to create libtraceevent.a
> >   perf: Build libtraceevent.a
> >   events: Update tools/lib/traceevent to work with perf
> >   perf: Have perf use the new libtraceevent.a library
> >   perf/events: Add flag to produce nsec output
> >   parse-events: Let pevent_free() take a NULL pointer
> >   parse-events: Allow '*' and '/' operations in TP_printk
> >   parse-event: Fix memset pointer size bug in handle
> >   parse-events: Rename struct record to struct pevent_record
> > 
> > Tom Zanussi (1):
> >   perf/events: Add flag/symbol format_flags
> > 
> > Vaibhav Nagarnaik (3):
> >   parse-events: Handle invalid opcode parsing gracefully
> >   parse-events: Handle opcode parsing error
> >   parse-events: Support '+' opcode in print format
> > 
> >  tools/lib/traceevent/Makefile                      |  303 ++
> >  tools/lib/traceevent/event-parse.c                 | 5065 ++++++++++++++++++++
> >  tools/lib/traceevent/event-parse.h                 |  804 ++++
> >  tools/lib/traceevent/event-utils.h                 |   80 +
> >  tools/lib/traceevent/parse-filter.c                | 2262 +++++++++
> >  tools/lib/traceevent/parse-utils.c                 |  110 +
> >  tools/lib/traceevent/trace-seq.c                   |  200 +
> >  tools/perf/Makefile                                |   20 +-
> >  tools/perf/builtin-kmem.c                          |    6 +-
> >  tools/perf/builtin-lock.c                          |   26 +-
> >  tools/perf/builtin-sched.c                         |   42 +-
> >  tools/perf/builtin-script.c                        |    2 +-
> >  .../util/scripting-engines/trace-event-python.c    |   16 +-
> >  tools/perf/util/trace-event-info.c                 |    4 +-
> >  tools/perf/util/trace-event-parse.c                | 3220 +------------
> >  tools/perf/util/trace-event-read.c                 |   44 +-
> >  tools/perf/util/trace-event.h                      |  269 +-
> >  tools/scripts/Makefile.include                     |    1 +
> >  18 files changed, 9161 insertions(+), 3313 deletions(-)
> >  create mode 100644 tools/lib/traceevent/Makefile
> >  create mode 100644 tools/lib/traceevent/event-parse.c
> >  create mode 100644 tools/lib/traceevent/event-parse.h
> >  create mode 100644 tools/lib/traceevent/event-utils.h
> >  create mode 100644 tools/lib/traceevent/parse-filter.c
> >  create mode 100644 tools/lib/traceevent/parse-utils.c
> >  create mode 100644 tools/lib/traceevent/trace-seq.c
> 
> Pulled, thanks a lot Frederic!
> 
> 	Ingo

Thanks a lot Ingo, this is a great step forward for our tools.

Now I guess we can start to think of backporting the remaining fixes
on the parse event code that reside in trace-cmd and then trace-cmd
can start using that library.
