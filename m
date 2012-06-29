Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab2F2NNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 09:13:00 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58325 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab2F2NM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 09:12:58 -0400
Date: Fri, 29 Jun 2012 15:12:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Dmitry Antipov <dmitry.antipov@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Jiri Olsa <jolsa@redhat.com>, linaro-dev@lists.linaro.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Sartain <mikesart@valvesoftware.com>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        patches@linaro.org, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Pierre-Loup A. Griffais" <pgriffais@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Chen <tim.c.chen@linux.intel.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/7] perf/core improvements and fixes
Message-ID: <20120629131253.GA395@gmail.com>
References: <1340824854-3005-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340824854-3005-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling.
> 
> 	Tested on RHEL6.2, Fedora 17 x86 and x86_64,
> 
> - Arnaldo
> 
> The following changes since commit 357398e96d8c883b010379a7669df43ed0e2e32b:
> 
>   perf/x86: Fix section mismatch in uncore_pci_init() (2012-06-25 10:32:21 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to d9873ab79376d5c0112ed09e14783067dc65e808:
> 
>   perf tools: Trivial build fix (2012-06-27 13:32:06 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> . Improve 'perf bench' docs, by Namhyung Kim
> 
> . Fix build when O= is not used, from David Ahern
> 
> . Fix cross compilation build, from Namhyung Kim
> 
> . Fix pipe mode when callchains are used, from David Ahern
> 
> . Follow .gnu_debuglink section to find separate symbols, from Pierre-Loup A. Griffais
> 
> . Fix 'perf test' raw events entries, from Jiri Olsa
> 
> . Use the events description in the perf.data file, not the sysfs ones.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (1):
>       perf tools: Stop using a global trace events description list
> 
> David Ahern (2):
>       perf report: Delay sample_type checks in pipe mode
>       perf tools: Trivial build fix
> 
> Jiri Olsa (1):
>       perf test: Fix parse events test to follow proper raw event name
> 
> Namhyung Kim (2):
>       perf evsel: Fix a build failure on cross compilation
>       perf bench: Documentation update
> 
> Pierre-Loup A. Griffais (1):
>       perf symbols: Follow .gnu_debuglink section to find separate symbols
> 
>  tools/perf/Documentation/perf-bench.txt            |   78 +++++++++++++++-
>  tools/perf/Makefile                                |    2 +-
>  tools/perf/bench/mem-memcpy.c                      |    4 +-
>  tools/perf/bench/mem-memset.c                      |    8 +-
>  tools/perf/builtin-bench.c                         |    4 +-
>  tools/perf/builtin-kmem.c                          |   37 +++++---
>  tools/perf/builtin-lock.c                          |    4 +-
>  tools/perf/builtin-report.c                        |    6 +-
>  tools/perf/builtin-sched.c                         |   36 +++++---
>  tools/perf/builtin-script.c                        |   66 ++++++++-----
>  tools/perf/util/evlist.c                           |    4 +-
>  tools/perf/util/evlist.h                           |    3 +
>  tools/perf/util/evsel.c                            |    1 -
>  tools/perf/util/header.c                           |   31 ++++---
>  tools/perf/util/parse-events-test.c                |    7 +-
>  .../perf/util/scripting-engines/trace-event-perl.c |   28 +++---
>  .../util/scripting-engines/trace-event-python.c    |   21 +++--
>  tools/perf/util/session.c                          |   56 +++++++++++
>  tools/perf/util/session.h                          |   10 ++
>  tools/perf/util/symbol.c                           |   65 ++++++++++++-
>  tools/perf/util/symbol.h                           |    1 +
>  tools/perf/util/trace-event-parse.c                |   58 ++++++------
>  tools/perf/util/trace-event-read.c                 |   97 ++++++++++----------
>  tools/perf/util/trace-event-scripting.c            |    7 +-
>  tools/perf/util/trace-event.h                      |   38 ++++----
>  25 files changed, 471 insertions(+), 201 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
