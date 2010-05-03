Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab0ECGYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 02:24:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56034 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab0ECGYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 02:24:41 -0400
Date: Mon, 3 May 2010 08:24:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 0/5] perf inject + say no to __KERNEL__ only stuff
Message-ID: <20100503062407.GB15241@elte.hu>
References: <1272841142-26029-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272841142-26029-1-git-send-email-acme@infradead.org>
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

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Hi Ingo,
> 
> 	Please consider pulling from:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (3):
>   perf tools: Don't use code surrounded by __KERNEL__
>   perf record: Don't exit in live mode when no tracepoints are enabled
>   perf inject: Refactor read_buildid function
> 
> Tom Zanussi (2):
>   perf/live: don't synthesize build ids at the end of a live mode trace
>   perf: add perf-inject builtin
> 
>  tools/perf/Makefile                    |   17 +--
>  tools/perf/builtin-annotate.c          |    2 +-
>  tools/perf/builtin-buildid-list.c      |    2 +-
>  tools/perf/builtin-diff.c              |    4 +-
>  tools/perf/builtin-inject.c            |  228 ++++++++++++++++++++++++++++++++
>  tools/perf/builtin-kmem.c              |    2 +-
>  tools/perf/builtin-lock.c              |    2 +-
>  tools/perf/builtin-record.c            |   24 ++--
>  tools/perf/builtin-report.c            |    2 +-
>  tools/perf/builtin-sched.c             |    2 +-
>  tools/perf/builtin-timechart.c         |    2 +-
>  tools/perf/builtin-top.c               |    2 +-
>  tools/perf/builtin-trace.c             |    2 +-
>  tools/perf/builtin.h                   |    1 +
>  tools/perf/perf.c                      |    1 +
>  tools/perf/util/bitmap.c               |   21 +++
>  tools/perf/util/header.c               |   96 ++++----------
>  tools/perf/util/header.h               |    2 -
>  tools/perf/util/hweight.c              |   31 +++++
>  tools/perf/util/include/asm/bitops.h   |   18 ---
>  tools/perf/util/include/asm/hweight.h  |    8 +
>  tools/perf/util/include/linux/bitmap.h |   38 +++++-
>  tools/perf/util/include/linux/bitops.h |   20 ++--
>  tools/perf/util/session.c              |    3 +-
>  tools/perf/util/session.h              |    3 +-
>  tools/perf/util/trace-event-read.c     |   19 +++-
>  tools/perf/util/trace-event.h          |    2 +-
>  27 files changed, 407 insertions(+), 147 deletions(-)
>  create mode 100644 tools/perf/builtin-inject.c
>  create mode 100644 tools/perf/util/bitmap.c
>  create mode 100644 tools/perf/util/hweight.c
>  delete mode 100644 tools/perf/util/include/asm/bitops.h
>  create mode 100644 tools/perf/util/include/asm/hweight.h

Pulled, thanks a lot!

	Ingo
