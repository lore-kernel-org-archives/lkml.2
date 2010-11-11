Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab0KKMxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:53:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38797 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154Ab0KKMw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:52:59 -0500
Date: Thu, 11 Nov 2010 07:52:54 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        mst@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.37-rc1, OOM] virtblk: OOM in do_virtblk_request()
Message-ID: <20101111125254.GB11194@infradead.org>
References: <20101105013003.GE13830@dastard>
 <20101110133151.GB2101@infradead.org>
 <201011111116.48263.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011111116.48263.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 11:16:48AM +1030, Rusty Russell wrote:
> On Thu, 11 Nov 2010 12:01:51 am Christoph Hellwig wrote:
> > Rusty, Michael,
> > 
> > any comments?  I think Dave's observation is correct, and the lack of
> > a mempool for allocations in the virtio stack is a no-go for virtio_blk.
> 
> Interesting.  virtio will try to fall back to using direct ring entries
> if it can, but if course if your request is too large it can never do that.
> 
> So, we could add a memory pool, or restrict the request size in virtio_blk.

The mempool looks like the more generic solution.  Especially as people
are still talking about swap over nfs, at which point virtio-net will
show the same issue (just even harder to reproduce)

