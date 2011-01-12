Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab1ALTKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 14:10:49 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38846 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab1ALTKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 14:10:47 -0500
Message-ID: <4D2DFCAF.9020204@linux.vnet.ibm.com>
Date: Wed, 12 Jan 2011 11:10:39 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        Robert Richter <robert.richter@amd.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [BUG] perf sched broken
References: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com> <20110112121113.GD11968@ghostprotocols.net>
In-Reply-To: <20110112121113.GD11968@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2011 04:11 AM, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jan 12, 2011 at 10:29:05AM +0100, Stephane Eranian escreveu:
>> Hi,
>>
>> I am trying to use perf sched from tip-x86 but it fails for all my attempts.
>>
>> First of, I think the event list is stale. This is not so much the
>> events themselves
>> but rather the flags.
>>
>> Looks to me like the :r modifier is not supported anymore, so a patch like the
>> one below is needed. That helps collect a trace. But then, you can dump
>> the trace.
>
> I got to this point as well, and reverting 4c635a4 did the trick for me,
> Corey, this is another report for that problem, can you take a look at
> it? Stephane, can you try doing a:
>
> git show 4c635a4 | patch -p1 -R
>
> To see if the problem is fixed?
>

I will have a look at this now.  Thanks for the report.

- Corey

> - Arnaldo
>
>> $ perf sched rec dd if=/dev/zero of=/dev/null count=1000000
>> 1000000+0 records in
>> 1000000+0 records out
>> 512000000 bytes (512 MB) copied, 0.589981 s, 868 MB/s
>> [ perf record: Woken up 1 times to write data ]
>> [ perf record: Captured and wrote 0.481 MB perf.data (~20997 samples) ]
>>
>> $ perf sched rep
>> run measurement overhead: 2934 nsecs
>> sleep measurement overhead: 90502 nsecs
>> the run test took 999149 nsecs
>> the sleep test took 1092248 nsecs
>>    Fatal: no trace data in the file
>>
>> $ perf sched trace -D
>>   usage: perf sched [<options>] {record|latency|map|replay|trace}
>>
>>      -i, --input<file>     input file name
>>      -v, --verbose         be more verbose (show symbol address, etc)
>>      -D, --dump-raw-trace  dump raw trace in ASCII
>>
>> Note that this is not specific to pref sched. If I use perf record directly,
>> I run into the same issue:
>> $ perf record -R -a -c 1 -e sched:sched_switch -- sleep 1
>> [ perf record: Woken up 1 times to write data ]
>> [ perf record: Captured and wrote 0.365 MB perf.data (~15962 samples) ]
>> $./perf report -D
>>    Fatal: no trace data in the file
>>
>> Now that perf trace is gone, how to I dump the trace?
>
> Good question, checking this s/trace/script/g fallout.
>
> - Arnaldo

