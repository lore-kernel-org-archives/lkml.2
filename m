Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab2JHU3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 16:29:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab2JHU3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 16:29:31 -0400
Date: Mon, 8 Oct 2012 23:31:15 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
        Thomas Lendacky <tahm@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] virtio-net: inline header support
Message-ID: <20121008213114.GB17820@redhat.com>
References: <cover.1348824232.git.mst@redhat.com>
 <87vces2gxq.fsf@rustcorp.com.au>
 <87mx033u74.fsf@codemonkey.ws>
 <87391u3o67.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87391u3o67.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 01:04:56PM +0930, Rusty Russell wrote:
> Anthony Liguori <anthony@codemonkey.ws> writes:
> > Rusty Russell <rusty@rustcorp.com.au> writes:
> >
> >> "Michael S. Tsirkin" <mst@redhat.com> writes:
> >>
> >>> Thinking about Sasha's patches, we can reduce ring usage
> >>> for virtio net small packets dramatically if we put
> >>> virtio net header inline with the data.
> >>> This can be done for free in case guest net stack allocated
> >>> extra head room for the packet, and I don't see
> >>> why would this have any downsides.
> >>
> >> I've been wanting to do this for the longest time... but...
> >>
> >>> Even though with my recent patches qemu
> >>> no longer requires header to be the first s/g element,
> >>> we need a new feature bit to detect this.
> >>> A trivial qemu patch will be sent separately.
> >>
> >> There's a reason I haven't done this.  I really, really dislike "my
> >> implemention isn't broken" feature bits.  We could have an infinite
> >> number of them, for each bug in each device.
> >
> > This is a bug in the specification.
> >
> > The QEMU implementation pre-dates the specification.  All of the actual
> > implementations of virtio relied on the semantics of s/g elements and
> > still do.
> 
> lguest fix is pending in my queue.  lkvm and qemu are broken; lkvm isn't
> ever going to be merged, so I'm not sure what its status is?  But I'm
> determined to fix qemu, and hence my torture patch to make sure this
> doesn't creep in again.

If you look at my patch you'll notice there's also a
comment in virtio_net.h that seems to be broken in this respect:

/* This is the first element of the scatter-gather list.  If you don't
 * specify GSO or CSUM features, you can simply ignore the header. */

There is a similar comment in virtio-blk.
