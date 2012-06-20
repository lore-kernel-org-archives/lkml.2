Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab2FTMBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:01:49 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61730 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2FTMBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:01:47 -0400
Date: Wed, 20 Jun 2012 14:01:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Arun Sharma <asharma@fb.com>,
        Benjamin Redelings <benjamin.redelings@nescent.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, David Ahern <dsahern@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Shan Wei <davidshan@tencent.com>,
        Stephane Eranian <eranian@google.com>, Sunjin Yang <fan4326@gmail.com>,
        Tom Zanussi <tzanussi@gmail.com>, Ulrich Drepper <drepper@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/20] perf/core improvements
Message-ID: <20120620120141.GB1925@gmail.com>
References: <1340128221-17348-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340128221-17348-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit e227051b13956b8f71c0abecc41ad351e64671c8:
> 
>   uprobes: Remove the unnecessary initialization in add_utask() (2012-06-16 09:10:52 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to c0a58fb2bdf033df433cad9009c7dac4c6b872b0:
> 
>   perf annotate: Check null of sym pointer before using it (2012-06-19 14:30:26 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes
> 
> . Replace event_name with perf_evsel__name, that handles the event modifiers
>   and doesn't use static variables.
> 
> . GTK browser improvements, from Namhyung Kim
> 
> . Fix possible NULL pointer deref in the TUI annotate browser, from Samuel Liao
> 
> . Add sort by source file:line number, using addr2line.
> 
> . Allow printing histogram text snapshots at any point in top/report.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (13):
>       perf tools: Add sort by src line/number
>       perf lib: Introduce rtrim
>       perf hists browser: Implement printing snapshots to files
>       perf evsel: Carve out event modifier formatting
>       perf tools: Reconstruct hw cache event with modifiers from perf_event_attr
>       perf tools: Reconstruct sw event with modifiers from perf_event_attr
>       perf evsel: Handle all event types in perf_evsel__name
>       perf tools: Move all users of event_name to perf_evsel__name
>       perf script: Replace __event_name uses with perf_evsel__name
>       perf tools: Don't access evsel->name directly
>       perf tools: Remove __event_name
>       perf evsel: Reconstruct raw event with modifiers from perf_event_attr
>       perf evsel: Make some methods private
> 
> Jiri Olsa (1):
>       perf tools: Remove unused evsel parameter from machine__resolve_callchain
> 
> Namhyung Kim (5):
>       perf ui: Introduce struct perf_error_ops
>       perf ui/gtk: Introduce struct perf_gtk_context
>       perf ui/gtk: Add GTK statusbar widget to browser window
>       perf ui/gtk: Add GTK info_bar widget to browser window
>       perf ui/gtk: Use struct perf_error_ops
> 
> Samuel Liao (1):
>       perf annotate: Check null of sym pointer before using it
> 
>  tools/perf/Documentation/perf-report.txt |    2 +-
>  tools/perf/Documentation/perf-top.txt    |    2 +-
>  tools/perf/Makefile                      |    6 +
>  tools/perf/builtin-evlist.c              |    2 +-
>  tools/perf/builtin-record.c              |    4 +-
>  tools/perf/builtin-report.c              |   10 +-
>  tools/perf/builtin-sched.c               |    2 +-
>  tools/perf/builtin-script.c              |   42 ++---
>  tools/perf/builtin-stat.c                |   12 +-
>  tools/perf/builtin-test.c                |    2 +-
>  tools/perf/builtin-top.c                 |   12 +-
>  tools/perf/config/feature-tests.mak      |   13 ++
>  tools/perf/ui/browsers/annotate.c        |    4 +-
>  tools/perf/ui/browsers/hists.c           |  210 ++++++++++++++++++++--
>  tools/perf/ui/gtk/browser.c              |   69 +++++++-
>  tools/perf/ui/gtk/gtk.h                  |   31 ++++
>  tools/perf/ui/gtk/setup.c                |    5 +
>  tools/perf/ui/gtk/util.c                 |  129 ++++++++++++++
>  tools/perf/ui/tui/setup.c                |    6 +
>  tools/perf/ui/tui/util.c                 |  243 ++++++++++++++++++++++++++
>  tools/perf/ui/util.c                     |  277 ++++++------------------------
>  tools/perf/ui/util.h                     |    9 +-
>  tools/perf/util/debug.c                  |    2 +-
>  tools/perf/util/debug.h                  |   23 ++-
>  tools/perf/util/evsel.c                  |  196 ++++++++++++++++++---
>  tools/perf/util/evsel.h                  |   15 +-
>  tools/perf/util/header.c                 |    2 +-
>  tools/perf/util/hist.h                   |    1 +
>  tools/perf/util/map.h                    |    2 +-
>  tools/perf/util/parse-events-test.c      |    4 +-
>  tools/perf/util/parse-events.c           |  203 ++--------------------
>  tools/perf/util/parse-events.h           |    2 -
>  tools/perf/util/session.c                |    9 +-
>  tools/perf/util/session.h                |    4 +-
>  tools/perf/util/sort.c                   |   49 ++++++
>  tools/perf/util/sort.h                   |    2 +
>  tools/perf/util/string.c                 |   22 +++
>  tools/perf/util/top.c                    |    2 +-
>  tools/perf/util/util.h                   |    2 +
>  39 files changed, 1118 insertions(+), 514 deletions(-)
>  create mode 100644 tools/perf/ui/gtk/util.c
>  create mode 100644 tools/perf/ui/tui/util.c

Pulled, thanks Arnaldo!

One Makefile bug I noticed is that lib/tracevents does not clean 
out these files:

 .event-parse.d
 .parse-filter.d
 .parse-utils.d
 .trace-seq.d

and this can break the build when the libgcc package upgraded:

 comet:~/tip/tools/perf> make -j
     SUBDIR ../lib/traceevent/
 make[1]: *** No rule to make target `/usr/lib/gcc/x86_64-redhat-linux/4.7.0/include/stddef.h', 
  needed by `event-parse.o'.  Stop.
 make: *** [../lib/traceevent//libtraceevent.a] Error 2

Thanks,

	Ingo
