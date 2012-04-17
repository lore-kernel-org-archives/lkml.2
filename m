Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab2DQCzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 22:55:09 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:33196 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab2DQCzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 22:55:06 -0400
Date: Tue, 17 Apr 2012 08:24:16 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        the arch/x86 maintainers <x86@kernel.org>, KVM <kvm@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Attilio Rao <attilio.rao@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Subject: Re: [Xen-devel] [PATCH RFC V6 0/11] Paravirtualized ticketlocks
Message-ID: <20120417025416.GA10184@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com>
 <4F7616F5.4070000@zytor.com>
 <alpine.LFD.2.02.1203302333560.2542@ionos>
 <20120331040745.GC14030@linux.vnet.ibm.com>
 <20120416154429.GB4654@phenom.dumpdata.com>
 <1334594195.14560.236.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1334594195.14560.236.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12041702-2674-0000-0000-0000040E2F1D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ian Campbell <Ian.Campbell@citrix.com> [2012-04-16 17:36:35]:

> > > The current pv-spinlock patches however does not track which vcpu is
> > > spinning at what head of the ticketlock. I suppose we can consider 
> > > that optimization in future and see how much benefit it provides (over
> > > plain yield/sleep the way its done now).
> > 
> > Right. I think Jeremy played around with this some time?
> 
> 5/11 "xen/pvticketlock: Xen implementation for PV ticket locks" tracks
> which vcpus are waiting for a lock in "cpumask_t waiting_cpus" and
> tracks which lock each is waiting for in per-cpu "lock_waiting". This is
> used in xen_unlock_kick to kick the right CPU. There's a loop over only
> the waiting cpus to figure out who to kick.

Yes sorry that's right. We do track who is waiting on what lock at what
position. This can be used to pass directed yield hints to host
scheduler (in a future optimization patch). What we don't track is the
vcpu owning a lock, which would have allowed other spinning vcpus to do
a directed yield to vcpu preempted holding a lock. OTOH that may be
unnecessary if we put in support for deferring preemption of vcpu that
are holding locks.

- vatsa

