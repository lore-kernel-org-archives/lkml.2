Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0IMIrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:47:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58900 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324Ab0IMIrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:47:09 -0400
Date: Mon, 13 Sep 2010 10:46:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nico Schottelius <nico-linux-20100709@schottelius.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, peterz@infradead.org, flo@xssn.at,
        lenb@kernel.org, jbarnes@virtuousgeek.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, rjw@sisk.pl, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] x86, tsc: Fix a preemption leak in
 restore_sched_clock_state()
Message-ID: <20100913084619.GC23741@elte.hu>
References: <1284150773.402.122.camel@laptop>
 <tip-55496c896b8a695140045099d4e0175cf09d4eae@git.kernel.org>
 <20100913074233.GA2674@schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913074233.GA2674@schottelius.org>
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


* Nico Schottelius <nico-linux-20100709@schottelius.org> wrote:

> Good morning,
> 
> tip-bot for Peter Zijlstra [Sat, Sep 11, 2010 at 07:49:07AM +0000]:
> > Commit-ID:  55496c896b8a695140045099d4e0175cf09d4eae
> > Gitweb:     http://git.kernel.org/tip/55496c896b8a695140045099d4e0175cf09d4eae
> > Author:     Peter Zijlstra <peterz@infradead.org>
> > AuthorDate: Fri, 10 Sep 2010 22:32:53 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sat, 11 Sep 2010 09:47:07 +0200
> > 
> > x86, tsc: Fix a preemption leak in restore_sched_clock_state()
> 
> running 2.6.36-rc3-00464-g84e1d83 now, which includes that fix.
> 
> So far no resume issues, but the backlight does not power on again,
> if the lid is opened.

That's probably unrelated.

> Manually triggering display backlight increase (via fn-home) changes 
> it to 100% though.
> 
> I've not seen that behaviour for a very long time and never on the 
> X201. It has been an issue on the X200, which means probably around 
> 2.6.30.

Might make sense to bisect it ... as long as you remember to do this at 
every bisection step that has the hung-suspend bug:

  git cherry-pick 55496c896b8a695140045099d4e0175cf09d4eae

Thanks,

	Ingo
