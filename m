Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab2GOOdP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 10:33:15 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17344 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab2GOOdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 10:33:04 -0400
Message-ID: <5002D46E.4080103@oracle.com>
Date: Sun, 15 Jul 2012 22:32:14 +0800
From: Jeff Liu <jeff.liu@oracle.com>
Reply-To: jeff.liu@oracle.com
Organization: Oracle
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Perf:  user land tools compiled failed on 3.5.0-rc7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I failed to compile perf tools on 3.5.0-rc7 with bison && flex
pre-installed.

The error seems something like this,

libperf.a(pmu.o): In function `pmu_format_parse':
/usr/src/linux/tools/perf/util/pmu.c:47: undefined reference to
`perf_pmu_in'
libperf.a(pmu-bison.o): In function `perf_pmu_parse':
/usr/src/linux/tools/perf/util/pmu-bison.c:1287: undefined reference to
`perf_pmu_lex'

For detail, please check the following,

/usr/src/linux/tools/perf$ make -j12
Makefile:450: No libdw.h found or old libdw.h found or elfutils is older
than 0.138, disables dwarf support. Please install new
elfutils-devel/libdw-dev
PERF_VERSION = 3.5.rc7
Makefile:450: No libdw.h found or old libdw.h found or elfutils is older
than 0.138, disables dwarf support. Please install new
elfutils-devel/libdw-dev
    GEN common-cmds.h
    * new build flags or prefix
    CC bench/mem-memcpy-x86-64-asm.o
    CC bench/mem-memset-x86-64-asm.o
    CC bench/mem-memcpy.o
    CC bench/mem-memset.o
    CC builtin-diff.o
    CC builtin-evlist.o
    CC builtin-sched.o
    CC builtin-buildid-list.o
    CC builtin-buildid-cache.o
    CC builtin-list.o
    CC builtin-record.o
    CC builtin-report.o
    CC builtin-stat.o
    CC builtin-timechart.o
    CC builtin-top.o
    CC builtin-script.o
    CC builtin-probe.o
    CC builtin-kmem.o
    CC builtin-lock.o
    CC builtin-kvm.o
    CC builtin-test.o
    CC builtin-inject.o
    CC util/abspath.o
    CC util/alias.o
    CC util/annotate.o
    CC util/build-id.o
    CC util/config.o
    CC util/ctype.o
    CC util/debugfs.o
    CC util/sysfs.o
    CC util/pmu.o
    CC util/environment.o
    CC util/event.o
    CC util/evlist.o
    CC util/evsel.o
    CC util/exec_cmd.o
    CC util/help.o
    CC util/levenshtein.o
    CC util/parse-options.o
    CC util/parse-events.o
    CC util/parse-events-test.o
    CC util/path.o
    CC util/rbtree.o
    CC util/bitmap.o
    CC util/hweight.o
    CC util/run-command.o
    CC util/quote.o
    CC util/strbuf.o
    CC util/string.o
    CC util/strlist.o
    CC util/strfilter.o
    CC util/top.o
    CC util/usage.o
    CC util/wrapper.o
    CC util/sigchain.o
    CC util/symbol.o
    CC util/color.o
    CC util/pager.o
    CC util/header.o
    CC util/callchain.o
    CC util/values.o
    CC util/debug.o
    CC util/map.o
    CC util/pstack.o
    CC util/session.o
    CC util/thread.o
    CC util/thread_map.o
    CC util/trace-event-parse.o
    CC util/parse-events-flex.o
    CC util/parse-events-bison.o
    CC util/pmu-flex.o
    CC util/pmu-bison.o
    CC util/trace-event-read.o
    CC util/trace-event-info.o
    CC util/trace-event-scripting.o
    CC util/svghelper.o
    CC util/sort.o
    CC util/hist.o
    CC util/probe-event.o
    CC util/util.o
    CC util/xyarray.o
    CC util/cpumap.o
    CC util/cgroup.o
    CC util/target.o
    CC arch/x86/util/header.o
    CC ui/setup.o
    CC ui/browser.o
    CC ui/browsers/annotate.o
    CC ui/browsers/hists.o
    CC ui/browsers/map.o
    CC ui/helpline.o
    CC ui/progress.o
    CC ui/util.o
    CC ui/tui/setup.o
    CC ui/gtk/browser.o
    CC ui/gtk/setup.o
    CC util/scripting-engines/trace-event-python.o
    CC scripts/python/Perf-Trace-Util/Context.o
    SUBDIR ../lib/traceevent/
    GEN perf-archive
make[1]: `libtraceevent.a' is up to date.
    GEN python/perf.so
    CC perf.o
    CC builtin-annotate.o
    CC builtin-bench.o
    CC bench/sched-messaging.o
    CC bench/sched-pipe.o
    CC builtin-help.o
    AR libperf.a
    LINK perf
libperf.a(pmu.o): In function `pmu_format_parse':
/usr/src/linux/tools/perf/util/pmu.c:47: undefined reference to
`perf_pmu_in'
libperf.a(pmu-bison.o): In function `perf_pmu_parse':
/usr/src/linux/tools/perf/util/pmu-bison.c:1287: undefined reference to
`perf_pmu_lex'
collect2: ld returned 1 exit status
make: *** [perf] Error 1
make: *** Waiting for unfinished jobs....


Thanks,
-Jeff
