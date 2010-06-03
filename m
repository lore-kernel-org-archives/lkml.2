Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab0FCFiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 01:38:10 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:44771 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab0FCFiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 01:38:08 -0400
Date: Thu, 3 Jun 2010 11:08:03 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, hpa@zytor.com, mingo@elte.hu, npiggin@suse.de,
       tglx@linutronix.de, mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
Message-ID: <20100603053803.GA4035@linux.vnet.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <87sk56ycka.fsf@basil.nowhere.org>
 <20100601162414.GA6191@redhat.com>
 <20100601163807.GA11880@basil.fritz.box>
 <4C053ACC.5020708@redhat.com>
 <20100601172730.GB11880@basil.fritz.box>
 <4C05C722.1010804@redhat.com>
 <20100602085055.GA14221@basil.fritz.box>
 <4C061DAB.6000804@redhat.com>
 <20100603042051.GA5953@linux.vnet.ibm.com>
 <1275540711.29413.63.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275540711.29413.63.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 06:51:51AM +0200, Eric Dumazet wrote:
> > Guest side:
> > 
> > static inline void spin_lock(spinlock_t *lock)
> > {
> > 	raw_spin_lock(&lock->rlock);
> > +       __get_cpu_var(gh_vcpu_ptr)->defer_preempt++;
> 
> 1) __this_cpu_inc() should be faster

Ok ..thx for that tip.

> 2) Isnt a bit late to do this increment _after_
> raw_spin_lock(&lock->rlock);

I think so, my worry about doing it earlier is we may set the defer_preempt hint
for the wrong vcpu (if lets say the guest application thread is preempted by
guest kernel and later migrated to another vcpu after it sets the hint and 
before it acquires the lock). 

- vatsa
