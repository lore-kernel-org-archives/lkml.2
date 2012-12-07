Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423218Ab2LGROD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 12:14:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22513 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423124Ab2LGRN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 12:13:58 -0500
X-Authority-Analysis: v=2.0 cv=ZNdVaAHb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=0q0mCv_Vr9gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=lrIq2vSOvhQA:10 a=fUGAhBWXZ_aTiXflodUA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354900436.17101.58.camel@gandalf.local.home>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
From: Steven Rostedt <rostedt@goodmis.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Rabin Vincent <rabin@rab.in>,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Dec 2012 12:13:56 -0500
In-Reply-To: <20121207164530.GX14363@n2100.arm.linux.org.uk>
References: <1354817466.30905.13.camel@linaro1.home>
	 <1354821581.17101.17.camel@gandalf.local.home>
	 <1354872138.3176.15.camel@computer5.home>
	 <1354888985.17101.41.camel@gandalf.local.home>
	 <1354892111.13000.50.camel@linaro1.home>
	 <1354894134.17101.44.camel@gandalf.local.home>
	 <20121207162346.GW14363@n2100.arm.linux.org.uk>
	 <1354898200.17101.50.camel@gandalf.local.home>
	 <20121207164530.GX14363@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 16:45 +0000, Russell King - ARM Linux wrote:
> On Fri, Dec 07, 2012 at 11:36:40AM -0500, Steven Rostedt wrote:

> > But what about the limitations that the function tracer imposes on the
> > code that gets modified by stop_machine()?
> > 
> > 1) the original code is simply a call to mcount
> > 
> > 2) on boot up, that call gets converted into a nop
> > 
> > 3) the code that gets changed will only be converting a nop to a call
> > into the function tracer, and back again.
> > 
> > IOW, it's a very limited subset of the ARM assembly that gets touched.
> > I'm not sure what the op codes are for the above, but I can imagine they
> > don't impose the prefixes as you described.
> > 
> > If that's the case, is it still possible to change to the breakpoint
> > method?
> 
> I have no idea; I've no idea how ftrace works on ARM.

I know how ftrace works on ARM, I'm just asking about the way the
architecture works in general. So to answer my question, you don't need
to know anything about ftrace. I'll make my question more general:

If I have a nop, that is a size of a call (branch and link), which is
near the beginning of a function and not part of any conditional, and I
want to convert it into a call (branch and link), would adding a
breakpoint to it, modifying it to the call, and then removing the
breakpoint be possible? Of course it would require syncing in between
steps, but my question is, if the above is possible on a thumb2 ARM
processor?


>   That's something
> other people use and deal with.  Last (and only) time I used the built-in
> kernel tracing facilities I ended up giving up with it and going back to
> using my sched-clock+record+printk based approaches instead on account
> of the kernels built-in tracing being far too heavy.

Too bad. Which tracing facilities did you use? Function tracing? And
IIRC, ARM originally had only the static tracing, which was extremely
heavy weight. Have you tried tracepoints? Also, have you tried my
favorite way of debugging: trace_printk(). It acts just like printk but
instead of recording to the console, it records into the ftrace buffer
which can be read via the /debug/tracing/trace or dumped to the console
with a sysrq-z.

-- Steve


