Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab1GYUww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:52:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:30864 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab1GYUwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:52:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,264,1309762800"; 
   d="scan'208";a="31306550"
Date: Mon, 25 Jul 2011 13:52:49 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/5] mm: page_alloc: increase __GFP_BITS_SHIFT to include
 __GFP_OTHER_NODE
Message-ID: <20110725205249.GB21691@tassilo.jf.intel.com>
References: <1311625159-13771-1-git-send-email-jweiner@redhat.com>
 <1311625159-13771-2-git-send-email-jweiner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311625159-13771-2-git-send-email-jweiner@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 10:19:15PM +0200, Johannes Weiner wrote:
> From: Johannes Weiner <hannes@cmpxchg.org>
> 
> __GFP_OTHER_NODE is used for NUMA allocations on behalf of other
> nodes.  It's supposed to be passed through from the page allocator to
> zone_statistics(), but it never gets there as gfp_allowed_mask is not
> wide enough and masks out the flag early in the allocation path.
> 
> The result is an accounting glitch where successful NUMA allocations
> by-agent are not properly attributed as local.
> 
> Increase __GFP_BITS_SHIFT so that it includes __GFP_OTHER_NODE.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi
