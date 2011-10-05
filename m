Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935236Ab1JERxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 13:53:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935188Ab1JERxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 13:53:04 -0400
Date: Wed, 5 Oct 2011 19:48:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 12/26]   Uprobes: Handle breakpoint
	and Singlestep
Message-ID: <20111005174842.GA3812@redhat.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20110920120221.25326.74714.sendpatchset@srdronam.in.ibm.com> <1317045553.1763.23.camel@twins> <20110926160144.GC13535@linux.vnet.ibm.com> <1317054322.1763.31.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317054322.1763.31.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26, Peter Zijlstra wrote:
>
> On Mon, 2011-09-26 at 21:31 +0530, Srikar Dronamraju wrote:
> > * Peter Zijlstra <peterz@infradead.org> [2011-09-26 15:59:13]:
> >
> > > On Tue, 2011-09-20 at 17:32 +0530, Srikar Dronamraju wrote:
> > > > 						Hence provide some extra
> > > > + * time (by way of synchronize_sched() for breakpoint hit threads to acquire
> > > > + * the uprobes_treelock before the uprobe is removed from the rbtree.
> > >
> > > 'Some extra time' doesn't make me all warm an fuzzy inside, but instead
> > > screams we fudge around a race condition.
> >
> > The extra time provided is sufficient to avoid the race. So will modify
> > it to mean "sufficient" instead of "some".
> >
> > Would that suffice?
>
> Much better, for extra point, explain why its sufficient as well ;-)

+1 ;)

I can't understand why synchronize_sched helps. In fact it is very
possible I simply misunderstood the problem, I'll appreciate if you
can explain.

Just for example. Suppose that uprobe_notify_resume() sleeps in
down_read(mmap_sem). In this case synchronize_sched() can return
even before it takes this sem, how this can help the subsequent
find_uprobe() ? Or that task  can be simply preempted before.

Or I missed the point completely?

Oleg.

