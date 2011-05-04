Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab1EDLRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 07:17:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49392 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab1EDLR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 07:17:29 -0400
Date: Wed, 4 May 2011 07:17:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] writeback: elevate queue_io() into wb_writeback()
Message-ID: <20110504111722.GB19261@infradead.org>
References: <20110426144218.GA14862@localhost>
 <20110426144402.GA15166@localhost>
 <20110504110849.GC4646@infradead.org>
 <20110504111547.GA5441@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504111547.GA5441@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 07:15:47PM +0800, Wu Fengguang wrote:
> > This should move to writeback_inodes_wb and be unconditional as
> > wb_writeback already always initializes it.
> 
> Never mind :) wbc->wb_start has been killed in a later patch named
> "writeback: avoid extra sync work at enqueue time".

Even better.  I was already wondering why we'd need two different
jiffies and jiffies + offset value in the writeback code.

