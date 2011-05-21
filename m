Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab1EUTOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 15:14:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46726 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab1EUTOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 15:14:32 -0400
Date: Sat, 21 May 2011 21:14:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
        Valdis.Kletnieks@vt.edu, a.p.zijlstra@chello.nl
Subject: Re: [GIT PULL rcu/next] fixes and breakup of memory-barrier-decrease
 patch
Message-ID: <20110521191418.GA30688@elte.hu>
References: <20110521140613.GA13062@linux.vnet.ibm.com>
 <20110521142844.GA29813@elte.hu>
 <20110521190830.GH2271@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110521190830.GH2271@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Sat, May 21, 2011 at 04:28:44PM +0200, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > Hello, Ingo,
> > > 
> > > This pull requests covers some RCU bug fixes and one patch rework.
> > > 
> > > The first group breaks up the infamous now-reverted (but ultimately
> > > vindicated) "Decrease memory-barrier usage based on semi-formal proof"
> > > commit into five commits.  These five commits immediately follow the
> > > revert, and the diff across all six of these commits is empty, so that
> > > the effect of the five commits is to revert the revert.
> > 
> > But ... the regression that was observed with that commit needs to be fixed 
> > first, or not? In what way was the barrier commit vindicated?
> 
> From what I can see, the hang was fixed by Frederic's patch at 
> https://lkml.org/lkml/2011/5/19/753.  I was interpreting that as vindication, 
> perhaps ill-advisedly.

I mean, without Frederic's patch we are getting very long hangs due to the 
barrier patch, right?

Even if the barrier patch is not to blame - somehow it still managed to produce 
these hangs - and we do not understand it yet.

> Yinghai said that he was still seeing a delay, adn that he was seeing it even 
> with the "Decrease memory-barrier usage based on semi-formal proof" reverted: 
> https://lkml.org/lkml/2011/5/20/427.  This hang seems to happen when he uses 
> gcc 4.5.0, but not when using gcc 4.5.1, assuming I understood his sequence 
> of emails.  So I was interpreting that as meaning that the delay was unlikely 
> to be caused by that commit, probably by one of the later commits.
> 
> I clearly need to figure out what is causing this delay.  I asked Yinghai to 
> apply c7a378603 (Remove waitqueue usage for cpu, node, and boost kthreads) 
> from Peter Zijlstra because the long delays that Yinghai is seeing (93 
> seconds for memory_dev_init() rather than 3 or 4 seconds) might be due to my 
> less-efficient method of awakening the RCU kthreads, so that Peter's 
> approache might help.
> 
> If that doesn't speed things up for Yinghai, then I will work out some 
> tracing to help localize the slowdown that he is seeing.
> 
> Of course, if you would rather that I get to the bottom of this before 
> pulling, fair enough!

We should fix the delay regression i suspect - do we have to revert more stuff 
perhaps?

Would it be possible to figure out what caused that other delay for Yinghai?

Thanks,

	Ingo
