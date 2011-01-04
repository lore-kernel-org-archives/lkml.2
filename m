Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab1ADHQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 02:16:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46813 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab1ADHQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 02:16:49 -0500
Date: Tue, 4 Jan 2011 08:16:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Han Pingtian <phan@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL||RFC 00/11] perf library and regression testing
 improvements
Message-ID: <20110104071629.GB13299@elte.hu>
References: <1294112905-25325-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294112905-25325-1-git-send-email-acme@infradead.org>
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

> Hi Ingo, Peter et al,
> 
> 	Trying to simplify using the API for tools and more specifically for
> 'perf test' regression tests, please take a look, perhaps starting from the last
> changeset, that implements a regression test using the resulting library API.
> 
> 	It also reduces the 'perf' tool footprint by not using hard coded array
> sizes, more need to be done, but should be a good start, one changeset shows a
> good reduction in BSS use.
> 
> 	Suggestions for naming most welcome, I thought about using "event__",
> but that is taken, "perf_event__", but thought it would clash with "event_t",
> so used the jargon used for the '-e' parameters: "Event Selector", but don't
> like it that much, what do you think?
> 
> 	Writing the first regression test I think there are more ways to simplify,
> on top of these, like not requiring a thread_map, i.e. passing NULL for that
> parameter would mean: self-monitor, etc.
> 
>         If you are pleased as-is, please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/test
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (11):
>   perf tools: Introduce event selectors
>   perf evsel: Adopt MATCH_EVENT macro from 'stat'
>   perf util: Move do_read from session to util
>   perf evsel: Delete the event selectors at exit
>   perf evsel: Steal the counter reading routines from stat
>   perf evsel: Introduce per cpu and per thread open helpers
>   perf tools: Refactor cpumap to hold nr and the map
>   perf tools: Refactor all_tids to hold nr and the map
>   perf evsel: Use {cpu,thread}_map to shorten list of parameters
>   perf evsel: Auto allocate resources needed for some methods
>   perf test: Add test for counting open syscalls
> 
>  tools/perf/Makefile                |    4 +
>  tools/perf/builtin-record.c        |  152 +++++++--------
>  tools/perf/builtin-stat.c          |  368 +++++++++++++++---------------------
>  tools/perf/builtin-test.c          |   83 ++++++++
>  tools/perf/builtin-top.c           |  221 ++++++++++++----------
>  tools/perf/perf.c                  |    2 +
>  tools/perf/util/cpumap.c           |  123 +++++++++---
>  tools/perf/util/cpumap.h           |   10 +-
>  tools/perf/util/evsel.c            |  186 ++++++++++++++++++
>  tools/perf/util/evsel.h            |  115 +++++++++++
>  tools/perf/util/header.c           |   15 +-
>  tools/perf/util/header.h           |    3 +-
>  tools/perf/util/parse-events.c     |   58 ++++--
>  tools/perf/util/parse-events.h     |   18 ++-
>  tools/perf/util/session.c          |   22 +--
>  tools/perf/util/session.h          |    1 -
>  tools/perf/util/thread.c           |   43 +++--
>  tools/perf/util/thread.h           |   15 ++-
>  tools/perf/util/trace-event-info.c |   30 ++--
>  tools/perf/util/trace-event.h      |    5 +-
>  tools/perf/util/util.c             |   17 ++
>  tools/perf/util/util.h             |    1 +
>  tools/perf/util/xyarray.c          |   20 ++
>  tools/perf/util/xyarray.h          |   20 ++
>  24 files changed, 1013 insertions(+), 519 deletions(-)
>  create mode 100644 tools/perf/util/evsel.c
>  create mode 100644 tools/perf/util/evsel.h
>  create mode 100644 tools/perf/util/xyarray.c
>  create mode 100644 tools/perf/util/xyarray.h

Pulled, thanks a lot Arnaldo!

	Ingo
