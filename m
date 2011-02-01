Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab1BAJPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 04:15:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54105 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab1BAJPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 04:15:05 -0500
Date: Tue, 1 Feb 2011 10:14:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/5] perf/core improvements
Message-ID: <20110201091447.GA27297@elte.hu>
References: <1296509362-28054-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296509362-28054-1-git-send-email-acme@infradead.org>
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
> Arnaldo Carvalho de Melo (5):
>   perf evlist: Move evlist methods to evlist.c
>   perf evlist: Store pointer to the cpu and thread maps
>   perf top: Move display agnostic routines to util/top.[ch]
>   perf tools: Don't fallback to setup_pager unconditionally
>   perf top: Introduce slang based TUI
> 
>  tools/perf/Makefile               |    6 +
>  tools/perf/builtin-annotate.c     |    2 +-
>  tools/perf/builtin-record.c       |   44 ++--
>  tools/perf/builtin-report.c       |    2 +-
>  tools/perf/builtin-stat.c         |   45 ++--
>  tools/perf/builtin-test.c         |    6 +-
>  tools/perf/builtin-top.c          |  530 ++++++++++++-------------------------
>  tools/perf/python/twatch.py       |    4 +-
>  tools/perf/util/cache.h           |    7 +-
>  tools/perf/util/evlist.c          |  185 +++++++++++++-
>  tools/perf/util/evlist.h          |   28 ++-
>  tools/perf/util/evsel.c           |  144 +----------
>  tools/perf/util/evsel.h           |    4 -
>  tools/perf/util/python.c          |   25 +-
>  tools/perf/util/top.c             |  217 +++++++++++++++
>  tools/perf/util/top.h             |   80 ++++++
>  tools/perf/util/ui/browsers/top.c |  136 ++++++++++
>  tools/perf/util/ui/setup.c        |    5 +-
>  18 files changed, 887 insertions(+), 583 deletions(-)
>  create mode 100644 tools/perf/util/top.c
>  create mode 100644 tools/perf/util/top.h
>  create mode 100644 tools/perf/util/ui/browsers/top.c

Pulled, thanks Arnaldo!

Note, there's a beauty wart i noticed, while building perf on 32-bit Fedora: the build output
includes new, unintended lines:

    CC util/scripting-engines/trace-event-perl.o
    CC scripts/perl/Perf-Trace-Util/Context.o
    CC util/scripting-engines/trace-event-python.o
    CC scripts/python/Perf-Trace-Util/Context.o
    CC perf.o
    CC builtin-help.o
gcc -pthread -fno-strict-aliasing -DNDEBUG -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m32 -march=i686 -mtune=atom -fasynchronous-unwind-tables -D_GNU_SOURCE -fPIC -fwrapv -fPIC -Iutil/include -I/usr/include/python2.6 -c util/evlist.c -o temp.linux-i686-2.6/util/evlist.o -fno-strict-aliasing -Wno-write-strings
gcc -pthread -fno-strict-aliasing -DNDEBUG -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m32 -march=i686 -mtune=atom -fasynchronous-unwind-tables -D_GNU_SOURCE -fPIC -fwrapv -fPIC -Iutil/include -I/usr/include/python2.6 -c util/evsel.c -o temp.linux-i686-2.6/util/evsel.o -fno-strict-aliasing -Wno-write-strings
gcc -pthread -fno-strict-aliasing -DNDEBUG -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m32 -march=i686 -mtune=atom -fasynchronous-unwind-tables -D_GNU_SOURCE -fPIC -fwrapv -fPIC -Iutil/include -I/usr/include/python2.6 -c util/cpumap.c -o temp.linux-i686-2.6/util/cpumap.o -fno-strict-aliasing -Wno-write-strings
gcc -pthread -fno-strict-aliasing -DNDEBUG -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m32 -march=i686 -mtune=atom -fasynchronous-unwind-tables -D_GNU_SOURCE -fPIC -fwrapv -fPIC -Iutil/include -I/usr/include/python2.6 -c util/thread_map.c -o temp.linux-i686-2.6/util/thread_map.o -fno-strict-aliasing -Wno-write-strings
gcc -pthread -fno-strict-aliasing -DNDEBUG -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m32 -march=i686 -mtune=atom -fasynchronous-unwind-tables -D_GNU_SOURCE -fPIC -fwrapv -fPIC -Iutil/include -I/usr/include/python2.6 -c util/util.c -o temp.linux-i686-2.6/util/util.o -fno-strict-aliasing -Wno-write-strings
gcc -pthread -fno-strict-aliasing -DNDEBUG -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m32 -march=i686 -mtune=atom -fasynchronous-unwind-tables -D_GNU_SOURCE -fPIC -fwrapv -fPIC -Iutil/include -I/usr/include/python2.6 -c util/xyarray.c -o temp.linux-i686-2.6/util/xyarray.o -fno-strict-aliasing -Wno-write-strings
gcc -pthread -shared temp.linux-i686-2.6/util/python.o temp.linux-i686-2.6/util/ctype.o temp.linux-i686-2.6/util/evlist.o temp.linux-i686-2.6/util/evsel.o temp.linux-i686-2.6/util/cpumap.o temp.linux-i686-2.6/util/thread_map.o temp.linux-i686-2.6/util/util.o temp.linux-i686-2.6/util/xyarray.o -L/usr/lib -lpython2.6 -o lib.linux-i686-2.6/perf.so
    AR libperf.a
    LINK perf

See all tose 'gcc -pthread ...' lines? Those should have the simplified 'CC '-alike 
output as well i suspect.

Thanks,

	Ingo
