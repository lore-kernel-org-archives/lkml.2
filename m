Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab1ELWkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 18:40:20 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:17222 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752214Ab1ELWkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 18:40:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIxfzE15LCoe/2dsb2JhbACleHjITw6GBwSXIIdX
Date: Fri, 13 May 2011 08:40:13 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/17] writeback: introduce .tagged_sync for the
 WB_SYNC_NONE sync stage
Message-ID: <20110512224013.GH19446@dastard>
References: <20110512135706.937596128@intel.com>
 <20110512140030.759385136@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512140030.759385136@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 09:57:07PM +0800, Wu Fengguang wrote:
> sync(2) is performed in two stages: the WB_SYNC_NONE sync and the
> WB_SYNC_ALL sync. Tag the first stage with wbc.tagged_sync and do
> livelock prevention for it, too.
> 
> Note that writeback_inodes_sb() is called by not only sync(), they are
> treated the same because the other callers also need livelock prevention.
> 
> Impact:  It changes the order in which pages/inodes are synced to disk.
> Now in the WB_SYNC_NONE stage, it won't proceed to write the next inode
> until finished with the current inode.

What about all the filesystems that implement their own
.writepages()/write_cache_pages() functions or have
have special code that checks WB_SYNC_ALL in .writepages (e.g. gfs2,
ext4, btrfs and perhaps others). Don't they all need to be aware of
this tagged_sync field?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
