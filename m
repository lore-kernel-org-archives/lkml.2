Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081Ab1LPEKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 23:10:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704Ab1LPEKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 23:10:52 -0500
Message-ID: <4EEAC4AC.90600@redhat.com>
Date: Thu, 15 Dec 2011 23:10:20 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Dave Jones <davej@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Nai Xia <nai.xia@gmail.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/11] mm: page allocator: Do not call direct reclaim
 for THP allocations while compaction is deferred
References: <1323877293-15401-1-git-send-email-mgorman@suse.de> <1323877293-15401-8-git-send-email-mgorman@suse.de>
In-Reply-To: <1323877293-15401-8-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 10:41 AM, Mel Gorman wrote:
> If compaction is deferred, direct reclaim is used to try free enough
> pages for the allocation to succeed. For small high-orders, this has
> a reasonable chance of success. However, if the caller has specified
> __GFP_NO_KSWAPD to limit the disruption to the system, it makes more
> sense to fail the allocation rather than stall the caller in direct
> reclaim. This patch skips direct reclaim if compaction is deferred
> and the caller specifies __GFP_NO_KSWAPD.
>
> Async compaction only considers a subset of pages so it is possible for
> compaction to be deferred prematurely and not enter direct reclaim even
> in cases where it should. To compensate for this, this patch also defers
> compaction only if sync compaction failed.
>
> Signed-off-by: Mel Gorman<mgorman@suse.de>
> Acked-by: Minchan Kim<minchan.kim@gmail.com>

Reviewed-by: Rik van Riel<riel@redhat.com>

-- 
All rights reversed
