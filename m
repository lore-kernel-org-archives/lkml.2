Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab2I1NKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:10:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287Ab2I1NKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:10:53 -0400
Date: Fri, 28 Sep 2012 14:10:43 +0100
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michal Nazarewicz <mina86@mina86.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] CMA: decrease cc.nr_migratepages after reclaiming
 pagelist
Message-ID: <20120928131043.GD29125@suse.de>
References: <1348642212-29394-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1348642212-29394-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 03:50:12PM +0900, Minchan Kim wrote:
> The reclaim_clean_pages_from_list reclaims clean pages before
> migration so cc.nr_migratepages should be updated.
> Currently, there is no problem but it can be wrong if we
> try to use the vaule in future.
> 
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Yeah ok. As you say, it shouldn't actually affect anything currently and
cc.migratepages is expected to go out of date after migration meaning we
need update_nr_listpages. This patch looks ok though.

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
