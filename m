Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935772Ab1JFJSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 05:18:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932475Ab1JFJSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 05:18:36 -0400
Date: Thu, 6 Oct 2011 11:19:18 -0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Wright <chrisw@sous-sol.org>,
        Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] virtio: support unlocked queue kick
Message-ID: <20111006131828.GC19023@redhat.com>
References: <20111005195403.407628164@bombadil.infradead.org>
 <20111005195529.964397366@bombadil.infradead.org>
 <87r52qgaf3.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r52qgaf3.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 12:15:36PM +1030, Rusty Russell wrote:
> On Wed, 05 Oct 2011 15:54:05 -0400, Christoph Hellwig <hch@infradead.org> wrote:
> > Split virtqueue_kick to be able to do the actual notification outside the
> > lock protecting the virtqueue.  This patch was originally done by
> > Stefan Hajnoczi, but I can't find the original one anymore and had to
> > recreated it from memory.  Pointers to the original or corrections for
> > the commit message are welcome.
> 
> An alternative to this is to update the ring on every virtqueue_add_buf.
> MST discussed this for virtio_net, and I think it's better in general.
> 
> The only reason that it wasn't written that way originally is that the
> barriers make add_buf slightly more expensive.
> 
> Cheers,
> Rusty.

With event index, I'm not sure that's enough to make the kick lockless
anymore.


-- 
MST
