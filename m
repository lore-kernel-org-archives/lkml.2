Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab2FORNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 13:13:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:48034 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab2FORNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 13:13:22 -0400
Date: Fri, 15 Jun 2012 14:13:10 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Dmitry Antipov <dmitry.antipov@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jim Cromie <jim.cromie@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/3] perf/urgent fixes
Message-ID: <20120615171310.GD11550@infradead.org>
References: <1339601367-17834-1-git-send-email-acme@infradead.org>
 <20120614100710.GB19531@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120614100710.GB19531@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 14, 2012 at 12:07:10PM +0200, Ingo Molnar escreveu:
> Hm, fails to build here:
> 
>     CC util/parse-events-bison.o
> util/parse-events.l: In function ‘__value’:
> util/parse-events.l:18:10: error: ‘PE_ERROR’ undeclared (first 
> use in this function)
> util/parse-events.l:18:10: note: each undeclared identifier is 
> reported only once for each function it appears in
> util/parse-events.l:20:2: error: ‘parse_events_lval’ undeclared 
> (first use in this function)
> util/parse-events.l: In function ‘value’:
> util/parse-events.l:26:42: error: ‘PE_VALUE’ undeclared (first 
> use in this function)
> util/parse-events.l: In function ‘raw’:
> util/parse-events.l:31:44: error: ‘PE_RAW’ undeclared (first use 
> in this function)
> util/parse-events.l: In function ‘str’:
> 
> stock Fedora 17 install. 25f42985825d builds fine.

Is this 32-bit? I'm installing another VM now, but on Fedora 17 x86_64:

