Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab2BJCCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 21:02:25 -0500
Received: from mga14.intel.com ([143.182.124.37]:54074 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab2BJCCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 21:02:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="105186632"
Date: Fri, 10 Feb 2012 09:52:18 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Chris Mason <chris.mason@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Li Shaohua <shaohua.li@intel.com>
Subject: Re: [PATCH] block: remove plugging at buffered write time
Message-ID: <20120210015218.GA11422@localhost>
References: <20120208110143.GA5550@localhost>
 <20120208232719.GD7479@dastard>
 <20120209080224.GA28465@localhost>
 <20120209180635.GA18902@infradead.org>
 <20120209183027.GT8384@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120209183027.GT8384@shiny>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 01:30:27PM -0500, Chris Mason wrote:
> On Thu, Feb 09, 2012 at 01:06:35PM -0500, Christoph Hellwig wrote:
> > On Thu, Feb 09, 2012 at 04:02:24PM +0800, Wu Fengguang wrote:
> > > On Thu, Feb 09, 2012 at 10:27:19AM +1100, Dave Chinner wrote:
> > > > On Wed, Feb 08, 2012 at 07:01:44PM +0800, Wu Fengguang wrote:
> > > > > Buffered write(2) is not directly tied to IO, so it's not suitable to
> > > > > handle plug in generic_file_aio_write().
> > > > 
> > > > But generic_sync_write() does issue IO for O_SYNC writes, so unless
> > > > there is plugging at a lower layer in the writeback code then it
> > > > appears to me that plugging is still necessary (at least inside the
> > > > sync branch)....
> > > 
> > > Good catch! It looks that generic_write_sync() eventually calls into
> > > vfs_fsync_range() which further calls ->fsync(). We may add plugging
> > > around it:
> > 
> > 
> > NAK, please keep the plugging down in the fs, or the libraries used but
> > not common VFS code.
> 
> Please, what Christoph said.  At least for btrfs plugging here is wrong.

OK, I get the point: the fs knows best when to unplug. Since any
higher level plug nesting will turn such low level efforts into no-op,
it's highly undesirable to do it in the high level.

Thanks,
Fengguang
