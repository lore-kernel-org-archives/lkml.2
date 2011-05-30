Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab1E3IOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 04:14:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43166 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707Ab1E3IOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 04:14:10 -0400
Date: Mon, 30 May 2011 10:14:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, linux-mm@kvack.org
Subject: Re: [PATCH] mm: Fix boot crash in mm_alloc()
Message-ID: <20110530081400.GK27557@elte.hu>
References: <20110529072256.GA20983@elte.hu>
 <BANLkTikHejgEyz9LfJ962Bu89vn1cBP+WQ@mail.gmail.com>
 <BANLkTimqhkiBSArm7n0_9FD+LW6hWBWxFA@mail.gmail.com>
 <BANLkTin8yxh=Bjwf7AEyzPCoghnYO2brLQ@mail.gmail.com>
 <4DE2EEFB.1080803@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE2EEFB.1080803@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> (2011/05/30 3:43), Linus Torvalds wrote:
> > On Sun, May 29, 2011 at 10:19 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> >>
> >> STILL TOTALLY UNTESTED! The fixes were just from eyeballing it a bit
> >> more, not from any actual testing.
> > 
> > Ok, I eyeballed it some more, and tested both the OFFSTACK and ONSTACK
> > case, and decided that I had better commit it now rather than wait any
> > later since I'll do the -rc1 later today, and will be on an airplane
> > most of tomorrow.
> > 
> > The exact placement of the cpu_vm_mask_var is up for grabs. For
> > example, I started thinking that it might be better to put it *after*
> > the mm_context_t, since for the non-OFFSTACK case it's generally
> > touched at the beginning rather than the end.
> > 
> > And the actual change to make the mm_cachep kmem_cache_create() use a
> > variable-sized allocation for the OFFSTACK case is similarly left as
> > an exercise for the the reader. So effectively, this reverts a lot of
> > de03c72cfce5, but does so in a way that should make very it easy to
> > get back to where KOSAKI was aiming for.
> > 
> > Whatever. I was hoping to get comments on it, but I think I need to
> > rather push it out to get tested and public than wait any longer. The
> > patch *looks* fine, tests ok on my machine, and removes more lines
> > than it adds despite the new big comment.
> 
> Hi
> 
> Thank you Linus and I'm sorry for bother you and guys. So, if I 
> understand this thread correctly, rest my homework is 1) make 
> cpumask_allocation variable size 2) remove NR_CPUS bit fill/copy 
> from fork/exec path. Right?
> 
> I think (2) is big matter than (1). NR_CPUS(=4096) bits copy easily 
> screw up cache behavior. Anyway, will do. Thank you!

I think the first task would be to double check that the code in 
3.0-rc1 is indeed correct! :-)

Thanks,

	Ingo
