Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933893Ab0KQBvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:51:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932959Ab0KQBvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:51:19 -0500
MIME-Version: 1.0
In-Reply-To: <20101117013148.GA22651@bombadil.infradead.org>
References: <AANLkTimHtjH3YvtX6i542_XjfFeuvG-AnU8i224a1R4j@mail.gmail.com>
 <1289778189.5154.10.camel@maggy.simson.net> <AANLkTimwSktAQ5PkXNGY2EQz71DFmKY3Bt2fbZYasD0G@mail.gmail.com>
 <AANLkTi=fT-DCP40_U24zft-3owseW24px=Zq=LnEJ_FF@mail.gmail.com>
 <1289783580.495.58.camel@maggy.simson.net> <1289811438.2109.474.camel@laptop>
 <1289820766.16406.45.camel@maggy.simson.net> <1289821590.16406.47.camel@maggy.simson.net>
 <20101115125716.GA22422@redhat.com> <1289856350.14719.135.camel@maggy.simson.net>
 <20101117013148.GA22651@bombadil.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Nov 2010 17:50:41 -0800
Message-ID: <AANLkTi=ynv+TAB9a2-+9PDhYbmopMn+6FPxh4ZUdro2K@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 5:31 PM, Kyle McMartin <kyle@mcmartin.ca> wrote:
>
> This is a bit of a problem, as it's called in_atomic context and kmalloc's
> under GFP_KERNEL (which can sleep.) This results in sleep-under-spinlock
> prints when CONFIG_DEBUG_SPINLOCK_SLEEP=y.

Blame me, I threw that out as a single point where this can be done.

In fact, holding the signal spinlock was seen as a bonus, since that
was used to serialize the access to the signal->autogroup access.
Which I think is required.

But yes, it does create problems for the allocation. It could be done
as just a GFP_ATOMIC, of course, and on allocation failure you'd just
punt and not do it. Not pretty, but functional.

                  Linus
