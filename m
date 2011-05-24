Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab1EXIl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 04:41:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43853 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab1EXIlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 04:41:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDB6F48.1010809@jp.fujitsu.com>
Date: Tue, 24 May 2011 17:41:44 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: minchan.kim@gmail.com
CC: abarry@cray.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mgorman@suse.de, riel@redhat.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: Unending loop in __alloc_pages_slowpath following OOM-kill; rfc:
 patch.
References: <4DCDA347.9080207@cray.com>	<BANLkTikiXUzbsUkzaKZsZg+5ugruA2JdMA@mail.gmail.com>	<4DD2991B.5040707@cray.com>	<BANLkTimYEs315jjY9OZsL6--mRq3O_zbDA@mail.gmail.com>	<20110520164924.GB2386@barrios-desktop>	<4DDB3A1E.6090206@jp.fujitsu.com> <BANLkTinkcu5j1H8tHNT4aTmOL-GXfSwPQw@mail.gmail.com>
In-Reply-To: <BANLkTinkcu5j1H8tHNT4aTmOL-GXfSwPQw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I'm sorry I missed this thread long time.
> 
> No problem. It would be better than not review.

thx.


>> In this case, I think we should call drain_all_pages(). then following
>> patch is better.
> 
> Strictly speaking, this problem isn't related to drain_all_pages.
> This problem caused by lru empty but I admit it could work well if
> your patch applied.
> So yours could help, too.
> 
>> However I also think your patch is valuable. because while the task is
>> sleeping in wait_iff_congested(), an another task may free some pages.
>> thus, rebalance path should try to get free pages. iow, you makes sense.
> 
> Yes.
> Off-topic.
> I would like to move cond_resched below get_page_from_freelist in
> __alloc_pages_direct_reclaim. Otherwise, it is likely we can be stolen
> pages to other processes.
> One more benefit is that if it's apparently OOM path(ie,
> did_some_progress = 0), we can reduce OOM kill latency due to remove
> unnecessary cond_resched.

I agree. Can you please mind to send a patch?


>> So, I'd like to propose to merge both your and my patch.
> 
> Recently, there was discussion on drain_all_pages with Wu.
> He saw much overhead in 8-core system, AFAIR.
> I Cced Wu.
> 
> How about checking per-cpu before calling drain_all_pages() than
> unconditional calling?
> if (per_cpu_ptr(zone->pageset, smp_processor_id())
>     drain_all_pages();
> 
> Of course, It can miss other CPU free pages. But above routine assume
> local cpu direct reclaim is successful but it failed by per-cpu. So I
> think it works.

Can you please tell me previous discussion url or mail subject?
I mean, if it is costly and performance degression risk, we don't have to
take my idea.

Thanks.


> 
> Thanks for good suggestion and Reviewed-by, KOSAKI.


