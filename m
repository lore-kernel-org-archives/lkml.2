Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab1HCN5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:57:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab1HCN5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:57:43 -0400
Date: Wed, 3 Aug 2011 14:57:39 +0100
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 7/8] mm: vmscan: Immediately reclaim end-of-LRU dirty
 pages when writeback completes
Message-ID: <20110803135739.GK19099@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
 <1311265730-5324-8-git-send-email-mgorman@suse.de>
 <20110803112630.GE27199@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110803112630.GE27199@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 01:26:30PM +0200, Johannes Weiner wrote:
> On Thu, Jul 21, 2011 at 05:28:49PM +0100, Mel Gorman wrote:
> > When direct reclaim encounters a dirty page, it gets recycled around
> > the LRU for another cycle. This patch marks the page PageReclaim
> > similar to deactivate_page() so that the page gets reclaimed almost
> > immediately after the page gets cleaned. This is to avoid reclaiming
> > clean pages that are younger than a dirty page encountered at the
> > end of the LRU that might have been something like a use-once page.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> Apart from the naming of the counter (I like nr_reclaim_preferred),
> 

At the moment it's NR_VMSCAN_IMMEDIATE and the name visible in
/proc/vmstat is nr_vmscan_immediate_reclaim

> Acked-by: Johannes Weiner <jweiner@redhat.com>

Thanks.

-- 
Mel Gorman
SUSE Labs
