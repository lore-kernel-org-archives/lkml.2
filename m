Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934158Ab0KQCOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 21:14:40 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:33521 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S934118Ab0KQCOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 21:14:38 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+J8IAxJqCJ+GJFmv36vseWm+CLZQjfe5w22hKW0i
	hlhwePN3sqlEnN
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101117013148.GA22651@bombadil.infradead.org>
References: <AANLkTimHtjH3YvtX6i542_XjfFeuvG-AnU8i224a1R4j@mail.gmail.com>
	 <1289778189.5154.10.camel@maggy.simson.net>
	 <AANLkTimwSktAQ5PkXNGY2EQz71DFmKY3Bt2fbZYasD0G@mail.gmail.com>
	 <AANLkTi=fT-DCP40_U24zft-3owseW24px=Zq=LnEJ_FF@mail.gmail.com>
	 <1289783580.495.58.camel@maggy.simson.net>
	 <1289811438.2109.474.camel@laptop>
	 <1289820766.16406.45.camel@maggy.simson.net>
	 <1289821590.16406.47.camel@maggy.simson.net>
	 <20101115125716.GA22422@redhat.com>
	 <1289856350.14719.135.camel@maggy.simson.net>
	 <20101117013148.GA22651@bombadil.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 19:14:20 -0700
Message-ID: <1289960060.8075.13.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 20:31 -0500, Kyle McMartin wrote:
> Hi Mike,
> 
> On Mon, Nov 15, 2010 at 02:25:50PM -0700, Mike Galbraith wrote:
> > --- linux-2.6.orig/drivers/tty/tty_io.c
> > +++ linux-2.6/drivers/tty/tty_io.c
> > @@ -3160,6 +3160,7 @@ static void __proc_set_tty(struct task_s
> >  	put_pid(tsk->signal->tty_old_pgrp);
> >  	tsk->signal->tty = tty_kref_get(tty);
> >  	tsk->signal->tty_old_pgrp = NULL;
> > +	sched_autogroup_create_attach(tsk);
> >  }
> >  
> 
> This is a bit of a problem, as it's called in_atomic context and kmalloc's
> under GFP_KERNEL (which can sleep.) This results in sleep-under-spinlock
> prints when CONFIG_DEBUG_SPINLOCK_SLEEP=y.

Yeah, I got another report about that today.

	-Mike

