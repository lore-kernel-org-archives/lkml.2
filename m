Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab0FOKOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 06:14:15 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47830 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756841Ab0FOKOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 06:14:10 -0400
Date: Tue, 15 Jun 2010 11:13:51 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 06/12] vmscan: simplify shrink_inactive_list()
Message-ID: <20100615101351.GA26788@csn.ul.ie>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie> <1276514273-27693-7-git-send-email-mel@csn.ul.ie> <4C166F95.3030907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4C166F95.3030907@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 02:06:13PM -0400, Rik van Riel wrote:
> On 06/14/2010 07:17 AM, Mel Gorman wrote:
>> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>>
>> Now, max_scan of shrink_inactive_list() is always passed less than
>> SWAP_CLUSTER_MAX. then, we can remove scanning pages loop in it.
>> This patch also help stack diet.
>>
>> detail
>>   - remove "while (nr_scanned<  max_scan)" loop
>>   - remove nr_freed (now, we use nr_reclaimed directly)
>>   - remove nr_scan (now, we use nr_scanned directly)
>>   - rename max_scan to nr_to_scan
>>   - pass nr_to_scan into isolate_pages() directly instead
>>     using SWAP_CLUSTER_MAX
>>
>> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>> Reviewed-by: Johannes Weiner<hannes@cmpxchg.org>
>
> Other than the weird whitespace below,
>

Not sure where this came out of. It's not in my local patch file nor in
my working tree. Very odd.

> Reviewed-by: Rik van Riel <riel@redhat.com>
>

Thanks

>> +	/*
>> +	 * If we are direct reclaiming for contiguous pages and we do
>> +	 * not reclaim everything in the list, try again and wait
>> +	 * for IO to complete. This will stall high-order allocations
>> +	 * but that should be acceptable to the caller
>> +	 */
>> +	if (nr_reclaimed<  nr_taken&&  !current_is_kswapd()&&  sc->lumpy_reclaim_mode) {
>> +		congestion_wait(BLK_RW_ASYNC, HZ/10);
>
> -- 
> All rights reversed
>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
