Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab1KCHjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 03:39:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54183 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab1KCHjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 03:39:04 -0400
Date: Thu, 3 Nov 2011 08:37:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: REGRESSION: "perf: Add PM notifiers ..." breaks resume
Message-ID: <20111103073725.GA7319@elte.hu>
References: <20111102134900.GB4377@one.firstfloor.org>
 <CA+55aFwCf41GFOVA656-ZgZB5mBNkpH3KqRfJ_Ornkn3RWF5gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwCf41GFOVA656-ZgZB5mBNkpH3KqRfJ_Ornkn3RWF5gQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Peter, Ingo, ping?
> 
> Quite frankly, I'm inclined to revert that patch just for being 
> horribly ugly and apparently broken regardless of the fact that it 
> also causes a regression.
> 
> *Notifiers* for doing something like this? smp_call_function? 
> That's just utter sh*t, guys.
> 
> If it is CPU state, then it should damn well be suspended and 
> resumed as part of CPU suspend and resume. No IPI cross-calls to 
> ask other CPU's to do random work, no crap like that.

Agreed, that's quite crappy.

> Comments? Should I just revert the thing (silence is obviously 
> "yes" in cases like this where we are talking about regressions 
> anyway)?

Yep, please revert it until we do the right fix. (I can queue up the 
revert too)

Thanks,

	Ingo
