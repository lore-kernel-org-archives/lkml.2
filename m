Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1FSPgk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 11:36:40 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39310
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754249Ab1FSPgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 11:36:38 -0400
Date: Sun, 19 Jun 2011 11:36:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] writeback: introduce smoothed global dirty limit
Message-ID: <20110619153636.GC20424@infradead.org>
References: <20110619150108.691351746@intel.com>
 <20110619150510.246140117@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110619150510.246140117@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 11:01:11PM +0800, Wu Fengguang wrote:
> The start of a heavy weight application (ie. KVM) may instantly knock
> down determine_dirtyable_memory() and hence the global/bdi dirty
> thresholds.
> 
> So introduce global_dirty_limit for tracking the global dirty threshold
> with policies
> 
> - follow downwards slowly
> - follow up in one shot
> 
> global_dirty_limit can effectively mask out the impact of sudden drop of
> dirtyable memory. It will be used in the next patch for two new type of
> dirty limits.

This needs to be explained in more detail in comments near the actual
code.

