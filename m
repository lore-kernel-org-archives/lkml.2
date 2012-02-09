Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab2BISGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 13:06:43 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44967
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757894Ab2BISGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 13:06:41 -0500
Date: Thu, 9 Feb 2012 13:06:35 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Li Shaohua <shaohua.li@intel.com>
Subject: Re: [PATCH] block: remove plugging at buffered write time
Message-ID: <20120209180635.GA18902@infradead.org>
References: <20120208110143.GA5550@localhost>
 <20120208232719.GD7479@dastard>
 <20120209080224.GA28465@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120209080224.GA28465@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 04:02:24PM +0800, Wu Fengguang wrote:
> On Thu, Feb 09, 2012 at 10:27:19AM +1100, Dave Chinner wrote:
> > On Wed, Feb 08, 2012 at 07:01:44PM +0800, Wu Fengguang wrote:
> > > Buffered write(2) is not directly tied to IO, so it's not suitable to
> > > handle plug in generic_file_aio_write().
> > 
> > But generic_sync_write() does issue IO for O_SYNC writes, so unless
> > there is plugging at a lower layer in the writeback code then it
> > appears to me that plugging is still necessary (at least inside the
> > sync branch)....
> 
> Good catch! It looks that generic_write_sync() eventually calls into
> vfs_fsync_range() which further calls ->fsync(). We may add plugging
> around it:


NAK, please keep the plugging down in the fs, or the libraries used but
not common VFS code.

