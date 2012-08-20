Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab2HTRm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 13:42:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773Ab2HTRmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 13:42:55 -0400
Date: Mon, 20 Aug 2012 19:42:47 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] perf tools: Catch event names from command line
Message-ID: <20120820174247.GD1176@krava.brq.redhat.com>
References: <1345144224-27280-1-git-send-email-robert.richter@amd.com>
 <1345144224-27280-6-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345144224-27280-6-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 09:10:21PM +0200, Robert Richter wrote:
> Use command line string provided by the -e option to name events. This
> way we get unique events names that also support pmu event syntax
> (<pmu_name>/<config>/<modifier>). No need to reconstruct the name
> anymore from its attributes. We use the event_desc of the header to
> store the name in the perf.data header. Thus it is also available for
> perf report.
> 
> Implemented by putting the parser in different states to parse events
> or configs.

I like the idea of multiple states in parser,
but parse tests fails:

[jolsa@krava perf]$ ./perf test -vvv parse
 5: parse events tests:
--- start ---
running test 0 'syscalls:sys_enter_open'
running test 1 'syscalls:*'
running test 2 'r1a'
running test 3 '1:1'
running test 4 'instructions'
running test 5 'cycles/period=100000,config2/'
running test 6 'faults'
running test 7 'L1-dcache-load-miss'
running test 8 'mem:0'
running test 9 'mem:0:x'
running test 10 'mem:0:r'
running test 11 'mem:0:w'
running test 12 'syscalls:sys_enter_open:k'
running test 13 'syscalls:*:u'
running test 14 'r1a:kp'
running test 15 '1:1:hp'
running test 16 'instructions:h'
running test 17 'faults:u'
running test 18 'L1-dcache-load-miss:kp'
running test 19 'mem:0:u'
FAILED util/parse-events-test.c:309 wrong name
---- end ----
parse events tests: FAILED!


jirka
