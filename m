Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab1FFHI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 03:08:58 -0400
Received: from ozlabs.org ([203.10.76.45]:58831 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756033Ab1FFHIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 03:08:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: Re: [PATCHv2 RFC 0/4] virtio and vhost-net capacity handling
In-Reply-To: <20110602171721.GA13215@redhat.com>
References: <cover.1307029008.git.mst@redhat.com> <20110602171721.GA13215@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 06 Jun 2011 13:09:35 +0930
Message-ID: <87fwnniq6f.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jun 2011 20:17:21 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Thu, Jun 02, 2011 at 06:42:35PM +0300, Michael S. Tsirkin wrote:
> > OK, here's a new attempt to use the new capacity api.  I also added more
> > comments to clarify the logic.  Hope this is more readable.  Let me know
> > pls.
> > 
> > This is on top of the patches applied by Rusty.
> > 
> > Warning: untested. Posting now to give people chance to
> > comment on the API.
> > 
> > Changes from v1:
> > - fix comment in patch 2 to correct confusion noted by Rusty
> > - rewrite patch 3 along the lines suggested by Rusty
> >   note: it's not exactly the same but I hope it's close
> >   enough, the main difference is that mine does limited
> >   polling even in the unlikely xmit failure case.
> > - added a patch to not return capacity from add_buf
> >   it always looked like a weird hack
> > 
> > Michael S. Tsirkin (4):
> >   virtio_ring: add capacity check API
> >   virtio_net: fix tx capacity checks using new API
> >   virtio_net: limit xmit polling
> >   Revert "virtio: make add_buf return capacity remaining:
> > 
> >  drivers/net/virtio_net.c     |  111 ++++++++++++++++++++++++++----------------
> >  drivers/virtio/virtio_ring.c |   10 +++-
> >  include/linux/virtio.h       |    7 ++-
> >  3 files changed, 84 insertions(+), 44 deletions(-)
> > 
> > -- 
> > 1.7.5.53.gc233e
> 
> 
> And just FYI, here's a patch (on top) that I considered but
> decided against. This does a single get_buf before
> xmit. I thought it's not really needed as the capacity
> check in add_buf is relatively cheap, and we removed
> the kick in xmit_skb. But the point is that the loop
> will now be easy to move around if someone manages
> to show this benefits speed (which I doubt).

Agreed.  The other is clearer.

I like the approach these patches take.  Testing is required, but I
think the final result is a neater driver than the current one, as well
as having nicer latency.

Thanks,
Rusty.
