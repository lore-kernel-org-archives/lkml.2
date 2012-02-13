Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730Ab2BMXlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 18:41:08 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60381 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab2BMXlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 18:41:06 -0500
Date: Mon, 13 Feb 2012 15:40:57 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH block/for-linus] block: blk-throttle should be drained
 regardless of q->elevator
Message-ID: <20120213234057.GI12117@google.com>
References: <20120213225248.GH12117@google.com>
 <20120213232742.GH3130@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120213232742.GH3130@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 13, 2012 at 06:27:42PM -0500, Vivek Goyal wrote:
> > -	/*
> > -	 * Drain all requests queued before DEAD marking.  The caller might
> > -	 * be trying to tear down @q before its elevator is initialized, in
> > -	 * which case we don't want to call into draining.
> > -	 */
> > -	if (q->elevator)
> > -		blk_drain_queue(q, true);
> > +	/* drain all requests queued before DEAD marking */
> 
> We have already marked the queue DEAD before we start draining the queue.
> May be we need to fix the comment.

Hmmm... it actually is correct.  It drains all requests which were
queued before the preceding DEAD marking.  ie... it's describing the
following.

	1. requests queued
	2. mark q DEAD
	3. drain requests which were queued before #2.  We don't care
	   about requests queued after #2.

Thanks.

-- 
tejun
