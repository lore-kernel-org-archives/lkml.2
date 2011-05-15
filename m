Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759901Ab1EOMry (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 08:47:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713Ab1EOMrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 08:47:52 -0400
Date: Sun, 15 May 2011 15:47:27 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: Re: [PATCH 06/18] virtio_ring: avail event index interface
Message-ID: <20110515124727.GA24932@redhat.com>
References: <cover.1304541918.git.mst@redhat.com>
 <b00ef5d572ec9bc3b884c496025512abc1f14349.1304541919.git.mst@redhat.com>
 <87aaewh5pg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aaewh5pg.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 01:43:15PM +0930, Rusty Russell wrote:
> On Wed, 4 May 2011 23:51:19 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > Define a new feature bit for the host to
> > declare that it uses an avail_event index
> > (like Xen) instead of a feature bit
> > to enable/disable interrupts.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  include/linux/virtio_ring.h |   11 ++++++++---
> >  1 files changed, 8 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
> > index f5c1b75..f791772 100644
> > --- a/include/linux/virtio_ring.h
> > +++ b/include/linux/virtio_ring.h
> > @@ -32,6 +32,9 @@
> >  /* The Guest publishes the used index for which it expects an interrupt
> >   * at the end of the avail ring. Host should ignore the avail->flags field. */
> >  #define VIRTIO_RING_F_USED_EVENT_IDX	29
> > +/* The Host publishes the avail index for which it expects a kick
> > + * at the end of the used ring. Guest should ignore the used->flags field. */
> > +#define VIRTIO_RING_F_AVAIL_EVENT_IDX	32
> 
> Are you really sure we want to separate the two?  Seems a little simpler
> to have one bit to mean "we're publishing our threshold".  For someone
> implementing this from scratch, it's a little simpler.
> 
> Or are there cases where the old style makes more sense?
> 
> Thanks,
> Rusty.

Hmm, it makes debugging easier as each side can disable
publishing separately - I used it all the time when I saw
e.g. networking stuck to guess whether I need to investigate the
interrupt or the exit handling.

But I'm not hung up on this.

Let me know pls.

-- 
MST
