Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762405Ab2KBBZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 21:25:28 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58194 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165Ab2KBBZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 21:25:20 -0400
X-AuditID: 9c930179-b7c8bae000003559-79-509320fe0de7
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/25] perf test: Add perf_event_attr tests
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
	<20121101203800.GA3911@ghostprotocols.net>
	<20121101232055.GA1690@krava.redhat.com>
Date: Fri, 02 Nov 2012 10:25:18 +0900
In-Reply-To: <20121101232055.GA1690@krava.redhat.com> (Jiri Olsa's message of
	"Fri, 2 Nov 2012 00:20:56 +0100")
Message-ID: <87objg4wzl.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2 Nov 2012 00:20:56 +0100, Jiri Olsa wrote:
> On Thu, Nov 01, 2012 at 05:38:01PM -0300, Arnaldo Carvalho de Melo wrote:
>> Ah, I just pushed perf/core with this patchset, thanks!
>
> thanks,
> jirka

When using current acme/perf/core, I got this:

namhyung@sejong:perf$ ./perf test -v perf_event_attr
13: struct perf_event_attr setup                           :
--- start ---
running './tests/attr/test-record-count'
running './tests/attr/test-stat-group1'
Traceback (most recent call last):
  File "./tests/attr.py", line 313, in <module>
    main()
  File "./tests/attr.py", line 304, in main
    run_tests(options)
  File "./tests/attr.py", line 247, in run_tests
    Test(f, options).run()
  File "./tests/attr.py", line 126, in __init__
    self.load_events(path, self.expect)
  File "./tests/attr.py", line 147, in load_events
    base_items = parser_base.items('event')
  File "/usr/lib64/python2.7/ConfigParser.py", line 642, in items
    raise NoSectionError(section)
ConfigParser.NoSectionError: No section: 'event'
---- end ----
struct perf_event_attr setup: FAILED!

namhyung@sejong:perf$ cat tests/attr/test-stat-group1 
[config]
command = stat
args    = -e '{cycles,instructions}' kill >/dev/null 2>&1
ret     = 1

[event-1:base-stat]
fd=1
group_fd=-1

[event-2:base-stat]
fd=2
group_fd=1
config=1
# TODO both disabled and enable_on_exec are disabled for --group option,
#      enabled otherwise, check why..
disabled=1
enable_on_exec=1


Thanks,
Namhyung
