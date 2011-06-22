Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab1FVCn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 22:43:58 -0400
Received: from ozlabs.org ([203.10.76.45]:34627 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757845Ab1FVCnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 22:43:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org
Cc: vapier@gentoo.org, linux-sh@vger.kernel.org,
        virtualization@lists.linux-foundation.org, horms@verge.net.au,
        mst@redhat.com, Magnus Damm <magnus.damm@gmail.com>,
        iws@ovro.caltech.edu, Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH 00/02][RESEND] virtio: Virtio platform driver
In-Reply-To: <20110621102605.1382.90232.sendpatchset@t400s>
References: <20110621102605.1382.90232.sendpatchset@t400s>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Wed, 22 Jun 2011 11:39:04 +0930
Message-ID: <87oc1q8vnj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jun 2011 19:26:05 +0900, Magnus Damm <magnus.damm@gmail.com> wrote:
> virtio: Virtio platform driver
> 
> [PATCH 01/02] virtio: Break out lguest virtio code to virtio_lguest.c
> [PATCH 02/02] virtio: Add virtio platform driver
> 
> These patches add a virtio platform driver to the Linux kernel. This
> platform driver has the same role as the virtio_pci driver, but instead
> of building on top of emulated PCI this driver is making use of the
> platform bus together with driver specific callbacks.
> 
> The virtio platform driver can be seen as a reusable implementation of
> the lguest virtio driver - in fact, most code is just taken directly
> from lguest_device.c and reworked to fit the platform device driver
> abstraction. The first patch breaks out code that can be shared between
> lguest and the virtio platform driver.
> 
> This code has been used to implement a mailbox interface between the
> two processor cores included in the sh7372 SoC. The sh7372 contains
> one ARM Cortex-A8 and one SH4AL-DSP core, and in the prototype two
> Linux kernels are running in parallel on the same chip. Virtio serves
> as a communication link between the two cores.

OK, this seems pretty neat, but I have three questions before we nail this
down (note that lguest doesn't have an ABI, so we can change it as much
as we want).

1) The lguest bus is dumb, and I never thought about device hotplug, for
   example.  It would be nice to handle that somehow.  Is it possible?
   Is this something you care about?

2) Have you seen the '[RFC 0/8] Introducing a generic AMP/IPC framework'
   patches?  Seems to overlap with what you're doing after these patches.

3) The S/390 layout is identical, except their struct kvm_vqconfig is a
   bit different.  Perhaps we should just use theirs (they use a 64-bit
   token instead of an interrupt number).

Christian?

Thanks,
Rusty.
