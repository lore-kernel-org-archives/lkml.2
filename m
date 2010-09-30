Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab0I3AYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 20:24:55 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:50639 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750873Ab0I3AYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 20:24:55 -0400
Date: Thu, 30 Sep 2010 10:24:50 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/17] fs: Inode cache scalability
Message-ID: <20100930002450.GT5665@dastard>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <20100929235716.GA18423@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100929235716.GA18423@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 07:57:16PM -0400, Christoph Hellwig wrote:
> On Wed, Sep 29, 2010 at 10:18:32PM +1000, Dave Chinner wrote:
> > I've only ported the patches so far, without changing anything
> > significant other than the comit descriptions. One thing that has
> > stood out as I've done this is that the ordering of the patches is
> > not ideal, and some things (like the inode counters) are modified
> > multiple times through the patch set.  I'm quite happy to
> > reorder/rework the series to fix these problems if that is desired.
> 
> There's two obvious ordering issues: first the inode counters that you
> mentioned.  I think this is esialy fixed by simply dropping both batches
> messing with it - we should have the new locks protecting it in places once
> inode_lock is dropped.  The other one is the clean up inode reference
> counting patch, which sounds like it should be earlier in the series so
> that we have the helpers in place before touching all places that
> opencode an inode reference count increment.

Yeah, I thought you'd want that. ;) I'll reorder the iget helper
patch to be the first in the series which should reduce churn quite
a bit, and then convert both the nr_inode and nr_unused counters to
be per-cpu before any of the other modifications and so they can be
ignored completely in later patches.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
