Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab1COUFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:05:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:39010 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930Ab1COUFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:05:25 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 00/12] perf/core improvements, fixes and cleanups
Date: Tue, 15 Mar 2011 17:04:49 -0300
Message-Id: <1300219501-15085-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (5):
  perf top: Remove redundant perf_top->sym_counter
  perf top: Remove redundant syme->origin field
  perf symbols: Rename dso->origin to dso->symtab_type
  perf symbol: Move sym_entry->skip to symbol->ignore
  perf evlist: New command to list the names of events present in a perf.data file

David Ahern (6):
  perf script: Change process_event prototype
  perf tracing: Remove print_graph_cpu and print_graph_proc from trace-event-parse
  perf script: Move printing of 'common' data from print_event and rename
  perf script: Support custom field selection for output
  perf script: Add support for dumping symbols
  perf script: Add support for H/W and S/W events

Frederic Weisbecker (1):
  perf stat: Provide support for filters

 tools/perf/Documentation/perf-evlist.txt           |   26 ++
 tools/perf/Documentation/perf-script.txt           |   22 ++
 tools/perf/Makefile                                |    1 +
 tools/perf/builtin-evlist.c                        |   54 ++++
 tools/perf/builtin-script.c                        |  300 ++++++++++++++++++--
 tools/perf/builtin-stat.c                          |    8 +
 tools/perf/builtin-top.c                           |   20 +-
 tools/perf/builtin.h                               |    1 +
 tools/perf/command-list.txt                        |    1 +
 tools/perf/perf.c                                  |    1 +
 tools/perf/util/annotate.c                         |    2 +-
 tools/perf/util/parse-events.c                     |   22 ++
 tools/perf/util/parse-events.h                     |    1 +
 .../perf/util/scripting-engines/trace-event-perl.c |   11 +-
 .../util/scripting-engines/trace-event-python.c    |   11 +-
 tools/perf/util/session.c                          |   61 ++++
 tools/perf/util/session.h                          |    4 +
 tools/perf/util/symbol.c                           |   64 ++--
 tools/perf/util/symbol.h                           |   31 ++-
 tools/perf/util/top.c                              |    6 +-
 tools/perf/util/top.h                              |    4 +-
 tools/perf/util/trace-event-parse.c                |  110 +-------
 tools/perf/util/trace-event-scripting.c            |    9 +-
 tools/perf/util/trace-event.h                      |   10 +-
 24 files changed, 580 insertions(+), 200 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-evlist.txt
 create mode 100644 tools/perf/builtin-evlist.c

