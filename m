Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab2EDBi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 21:38:28 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57810 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab2EDBi1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 21:38:27 -0400
X-AuditID: 9c930179-b7c19ae000000486-41-4fa33310268d
From: Namhyung Kim <namhyung.kim@lge.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Arnaud Lacombe <lacombar@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: perf build failure on Linus's tree
References: <20120503215748.GA18995@kroah.com>
Date: Fri, 04 May 2012 10:37:24 +0900
In-Reply-To: <20120503215748.GA18995@kroah.com> (Greg KH's message of "Thu, 3
	May 2012 14:57:48 -0700")
Message-ID: <87sjfgafqj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 3 May 2012 14:57:48 -0700, Greg KH wrote:
> Linus's tree right now (3.4.rc5.67.gac001.dirty) gives me the following
> build error when I try to build perf:
>     CC util/parse-events-flex.o
> <stdout>: In function ‘yy_get_next_buffer’:
> <stdout>:1510:3: error: comparison between signed and unsigned integer expressions [-Werror=sign-compare]
> util/parse-events.l: In function ‘parse_events_lex’:
> util/parse-events.l:122:1: error: ignoring return value of ‘fwrite’, declared with attribute warn_unused_result [-Werror=unused-result]
> cc1: all warnings being treated as errors
>
> Do you really want to ensure that flex's build warnings fail the build?
>
> thanks,
>
> greg k-h

Can't reproduce it on my Fedora 17 box:

namhyung@sejong:perf$ make
PERF_VERSION = 3.4.rc5.67.gac001
    GEN common-cmds.h
    * new build flags or prefix
    CC perf.o
    CC builtin-annotate.o
    CC builtin-bench.o
    CC bench/sched-messaging.o
    CC bench/sched-pipe.o
[SNIP]
    CC util/trace-event-parse.o
    CC util/parse-events-flex.o
    CC util/parse-events-bison.o
    CC util/pmu-flex.o
    CC util/pmu-bison.o
[SNIP]
    CC util/scripting-engines/trace-event-python.o
    CC scripts/python/Perf-Trace-Util/Context.o
    AR libperf.a
    LINK perf
    GEN perf-archive
    GEN python/perf.so


What are versions of tools you are using?

Thanks,
Namhyung
