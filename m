Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab2AZB1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 20:27:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab2AZB13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 20:27:29 -0500
Message-ID: <4F20ABDF.8020604@redhat.com>
Date: Wed, 25 Jan 2012 20:26:55 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        Adrian Drzewieki <z@drze.net>
Subject: Re: [PATCH v4 -mm] make swapin readahead skip over holes
References: <20120124131351.05309a2a@annuminas.surriel.com> <20120124141400.6d33b7c4@annuminas.surriel.com> <20120125172319.edbbde73.akpm@linux-foundation.org>
In-Reply-To: <20120125172319.edbbde73.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2012 08:23 PM, Andrew Morton wrote:

> Just to show that I'm paying attention...
>
>> --- a/mm/swap_state.c
>> +++ b/mm/swap_state.c
>> @@ -382,25 +382,23 @@ struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>>   struct page *swapin_readahead(swp_entry_t entry, gfp_t gfp_mask,
>>   			struct vm_area_struct *vma, unsigned long addr)
>>   {
>> -	int nr_pages;
>>   	struct page *page;
>> -	unsigned long offset;
>> -	unsigned long end_offset;
>> +	unsigned long offset = swp_offset(entry);
>> +	unsigned long start_offset, end_offset;
>> +	unsigned long mask = (1<<  page_cluster) - 1;
>
> This is broken for page_cluster>  31.  Fix:

I don't know who would want to do their swapins in chunks
of 8GB or large at a time, but still a good catch.

Want me to send in a v5, or do you prefer to merge a -fix
patch in your tree?

-- 
All rights reversed
