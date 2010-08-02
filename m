Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab0HBG0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 02:26:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44468 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab0HBG0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 02:26:49 -0400
Date: Mon, 2 Aug 2010 08:26:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Martin <dave.martin@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mike Galbraith <efault@gmx.de>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 00/19] perf/core improvements and fixes
Message-ID: <20100802062615.GA2320@elte.hu>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280711334-30000-1-git-send-email-acme@infradead.org>
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
>         Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (13):
>   perf hists: Mark entries filtered by parent
>   perf sort: Make column width code per hists instance
>   perf ui: Restore SPACE as an alias to PGDN in annotate
>   perf hist: Introduce routine to measure lenght of formatted entry
>   perf ui: Consider the refreshed dimensions in ui_browser__show
>   perf ui: Show the scroll bar over the left window frame
>   perf ui: New hists tree widget
>   perf man pages: Fix cut'n'paste error
>   perf record: Release resources at exit
>   perf symbols: Precisely specify if dso->{long,short}_name should be freed
>   perf tui: Make CTRL+Z suspend perf
>   perf tools: Release thread resources on PERF_RECORD_EXIT
>   perf tools: Release session and symbol resources on exit
> 
> Dave Martin (5):
>   perf report: Don't abbreviate file paths relative to the cwd
>   perf tools: Remove unneeded code for tracking the cwd in perf sessions
>   perf tools: Factor out buildid reading and make it implicit in dso__load
>   perf tools: remove extra build-id check factored into dso__load
>   perf symbols: Improve debug image search when loading symbols
> 
> Srikar Dronamraju (1):
>   perf probe: Rename common fields/functions from kprobe to probe.
> 
>  tools/perf/Documentation/perf-buildid-cache.txt |    8 +-
>  tools/perf/builtin-buildid-list.c               |    4 +-
>  tools/perf/builtin-diff.c                       |    2 -
>  tools/perf/builtin-probe.c                      |    1 -
>  tools/perf/builtin-record.c                     |   37 +-
>  tools/perf/builtin-report.c                     |    2 -
>  tools/perf/util/build-id.c                      |   18 +
>  tools/perf/util/event.c                         |   42 +-
>  tools/perf/util/hist.c                          |  160 +++-
>  tools/perf/util/hist.h                          |   30 +-
>  tools/perf/util/map.c                           |   81 ++-
>  tools/perf/util/map.h                           |    4 +-
>  tools/perf/util/newt.c                          |  991 ++++++++++++++++-------
>  tools/perf/util/probe-event.c                   |  135 ++--
>  tools/perf/util/probe-event.h                   |   27 +-
>  tools/perf/util/probe-finder.c                  |   34 +-
>  tools/perf/util/probe-finder.h                  |   10 +-
>  tools/perf/util/session.c                       |   48 +-
>  tools/perf/util/sort.c                          |   17 +-
>  tools/perf/util/sort.h                          |   18 +-
>  tools/perf/util/symbol.c                        |  219 +++---
>  tools/perf/util/symbol.h                        |   10 +-
>  tools/perf/util/thread.c                        |    7 +
>  tools/perf/util/thread.h                        |    2 +
>  24 files changed, 1253 insertions(+), 654 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
