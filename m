Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965135Ab2EWPG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:06:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56272 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965054Ab2EWPG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:06:56 -0400
Date: Wed, 23 May 2012 17:06:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
        arnaldo.melo@gmail.com, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/19] perf/core improvements and fixes
Message-ID: <20120523150648.GC26974@gmail.com>
References: <1337708407-24522-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337708407-24522-1-git-send-email-acme@infradead.org>
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
> The following changes since commit 73787190d04a34e6da745da893b3ae8bedde418f:
> 
>   Merge branch 'perf/parse-events-4' of git://github.com/fweisbec/tracing into perf/core (2012-05-21 10:42:09 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core
> 
> for you to fetch changes up to 26252ea675663d1bc6747125fcaa2b7cc4ed8a03:
> 
>   perf evlist: Show event attribute details (2012-05-22 14:30:11 -0300)
> 
> ----------------------------------------------------------------
> Fixes and improvements for perf/core:
> 
> . Fix perf perl script build fallout from libtraceevent conversion,
>   from Frederic Weisbecker.
> 
> . Libtraceevent Makefile fixes, from Namhyung Kim
> 
> . Pipe mode fixes, from Stephane Eranian
> 
> . Event parsing improvements, from Jiri Olsa.
> 
> . Endianness fixes, from Jiri Olsa
> 
> . Bump the default sampling freq to 4 kHz, requested by Ingo Molnar.
> 
> . Show event attribute details, such as the sampling freq, in the
>   'perf evlist' command.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Anshuman Khandual (1):
>       perf record: Fix documentation for branch stack sampling
> 
> Arnaldo Carvalho de Melo (2):
>       perf tools: Bump default sample freq to 4 kHz
>       perf evlist: Show event attribute details
> 
> Frederic Weisbecker (2):
>       perf script: Explicitly handle known default print arg type
>       perf script: Rename struct event to struct event_format in perl engine
> 
> Jiri Olsa (7):
>       perf test: Move parse event automated tests to separated object
>       perf tools: Add support for displaying event parser debug info
>       perf tools: Use allocated list for each parsed event
>       perf tools: Separate 'mem:' event scanner bits
>       perf tools: Add hardcoded name term for pmu events
>       perf tools: Carry perf_event_attr bitfield throught different endians
>       perf tools: Add union u64_swap type for swapping u64 data
> 
> Namhyung Kim (3):
>       perf tools: Rename libparsevent to libtraceevent in Makefile
>       perf tools: Always try to build libtraceevent
>       perf target: Add cpu flag to sample_type if target has cpu
> 
> Stephane Eranian (4):
>       perf tools: rename HEADER_TRACE_INFO to HEADER_TRACING_DATA
>       perf inject: Fix broken perf inject -b
>       perf tools: Fix piped mode read code
>       perf buildid-list: Work better with pipe mode
> 
>  tools/perf/Documentation/perf-evlist.txt           |    8 +
>  tools/perf/Documentation/perf-record.txt           |    2 +-
>  tools/perf/Makefile                                |   37 +-
>  tools/perf/builtin-buildid-list.c                  |    6 +-
>  tools/perf/builtin-evlist.c                        |  103 +++-
>  tools/perf/builtin-inject.c                        |    5 +
>  tools/perf/builtin-record.c                        |    6 +-
>  tools/perf/builtin-test.c                          |  552 +----------------
>  tools/perf/builtin-top.c                           |    5 +-
>  tools/perf/util/build-id.c                         |    2 +
>  tools/perf/util/evsel.c                            |   12 +-
>  tools/perf/util/header.c                           |   10 +-
>  tools/perf/util/header.h                           |    2 +-
>  tools/perf/util/parse-events-test.c                |  625 ++++++++++++++++++++
>  tools/perf/util/parse-events.c                     |   69 ++-
>  tools/perf/util/parse-events.h                     |   20 +-
>  tools/perf/util/parse-events.l                     |   26 +-
>  tools/perf/util/parse-events.y                     |   77 ++-
>  tools/perf/util/pmu.c                              |    4 +-
>  .../perf/util/scripting-engines/trace-event-perl.c |   16 +-
>  tools/perf/util/session.c                          |   68 ++-
>  tools/perf/util/types.h                            |    5 +
>  22 files changed, 1002 insertions(+), 658 deletions(-)
>  create mode 100644 tools/perf/util/parse-events-test.c

Pulled, thanks a lot Arnaldo!

	Ingo
