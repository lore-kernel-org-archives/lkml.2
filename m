Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab2JUS7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 14:59:09 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55493 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474Ab2JUS7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 14:59:07 -0400
Date: Sun, 21 Oct 2012 11:56:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [ 12/37] block: fix request_queue->flags initialization
Message-ID: <20121021185618.GA5951@atj.dyndns.org>
References: <20121019031302.789593147@linuxfoundation.org>
 <20121019031304.836071629@linuxfoundation.org>
 <20121019231604.GF13292@decadent.org.uk>
 <20121021162529.GA25856@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121021162529.GA25856@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

On Sun, Oct 21, 2012 at 09:25:29AM -0700, Greg Kroah-Hartman wrote:
> > > commit 60ea8226cbd5c8301f9a39edc574ddabcb8150e0 upstream.
> > > 
> > > A queue newly allocated with blk_alloc_queue_node() has only
> > > QUEUE_FLAG_BYPASS set.  For request-based drivers,
> > > blk_init_allocated_queue() is called and q->queue_flags is overwritten
> > > with QUEUE_FLAG_DEFAULT which doesn't include BYPASS even though the
> > > initial bypass is still in effect.
> > > 
> > > In blk_init_allocated_queue(), or QUEUE_FLAG_DEFAULT to q->queue_flags
> > > instead of overwriting.
> > [...]
> > 
> > This is not needed, as there is no QUEUE_FLAG_BYPASS in 3.0.y.
> 
> Odd, it doesn't break the build.  And for some reason I just missed
> this, does it hurt to have it applied?

I don't think it will break anything as it simply changes assignment
to |= to avoid overwriting existing flags.  That said, any patch can
break anything, so if possible it would be better to drop for 3.0.y.

Thanks.

--
tejun
