Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab0FCOsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 10:48:24 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44582 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182Ab0FCOsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 10:48:23 -0400
Date: Thu, 3 Jun 2010 20:18:17 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Avi Kivity <avi@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
       mtosatti@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
Message-ID: <20100603144817.GA30321@linux.vnet.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20100601172730.GB11880@basil.fritz.box>
 <4C05C722.1010804@redhat.com>
 <20100602085055.GA14221@basil.fritz.box>
 <4C061DAB.6000804@redhat.com>
 <20100603042051.GA5953@linux.vnet.ibm.com>
 <20100603103855.GG6822@laptop>
 <20100603120450.GH4035@linux.vnet.ibm.com>
 <20100603123832.GL6822@laptop>
 <20100603125821.GJ4035@linux.vnet.ibm.com>
 <20100603134500.GN6822@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603134500.GN6822@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 11:45:00PM +1000, Nick Piggin wrote:
> > Ok got it - although that approach is not advisable in some cases for ex: when
> > the lock holder vcpu and lock acquired vcpu are scheduled on the same pcpu by
> > the hypervisor (which was experimented with in [1] where they foud a huge hit in
> > perf).
> 
> Sure but if you had adaptive yielding, that solves that problem.

I guess so.

> > Oops you are right - sorry should have checked more closely earlier. Given that
> > we may not be able to always guarantee that locked critical sections will not be
> > preempted (ex: when a real-time task takes over), we will need a combination of 
> > both approaches (i.e request preemption defer on lock hold path + yield on lock 
> > acquire path if owner !scheduled). The advantage of former approach is that it
> > could reduce job turnaround times in most cases (as lock is available when we 
> > want or we don't have to wait too long for it).
> 
> Both I think would be good. It might be interesting to talk with the
> s390 guys and see if they can look at ticket locks and preempt defer
> techniques too (considering they already do the other half of the
> equation well).

Martin/Heiko,
	Do you want to comment on this?

- vatsa
