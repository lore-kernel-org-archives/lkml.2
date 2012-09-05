Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410Ab2IEK4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:56:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab2IEK4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:56:14 -0400
Date: Wed, 5 Sep 2012 11:56:11 +0100
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] mm: support MIGRATE_DISCARD
Message-ID: <20120905105611.GI11266@suse.de>
References: <1346832673-12512-1-git-send-email-minchan@kernel.org>
 <1346832673-12512-2-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1346832673-12512-2-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 05:11:13PM +0900, Minchan Kim wrote:
> This patch introudes MIGRATE_DISCARD mode in migration.
> It drops *clean cache pages* instead of migration so that
> migration latency could be reduced by avoiding (memcpy + page remapping).
> It's useful for CMA because latency of migration is very important rather
> than eviction of background processes's workingset. In addition, it needs
> less free pages for migration targets so it could avoid memory reclaiming
> to get free pages, which is another factor increase latency.
> 

Bah, this was released while I was reviewing the older version. I did
not read this one as closely but I see the enum problems have gone away
at least. I'd still prefer if CMA had an additional helper to discard
some pages with shrink_page_list() and migrate the remaining pages with
migrate_pages(). That would remove the need to add a MIGRATE_DISCARD
migrate mode at all.

-- 
Mel Gorman
SUSE Labs
