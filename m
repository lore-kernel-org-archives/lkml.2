Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab2FKKoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 06:44:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53103 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2FKKoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 06:44:23 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-23-4fd5cbfeed3c
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v10] mm: compaction: handle incorrect MIGRATE_UNMOVABLE
 type pageblocks
Date: Mon, 11 Jun 2012 12:43:14 +0200
User-Agent: KMail/1.13.2 (Linux/3.2.6; KDE/4.4.5; i686; ; )
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Dave Jones <davej@redhat.com>, Cong Wang <amwang@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <201206081046.32382.b.zolnierkie@samsung.com>
 <4FD54959.6060500@kernel.org>
In-reply-to: <4FD54959.6060500@kernel.org>
MIME-version: 1.0
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <201206111243.14379.b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jQd1/p6/6G2w+pmJxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyLky4wVJwnq/i6GPbBsbV3F2MnBwSAiYSyxoXMkHYYhIX7q1n
	62Lk4hASmM4oceX2DCYIZzWTxOW1c8Cq2ASsJCa2r2IEsUUEVCT+PP0HZgsLxErsWLeHFcRm
	EVCVOHBlLTuILSpgLXH0wj1GkEHMAm+ZJdZ+fM/cxcgBNDVS4t+MfJAaTgEtif5PN8Hm8woI
	SvyYfI8FxGYGije/2cQIYctLbF7zlhmixlLidUszywRGgVlIWmYhaZmFpGUBI/MqRtHUguSC
	4qT0XCO94sTc4tK8dL3k/NxNjOAAfCa9g3FVg8UhRgEORiUe3oalV/2FWBPLiitzDzFKcDAr
	ifBuqwAK8aYkVlalFuXHF5XmpBYfYpTmYFES522yvuAvJJCeWJKanZpakFoEk2Xi4JRqYCy4
	xLW39/Mtk212nzZvEnroFvW5vGCp3pYtcV2/H6y+PslJ4SX3ezWD5ZlZU/0mT9+58+6fV+9a
	pDqXxV733Tvvbqn+PiPO07O09Fh11RcJ9ky4vqCP83CrVInvFWOJF/xXG+L0jE7ETNh3IMp/
	UahFKmPOoYhOgbof/1X+nCrjt4+wzGIO363EUpyRaKjFXFScCADOkWj2PAIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 June 2012 03:26:49 Minchan Kim wrote:
> Hi Bartlomiej,
> 
> On 06/08/2012 05:46 PM, Bartlomiej Zolnierkiewicz wrote:
> 
> > 
> > Hi,
> > 
> > This version is much simpler as it just uses __count_immobile_pages()
> > instead of using its own open coded version and it integrates changes
> 
> 
> That's a good idea. I don't have noticed that function is there.
> When I look at the function, it has a problem, too.
> Please, look at this.
> 
> https://lkml.org/lkml/2012/6/10/180
> 
> If reviewer is okay that patch, I would like to resend your patch based on that. 

Ok, I would later merge all changes into v11 and rebase on top of your patch.

> > from Minchan Kim (without page_count change as it doesn't seem correct
> 
> 
> Why do you think so?
> If it isn't correct, how can you prevent racing with THP page freeing?

After seeing the explanation for the previous fix it is all clear now.

> > and __count_immobile_pages() does the check in the standard way; if it
> > still is a problem I think that removing 1st phase check altogether
> > would be better instead of adding more locking complexity).
> > 
> > The patch also adds compact_rescued_unmovable_blocks vmevent to vmstats
> > to make it possible to easily check if the code is working in practice.
> 
> 
> I think that part should be another patch.
> 
> 1. Adding new vmstat would be arguable so it might interrupt this patch merging.

Why would it be arguable?  It seems non-intrusive and obvious to me.

> 2. New vmstat adding is just for this patch is effective or not in real practice
>    so if we prove it in future, let's revert the vmstat. Separating it would make it
>    easily.

I would like to add this vmstat permanently, not only for the testing period..

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center
