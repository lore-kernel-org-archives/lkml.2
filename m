Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818Ab0GPSWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 14:22:44 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47753 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756991Ab0GPSWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 14:22:43 -0400
Date: Fri, 16 Jul 2010 14:22:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
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
Message-ID: <20100716182240.GA23215@Krystal>
References: <20100714154923.947138065@efficios.com> <20100714155804.252253097@efficios.com> <4C405078.20707@redhat.com> <20100716144927.GA22516@Krystal> <4C408D0C.5050709@redhat.com> <20100716165855.GA3836@Krystal> <4C409CBA.1050709@redhat.com> <4C409F62.6030303@zytor.com> <4C40A1BD.4040507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C40A1BD.4040507@redhat.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:20:31 up 174 days, 20:57,  6 users,  load average: 0.11, 0.09,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity (avi@redhat.com) wrote:
> On 07/16/2010 09:05 PM, H. Peter Anvin wrote:
>>
>>> Module loading can certainly take a vmalloc_sync_all() (though I agree
>>> it's unpleasant).  Anything else?
>>>
>>> Note perf is not modular at this time, but could be made so with
>>> preempt/sched notifiers to hook the context switch.
>>>
>>>      
>> Actually, module loading is already a performance problem; a lot of
>> distros load sometimes hundreds of modules on startup, and it's heavily
>> serialized, so I can see this being desirable to skip.
>>    
>
> There aren't that many processes at this time (or there shouldn't be,  
> don't know how fork-happy udev is at this stage), so the sync should be  
> pretty fast.  In any case, we can sync only modules that contain NMI  
> handlers.

USB hotplug is a use-case happening randomly after the system is well there and
running; I'm afraid this does not fit in your module loading expectations. It
triggers tons of events, many of these actually load modules.

Thanks,

Mathieu

>
>> I really hope noone ever gets the idea of touching user space from an
>> NMI handler, though, and expecting it to work...
>>    
>
> I think the concern here is about an NMI handler's code running in  
> vmalloc space, or is it something else?
>
> -- 
> I have a truly marvellous patch that fixes the bug which this
> signature is too narrow to contain.
>

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
