Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab2DNUxE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 16:53:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951Ab2DNUxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 16:53:01 -0400
Date: Sat, 14 Apr 2012 22:52:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Subject: Re: [RFC 0/6] uprobes: kill uprobes_srcu/uprobe_srcu_id
Message-ID: <20120414205200.GA9083@redhat.com>
References: <20120405222024.GA19154@redhat.com> <1334409396.2528.100.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334409396.2528.100.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14, Peter Zijlstra wrote:
>
> On Fri, 2012-04-06 at 00:20 +0200, Oleg Nesterov wrote:
> > Hello.
> >
> > Not for inclusion yet, only for the early review.
> >
> > I didn't even try to test these changes, and I am not expert
> > in this area. And even _if_ this code is correct, I need to
> > re-split these changes anyway, update the changelogs, etc.
> >
> > Questions:
> >
> > 	- does it make sense?
>
> Maybe, upside is reclaiming that int from task_struct, downside is that
> down_write :/ It would be very good not to have to do that.

Yes, down_write() is pessimization, I agree.

> Nor do I
> really see how that works.
>
> > 	- can it work or I missed something "in general" ?
>
> So we insert in the rb-tree before we take mmap_sem, this means we can
> hit a non-uprobe int3 and still find a uprobe there, no?

Yes, but unless I miss something this is "off-topic", this
can happen with or without these changes. If find_uprobe()
succeeds we assume that this bp was inserted by uprobe.

Perhaps uprobe_register() should not "ignore" -EXIST from
install_breakpoint()->is_swbp_insn(), or perhaps we can
add UPROBE_SHARED_BP.

Oleg.

