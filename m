Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab0I3CID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 22:08:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39033 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab0I3CIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 22:08:01 -0400
Date: Wed, 29 Sep 2010 22:07:59 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>, dada1@cosmosbay.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] fs: inode per-cpu last_ino allocator
Message-ID: <20100930020759.GC1535@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-16-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285762729-17928-16-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 10:18:47PM +1000, Dave Chinner wrote:
> From: Eric Dumazet <dada1@cosmosbay.com>
> 
> last_ino was converted to an atomic variable to allow the inode_lock
> to go away. However, contended atomics do not scale on large
> machines, and new_inode() triggers excessive contention in such
> situations.

And the good thing is most users of new_inode couldn't care less about
the fake i_ino assigned because they have a real inode number.  So
the first step is to move the i_ino assignment into a separate helper
and only use it in those filesystems that need it.  Second step is
to figure out why some filesystems need iunique() and some are fine
with the incrementing counter and then we should find a scalable way
to generate an inode number - preferably just one and not to, but if
that's not possible we need some documentation on why which one is
needed.

