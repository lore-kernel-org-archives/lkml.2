Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881Ab0KQIHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 03:07:06 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58836 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758033Ab0KQIHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 03:07:03 -0500
Date: Wed, 17 Nov 2010 13:36:55 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101117080653.GB16969@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <AANLkTimwSktAQ5PkXNGY2EQz71DFmKY3Bt2fbZYasD0G@mail.gmail.com>
 <AANLkTi=fT-DCP40_U24zft-3owseW24px=Zq=LnEJ_FF@mail.gmail.com>
 <1289783580.495.58.camel@maggy.simson.net>
 <1289811438.2109.474.camel@laptop>
 <1289820766.16406.45.camel@maggy.simson.net>
 <1289821590.16406.47.camel@maggy.simson.net>
 <20101115125716.GA22422@redhat.com>
 <1289856350.14719.135.camel@maggy.simson.net>
 <20101116015648.GA11534@redhat.com>
 <AANLkTik4J7u1zC+D7bkB5PyVHRS_pLOU=c5HFUMxGqwM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <AANLkTik4J7u1zC+D7bkB5PyVHRS_pLOU=c5HFUMxGqwM@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org> [2010-11-15 18:18:20]:

> On Mon, Nov 15, 2010 at 5:56 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > Should this kind of thing be done in user space?
> 
> Almost certainly not.
>
> First off, user-space is a fragmented mess. Just from a "let's get it
> done" angle, it just doesn't work. There are lots of different thing
> that create new tty's, and you can't have them all fixed. Plus it
> would be _way_ more code in user space than it is in kernel space.
>
> Secondly, user-space daemons are a total mess. We've tried it many
> many times, and every time the _intention_ is to make things simpler
> to debug and deploy. And it almost never is. The interfaces end up
> being too painful, and the "part of the code is in kernel space, part
> of it is in user space" means that things just break all the time.
> 

Please elaborate, is this a generic statement or a comment on
cgclassify or cgroup user rules.

> Finally, the whole "user space is more flexible" is just a lie. It
> simply doesn't end up being true. It will be _harder_ to configure
> some user-space daemon than it is to just set a flag in /sys or
> whatever. The "flexibility" tends to be more a flexibility to get
> things wrong than any actual advantage.
> 
> Just look at the patch in question. It's simple, it's clean, and it
> "just works". Doing the same thing in user space? It would be a total
> nightmare, and exactly _because_ it would be a total nightmare, the
> code would never be that simple or clean.
> 
>                        Linus

-- 
	Three Cheers,
	Balbir
