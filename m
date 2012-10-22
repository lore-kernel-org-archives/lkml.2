Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab2JVIvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:51:07 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61935 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab2JVIvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:51:05 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-55-508508f54bee
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/11] perf tool: Add PERF_SAMPLE_READ sample read support
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
	<20121021163848.GB28726@gmail.com>
	<20121022080930.GB984@krava.brq.redhat.com>
Date: Mon, 22 Oct 2012 17:51:01 +0900
In-Reply-To: <20121022080930.GB984@krava.brq.redhat.com> (Jiri Olsa's message
	of "Mon, 22 Oct 2012 10:09:31 +0200")
Message-ID: <87a9vekhze.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012 10:09:31 +0200, Jiri Olsa wrote:
> On Sun, Oct 21, 2012 at 06:38:49PM +0200, Ingo Molnar wrote:
>> >   #
>> >   # Samples: 86  of event 'anon group { cycles, cache-misses }'
>> >   # Event count (approx.): 34863674
>> >   #
>> >   #         Overhead                    Period  Command      Shared Object                            Symbol
>> >   # ................  ........................  .......  .................  ................................
>> 
>> Might make sense to consider this column enumeration:
>> 
>>     #
>>     #   cycles
>>     #   |       cache-misses
>>     #   |       |
>> >   #   v       v
>> >   #
>> >       16.56%  19.47%       5773450         475       ls  [kernel.kallsyms]  [k] native_sched_clock          
>> >       10.87%   0.74%       3789088          18       ls  [kernel.kallsyms]  [k] rtl8169_interrupt           
>
> no problem in '--stdio' mode I guess.. not sure in '--tui/--gtk', Namhyung?

I thought a similar way but met a problem.  We have other output columns
than 'overhead' like 'period' in this example.  What about others?
Adding all event names for each column will just increase the column
width so bothers user IMHO - especially for pmu format events.

So I ended up printing those events on the header:

  # Samples: 86  of event 'anon group { cycles, cache-misses }'

Thanks,
Namhyung
