Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab0KQNCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:02:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:54099 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313Ab0KQNCl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:02:41 -0500
Subject: Re: [ANNOUNCE] New utility: 'trace'
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20101117125344.GC5464@nowhere>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	 <4CE2F747.4060406@linux.intel.com> <20101116221726.GB26243@nowhere>
	 <20101117083020.GA11336@elte.hu> <1289993750.2109.718.camel@laptop>
	 <20101117125344.GC5464@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 14:02:37 +0100
Message-ID: <1289998957.2109.751.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 13:53 +0100, Frederic Weisbecker wrote:
> On Wed, Nov 17, 2010 at 12:35:50PM +0100, Peter Zijlstra wrote:
> > On Wed, 2010-11-17 at 09:30 +0100, Ingo Molnar wrote:
> > > > For example I'm currently working with dozens of trace_printk() and I would be 
> > > > very happy to turn some of them off half of the time.
> > > 
> > > I guess we could try such a patch. If you send a prototype i'd be interested in 
> > > testing it out.
> > 
> > I don't see the point, the kernel shouldn't contain any trace_printk()s
> > to begin with..
> 
> 
> It's oriented toward developers. Those who use dozens of tracepoints in
> their tree because they are debugging something or developing a new feature,
> they might to deactivate/reactivate some of these independant points.
> 
> This can also apply to dynamic_printk of course.
> 
> Well, the very first and main point is to standardize trace_printk into
> a trace event so that it gets usable by perf tools. I have been asked many
> times "how to use trace_printk() with perf?".

Thing is, since its these dev who add the trace_printk()s to begin with,
I don't see the point in splitting them out, if you didn't want them why
did you add them to begin with?!

As to the trace_printk() to perf interface, you could do like mingo did
and create a fake event and use the regular tracepoint interface, or
hook it up directly and create a PERF_RECORD_TEXT field.

Personally I like the trace_printk() as a TRACE_EVENT(printk), it also
allows removing lots of the special casing concerning trace_printk from
ftrace.


