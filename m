Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934740Ab0KQMdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:33:17 -0500
Received: from freeflow.nu ([178.79.134.28]:54953 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933291Ab0KQMdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:33:16 -0500
Message-ID: <4CE3CB8A.8060608@kernel.org>
Date: Wed, 17 Nov 2010 14:33:14 +0200
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch] trace: Add user-space event tracing/injection
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6> <4CE38C53.8090606@kernel.org> <20101117120740.GA24972@elte.hu> <4CE3C7C2.7000200@kernel.org> <20101117123055.GA27063@elte.hu>
In-Reply-To: <20101117123055.GA27063@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/10 2:30 PM, Ingo Molnar wrote:
> What does the duration in milliseconds mean there? For things like
>> GC and JIT, I want something like:
>>
>> void gc(void)
>> {
>>          prctl(PR_TASK_PERF_USER_TRACE_START, ...)
>>
>>          collect();
>>
>>          prctl(PR_TASK_PERF_USER_TRACE_END, ...)
>> }
>>
>> So that it's clear from the tracing output that the VM was busy
>> doing GC for n milliseconds. Barring background JIT'ing and
>> pauseless GC, I'd also be interested in showing how much time the VM
>> was actually _blocking_ the running application (which can happen
>> with signals too, btw, for things like accessing data that's lazily
>> initialized).
> We can add two events: user_event_entry/user_event_exit - or we could use the string
> to differentiate, and start it with:
>
>    "entry: ..."
>    "exit: ..."
>
> And then the event timestamps (which are absolute and are available) could be used
> to calculate the duration of this period.
>
> 'trace' could even be taught to treat such entry:/exit: strings in a special way, so
> that you dont have to write Jato specific trace decoding bits?

Yes, makes sense. I like the API so lets convince others that it's 
important enough to be merged. :-)

             Pekka
