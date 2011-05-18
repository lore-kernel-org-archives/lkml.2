Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab1ERAp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 20:45:27 -0400
Received: from ozlabs.org ([203.10.76.45]:55906 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142Ab1ERApY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 20:45:24 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
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
In-Reply-To: <20110517060052.GB26989@redhat.com>
References: <cover.1304541918.git.mst@redhat.com> <b00ef5d572ec9bc3b884c496025512abc1f14349.1304541919.git.mst@redhat.com> <87aaewh5pg.fsf@rustcorp.com.au> <20110515124727.GA24932@redhat.com> <87k4drduzs.fsf@rustcorp.com.au> <20110517060052.GB26989@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Wed, 18 May 2011 09:38:24 +0930
Message-ID: <87wrhona4n.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 May 2011 09:00:52 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Mon, May 16, 2011 at 03:53:19PM +0930, Rusty Russell wrote:
> > On Sun, 15 May 2011 15:47:27 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > On Mon, May 09, 2011 at 01:43:15PM +0930, Rusty Russell wrote:
> > > > On Wed, 4 May 2011 23:51:19 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > >  #define VIRTIO_RING_F_USED_EVENT_IDX	29
> > > > > +/* The Host publishes the avail index for which it expects a kick
> > > > > + * at the end of the used ring. Guest should ignore the used->flags field. */
> > > > > +#define VIRTIO_RING_F_AVAIL_EVENT_IDX	32
> > > > 
> > > > Are you really sure we want to separate the two?  Seems a little simpler
> > > > to have one bit to mean "we're publishing our threshold".  For someone
> > > > implementing this from scratch, it's a little simpler.
> > > > 
> > > > Or are there cases where the old style makes more sense?
> > > > 
> > > > Thanks,
> > > > Rusty.
> > > 
> > > Hmm, it makes debugging easier as each side can disable
> > > publishing separately - I used it all the time when I saw
> > > e.g. networking stuck to guess whether I need to investigate the
> > > interrupt or the exit handling.
> > > 
> > > But I'm not hung up on this.
> > > 
> > > Let me know pls.
> > 
> > If we combine them into one, then these patches no longer depend on
> > the feature bit expansion, which is worthwhile (though I'll take both).
> > 
> > Thanks,
> > Rusty.
> 
> Yes, I know. But if we do expand feature bits anyway, for debugging
> and profiling if nothing else it's useful to have them separate ...
> If you take both why does the order matter?

Damage control.  Then if something breaks, it doesn't break everything.

Cheers,
Rusty.
