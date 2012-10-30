Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab2J3HhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 03:37:22 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35238 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab2J3HhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 03:37:19 -0400
Date: Tue, 30 Oct 2012 08:37:13 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Feng Tang <feng.tang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/14] perf/core improvements, fixes and code move
Message-ID: <20121030073713.GD4537@gmail.com>
References: <1351523353-27982-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351523353-27982-1-git-send-email-acme@infradead.org>
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
> The following changes since commit 9db55064940db1447976945d07402a923e818962:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2012-10-26 16:52:45 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to 0da2e9c24804d787cbc919b3e0d28ee7c00240ff:
> 
>   perf python: Initialize 'page_size' variable (2012-10-29 12:36:46 -0200)
> 
> ----------------------------------------------------------------
> perf/core improvements, fixes and code move
> 
> . Initialize 'page_size' variable in the python binding, this was sent
>   for perf/urgent by mistake, then when merging Ingo removed it, fixing
>   the problem for perf/urgent, but when perf/urgent was merged with
>   perf/core, where that initialization is needed, made the python
>   binding mmap call to fail, fix it by initializing page_size again.
> 
> . Add a browser for 'perf script' and make it available from the report
>   and annotate browsers. It does filtering to find the scripts that
>   handle events found in the perf.data file used. From Feng Tang
> 
> . Move some functions from symbol.c to more appropriate files, creating
>   dso.[ch] in the process, no code changes. From Jiri Olsa
> 
> . Fix mmap error output message for when perf_mmap fails and returns
>   !-EPERM, where the default for mmap_pages, INT_MAX, was causing a
>   !power of 2 error message, fix from Jiri Olsa.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Andi Kleen (1):
>       perf tools: Move parse_events error printing to parse_events_options
> 
> Arnaldo Carvalho de Melo (1):
>       perf python: Initialize 'page_size' variable
> 
> Feng Tang (6):
>       perf tools: Add a global variable "const char *input_name"
>       perf script: Add more filter to find_scripts()
>       perf scripts browser: Add a browser for perf script
>       perf annotate browser: Integrate script browser into annotation browser
>       perf hists browser: Integrate script browser into main hists browser
>       perf header: Add is_perf_magic() func
> 
> Jiri Olsa (6):
>       perf tools: Move build_id__sprintf into build-id object
>       perf tools: Move BUILD_ID_SIZE into build-id object
>       perf tools: Move hex2u64 into util object
>       perf tools: Move strxfrchar into string object
>       perf tools: Move dso_* related functions into dso object
>       perf record: Fix mmap error output condition
> 
>  tools/perf/Makefile                |    6 +
>  tools/perf/builtin-annotate.c      |    5 +-
>  tools/perf/builtin-buildid-cache.c |    1 +
>  tools/perf/builtin-buildid-list.c  |    6 +-
>  tools/perf/builtin-evlist.c        |    5 +-
>  tools/perf/builtin-kmem.c          |    5 +-
>  tools/perf/builtin-lock.c          |    2 -
>  tools/perf/builtin-record.c        |    3 +-
>  tools/perf/builtin-report.c        |   13 +-
>  tools/perf/builtin-sched.c         |    5 +-
>  tools/perf/builtin-script.c        |   83 ++++-
>  tools/perf/builtin-timechart.c     |    5 +-
>  tools/perf/perf.c                  |    1 +
>  tools/perf/perf.h                  |    1 +
>  tools/perf/ui/browsers/annotate.c  |    6 +
>  tools/perf/ui/browsers/hists.c     |   38 +++
>  tools/perf/ui/browsers/scripts.c   |  189 +++++++++++
>  tools/perf/util/annotate.c         |    1 +
>  tools/perf/util/build-id.c         |   15 +
>  tools/perf/util/build-id.h         |    7 +-
>  tools/perf/util/dso.c              |  594 ++++++++++++++++++++++++++++++++
>  tools/perf/util/dso.h              |  148 ++++++++
>  tools/perf/util/event.h            |    3 +-
>  tools/perf/util/header.c           |   11 +
>  tools/perf/util/header.h           |    1 +
>  tools/perf/util/hist.h             |    7 +
>  tools/perf/util/map.c              |    1 +
>  tools/perf/util/parse-events.c     |   10 +-
>  tools/perf/util/python.c           |    2 +
>  tools/perf/util/string.c           |   18 +
>  tools/perf/util/symbol.c           |  657 +-----------------------------------
>  tools/perf/util/symbol.h           |  141 +-------
>  tools/perf/util/util.c             |   33 ++
>  tools/perf/util/util.h             |    2 +
>  34 files changed, 1196 insertions(+), 829 deletions(-)
>  create mode 100644 tools/perf/ui/browsers/scripts.c
>  create mode 100644 tools/perf/util/dso.c
>  create mode 100644 tools/perf/util/dso.h

Pulled, thanks a lot Arnaldo!

	Ingo
