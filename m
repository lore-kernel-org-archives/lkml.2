Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab0ERBVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 21:21:33 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:42709 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754422Ab0ERBVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 21:21:30 -0400
Date: Tue, 18 May 2010 11:21:19 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, akpm@linux-foundation.org,
       npiggin@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100518012119.GB2150@dastard>
References: <20100512212403.GE3597@localhost.localdomain>
 <20100513013926.GD27011@dhcp231-156.rdu.redhat.com>
 <20100514010042.GI13617@dastard>
 <20100514033057.GL27011@dhcp231-156.rdu.redhat.com>
 <20100514064145.GJ13617@dastard>
 <20100517233540.GM3364@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100517233540.GM3364@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 01:35:41AM +0200, Jan Kara wrote:
> On Fri 14-05-10 16:41:45, Dave Chinner wrote:
> ...
> > Well, the "RESERVE" callout I proposed should mean that the
> > allocation that follows the copy should never fail with ENOSPC. i.e.
> > if there isn't space, the RESERVE call will fail with ENOSPC, not
> > the actual ALLOCATE call that occurs after the data is copied.
> > 
> > Basically I was thinking that in the XFS case, RESERVE would scan the
> > range for holes, and reserve all blocks needed to fill all the holes
> > in the range. Then the ALLOCATE call would mark them all delalloc.
> > The space reservation and delalloc is done in a single call right
> > now, but splitting them is not hard...
>   But this would mean that you would have to implement at least a basic
> delayed allocation support for filesystems like ext2, ext3, udf, vfat, etc.
> They currently do not have a way to provide a functionality you require
> from RESERVE call...

I don't think that's necessary. For filesytems that don't do
multipage writes (i.e. continue to operate as they do now) then
RSERVE/UNRESERVE can effectively be a no-op as there is nothing
extra to reserve or undo if the single page allocation fails.  Hence
filesystems that can't easily be converted or we don't want to put
the effort into converting to multi-page writes do not need any new
functionality....

>   Not that it would be so hard to do - I actually have some patches for
> ext2/3 doing that because of problems with ENOSPC during mmaped writes but
> it's not completely trivial either.

Yup, and a good reason for not trying to retrofit delayed allocation to
all those old filesystems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
