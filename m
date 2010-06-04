Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab0FDIzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 04:55:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56437 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431Ab0FDIzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 04:55:47 -0400
Date: Fri, 4 Jun 2010 10:55:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Brian Swetland <swetland@google.com>
Cc: tytso@mit.edu, Neil Brown <neilb@suse.de>,
       Arve Hj?nnev?g <arve@android.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: suspend blockers & Android integration
Message-ID: <20100604085513.GE15181@elte.hu>
References: <20100603193045.GA7188@elte.hu>
 <AANLkTinsOF3wnxsruR0TvjBAQcHks4tf0ay_sM2xB_p4@mail.gmail.com>
 <20100604075722.GA15181@elte.hu>
 <AANLkTiksGnpL8tkcc5eScWHrGoijyZNUwZik5lXmU_TS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTiksGnpL8tkcc5eScWHrGoijyZNUwZik5lXmU_TS@mail.gmail.com>
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


* Brian Swetland <swetland@google.com> wrote:

> On Fri, Jun 4, 2010 at 12:57 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > * Brian Swetland <swetland@google.com> wrote:
> >>
> >> We started here because it's possibly the only api level change we have 
> >> -- almost everything else is driver or subarch type work or controversial 
> >> but entirely self-contained (like the binder, which I would be shocked to 
> >> see ever hit mainline). [...]
> >
> > So why arent those bits mainline? It's a 1000 times easier to get drivers 
> > and small improvements and non-ABI changes upstream.
> >
> > After basically two years of growing your fork (and some attempts to get 
> > your drivers into drivers/staging/ - from where they have meanwhile 
> > dropped out again) you re-started with the worst possible thing to merge: 
> > a big and difficult kernel feature affecting many subsystems. Why?
> 
> Because a large number of our drivers depend on it.

So why not put in some stub or so? Auto-suspend/suspend-blockers is a feature, 
and drivers ought to be able to work without a feature as well. Keep the 
suspend-blocker changes in the android tree initially, and get the main body 
of changes out first, and establish a flow of timely changes. That reduces 
your maintenance burden and increases trust for future changes - a win-win 
situation.

In any case, this is not to suggest that the suspend-blocker bits are 
'impossible' to merge. I just say that if you start with your most difficult 
feature you should not be surprised to be on the receiving end of a 1000+ 
mails flamewar on lkml ;-)

> > I've been tracking android-common and android-msm for a while and i have 
> > to say that it shows a very lackluster attitude towards upstream:
> >
> > ??- The latest branches i can see are v2.6.32 based today. We are in the 
> > ?? v2.6.35 stabilization cycle and are developing v2.6.36. I.e. your 
> > upstream ?? base is about a year too old.
> 
> We have some branch naming confusion and work going on in
> experimental, but our active work right now is against 2.6.34 and
> 2.6.35-rc. [...]

That's nice!

> [...]  The tegra2 work has been very aggressively following mainline 
> (rebasing against 2.6.34rc as they were getting underway), and we've been 
> sending those patches out for review, in hopes of getting that tree off on a 
> better foot.

Ah, googling for 'tegra2' gave me the magic URI:

  git remote add android-tegra2 git://android.git.kernel.org/kernel/tegra.git

I generally roam various trees for scheduler patches when i can, seeing what 
problems people are facing and trying to prevent more painful forks from 
developing. You have these changes there currently:

 d82647e: sched: make task dump print all 15 chars of proc comm
 5e3e0f1: sched: Enable might_sleep before initializing drivers.

Please submit 5e3e0f1. We can probably do that one even simpler, by turning 
__might_sleep_init_called into the only flag that __might_sleep() checks - 
i.e. not checking system_state at all.

Also, please submit d82647e, it makes sense too.

Thanks,

	Ingo
