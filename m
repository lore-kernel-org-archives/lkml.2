Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067Ab2JYHny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 03:43:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45540 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530Ab2JYHnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 03:43:51 -0400
Date: Thu, 25 Oct 2012 09:43:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Irina Tirdea <irina.tirdea@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/12] perf/core improvements and fixes
Message-ID: <20121025074344.GA3712@gmail.com>
References: <1351115423-9025-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351115423-9025-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling.
> 
> 	 I'll continue processing patchsets by Jiri, Namhyung, David, Irina and
> others tomorrow.
> 
> 	I also have to rework the pagefaults patches, as the code it touches
> changed lately, will add that NUMA node info you suggested.
> 
> - Arnaldo
> 
> The following changes since commit ce37f400336a34bb6e72c4700f9dcc2a41ff7163:
> 
>   x86: Allow tracing of functions in arch/x86/kernel/rtc.c (2012-10-24 13:14:22 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to af3df2cf17f5df079189c3cc88870d28e219496b:
> 
>   perf tools: Try to build Documentation when installing (2012-10-24 19:30:48 -0200)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes
> 
> . Align the 'Ok'/'FAILED!' test results in 'perf test.
> 
> . Support interrupted syscalls in 'trace'
> 
> . Add an event duration column and filter in 'trace'.
> 
> . There are references to the man pages in some tools, so try to build
>   Documentation when installing, warning the user if that is not possible,
>   from Borislav Petkov.
> 
> . Give user better message if precise is not supported, from David Ahern.
> 
> . Try to find cross-built objdump path by using the session environment
>   information in the perf.data file header, from Irina Tirdea, original
>   patch and idea by Namhyung Kim.
> 
> . Diplays more output on features check for make V=1, so that one can figure
>   out what is happening by looking at gcc output, etc. From Jiri Olsa.
> 
> . Account the nr_entries in rblist properly, fix by Suzuki K. Poulose.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (7):
>       perf tools: Remove noise in python version feature test
>       perf test: Align the 'Ok'/'FAILED!' test results
>       perf trace: Support interrupted syscalls
>       perf trace: Add an event duration column
>       perf trace: Add duration filter
>       perf tools: Pretty print errno for some more functions
>       perf trace: Print the name of a syscall when failing to read its info
> 
> Borislav Petkov (1):
>       perf tools: Try to build Documentation when installing
> 
> David Ahern (1):
>       perf tools: Give user better message if precise is not supported
> 
> Irina Tirdea (1):
>       perf tools: Try to find cross-built objdump path
> 
> Jiri Olsa (1):
>       perf tools: Diplays more output on features check for make V=1
> 
> Suzuki K. Poulose (1):
>       Account the nr_entries in rblist properly
> 
>  tools/perf/Documentation/Makefile       |   31 +++-
>  tools/perf/Documentation/perf-trace.txt |    3 +
>  tools/perf/Makefile                     |   53 ++++---
>  tools/perf/arch/common.c                |  178 ++++++++++++++++++++++
>  tools/perf/arch/common.h                |   10 ++
>  tools/perf/builtin-annotate.c           |    7 +
>  tools/perf/builtin-record.c             |    5 +
>  tools/perf/builtin-report.c             |    7 +
>  tools/perf/builtin-test.c               |   18 ++-
>  tools/perf/builtin-top.c                |    4 +
>  tools/perf/builtin-trace.c              |  250 ++++++++++++++++++++++++++++---
>  tools/perf/config/feature-tests.mak     |    5 +-
>  tools/perf/config/utilities.mak         |   11 +-
>  tools/perf/util/annotate.h              |    1 -
>  tools/perf/util/parse-events.c          |    2 +-
>  tools/perf/util/rblist.c                |    4 +-
>  tools/perf/util/util.h                  |    4 +
>  17 files changed, 535 insertions(+), 58 deletions(-)
>  create mode 100644 tools/perf/arch/common.c
>  create mode 100644 tools/perf/arch/common.h

Pulled, thanks a lot Arnado!

	Ingo
