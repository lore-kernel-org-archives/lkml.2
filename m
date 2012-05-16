Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030221Ab2EPKs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 06:48:27 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:55660 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966987Ab2EPKsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 06:48:25 -0400
Message-ID: <4FB38677.8070601@linaro.org>
Date: Wed, 16 May 2012 14:50:31 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: Perf record format portability
References: <4FB275EB.5050904@linaro.org> <20120515155146.GB7864@infradead.org>
In-Reply-To: <20120515155146.GB7864@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 07:51 PM, Arnaldo Carvalho de Melo wrote:
> Em Tue, May 15, 2012 at 07:27:39PM +0400, Dmitry Antipov escreveu:
>> Hello,
>>
>> are there any thoughts on how much of the perf.data is portable and how much it should be?
>> I'm interesting in recording scheduler activity on one machine and then replaying on
>> another. As I can see, replaying x86 perf.data on ARM doesn't work. At least, should it
>> work with a small subset of recorded events (for example, sched:sched_switch,
>> sched:sched_process_exit, sched:sched_process_fork, sched:sched_wakeup
>> and sched:sched_migrate_task) on the same architecture?
>
> Endianness issues? ARM EB? There are some patches by Jiri Olsa that may
> help you if that is the case.

Thanks, will look at.

> It should be portable, are you using 'perf archive' too?

It doesn't work with cryptic messages like:

tar: .build-id/17/d6ca02b2c31df54bf62a4142c47e3c99a9eedf: Cannot stat: No such file or directory

creating empty archive.

> What exactly is the error experienced?

Now I'm facing the simple problem with event IDs, which may be different from machine to
machine. For example, /sys/kernel/debug/tracing/events/sched/sched_switch/id is 55 on my ARM
board and 279 on my PC host, so 'perf report' displays all event names like "unknown:unknown",
even with --kallsyms=XXX where XXX is 'cat /proc/kallsyms > XXX' from PC host.

Dmitry

