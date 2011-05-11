Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab1EKRQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:16:40 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:47548 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab1EKRQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:16:38 -0400
Date: Wed, 11 May 2011 13:19:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rakib.mullick@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Use bool type for rq->idle_at_tick
Message-ID: <20110511111915.GF18521@elte.hu>
References: <1304100062.19359.6.camel@localhost.localdomain>
 <tip-eea502ffd4aeef233b5eadbde405a9df92d57a5e@git.kernel.org>
 <1305112098.2914.211.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305112098.2914.211.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sat, 2011-04-30 at 07:16 +0000, tip-bot for Rakib Mullick wrote:
> > Commit-ID:  eea502ffd4aeef233b5eadbde405a9df92d57a5e
> > Gitweb:     http://git.kernel.org/tip/eea502ffd4aeef233b5eadbde405a9df92d57a5e
> > Author:     Rakib Mullick <rakib.mullick@gmail.com>
> > AuthorDate: Sat, 30 Apr 2011 00:01:02 +0600
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sat, 30 Apr 2011 00:17:14 +0200
> > 
> > sched: Use bool type for rq->idle_at_tick
> > 
> > Searching over the scheduler code for uses of rq->idle_at_tick
> > shows us that it's used for making TRUE/FALSE decision.
> > 
> > Still its type is 'unsigned char' so using 'bool' would be
> > cleaner.
> > 
> > Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Link: http://lkml.kernel.org/r/1304100062.19359.6.camel@localhost.localdomain
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  kernel/sched.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index f11a2a5..a492209 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -505,7 +505,7 @@ struct rq {
> >  
> >  	unsigned long cpu_power;
> >  
> > -	unsigned char idle_at_tick;
> > +	bool idle_at_tick;
> >  	/* For active balancing */
> >  	int post_schedule;
> >  	int active_balance;
> 
> Right, so the problem I have with using bool in structures is that
> sizeof(_Bool) is not well defined by the C standard and is
> implementation dependent, meaning the struct rq layout can change
> between gcc versions, architectures or even between optimization levels.
> 
> So for structures where the layout is relevant we must avoid bool.

Okay, zapped it stays then.

Thanks,

	Ingo
