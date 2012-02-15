Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab2BOPxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 10:53:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928Ab2BOPxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 10:53:31 -0500
Date: Wed, 15 Feb 2012 10:53:28 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH block/for-linus] block: blk-throttle should be drained
 regardless of q->elevator
Message-ID: <20120215155328.GC27312@redhat.com>
References: <20120213225248.GH12117@google.com>
 <20120213232742.GH3130@redhat.com>
 <20120213234057.GI12117@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120213234057.GI12117@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 03:40:57PM -0800, Tejun Heo wrote:
> Hello,
> 
> On Mon, Feb 13, 2012 at 06:27:42PM -0500, Vivek Goyal wrote:
> > > -	/*
> > > -	 * Drain all requests queued before DEAD marking.  The caller might
> > > -	 * be trying to tear down @q before its elevator is initialized, in
> > > -	 * which case we don't want to call into draining.
> > > -	 */
> > > -	if (q->elevator)
> > > -		blk_drain_queue(q, true);
> > > +	/* drain all requests queued before DEAD marking */
> > 
> > We have already marked the queue DEAD before we start draining the queue.
> > May be we need to fix the comment.
> 
> Hmmm... it actually is correct.  It drains all requests which were
> queued before the preceding DEAD marking.  ie... it's describing the
> following.
> 
> 	1. requests queued
> 	2. mark q DEAD
> 	3. drain requests which were queued before #2.  We don't care
> 	   about requests queued after #2.

Ok, thanks. I read the comment wrong. I thought of it as "drain all requests before marking queue DEAD". :-)

Thanks
Vivek
