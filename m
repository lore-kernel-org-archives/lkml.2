Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab1K2POj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 10:14:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504Ab1K2POi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 10:14:38 -0500
Date: Tue, 29 Nov 2011 17:16:07 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
Message-ID: <20111129151607.GE30966@redhat.com>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com>
 <20111129131110.GC19157@redhat.com>
 <CAK=WgbZoGYVyKt=XXvnPVdh0koSBJC0zcgkLaYRkmjwBLOFA-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=WgbZoGYVyKt=XXvnPVdh0koSBJC0zcgkLaYRkmjwBLOFA-A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 03:57:19PM +0200, Ohad Ben-Cohen wrote:
> On Tue, Nov 29, 2011 at 3:11 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > On Tue, Nov 29, 2011 at 02:31:26PM +0200, Ohad Ben-Cohen wrote:
> >> Virtio is using memory barriers to control the ordering of
> >> references to the vrings on SMP systems. When the guest is compiled
> >> with SMP support, virtio is only using SMP barriers in order to
> >> avoid incurring the overhead involved with mandatory barriers.
> >>
> >> Lately, though, virtio is being increasingly used with inter-processor
> >> communication scenarios too, which involve running two (separate)
> >> instances of operating systems on two (separate) processors, each of
> >> which might either be UP or SMP.
> >
> > Is that using virtio-mmio?
> 
> No, I'm using this:
> 
> https://lkml.org/lkml/2011/10/25/139

This mentions iommu - is there a need to use dma api to let
the firmware acess the rings? Or does it have access to all
of memory?

> > Sorry, could you pls explain what are 'two external processors'?
> > I think I know that if two x86 CPUs in an SMP system run kernels built
> > in an SMP configuration, smp_*mb barriers are enough.
> 
> Sure:
> 
> My setup is not SMP-based; it's two separate processors running in AMP
> configuration. The processors have completely different architectures,
> are not cache coherent, and only simply share some memory, which is
> used for communications using virtio as the shared memory "wire"
> protocol (i.e. we're not even doing virtualization: we have Linux on
> one processor, and some RTOS on another processor, and they use virtio
> to send and receive buffers).

I'd like to make sure I understand the memory model some more.
Is there cache snooping? If yes access from an external device
typically works mostly in the same way as smp ...


> So it's not SMP effects we're controlling; we're pretty much doing
> MMIO and must use mandatory barriers

So you put virtio rings in MMIO memory?

> (otherwise we see breakage).

Could you please give a couple of examples of breakage?

-- 
MST
