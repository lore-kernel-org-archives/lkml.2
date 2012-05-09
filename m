Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab2EIFz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:55:27 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:60748 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab2EIFzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:55:25 -0400
X-AuditID: b753bd60-9658fba000007b1b-a1-4faa06ca0c29
X-AuditID: b753bd60-9658fba000007b1b-a1-4faa06ca0c29
Message-ID: <4FAA06C8.6050700@hitachi.com>
Date: Wed, 09 May 2012 14:55:20 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH v20] tracing: Fix kconfig warning due to a typo
References: <20120508111126.21004.38285.sendpatchset@srdronam.in.ibm.com>  <1336476588.16236.20.camel@twins>  <1336481312.14207.164.camel@gandalf.stny.rr.com> <1336483073.16236.37.camel@twins>
In-Reply-To: <1336483073.16236.37.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/08 22:17), Peter Zijlstra wrote:
> On Tue, 2012-05-08 at 08:48 -0400, Steven Rostedt wrote:
>> On Tue, 2012-05-08 at 13:29 +0200, Peter Zijlstra wrote:
>>> On Tue, 2012-05-08 at 16:41 +0530, Srikar Dronamraju wrote:
>>>> +    p:uprobes/p_zsh_0x46420 /bin/zsh:0x00046420 arg1=%ip arg2=%ax
>>>
>>> can you also do things like:
>>>
>>>  p:uprobes/ponies /bin/zsh:foo arg1=bar
>>>
>>> when bar is either a function argument of foo (or an otherwise live
>>> variable at the probe point)?
>>>
>>> Only sampling register content is somewhat limiting, you might want to
>>> have %ax[5] + 24 for example, or a pure memory deref -- and the dwarves
>>> know where it all lives.
>>
>> But this is for the raw entry into the kernel. The kernel wont know the
>> variable name. Although perf could do that parsing for you.
> 
> Ah, ok. Yes I meant for perf to do this, I overlooked it was the kernel
> input.

Right, perf-probe can provide that interface, if we can find debuginfo.

>> That said, the %ax[5] + 24 could be done in kernel, and that would be
>> useful. Does kprobes handle that?
> 
> In general something like: %mr + %c * %cr + %cr would be most useful I
> think (%m - memory address, %r - register, %c - constant). Although
> maybe it needs segment registers too, dunno. Also no idea if this covers
> the addressing scope of all archs.

Would you mean SIB + displacement addressing? :)

Currently, kprobe tracer just accept [[%mr + %c] + %c] ...,
because it's a basic functionality for accessing members of
a data structure.

I see that this is not enough for the person who want to debug
kernel in machine code level.
Now I'm considering that it may be better to re-implement
internal argument parser/fetcher for supporting those kind
of memory addressing.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
