Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab1AUOCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 09:02:25 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40372 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab1AUOCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 09:02:16 -0500
Date: Fri, 21 Jan 2011 19:32:08 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        kvm@vger.kernel.org, suzuki@in.ibm.com
Subject: Re: [PATCH 2/3] kvm hypervisor : Add hypercalls to support
 pv-ticketlock
Message-ID: <20110121140208.GA13609@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
 <20110119164432.GA30669@linux.vnet.ibm.com>
 <20110119171239.GB726@linux.vnet.ibm.com>
 <1295457672.28776.144.camel@laptop>
 <4D373340.60608@goop.org>
 <20110120115958.GB11177@linux.vnet.ibm.com>
 <4D38774B.6070704@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D38774B.6070704@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 09:56:27AM -0800, Jeremy Fitzhardinge wrote:
> >  The key here is not to
> > sleep when waiting for locks (as implemented by current patch-series, which can 
> > put other VMs at an advantage by giving them more time than they are entitled 
> > to)
> 
> Why?  If a VCPU can't make progress because its waiting for some
> resource, then why not schedule something else instead?

In the process, "something else" can get more share of cpu resource than its 
entitled to and that's where I was bit concerned. I guess one could
employ hard-limits to cap "something else's" bandwidth where it is of real 
concern (like clouds).

> Presumably when
> the VCPU does become runnable, the scheduler will credit its previous
> blocked state and let it run in preference to something else.

which may not be sufficient for it to gain back bandwidth lost while blocked
(speaking of mainline scheduler atleast).

> > Is there a way we can dynamically expand the size of lock only upon contention
> > to include additional information like owning vcpu? Have the lock point to a
> > per-cpu area upon contention where additional details can be stored perhaps?
> 
> As soon as you add a pointer to the lock, you're increasing its size. 

I didn't really mean to expand size statically. Rather have some bits of the 
lock word store pointer to a per-cpu area when there is contention (somewhat 
similar to how bits of rt_mutex.owner are used). I haven't thought thr' this in
detail to see if that is possible though.

- vatsa