[acme@fedora17 linux]$ mkdir -p ../build/perf
[acme@fedora17 linux]$ make -j2 O=/home/acme/git/build/perf -C tools/perf/
make: Entering directory `/home/acme/git/linux/tools/perf'
    MKDIR /home/acme/git/build/perf/arch/x86/util/
    MKDIR /home/acme/git/build/perf/bench/
    MKDIR /home/acme/git/build/perf/scripts/python/Perf-Trace-Util/
    MKDIR /home/acme/git/build/perf/ui/
    MKDIR /home/acme/git/build/perf/ui/browsers/
    MKDIR /home/acme/git/build/perf/ui/gtk/
    MKDIR /home/acme/git/build/perf/ui/tui/
    MKDIR /home/acme/git/build/perf/util/
    MKDIR /home/acme/git/build/perf/util/scripting-engines/
PERF_VERSION = 3.5.rc1.87.gcb9dd4
make: Leaving directory `/home/acme/git/linux/tools/perf'
make: Entering directory `/home/acme/git/linux/tools/perf'
    GEN /home/acme/git/build/perf/common-cmds.h
    * new build flags or prefix
    CC /home/acme/git/build/perf/bench/mem-memcpy-x86-64-asm.o
    CC /home/acme/git/build/perf/bench/mem-memset-x86-64-asm.o
    CC /home/acme/git/build/perf/bench/mem-memcpy.o
    CC /home/acme/git/build/perf/bench/mem-memset.o
    CC /home/acme/git/build/perf/builtin-diff.o
    CC /home/acme/git/build/perf/builtin-evlist.o
    CC /home/acme/git/build/perf/builtin-help.o
    CC /home/acme/git/build/perf/builtin-sched.o
    CC /home/acme/git/build/perf/builtin-buildid-list.o
    CC /home/acme/git/build/perf/builtin-buildid-cache.o
    CC /home/acme/git/build/perf/builtin-list.o
    CC /home/acme/git/build/perf/builtin-record.o
    CC /home/acme/git/build/perf/builtin-report.o
    CC /home/acme/git/build/perf/builtin-stat.o
    CC /home/acme/git/build/perf/builtin-timechart.o
    CC /home/acme/git/build/perf/builtin-top.o
    CC /home/acme/git/build/perf/builtin-script.o
    CC /home/acme/git/build/perf/builtin-probe.o
    CC /home/acme/git/build/perf/builtin-kmem.o
    CC /home/acme/git/build/perf/builtin-lock.o
    CC /home/acme/git/build/perf/builtin-kvm.o
    CC /home/acme/git/build/perf/builtin-test.o
    CC /home/acme/git/build/perf/builtin-inject.o
    CC /home/acme/git/build/perf/util/abspath.o
    CC /home/acme/git/build/perf/util/alias.o
    CC /home/acme/git/build/perf/util/annotate.o
    CC /home/acme/git/build/perf/util/build-id.o
    CC /home/acme/git/build/perf/util/config.o
    CC /home/acme/git/build/perf/util/ctype.o
    CC /home/acme/git/build/perf/util/debugfs.o
    CC /home/acme/git/build/perf/util/sysfs.o
    FLEX /home/acme/git/build/perf/util/pmu-flex.c
    BISON /home/acme/git/build/perf/util/pmu-bison.c
    CC /home/acme/git/build/perf/util/environment.o
    CC /home/acme/git/build/perf/util/event.o
    CC /home/acme/git/build/perf/util/evlist.o
    CC /home/acme/git/build/perf/util/evsel.o
    CC /home/acme/git/build/perf/util/exec_cmd.o
    CC /home/acme/git/build/perf/util/help.o
    CC /home/acme/git/build/perf/util/levenshtein.o
    CC /home/acme/git/build/perf/util/parse-options.o
    FLEX /home/acme/git/build/perf/util/parse-events-flex.c
    BISON /home/acme/git/build/perf/util/parse-events-bison.c
    CC /home/acme/git/build/perf/util/parse-events-test.o
    CC /home/acme/git/build/perf/util/path.o
    CC /home/acme/git/build/perf/util/rbtree.o
    CC /home/acme/git/build/perf/util/bitmap.o
    CC /home/acme/git/build/perf/util/hweight.o
    CC /home/acme/git/build/perf/util/run-command.o
    CC /home/acme/git/build/perf/util/quote.o
    CC /home/acme/git/build/perf/util/strbuf.o
    CC /home/acme/git/build/perf/util/string.o
    CC /home/acme/git/build/perf/util/strlist.o
    CC /home/acme/git/build/perf/util/strfilter.o
    CC /home/acme/git/build/perf/util/top.o
    CC /home/acme/git/build/perf/util/usage.o
    CC /home/acme/git/build/perf/util/wrapper.o
    CC /home/acme/git/build/perf/util/sigchain.o
    CC /home/acme/git/build/perf/util/symbol.o
    CC /home/acme/git/build/perf/util/color.o
    CC /home/acme/git/build/perf/util/pager.o
    CC /home/acme/git/build/perf/util/header.o
    CC /home/acme/git/build/perf/util/callchain.o
    CC /home/acme/git/build/perf/util/values.o
    CC /home/acme/git/build/perf/util/debug.o
    CC /home/acme/git/build/perf/util/map.o
    CC /home/acme/git/build/perf/util/pstack.o
    CC /home/acme/git/build/perf/util/session.o
    CC /home/acme/git/build/perf/util/thread.o
    CC /home/acme/git/build/perf/util/thread_map.o
    CC /home/acme/git/build/perf/util/trace-event-parse.o
    CC /home/acme/git/build/perf/util/parse-events-flex.o
    CC /home/acme/git/build/perf/util/parse-events-bison.o
    CC /home/acme/git/build/perf/util/pmu-flex.o
    CC /home/acme/git/build/perf/util/pmu-bison.o
    CC /home/acme/git/build/perf/util/trace-event-read.o
    CC /home/acme/git/build/perf/util/trace-event-info.o
    CC /home/acme/git/build/perf/util/trace-event-scripting.o
    CC /home/acme/git/build/perf/util/svghelper.o
    CC /home/acme/git/build/perf/util/sort.o
    CC /home/acme/git/build/perf/util/hist.o
    CC /home/acme/git/build/perf/util/probe-event.o
    CC /home/acme/git/build/perf/util/util.o
    CC /home/acme/git/build/perf/util/xyarray.o
    CC /home/acme/git/build/perf/util/cpumap.o
    CC /home/acme/git/build/perf/util/cgroup.o
    CC /home/acme/git/build/perf/util/target.o
    CC /home/acme/git/build/perf/arch/x86/util/dwarf-regs.o
    CC /home/acme/git/build/perf/arch/x86/util/header.o
    CC /home/acme/git/build/perf/util/probe-finder.o
    CC /home/acme/git/build/perf/util/dwarf-aux.o
    CC /home/acme/git/build/perf/ui/setup.o
    CC /home/acme/git/build/perf/ui/browser.o
    CC /home/acme/git/build/perf/ui/browsers/annotate.o
    CC /home/acme/git/build/perf/ui/browsers/hists.o
    CC /home/acme/git/build/perf/ui/browsers/map.o
    CC /home/acme/git/build/perf/ui/helpline.o
    CC /home/acme/git/build/perf/ui/progress.o
    CC /home/acme/git/build/perf/ui/util.o
    CC /home/acme/git/build/perf/ui/tui/setup.o
    CC /home/acme/git/build/perf/ui/gtk/browser.o
    CC /home/acme/git/build/perf/ui/gtk/setup.o
    CC /home/acme/git/build/perf/util/scripting-engines/trace-event-python.o
    CC /home/acme/git/build/perf/scripts/python/Perf-Trace-Util/Context.o
make[1]: Entering directory `/home/acme/git/linux/tools/lib/traceevent'
make[2]: warning: jobserver unavailable: using -j1.  Add `+' to parent make rule.
    GEN perf-archive
  CC FPIC            event-parse.o
    GEN /home/acme/git/build/perf/python/perf.so
  CC FPIC            trace-seq.o
  CC FPIC            parse-filter.o
  CC FPIC            parse-utils.o
  BUILD STATIC LIB   libtraceevent.a
make[1]: Leaving directory `/home/acme/git/linux/tools/lib/traceevent'
    CC /home/acme/git/build/perf/perf.o
    CC /home/acme/git/build/perf/builtin-annotate.o
    CC /home/acme/git/build/perf/builtin-bench.o
    CC /home/acme/git/build/perf/bench/sched-messaging.o
    CC /home/acme/git/build/perf/bench/sched-pipe.o
    CC /home/acme/git/build/perf/util/pmu.o
    CC /home/acme/git/build/perf/util/parse-events.o
    AR /home/acme/git/build/perf/libperf.a
    LINK /home/acme/git/build/perf/perf
make: Leaving directory `/home/acme/git/linux/tools/perf'
[acme@fedora17 linux]$ cat /etc/fedora-release 
Fedora release 17 (Beefy Miracle)
[acme@fedora17 linux]$ 
[acme@fedora17 linux]$ git describe
perf-urgent-for-mingo
[acme@fedora17 linux]$ git describe --match 'v[0-9].[0-9]*'
v3.5-rc1-87-gcb9dd49
[acme@fedora17 linux]$ git branch | grep '*'
* perf/urgent
[acme@fedora17 linux]$ uname -a
Linux fedora17.ghostprotocols.net 3.4.0-1.fc17.x86_64 #1 SMP Sun Jun 3 06:35:17 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
[acme@fedora17 linux]$
