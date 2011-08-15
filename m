Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab1HONGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 09:06:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51076 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab1HONGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 09:06:06 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=_E3Q4npPQ1wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=yu6Fyl-I2SbDMTBwaBgA:9 a=b0tvHVN0wDhPKIYee44A:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
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
In-Reply-To: <4E47A33E.5020202@hitachi.com>
References: <20110810162222.017387055@goodmis.org>
	 <4E43209D.7090104@hitachi.com>
	 <1313022842.18583.282.camel@gandalf.stny.rr.com>
	 <4E43769C.9000901@hitachi.com>
	 <1313067691.18583.290.camel@gandalf.stny.rr.com>
	 <4E44967C.1090101@hitachi.com>
	 <1313154537.18583.319.camel@gandalf.stny.rr.com>
	 <4E464D6C.9020807@hitachi.com>
	 <1313290684.18583.362.camel@gandalf.stny.rr.com>
	 <4E47A33E.5020202@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 15 Aug 2011 09:06:02 -0400
Message-ID: <1313413562.15704.5.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-08-14 at 19:28 +0900, Masami Hiramatsu wrote:

> > The point I was making is, if I need to get ftrace function tracing
> > being good enough for function graph tracer, then it should work with
> > kprobes without any issues.
> 
> No, I don't think so, because kprobes user may trace a flags register or
> segment registers. However, function graph tracer only needs stack
> register etc. Thus, if ftrace function tracing is good enough for
> kprobes handlers, it is enough for function graph tracer too.

The added code needed for ftrace is not much more. We just need to save
all of pt_regs and that should work (I already save most of it). The
flags can be saved, but things like compare flags will be useless, as
those are used. But compare flags are undefined when calling a function
anyway.


> 
> > If I need to do the work anyway (for
> > function graph tracing) then why not use it directly with kprobes
> > instead of doing more hooks just in the kprobe_trace?
> 
> >From the kprobe-tracer point of view, I don't mind. I just care
> about complexity, and compatibility of kprobe handlers.

Right, so far there's not much changes to the kprobe side. I'll see if I
can make ftrace do all the hard work to get the proper registers. I want
to make as much as possible stay in the generic kprobe code, and not
touch the arch code. But I may still need to do something like
'increment rip' or whatever.

Note, we will need to touch kprobes one way or another. Either we have
kprobes hook to ftrace, or we need to do the nop skip trick, which will
probably be as intrusive in the kprobe code.

Thanks!

-- Steve


