Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab2AaOam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 09:30:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33296 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab2AaOal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 09:30:41 -0500
Date: Tue, 31 Jan 2012 15:30:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, arjanvandeven@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: x86: clean up smpboot.c's use of udelay+schedule
Message-ID: <20120131143022.GE13676@elte.hu>
References: <20120130205304.0e10b05e@infradead.org>
 <20120131124341.GC4408@elte.hu>
 <20120131053236.3f120f11@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120131053236.3f120f11@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Tue, 31 Jan 2012 13:43:41 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> > > +			usleep_range(100, 200);
> > 
> > I'm wondering whether we could shorten this delay to say 10 
> > usecs and thus save 0.1 msecs (or more) from a typical SMP 
> > bootup?
> 
> doesn't matter really; [...]

It matters somewhat, especially if PeterZ's suggestion is used, 
which is far more clean as well. The magic delays are not really 
justified anymore.

> [...] bringing up a cpu is several orders more expensive (> 
> 100msec in 3.2, in 3.3 this got optimized to maybe 30 msec) 
> 0.1 msec is the least of anyone's worries at this point ;-)

It's 3% of the 30 msecs overhead.

> ( would be nice if this was a completion, but this is rather 
> fragile code in general... at least not making it spin is an 
> incremental improvement )

Completions arent hard to use and the scheduler should be up and 
running at this stage already.

Thanks,

	Ingo
