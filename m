Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab1BQQHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 11:07:36 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:60504 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1BQQHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 11:07:34 -0500
X-AuditID: b753bd60-a0effba0000066fd-96-4d5d47c3cbf8
X-AuditID: b753bd60-a0effba0000066fd-96-4d5d47c3cbf8
Message-ID: <4D5D47C0.9020206@hitachi.com>
Date: Fri, 18 Feb 2011 01:07:28 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [RFC][PATCH 0/4] ftrace: Use -mfentry when supported (this is
 for x86_64 right now)
References: <20110209200249.111932716@goodmis.org>	 <4D5D1672.6070206@hitachi.com>	 <1297948703.23343.907.camel@gandalf.stny.rr.com>	 <4D5D4013.4070602@hitachi.com> <1297957591.23343.921.camel@gandalf.stny.rr.com>
In-Reply-To: <1297957591.23343.921.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/02/18 0:46), Steven Rostedt wrote:
> On Fri, 2011-02-18 at 00:34 +0900, Masami Hiramatsu wrote:
>> (2011/02/17 22:18), Steven Rostedt wrote:
>>> On Thu, 2011-02-17 at 21:37 +0900, Masami Hiramatsu wrote:
>>>
>>>> Oops! with this change, current kprobes might not be able to probe
>>>> the entry of functions, because that is always reserved by ftrace!
>>>> I think we need to have some new interface for replacing each other
>>>> safely...
>>>
>>> Good point. I suspect that this wont be ready till .40 anyway. When I
>>> get a chance to work more an this, I'll also include patches where if
>>> -mfentry is activated kprobes will just hook to the mcount caller
>>> instead. Or ftrace itself :)
>>
>> Ah, that's a good idea! :) it could be done without -mfentry too.
>> But is that possible to modify just one mcount entry? I also worry
>> about the latency of enabling/disabling one entry.
> 
> I would have it go through the ftrace function tracing facility, which
> would handle which entry to enable/disable. It still does stopmachine.
> Is that an issue to enable/disable kprobes? The "fast" enable/disable
> could be done by the called function to just ignore the call.

I just thought that frequent stop-machine is not so good from the user's
POV. I agree that disabled probe ignoring the call is enough.
Maybe, it could be done with the similar mechanism of jump optimization.

> Also note, if there's other callbacks that are attached to the function
> being traced, no stop machine is enabled. The callbacks are just a list
> and as long as a function has an associated callback, no code
> modification needs to be done to add or remove other callbacks.

Right :)

>> BTW, without dynamic ftrace (no code modifying), I think we don't
>> need to reserve mcount code, because no one modifies it.
> 
> Correct. And even today, you can remove any kprobe code that checks for
> mcount without dynamic ftrace enabled. But I'm not sure if anyone
> enables the function tracer without dynamic ftrace, except for debugging
> in archs that do not support dynamic ftrace. As the overhead of this is
> quite high even when function tracer is disabled.

Indeed. Maybe that is only for that exception case, because it allows
us to put probe even on the mcount call.

Thank you,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
