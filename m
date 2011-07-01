Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab1GAR3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 13:29:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45656 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756436Ab1GAR3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 13:29:50 -0400
Date: Fri, 1 Jul 2011 19:29:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL v2] sched: Make sleep inside atomic detection work on
 !PREEMPT
Message-ID: <20110701172934.GA6240@elte.hu>
References: <1307712622-11104-1-git-send-email-fweisbec@gmail.com>
 <20110622224844.GA3290@somewhere>
 <20110701123629.GA12605@elte.hu>
 <20110701125644.GD8508@somewhere>
 <20110701125926.GF12605@elte.hu>
 <20110701150517.GA24707@elte.hu>
 <20110701164425.GG8508@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701164425.GG8508@somewhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Fri, Jul 01, 2011 at 05:05:17PM +0200, Ingo Molnar wrote:
> > 
> > -tip testing also found that m32r fails to build:
> > 
> > /home/mingo/tip/kernel/sched.c: In function 'preempt_schedule':
> > /home/mingo/tip/kernel/sched.c:4364: error: implicit declaration of function 'add_preempt_count_notrace'
> > /home/mingo/tip/kernel/sched.c:4366: error: implicit declaration of function 'sub_preempt_count_notrace'
> > 
> > due to:
> > 
> > bdd4e85dc36cdbcfc1608a5b2a17c80a9db8986a is the first bad commit
> > commit bdd4e85dc36cdbcfc1608a5b2a17c80a9db8986a
> > Author: Frederic Weisbecker <fweisbec@gmail.com>
> > Date:   Wed Jun 8 01:13:27 2011 +0200
> > 
> >     sched: Isolate preempt counting in its own config option
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> I have no clue how that did happen.
> 
> Can you send me your config?

Just the m32r defconfig: m32700ut.smp_defconfig.

My guess would be that one of these:

 include/linux/bit_spinlock.h |    2 +-
 include/linux/hardirq.h      |    4 ++--
 include/linux/pagemap.h      |    4 ++--
 include/linux/preempt.h      |   26 +++++++++++++++++---------
 include/linux/rcupdate.h     |   12 ++++++------
 include/linux/sched.h        |    2 +-

changed/exposed some header dependency quirk on m32r, failing the 
build. Or m32r has some strange .config combo.

Thanks,

	Ingo
