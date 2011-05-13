Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647Ab1EMKRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 06:17:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41798 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758443Ab1EMKRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 06:17:15 -0400
Date: Fri, 13 May 2011 06:17:07 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/17] writeback: introduce .tagged_sync for the
 WB_SYNC_NONE sync stage
Message-ID: <20110513101707.GA17434@infradead.org>
References: <20110512135706.937596128@intel.com>
 <20110512140030.759385136@intel.com>
 <20110512224013.GH19446@dastard>
 <20110513025607.GA8016@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513025607.GA8016@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 10:56:08AM +0800, Wu Fengguang wrote:
> > What about all the filesystems that implement their own
> > .writepages()/write_cache_pages() functions or have
> > have special code that checks WB_SYNC_ALL in .writepages (e.g. gfs2,
> > ext4, btrfs and perhaps others). Don't they all need to be aware of
> > this tagged_sync field?
> 
> Right, good point. Currently only ext4 is updated. The other
> filesystems --- afs, btrfs, cifs, gfs2 --- do not even use
> PAGECACHE_TAG_TOWRITE for livelock prevention. My plan was to add
> PAGECACHE_TAG_TOWRITE and tagged_sync code to them as the next step,
> when tagged_sync is accepted and proved to work fine.

I think it would be better to try to figure out why these filesystems
need to duplicate that functionality and figure out if there's any
way to make them use the generic code.  But given that we need to get
some writeback updates ready for .40 it might be worth to postponed
that and go down the copy & paste route for now.

