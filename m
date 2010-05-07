Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab0EGU7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 16:59:00 -0400
Received: from mail.openrapids.net ([64.15.138.104]:60261 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755535Ab0EGU66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 16:58:58 -0400
Date: Fri, 7 May 2010 16:58:56 -0400
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
Message-ID: <20100507205855.GB28122@Krystal>
References: <20100504034045.085822814@goodmis.org> <20100504034202.282030521@goodmis.org> <20100507042025.GC8069@nowhere> <20100507145438.GB29573@Krystal> <20100507180130.GA5401@nowhere> <1273259305.22438.417.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273259305.22438.417.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:56:28 up 104 days, 23:33,  7 users,  load average: 0.20, 0.16,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Fri, 2010-05-07 at 20:01 +0200, Frederic Weisbecker wrote:
> > On Fri, May 07, 2010 at 10:54:38AM -0400, Mathieu Desnoyers wrote:
> 
> > The second is this extra parameter passed whether or not it is needed.
> > And although we suppose it is safe, I don't feel comfortable with it.
> > So if we can find a more proper way to avoid it, I'm all for it.
> 
> Now I'm making the extra parameter mandatory for all tracepoint
> probes. ;-)
> 
> But this time, it will be at the start not the end.
> 
> 	void probe(void *data, proto);
> 
> 
> Unfortunately we can't avoid it. In order to remove the extra code
> (registering and unregistering) and even share the probe among several
> events, we need a way to pass the data to the probe to let the probe
> know what event it is dealing with (to put in the event id into the
> buffer, to let the tracer output code know what event this data is for).
> 
> The current method is that only the proto that the tracepoint uses is
> passed to the probe. This gives us no way to add any more information.
> 
> This new method allows data to be assigned at probe register, and the
> probe gets this data as the first parameter.
> 
> The register_* functions will still do typechecking of the probes, they
> just add the "void *" at the beginning.
> 
> Actually, here is a place that I can see where Mathieu's check does come
> in handy. If we add the check test to each probe, and the tracepoint
> proto changes, it will flag it.

Ah ! finally we are getting on the same page. :-)

> 
> Mathieu, you've been explaining this wrong ;-)

Yep, it seems like I've done a terrible job at trying to explain my motivation
to you. ;)

> 
> I'm not worried about changes to ftrace.h breaking things. I'm worried
> about changes to tracepoint.h breaking ftrace.h.  This is where your
> check comes in. As I change the void *data from the end to the start,
> I'm nervous about catching all the probes that are registered this way.
> (ftrace events, syscalls, kprobes, and perf)

I'm nervous about catching all tracepoint-related problems that may arise from
both tracepoint and tracepoint probes prototype changes, yes.

I'm glad we agree then. :-)

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
