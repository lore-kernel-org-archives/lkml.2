Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab1E0PRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:17:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:60059 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab1E0PRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:17:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,280,1304319600"; 
   d="scan'208";a="9979868"
Date: Fri, 27 May 2011 23:17:32 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/18] writeback: sync expired inodes first in
 background writeback
Message-ID: <20110527151732.GA13296@localhost>
References: <20110524051411.924582719@intel.com>
 <20110524051858.972440561@intel.com>
 <20110524155205.GC5390@quack.suse.cz>
 <20110525143857.GA25536@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525143857.GA25536@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 10:38:57PM +0800, Wu Fengguang wrote:
> On Tue, May 24, 2011 at 11:52:05PM +0800, Jan Kara wrote:
[snip]
> > and I was wondering: Assume there is one continuously redirtied file and
> > untar starts in parallel. With the new logic, background writeback will
> > never consider inodes that are not expired in this situation (we never
> > switch to "all dirty inodes" phase - or even if we switched, we would just
> > queue all inodes and then return back to queueing only expired inodes). So
> > the net effect is that for 30 seconds we will be only continuously writing
> > pages of the continuously dirtied file instead of (possibly older) pages of
> > other files that are written. Is this really desirable? Wasn't the old
> > behavior simpler and not worse than the new one?
> 
> Good question! Yes sadly in this case the new behavior could be worse
> than the old one.

Andrew, it's desirable to delay this patch given that it has some
negative behavior (it's fixable but the fix won't be trivial enough
for immediate merge).

You may simply drop this patch (06) and the last two patches (17, 18)
and still be able to cleanly apply all other patches in this series.

Thanks,
Fengguang
