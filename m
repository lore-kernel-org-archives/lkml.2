Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab1HCL1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 07:27:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab1HCL1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 07:27:13 -0400
Date: Wed, 3 Aug 2011 13:26:30 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 7/8] mm: vmscan: Immediately reclaim end-of-LRU dirty
 pages when writeback completes
Message-ID: <20110803112630.GE27199@redhat.com>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
 <1311265730-5324-8-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311265730-5324-8-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 05:28:49PM +0100, Mel Gorman wrote:
> When direct reclaim encounters a dirty page, it gets recycled around
> the LRU for another cycle. This patch marks the page PageReclaim
> similar to deactivate_page() so that the page gets reclaimed almost
> immediately after the page gets cleaned. This is to avoid reclaiming
> clean pages that are younger than a dirty page encountered at the
> end of the LRU that might have been something like a use-once page.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Apart from the naming of the counter (I like nr_reclaim_preferred),

Acked-by: Johannes Weiner <jweiner@redhat.com>
