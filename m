Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab2EQFIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 01:08:51 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60407 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab2EQFIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 01:08:50 -0400
Message-ID: <4FB4885F.4000002@linaro.org>
Date: Thu, 17 May 2012 09:10:55 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: Re: Perf record format portability
References: <4FB275EB.5050904@linaro.org>  <20120515155146.GB7864@infradead.org> <4FB38677.8070601@linaro.org>  <20120516145927.GC7864@infradead.org> <1337187503.6724.50.camel@gandalf.stny.rr.com>
In-Reply-To: <1337187503.6724.50.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 08:58 PM, Steven Rostedt wrote:

> On Wed, 2012-05-16 at 11:59 -0300, Arnaldo Carvalho de Melo wrote:
>
>> Steve,
>>
>> 	Was the kernel trace events infrastructure designed with that in
>> mind? I.e. cross analysis? I must be missing something here, still
>> ENOCOFFEE :-\
>
> Yes, the libparsevents library was design for this from day one. That's
> why trace-cmd data file can be run on an ARM and read on x86, or PPC, or
> whatever. I did all my development testing against 32bit, 64bit and big
> and little endian. This was the case from the beginning.

I didn't face with big/little conversion issues, most probably both x86 and
my ARM board are of the same (little) endian :-).

But the original question was about event IDs. For example,
/sys/kernel/debug/tracing/events/sched/sched_switch/id is 55 on my ARM board
and 279 on my PC host, so 'perf report' displays "unknown:unknown" instead
of expected "sched:sched_switch" when attempting to do some cross-analysis.
I suppose that original event IDs should be preserved, either within perf.data
or by providing the copy of original /sys/kernel/debug/tracing/*, much like
it's done with --kallsyms to resolve kernel symbols.

Dmitry
