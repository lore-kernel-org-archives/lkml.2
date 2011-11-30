Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab1K3QOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 11:14:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757124Ab1K3QOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 11:14:22 -0500
Date: Wed, 30 Nov 2011 18:15:56 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
Message-ID: <20111130161555.GB25812@redhat.com>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com>
 <20111129131110.GC19157@redhat.com>
 <CAK=WgbZoGYVyKt=XXvnPVdh0koSBJC0zcgkLaYRkmjwBLOFA-A@mail.gmail.com>
 <20111129151607.GE30966@redhat.com>
 <CAK=WgbZK+k4uuyMPHUfr_PMyrR5ceRTvuDRpmhXfgwpSUOPw0g@mail.gmail.com>
 <20111130145958.GE21413@redhat.com>
 <CAK=WgbYyFdLftE_kp2_JOThVhn-FzGsDqVqKn0Jwm2teQyZBNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=WgbYyFdLftE_kp2_JOThVhn-FzGsDqVqKn0Jwm2teQyZBNA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 06:04:56PM +0200, Ohad Ben-Cohen wrote:
> On Wed, Nov 30, 2011 at 4:59 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > I see. And this happens because the ARM processor reorders
> > memory writes
> 
> Yes.
> 
> > And in an SMP configuration, writes are somehow not reordered?
> 
> They are, but then the smp memory barriers are enough to control these
> effects. It's not enough to control reordering as seen by a device
> (which is what our AMP processors are) though.
> 
> (btw, the difference between an SMP processor and a device here lies
> in how the memory is mapped: normal memory vs. device memory
> attributes. it's an ARM thingy).

How are the rings mapped? normal memory, right?
We allocate them with plan alloc_pages_exact in virtio_pci.c ...

> > Just checking that this is not a bug in the smp_wmb implementation
> > for the specific platform.
> 
> No, it's not.
> 
> ARM's smp memory barriers use ARM's DMB instruction, which is enough
> to control SMP effects, whereas ARM's mandatory memory barriers use
> ARM's DSB instruction, which is required to ensure the ordering
> between Device and Normal memory accesses.
> 
> Thanks,
> Ohad.

Yes wmb() is required to ensure ordering for MMIO.
But here both accesses: index and ring - are for
memory, not MMIO.

I could understand ring kick bypassing index write, maybe ...
But you described an index write bypassing descriptor write.
Is this something you see in practice?


-- 
MST
