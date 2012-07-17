Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab2GQDNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 23:13:55 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55684 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2GQDNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 23:13:53 -0400
X-AuditID: b753bd60-9f483ba000000655-b8-5004d86fa95b
X-AuditID: b753bd60-9f483ba000000655-b8-5004d86fa95b
Message-ID: <5004D85C.70704@hitachi.com>
Date: Tue, 17 Jul 2012 12:13:32 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: Re: [RFC][PATCH 2/4 v4] ftrace/x86: Add save_regs for
 i386 function calls
References: <20120711195048.885039013@goodmis.org>   <20120711195745.379060003@goodmis.org> <4FFEC58E.5070202@hitachi.com>  <1342205273.30075.19.camel@gandalf.stny.rr.com>  <5004C917.1060909@hitachi.com> <1342494302.24525.4.camel@gandalf.stny.rr.com>
In-Reply-To: <1342494302.24525.4.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/17 12:05), Steven Rostedt wrote:
> On Tue, 2012-07-17 at 11:08 +0900, Masami Hiramatsu wrote:
> 
>>> I found that regs_get_register() doesn't honor this either. Thus,
>>> kprobes in tracing gets this:
>>>
>>>  # echo 'p:ftrace sys_read+4 s=%sp' > /debug/tracing/kprobe_events
>>>  # echo 1 > /debug/tracing/events/kprobes/enable
>>>  # cat trace
>>>             sshd-1345  [000] d...   489.117168: ftrace: (sys_read+0x4/0x70) s=b7e96768
>>>             sshd-1345  [000] d...   489.117191: ftrace: (sys_read+0x4/0x70) s=b7e96768
>>>              cat-1447  [000] d...   489.117392: ftrace: (sys_read+0x4/0x70) s=5a7
>>>              cat-1447  [001] d...   489.118023: ftrace: (sys_read+0x4/0x70) s=b77ad05f
>>>             less-1448  [000] d...   489.118079: ftrace: (sys_read+0x4/0x70) s=b7762e06
>>>             less-1448  [000] d...   489.118117: ftrace: (sys_read+0x4/0x70) s=b7764970
>>>
>>
>> Yes, that is by design, since I made it so. :)
>> Instead of %sp, kprobe tracer provides $stack special argument
>> for stack address, because "sp" is not always means the stack
>> address on every arch.
> 
> But is that useful? Wouldn't the actual stack pointer be more
> informative?

It is just FYI :). I rather like your "%sp" enhancement
than current meaningless "%sp" on i386...

However, I think "$stack" is more general and informative
for users, thus, at least perf probe uses it for getting
variables from stack.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


