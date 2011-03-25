Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab1CYUAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 16:00:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37827 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab1CYUAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 16:00:15 -0400
Date: Fri, 25 Mar 2011 21:00:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Christoph Lameter <cl@linux.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [boot crash #2] Re: [GIT PULL] SLAB changes for v2.6.39-rc1
Message-ID: <20110325200003.GC7346@elte.hu>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>
 <20110324142146.GA11682@elte.hu>
 <alpine.DEB.2.00.1103240940570.32226@router.home>
 <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>
 <20110324172653.GA28507@elte.hu>
 <20110324185258.GA28370@elte.hu>
 <alpine.LFD.2.00.1103242005530.31464@localhost6.localdomain6>
 <20110324192247.GA5477@elte.hu>
 <AANLkTinBwM9egao496WnaNLAPUxhMyJmkusmxt+ARtnV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinBwM9egao496WnaNLAPUxhMyJmkusmxt+ARtnV@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@kernel.org> wrote:

> On Thu, Mar 24, 2011 at 9:22 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> >> On Thu, 24 Mar 2011, Ingo Molnar wrote:
> >> > RIP: 0010:[<ffffffff810570a9>]  [<ffffffff810570a9>] get_next_timer_interrupt+0x119/0x260
> >>
> >> That's a typical timer crash, but you were unable to debug it with
> >> debugobjects because commit d3f661d6 broke those.
> >>
> >> Christoph, debugobjects do not need to run with interupts
> >> disabled. And just because they were in that section to keep all the
> >> debug stuff together does not make an excuse for not looking at the
> >> code and just slopping it into some totally unrelated ifdef along with
> >> a completely bogus comment.
> >>
> >> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> >> ---
> >>  mm/slub.c |    4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> Index: linux-2.6/mm/slub.c
> >> ===================================================================
> >> --- linux-2.6.orig/mm/slub.c
> >> +++ linux-2.6/mm/slub.c
> >> @@ -849,11 +849,11 @@ static inline void slab_free_hook(struct
> >>               local_irq_save(flags);
> >>               kmemcheck_slab_free(s, x, s->objsize);
> >>               debug_check_no_locks_freed(x, s->objsize);
> >> -             if (!(s->flags & SLAB_DEBUG_OBJECTS))
> >> -                     debug_check_no_obj_freed(x, s->objsize);
> >>               local_irq_restore(flags);
> >>       }
> >>  #endif
> >> +     if (!(s->flags & SLAB_DEBUG_OBJECTS))
> >> +             debug_check_no_obj_freed(x, s->objsize);
> >
> > Thanks, this did the trick!
> >
> > Tested-by: Ingo Molnar <mingo@elte.hu>
> >
> > With this fix i got the warning below - pinpointing a net/bluetooth/hci_core.c
> > timer bug.
> 
> Applied, thanks!

Just an update: all SLAB/SLUB problems appear to be fixed with the latest 
patches, so i'm a happy camper!

Thanks Pekka,

	Ingo
