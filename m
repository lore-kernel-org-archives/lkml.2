Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab2IFF3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 01:29:39 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48709 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab2IFF3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 01:29:38 -0400
X-AuditID: 9c930197-b7b93ae0000028a7-fc-504834c0147c
Date: Thu, 6 Sep 2012 14:31:12 +0900
From: Minchan Kim <minchan@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] mm: support MIGRATE_DISCARD
Message-ID: <20120906053112.GA16231@bbox>
References: <1346832673-12512-1-git-send-email-minchan@kernel.org>
 <1346832673-12512-2-git-send-email-minchan@kernel.org>
 <20120905105611.GI11266@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120905105611.GI11266@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Wed, Sep 05, 2012 at 11:56:11AM +0100, Mel Gorman wrote:
> On Wed, Sep 05, 2012 at 05:11:13PM +0900, Minchan Kim wrote:
> > This patch introudes MIGRATE_DISCARD mode in migration.
> > It drops *clean cache pages* instead of migration so that
> > migration latency could be reduced by avoiding (memcpy + page remapping).
> > It's useful for CMA because latency of migration is very important rather
> > than eviction of background processes's workingset. In addition, it needs
> > less free pages for migration targets so it could avoid memory reclaiming
> > to get free pages, which is another factor increase latency.
> > 
> 
> Bah, this was released while I was reviewing the older version. I did
> not read this one as closely but I see the enum problems have gone away
> at least. I'd still prefer if CMA had an additional helper to discard
> some pages with shrink_page_list() and migrate the remaining pages with
> migrate_pages(). That would remove the need to add a MIGRATE_DISCARD
> migrate mode at all.

I am not convinced with your point. What's the benefit on separating
reclaim and migration? For just removing MIGRATE_DISCARD mode?
I don't think it's not bad because my implementation is very simple(maybe
it's much simpler than separating reclaim and migration) and
could be used by others like memory-hotplug in future.
If you're not strong against with me, I would like to insist on my implementation.

> 
> -- 
> Mel Gorman
> SUSE Labs
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
