Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab1KWI2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 03:28:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab1KWI2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 03:28:43 -0500
Date: Wed, 23 Nov 2011 10:30:06 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 5 of 5] virtio: expose added descriptors immediately
Message-ID: <20111123083005.GD22734@redhat.com>
References: <f3831c1617c86a51d875.1320306173@localhost6.localdomain6>
 <20111113210256.GA31621@redhat.com>
 <20111114065606.GA3779@redhat.com>
 <871ut8q5mh.fsf@rustcorp.com.au>
 <20111116071838.GE5433@redhat.com>
 <8739dib5z6.fsf@rustcorp.com.au>
 <20111121115702.GA27580@redhat.com>
 <87lir9xagv.fsf@rustcorp.com.au>
 <20111122062907.GB11012@redhat.com>
 <87ty5v1vqy.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ty5v1vqy.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 11:49:01AM +1030, Rusty Russell wrote:
> On Tue, 22 Nov 2011 08:29:08 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Tue, Nov 22, 2011 at 11:03:04AM +1030, Rusty Russell wrote:
> > > -	/* If you haven't kicked in this long, you're probably doing something
> > > -	 * wrong. */
> > > -	WARN_ON(vq->num_added > vq->vring.num);
> > > +	/* This is very unlikely, but theoretically possible.  Kick
> > > +	 * just in case. */
> > > +	if (unlikely(vq->num_added == 65535))
> > 
> > This is 0xffff but why use the decimal notation?
> 
> Interesting.  Why use hex?  Feels more like binary?

Just easier to see it's the largest 16 bit number.

> But I've changed it to "(1 << 16) - 1" to be clear.

That's even better.

> > > +		virtqueue_kick(_vq);
> > >  
> > >  	pr_debug("Added buffer head %i to %p\n", head, vq);
> > >  	END_USE(vq);
> > 
> > We also still need to reset vq->num_added, right?
> 
> virtqueue_kick does that for us.
> 
> Cheers,
> Rusty.

Right.
