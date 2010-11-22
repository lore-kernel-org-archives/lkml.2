Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab0KVB06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:26:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450Ab0KVB05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:26:57 -0500
Message-ID: <4CE9C6CF.20105@redhat.com>
Date: Sun, 21 Nov 2010 20:26:39 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] vmscan: Make move_active_pages_to_lru more generic
References: <1290349496-13297-1-git-send-email-minchan.kim@gmail.com>	<4CE95FD7.1060805@redhat.com> <AANLkTimSE2j71uFPCZWBFdau4NE_hmTtTMvUOBWOdMhF@mail.gmail.com>
In-Reply-To: <AANLkTimSE2j71uFPCZWBFdau4NE_hmTtTMvUOBWOdMhF@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2010 07:49 PM, Minchan Kim wrote:
> On Mon, Nov 22, 2010 at 3:07 AM, Rik van Riel<riel@redhat.com>  wrote:
>> On 11/21/2010 09:24 AM, Minchan Kim wrote:
>>>
>>> Now move_active_pages_to_lru can move pages into active or inactive.
>>> if it moves the pages into inactive, it itself can clear PG_acive.
>>> It makes the function more generic.
>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index aa4f1cb..bd408b3 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -1457,6 +1457,10 @@ static void move_active_pages_to_lru(struct zone
>>> *zone,
>>>                 VM_BUG_ON(PageLRU(page));
>>>                 SetPageLRU(page);
>>>
>>> +               /* we are de-activating */
>>> +               if (!is_active_lru(lru))
>>> +                       ClearPageActive(page);
>>> +
>>
>> Does that mean we also want code to ensure that pages have
>> the PG_active bit set when we add them to an active list?
>
> Yes. the function name is move_"active"_pages_to_lru.
> So  caller have to make sure pages have PG_active.

Good point.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
