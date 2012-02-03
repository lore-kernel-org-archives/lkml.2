Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab2BCPue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 10:50:34 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45470 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab2BCPud convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 10:50:33 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Hillf Danton" <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 08/15] mm: mmzone: MIGRATE_CMA migration type added
References: <1328271538-14502-1-git-send-email-m.szyprowski@samsung.com>
 <1328271538-14502-9-git-send-email-m.szyprowski@samsung.com>
 <CAJd=RBByc_wLEJTK66J4eY03CWnCoCRiwAeEYjXCZ5xEZhp3ag@mail.gmail.com>
Date: Fri, 03 Feb 2012 16:50:30 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v830ygma3l0zgt@mpn-glaptop>
In-Reply-To: <CAJd=RBByc_wLEJTK66J4eY03CWnCoCRiwAeEYjXCZ5xEZhp3ag@mail.gmail.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Feb 3, 2012 at 8:18 PM, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
>> From: Michal Nazarewicz <mina86@mina86.com>
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index d5174c4..a6e7c64 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -45,6 +45,11 @@ static void map_pages(struct list_head *list)
>>        }
>>  }
>>
>> +static inline bool migrate_async_suitable(int migratetype)

On Fri, 03 Feb 2012 15:19:54 +0100, Hillf Danton <dhillf@gmail.com> wrote:
> Just nitpick, since the helper is not directly related to what async means,
> how about migrate_suitable(int migrate_type) ?

I feel current name is better suited since it says that it's OK to scan this
block if it's an asynchronous compaction run.

>> +{
>> +       return is_migrate_cma(migratetype) || migratetype == MIGRATE_MOVABLE;
>> +}
>> +
>>  /*
>>  * Isolate free pages onto a private freelist. Caller must hold zone->lock.
>>  * If @strict is true, will abort returning 0 on any invalid PFNs or non-free
>> @@ -277,7 +282,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
>>                 */
>>                pageblock_nr = low_pfn >> pageblock_order;
>>                if (!cc->sync && last_pageblock_nr != pageblock_nr &&
>> -                               get_pageblock_migratetype(page) != MIGRATE_MOVABLE) {
>> +                   migrate_async_suitable(get_pageblock_migratetype(page))) {
>
> Here compaction looks corrupted if CMA not enabled, Mel?

Damn, yes, this should be !migrate_async_suitable(...).  Sorry about that.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
