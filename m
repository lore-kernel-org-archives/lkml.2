Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab2KTOtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:49:43 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:23884 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab2KTOtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:49:42 -0500
Message-id: <50AB987F.30002@samsung.com>
Date: Tue, 20 Nov 2012 15:49:35 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026
 Thunderbird/16.0.2
MIME-version: 1.0
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] mm: cma: allocate pages from CMA if NR_FREE_PAGES
 approaches low water mark
References: <1352710782-25425-1-git-send-email-m.szyprowski@samsung.com>
 <20121120000137.GC447@bbox>
In-reply-to: <20121120000137.GC447@bbox>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/20/2012 1:01 AM, Minchan Kim wrote:
> Hi Marek,
>
> On Mon, Nov 12, 2012 at 09:59:42AM +0100, Marek Szyprowski wrote:
> > It has been observed that system tends to keep a lot of CMA free pages
> > even in very high memory pressure use cases. The CMA fallback for movable
>
> CMA free pages are just fallback for movable pages so if user requires many
> user pages, it ends up consuming cma free pages after out of movable pages.
> What do you mean that system tend to keep free pages even in very
> high memory pressure?
> > pages is used very rarely, only when system is completely pruned from
> > MOVABLE pages, what usually means that the out-of-memory even will be
> > triggered very soon. To avoid such situation and make better use of CMA
>
> Why does OOM is triggered very soon if movable pages are burned out while
> there are many cma pages?
>
> It seems I can't understand your point quitely.
> Please make your problem clear for silly me to understand clearly.

Right now running out of 'plain' movable pages is the only possibility to
get movable pages allocated from CMA. On the other hand running out of
'plain' movable pages is very deadly for the system, as movable pageblocks
are also the main fallbacks for reclaimable and non-movable pages.

Then, once we run out of movable pages and kernel needs non-mobable or
reclaimable page (what happens quite often), it usually triggers OOM to
satisfy the memory needs. Such OOM is very strange, especially on a system
with dozen of megabytes of CMA memory, having most of them free at the OOM
event. By high memory pressure I mean the high memory usage.

This patch introduces a heuristics which let kernel to consume free CMA
pages before it runs out of 'plain' movable pages, what is usually enough to
keep some spare movable pages for emergency cases before the reclaim occurs.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


