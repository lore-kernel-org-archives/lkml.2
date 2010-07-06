Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0GFGr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 02:47:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50835 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab0GFGrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 02:47:55 -0400
Date: Tue, 6 Jul 2010 08:47:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bill Davidsen <davidsen@tmr.com>, Jens Axboe <axboe@kernel.dk>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] Crash in wb_clear_pending()
Message-ID: <20100706064733.GA12382@elte.hu>
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com>
 <20100705085550.GA26775@elte.hu>
 <20100705164022.GA26995@infradead.org>
 <20100705171125.GB26202@elte.hu>
 <20100705171420.GA29697@elte.hu>
 <20100705182003.GA12332@infradead.org>
 <4C323177.3070606@kernel.dk>
 <4C324C78.5090805@tmr.com>
 <AANLkTinLrbQNv9uKYZCAKS-kFPSdle3fvAMzjI77BCu2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinLrbQNv9uKYZCAKS-kFPSdle3fvAMzjI77BCu2@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Jul 5, 2010 at 2:19 PM, Bill Davidsen <davidsen@tmr.com> wrote:
> >
> > Absent a small fix, and given that the big fix has a lot more testing than
> > any new patch might, in this case the quickie might be undesirable.
> > Particularly since posters here seem sure that code will be replaced in the
> > next version anyway, and lightly tested patch to obsolete code is actually
> > less conservative.
> 
> I have to agree. Especially as the "big patch" just removes the fragile code 
> that caused the problem in the first place. So in this case I do suspect 
> that the bigger patch ends up being the safer one.

Yeah, i agree - especially since the smaller patch is still pretty large (not 
a oneliner), plus it does not appear that the precise failure mode is fully 
understood either.

> But I obviously don't actually see the problem, so it would be good to get 
> confirmation that Christoph's patch actually fixes things first. Ingo, does 
> the one in this thread apply for you?

Yes, the three larger patches survived overnight testing with 300+ iterations 
and i did some other tests as well, which passed too. These are the patches i 
applied:

 a73dd720  writeback: remove writeback_inodes_wbc
 9f98c0fa  writeback: split writeback_inodes_wb
 79338d2a  writeback: simplify the write back thread queue

Thanks,

	Ingo
