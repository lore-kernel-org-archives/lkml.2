Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab0KOA1M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 19:27:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755368Ab0KOA1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 19:27:11 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimwSktAQ5PkXNGY2EQz71DFmKY3Bt2fbZYasD0G@mail.gmail.com>
References: <1289489200.11397.21.camel@maggy.simson.net> <20101111202703.GA16282@redhat.com>
 <1289514000.21413.204.camel@maggy.simson.net> <20101112181240.GB8659@redhat.com>
 <1289648524.22764.149.camel@maggy.simson.net> <1289755150.3228.44.camel@maggy.simson.net>
 <20101114174921.GA1569@arch.trippelsdorf.de> <1289758238.17491.12.camel@maggy.simson.net>
 <AANLkTimy5DdF8qwGuk09iT3wHfXMjkiwRKxo-LuvEJzW@mail.gmail.com>
 <AANLkTikjSCbcRnKOU=nd4os1sdW-GJkD6QVj=U5zPyu8@mail.gmail.com>
 <20101114202734.GA1627@arch.trippelsdorf.de> <AANLkTimHtjH3YvtX6i542_XjfFeuvG-AnU8i224a1R4j@mail.gmail.com>
 <1289778189.5154.10.camel@maggy.simson.net> <AANLkTimwSktAQ5PkXNGY2EQz71DFmKY3Bt2fbZYasD0G@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 14 Nov 2010 16:26:47 -0800
Message-ID: <AANLkTi=fT-DCP40_U24zft-3owseW24px=Zq=LnEJ_FF@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Mike Galbraith <efault@gmx.de>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 14, 2010 at 4:15 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> THAT is why I think it's so silly to try to be so strict and walk over
> all processes while holding a couple of spinlocks.

Btw, let me say that I think the patch is great even with that thing
in. It looks clean, the thing I'm complaining about is not a big deal,
and it seems to perform very much as advertized. The difference with
autogroup scheduling is very noticeable with a simple "make -j64"
kernel compile.

So I really don't think it's a big deal. The sysctl handler isn't even
complicated. But boy does it hurt my eyes to see a spinlock held
around a "do_each_thread()". And I do get the feeling that the
simplest way to fix it would be to just remove the code entirely, and
just say that "enabling/disabling may be delayed for old processes
with existing autogroups".

                    Linus
