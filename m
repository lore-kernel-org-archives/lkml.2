Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab1EDLcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 07:32:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:2356 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab1EDLcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 07:32:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,313,1301900400"; 
   d="scan'208";a="637756463"
Date: Wed, 4 May 2011 19:32:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Chinner <david@fromorbit.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] writeback: introduce
 writeback_control.inodes_cleaned
Message-ID: <20110504113211.GA5853@localhost>
References: <20110420080336.441157866@intel.com>
 <20110420080917.890756812@intel.com>
 <20110504110500.GB4646@infradead.org>
 <20110504111130.GA5191@localhost>
 <20110504111647.GA19261@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504111647.GA19261@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 07:16:47PM +0800, Christoph Hellwig wrote:
> On Wed, May 04, 2011 at 07:11:30PM +0800, Wu Fengguang wrote:
> > On Wed, May 04, 2011 at 07:05:00PM +0800, Christoph Hellwig wrote:
> > > Same here - this has nothing to do with actual page writeback and really
> > > should stay internal to fs/fs-writeback.c
> > 
> > OK, I'll check how to constrain writeback_control to the minimal scope.
> 
> The basic idea would be to pass the struct wb_writeback_work all the
> way down to writeback_sb_inodes, and initialize the struct writeback_control
> there.

OK.

> This requires adding a few more fields like more_io and

We can in fact just kill more_io and test list_empty(b_more_io)
instead.

> older_than_this to struct wb_writeback_work, and redoing a lot of the
> tracing,

Yeah, older_than_this must still be set in wb_writeback().
The two trace points could be removed for now.

> but it immediately clean things up, e.g. suddently
> wbc.nr_to_write vs work->nr_pages starts to make sense, and instead
> of saving and restoring pages_skipped in writeback_sb_inodes it can
> always start with a clean zero value.

That's right.

Thanks,
Fengguang
