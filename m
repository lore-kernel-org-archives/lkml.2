Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab2GYS0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 14:26:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab2GYS0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 14:26:52 -0400
Message-ID: <501039F6.7010702@redhat.com>
Date: Wed, 25 Jul 2012 14:24:54 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH -mm] remove __GFP_NO_KSWAPD
References: <20120724111222.2c5e6b30@annuminas.surriel.com> <20120724233422.GB14411@bbox>
In-Reply-To: <20120724233422.GB14411@bbox>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 07:34 PM, Minchan Kim wrote:
> Hi Rik,
>
> On Tue, Jul 24, 2012 at 11:12:22AM -0400, Rik van Riel wrote:
>> When transparent huge pages were introduced, memory compaction and
>> swap storms were an issue, and the kernel had to be careful to not
>> make THP allocations cause pageout or compaction.
>>
>> Now that we have working compaction deferral, kswapd is smart enough
>> to invoke compaction and the quadratic behaviour around isolate_free_pages
>> has been fixed, it should be safe to remove __GFP_NO_KSWAPD.
>
> Could you point out specific patches you mentiond which makes kswapd/compaction
> smart? It will make description very clear.

That could be a list of 50+ patches, merged over the
last two or so years.

In other words, such a large amount of data that it
is unlikely to clarify the discussion...

>> Signed-off-by: Rik van Riel <riel@redhat.com>
>
> I support it because I had a concern about that flags which is likely to be
> used by other subsystems without careful thinking when the flag was introduced.
> It's proved by mtd_kmalloc_up_to which was merged with sneaking without catching
> from mm guys's eyes. When I read comment of that function, it seems to be proper
> usage but I don't like it because it requries users of mm to know mm internal
> like kswapd. So it should be avoided if possible.
>
> Plus, it means you need to fix it with show_gfp_flags. :)

Ohh, a place I forgot to grep!

I'll send in an incremental patch right now.

>> ---
>> This has been running fine on my system for a while, but my system
>> only has 12GB and moderate memory pressure. I propose we keep this
>> in -mm and -next for a while, and merge it for 3.7 if nobody complains.
>
> Yes. it should be very careful.
> I guess Mel and Andrea would have opinions and benchmark.

It's not as much benchmarks that I am worried about,
but somebody running something unexpected on their
system.


