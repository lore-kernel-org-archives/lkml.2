Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab1KIKWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 05:22:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42346 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab1KIKWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 05:22:11 -0500
Subject: Re: [PATCH RFC] virtio-spec: flexible configuration layout
From: Sasha Levin <levinsasha928@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        avi@redhat.com
In-Reply-To: <20111109101814.GC20612@redhat.com>
References: <87wrbkvh3v.fsf@rustcorp.com.au>
	 <20111101114542.GA13434@redhat.com> <1320150813.3847.24.camel@lappy>
	 <20111101124223.GA14060@redhat.com> <8739e7uy87.fsf@rustcorp.com.au>
	 <20111102233110.GA20289@redhat.com> <20111108214021.GA4538@redhat.com>
	 <1320832502.31056.22.camel@lappy>  <20111109101814.GC20612@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 09 Nov 2011 12:20:17 +0200
Message-ID: <1320834017.31056.26.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 12:18 +0200, Michael S. Tsirkin wrote:
> On Wed, Nov 09, 2011 at 11:55:02AM +0200, Sasha Levin wrote:
> > On Tue, 2011-11-08 at 23:40 +0200, Michael S. Tsirkin wrote:
> > > Here's a spec change documenting what my C patch does
> > > (almost - I tweaked the layout a bit, but the idea is the same).
> > > Some more cleanups are needed but I thought I'd send it
> > > for early flames/comments.
> > > 
> > > The idea is simple: we split functionally unrelated
> > > register groups to independent structures, and let
> > > the device place is anywhere using a capability
> > > in PCI configuration space.
> > 
> > I'm also wondering it it's ok to move virtio configuration out of virtio
> > space and into PCI space for archs that don't have PCI (such as ARM).
> 
> A bit of confusion here: no register is moved from memory into
> configuration space. Configuration space only gains a list of
> pointers into memory/pio space.

The definition of the way the virtio configuration space looks is moved
into PCI configuration space, it was constant before.

> > Would it mean they get stuck with legacy configuration (and no new
> > features)? Or is there an alternative for them?
> 
> The change only affects the layout of virtio PCI. Arches that don't
> have PCI don't use virtio PCI, presumably?
> 
> BTW, the spec only covers x86 ATM, this needs to be fixed.

>From what I see there is a WIP by Pawel Moll <pawel.moll@arm.com> to add
virtio platform drivers which get virtio working on ARM for example, and
by Peter Maydell <peter.maydell@linaro.org> to modify the spec to
support MMIO access (besides PCI).

Maybe worth seeing if it works for them...

-- 

Sasha.

