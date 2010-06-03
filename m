Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab0FCRZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:25:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34149 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab0FCRZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:25:40 -0400
Date: Thu, 3 Jun 2010 19:25:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hpa@zytor.com,
       mingo@elte.hu, tglx@linutronix.de, mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
Message-ID: <20100603172534.GF4166@basil.fritz.box>
References: <20100601172730.GB11880@basil.fritz.box> <4C05C722.1010804@redhat.com> <20100602085055.GA14221@basil.fritz.box> <4C061DAB.6000804@redhat.com> <20100603042051.GA5953@linux.vnet.ibm.com> <20100603103855.GG6822@laptop> <20100603120450.GH4035@linux.vnet.ibm.com> <20100603123832.GL6822@laptop> <20100603151730.GE4166@basil.fritz.box> <20100603153518.GP6822@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603153518.GP6822@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That would certainly be a part of it, I'm sure they have stronger
> fairness and guarantees at the expense of some performance. We saw the
> spinlock starvation first on 8-16 core Opterons I think, wheras Altix
> had been over 1024 cores and POWER7 1024 threads now apparently without
> reported problems.

I suppose P7 handles that in the HV through the pvcall.

Altix AFAIK has special hardware for this in the interconnect, 
but as individual nodes get larger and have more cores you'll start
seeing it there too.

In general we now have the problem that with increasing core counts
per socket each NUMA node can be a fairly large SMP by itself
and several of the old SMP scalability problems that were fixed
by having per node datastructures are back now.

For example this is a serious problem with the zone locks in some
workloads now on 8core+HT systems.

> So I think actively enforcing fairness at the lock level would be
> required. Something like if it is detected that a core is not making

I suppose how that exactly works is IBM's secret sauce. Anyways
as long as there are no reports I wouldn't worry about it.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
