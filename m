Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab2JVPgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:36:13 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57332 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab2JVPgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:36:10 -0400
Date: Mon, 22 Oct 2012 08:36:06 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [ 12/37] block: fix request_queue->flags initialization
Message-ID: <20121022153606.GA13399@kroah.com>
References: <20121019031302.789593147@linuxfoundation.org>
 <20121019031304.836071629@linuxfoundation.org>
 <20121019231604.GF13292@decadent.org.uk>
 <20121021162529.GA25856@kroah.com>
 <20121021185618.GA5951@atj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121021185618.GA5951@atj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2012 at 11:56:18AM -0700, Tejun Heo wrote:
> Hello, Greg.
> 
> On Sun, Oct 21, 2012 at 09:25:29AM -0700, Greg Kroah-Hartman wrote:
> > > > commit 60ea8226cbd5c8301f9a39edc574ddabcb8150e0 upstream.
> > > > 
> > > > A queue newly allocated with blk_alloc_queue_node() has only
> > > > QUEUE_FLAG_BYPASS set.  For request-based drivers,
> > > > blk_init_allocated_queue() is called and q->queue_flags is overwritten
> > > > with QUEUE_FLAG_DEFAULT which doesn't include BYPASS even though the
> > > > initial bypass is still in effect.
> > > > 
> > > > In blk_init_allocated_queue(), or QUEUE_FLAG_DEFAULT to q->queue_flags
> > > > instead of overwriting.
> > > [...]
> > > 
> > > This is not needed, as there is no QUEUE_FLAG_BYPASS in 3.0.y.
> > 
> > Odd, it doesn't break the build.  And for some reason I just missed
> > this, does it hurt to have it applied?
> 
> I don't think it will break anything as it simply changes assignment
> to |= to avoid overwriting existing flags.  That said, any patch can
> break anything, so if possible it would be better to drop for 3.0.y.

Ok, I'll revert this and push out a 3.0.48 to be safe.

thanks,

greg k-h
