Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055Ab2IKLXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:23:20 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34794 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758888Ab2IKLXQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:23:16 -0400
MIME-Version: 1.0
In-Reply-To: <xa1tehm8yfmb.fsf@mina86.com>
References: <1347324112-14134-1-git-send-email-minchan@kernel.org>
	<xa1tehm8yfmb.fsf@mina86.com>
Date: Tue, 11 Sep 2012 20:23:14 +0900
X-Google-Sender-Auth: X-gcoDhzGDZyDRWNVc51kIdmlqU
Message-ID: <CAH9JG2V-ATcfe5_YkH6sMmm5UZFHt2SYBWnCNSpfsncGFU96mg@mail.gmail.com>
Subject: Re: [PATCH] mm: cma: Discard clean pages during contiguous allocation
 instead of migration
From: Kyungmin Park <kmpark@infradead.org>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/11/12, Michal Nazarewicz <mina86@mina86.com> wrote:
>
> On Tue, Sep 11 2012, Minchan Kim wrote:
>> This patch drops clean cache pages instead of migration during
>> alloc_contig_range() to minimise allocation latency by reducing the
>> amount
>> of migration is necessary. It's useful for CMA because latency of
>> migration
>> is more important than evicting the background processes working set.
>> In addition, as pages are reclaimed then fewer free pages for migration
>> targets are required so it avoids memory reclaiming to get free pages,
>> which is a contributory factor to increased latency.
>>
>> * from v1
>>   * drop migrate_mode_t
>>   * add reclaim_clean_pages_from_list instad of MIGRATE_DISCARD support -
>> Mel
>>
>> I measured elapsed time of __alloc_contig_migrate_range which migrates
>> 10M in 40M movable zone in QEMU machine.
>>
>> Before - 146ms, After - 7ms
>>
>> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
>> Cc: Michal Nazarewicz <mina86@mina86.com>
>
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
Tested-by: Kyungmin Park <kyungmin.park@samsung.com>
>
> Thanks!
>
> --
> Best regards,                                         _     _
> .o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
> ..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
> ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
