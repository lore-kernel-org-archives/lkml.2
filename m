Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab0KKNQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 08:16:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489Ab0KKNQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 08:16:03 -0500
Date: Thu, 11 Nov 2010 15:15:42 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [2.6.37-rc1, OOM] virtblk: OOM in do_virtblk_request()
Message-ID: <20101111131542.GC25692@redhat.com>
References: <20101105013003.GE13830@dastard>
 <20101110133151.GB2101@infradead.org>
 <201011111116.48263.rusty@rustcorp.com.au>
 <20101111125254.GB11194@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101111125254.GB11194@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 07:52:54AM -0500, Christoph Hellwig wrote:
> On Thu, Nov 11, 2010 at 11:16:48AM +1030, Rusty Russell wrote:
> > On Thu, 11 Nov 2010 12:01:51 am Christoph Hellwig wrote:
> > > Rusty, Michael,
> > > 
> > > any comments?  I think Dave's observation is correct, and the lack of
> > > a mempool for allocations in the virtio stack is a no-go for virtio_blk.
> > 
> > Interesting.  virtio will try to fall back to using direct ring entries
> > if it can, but if course if your request is too large it can never do that.
> > 
> > So, we could add a memory pool, or restrict the request size in virtio_blk.

IMO size restriction is required anyway as host might not support
indirect buffers. So let's do that, and then add mempool if someone has
the time to profile and show the benefit.

> The mempool looks like the more generic solution.  Especially as people
> are still talking about swap over nfs, at which point virtio-net will
> show the same issue (just even harder to reproduce)

I don't think so - virtio-net does it correctly: it won't let you send
more packets than can fit in the ring.


-- 
MST
