Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab1AZGw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 01:52:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34232 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab1AZGw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 01:52:27 -0500
Date: Wed, 26 Jan 2011 07:52:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Franck Bui-Huu <fbuihuu@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Pingtian <phan@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 00/29] perf/core improvements for 2.6.39
Message-ID: <20110126065206.GB15752@elte.hu>
References: <1295976112-2796-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295976112-2796-1-git-send-email-acme@infradead.org>
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


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
>         Please consider pulling from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> 
> 	The 'stat', 'record' and 'top' tools now share the event selector
> lifecycle routines, in the process 'top' switched to using just one mmap per
> CPU, using ioctl(PERF_EVENT_IOC_SET_OUTPUT) to set all events to just the first
> counter on a cpu, etc.
> 
> 	I'm now working on a thin python binding for these abstractions, to
> ease prototyping monitoring apps.
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (20):
>   perf evsel: Introduce perf_evlist
>   perf evlist: Adopt the pollfd array
>   perf evsel: Support event groups
>   perf evsel: Allow specifying if the inherit bit should be set
>   perf top: Use perf_evsel__open
>   perf record: Use perf_evsel__open
>   perf evsel: Introduce mmap support
>   perf record: Use struct perf_mmap and helpers
>   perf record: Move perf_mmap__write_tail to perf.h
>   perf evlist: Move the mmap array from perf_evsel
>   perf record: Use perf_evlist__mmap
>   perf tools: Add missing cpu_map__delete()
>   perf test: Check counts on all cpus in test__open_syscall_event_on_all_cpus
>   perf evlist: Steal mmap reading routine from 'perf top'
>   perf test: Add test for the evlist mmap routines
>   perf top: Add native_safe_halt to skip symbols
>   perf tools: Pass the struct opt to the wildcard parsing routine
>   perf threads: Move thread_map to separate file
>   perf tools: Move event__parse_sample to evsel.c
>   perf evsel: Introduce perf_evsel__{in,ex}it
> 
> Franck Bui-Huu (1):
>   perf record: auto detect when stdout is a pipe
> 
> Frederic Weisbecker (4):
>   perf callchain: Feed callchains into a cursor
>   perf callchain: Rename cumul_hits into callchain_cumul_hits
>   perf callchain: Rename register_callchain_param into callchain_register_param
>   perf callchain: Don't give arbitrary gender to callchain tree nodes
> 
> Han Pingtian (1):
>   perf test: check if cpu_map__new() return NULL
> 
> Masami Hiramatsu (3):
>   perf probe: Introduce lines walker interface
>   perf probe: Enable to put probe inline function call site
>   perf probe: Add --funcs to show available functions in symtab
> 
>  tools/perf/Documentation/perf-probe.txt |    4 +
>  tools/perf/Makefile                     |    4 +
>  tools/perf/builtin-probe.c              |   29 +++-
>  tools/perf/builtin-record.c             |  328 ++++++++++++-----------------
>  tools/perf/builtin-report.c             |   29 ++--
>  tools/perf/builtin-stat.c               |   39 ++--
>  tools/perf/builtin-test.c               |  184 +++++++++++++++-
>  tools/perf/builtin-top.c                |  283 ++++++++-----------------
>  tools/perf/perf.h                       |   26 +++
>  tools/perf/util/callchain.c             |  224 ++++++++++----------
>  tools/perf/util/callchain.h             |   74 ++++++-
>  tools/perf/util/cpumap.c                |    5 +
>  tools/perf/util/cpumap.h                |    2 +-
>  tools/perf/util/event.c                 |  125 -----------
>  tools/perf/util/event.h                 |    5 +-
>  tools/perf/util/evlist.c                |  170 +++++++++++++++
>  tools/perf/util/evlist.h                |   41 ++++
>  tools/perf/util/evsel.c                 |  318 ++++++++++++++++++++++++++--
>  tools/perf/util/evsel.h                 |   33 +++-
>  tools/perf/util/header.c                |   17 +-
>  tools/perf/util/header.h                |    7 +-
>  tools/perf/util/hist.c                  |   15 +-
>  tools/perf/util/hist.h                  |    2 +
>  tools/perf/util/include/linux/list.h    |    1 +
>  tools/perf/util/parse-events.c          |   71 ++-----
>  tools/perf/util/parse-events.h          |    7 -
>  tools/perf/util/probe-event.c           |   68 ++++++-
>  tools/perf/util/probe-event.h           |    1 +
>  tools/perf/util/probe-finder.c          |  361 ++++++++++++++++++-------------
>  tools/perf/util/session.c               |   26 ++-
>  tools/perf/util/session.h               |   20 ++-
>  tools/perf/util/thread.c                |   55 -----
>  tools/perf/util/thread.h                |   14 --
>  tools/perf/util/thread_map.c            |   64 ++++++
>  tools/perf/util/thread_map.h            |   15 ++
>  tools/perf/util/ui/browsers/hists.c     |    2 +-
>  36 files changed, 1647 insertions(+), 1022 deletions(-)
>  create mode 100644 tools/perf/util/evlist.c
>  create mode 100644 tools/perf/util/evlist.h
>  create mode 100644 tools/perf/util/thread_map.c
>  create mode 100644 tools/perf/util/thread_map.h

Pulled, thanks a lot Arnaldo!

	Ingo
