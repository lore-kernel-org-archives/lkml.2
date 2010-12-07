Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab0LGWTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 17:19:37 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37889 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab0LGWTg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 17:19:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ju/mNxKAnXUEn1zLbNOX+Uq9/2nJh6C5K5vv8gFS2pcF44ZQ0gM34G6xFCHko3KTI0
         6PjfnY2abeP0xD+3E0KrXJFq2Q9HXfZ4+E3U8YZdfGjFcMHbhTpIS4KbZIzAn4rTFNoQ
         G0DCmOZBKABbYj7CL6k05nPzrtHPwl3JZp1VE=
MIME-Version: 1.0
In-Reply-To: <20101207135301.49898964.akpm@linux-foundation.org>
References: <1291734086-1405-1-git-send-email-minchan.kim@gmail.com>
	<20101207135301.49898964.akpm@linux-foundation.org>
Date: Wed, 8 Dec 2010 07:19:35 +0900
Message-ID: <AANLkTi=qr4GV8Uh6Rk76FkDUtr=NqydERmWqcxDn8HT0@mail.gmail.com>
Subject: Re: [PATCH] compaction: Remove mem_cgroup_del_lru
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 6:53 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed,  8 Dec 2010 00:01:26 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> del_page_from_lru_list alreay called mem_cgroup_del_lru.
>> So we need to call it again. It makes wrong stat of memcg and
>> even happen VM_BUG_ON hit.
>>
>> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
>> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> Cc: Mel Gorman <mel@csn.ul.ie>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> ---
>>  mm/compaction.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index 50b0a90..b0fbfdf 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -302,7 +302,6 @@ static unsigned long isolate_migratepages(struct zone *zone,
>>               /* Successfully isolated */
>>               del_page_from_lru_list(zone, page, page_lru(page));
>>               list_add(&page->lru, migratelist);
>> -             mem_cgroup_del_lru(page);
>>               cc->nr_migratepages++;
>>               nr_isolated++;
>>
>
> err, yes, that looks bad.
>
> This bug is present in 2.6.35 and 2.6.36 afaict, so I tagged the fix
> for -stable backporting.

Thanks, Andrew.

>
>



-- 
Kind regards,
Minchan Kim
