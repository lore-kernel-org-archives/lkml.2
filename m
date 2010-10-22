Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab0JVIyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:54:39 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:45212 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab0JVIyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:54:38 -0400
Message-ID: <4CC1515E.6080006@kernel.dk>
Date: Fri, 22 Oct 2010 10:54:54 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>
Subject: Re: linux-next regression: IO errors in with ext4 and xen-blkfront
References: <4CBF83A0.8090802@goop.org> <4CBF84C9.6050606@goop.org> <4CC148E5.2030605@kernel.dk> <20101022082916.GA14070@infradead.org>
In-Reply-To: <20101022082916.GA14070@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-22 10:29, Christoph Hellwig wrote:
> In the barriers tree Xen claims to support flushes, but I doesn't.
> It never handles REQ_FLUSH requests.  Try commenting out the
> 
> 	blk_queue_flush(info->rq, info->feature_flush);
> 
> call and things should improve.  I still need to hear back from Xen
> folks how to actually implement a cache flush - they only implement
> a barrier write privilegue which could never implement an empty
> cache flush.  Up to current kernels that meant it would implement
> barrier writes with content correctly and silently ignore empty barriers
> leading to very interesting data integrity bugs.  From 2.6.37 onwards
> it simply won't work anymore at all, which is at least consistent
> (modulo the bug of actually claiming to support flushes).

So how about we just disable barriers for Xen atm? I would really really
like to push that branch out as well now, since I'll be travelling for
most of the merge window this time.

-- 
Jens Axboe

