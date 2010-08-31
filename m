Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab0HaBKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 21:10:20 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62911 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab0HaBKS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 21:10:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kBryG0XSpJRMnD5ChYUjLIvFbO2hOIQKb7PSS+akGt+yxZjhq8Zwk5Au5NVWjLrnrV
         2mmxk0WKfbBh4m/tkoju1lUbX1lK10ighPLzDUR7fEW0yMe+ORv6k6tlls92xnkrtJSC
         wlSBmX4j1q9TVaMPqfvD4vCEZjnMqnbz7OY3M=
MIME-Version: 1.0
In-Reply-To: <20100831095542.87CA.A69D9226@jp.fujitsu.com>
References: <AANLkTinqm0o=AfmgFy+SpZ1mrdekRnjeXvs_7=OcLii8@mail.gmail.com>
	<AANLkTikbs9sUVLhE4sWWVw8uEqY=v6SCdJ_6FLhXY6HW@mail.gmail.com>
	<20100831095542.87CA.A69D9226@jp.fujitsu.com>
Date: Tue, 31 Aug 2010 10:10:17 +0900
Message-ID: <AANLkTi=NsY9T19rXuBWmeZ3Z2ayA=tHZ1+e=cEXuKVAt@mail.gmail.com>
Subject: Re: [PATCH] vmscan: prevent background aging of anon page in no swap system
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, KOSAKI.

On Tue, Aug 31, 2010 at 9:56 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 1b145e6..0b8a3ce 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1747,7 +1747,7 @@ static void shrink_zone(int priority, struct zone *zone,
>>          * Even if we did not try to evict anon pages at all, we want to
>>          * rebalance the anon lru active/inactive ratio.
>>          */
>> -       if (inactive_anon_is_low(zone, sc) && nr_swap_pages > 0)
>> +       if (nr_swap_pges > 0 && inactive_anon_is_low(zone, sc))
>
> Sorry, I don't find any difference. What is your intention?
>

My intention is that smart gcc can compile out inactive_anon_is_low
call in case of non swap configurable system.

-- 
Kind regards,
Minchan Kim
