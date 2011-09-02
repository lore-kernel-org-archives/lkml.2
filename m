Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab1IBWlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 18:41:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43765 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376Ab1IBWlD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 18:41:03 -0400
Subject: Re: [PATCH 08/13] xen/pvticketlock: disable interrupts while
 blocking
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date: Sat, 03 Sep 2011 00:37:07 +0200
In-Reply-To: <4E614FBD.2030509@goop.org>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
	   <38bb37e15f6e5056d5238adac945bc1837a996ec.1314922370.git.jeremy.fitzhardinge@citrix.com>
	  <1314974826.1861.1.camel@twins> <4E612EA1.20007@goop.org>
	 <1314996468.8255.0.camel@twins> <4E614FBD.2030509@goop.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315003027.10110.2.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-02 at 14:50 -0700, Jeremy Fitzhardinge wrote:
> On 09/02/2011 01:47 PM, Peter Zijlstra wrote:
> > On Fri, 2011-09-02 at 12:29 -0700, Jeremy Fitzhardinge wrote:
> >>> I know that its generally considered bad form, but there's at least one
> >>> spinlock that's only taken from NMI context and thus hasn't got any
> >>> deadlock potential.
> >> Which one? 
> > arch/x86/kernel/traps.c:nmi_reason_lock
> >
> > It serializes NMI access to the NMI reason port across CPUs.
> 
> Ah, OK.  Well, that will never happen in a PV Xen guest.  But PV
> ticketlocks are equally applicable to an HVM Xen domain (and KVM guest),
> so I guess there's at least some chance there could be a virtual
> emulated NMI.  Maybe?  Does qemu do that kind of thing?

Afaik qemu/kvm can do the whole NMI thing, yes.

> But, erm, does that even make sense?  I'm assuming the NMI reason port
> tells the CPU why it got an NMI.  If multiple CPUs can get NMIs and
> there's only a single reason port, then doesn't that mean that either 1)
> they all got the NMI for the same reason, or 2) having a single port is
> inherently racy?  How does the locking actually work there?

I really wouldn't know, the whole NMI thing is a bit of a trainwreck
architecturally. Maybe the x86 maintainers or Linus knows more on this
aspect of it.


