Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab1HaBKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 21:10:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368Ab1HaBKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 21:10:35 -0400
Message-ID: <4E5D89E3.6020008@redhat.com>
Date: Tue, 30 Aug 2011 21:09:55 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>
Subject: Re: [PATCH 2/3] compaction: compact unevictable page
References: <cover.1321112552.git.minchan.kim@gmail.com> <8ef02605a7a76b176167d90a285033afa8513326.1321112552.git.minchan.kim@gmail.com>
In-Reply-To: <8ef02605a7a76b176167d90a285033afa8513326.1321112552.git.minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2011 11:37 AM, Minchan Kim wrote:
> Now compaction doesn't handle mlocked page as it uses __isolate_lru_page
> which doesn't consider unevicatable page. It has been used by just lumpy so
> it was pointless that it isolates unevictable page. But the situation is
> changed. Compaction could handle unevictable page and it can help getting
> big contiguos pages in fragment memory by many pinned page with mlock.
>
> I tested this patch with following scenario.
>
> 1. A : allocate 80% anon pages in system
> 2. B : allocate 20% mlocked page in system
> /* Maybe, mlocked pages are located in low pfn address */
> 3. kill A /* high pfn address are free */
> 4. echo 1>  /proc/sys/vm/compact_memory
>
> old:
>
> compact_blocks_moved 251
> compact_pages_moved 44
>
> new:
>
> compact_blocks_moved 258
> compact_pages_moved 412
>
> CC: Mel Gorman<mgorman@suse.de>
> CC: Johannes Weiner<jweiner@redhat.com>
> CC: Rik van Riel<riel@redhat.com>
> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
