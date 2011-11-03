Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab1KCE6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 00:58:38 -0400
Received: from ozlabs.org ([203.10.76.45]:57347 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab1KCE6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 00:58:37 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] virtio: support unlocked queue kick
In-Reply-To: <20111102072544.GA6967@infradead.org>
References: <20111005195403.407628164@bombadil.infradead.org> <20111005195529.964397366@bombadil.infradead.org> <87r52qgaf3.fsf@rustcorp.com.au> <20111006131828.GC19023@redhat.com> <20111101144045.GA15433@redhat.com> <87ty6ntdmf.fsf@rustcorp.com.au> <20111102072544.GA6967@infradead.org>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 03 Nov 2011 14:31:48 +1030
Message-ID: <874nylua4z.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Nov 2011 03:25:44 -0400, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Nov 02, 2011 at 01:49:36PM +1030, Rusty Russell wrote:
> > I thought it was still a WIP?
> 
> The whole series - yes.  This patch (and the serial number rewrite): no
> - these are pretty much rock solid.

OK, thanks.

> > Since the problem is contention on the lock inside the block layer, the
> > simplest solution is to have a separate lock to protect the virtqueue.
> 
> As long as we still use a ->request_fn based driver that is not going
> to buy us anything, in fact it's going to make things worse.

Of course...

> With the ->make_request_fn based driver vlkb->lock does't protect
> anything but the virtuequeue anyway, but not having to take it
> over the wakeup there is a) done easily and b) neatly fits the model.

It adds YA API though.  But I can't better it.  Doing the "should we
kick" check outside the lock is problematic, and doing it inside every
add() is inefficient.

So let's change the API for everyone, into:

        bool virtqueue_should_kick(struct virtqueue *vq);
        void virtqueue_kick(struct virtqueue *vq);

Patch series coming...

Thanks,
Rusty.
