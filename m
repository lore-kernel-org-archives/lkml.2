Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab1JFNkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:40:53 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59305
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757769Ab1JFNkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:40:49 -0400
Date: Thu, 6 Oct 2011 09:40:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] block: add bio_map_sg
Message-ID: <20111006134021.GA20190@infradead.org>
References: <20111005195403.407628164@bombadil.infradead.org>
 <20111005195529.760114992@bombadil.infradead.org>
 <4E8CDF7B.7000601@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8CDF7B.7000601@panasas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 12:51:39AM +0200, Boaz Harrosh wrote:
> I have some questions.
> 
> - Could we later use this bio_map_sg() to implement blk_rq_map_sg() and
>   remove some duplicated code?

I didn't even think about that, but it actually looks very possible
to factor the "meat" in the for each bvec loop into a common helper
used by both.

> - Don't you need to support a chained bio (bio->next != NULL)? Because
>   I did not see any looping in the last patch 
> 	[PATCH 5/5] virtio-blk: implement ->make_request
>   Or is it that ->make_request() is a single bio at a time?
>   If so could we benefit from both bio-chaining and sg-chaning to
>   make bigger IOs?

At this point ->make_request is a single bio interface.  I have some
WIP patches to do the onstack plugging per bio, at which point it would
change to take a list.  For this to work we'd need major changes to
all ->make_request drivers.

