Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab0HBH5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:57:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54983 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab0HBH5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:57:04 -0400
Date: Mon, 2 Aug 2010 09:56:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCHv10 2.6.35-rc6-tip 9/14]  trace: uprobes trace_event
 interface
Message-ID: <20100802075637.GB24085@elte.hu>
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6>
 <20100727111045.24690.31897.sendpatchset@localhost6.localdomain6>
 <4C510BCE.4010704@hitachi.com>
 <20100802022055.GB5581@nowhere>
 <4C563F44.9080300@hitachi.com>
 <20100802074619.GA5292@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802074619.GA5292@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Mon, Aug 02, 2010 at 12:45:08PM +0900, Masami Hiramatsu wrote:
> > Frederic Weisbecker wrote:
> > > On Thu, Jul 29, 2010 at 02:04:14PM +0900, Masami Hiramatsu wrote:
> > >> Srikar Dronamraju wrote:
> > >>> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> > >>> index c681fa7..16e2a8c 100644
> > >>> --- a/kernel/trace/Kconfig
> > >>> +++ b/kernel/trace/Kconfig
> > >>> @@ -482,6 +482,22 @@ config RING_BUFFER_BENCHMARK
> > >>>  
> > >>>  	  If unsure, say N.
> > >>>  
> > >>> +config UPROBE_EVENT
> > >>> +	bool "Enable uprobes-based dynamic events"
> > >>> +	depends on ARCH_SUPPORTS_UPROBES
> > >>> +	depends on MMU
> > >>> +	select UPROBES
> > >>> +	select PROBE_EVENTS
> > >>> +	select TRACING
> > >>> +	default n
> > >>> +	help
> > >>> +	  This allows the user to add tracing events on top of userspace dynamic
> > >>> +	  events (similar to tracepoints) on the fly via the traceevents interface.
> > >>> +	  Those events can be inserted wherever uprobes can probe, and record
> > >>> +	  various registers.
> > >>> +	  This option is required if you plan to use perf-probe subcommand of perf
> > >>> +	  tools on user space applications.
> > >>> +
> > >> Possible enhancement: Moving this config right after KPROBE_EVENT, because
> > >>  those two provide similar dynamic events.
> > >>
> > >> Thank you,
> > > 
> > > 
> > > In fact this could be a menu "Dynamic Probes", perhaps default off, inside
> > > which Kprobes and Uprobes would be default on (but depend on "Dynamic Probes").
> > > 
> > > So that you can quickly enable them all in one.
> > 
> > Hmm, I disagree with it, because both Kprobes and Uprobes provides
> > APIs for modules too.
> 
> I'm not sure there is a point in maintaining a leightweight version for out 
> of tree code. These modules could just select kprobes/uprobes events as 
> well.
> 
> As you prefer, that was just a suggestion to make it more simple.

The upstream policy always was that out of tree code does not exist as far as 
the kernel is concerned. So it is wrong to make the kernel crappier while 
helping out of tree code.

Thanks,

	Ingo
