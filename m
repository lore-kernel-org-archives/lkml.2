Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab2JINfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:35:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60055 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab2JINfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:35:10 -0400
Date: Tue, 9 Oct 2012 15:34:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Bernhard Rosenkraenzer <Bernhard.Rosenkranzer@linaro.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Dong Hao <haodong@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Irina Tirdea <irina.tirdea@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 00/25] perf/core improvements and fixes
Message-ID: <20121009133459.GA9523@gmail.com>
References: <1349735570-19339-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349735570-19339-1-git-send-email-acme@infradead.org>
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
> The following changes since commit 139c0815903de1a7865fe1d6beac5e995fefdf46:
> 
>   perf hists: Add more helpers for hist entry stat (2012-10-04 13:36:18 -0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to 7747e2f4fb5fb840994613dd1474c17cddb7836b:
> 
>   Documentation: add documentation on compiling for Android (2012-10-08 17:44:39 -0300)
> 
> ----------------------------------------------------------------
> 
> perf/core improvements and fixes
> 
> . Handle PERF_RECORD_EXIT events in sched and annotate.
> 
> . struct machine refactorings to help in top and trace.
> 
> . Add on_exit implementation for systems without one, e.g. Android, from
>   Bernhard Rosenkraenzer.
> 
> . Only process events for vcpus of interest, helps handling large number
>   of events, from David Ahern.
> 
> . Cross compiling fixes for Android, from Irina Tirdea.
> 
> . Add documentation on compiling for Android, from Irina Tirdea.
> 
> . perf diff improvements from Jiri Olsa.
> 
> . Target (task/user/cpu/syswide) handling improvements, from Namhyung Kim.
> 
> . Add support in 'trace' for tracing workload given by command line, from
>   Namhyung Kim.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> 
> Arnaldo Carvalho de Melo (6):
>       perf tools: Have the page size value available for all tools
>       perf machine: Introduce find_thread method
>       perf event: No need to create a thread when handling PERF_RECORD_EXIT
>       perf annotate: Handle PERF_RECORD_EXIT events
>       perf sched: Handle PERF_RECORD_EXIT events
>       perf machine: Carve up event processing specific from perf_tool
> 
> Bernhard Rosenkraenzer (1):
>       perf tools: Add on_exit implementation
> 
> David Ahern (4):
>       perf kvm: Only process events for vcpus of interest
>       perf kvm: Remove typecast in init_kvm_event_record
>       perf kvm: Total count is a u64, print as so
>       perf kvm: Add braces around multi-line statements
> 
> Irina Tirdea (2):
>       perf tools: Update Makefile for Android
>       Documentation: add documentation on compiling for Android
> 
> Jiri Olsa (8):
>       perf diff: Add -b option for perf diff to display paired entries only
>       perf diff: Add ratio computation way to compare hist entries
>       perf diff: Add option to sort entries based on diff computation
>       perf diff: Add weighted diff computation way to compare hist entries
>       perf diff: Add -p option to display period values for hist entries
>       perf diff: Add -F option to display formula for computation
>       perf diff: Include samples without symbol in overall stats
>       perf diff: Display empty space for non paired samples
> 
> Namhyung Kim (3):
>       perf trace: Validate target task/user/cpu argument
>       perf trace: Explicitly enable system-wide mode if no option is given
>       perf trace: Add support for tracing workload given by command line
> 
> Wei Yongjun (1):
>       perf tools: Remove duplicated include from trace-event-python.c
> 
>  tools/perf/Documentation/android.txt               |   75 ++++
>  tools/perf/Documentation/perf-diff.txt             |   60 +++
>  tools/perf/Makefile                                |   33 +-
>  tools/perf/builtin-annotate.c                      |    3 +-
>  tools/perf/builtin-diff.c                          |  405 +++++++++++++++++++-
>  tools/perf/builtin-inject.c                        |    6 +-
>  tools/perf/builtin-kvm.c                           |   35 +-
>  tools/perf/builtin-record.c                        |   32 ++
>  tools/perf/builtin-report.c                        |    4 +-
>  tools/perf/builtin-sched.c                         |    3 +-
>  tools/perf/builtin-script.c                        |    4 +-
>  tools/perf/builtin-test.c                          |    2 -
>  tools/perf/builtin-top.c                           |    3 +-
>  tools/perf/builtin-trace.c                         |   53 ++-
>  tools/perf/config/feature-tests.mak                |   20 +-
>  tools/perf/perf.c                                  |    2 +
>  tools/perf/ui/hist.c                               |  134 ++++++-
>  tools/perf/ui/stdio/hist.c                         |    2 +-
>  tools/perf/util/build-id.c                         |    2 +-
>  tools/perf/util/event.c                            |  215 +----------
>  tools/perf/util/event.h                            |    6 +-
>  tools/perf/util/evlist.c                           |    3 -
>  tools/perf/util/hist.h                             |    8 +
>  tools/perf/util/machine.c                          |  277 +++++++++++++
>  tools/perf/util/machine.h                          |   19 +
>  .../util/scripting-engines/trace-event-python.c    |    1 -
>  tools/perf/util/session.c                          |    4 +-
>  tools/perf/util/sort.h                             |   18 +
>  tools/perf/util/thread.c                           |   41 +-
>  tools/perf/util/thread.h                           |    2 +
>  tools/perf/util/trace-event-read.c                 |    2 -
>  tools/perf/util/util.c                             |    2 +
>  tools/perf/util/util.h                             |    2 +
>  33 files changed, 1173 insertions(+), 305 deletions(-)
>  create mode 100644 tools/perf/Documentation/android.txt
>  create mode 100644 tools/perf/util/machine.c
>  create mode 100644 tools/perf/util/machine.h

Pulled, thanks Arnaldo!

	Ingo
