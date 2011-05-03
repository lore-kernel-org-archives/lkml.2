Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab1ECAai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 20:30:38 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44912 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab1ECAah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 20:30:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Hm3RSmy5I97adHA733FLkzAyGnvXt0Ur49qeCwKqC12A4gFEvG0QtSfTig9N8v2138
         2FHUmPaMRmhP5EZRnduGGQ1OxTq7/T42nI7FY9s6oJjBstOZFl/13E6dI2epRJTP2vGr
         2iZFOVG4xXvwmkVJc1ouPyjDfbx40HbQjSoek=
MIME-Version: 1.0
In-Reply-To: <4DBEC65B.4010201@redhat.com>
References: <cover.1304261567.git.minchan.kim@gmail.com>
	<dc54a5771cf1f580a91d16816100d4a2bcf2cdf5.1304261567.git.minchan.kim@gmail.com>
	<4DBEC65B.4010201@redhat.com>
Date: Tue, 3 May 2011 09:30:36 +0900
Message-ID: <BANLkTimNLcFVH=7kFSuLtzfYFewag7-hoA@mail.gmail.com>
Subject: Re: [PATCH 2/2] Filter unevictable page out in deactivate_page
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,

On Mon, May 2, 2011 at 11:57 PM, Rik van Riel <riel@redhat.com> wrote:
> On 05/01/2011 11:03 AM, Minchan Kim wrote:
>>
>> It's pointless that deactive_page's pagevec operation about
>> unevictable page as it's nop.
>> This patch removes unnecessary overhead which might be a bit problem
>> in case that there are many unevictable page in system(ex, mprotect
>> workload)
>>
>> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>
>> ---
>>  mm/swap.c |    9 +++++++++
>>  1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/mm/swap.c b/mm/swap.c
>> index 2e9656d..b707694 100644
>> --- a/mm/swap.c
>> +++ b/mm/swap.c
>> @@ -511,6 +511,15 @@ static void drain_cpu_pagevecs(int cpu)
>>   */
>>  void deactivate_page(struct page *page)
>>  {
>> +
>> +       /*
>> +        * In workload which system has many unevictable page(ex,
>> mprotect),
>> +        * unevictalge page deactivation for accelerating reclaim
>
> Typo.

My bad. I will resend after work.
Thanks.

-- 
Kind regards,
Minchan Kim
