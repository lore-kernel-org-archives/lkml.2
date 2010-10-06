Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab0JFG31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 02:29:27 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:33917 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758571Ab0JFG3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 02:29:25 -0400
Date: Wed, 6 Oct 2010 17:29:21 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: dada1@cosmosbay.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] fs: inode per-cpu last_ino allocator
Message-ID: <20101006062921.GA32255@dastard>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-16-git-send-email-david@fromorbit.com>
 <20100930020759.GC1535@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930020759.GC1535@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 10:07:59PM -0400, Christoph Hellwig wrote:
> On Wed, Sep 29, 2010 at 10:18:47PM +1000, Dave Chinner wrote:
> > From: Eric Dumazet <dada1@cosmosbay.com>
> > 
> > last_ino was converted to an atomic variable to allow the inode_lock
> > to go away. However, contended atomics do not scale on large
> > machines, and new_inode() triggers excessive contention in such
> > situations.
> 
> And the good thing is most users of new_inode couldn't care less about
> the fake i_ino assigned because they have a real inode number.  So
> the first step is to move the i_ino assignment into a separate helper
> and only use it in those filesystems that need it.  Second step is
> to figure out why some filesystems need iunique() and some are fine
> with the incrementing counter and then we should find a scalable way
> to generate an inode number - preferably just one and not to, but if
> that's not possible we need some documentation on why which one is
> needed.

Sounds like a good plan, but I don't really have time right now to
understand the iget routines of every single filesystem to determine
which rely on the current new_inode() allocated inode number. I
think that is best left for a later cleanup, seeing as the
last_ino scalability problem is easily addressed....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
