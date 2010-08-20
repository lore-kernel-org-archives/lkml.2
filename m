Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab0HTNTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 09:19:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41224 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724Ab0HTNTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 09:19:40 -0400
Date: Fri, 20 Aug 2010 15:19:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        peterz@infradead.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH  1/1] mutex: prevent optimistic spinning from spinning
 longer than neccessary (Repost)
Message-ID: <20100820131920.GC3321@elte.hu>
References: <1282168827.9542.72.camel@schen9-DESK>
 <20100819110511.GA16264@elte.hu>
 <1877.10.21.68.23.1282256686.squirrel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1877.10.21.68.23.1282256686.squirrel@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4540]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tim Chen <tim.c.chen@linux.intel.com> wrote:

> > Ingo wrote:
> >
> > These are some rather impressive speedups!
> >
> > Have you tried to see what performance effects this change has on
> smaller
> > boxes? Just to see what flip side (if any) this change has.
> >
> 
> I've done similar experiments with 2.6.35 kernel on smaller boxes.  One is
> on a dual-socket Westmere box (12 cores total, with HT). Another
> experiment is on an old dual-socket Core 2 box (4 cores total, no HT)
> 
> On the 12-core Westmere box, I see a 250% increase for Ingo's mutex-test
> program with my mutex patch but no significant difference in aim7's
> fserver workload.
> 
> On the 4-core Core 2 box, I see the difference with the patch for both
> mutex-test and aim7 fserver are negligible.

Great!

> So far, it seems like the patch has not caused regression on smaller 
> systems.  We'll put it through more workloads to check.

Thanks! The performance results you've posted so far IMO more than justifies 
its inclusion.

	Ingo
