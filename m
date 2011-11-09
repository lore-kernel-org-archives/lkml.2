Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab1KIKrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 05:47:47 -0500
Received: from service87.mimecast.com ([91.220.42.44]:44460 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab1KIKrq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 05:47:46 -0500
Subject: Re: [PATCH RFC] virtio-spec: flexible configuration layout
From: Pawel Moll <pawel.moll@arm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Wang Sheng-Hui <shhuiw@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "avi@redhat.com" <avi@redhat.com>
In-Reply-To: <1320834017.31056.26.camel@lappy>
References: <87wrbkvh3v.fsf@rustcorp.com.au>
	 <20111101114542.GA13434@redhat.com> <1320150813.3847.24.camel@lappy>
	 <20111101124223.GA14060@redhat.com> <8739e7uy87.fsf@rustcorp.com.au>
	 <20111102233110.GA20289@redhat.com> <20111108214021.GA4538@redhat.com>
	 <1320832502.31056.22.camel@lappy>  <20111109101814.GC20612@redhat.com>
	 <1320834017.31056.26.camel@lappy>
Date: Wed, 09 Nov 2011 10:47:33 +0000
Message-ID: <1320835653.3259.138.camel@hornet.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 09 Nov 2011 10:47:34.0245 (UTC) FILETIME=[FD060950:01CC9ECC]
X-MC-Unique: 111110910473911301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 10:20 +0000, Sasha Levin wrote:
> > > I'm also wondering it it's ok to move virtio configuration out of virtio
> > > space and into PCI space for archs that don't have PCI (such as ARM).

Just a note - ARM-based chips can by all means have PCI (grep -r PCI
arch/arm/ ;-). The fact is that most of the SOCs available on the market
don't have it, but this is slowly changing.

The main architectural difference is that ARM doesn't provide separate
I/O space so the PCI I/O space is usually remapped somewhere into normal
address space (grep -r "#define __io_address" arch/arm/)
 
> > > Would it mean they get stuck with legacy configuration (and no new
> > > features)? Or is there an alternative for them?
> > 
> > The change only affects the layout of virtio PCI. Arches that don't
> > have PCI don't use virtio PCI, presumably?
> > 
> > BTW, the spec only covers x86 ATM, this needs to be fixed.
> 
> From what I see there is a WIP by Pawel Moll <pawel.moll@arm.com> to add
> virtio platform drivers which get virtio working on ARM for example, and
> by Peter Maydell <peter.maydell@linaro.org> to modify the spec to
> support MMIO access (besides PCI).

Yep, it's actually already in 3.2-rc1 (drivers/virtio/virtio_mmio.c) and
in the spec (see Appendix X). And actually the control registers layout
I used was originally based on the PCI "legacy" headers (slightly
simplified), but evolved a bit since. My understanding is that the
changes Michael is proposing affect the PCI device interface only so
they shouldn't affect "my" interface.

By the way, I vaguely remember Peter mentioning that he got the PCI
device "experimentally" running some time ago on one of the PCI-enabled
ARM platform models (realview or versatile)...

Cheers!

Pawel



