Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab1EFOgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 10:36:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab1EFOgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 10:36:17 -0400
Date: Fri, 6 May 2011 16:36:14 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@csn.ul.ie>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/17] writeback: introduce
 writeback_control.inodes_cleaned
Message-ID: <20110506143614.GF18982@quack.suse.cz>
References: <20110506030821.523093711@intel.com>
 <20110506031612.167620443@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110506031612.167620443@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 06-05-11 11:08:24, Wu Fengguang wrote:
> The flusher works on dirty inodes in batches, and may quit prematurely
> if the batch of inodes happen to be metadata-only dirtied: in this case
> wbc->nr_to_write won't be decreased at all, which stands for "no pages
> written" but also mis-interpreted as "no progress".
> 
> So introduce writeback_control.inodes_cleaned to count the inodes get
> cleaned.  A non-zero value means there are some progress on writeback,
> in which case more writeback can be tried.
> 
> about v1: The initial version was to count successful ->write_inode()
> calls.  However it leads to busy loops for sync() over NFS, because NFS
> ridiculously returns 0 (success) while at the same time redirties the
> inode.  The NFS case can be trivially fixed, however there may be more
> hidden bugs in other filesystems..
  I think Christoph didn't like this patch
(https://lkml.org/lkml/2011/5/4/123) and suggested that inodes_cleaned
should remain local to fs-writeback.c...

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
