Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab0EGPcC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:32:02 -0400
Received: from mail.openrapids.net ([64.15.138.104]:56769 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755444Ab0EGPcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:32:00 -0400
Date: Fri, 7 May 2010 11:31:59 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/9 - v2][RFC] tracing: Remove per event trace
	registering
Message-ID: <20100507153158.GB15267@Krystal>
References: <20100504034045.085822814@goodmis.org> <20100504034202.282030521@goodmis.org> <20100507042025.GC8069@nowhere> <20100507145438.GB29573@Krystal> <1273245128.22438.160.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273245128.22438.160.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:31:39 up 104 days, 18:08,  7 users,  load average: 0.15, 0.15,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Fri, 2010-05-07 at 10:54 -0400, Mathieu Desnoyers wrote:
> > * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > > On Mon, May 03, 2010 at 11:40:48PM -0400, Steven Rostedt wrote:
> > > > From: Steven Rostedt <srostedt@redhat.com>
> > > > 
> > > > This patch removes the register functions of TRACE_EVENT() to enable
> > > > and disable tracepoints. The registering of a event is now down
> > > > directly in the trace_events.c file. The tracepoint_probe_register()
> > > > is now called directly.
> > > > 
> > > > The prototypes are no longer type checked, but this should not be
> > > > an issue since the tracepoints are created automatically by the
> > > > macros. If a prototype is incorrect in the TRACE_EVENT() macro, then
> > > > other macros will catch it.
> > > 
> > > 
> > > 
> > > Agreed. Typechecking matters for human code but not in this context.
> > > Considering that the tracepoint and the probe are created by the same
> > > CPP code, bugs will be tracked down quickly and located to a single
> > > place.
> > 
> > So it seems that I am the only one asking for extra type-checking and
> > caring about problems that can appear subtily on architectures where the
> > number of caller/callee arguments must match. And also the only one
> > considering that passing more arguments to a callback that does not
> > expect all of them might be a problem on some architectures.
> > 
> > Am I the only one thinking there is something fishy there ? I might be
> > entirely over-paranoid, but this approach has rarely failed me in the
> > past.
> 
> I think you are the only one not realizing that the caller and callee
> are created automatically with the same data. There is no human
> intervention here.
> 
> You are asking to add a check that I can not see helping. The only way
> to add a check, is to use the automated process to check the automation.
> If the automated process fails, it is very likely the check will also be
> broken and will not catch the bug either.

Tell me where to fetch the git head, I'll add it myself. ;)

Thanks,

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
