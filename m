Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab1CJTqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 14:46:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab1CJTqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 14:46:33 -0500
Date: Thu, 10 Mar 2011 14:46:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        hch@infradead.org, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 04/10] block: initial patch for on-stack per-task plugging
Message-ID: <20110310194625.GI29464@redhat.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
 <1295659049-2688-5-git-send-email-jaxboe@fusionio.com>
 <20110310165452.GE29464@redhat.com>
 <4D792735.8000604@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D792735.8000604@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 08:32:05PM +0100, Jens Axboe wrote:
> On 2011-03-10 17:54, Vivek Goyal wrote:
> > On Sat, Jan 22, 2011 at 01:17:23AM +0000, Jens Axboe wrote:
> > 
> > [..]
> >> -/*
> >> - * Only disabling plugging for non-rotational devices if it does tagging
> >> - * as well, otherwise we do need the proper merging
> >> - */
> >> -static inline bool queue_should_plug(struct request_queue *q)
> >> -{
> >> -	return !(blk_queue_nonrot(q) && blk_queue_tagged(q));
> >> -}
> >> -
> > 
> > Jens,
> > 
> > While discussing stack plug with Mike Snitzer, this occurred to us that in
> > new code we seem to be plugging even if underlying device is SSD with NCQ.
> > Should we continue to maintain the old behavior of not plugging for NCQ SSD?
> 
> The main reason plugging was turned off for SSD's previously was because
> it ended up hammering on the queue lock a lot. So it was turned off to
> speed them up.
> 
> The new plugging scheme is faster than hitting the queue directly, so
> now it would be a good idea to do the plugging in fact. Plus even for
> high performance SSD's, things like merging are still a good idea.
> 
> So yes, it's on now and on purpose.

Ok. Thanks for the explanation. That helps.

Vivek
