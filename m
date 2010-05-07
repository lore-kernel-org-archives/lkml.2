Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab0EGPPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:15:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44394 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab0EGPPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:15:42 -0400
X-Authority-Analysis: v=1.1 cv=OMZqYO3L41gFG4eI735GctFZkIqa2t9YKv4cWfI71LE= c=1 sm=0 a=8LHCb4_oiB0A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=dt4kaHklVt5s5FRngd4A:9 a=h6iFTf9miLASv7JxbvgA:7 a=fNvGzAgk7WO4kCffDQYTiCk7EuUA:4 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 3/9 - v2][RFC] tracing: Remove per event trace
 registering
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100507145438.GB29573@Krystal>
References: <20100504034045.085822814@goodmis.org>
	 <20100504034202.282030521@goodmis.org> <20100507042025.GC8069@nowhere>
	 <20100507145438.GB29573@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 07 May 2010 11:12:08 -0400
Message-ID: <1273245128.22438.160.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 10:54 -0400, Mathieu Desnoyers wrote:
> * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > On Mon, May 03, 2010 at 11:40:48PM -0400, Steven Rostedt wrote:
> > > From: Steven Rostedt <srostedt@redhat.com>
> > > 
> > > This patch removes the register functions of TRACE_EVENT() to enable
> > > and disable tracepoints. The registering of a event is now down
> > > directly in the trace_events.c file. The tracepoint_probe_register()
> > > is now called directly.
> > > 
> > > The prototypes are no longer type checked, but this should not be
> > > an issue since the tracepoints are created automatically by the
> > > macros. If a prototype is incorrect in the TRACE_EVENT() macro, then
> > > other macros will catch it.
> > 
> > 
> > 
> > Agreed. Typechecking matters for human code but not in this context.
> > Considering that the tracepoint and the probe are created by the same
> > CPP code, bugs will be tracked down quickly and located to a single
> > place.
> 
> So it seems that I am the only one asking for extra type-checking and
> caring about problems that can appear subtily on architectures where the
> number of caller/callee arguments must match. And also the only one
> considering that passing more arguments to a callback that does not
> expect all of them might be a problem on some architectures.
> 
> Am I the only one thinking there is something fishy there ? I might be
> entirely over-paranoid, but this approach has rarely failed me in the
> past.

I think you are the only one not realizing that the caller and callee
are created automatically with the same data. There is no human
intervention here.

You are asking to add a check that I can not see helping. The only way
to add a check, is to use the automated process to check the automation.
If the automated process fails, it is very likely the check will also be
broken and will not catch the bug either.

-- Steve


