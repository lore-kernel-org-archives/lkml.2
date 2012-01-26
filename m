Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab2AZLLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:11:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48699 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443Ab2AZLLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:11:21 -0500
Date: Thu, 26 Jan 2012 12:10:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux-mm <linux-mm@kvack.org>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v9 3.2 0/9] Uprobes patchset with perf probe support
Message-ID: <20120126111041.GG3853@elte.hu>
References: <20120110114821.17610.9188.sendpatchset@srdronam.in.ibm.com>
 <20120116083442.GA23622@elte.hu>
 <20120116151755.GH10189@linux.vnet.ibm.com>
 <20120117093925.GC10397@elte.hu>
 <1327500687.2614.70.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327500687.2614.70.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2012-01-17 at 10:39 +0100, Ingo Molnar wrote:
> 
> > I did not suggest anything complex or intrusive: just basically 
> > unify the namespace, have a single set of callbacks, and call 
> > into the uprobes and perf code from those callbacks - out of the 
> > sight of MM code.
> > 
> > That unified namespace could be called:
> > 
> >     event_mmap(...);
> >     event_fork(...);
> > 
> > etc. - and from event_mmap() you could do a simple:
> > 
> > 	perf_event_mmap(...)
> > 	uprobes_event_mmap(...)
> > 
> > [ Once all this is updated to use tracepoints it would turn into 
> >   a notification callback chain kind of thing. ]
> 
> We keep disagreeing on this. I utterly loathe hiding stuff in 
> notifier lists. It makes it completely non-obvious who all 
> does what.

My immediate suggestion was not a notifier list but an 
open-coded list of function calls done in helper inline 
functions - to minimize the impact of the callbacks on mm/.

> Another very good reason to not do what you suggest is that 
> perf_event_mmap() is a pure consumer, it doesn't have a return 
> value, whereas uprobes_mmap() can actually fail the mmap.

You know that i disagree with that, there is no fundamental 
reason why event callbacks couldnt participate in program logic, 
as long as the call site explicitly wants such side effects. It 
avoids senseless duplication of callbacks.

Anyway, if Andrew is fine with the current callbacks as-is then 
it's fine to me as well.

Thanks,

	Ingo
