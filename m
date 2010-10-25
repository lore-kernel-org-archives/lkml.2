Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869Ab0JYTGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 15:06:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28626 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760Ab0JYTGl (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 25 Oct 2010 15:06:41 -0400
Date: Mon, 25 Oct 2010 15:05:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Christoph Hellwig <hch@infradead.org>, daniel.stodden@citrix.com
Cc: Jens Axboe <axboe@kernel.dk>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, daniel.stodden@citrix.com
Subject: Re: [Xen-devel] Re: linux-next regression: IO errors in with ext4
 and xen-blkfront
Message-ID: <20101025190510.GA6452@dumpdata.com>
References: <4CBF83A0.8090802@goop.org>
 <4CBF84C9.6050606@goop.org>
 <4CC148E5.2030605@kernel.dk>
 <20101022082916.GA14070@infradead.org>
 <20101025182630.GA6036@dumpdata.com>
 <20101025184756.GA26230@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101025184756.GA26230@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 02:47:56PM -0400, Christoph Hellwig wrote:
> On Mon, Oct 25, 2010 at 02:26:30PM -0400, Konrad Rzeszutek Wilk wrote:
> > I think we just blindly assume that we would pass the request
> > to the backend. And if the backend is running under an ancient
> > version (2.6.18), the behavior would be quite different.
> 
> I don't think this has much to do with the backend.  Xen never
> implemented empty barriers correctly.  This has been a bug since day
> one, although before no one noticed because the cruft in the old
> barrier code made them look like they succeed without them actually
> succeeding.  With the new barrier code you do get an error back for
> them - and you do get them more often because cache flushes aka
> empty barriers are the only thing we send now.
> 
> The right fix is to add a cache flush command to the protocol which
> will do the right things for all guests.  In fact I read on a netbsd
> lists they had to do exactly that command to get their cache flushes
> to work, so it must exist for some versions of the backends.

Ok, thank you for the pointer.

Daniel, you are the resident expert, what do you say?

Jens, for 2.6.37 is the patch for disabling write barrier support
by the xen-blkfront the way to do it?

Or if we came up with a patch now would it potentially make it in
2.6.37-rcX (I don't know if the fix for this would qualify as a bug
or regression since it looks to be adding a new command)? And what
Christoph suggest that this has been in v2.6.36, v2.6.35, etc. so that
would definitly but it outside the regression definition.
