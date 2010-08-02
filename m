Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab0HBCVL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 22:21:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46098 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab0HBCVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 22:21:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rwFqAvoXPcVbftVJdwrcEsTTpO9vn7uQDS7l+RakJeadnkqdG1MMdQ2nYZF9aNU9GT
         JRj9pL7c4TZt4L5FVDWT4Z225kKDY1WGpmo0y6uigy56sRANUS32PDjymkBd77utqlXS
         i+8VPa8d/adb/PV6Rmwv0vuqgyqvHKyQki5vw=
Date: Mon, 2 Aug 2010 04:20:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
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
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv10 2.6.35-rc6-tip 9/14]  trace: uprobes trace_event
	interface
Message-ID: <20100802022055.GB5581@nowhere>
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6> <20100727111045.24690.31897.sendpatchset@localhost6.localdomain6> <4C510BCE.4010704@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C510BCE.4010704@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 02:04:14PM +0900, Masami Hiramatsu wrote:
> Srikar Dronamraju wrote:
> > diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> > index c681fa7..16e2a8c 100644
> > --- a/kernel/trace/Kconfig
> > +++ b/kernel/trace/Kconfig
> > @@ -482,6 +482,22 @@ config RING_BUFFER_BENCHMARK
> >  
> >  	  If unsure, say N.
> >  
> > +config UPROBE_EVENT
> > +	bool "Enable uprobes-based dynamic events"
> > +	depends on ARCH_SUPPORTS_UPROBES
> > +	depends on MMU
> > +	select UPROBES
> > +	select PROBE_EVENTS
> > +	select TRACING
> > +	default n
> > +	help
> > +	  This allows the user to add tracing events on top of userspace dynamic
> > +	  events (similar to tracepoints) on the fly via the traceevents interface.
> > +	  Those events can be inserted wherever uprobes can probe, and record
> > +	  various registers.
> > +	  This option is required if you plan to use perf-probe subcommand of perf
> > +	  tools on user space applications.
> > +
> 
> Possible enhancement: Moving this config right after KPROBE_EVENT, because
>  those two provide similar dynamic events.
> 
> Thank you,


In fact this could be a menu "Dynamic Probes", perhaps default off, inside
which Kprobes and Uprobes would be default on (but depend on "Dynamic Probes").

So that you can quickly enable them all in one.

