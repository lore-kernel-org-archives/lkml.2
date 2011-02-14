Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab1BNSyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:54:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab1BNSyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:54:52 -0500
Date: Mon, 14 Feb 2011 13:54:00 -0500
From: Jason Baron <jbaron@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, peterz@infradead.org
Cc: hpa@zytor.com, rostedt@goodmis.org, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
Message-ID: <20110214185400.GB3449@redhat.com>
References: <1297460297.5226.99.camel@laptop> <1297536465.5226.108.camel@laptop> <20110214155113.GA2840@redhat.com> <1297699024.2401.12.camel@twins> <20110214160437.GB2840@redhat.com> <BLU0-SMTP4069A1A89F06CDFF9B28F896D00@phx.gbl> <1297700754.5226.110.camel@laptop> <20110214162947.GA3449@redhat.com> <1297701438.5226.113.camel@laptop> <BLU0-SMTP64371A838030ED92A7CCB696D00@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU0-SMTP64371A838030ED92A7CCB696D00@phx.gbl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 11:43:43AM -0500, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Mon, 2011-02-14 at 11:29 -0500, Jason Baron wrote:
> > > On Mon, Feb 14, 2011 at 05:25:54PM +0100, Peter Zijlstra wrote:
> > > > > 
> > > > > I remember that atomic_t is defined in types.h now rather than atomic.h.
> > > > > Any reason why you should keep including atomic.h from jump_label.h ?
> > > > 
> > > > Ooh, shiny.. we could probably move the few atomic_{read,inc,dec} users
> > > > in jump_label.h into out of line functions and have this sorted.
> > > > 
> > > 
> > > inc and dec sure, but atomic_read() for the disabled case needs to be
> > > inline....
> > 
> > D'0h yes of course, I was thinking about jump_label_enabled(), but
> > there's still the static_branch() implementation to consider.
> > 
> > We could of course cheat implement our own version of atomic_read() in
> > order to avoid the whole header mess, but that's not pretty at all
> > 
> 
> OK, so the other way around then : why does kernel.h need to include
> dynamic_debug.h (which includes jump_label.h) ?
> 

well, its used to dynamically enable/disable pr_debug() statements which
actually have now moved to linux/printk.h, which is included by
kernel.h.

I don't need an atomic_read() in the disabled case for dynamic debug,
and I would be ok, #ifdef CONFIG_JUMP_LABEL, in dynamic_debug.h. Its not
the prettiest solution. But I can certainly live with it for now, so
that we can sort out the atomic_read() issue independently.

Peter, Mathieu, are you guys ok with this?

-Jason
