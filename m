Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab2JSXQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 19:16:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41838 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755090Ab2JSXQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 19:16:09 -0400
Date: Sat, 20 Oct 2012 00:16:04 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
Message-ID: <20121019231604.GF13292@decadent.org.uk>
References: <20121019031302.789593147@linuxfoundation.org>
 <20121019031304.836071629@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019031304.836071629@linuxfoundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 12/37] block: fix request_queue->flags initialization
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 08:16:35PM -0700, Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Tejun Heo <tj@kernel.org>
> 
> commit 60ea8226cbd5c8301f9a39edc574ddabcb8150e0 upstream.
> 
> A queue newly allocated with blk_alloc_queue_node() has only
> QUEUE_FLAG_BYPASS set.  For request-based drivers,
> blk_init_allocated_queue() is called and q->queue_flags is overwritten
> with QUEUE_FLAG_DEFAULT which doesn't include BYPASS even though the
> initial bypass is still in effect.
> 
> In blk_init_allocated_queue(), or QUEUE_FLAG_DEFAULT to q->queue_flags
> instead of overwriting.
[...]

This is not needed, as there is no QUEUE_FLAG_BYPASS in 3.0.y.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
