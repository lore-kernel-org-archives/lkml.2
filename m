Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab1D2PPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:15:04 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34551 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab1D2PPC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:15:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iTYIoYrS4UU2ImlvrHiDOgQYmpyyBs301tk3If2is7S7SdlGVO/kswj/mPA7DzLMp6
         ZrTy7WbOruVFuc0jH/WIySAyCA8vLXCF/UVgzJCE9BNrDQfHGpYLmc6H3zC/JGnms0yF
         Khzz3rMKfRHNG42KPs6fMSO/dRu1lLDKten2o=
MIME-Version: 1.0
In-Reply-To: <20110428084820.GH12437@cmpxchg.org>
References: <cover.1303833415.git.minchan.kim@gmail.com>
	<4dc5e63cfc8672426336e43dea29057d5bb6e863.1303833417.git.minchan.kim@gmail.com>
	<20110428084820.GH12437@cmpxchg.org>
Date: Sat, 30 Apr 2011 00:15:01 +0900
Message-ID: <BANLkTina+YuDgACZfDV8T_Lnipo50J6zVA@mail.gmail.com>
Subject: Re: [RFC 2/8] compaction: make isolate_lru_page with filter aware
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hannes,

On Thu, Apr 28, 2011 at 5:48 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Wed, Apr 27, 2011 at 01:25:19AM +0900, Minchan Kim wrote:
>> In async mode, compaction doesn't migrate dirty or writeback pages.
>> So, it's meaningless to pick the page and re-add it to lru list.
>>
>> Of course, when we isolate the page in compaction, the page might
>> be dirty or writeback but when we try to migrate the page, the page
>> would be not dirty, writeback. So it could be migrated. But it's
>> very unlikely as isolate and migration cycle is much faster than
>> writeout.
>>
>> So, this patch helps cpu and prevent unnecessary LRU churning.
>>
>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: Rik van Riel <riel@redhat.com>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> ---
>>  mm/compaction.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index dea32e3..9f80b5a 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -335,7 +335,7 @@ static unsigned long isolate_migratepages(struct zone *zone,
>>               }
>>
>>               /* Try isolate the page */
>> -             if (__isolate_lru_page(page, ISOLATE_BOTH, 0, 0, 0) != 0)
>> +             if (__isolate_lru_page(page, ISOLATE_BOTH, 0, !cc->sync, 0) != 0)
>>                       continue;
>
> With the suggested flags argument from 1/8, this would look like:
>
>        flags = ISOLATE_BOTH;
>        if (!cc->sync)
>                flags |= ISOLATE_CLEAN;
>
> ?

Yes. I will change it.

>
> Anyway, nice change indeed!

Thanks!


-- 
Kind regards,
Minchan Kim
