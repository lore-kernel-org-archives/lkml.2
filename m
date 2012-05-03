Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab2ECOj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:39:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56882 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab2ECOj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:39:56 -0400
Subject: Re: [PATCH 08/13] perf target: Split out perf_target handling code
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
In-Reply-To: <20120502183026.GC5745@infradead.org>
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
	 <1335417327-11796-9-git-send-email-namhyung.kim@lge.com>
	 <20120502183026.GC5745@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 May 2012 23:39:47 +0900
Message-ID: <1336055987.1493.17.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-05-02 (수), 15:30 -0300, Arnaldo Carvalho de Melo:
> Em Thu, Apr 26, 2012 at 02:15:22PM +0900, Namhyung Kim escreveu:
> > For further work on perf_target, it'd be better off splitting
> > the code into a separate file.
> > 
> > Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> > ---
> >  tools/perf/Makefile      |    2 ++
> >  tools/perf/perf.h        |    9 +--------
> >  tools/perf/util/evlist.c |    1 +
> >  tools/perf/util/evsel.c  |    1 +
> >  tools/perf/util/target.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
> >  tools/perf/util/target.h |   17 +++++++++++++++++
> >  tools/perf/util/usage.c  |   34 ----------------------------------
> >  tools/perf/util/util.h   |    2 --
> >  8 files changed, 67 insertions(+), 44 deletions(-)
> >  create mode 100644 tools/perf/util/target.c
> >  create mode 100644 tools/perf/util/target.h
> 
> Trying to fix this now...
> 

Oops, sorry. I'll investigate it tomorrow.

Thanks,
Namhyung


> [acme@sandy linux]$ make -C tools/perf/ O=/home/git/build/perf install
> make: Entering directory `/home/git/linux/tools/perf'
>     CC /home/git/build/perf/builtin-bench.o
>     CC /home/git/build/perf/bench/sched-messaging.o
>     CC /home/git/build/perf/bench/sched-pipe.o
>     CC /home/git/build/perf/scripts/perl/Perf-Trace-Util/Context.o
> In file included from
> scripts/perl/Perf-Trace-Util/../../../util/target.h:4,
>                  from scripts/perl/Perf-Trace-Util/../../../perf.h:210,
>                  from Context.xs:25:
> scripts/perl/Perf-Trace-Util/../../../util/util.h:44:1: error:
> "HAS_BOOL" redefined
> In file included from /usr/lib64/perl5/CORE/perl.h:2424,
>                  from Context.xs:23:
> /usr/lib64/perl5/CORE/handy.h:110:1: error: this is the location of the
> previous definition
> In file included from
> scripts/perl/Perf-Trace-Util/../../../util/target.h:4,
>                  from scripts/perl/Perf-Trace-Util/../../../perf.h:210,
>                  from Context.xs:25:
> scripts/perl/Perf-Trace-Util/../../../util/util.h:133: error:
> conflicting types for ‘Perl_die_nocontext’
> /usr/lib64/perl5/CORE/proto.h:331: note: previous declaration of
> ‘Perl_die_nocontext’ was here
> make: *** [/home/git/build/perf/scripts/perl/Perf-Trace-Util/Context.o]
> Error 1
> make: Leaving directory `/home/git/linux/tools/perf'
> [acme@sandy linux]$


-- 
Regards,
Namhyung Kim


