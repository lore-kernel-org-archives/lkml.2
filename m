Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab0FNXUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 19:20:21 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:42130 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752708Ab0FNXUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 19:20:19 -0400
Date: Tue, 15 Jun 2010 09:19:43 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, josef@redhat.com, jeffmerkey@gmail.com
Subject: Re: [PATCH 1/5] fsfreeze: Prevent emergency thaw from looping
 infinitely
Message-ID: <20100614231943.GH6590@dastard>
References: <1276154395-24766-1-git-send-email-david@fromorbit.com>
 <1276154395-24766-2-git-send-email-david@fromorbit.com>
 <20100614151815.GA32354@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614151815.GA32354@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 11:18:15AM -0400, Christoph Hellwig wrote:
> On Thu, Jun 10, 2010 at 05:19:50PM +1000, Dave Chinner wrote:
> > Return -EINVAL when the filesystem is already unfrozen to avoid this
> > problem.
> 
> 
> This includes some additional changes in addition to the description,
> and at least one of them seems incorrect.
> 
> > -	error = 0;
> > -	if (--bdev->bd_fsfreeze_count > 0)
> > +	if (!sb)
> >  		goto out;
> >  
> > -	if (!sb)
> > +	error = 0;
> > +	if (--bdev->bd_fsfreeze_count > 0)
> >  		goto out;
> 
> Here you reorder the sb check to be before the counter decrement.  But
> we do support calling freeze_bdev on a device without a superblock, and
> you would leak bd_fsfreeze_count for that case and wrongly return
> -EINVAL on unthaw for these now.

Ok, will fix it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
