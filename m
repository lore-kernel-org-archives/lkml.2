Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab1EAXAs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 19:00:48 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49422 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab1EAXAr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 19:00:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SHVRurYL3Udb2CyYX5puHq6yZ4BJ95ax4gn7FQcF846p9paI1uQTMnMo3Q5uGbQHXY
         SikYammHYeRVKpMaDPD53+I7E0Lk4NWzBU36F6wJ8P89Dyyo6G6Sz767p6mbnxWDfWoY
         Ctmqm4uAGb4obLPdwJcz/6coA2ttJWK9lyouE=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=c2tBcXJnFi-i4r1_ADiMFebmxMA@mail.gmail.com>
References: <cover.1304261567.git.minchan.kim@gmail.com>
	<c7a7b3ceafe4fdc4bc038774374504827c01481f.1304261567.git.minchan.kim@gmail.com>
	<BANLkTi=c2tBcXJnFi-i4r1_ADiMFebmxMA@mail.gmail.com>
Date: Mon, 2 May 2011 08:00:46 +0900
Message-ID: <BANLkTim1k-wGA1j9Cv1scCNR_-5b9BqESQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] Check PageUnevictable in lru_deactivate_fn
From: Minchan Kim <minchan.kim@gmail.com>
To: Ying Han <yinghan@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 2, 2011 at 7:10 AM, Ying Han <yinghan@google.com> wrote:
> On Sun, May 1, 2011 at 8:03 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
>> The lru_deactivate_fn should not move page which in on unevictable lru
>> into inactive list. Otherwise, we can meet BUG when we use isolate_lru_pages
>> as __isolate_lru_page could return -EINVAL.
>> It's really BUG and let's fix it.
>>
>> Reported-by: Ying Han <yinghan@google.com>
>> Tested-by: Ying Han <yinghan@google.com>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> ---
>>  mm/swap.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/mm/swap.c b/mm/swap.c
>> index a83ec5a..2e9656d 100644
>> --- a/mm/swap.c
>> +++ b/mm/swap.c
>> @@ -429,6 +429,9 @@ static void lru_deactivate_fn(struct page *page, void *arg)
>>        if (!PageLRU(page))
>>                return;
>>
>> +       if (PageUnevictable(page))
>> +               return;
>> +
>>        /* Some processes are using the page */
>>        if (page_mapped(page))
>>                return;
>> --
>> 1.7.1
>
> Thanks Minchan for the fix, and i haven't been able to reproducing the
> issue after applying the patch.

Thanks for the help, Ying.

-- 
Kind regards,
Minchan Kim
