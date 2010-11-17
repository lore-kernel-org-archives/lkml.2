Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933978Ab0KQB5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:57:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45703 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab0KQB5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:57:09 -0500
Date: Tue, 16 Nov 2010 20:56:50 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101117015650.GD22651@bombadil.infradead.org>
References: <AANLkTimwSktAQ5PkXNGY2EQz71DFmKY3Bt2fbZYasD0G@mail.gmail.com>
 <AANLkTi=fT-DCP40_U24zft-3owseW24px=Zq=LnEJ_FF@mail.gmail.com>
 <1289783580.495.58.camel@maggy.simson.net>
 <1289811438.2109.474.camel@laptop>
 <1289820766.16406.45.camel@maggy.simson.net>
 <1289821590.16406.47.camel@maggy.simson.net>
 <20101115125716.GA22422@redhat.com>
 <1289856350.14719.135.camel@maggy.simson.net>
 <20101117013148.GA22651@bombadil.infradead.org>
 <AANLkTi=ynv+TAB9a2-+9PDhYbmopMn+6FPxh4ZUdro2K@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=ynv+TAB9a2-+9PDhYbmopMn+6FPxh4ZUdro2K@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 05:50:41PM -0800, Linus Torvalds wrote:
> Blame me, I threw that out as a single point where this can be done.
> 
> In fact, holding the signal spinlock was seen as a bonus, since that
> was used to serialize the access to the signal->autogroup access.
> Which I think is required.
> 
> But yes, it does create problems for the allocation. It could be done
> as just a GFP_ATOMIC, of course, and on allocation failure you'd just
> punt and not do it. Not pretty, but functional.
> 

Yeah, I didn't look any deeper than kernel/sched.c::sched_create_group,
but that would need to GFP_ATOMIC as well.

Looking at it now, so would alloc_rt_sched_group/alloc_fair_sched_group,
and we're looking at an awful lot of sleepless allocations. Not sure
that's a feasible plan.

--Kyle
