Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab1EDLI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 07:08:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33882 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab1EDLI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 07:08:56 -0400
Date: Wed, 4 May 2011 07:08:49 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] writeback: elevate queue_io() into wb_writeback()
Message-ID: <20110504110849.GC4646@infradead.org>
References: <20110426144218.GA14862@localhost>
 <20110426144402.GA15166@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426144402.GA15166@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	return 1;
>  }
>  
> -void writeback_inodes_wb(struct bdi_writeback *wb,
> -		struct writeback_control *wbc)
> +static void __writeback_inodes_wb(struct bdi_writeback *wb,
> +				  struct writeback_control *wbc)
>  {
>  	int ret = 0;
>  
>  	if (!wbc->wb_start)
>  		wbc->wb_start = jiffies; /* livelock avoidance */

This should move to writeback_inodes_wb and be unconditional as
wb_writeback already always initializes it.

