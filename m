Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab1EPHjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 03:39:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42860 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab1EPHji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 03:39:38 -0400
Date: Mon, 16 May 2011 09:39:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110516073928.GA23252@elte.hu>
References: <BANLkTin1haL+isnR0UUoHdNm99bnxYPt-g@mail.gmail.com>
 <20110514142621.GB2258@linux.vnet.ibm.com>
 <20110514153118.GA24311@linux.vnet.ibm.com>
 <20110514183453.GA32756@linux.vnet.ibm.com>
 <4DCF5322.7030305@kernel.org>
 <4DCF6789.70701@kernel.org>
 <4DCF696B.8020304@kernel.org>
 <20110515060415.GF2258@linux.vnet.ibm.com>
 <20110515065949.GA11330@linux.vnet.ibm.com>
 <20110516070849.GA20580@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516070849.GA20580@linux.vnet.ibm.com>
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

> > And the way you can prove that it is my code rather than the arch
> > code is to show that the warning happens on your system when the
> > irq_enter()/irq_exit() calls are perfectly nested.
> 
> So I took another look at the RCU debugfs stats you provided earlier,
> and realized that your system gets a lot more NMIs than do the ones
> that I have access to.  So as a diagnostic patch, I ifdefed out the
> body of rcu_nmi_enter() and rcu_nmi_exit().

Well, but the delays are occuring all the time (and it's bisectable) and NMIs 
are generally not deterministic.

I'd really suggest the creation of a revert + finegrained series on top of 
core/rcu which would IMHO help us narrow this down a lot more directly than 
jumping between the 'need_resched bug', 'nmi bug' and 'barrier bug' hypoteses.

( Btw., the bug still has the feeling of a need_resched/scheduling/timing 
  artifact to me, not barriers or NMI. )

Thanks,

	Ingo
