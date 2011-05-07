Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab1EGR7n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 13:59:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:41194 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab1EGR7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 13:59:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,331,1301900400"; 
   d="scan'208";a="743775253"
Message-ID: <4DC58888.9030402@linux.intel.com>
Date: Sat, 07 May 2011 10:59:36 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
References: <4DC45537.6070609@linux.intel.com>	 <1304713252.25414.2532.camel@gandalf.stny.rr.com>	 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>	 <20110507065803.GA23414@elte.hu>	 <1304765110.25414.2564.camel@gandalf.stny.rr.com>	 <20110507144402.GC2859@elte.hu> <1304788829.11129.57.camel@frodo>
In-Reply-To: <1304788829.11129.57.camel@frodo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/2011 10:20 AM, Steven Rostedt wrote:
> On Sat, 2011-05-07 at 16:44 +0200, Ingo Molnar wrote:
>> * Steven Rostedt<rostedt@goodmis.org>  wrote:
>>
>>> 2) we separate perf from ftrace and keep the "stable" ABI for perf, and let
>>> ftrace advance into a more efficient tracer.
>> The thing is, ftrace is still largely separated from perf, and this is why this
>> regression came in: a random tracing 'cleanup' churn was done to 'tracing'
>> which broke PowerTop.
>>
>> Look at the commit itself:
>>
>>    e6e1e2593592: tracing: Remove lock_depth from event entry
>>
>> Clearly you didnt even *realize* that there's a whole tooling world behind this
>> mechanism ...
> Note, I discussed this change with Frederic and he totally agreed with
> me on removing it. In fact, we are in discussions about getting rid of
> pid, preempt-count, and irq flags as well. But according to your logic,
> that is a no go. I guess Frederic also does not *realize* there's a
> whole tooling world behind this mechanism too.

btw if you remove some of these, how is userland supposed to find out if 
an event happened in irq context?


