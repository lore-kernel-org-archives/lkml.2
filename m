Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab1HQMNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 08:13:00 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54711 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab1HQMM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 08:12:59 -0400
X-AuditID: b753bd60-a3c7dba0000050a4-5e-4e4bb048e6fc
X-AuditID: b753bd60-a3c7dba0000050a4-5e-4e4bb048e6fc
Message-ID: <4E4BB041.1050004@hitachi.com>
Date: Wed, 17 Aug 2011 21:12:49 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jason Baron <jbaron@redhat.com>, yrl.pp-manager.tt@hitachi.com,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH 0/5][RFC] kprobes/ftrace: Have kprobes use ftrace on ftrace
 nops
References: <20110810162222.017387055@goodmis.org>  <4E43209D.7090104@hitachi.com>  <1313022842.18583.282.camel@gandalf.stny.rr.com>  <4E43769C.9000901@hitachi.com>  <1313067691.18583.290.camel@gandalf.stny.rr.com>  <4E44967C.1090101@hitachi.com>  <1313154537.18583.319.camel@gandalf.stny.rr.com>  <4E464D6C.9020807@hitachi.com>  <1313290684.18583.362.camel@gandalf.stny.rr.com>  <4E47A33E.5020202@hitachi.com> <1313413562.15704.5.camel@gandalf.stny.rr.com>
In-Reply-To: <1313413562.15704.5.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/08/15 22:06), Steven Rostedt wrote:
> On Sun, 2011-08-14 at 19:28 +0900, Masami Hiramatsu wrote:
>
>>> The point I was making is, if I need to get ftrace function tracing
>>> being good enough for function graph tracer, then it should work with
>>> kprobes without any issues.
>>
>> No, I don't think so, because kprobes user may trace a flags register or
>> segment registers. However, function graph tracer only needs stack
>> register etc. Thus, if ftrace function tracing is good enough for
>> kprobes handlers, it is enough for function graph tracer too.
>
> The added code needed for ftrace is not much more. We just need to save
> all of pt_regs and that should work (I already save most of it). The
> flags can be saved, but things like compare flags will be useless, as
> those are used. But compare flags are undefined when calling a function
> anyway.

Agreed. I think users may just want to see other status flags.

>>> If I need to do the work anyway (for
>>> function graph tracing) then why not use it directly with kprobes
>>> instead of doing more hooks just in the kprobe_trace?
>>
>> >From the kprobe-tracer point of view, I don't mind. I just care
>> about complexity, and compatibility of kprobe handlers.
>
> Right, so far there's not much changes to the kprobe side. I'll see if I
> can make ftrace do all the hard work to get the proper registers. I want
> to make as much as possible stay in the generic kprobe code, and not
> touch the arch code. But I may still need to do something like
> 'increment rip' or whatever.

kprobes arch side code is not so complex, it has less states.
Generic kprobes code has much more states to support module
probes, module init, aggregated probes, and so on. So it is OK for me
to touch the arch code :).

> Note, we will need to touch kprobes one way or another. Either we have
> kprobes hook to ftrace, or we need to do the nop skip trick, which will
> probably be as intrusive in the kprobe code.

I see. OK, I'm now looking forward to your work ;)

Thank you!


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
