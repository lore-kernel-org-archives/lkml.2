Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab0HBH6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:58:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65460 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0HBH6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:58:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TXTSJzGDtgFBHbitsU1yDQVie5U24+JMhNw+UvJe1jee+NC1ZtDxUOPERByGIZtzu9
         qIqa8YmSh3ymz5eZak7jCzQFH2Om7l/fzkAGQVth+dF8LODU6KkJRRqg+mFqtujXa4dS
         +QfSkVrDppS9BQBdeAikNJ036d3isJczlQZok=
Date: Mon, 2 Aug 2010 09:58:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
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
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCHv10 2.6.35-rc6-tip 9/14]  trace: uprobes trace_event
	interface
Message-ID: <20100802075810.GB5292@nowhere>
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6> <20100727111045.24690.31897.sendpatchset@localhost6.localdomain6> <4C510BCE.4010704@hitachi.com> <20100802022055.GB5581@nowhere> <4C563F44.9080300@hitachi.com> <20100802064638.GB22812@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802064638.GB22812@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 12:16:38PM +0530, Srikar Dronamraju wrote:
> > > 
> > > In fact this could be a menu "Dynamic Probes", perhaps default off, inside
> > > which Kprobes and Uprobes would be default on (but depend on "Dynamic Probes").
> > > 
> > > So that you can quickly enable them all in one.
> > 
> > Hmm, I disagree with it, because both Kprobes and Uprobes provides
> > APIs for modules too.
> > 
> > I'd like to suggest below config tree
> > 
> > Kenrel hacking
> >   - Kprobes
> >   - Uprobes
> >   - Tracing
> >      -- Dynamic Events
> >         depends on Kprobes || Uprobes
> > or
> > 	select Kprobes && Uprobes
> 
> I would agree with Masami since there could be people who might be
> apprehensive to try out Uprobes (which would still be experimental) but
> would be interested to use kprobes only since its more mature.
> 
> One change I would suggest would be to select respective events(i.e
> kprobe_event, uprobe_event) instead of kprobes and uprobes.


Yeah sure. The goal was to still have both selectable independently, but
have a menu that can select all in one.

ie:

config DYNAMIC_PROBE
	depends on (KPROBES || UPROBES) && EVENTS_TRACING
	default n

config KPROBES_EVENT:
	depends on DYNAMIC_PROBE && KPROBES
	default y

config UPROBES_EVENT:
	depends on DYNAMIC_PROBE && UPROBES
	default y


So that people who want dynamic probes just don't care and select dynamic probe.
Those who want more granularity can still unselect uprobes events or kprobes
events after that.

