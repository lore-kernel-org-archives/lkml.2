Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab1HKAeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 20:34:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49222 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1HKAeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 20:34:06 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=_E3Q4npPQ1wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=yZ5e0GRByNthoOTxgGEA:9 a=Svij3tE1G1tsiyBpVykA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
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
        Jason Baron <jbaron@redhat.com>, yrl.pp-manager.tt@hitachi.com
In-Reply-To: <4E43209D.7090104@hitachi.com>
References: <20110810162222.017387055@goodmis.org>
	 <4E43209D.7090104@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Aug 2011 20:34:02 -0400
Message-ID: <1313022842.18583.282.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 09:21 +0900, Masami Hiramatsu wrote:
> Hi Steven,
> 
> Thanks for this nice feature!
> 
> (2011/08/11 1:22), Steven Rostedt wrote:
> > Hi All,
> >
> > I started working on adding the -mfentry switch to ftrace, which
> > allows us to remove the frame pointers requirement from function tracing
> > as well as makes mcount (fentry) work just better.
> >
> > But when I did this in another branch, I noticed that I broke kprobes
> > in its most common usage. The attaching a probe at the beginning of
> > a function to use get to its parameters.
> >
> > So I started this branch. This branch is to have kprobes use ftrace
> > directly when a probe is attached to a ftrace nop. Currently, kprobes
> > will just error when that happens. With this patch set, it will hook
> > into the ftrace infrastructure and use ftrace instead. This is more
> > like an optimized probe as no breakpoints need to be set. A call to
> > the function is done directly via the mcount trampoline. If ftrace
> > pt_regs is implemented for an arch, kprobes gets this feature for free.
> 
> I agreed this idea, this looks good to me too :)
> With -fentry, this can improve dynamic trace events very much.
> 
> BTW (OT), it seems that current kprobe data structure becomes a bit
> fat. Maybe what we need is just a "holder of hooking handler" as
> what ftrace provides, not a full storage data structure of copied
> instrucutions. Perhaps, we'd better diet the kprobe structure for
> transparency of hooking infrastructure.

Sure, I can make the ftrace_ops field in kprobes dynamically allocated
instead. That shouldn't be an issue.

> 
> > The first patch is just a clean up that I need to push out to get rid
> > of the annoying compile warning about initialized variables that
> > gcc can't tell have been initialized.
> >
> > The next two patches have ftrace pass both the ftrace_ops structure
> > and the pt_regs to the callback function that is registered with ftrace.
> >
> > The last two patches have kprobes interact with ftrace and use the
> > ftrace infrastructure instead.
> >
> > I only did this for x86_64, and will do it for x86_32 and PPC64 if everyone
> > agrees with this approach. Then I could find people to do it for other
> > archs :)
> 
> OK, I'll review this soon!

Thanks!

-- Steve


