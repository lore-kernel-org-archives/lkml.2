Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab0GOAF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 20:05:57 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:56014 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754050Ab0GOAF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 20:05:56 -0400
Date: Thu, 15 Jul 2010 10:05:52 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: don't block on buffer read errors
Message-ID: <20100715000552.GE30737@dastard>
References: <1279007450-10457-1-git-send-email-david@fromorbit.com>
 <1279007450-10457-2-git-send-email-david@fromorbit.com>
 <20100714182836.GA12108@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714182836.GA12108@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 02:28:36PM -0400, Christoph Hellwig wrote:
> Looks good, except that I'd rework the snipplet below
> 
> >  	status = xfs_buf_iorequest(bp);
> > -	if (!status && !(flags & XBF_ASYNC))
> > +	if (!(status || XFS_BUF_ISERROR(bp) || (flags & XBF_ASYNC)))
> >  		status = xfs_buf_iowait(bp);
> >  	return status;
> 
> as:
> 
> 	if (status || XFS_BUF_ISERROR(bp) || (flags & XBF_ASYNC))
> 		return status;
> 	return xfs_buf_iowait(bp);
> 
> to make it a bit more clear.

Make sense. Fixed it up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
