Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933867Ab0KQNhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:37:17 -0500
Received: from canuck.infradead.org ([134.117.69.58]:39964 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757404Ab0KQNhQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:37:16 -0500
Subject: Re: [ANNOUNCE] New utility: 'trace'
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
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
In-Reply-To: <20101117131023.GE27063@elte.hu>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	 <4CE2F747.4060406@linux.intel.com> <20101116221726.GB26243@nowhere>
	 <20101117083020.GA11336@elte.hu> <1289993750.2109.718.camel@laptop>
	 <20101117125344.GC5464@nowhere> <1289998957.2109.751.camel@laptop>
	 <20101117131023.GE27063@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 14:36:16 +0100
Message-ID: <1290000976.2109.782.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 14:10 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, 2010-11-17 at 13:53 +0100, Frederic Weisbecker wrote:
> > > On Wed, Nov 17, 2010 at 12:35:50PM +0100, Peter Zijlstra wrote:
> > > > On Wed, 2010-11-17 at 09:30 +0100, Ingo Molnar wrote:
> > > > > > For example I'm currently working with dozens of trace_printk() and I would be 
> > > > > > very happy to turn some of them off half of the time.
> > > > > 
> > > > > I guess we could try such a patch. If you send a prototype i'd be interested in 
> > > > > testing it out.
> > > > 
> > > > I don't see the point, the kernel shouldn't contain any trace_printk()s
> > > > to begin with..
> > > 
> > > 
> > > It's oriented toward developers. Those who use dozens of tracepoints in
> > > their tree because they are debugging something or developing a new feature,
> > > they might to deactivate/reactivate some of these independant points.
> > > 
> > > This can also apply to dynamic_printk of course.
> > > 
> > > Well, the very first and main point is to standardize trace_printk into
> > > a trace event so that it gets usable by perf tools. I have been asked many
> > > times "how to use trace_printk() with perf?".
> > 
> > Thing is, since its these dev who add the trace_printk()s to begin with, I don't 
> > see the point in splitting them out, if you didn't want them why did you add them 
> > to begin with?!
> 
> That's a common workflow: lots of printks (trace_printk's) put all around the code - 
> and sometimes one set of tracepoints is needed, one time another set.
> 
> _If_ we succeed in presenting them like Frederic suggested it, and if we make the 
> turning on/off _simpler_ (no kernel modification) and faster (no kernel reboot) via 
> the tooling, people like Frederic might start using it.
> 
> I dont think we should fight the workflow itself - it makes sense.
> 
> The only question is whether we can represent it all in a nicer fashion than 'modify 
> the source code and reboot'. If we cannot then there's no point - but i'm not sure 
> about it and Frederic seems to be convinced too that he can make such a switch 
> on/off facility intuitive. We'll only see if we try it.
> 
> Also, i dont see any harm - do you?

Yes, trace_printk() is a pure debug interface, solely meant for the edit
+ reboot cycle.

If you want anything more than that we've got tracepoints. The rule up
until now has been to never merge a trace_printk() user.
