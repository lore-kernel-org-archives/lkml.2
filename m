Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab1F1XXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 19:23:16 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56979 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab1F1XXL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 19:23:11 -0400
MIME-Version: 1.0
In-Reply-To: <20110628125249.GX9396@suse.de>
References: <1308926697-22475-1-git-send-email-mgorman@suse.de>
	<1308926697-22475-4-git-send-email-mgorman@suse.de>
	<BANLkTinH_EcYUAAsrGmboMywqPcCfye2gg@mail.gmail.com>
	<20110628125249.GX9396@suse.de>
Date: Wed, 29 Jun 2011 08:23:10 +0900
Message-ID: <BANLkTik16=kYyNtK-h-z3Ex64yPHUHFnVQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] mm: vmscan: Evaluate the watermarks against the
 correct classzone
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "P?draig Brady" <P@draigbrady.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Colin King <colin.king@canonical.com>,
        Andrew Lutomirski <luto@mit.edu>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 9:52 PM, Mel Gorman <mgorman@suse.de> wrote:
> On Mon, Jun 27, 2011 at 03:53:04PM +0900, Minchan Kim wrote:
>> On Fri, Jun 24, 2011 at 11:44 PM, Mel Gorman <mgorman@suse.de> wrote:
>> > When deciding if kswapd is sleeping prematurely, the classzone is
>> > taken into account but this is different to what balance_pgdat() and
>> > the allocator are doing. Specifically, the DMA zone will be checked
>> > based on the classzone used when waking kswapd which could be for a
>> > GFP_KERNEL or GFP_HIGHMEM request. The lowmem reserve limit kicks in,
>> > the watermark is not met and kswapd thinks its sleeping prematurely
>> > keeping kswapd awake in error.
>>
>>
>> I thought it was intentional when you submitted a patch firstly.
>
> It was, it also wasn't right.
>
>> "Kswapd makes sure zones include enough free pages(ie, include reserve
>> limit of above zones).
>> But you seem to see DMA zone can't meet above requirement forever in
>> some situation so that kswapd doesn't sleep.
>> Right?
>>
>
> Right.
>
>> >
>> > Reported-and-tested-by: Pádraig Brady <P@draigBrady.com>
>> > Signed-off-by: Mel Gorman <mgorman@suse.de>
>> > ---
>> >  mm/vmscan.c |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/mm/vmscan.c b/mm/vmscan.c
>> > index 9cebed1..a76b6cc2 100644
>> > --- a/mm/vmscan.c
>> > +++ b/mm/vmscan.c
>> > @@ -2341,7 +2341,7 @@ static bool sleeping_prematurely(pg_data_t *pgdat, int order, long remaining,
>> >                }
>> >
>> >                if (!zone_watermark_ok_safe(zone, order, high_wmark_pages(zone),
>> > -                                                       classzone_idx, 0))
>> > +                                                       i, 0))
>>
>> Isn't it  better to use 0 instead of i?
>>
>
> I considered it but went with i to compromise between making sure zones
> included enough free pages without requiring that ZONE_DMA meet an
> almost impossible requirement when under continual memory pressure.

I see.
Thanks, Mel.

-- 
Kind regards,
Minchan Kim
