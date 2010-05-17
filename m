Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab0EQXfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:35:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:51817 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab0EQXft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:35:49 -0400
Date: Tue, 18 May 2010 01:35:41 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, akpm@linux-foundation.org,
       npiggin@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100517233540.GM3364@quack.suse.cz>
References: <20100512212403.GE3597@localhost.localdomain>
 <20100513013926.GD27011@dhcp231-156.rdu.redhat.com>
 <20100514010042.GI13617@dastard>
 <20100514033057.GL27011@dhcp231-156.rdu.redhat.com>
 <20100514064145.GJ13617@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514064145.GJ13617@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 14-05-10 16:41:45, Dave Chinner wrote:
...
> Well, the "RESERVE" callout I proposed should mean that the
> allocation that follows the copy should never fail with ENOSPC. i.e.
> if there isn't space, the RESERVE call will fail with ENOSPC, not
> the actual ALLOCATE call that occurs after the data is copied.
> 
> Basically I was thinking that in the XFS case, RESERVE would scan the
> range for holes, and reserve all blocks needed to fill all the holes
> in the range. Then the ALLOCATE call would mark them all delalloc.
> The space reservation and delalloc is done in a single call right
> now, but splitting them is not hard...
  But this would mean that you would have to implement at least a basic
delayed allocation support for filesystems like ext2, ext3, udf, vfat, etc.
They currently do not have a way to provide a functionality you require
from RESERVE call...
  Not that it would be so hard to do - I actually have some patches for
ext2/3 doing that because of problems with ENOSPC during mmaped writes but
it's not completely trivial either.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
