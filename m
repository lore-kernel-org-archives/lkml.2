Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab2BOP5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 10:57:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab2BOP5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 10:57:44 -0500
Date: Wed, 15 Feb 2012 10:57:40 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED block/for-linus] block: blk-throttle should be
 drained regardless of q->elevator
Message-ID: <20120215155740.GD27312@redhat.com>
References: <20120213225248.GH12117@google.com>
 <20120214011427.GJ12117@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214011427.GJ12117@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 05:14:27PM -0800, Tejun Heo wrote:

[..]
>  		/*
>  		 * This function might be called on a queue which failed
> -		 * driver init after queue creation.  Some drivers
> -		 * (e.g. fd) get unhappy in such cases.  Kick queue iff
> -		 * dispatch queue has something on it.
> +		 * driver init after queue creation or is not yet fully
> +		 * active yet.  Some drivers (e.g. fd and loop) get unhappy
> +		 * in such cases.  Kick queue iff dispatch queue has
> +		 * something on it and @q has request_fn set.
>  		 */
> -		if (!list_empty(&q->queue_head))
> +		if (!list_empty(&q->queue_head) && q->request_fn)
>  			__blk_run_queue(q);

Is it not a BUG() condition. We have a queue which has some requests
in it and we don't have q->request_fn?

Thanks
Vivek
