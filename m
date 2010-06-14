Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab0FNSHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 14:07:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab0FNSHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 14:07:47 -0400
Message-ID: <4C166F95.3030907@redhat.com>
Date: Mon, 14 Jun 2010 14:06:13 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 06/12] vmscan: simplify shrink_inactive_list()
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie> <1276514273-27693-7-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1276514273-27693-7-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 07:17 AM, Mel Gorman wrote:
> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>
> Now, max_scan of shrink_inactive_list() is always passed less than
> SWAP_CLUSTER_MAX. then, we can remove scanning pages loop in it.
> This patch also help stack diet.
>
> detail
>   - remove "while (nr_scanned<  max_scan)" loop
>   - remove nr_freed (now, we use nr_reclaimed directly)
>   - remove nr_scan (now, we use nr_scanned directly)
>   - rename max_scan to nr_to_scan
>   - pass nr_to_scan into isolate_pages() directly instead
>     using SWAP_CLUSTER_MAX
>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: Johannes Weiner<hannes@cmpxchg.org>

Other than the weird whitespace below,

Reviewed-by: Rik van Riel <riel@redhat.com>

> +	/*
> +	 * If we are direct reclaiming for contiguous pages and we do
> +	 * not reclaim everything in the list, try again and wait
> +	 * for IO to complete. This will stall high-order allocations
> +	 * but that should be acceptable to the caller
> +	 */
> +	if (nr_reclaimed<  nr_taken&&  !current_is_kswapd()&&  sc->lumpy_reclaim_mode) {
> +		congestion_wait(BLK_RW_ASYNC, HZ/10);

-- 
All rights reversed
