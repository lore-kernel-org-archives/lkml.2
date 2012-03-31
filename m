Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab2CaAIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 20:08:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58601 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2CaAIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 20:08:46 -0400
Date: Sat, 31 Mar 2012 02:08:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>
Subject: Re: [PATCH RFC V6 0/11] Paravirtualized ticketlocks
Message-ID: <20120331000843.GO17822@one.firstfloor.org>
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com> <4F7616F5.4070000@zytor.com> <alpine.LFD.2.02.1203302333560.2542@ionos> <20120330221836.GN17822@one.firstfloor.org> <alpine.LFD.2.02.1203310044580.2542@ionos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1203310044580.2542@ionos>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 01:04:41AM +0200, Thomas "Kubys" Gleixner wrote:
> On Sat, 31 Mar 2012, Andi Kleen wrote:
> 
> > > So if a guest exits due to an external event it's easy to inspect the
> > > state of that guest and avoid to schedule away when it was interrupted
> > > in a spinlock held section. That guest/host shared state needs to be
> > 
> > On a large system under high contention sleeping can perform surprisingly
> > well. pthread mutexes have a tendency to beat kernel spinlocks there.
> > So avoiding sleeping locks completely (that is what pv locks are
> > essentially) is not necessarily that good.
> 
> Care to back that up with numbers and proper trace evidence instead of
> handwaving?

E.g. my plumbers presentations on lock and mm scalability from last year has some 
graphs that show this very clearly, plus some additional data on the mutexes. 
This compares to the glibc futex locks, which perform much better than the kernel 
mutex locks on larger systems under higher contention

Given your tone I will not supply an URL. I'm sure you can find it if you
need it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
