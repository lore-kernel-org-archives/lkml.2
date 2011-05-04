Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab1EDLPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 07:15:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:58285 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117Ab1EDLPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 07:15:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,313,1301900400"; 
   d="scan'208";a="917847403"
Date: Wed, 4 May 2011 19:15:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] writeback: elevate queue_io() into wb_writeback()
Message-ID: <20110504111547.GA5441@localhost>
References: <20110426144218.GA14862@localhost>
 <20110426144402.GA15166@localhost>
 <20110504110849.GC4646@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504110849.GC4646@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 07:08:49PM +0800, Christoph Hellwig wrote:
> >  	return 1;
> >  }
> >  
> > -void writeback_inodes_wb(struct bdi_writeback *wb,
> > -		struct writeback_control *wbc)
> > +static void __writeback_inodes_wb(struct bdi_writeback *wb,
> > +				  struct writeback_control *wbc)
> >  {
> >  	int ret = 0;
> >  
> >  	if (!wbc->wb_start)
> >  		wbc->wb_start = jiffies; /* livelock avoidance */
> 
> This should move to writeback_inodes_wb and be unconditional as
> wb_writeback already always initializes it.

Never mind :) wbc->wb_start has been killed in a later patch named
"writeback: avoid extra sync work at enqueue time".

Thanks,
Fengguang
