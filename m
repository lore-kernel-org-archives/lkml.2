Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab1HNC6N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 22:58:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44987 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab1HNC6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 22:58:09 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=_E3Q4npPQ1wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=peRQtgUrQhlEjBqzj-8A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/5][RFC] kprobes/ftrace: Have kprobes use ftrace on
 ftrace nops
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jason Baron <jbaron@redhat.com>, yrl.pp-manager.tt@hitachi.com,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
In-Reply-To: <4E464D6C.9020807@hitachi.com>
References: <20110810162222.017387055@goodmis.org>
	 <4E43209D.7090104@hitachi.com>
	 <1313022842.18583.282.camel@gandalf.stny.rr.com>
	 <4E43769C.9000901@hitachi.com>
	 <1313067691.18583.290.camel@gandalf.stny.rr.com>
	 <4E44967C.1090101@hitachi.com>
	 <1313154537.18583.319.camel@gandalf.stny.rr.com>
	 <4E464D6C.9020807@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 13 Aug 2011 22:58:04 -0400
Message-ID: <1313290684.18583.362.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-13 at 19:09 +0900, Masami Hiramatsu wrote:
> (2011/08/12 22:08), Steven Rostedt wrote:
> > On Fri, 2011-08-12 at 11:57 +0900, Masami Hiramatsu wrote:
> >
> >> I don't think it won't work. It can work but on a long way.
> >> Could you tell me your "bigger ideas"? Perhaps, we are on the different
> >> way but aim to same goal.
> >
> > Part of the bigger ideas is to have things like function graph tracing
> > use this, as it will simplify the entry.S code. There's other things
> > that may come out of this too.
> 
> Hmm, I think that the current function graph tracing implementation
> is more scalable than kretprobes, because kretprobe requires
> spinlock on every hit. Moreover, you can't probe NMI handler with
> kprobe, and kprobes on irq-handler are also possible to fail
> because of recursive-call.
> So I don't recommend using kretprobe for function-graph tracer :-(

Sorry for the confusion. My idea is not to use kretprobe with function
graph tracer, but to use the ftrace hooks with the pt_regs and friends
for function graph tracer instead of what it does today, which is to add
function graph code directly into entry.S.

The point I was making is, if I need to get ftrace function tracing
being good enough for function graph tracer, then it should work with
kprobes without any issues. If I need to do the work anyway (for
function graph tracing) then why not use it directly with kprobes
instead of doing more hooks just in the kprobe_trace?

-- Steve


