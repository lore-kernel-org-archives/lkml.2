Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203Ab0KRULY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:11:24 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62826 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab0KRULW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:11:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tlwN4V5yJB9wyFuPd3C1c+ILNa4yQho85NbDs48Xdngvy/IvvGrr6StHOhcmi0/6bh
         XmMcBVYdPzj4XEtt39gauVqHXg+8NeQHPgUOowyQEYsiC1NUeR+qi+9ngIGsZ8dHNqLD
         jg6EmudfD1a0F8x4cthxDSPBORtL8lm129Zt4=
Date: Thu, 18 Nov 2010 23:11:18 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
Message-ID: <20101118201118.GC6028@lenovo>
References: <4CDD6CAD.30303@windriver.com> <20101112172755.GR4823@redhat.com> <20101116184325.GB4823@redhat.com> <4CE2E3C3.6060800@windriver.com> <20101118080516.GJ32621@elte.hu> <4CE52048.5080802@windriver.com> <1290086232.2109.1507.camel@laptop> <20101118193247.GF18100@redhat.com> <4CE583D0.8050407@windriver.com> <20101118200807.GC8131@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118200807.GC8131@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 03:08:07PM -0500, Don Zickus wrote:
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
> inside a guest.  Nor are the KVM folks having much success in doing so.
> 
> Just to clarify, perf counter emulation is _not_ implemented in kvm.
> Therefore disabling perf in the guest makes sense until someone gets
> around to actually writing the emulation code for perf in a guest. :-)
> 
> Cheers,
> Don

ok, Don, but you mentioned there are false alarms on real P4 machine, right?

 Cyrill
