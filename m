Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab2JDSuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:50:17 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37767 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab2JDSuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:50:14 -0400
From: Anthony Liguori <aliguori@us.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Adam Litke <agl@us.ibm.com>,
        Amit Shah <amit.shah@redhat.com>, Avi Kivity <avi@redhat.com>,
        Avishay Traeger <AVISHAY@il.ibm.com>, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Pawel Moll <pawel.moll@arm.com>, Sasha Levin <levinsasha928@gmail.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [Qemu-devel] Proposal for virtio standardization.
In-Reply-To: <87zk4c2tqq.fsf@rustcorp.com.au>
References: <87zk4c2tqq.fsf@rustcorp.com.au>
User-Agent: Notmuch/0.13.2+93~ged93d79 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 04 Oct 2012 13:49:56 -0500
Message-ID: <874nmajcmj.fsf@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12100418-9264-0000-0000-000002721DF2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:

> Hi all,
>
> 	I've had several requests for a more formal approach to the
> virtio draft spec, and (after some soul-searching) I'd like to try that.
>
> 	The proposal is to use OASIS as the standards body, as it's
> fairly light-weight as these things go.  For me this means paperwork and
> setting up a Working Group and getting the right people involved as
> Voting members starting with the current contributors; for most of you
> it just means a new mailing list, though I'll be cross-posting any
> drafts and major changes here anyway.
>
> 	I believe that a documented standard (aka virtio 1.0) will
> increase visibility and adoption in areas outside our normal linux/kvm
> universe.  There's been some of that already, but this is the clearest
> path to accelerate it.  Not the easiest path, but I believe that a solid
> I/O standard is a Good Thing for everyone.
>
> 	Yet I also want to decouple new and experimental development
> from the standards effort; running code comes first.  New feature bits
> and new device numbers should be reservable without requiring a full
> spec change.
>
> So the essence of my proposal is:
> 1) I start a Working Group within OASIS where we can aim for virtio spec
>    1.0.
>
> 2) The current spec is textually reordered so the core is clearly
>    bus-independent, with PCI, mmio, etc appendices.
>
> 3) Various clarifications, formalizations and cleanups to the spec text,
>    and possibly elimination of old deprecated features.
>
> 4) The only significant change to the spec is that we use PCI
>    capabilities, so we can have infinite feature bits.
>    (see http://lists.linuxfoundation.org/pipermail/virtualization/2011-December/019198.html)

We discussed this on IRC last night.  I don't think PCI capabilites are
a good mechanism to use...

PCI capabilities are there to organize how the PCI config space is
allocated to allow vendor extensions to co-exist with future PCI
extensions.

But we've never used the PCI config space within virtio-pci.  We do
everything in BAR0.  I don't think there's any real advantage of using
the config space vs. a BAR for virtio-pci.

The nice thing about using a BAR is that the region is MMIO or PIO.
This maps really nicely to non-PCI transports too.  But extending the
PCI config space (especially dealing with capability allocation) is
pretty gnarly and there isn't an obvious equivalent outside of PCI.

There are very devices that we emulate today that make use of extended
PCI device registers outside the platform devices (that have no BARs).

Regards,

Anthony Liguori

>
> 5) Changes to the ring layout and other such things are deferred to a
>    future virtio version; whether this is done within OASIS or
>    externally depends on how well this works for the 1.0 release.
>
> Thoughts?
> Rusty.

