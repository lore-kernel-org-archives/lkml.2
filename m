Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985Ab0KPPKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 10:10:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756378Ab0KPPKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 10:10:42 -0500
Date: Tue, 16 Nov 2010 16:03:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101116150319.GA3475@redhat.com>
References: <AANLkTimwSktAQ5PkXNGY2EQz71DFmKY3Bt2fbZYasD0G@mail.gmail.com> <AANLkTi=fT-DCP40_U24zft-3owseW24px=Zq=LnEJ_FF@mail.gmail.com> <1289783580.495.58.camel@maggy.simson.net> <1289811438.2109.474.camel@laptop> <1289820766.16406.45.camel@maggy.simson.net> <1289821590.16406.47.camel@maggy.simson.net> <20101115125716.GA22422@redhat.com> <1289856350.14719.135.camel@maggy.simson.net> <20101116130413.GA29368@redhat.com> <1289917109.5169.131.camel@maggy.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289917109.5169.131.camel@maggy.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16, Mike Galbraith wrote:
>
> On Tue, 2010-11-16 at 14:04 +0100, Oleg Nesterov wrote:
> > However, I must admit I dislike this check. Because, looking at this
> > code, it is not clear why do we check PF_EXITING. It looks as if it
> > is needed for correctness.
>
> Is _not_ needed I presume.
>
> I'll remove it, I'm not overly attached (a t t a..;) to it.

Argh!

I was wrong, it _is_ needed for correctness. Yes, it is always safe
to read the pointer, but

> > Yes, sure, rq->lock should ensure signal->autogroup can't go away.
> > (even if it can be changed under us). And it does, we are moving all
> > threads before kref_put().
>
> (yeah)

Exactly. And this means we can _only_ assume it can't go away if
autogroup_move_group() can see us on ->thread_group list.

Perhaps this deserve a commen (unless I missed something again).

Mike, sorry for confusion.

Oleg.

