Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab2J3Hmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 03:42:47 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58775 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab2J3Hmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 03:42:46 -0400
X-AuditID: 9c930179-b7c8bae000003559-9b-508f84f44d45
From: Namhyung Kim <namhyung@kernel.org>
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Arnaldo de Melo <acme@infradead.org>, mingo@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        akshay kumar <iit.akshay@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] perf report: different reports when run on terminal as opposed to script
References: <CAPhKKr8HAbAw2jdvva6oJYj747ZS0dTakz2=qJXN+NsTiu=dCg@mail.gmail.com>
	<CAPhKKr8KNi0kU4CcbPofZT7sghumeUTRyiuywOWrd24DiF4gFQ@mail.gmail.com>
Date: Tue, 30 Oct 2012 16:42:44 +0900
In-Reply-To: <CAPhKKr8KNi0kU4CcbPofZT7sghumeUTRyiuywOWrd24DiF4gFQ@mail.gmail.com>
	(Dhaval Giani's message of "Mon, 29 Oct 2012 12:45:53 -0400")
Message-ID: <871ugg76dn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dhaval,

On Mon, 29 Oct 2012 12:45:53 -0400, Dhaval Giani wrote:
> On Mon, Oct 29, 2012 at 12:01 PM, Dhaval Giani <dhaval.giani@gmail.com> wrote:
>> Hi,
>>
>> As part of a class assignment I have to collect some performance
>> statistics. In order to do so I run
>>
>> perf record -g <the program I have to profile>
>>
>> And in another window, I start 200 threads of the load generator
>> (which is not recorded by perf)
>>
>> This generates me statistics that I expect to see, and I am happy. As
>> this is academia and a class assignment, I need to collect information
>> and analyze it across different setups. Which of course meant I script
>> this whole thing, which basically is
>>
>> for i in all possibilities
>> do
>> perf record -g <the program I have to profile> &
>> WAITPID=$!
>> for j in NR_THREADS
>> do
>> <start load generator> &
>> KILLPID=$!
>> done
>> wait $PID

You meant $WAITPID, right?


>> kill $KILLPID

Doesn't it kill the last load generator only?


>> mv perf.data results/perf.data.$i
>> done
>>
>> (This is basic pseudo script of what I am doing), which results me
>> having my profile being topped by _vscanf() and the function which I
>> was seeing dominating in the older report dropping down to something
>> like 5% (as opposed to 16-17%)
>>
>> Have I misunderstood how perf works? Something deeper? I am currently
>> on 3.6.3. I can update to the latest upstream and report back. Any
>> debug code is very welcome. I can also make my toy program and the
>> scripts available for you to try out.
>
> I just updated to 6b0cb4eef7bdaa27b8021ea81813fba330a2d94d and I still
> see this happen.
>
> Thanks!
> Dhaval
