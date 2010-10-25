Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174Ab0JYS35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:29:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43224 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab0JYS3z (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 25 Oct 2010 14:29:55 -0400
Date: Mon, 25 Oct 2010 14:26:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Christoph Hellwig <hch@infradead.org>, daniel.stodden@citrix.com
Cc: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: linux-next regression: IO errors in with ext4
 and xen-blkfront
Message-ID: <20101025182630.GA6036@dumpdata.com>
References: <4CBF83A0.8090802@goop.org>
 <4CBF84C9.6050606@goop.org>
 <4CC148E5.2030605@kernel.dk>
 <20101022082916.GA14070@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022082916.GA14070@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 04:29:16AM -0400, Christoph Hellwig wrote:
> In the barriers tree Xen claims to support flushes, but I doesn't.
> It never handles REQ_FLUSH requests.  Try commenting out the
> 
> 	blk_queue_flush(info->rq, info->feature_flush);
> 
> call and things should improve.  I still need to hear back from Xen
> folks how to actually implement a cache flush - they only implement

I think we just blindly assume that we would pass the request
to the backend. And if the backend is running under an ancient
version (2.6.18), the behavior would be quite different.

Perhaps we should negotiate with the backend whether it runs
under a kernel with the new barrier support? And if so, then enable
them? If the backend says it has no idea what we are talking about then
disable the barrier support?

How does that sound?

(Adding Daniel to this email thread as he has much more experience
than I do).

Daniel, what about the "use tagged queuing for barriers" patch you wrote
some time ago? Is it applicable to this issue?

> a barrier write privilegue which could never implement an empty
> cache flush.  Up to current kernels that meant it would implement
> barrier writes with content correctly and silently ignore empty barriers
> leading to very interesting data integrity bugs.  From 2.6.37 onwards
> it simply won't work anymore at all, which is at least consistent
> (modulo the bug of actually claiming to support flushes).
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
