Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab0GPSHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 14:07:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49446 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756846Ab0GPSHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 14:07:06 -0400
Message-ID: <4C409F62.6030303@zytor.com>
Date: Fri, 16 Jul 2010 11:05:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
References: <20100714154923.947138065@efficios.com> <20100714155804.252253097@efficios.com> <4C405078.20707@redhat.com> <20100716144927.GA22516@Krystal> <4C408D0C.5050709@redhat.com> <20100716165855.GA3836@Krystal> <4C409CBA.1050709@redhat.com>
In-Reply-To: <4C409CBA.1050709@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 10:54 AM, Avi Kivity wrote:
> On 07/16/2010 07:58 PM, Mathieu Desnoyers wrote:
>>
>>> Why is that kernel code calling vmalloc_sync_all()?  If it is only NMI
>>> which cannot take vmalloc faults, why bother?  If not, why not?
>>>      
>> Modules come as yet another example of stuff that is loaded in vmalloc'd space
>> and can be accesses from NMI context. That would include oprofile, tracers, and
>> probably others I'm forgetting about.
>>    
> 
> Module loading can certainly take a vmalloc_sync_all() (though I agree 
> it's unpleasant).  Anything else?
> 
> Note perf is not modular at this time, but could be made so with 
> preempt/sched notifiers to hook the context switch.
> 

Actually, module loading is already a performance problem; a lot of
distros load sometimes hundreds of modules on startup, and it's heavily
serialized, so I can see this being desirable to skip.

I really hope noone ever gets the idea of touching user space from an
NMI handler, though, and expecting it to work...

	-hpa

