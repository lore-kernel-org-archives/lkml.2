Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab2F0O2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:28:24 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64423 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab2F0O2X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:28:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAMO-S2jPvVZndo3_cM67ZvXXV5y5CKvxe-x6YGfguq3w9mVbAg@mail.gmail.com>
References: <1339944948-3193-1-git-send-email-namhyung@kernel.org>
	<20120618090501.GB28824@gmail.com>
	<87mx3zhekz.fsf@sejong.aot.lge.com>
	<CAMO-S2jPvVZndo3_cM67ZvXXV5y5CKvxe-x6YGfguq3w9mVbAg@mail.gmail.com>
Date: Wed, 27 Jun 2012 23:28:22 +0900
Message-ID: <CAMO-S2j74+=9QJ40-=3Zj9a2M2wnCC474vsm216GP-BB9OWbsg@mail.gmail.com>
Subject: Re: [PATCH] perf tools: Fix an error on perf-bench document
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 12:59 AM, Hitoshi Mitake <h.mitake@gmail.com> wrote:
> On Tue, Jun 19, 2012 at 5:48 PM, Namhyung Kim <namhyung@kernel.org> wrote:
>> Hi, Ingo
>>
>> On Mon, 18 Jun 2012 11:05:01 +0200, Ingo Molnar wrote:
>>> There's several typos all across the perf bench documentation:
>>>
>>> 1)
>>>
>>>        This perf bench command is general framework for benchmark suites.
>>>
>>> s/is general/is a general
>>>
>>
>> Will fix.
>>
>>
>>> 2)
>>>
>>> The output of 'perf bench --help' outputs weird looking
>>> formatting characters like:
>>>
>>>            .ft C
>>>            % perf bench sched pipe                      # with no style specified
>>>            (executing 1000000 pipe operations between two tasks)
>>>                    Total time:5.855 sec
>>>                            5.855061 usecs/op
>>>                            170792 ops/sec
>>>            .ft
>>>
>>
>> I have no idea on this, maybe a problem of asciidoc?
>>
>>
>>> 3)
>>>
>>> This:
>>>
>>>            all: test all suite (pseudo suite)
>>>
>>> s/all suite (psudo suite)/all benchmark suites
>>>
>>> (this should be fixed for perf bench mem as well.)
>>>
>>
>> Will fix.
>>
>>
>>> 4)
>>>
>>> perf bench mem memcpy -h outputs:
>>>
>>>     -l, --length <1MB>    Specify length of memory to copy. available unit: B, MB, GB (upper and lower)
>>>
>>> bad capitalization: s/. a/. A
>>>
>>> s/unit/units
>>>
>>
>> Will fix too.
>>
>>
>>> 5)
>>>
>>> This:
>>>
>>>     -c, --clock           Use CPU clock for measuring
>>>
>>> should probably clarify why the CPU clock matters and what
>>> measurement is done otherwise.
>>>
>>
>> This looks a bit weird. If -c switch was given, it'd use the cycles
>> event not the cpu-clock event. If omitted, it'd use the gtod().
>>
>
> Very sorry, I misused the terms clock and cycles. The memset uses
> hardware cycles event, the above naming and description with "clock"
> is very bad...
> I will write and send a patch for fix the problem.

I wrote the simple fix for eliminatng wrong usage of "clock":
https://github.com/mitake/linux/commit/b7836d41deff430c16058ca729120dccfa41e74e

This patch assumes the change made by the Namhyung's patch. So I'm
planning to send this after the Namhyung's patch is applied to tip
tree. Or should the patches be unified before applied?


-- 
Hitoshi Mitake
h.mitake@gmail.com
