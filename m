Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab2HaSlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 14:41:07 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48044 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab2HaSlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 14:41:04 -0400
X-Originating-IP: 217.70.178.150
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 11:40:56 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 12/15] rcu: Remove redundant memory barrier
 from __call_rcu()
Message-ID: <20120831184055.GL4259@jtriplet-mobl1>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-12-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120831183035.GJ4259@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120831183035.GJ4259@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 11:30:35AM -0700, Josh Triplett wrote:
> On Thu, Aug 30, 2012 at 11:56:25AM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > 
> > The first memory barrier in __call_rcu() is supposed to order any
> > updates done beforehand by the caller against the actual queuing
> > of the callback.  However, the second memory barrier (which is intended
> > to order incrementing the queue lengths before queuing the callback)
> > is also between the caller's updates and the queuing of the callback.
> > The second memory barrier can therefore serve both purposes.
> > 
> > This commit therefore removes the first memory barrier.
> 
> I don't see any such second memory barrier in __call_rcu(), at least not
> in current master.  Right after this smp_mb(), __call_rcu() enqueues the
> callback and increments the queue length.
> 
> Did you add a second memory barrier in some other patch that hasn't made
> it upstream yet?  If so, could you note that patch dependency explicitly
> in the commit message?

Argh, nevermind.  Looked at the wrong branch, not master.  Looking at
master, I do indeed see the second smp_mb().

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
