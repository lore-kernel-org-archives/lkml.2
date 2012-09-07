Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab2IGIPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:15:48 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51373 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488Ab2IGIPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:15:39 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-f8-5049ad29b684
Date: Fri, 7 Sep 2012 17:17:18 +0900
From: Minchan Kim <minchan@kernel.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] mm: support MIGRATE_DISCARD
Message-ID: <20120907081718.GA31784@bbox>
References: <1346832673-12512-1-git-send-email-minchan@kernel.org>
 <1346832673-12512-2-git-send-email-minchan@kernel.org>
 <20120905105611.GI11266@suse.de>
 <20120906053112.GA16231@bbox>
 <20120906082935.GN11266@suse.de>
 <20120906090325.GO11266@suse.de>
 <20120907022434.GG16231@bbox>
 <CAH9JG2VOoA30q+3sjC4UbNFNv2Vn9KnPNNXRb+kYMKWXKHbPew@mail.gmail.com>
 <CAH9JG2XozEBOah1BsaowbU=j3SE35wZVXkDjZhK7GLUzcTbfEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH9JG2XozEBOah1BsaowbU=j3SE35wZVXkDjZhK7GLUzcTbfEA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin,

On Fri, Sep 07, 2012 at 04:31:17PM +0900, Kyungmin Park wrote:
> On 9/7/12, Kyungmin Park <kmpark@infradead.org> wrote:
> > Hi Minchan,
> >
> > I tested Mel patch again with ClearPageActive(page). but after some
> > testing, it's stall and can't return from
> > reclaim_clean_pages_from_list(&cc.migratepages).
> >
> > Maybe it's related with unmap feature from yours?
> > stall is not happened from your codes until now.
> >
> > I'll test it more and report any issue if happened.
> Updated. it's hang also. there are other issues.

It was silly mistake in my patch and I suspect it fixes your issue
because I guess you already tried below patch when you compiled and saw
warning message.
Anyway, if you see hang still after applying below patch,
please enable CONFIG_DEBUG_VM and retest, if you find something, report it.
I hope CONFIG_DEBUG_VM catch something.

Thanks.

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6668115..51d3f66 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5705,7 +5705,7 @@ static int __alloc_contig_migrate_range(unsigned long start, unsigned
                        break;
                }
 
-               reclaim_clean_pages_from_list(&cc.migratepages, cc.zone);
+               reclaim_clean_pages_from_list(cc.zone, &cc.migratepages);
 
                ret = migrate_pages(&cc.migratepages,
                                    __alloc_contig_migrate_alloc,
(END)


-- 
Kind regards,
Minchan Kim
