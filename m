Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab1HMKKG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 06:10:06 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42381 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab1HMKKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 06:10:03 -0400
X-AuditID: b753bd60-a2688ba000000655-be-4e464d774b3f
X-AuditID: b753bd60-a2688ba000000655-be-4e464d774b3f
Message-ID: <4E464D6C.9020807@hitachi.com>
Date: Sat, 13 Aug 2011 19:09:48 +0900
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
References: <20110810162222.017387055@goodmis.org>  <4E43209D.7090104@hitachi.com>  <1313022842.18583.282.camel@gandalf.stny.rr.com>  <4E43769C.9000901@hitachi.com>  <1313067691.18583.290.camel@gandalf.stny.rr.com>  <4E44967C.1090101@hitachi.com> <1313154537.18583.319.camel@gandalf.stny.rr.com>
In-Reply-To: <1313154537.18583.319.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/08/12 22:08), Steven Rostedt wrote:
> On Fri, 2011-08-12 at 11:57 +0900, Masami Hiramatsu wrote:
>
>> I don't think it won't work. It can work but on a long way.
>> Could you tell me your "bigger ideas"? Perhaps, we are on the different
>> way but aim to same goal.
>
> Part of the bigger ideas is to have things like function graph tracing
> use this, as it will simplify the entry.S code. There's other things
> that may come out of this too.

Hmm, I think that the current function graph tracing implementation
is more scalable than kretprobes, because kretprobe requires
spinlock on every hit. Moreover, you can't probe NMI handler with
kprobe, and kprobes on irq-handler are also possible to fail
because of recursive-call.
So I don't recommend using kretprobe for function-graph tracer :-(

However, even though, some parts of code can be shared among them
and it will simplify their implementations.

>>>> The cons:
>>>> - Native kprobes users will be disappointed... anyway, they just need to
>>>>   move their probes to the next instruction (usually addr+=5 is OK).
>>>
>>> I've been told that doing the addr+=5 (which is also arch specific) can
>>> break things for other tools.
>>
>> As I told in previous mail, I think kprobes can do that transparently.
>
> Yeah, it could, but I'm afraid this may need to be done differently for
> every arch. If I'm working on getting this code to work for ftrace,
> which will require modifying ever arch as well, kprobes can get the
> changes for free.

I guess that anyway it should be done (at least, carefully checked)
for every arch.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
