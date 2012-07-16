Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab2GPJ3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 05:29:12 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:36656 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab2GPJ3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 05:29:10 -0400
Message-ID: <5003DEB8.7000108@oracle.com>
Date: Mon, 16 Jul 2012 17:28:24 +0800
From: Jeff Liu <jeff.liu@oracle.com>
Reply-To: jeff.liu@oracle.com
Organization: Oracle
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: Perf:  user land tools compiled failed on 3.5.0-rc7
References: <5002D46E.4080103@oracle.com> <87mx302sly.fsf@sejong.aot.lge.com>
In-Reply-To: <87mx302sly.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Namhyung,

Thanks for your response!
On 07/16/2012 01:16 PM, Namhyung Kim wrote:

> Hi,
> 
> (CC-ing Jiri)
> 
> On Sun, 15 Jul 2012 22:32:14 +0800, Jeff Liu wrote:
>> Hello,
>>
>> I failed to compile perf tools on 3.5.0-rc7 with bison && flex
>> pre-installed.
>>
>> The error seems something like this,
>>
>> libperf.a(pmu.o): In function `pmu_format_parse':
>> /usr/src/linux/tools/perf/util/pmu.c:47: undefined reference to
>> `perf_pmu_in'
>> libperf.a(pmu-bison.o): In function `perf_pmu_parse':
>> /usr/src/linux/tools/perf/util/pmu-bison.c:1287: undefined reference to
>> `perf_pmu_lex'
>>
> 
> Hmm.. I can't reproduce it. Those symbols should be in pmu-flex.c:
> 
>  $ grep 'perf_pmu_in$' -Inr .
>  ./util/pmu-flex.c:15:#define yyin perf_pmu_in
> 
>  $ grep 'perf_pmu_lex ' -Inr .
>  ./util/pmu-flex.h:292:extern int perf_pmu_lex (void);
>  ./util/pmu-flex.h:294:#define YY_DECL int perf_pmu_lex (void)
>  ./util/pmu-flex.c:650:extern int perf_pmu_lex (void);
>  ./util/pmu-flex.c:652:#define YY_DECL int perf_pmu_lex (void)
>  ./util/pmu-flex.c:946:} /* end of perf_pmu_lex */
>  ./util/pmu-bison.c:86:extern int perf_pmu_lex (void);
>  ./util/pmu.y:14:extern int perf_pmu_lex (void);

Oops! I just realized that there is no util/pmu-flex.h and utils/pmu-flex.c is even an empty file on my source tree. :(
I'll try it again with a refreshed clone.

Thanks,
-Jeff

> 
> Thanks,
> Namhyung
> 
> 
>> For detail, please check the following,
>>
>> /usr/src/linux/tools/perf$ make -j12
>> Makefile:450: No libdw.h found or old libdw.h found or elfutils is older
>> than 0.138, disables dwarf support. Please install new
>> elfutils-devel/libdw-dev
>> PERF_VERSION = 3.5.rc7
>> Makefile:450: No libdw.h found or old libdw.h found or elfutils is older
>> than 0.138, disables dwarf support. Please install new
>> elfutils-devel/libdw-dev
>>     GEN common-cmds.h
>>     * new build flags or prefix
>>     CC bench/mem-memcpy-x86-64-asm.o
>>     CC bench/mem-memset-x86-64-asm.o
>>     CC bench/mem-memcpy.o
>>     CC bench/mem-memset.o
>>     CC builtin-diff.o
>>     CC builtin-evlist.o
>>     CC builtin-sched.o
>>     CC builtin-buildid-list.o
>>     CC builtin-buildid-cache.o
>>     CC builtin-list.o
>>     CC builtin-record.o
>>     CC builtin-report.o
>>     CC builtin-stat.o
>>     CC builtin-timechart.o
>>     CC builtin-top.o
>>     CC builtin-script.o
>>     CC builtin-probe.o
>>     CC builtin-kmem.o
>>     CC builtin-lock.o
>>     CC builtin-kvm.o
>>     CC builtin-test.o
>>     CC builtin-inject.o
>>     CC util/abspath.o
>>     CC util/alias.o
>>     CC util/annotate.o
>>     CC util/build-id.o
>>     CC util/config.o
>>     CC util/ctype.o
>>     CC util/debugfs.o
>>     CC util/sysfs.o
>>     CC util/pmu.o
>>     CC util/environment.o
>>     CC util/event.o
>>     CC util/evlist.o
>>     CC util/evsel.o
>>     CC util/exec_cmd.o
>>     CC util/help.o
>>     CC util/levenshtein.o
>>     CC util/parse-options.o
>>     CC util/parse-events.o
>>     CC util/parse-events-test.o
>>     CC util/path.o
>>     CC util/rbtree.o
>>     CC util/bitmap.o
>>     CC util/hweight.o
>>     CC util/run-command.o
>>     CC util/quote.o
>>     CC util/strbuf.o
>>     CC util/string.o
>>     CC util/strlist.o
>>     CC util/strfilter.o
>>     CC util/top.o
>>     CC util/usage.o
>>     CC util/wrapper.o
>>     CC util/sigchain.o
>>     CC util/symbol.o
>>     CC util/color.o
>>     CC util/pager.o
>>     CC util/header.o
>>     CC util/callchain.o
>>     CC util/values.o
>>     CC util/debug.o
>>     CC util/map.o
>>     CC util/pstack.o
>>     CC util/session.o
>>     CC util/thread.o
>>     CC util/thread_map.o
>>     CC util/trace-event-parse.o
>>     CC util/parse-events-flex.o
>>     CC util/parse-events-bison.o
>>     CC util/pmu-flex.o
>>     CC util/pmu-bison.o
>>     CC util/trace-event-read.o
>>     CC util/trace-event-info.o
>>     CC util/trace-event-scripting.o
>>     CC util/svghelper.o
>>     CC util/sort.o
>>     CC util/hist.o
>>     CC util/probe-event.o
>>     CC util/util.o
>>     CC util/xyarray.o
>>     CC util/cpumap.o
>>     CC util/cgroup.o
>>     CC util/target.o
>>     CC arch/x86/util/header.o
>>     CC ui/setup.o
>>     CC ui/browser.o
>>     CC ui/browsers/annotate.o
>>     CC ui/browsers/hists.o
>>     CC ui/browsers/map.o
>>     CC ui/helpline.o
>>     CC ui/progress.o
>>     CC ui/util.o
>>     CC ui/tui/setup.o
>>     CC ui/gtk/browser.o
>>     CC ui/gtk/setup.o
>>     CC util/scripting-engines/trace-event-python.o
>>     CC scripts/python/Perf-Trace-Util/Context.o
>>     SUBDIR ../lib/traceevent/
>>     GEN perf-archive
>> make[1]: `libtraceevent.a' is up to date.
>>     GEN python/perf.so
>>     CC perf.o
>>     CC builtin-annotate.o
>>     CC builtin-bench.o
>>     CC bench/sched-messaging.o
>>     CC bench/sched-pipe.o
>>     CC builtin-help.o
>>     AR libperf.a
>>     LINK perf
>> libperf.a(pmu.o): In function `pmu_format_parse':
>> /usr/src/linux/tools/perf/util/pmu.c:47: undefined reference to
>> `perf_pmu_in'
>> libperf.a(pmu-bison.o): In function `perf_pmu_parse':
>> /usr/src/linux/tools/perf/util/pmu-bison.c:1287: undefined reference to
>> `perf_pmu_lex'
>> collect2: ld returned 1 exit status
>> make: *** [perf] Error 1
>> make: *** Waiting for unfinished jobs....
>>
>>
>> Thanks,
>> -Jeff


