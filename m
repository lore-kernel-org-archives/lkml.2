Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab1HLNOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:14:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50605 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab1HLNOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:14:19 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=pcmhLELtPZwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=PVx-zxsCqT3VcSFylhAA:9 a=L6pMMbTMiRBcWQA4JlMA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 5/5][RFC] kprobes: Use ftrace hooks when probing ftrace
 nops
From: Steven Rostedt <rostedt@goodmis.org>
To: ananth@in.ibm.com
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jason Baron <jbaron@redhat.com>, yrl.pp-manager.tt@hitachi.com
In-Reply-To: <20110812054606.GA6975@in.ibm.com>
References: <20110810162222.017387055@goodmis.org>
	 <20110810163039.000615163@goodmis.org> <4E4387A7.7040200@hitachi.com>
	 <1313068956.18583.309.camel@gandalf.stny.rr.com>
	 <20110812054606.GA6975@in.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Aug 2011 09:14:17 -0400
Message-ID: <1313154857.18583.320.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 11:16 +0530, Ananth N Mavinakayanahalli wrote:
> On Thu, Aug 11, 2011 at 09:22:36AM -0400, Steven Rostedt wrote:
> > On Thu, 2011-08-11 at 16:41 +0900, Masami Hiramatsu wrote:
> 
> ...
> 
> > > > +#ifdef CONFIG_FUNCTION_TRACER
> > > > +static notrace void
> > > > +kprobe_ftrace_callback(unsigned long ip, unsigned long parent_ip,
> > > > +		       struct ftrace_ops *op, struct pt_regs *pt_regs)
> > > > +{
> > > > +	struct kprobe *p = container_of(op, struct kprobe, fops);
> > > > +
> > > 
> > > Here, we need to set up kprobe_ctlblk and some of pt_regs members,
> > > ip, cs and orig_ax as optimized_callback()@arch/x86/kernel/kprobes.c
> > > does.
> > 
> > I'm curious to what this is used for? It doesn't seem to be needed for
> > the generic kprobes. Because we know the probe was on a nop, there's no
> > need to simulate the operation. IOW, there's no need for singlestep() or
> > other gdb like operations.
> 
> It is needed to handle recursion, for instance. If in the rare case a
> kprobe handler calls another routine which also has a kprobe installed
> (and so on), we just bypass calling the 2nd kprobe's handlers. To do
> this and to set back the original kprobe context, we track the kprobe
> state in the per_cpu kprobe_ctlblk.

OK, so this looks a bit more involved. I'll look into this as well. This
is still all under RFC now anyway. But I think it is doable.

Thanks!

-- Steve


