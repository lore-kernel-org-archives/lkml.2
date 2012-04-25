Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab2DYM1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:27:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41891 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab2DYM1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:27:48 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Julia Lawall <julia@diku.dk>, Tom Zanussi <tzanussi@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 00/15] tools: Unify perf and trace-cmd trace event format parsing v3
Date: Wed, 25 Apr 2012 14:26:44 +0200
Message-Id: <1335356819-16710-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is essentially a rebase against latest tip:perf/core updates.
Mostly due to conflicts against the perf Makefile updates.

I think we all agree that this library needs improvements but these
should rather be done incrementally. The current perf trace event parsing
is anyway much backward compared to that library.

Default target is a static library in tools/libtraceevent/libtraceevent.a

This can be pulled from:

git://github.com/fweisbec/tracing.git
	perf/parse-events-4

Thanks.

Julia Lawall (1):
  perf/events: Correct size given to memset

Steven Rostedt (10):
  perf: Separate out trace-cmd parse-events from perf files
  tools/events: Add files to create libtraceevent.a
  perf: Build libtraceevent.a
  events: Update tools/lib/traceevent to work with perf
  perf: Have perf use the new libtraceevent.a library
  perf/events: Add flag to produce nsec output
  parse-events: Let pevent_free() take a NULL pointer
  parse-events: Allow '*' and '/' operations in TP_printk
  parse-event: Fix memset pointer size bug in handle
  parse-events: Rename struct record to struct pevent_record

Tom Zanussi (1):
  perf/events: Add flag/symbol format_flags

Vaibhav Nagarnaik (3):
  parse-events: Handle invalid opcode parsing gracefully
  parse-events: Handle opcode parsing error
  parse-events: Support '+' opcode in print format

 tools/lib/traceevent/Makefile                      |  303 ++
 tools/lib/traceevent/event-parse.c                 | 5065 ++++++++++++++++++++
 tools/lib/traceevent/event-parse.h                 |  804 ++++
 tools/lib/traceevent/event-utils.h                 |   80 +
 tools/lib/traceevent/parse-filter.c                | 2262 +++++++++
 tools/lib/traceevent/parse-utils.c                 |  110 +
 tools/lib/traceevent/trace-seq.c                   |  200 +
 tools/perf/Makefile                                |   20 +-
 tools/perf/builtin-kmem.c                          |    6 +-
 tools/perf/builtin-lock.c                          |   26 +-
 tools/perf/builtin-sched.c                         |   42 +-
 tools/perf/builtin-script.c                        |    2 +-
 .../util/scripting-engines/trace-event-python.c    |   16 +-
 tools/perf/util/trace-event-info.c                 |    4 +-
 tools/perf/util/trace-event-parse.c                | 3220 +------------
 tools/perf/util/trace-event-read.c                 |   44 +-
 tools/perf/util/trace-event.h                      |  269 +-
 tools/scripts/Makefile.include                     |    1 +
 18 files changed, 9161 insertions(+), 3313 deletions(-)
 create mode 100644 tools/lib/traceevent/Makefile
 create mode 100644 tools/lib/traceevent/event-parse.c
 create mode 100644 tools/lib/traceevent/event-parse.h
 create mode 100644 tools/lib/traceevent/event-utils.h
 create mode 100644 tools/lib/traceevent/parse-filter.c
 create mode 100644 tools/lib/traceevent/parse-utils.c
 create mode 100644 tools/lib/traceevent/trace-seq.c

-- 
1.7.5.4

