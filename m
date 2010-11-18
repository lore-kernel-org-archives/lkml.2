Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223Ab0KRUab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:30:31 -0500
Received: from canuck.infradead.org ([134.117.69.58]:49252 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773Ab0KRUaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:30:30 -0500
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20101118200807.GC8131@redhat.com>
References: <20101112161144.GP4823@redhat.com>
	 <4CDD6CAD.30303@windriver.com> <20101112172755.GR4823@redhat.com>
	 <20101116184325.GB4823@redhat.com> <4CE2E3C3.6060800@windriver.com>
	 <20101118080516.GJ32621@elte.hu> <4CE52048.5080802@windriver.com>
	 <1290086232.2109.1507.camel@laptop> <20101118193247.GF18100@redhat.com>
	 <4CE583D0.8050407@windriver.com>  <20101118200807.GC8131@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 18 Nov 2010 21:30:33 +0100
Message-ID: <1290112234.2109.1534.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 15:08 -0500, Don Zickus wrote:
> On Thu, Nov 18, 2010 at 01:51:44PM -0600, Jason Wessel wrote:
> > > So the problem is when the nmi watchdog is enabled, the perf event is
> > > 'active' and thus tries to read the counter value.  Because it is always
> > > zero, perf just assumes the counter overflowed and the NMI is his.
> > >
> > > Not sure how to fix it yet, other than include the logic that detects we
> > > are on a guest and disable perf??
> > >
> > >   
> > 
> > I highly doubt we want to disable perf.   I would rather use the source
> > and fix the nmi emulation in KVM/Qemu after we hear back the results
> 
> Well I think Peter does not have a positive opinion about emulating perf
> inside a guest.  

Well, I'll let someone else write it.. I tihnk its pretty pointless to
have, the whole virt layer totally destroys many (if not all) useful
metrics.

But I don't have a problem with full msr emulation, what I do not like
is a direct msr passthough bypassing perf.

> Nor are the KVM folks having much success in doing so.

Just busy doing other stuff I guess.. Jes was going to prod at it at
some point.

> Just to clarify, perf counter emulation is _not_ implemented in kvm.
> Therefore disabling perf in the guest makes sense until someone gets
> around to actually writing the emulation code for perf in a guest. :-)

Right, which is what I proposed, on init do a checking_wrmsrl() on a
known PMU reg, KVM/qemu should fault on that.. (I'd prefer it if they'd
also fault on reading it too).


