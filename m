Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab1EPLv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 07:51:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52299 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab1EPLv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 07:51:57 -0400
Date: Mon, 16 May 2011 13:51:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110516115148.GA2421@elte.hu>
References: <4DCC894D.3070204@kernel.org>
 <20110513084253.GE13647@elte.hu>
 <20110513121906.GA3676@elte.hu>
 <20110513130414.GA6863@elte.hu>
 <20110513131218.GA7669@elte.hu>
 <20110513141431.GV2258@linux.vnet.ibm.com>
 <20110513150744.GE32688@elte.hu>
 <20110513162646.GW2258@linux.vnet.ibm.com>
 <20110516070808.GC24836@elte.hu>
 <20110516074822.GE2573@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516074822.GE2573@linux.vnet.ibm.com>
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

> On Mon, May 16, 2011 at 09:08:08AM +0200, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > > Would it have been possible to split it in two, one for the movement of the 
> > > > notifiers, the other for the barrier changes?
> > > > 
> > > > That way the bisection would have fingered the movement commit. Or so.
> > > 
> > > In hindsight, that certainly would have been better.
> > 
> > This is the Linux kernel and we *can* turn back the clock!
> 
> Yay for source-code control systems in general and git in particular!  ;-)
> 
> > > I was afraid of that...
> > > 
> > > On the off-chance that moving the memory barriers was at fault, the following 
> > > patch restores all of them that don't have in situ replacements.  Grasping at 
> > > straws, admittedly.
> > 
> > Well, the nice thing is that we really do not have to grasp at straws, and even 
> > while we have no good ideas we can debug this *much* better.
> > 
> > Could you please do a simple test-tree that does has 3 commits:
> > 
> >  first one reverts the offending commit
> >  second one applies the barrier part of it
> >  this one applies the need_resched part of it
> > 
> > ( You can do even more finegrained steps, if you find harmless-looking bits of 
> >   it that can be applied separately! )
> > 
> > Note, the important thing is that the tree should be a 'null pull' - i.e. the 
> > revert plus the patches applied will not change anything in core/rcu.
> > 
> > Obviously it would be nice if each step built fine - no need to boot test each 
> > step as long as you are reasonably sure it will boot fine.
> > 
> > Then i could take my reproducer and come up with a very precise bisection 
> > result for you, with just a couple of minutes time spent on testing. One of the 
> > commits after the revert will trigger the hang/slowdown.
> > 
> > My prediction is that we will be much wiser after that! :-)
> 
> I will put this together!
> 
> In the meantime, would you be willing to try out the patch at
> https://lkml.org/lkml/2011/5/14/89?  This patch helped out Yinghai
> in several configurations.

Wasn't this the one i tested - or is it a new iteration?

I'll try it in any case.

If the bug is fixed for good then we can learn no more from it and then i'd 
suggest for you to not waste much time with a more finegrained queue :-)

Thanks,

	Ingo
