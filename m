Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab1GTT7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:59:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51581 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab1GTT7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:59:14 -0400
Date: Wed, 20 Jul 2011 21:57:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ben Greear <greearb@candelatech.com>, Ed Tomlinson <edt@aei.ca>,
        linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, edward.tomlinson@aero.bombardier.com
Subject: Re: [PATCH rcu/urgent 0/6] Fixes for RCU/scheduler/irq-threads
 trainwreck
Message-ID: <20110720195742.GA14671@elte.hu>
References: <20110720044435.GB2400@linux.vnet.ibm.com>
 <CA+55aFyaCY=qzFKswi2NR097KZtb5x98sba3rHJ7B0rchtzm2g@mail.gmail.com>
 <20110720133443.GG2400@linux.vnet.ibm.com>
 <4E270A0E.6090902@candelatech.com>
 <20110720171532.GB2313@linux.vnet.ibm.com>
 <20110720184413.GD17977@elte.hu>
 <1311187978.29152.58.camel@twins>
 <CA+55aFyuKTj3zEvWJEx4_RDzLQ+ipJ58UWFYH84nmcwGF_c4aA@mail.gmail.com>
 <20110720192949.GM2313@linux.vnet.ibm.com>
 <20110720193925.GB7910@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720193925.GB7910@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > If my guess is correct, then the minimal non-RCU_BOOST fix is #4 
> > (which drags along #3) and #6.  Which are not one-liners, but 
> > somewhat smaller:
> > 
> >  b/kernel/rcutree_plugin.h |   12 ++++++------
> >  b/kernel/softirq.c        |   12 ++++++++++--
> >  kernel/rcutree_plugin.h   |   31 +++++++++++++++++++++++++------
> >  3 files changed, 41 insertions(+), 14 deletions(-)
> 
> That's half the patch size and half the patch count.
> 
> PeterZ's question is relevant: since we apparently had similar bugs 
> in v2.6.39 as well, what changed in v3.0 that makes them so urgent 
> to fix?
> 
> If it's just better instrumentation that proves them better then 
> i'd suggest fixing this in v3.1 and not risking v3.0 with an 
> unintended side effect.

Ok, i looked some more at the background and the symptoms that people 
are seeing: kernel crashes and lockups. I think we want these 
problems fixed in v3.0, even if it was the recent introduction of 
RCU_BOOST that made it really prominent.

Having put some testing into your rcu/urgent branch today i'd feel 
more comfortable with taking this plus perhaps an RCU_BOOST disabling 
patch. That makes it all fundamentally tested by a number of people 
(including those who reported/reproduced the problems).

Linus, would that approach be fine with you? I'll send an RFC pull 
request for the 6 patches as a reply to this mail, in a couple of 
minutes.

Thanks,

	Ingo
