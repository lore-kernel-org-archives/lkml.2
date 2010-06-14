Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab0FNV4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:56:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073Ab0FNV4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:56:42 -0400
Message-ID: <4C16A567.4080000@redhat.com>
Date: Mon, 14 Jun 2010 17:55:51 -0400
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
Subject: Re: [PATCH 12/12] vmscan: Do not writeback pages in direct reclaim
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie> <1276514273-27693-13-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1276514273-27693-13-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 07:17 AM, Mel Gorman wrote:

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 4856a2a..574e816 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -372,6 +372,12 @@ int write_reclaim_page(struct page *page, struct address_space *mapping,
>   	return PAGE_SUCCESS;
>   }
>
> +/* kswapd and memcg can writeback as they are unlikely to overflow stack */
> +static inline bool reclaim_can_writeback(struct scan_control *sc)
> +{
> +	return current_is_kswapd() || sc->mem_cgroup != NULL;
> +}
> +

I'm not entirely convinced on this bit, but am willing to
be convinced by the data.

-- 
All rights reversed
