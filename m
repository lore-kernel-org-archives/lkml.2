Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab1HNK2W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 06:28:22 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:38628 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab1HNK2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 06:28:19 -0400
X-AuditID: b753bd60-a3089ba000000655-4d-4e47a3405980
X-AuditID: b753bd60-a3089ba000000655-4d-4e47a3405980
Message-ID: <4E47A33E.5020202@hitachi.com>
Date: Sun, 14 Aug 2011 19:28:14 +0900
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
References: <20110810162222.017387055@goodmis.org>  <4E43209D.7090104@hitachi.com>  <1313022842.18583.282.camel@gandalf.stny.rr.com>  <4E43769C.9000901@hitachi.com>  <1313067691.18583.290.camel@gandalf.stny.rr.com>  <4E44967C.1090101@hitachi.com>  <1313154537.18583.319.camel@gandalf.stny.rr.com>  <4E464D6C.9020807@hitachi.com> <1313290684.18583.362.camel@gandalf.stny.rr.com>
In-Reply-To: <1313290684.18583.362.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/08/14 11:58), Steven Rostedt wrote:
> On Sat, 2011-08-13 at 19:09 +0900, Masami Hiramatsu wrote:
>> (2011/08/12 22:08), Steven Rostedt wrote:
>>> On Fri, 2011-08-12 at 11:57 +0900, Masami Hiramatsu wrote:
>>>
>>>> I don't think it won't work. It can work but on a long way.
>>>> Could you tell me your "bigger ideas"? Perhaps, we are on the different
>>>> way but aim to same goal.
>>>
>>> Part of the bigger ideas is to have things like function graph tracing
>>> use this, as it will simplify the entry.S code. There's other things
>>> that may come out of this too.
>>
>> Hmm, I think that the current function graph tracing implementation
>> is more scalable than kretprobes, because kretprobe requires
>> spinlock on every hit. Moreover, you can't probe NMI handler with
>> kprobe, and kprobes on irq-handler are also possible to fail
>> because of recursive-call.
>> So I don't recommend using kretprobe for function-graph tracer :-(
>
> Sorry for the confusion. My idea is not to use kretprobe with function
> graph tracer, but to use the ftrace hooks with the pt_regs and friends
> for function graph tracer instead of what it does today, which is to add
> function graph code directly into entry.S.

Ah, OK.

> The point I was making is, if I need to get ftrace function tracing
> being good enough for function graph tracer, then it should work with
> kprobes without any issues.

No, I don't think so, because kprobes user may trace a flags register or
segment registers. However, function graph tracer only needs stack
register etc. Thus, if ftrace function tracing is good enough for
kprobes handlers, it is enough for function graph tracer too.

> If I need to do the work anyway (for
> function graph tracing) then why not use it directly with kprobes
> instead of doing more hooks just in the kprobe_trace?

>From the kprobe-tracer point of view, I don't mind. I just care
about complexity, and compatibility of kprobe handlers.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
