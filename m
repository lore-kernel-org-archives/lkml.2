Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933910Ab0JSJmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:42:15 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:56260 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758124Ab0JSJmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:42:13 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19u3tQX+V1uwnduq2z23M9ZQgmmPVRyqPgnpZMiFs
	XW34KBZKEg1YLu
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1287480592.29097.1650.camel@twins>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <1287480592.29097.1650.camel@twins>
Content-Type: text/plain
Date: Tue, 19 Oct 2010 11:42:08 +0200
Message-Id: <1287481328.24189.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 11:29 +0200, Peter Zijlstra wrote:
> On Tue, 2010-10-19 at 11:16 +0200, Mike Galbraith wrote:
> > +       read_lock_irqsave(&tasklist_lock, flags);
> > +
> > +       rcu_read_lock();
> > +       for_each_process(p) {
> > +               tg = task_group(p);
> > +               tty_sched_move_task(p, tg);
> > +               list_for_each_entry_rcu(t, &p->thread_group, thread_group) {
> > +                       tty_sched_move_task(t, tg);
> > +               }
> > +       }
> > +       rcu_read_unlock();
> > +
> > +       read_unlock_irqrestore(&tasklist_lock, flags); 
> 
> I don't think you need to disable IRQs for tasklist lock, nor do I think
> you actually need it.

OK, thanks.  (No such thing as too paranoid;)

	-Mike

