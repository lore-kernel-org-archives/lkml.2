Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab2JUQZM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 12:25:12 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54303 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab2JUQZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 12:25:07 -0400
Date: Sun, 21 Oct 2012 09:25:29 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [ 12/37] block: fix request_queue->flags initialization
Message-ID: <20121021162529.GA25856@kroah.com>
References: <20121019031302.789593147@linuxfoundation.org>
 <20121019031304.836071629@linuxfoundation.org>
 <20121019231604.GF13292@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019231604.GF13292@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2012 at 12:16:04AM +0100, Ben Hutchings wrote:
> On Thu, Oct 18, 2012 at 08:16:35PM -0700, Greg Kroah-Hartman wrote:
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Tejun Heo <tj@kernel.org>
> > 
> > commit 60ea8226cbd5c8301f9a39edc574ddabcb8150e0 upstream.
> > 
> > A queue newly allocated with blk_alloc_queue_node() has only
> > QUEUE_FLAG_BYPASS set.  For request-based drivers,
> > blk_init_allocated_queue() is called and q->queue_flags is overwritten
> > with QUEUE_FLAG_DEFAULT which doesn't include BYPASS even though the
> > initial bypass is still in effect.
> > 
> > In blk_init_allocated_queue(), or QUEUE_FLAG_DEFAULT to q->queue_flags
> > instead of overwriting.
> [...]
> 
> This is not needed, as there is no QUEUE_FLAG_BYPASS in 3.0.y.

Odd, it doesn't break the build.  And for some reason I just missed
this, does it hurt to have it applied?

greg k-h
