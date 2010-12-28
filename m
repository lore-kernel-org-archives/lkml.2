Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab0L1DYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 22:24:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39814 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab0L1DYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 22:24:47 -0500
Date: Tue, 28 Dec 2010 04:24:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Franck Bui-Huu <fbuihuu@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Torok Edwin <edwintorok@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/4] perf/core fixes
Message-ID: <20101228032426.GC24500@elte.hu>
References: <1293487213-533-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293487213-533-1-git-send-email-acme@infradead.org>
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
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (3):
>   perf script: Finish the rename from trace to script
>   perf record: Fix use of sample_id_all userspace with !sample_id_all kernels
>   perf script: Fix event ordering settings to work with older kernels
> 
> Franck Bui-Huu (1):
>   perf probe: Fix short file name probe location reporting
> 
>  tools/perf/builtin-record.c                        |   24 +++++++++++++++----
>  tools/perf/builtin-script.c                        |    1 +
>  tools/perf/scripts/perl/Perf-Trace-Util/Context.c  |    2 +-
>  tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |    4 +-
>  tools/perf/scripts/perl/Perf-Trace-Util/README     |    4 +-
>  .../perl/Perf-Trace-Util/lib/Perf/Trace/Context.pm |    2 +-
>  .../perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm    |    4 +-
>  .../perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm    |    4 +-
>  tools/perf/scripts/perl/bin/failed-syscalls-report |    2 +-
>  tools/perf/scripts/perl/bin/rw-by-file-report      |    5 +---
>  tools/perf/scripts/perl/bin/rw-by-pid-report       |    5 +---
>  tools/perf/scripts/perl/bin/rwtop-report           |    5 +---
>  tools/perf/scripts/perl/bin/wakeup-latency-report  |    5 +---
>  tools/perf/scripts/perl/bin/workqueue-stats-report |    6 +----
>  tools/perf/scripts/perl/check-perf-trace.pl        |    2 +-
>  tools/perf/scripts/perl/rw-by-file.pl              |    2 +-
>  tools/perf/scripts/perl/workqueue-stats.pl         |    2 +-
>  .../python/Perf-Trace-Util/lib/Perf/Trace/Core.py  |    2 +-
>  .../Perf-Trace-Util/lib/Perf/Trace/SchedGui.py     |    2 +-
>  .../python/Perf-Trace-Util/lib/Perf/Trace/Util.py  |    2 +-
>  .../python/bin/failed-syscalls-by-pid-report       |    2 +-
>  .../scripts/python/bin/futex-contention-report     |    2 +-
>  tools/perf/scripts/python/bin/netdev-times-report  |    2 +-
>  .../perf/scripts/python/bin/sched-migration-report |    2 +-
>  tools/perf/scripts/python/bin/sctop-report         |    2 +-
>  .../python/bin/syscall-counts-by-pid-report        |    2 +-
>  .../perf/scripts/python/bin/syscall-counts-report  |    2 +-
>  tools/perf/scripts/python/check-perf-trace.py      |    2 +-
>  .../perf/scripts/python/failed-syscalls-by-pid.py  |    2 +-
>  tools/perf/scripts/python/sched-migration.py       |    2 +-
>  tools/perf/scripts/python/sctop.py                 |    2 +-
>  tools/perf/scripts/python/syscall-counts-by-pid.py |    2 +-
>  tools/perf/scripts/python/syscall-counts.py        |    2 +-
>  tools/perf/util/probe-event.c                      |   14 +++++-----
>  34 files changed, 62 insertions(+), 63 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
