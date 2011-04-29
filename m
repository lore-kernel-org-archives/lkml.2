Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039Ab1D2PTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:19:47 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51888 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab1D2PTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:19:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r7KGZV2HFQ8AFGPaCeQ/g9FzB7aP9mUK7RQsCAK8/fHxPFCAXFTrrp2fJPGjk4nut2
         LMLtclY1JTxbhqNZpccgIRhJKAbZyCXSEtIlj1e2RhStCIKNVlIJ98VmmJ2g/l03P4ph
         QB9YuG/UPhioM1Ca4IAXmUqG4dOc/g8i/KoFg=
MIME-Version: 1.0
In-Reply-To: <20110428085816.GJ12437@cmpxchg.org>
References: <cover.1303833415.git.minchan.kim@gmail.com>
	<2b79bbf9ddceb73624f49bbe9477126147d875fd.1303833417.git.minchan.kim@gmail.com>
	<20110428085816.GJ12437@cmpxchg.org>
Date: Sat, 30 Apr 2011 00:19:44 +0900
Message-ID: <BANLkTi=iTvfrWQMnu2O-AvZhFgD0AfffDw@mail.gmail.com>
Subject: Re: [RFC 5/8] compaction: remove active list counting
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

On Thu, Apr 28, 2011 at 5:58 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Wed, Apr 27, 2011 at 01:25:22AM +0900, Minchan Kim wrote:
>> acct_isolated of compaction uses page_lru_base_type which returns only
>> base type of LRU list so it never returns LRU_ACTIVE_ANON or LRU_ACTIVE_FILE.
>> So it's pointless to add lru[LRU_ACTIVE_[ANON|FILE]] to get sum.
>>
>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: Rik van Riel <riel@redhat.com>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> ---
>>  mm/compaction.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index 9f80b5a..653b02b 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -219,8 +219,8 @@ static void acct_isolated(struct zone *zone, struct compact_control *cc)
>>               count[lru]++;
>>       }
>>
>> -     cc->nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
>> -     cc->nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
>> +     cc->nr_anon = count[LRU_INACTIVE_ANON];
>> +     cc->nr_file = count[LRU_INACTIVE_FILE];
>>       __mod_zone_page_state(zone, NR_ISOLATED_ANON, cc->nr_anon);
>>       __mod_zone_page_state(zone, NR_ISOLATED_FILE, cc->nr_file);
>>  }
>
> I don't see anything using cc->nr_anon and cc->nr_file outside this
> code.  Would it make sense to remove them completely?
>

Good idea.
I will remove it totally in next version.
Thanks, Hannes.


-- 
Kind regards,
Minchan Kim
