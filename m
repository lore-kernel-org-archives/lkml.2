Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab0JSNw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:52:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:46457 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab0JSNw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:52:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,350,1283756400"; 
   d="scan'208";a="337843360"
Message-ID: <4CBDA2B6.9000405@linux.intel.com>
Date: Tue, 19 Oct 2010 06:52:54 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Thomas Renninger <trenn@suse.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Pierre Tardy <tardyp@gmail.com>,
        Jean Pihet <jean.pihet@newoldbits.com>,
        linux-trace-users@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        rjw@sisk.pl, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Steven Rostedt <rostedt@goodmis.org>, Frank Eigler <fche@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: PATCH [0/4] perf: clean-up of power events API
References: <201010062334.46971.trenn@suse.de> <4CB095FA.8060803@linux.intel.com> <20101010121928.GA2688@elte.hu> <201010191331.03080.trenn@suse.de> <20101019114501.GA25371@elte.hu> <1287488841.1994.5.camel@twins> <20101019115200.GC25371@elte.hu> <4CBD9CDD.1010300@linux.intel.com> <20101019135053.GA665@elte.hu>
In-Reply-To: <20101019135053.GA665@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/19/2010 6:50 AM, Ingo Molnar wrote:
> * Arjan van de Ven<arjan@linux.intel.com>  wrote:
>
>>   On 10/19/2010 4:52 AM, Ingo Molnar wrote:
>>> * Peter Zijlstra<peterz@infradead.org>   wrote:
>>>
>>>> On Tue, 2010-10-19 at 13:45 +0200, Ingo Molnar wrote:
>>>>> * Thomas Renninger<trenn@suse.de>   wrote:
>>>>>
>>>>>>> Most definitely. It's no accident that it took such a long time for this issue
>>>>>>> to be raised in the first place. It's a rare occurance -
>>>>>> Do you agree that this occurance happened now and these events should get cleaned
>>>>>> up before ARM and other archs make use of the broken interface?
>>>>>>
>>>>>> If not, discussing this further, is a big waste of time... and Jean would have to
>>>>>> try to adapt his ARM code on the broken ABI...
>>>>> The discussion seems to have died down somewhat. Please re-send to lkml the latest
>>>>> patches you have to remind everyone of the latest state of things - the merge window
>>>>> is getting near.
>>>>>
>>>>> My only compatibility/ABI point is basically that it shouldnt break _existing_
>>>>> tracepoints (and users thereof). If your latest bits meet that then it ought to be a
>>>>> good first step. You are free to (and encouraged to) introduce more complete sets of
>>>>> events.
>>>> Can we deprecate and eventually remove the old ones, or will we be forever obliged
>>>> to carry the old ones too?
>>> We most definitely want to deprecate and remove the old ones - but we want to give
>>> instrumentation software some migration time for that.
>>>
>>> Jean, Arjan, what would be a feasible and practical deprecation period for that? One
>>> kernel cycle?
>> more like a year
>>
>> for some time software needs to support both, especially if popular distros stick
>> to an older kernel like *cough* RHEL6
> Sure, you can support both. But as long as support for the _new_ events is included
> in PowerTop there's no need to keep the duality upstream. Running ancient PowerTop
> on fresh kernels is not common.
>
> An old RHEL kernel will still keep on working as you can keep support for old events
> in PowerTop as long as you wish to.
>
> The new kernel also wont 'overwrite' old events with new definitions in the future,
> so PowerTop will keep working for as long as you want to support older kernels.
>
> Does that sound good?

this does not scale much long term, eg this only works if this is only 
done once, and these points are stable afterwards.
otherwise we get 25 of those different  "workarounds for kernel ABI 
breakage" into all different projects, and it becomes
untestable for all the poor software writers...

