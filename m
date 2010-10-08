Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab0JHHvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:51:14 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:59316 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753565Ab0JHHvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:51:13 -0400
Date: Fri, 8 Oct 2010 18:51:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
Message-ID: <20101008075109.GU4681@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-12-git-send-email-david@fromorbit.com>
 <20101008073306.GD7831@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008073306.GD7831@lst.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 03:33:06AM -0400, Christoph Hellwig wrote:
> On Fri, Oct 08, 2010 at 04:21:25PM +1100, Dave Chinner wrote:
> > From: Nick Piggin <npiggin@suse.de>
> > 
> > Protect the inod hash with a single lock is not scalable.  Convert
> 
> s/inod/inode/
> 
> >  	p = &root->inode_tree.rb_node;
> >  	parent = NULL;
> >  
> > -	if (hlist_unhashed(&inode->i_hash))
> > +	if (hlist_bl_unhashed(&inode->i_hash))
> 
> Maybe introduce an inode_unhashed helper for this check which we're
> doing in quite a lot of places?

Ok, makes sense.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
