Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab2BPI5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 03:57:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab2BPI5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 03:57:48 -0500
Date: Thu, 16 Feb 2012 10:57:41 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@redhat.com>, Rusty Russell <rusty@ozlabs.org>,
        qemu-devel <qemu-devel@nongnu.org>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
Message-ID: <20120216085741.GB19771@redhat.com>
References: <4F2AB552.2070909@redhat.com>
 <20120205093723.GQ23536@redhat.com>
 <4F2E4F8B.8090504@redhat.com>
 <20120205095153.GA29265@redhat.com>
 <4F2EAFF6.7030006@codemonkey.ws>
 <4F2F9E89.7090607@redhat.com>
 <87vcnih5qt.fsf@rustcorp.com.au>
 <4F3BB59D.2020505@redhat.com>
 <4F3C2AC5.80400@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3C2AC5.80400@codemonkey.ws>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 03:59:33PM -0600, Anthony Liguori wrote:
> On 02/15/2012 07:39 AM, Avi Kivity wrote:
> >On 02/07/2012 08:12 PM, Rusty Russell wrote:
> >>>I would really love to have this, but the problem is that we'd need a
> >>>general purpose bytecode VM with binding to some kernel APIs.  The
> >>>bytecode VM, if made general enough to host more complicated devices,
> >>>would likely be much larger than the actual code we have in the kernel now.
> >>
> >>We have the ability to upload bytecode into the kernel already.  It's in
> >>a great bytecode interpreted by the CPU itself.
> >
> >Unfortunately it's inflexible (has to come with the kernel) and open to
> >security vulnerabilities.
> 
> I wonder if there's any reasonable way to run device emulation
> within the context of the guest.  Could we effectively do something
> like SMM?
> 
> For a given set of traps, reflect back into the guest quickly
> changing the visibility of the VGA region. It may require installing
> a new CR3 but maybe that wouldn't be so bad with VPIDs.
> 
What will it buy us? Surely not speed. Entering a guest is not much
(if at all) faster than exiting to userspace and any non trivial
operation will require exit to userspace anyway, so we just added one
more guest entry/exit operation on the way to userspace.

> Then you could implement the PIT as guest firmware using kvmclock as the time base.
> 
> Once you're back in the guest, you could install the old CR3.
> Perhaps just hide a portion of the physical address space with the
> e820.
> 
> Regards,
> 
> Anthony Liguori
> 
> >>If every user were emulating different machines, LPF this would make
> >>sense.  Are they?
> >
> >They aren't.
> >
> >>Or should we write those helpers once, in C, and
> >>provide that for them.
> >
> >There are many of them: PIT/PIC/IOAPIC/MSIX tables/HPET/kvmclock/Hyper-V
> >stuff/vhost-net/DMA remapping/IO remapping (just for x86), and some of
> >them are quite complicated.  However implementing them in bytecode
> >amounts to exposing a stable kernel ABI, since they use such a vast
> >range of kernel services.
> >

--
			Gleb.
