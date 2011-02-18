Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab1BRWHD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 17:07:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47125 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab1BRWHC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 17:07:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ngA/2W1I5sN6PEdeQIkYc1HePLBhYGCKvnllbBLyjwhDRvIHdqZi4FGMfiuHYKLpcu
         N2dWU04qledOMEi9W8nZpXKp3Sv/CjIUUL77C4BLBs8N9S1EdzqMKgzTVtZSi7OH9Ecg
         O8jlYre/pC+DQnH9Os1qeCzw4COOPlGKTGUtQ=
MIME-Version: 1.0
In-Reply-To: <20110218165827.GB13246@csn.ul.ie>
References: <cover.1297940291.git.minchan.kim@gmail.com>
	<7563767d6b6e841a8ac5f8315ee166e0f039723c.1297940291.git.minchan.kim@gmail.com>
	<20110218165827.GB13246@csn.ul.ie>
Date: Sat, 19 Feb 2011 07:07:01 +0900
Message-ID: <AANLkTikom2dZaE4v2fNBaRV+OKT+0ZF3ZcEnvkRH0oJW@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] add profile information for invalidated page
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Barrett <damentz@liquorix.net>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Sat, Feb 19, 2011 at 1:58 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Fri, Feb 18, 2011 at 12:08:22AM +0900, Minchan Kim wrote:
>> This patch adds profile information about invalidated page reclaim.
>> It's just for profiling for test so it is never for merging.
>>
>> Acked-by: Rik van Riel <riel@redhat.com>
>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Cc: Wu Fengguang <fengguang.wu@intel.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Nick Piggin <npiggin@kernel.dk>
>> Cc: Mel Gorman <mel@csn.ul.ie>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> ---
>>  include/linux/vmstat.h |    4 ++--
>>  mm/swap.c              |    3 +++
>>  mm/vmstat.c            |    3 +++
>>  3 files changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
>> index 833e676..c38ad95 100644
>> --- a/include/linux/vmstat.h
>> +++ b/include/linux/vmstat.h
>> @@ -30,8 +30,8 @@
>>
>>  enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>>               FOR_ALL_ZONES(PGALLOC),
>> -             PGFREE, PGACTIVATE, PGDEACTIVATE,
>> -             PGFAULT, PGMAJFAULT,
>> +             PGFREE, PGACTIVATE, PGDEACTIVATE, PGINVALIDATE,
>> +             PGRECLAIM, PGFAULT, PGMAJFAULT,
>>               FOR_ALL_ZONES(PGREFILL),
>>               FOR_ALL_ZONES(PGSTEAL),
>>               FOR_ALL_ZONES(PGSCAN_KSWAPD),
>> diff --git a/mm/swap.c b/mm/swap.c
>> index 0a33714..980c17b 100644
>> --- a/mm/swap.c
>> +++ b/mm/swap.c
>> @@ -397,6 +397,7 @@ static void lru_deactivate(struct page *page, struct zone *zone)
>>                * is _really_ small and  it's non-critical problem.
>>                */
>>               SetPageReclaim(page);
>> +             __count_vm_event(PGRECLAIM);
>>       } else {
>>               /*
>>                * The page's writeback ends up during pagevec
>
> Is this name potentially misleading?
>
> Pages that are reclaimed are accounted for with _steal. It's not particularly
> obvious but that's the name it was given. I'd worry that an administrator that
> was not aware of *_steal would read pgreclaim as "pages that were reclaimed"
> when this is not necessarily the case.
>
> Is there a better name for this? pginvalidate_deferred
> or pginvalidate_delayed maybe?
>

Yep. Your suggestion is fair enough. But as I said in description,
It's just for testing for my profiling, not merging so I didn't care
about it.
I don't think we need new vmstat of pginvalidate.

-- 
Kind regards,
Minchan Kim
