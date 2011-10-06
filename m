Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492Ab1JFNnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:43:08 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59326
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757981Ab1JFNnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:43:06 -0400
Date: Thu, 6 Oct 2011 09:42:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Wright <chrisw@sous-sol.org>,
        Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] virtio-blk: implement ->make_request
Message-ID: <20111006134257.GB20190@infradead.org>
References: <20111005195403.407628164@bombadil.infradead.org>
 <20111005195530.558142038@bombadil.infradead.org>
 <87obxuga41.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87obxuga41.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 12:22:14PM +1030, Rusty Russell wrote:
> On Wed, 05 Oct 2011 15:54:08 -0400, Christoph Hellwig <hch@infradead.org> wrote:
> > Add an alternate I/O path that implements ->make_request for virtio-blk.
> > This is required for high IOPs devices which get slowed down to 1/5th of
> > the native speed by all the locking, memory allocation and other overhead
> > in the request based I/O path.
> 
> Ouch.
> 
> I'd be tempted to just switch across to this, though I'd be interested
> to see if the simple add_buf change I referred to before has some effect
> by itself (I doubt it).

Benchmarking this more extensively even on low-end devices is number
on my todo list after sorting out the virtqueue race and implementing
flush/fua support.  I'd really prefer to switch over to it
unconditionally if the performance numbers allow it.

> Also, though it's overkill I'd use standard list primitives rather than
> open-coding a single linked list.

I really prefer using standard helpers, but using a doubly linked list
and increasing memory usage seems like such a waste.  Maybe I should
annoy Linus by proposing another iteration of a common single linked
list implementation :)

