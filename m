Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393Ab2FETEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 15:04:08 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46095 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751087Ab2FETEG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 15:04:06 -0400
MIME-Version: 1.0
In-Reply-To: <4FCE3DE3.9060805@gmail.com>
References: <4FCE25C6.2080601@gmail.com>
	<1338912052.2749.2.camel@twins>
	<1338912312.2749.6.camel@twins>
	<4FCE3DE3.9060805@gmail.com>
Date: Tue, 5 Jun 2012 21:04:04 +0200
Message-ID: <CABPqkBSR6VCypKXoArPpvKBEpkY0MaPUmLnL7J0tOqgi8WAYzw@mail.gmail.com>
Subject: Re: git bisect and perf
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 7:12 PM, David Ahern <dsahern@gmail.com> wrote:
> On 6/5/12 10:05 AM, Peter Zijlstra wrote:
>>
>> On Tue, 2012-06-05 at 18:00 +0200, Peter Zijlstra wrote:
>>>
>>> On Tue, 2012-06-05 at 09:29 -0600, David Ahern wrote:
>>>>
>>>> I am trying find out when (ie. which commit) the pebs feature
>>>> actually
>>>> started working on a westmere system
>>>
>>>
>>> What do you mean with working? The whole cycles:pp thing is magic and
>>> unrelated to 'regular' PEBS stuff.
>
>
> :p requires PEBS?
>
>
>> .35 would indeed be the version we
>>>
>>> introduced PEBS support and it should actually work.
>
>
> I'm referring to cycles:p
>
> model name      : Intel(R) Xeon(R) CPU           E5620  @ 2.40GHz
That's not as helpful as /proc/cpuinfo. I suspect this is a Westmere
system, isn't it?

> Fedora 14, 2.6.35.14-106.fc14.x86_64 (few perf_event* differences from
> 2.6.35.14).
>
> # perf record -e cycles:p -v -- sleep 1
>
>  Warning:  ... trying to fall back to cpu-clock-ticks
>
> ...
>
> Cycles is supported; it's the :p that is not. perf userspace only recently
> gained the knowledge for discriminating the two. Using perf from
> acme/perf/urgent:
>
> # /tmp/pbuild/perf record -e cycles:p -v -- sleep 1
>
>  Error: sys_perf_event_open() syscall returned with 28 (No space left on
> device).  /bin/dmesg may provide additional information.
>
> I chased this to intel_pebs_constraints() returning &emptyconstraint which
> has a weight of 0 (validate_event -> intel_get_event_constraints ->
> intel_pebs_constraints).
>
>
>
>>>
>>> But if you're looking for the cycles:pp stuff (commit 7639dae0ca1)
>>> that's .38-rc1-ish.
>>
>>
>> So on kernels pre that commit you could still do:
>>
>>   perf record -e r108000c0:pp
>
>
> Indeed that works on the F14 kernel.
>
> David
