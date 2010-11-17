Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935228Ab0KQS0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 13:26:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:37363 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933148Ab0KQS0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 13:26:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,212,1288594800"; 
   d="scan'208";a="574795698"
Message-ID: <4CE4077F.1090303@linux.intel.com>
Date: Wed, 17 Nov 2010 08:49:03 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ANNOUNCE] New utility: 'trace'
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>	 <4CE2F747.4060406@linux.intel.com> <20101116221726.GB26243@nowhere>	 <20101117083020.GA11336@elte.hu> <1289993750.2109.718.camel@laptop>	 <20101117125344.GC5464@nowhere> <1289998957.2109.751.camel@laptop>
In-Reply-To: <1289998957.2109.751.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 05:02 AM, Peter Zijlstra wrote:
> On Wed, 2010-11-17 at 13:53 +0100, Frederic Weisbecker wrote:
>> On Wed, Nov 17, 2010 at 12:35:50PM +0100, Peter Zijlstra wrote:
>>> On Wed, 2010-11-17 at 09:30 +0100, Ingo Molnar wrote:
>>>>> For example I'm currently working with dozens of trace_printk() and I would be
>>>>> very happy to turn some of them off half of the time.
>>>>
>>>> I guess we could try such a patch. If you send a prototype i'd be interested in
>>>> testing it out.
>>>
>>> I don't see the point, the kernel shouldn't contain any trace_printk()s
>>> to begin with..
>>
>>
>> It's oriented toward developers. Those who use dozens of tracepoints in
>> their tree because they are debugging something or developing a new feature,
>> they might to deactivate/reactivate some of these independant points.
>>
>> This can also apply to dynamic_printk of course.
>>
>> Well, the very first and main point is to standardize trace_printk into
>> a trace event so that it gets usable by perf tools. I have been asked many
>> times "how to use trace_printk() with perf?".
>
> Thing is, since its these dev who add the trace_printk()s to begin with,
> I don't see the point in splitting them out, if you didn't want them why
> did you add them to begin with?!

What I understood from Frederic's email was that during a debug session 
it is sometimes helpful to be able to enable and disable the 
trace_printk's. This makes sense as it reduces the number of kernel 
build/reboot cycles. However, I would think most of that could be 
accomplished with some judicious message tagging and post-processing to 
filter out the unwanted trace_printk's. The only exception might be when 
the trace_printk's add enough overhead to mask a timing related bug. In 
this case, I'd probably be tempted to remove the stubs anyway.

-- 
Darren Hart
Yocto Linux Kernel
