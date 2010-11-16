Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880Ab0KPWHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 17:07:14 -0500
Received: from mga14.intel.com ([143.182.124.37]:31502 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932758Ab0KPWHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 17:07:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,207,1288594800"; 
   d="scan'208";a="349619482"
Message-ID: <4CE30086.2070806@linux.intel.com>
Date: Tue, 16 Nov 2010 14:07:02 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ANNOUNCE] New utility: 'trace'
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6> <4CE2F747.4060406@linux.intel.com> <20101116215940.GA13912@elte.hu>
In-Reply-To: <20101116215940.GA13912@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2010 01:59 PM, Ingo Molnar wrote:
>
> * Darren Hart<dvhart@linux.intel.com>  wrote:
>
>> On 11/16/2010 01:04 PM, Thomas Gleixner wrote:
>>> We are pleased to announce a new tracing tool called 'trace'.
>>>
>>
>> Hi Thomas, Ingo - Congrats and Thanks!
>
> You are welcome :)
>
>>> At this point we'd like to ask for feedback from other users of tracing tools,
>>> which workflow components would you like to see in addition to what the 'trace'
>>> tool is offering?
>>>
>>> Comments, bug reports, suggestions welcome,
>>
>> The first thing that comes to mind is trace_marker:
>>
>>    echo "Test point A">  /sys/kernel/debug/tracing/trace_marker
>>
>> I've found this sort of markup to be useful using ftrace (with C equivalents
>> embedded in the test case). Is this supported?
>
> Yes, LatencyTop uses something similar IIRC, via a prctl() hack: it uses
> prctl(PR_SET_NAME) to inject up to 16 characters into the comm - and then every perf
> event gets that comm. You can utilize that straight away if you need a marker
> solution right now.

OK, definitely much more limited than trace_marker.

>
> A cleaner, more generic approach would be a more free-form ASCII event facility for
> this: a generic 'user-space triggered event' with injection capabilities.
>
> To inject it, we could put that into a prctl() as well, for easy, single-syscall
> access from C. We already have two perf prctls: PR_TASK_PERF_EVENTS_DISABLE,
> PR_TASK_PERF_EVENTS_ENABLE - and this would be a third one: PR_TASK_PERF_USER_EVENT.
>
> This would, like the existing perf_event_task_enable()/disable() methods, loop
> through current events and inject a string into matching user events.
>
> Ideally i'd like to see basically user-space access to trace_printk(), and proper

Right, this would be ideal.

> integration into /debug/tracing/events/ enumeration and availability - not a
> ftrace-specific and admin-only hack like /sys/kernel/debug/tracing/trace_marker is
> today.
>
> Would you be interested in helping out with (and testing) such a more generic
> approach?

I would. I need some time to familiarize myself with perf first (I've 
been a relatively happy ftrace/trace-cmd user for the last couple years).

-- 
Darren Hart
Yocto Linux Kernel
