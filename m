Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab0KVAte (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 19:49:34 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44394 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab0KVAtd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 19:49:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qYkv0Wpi0eo0iBBsmF3jZ7dEPJ6tNVDY6V4ST3xZ9s/L3uBPOBe5EtnDKufGBmRfyP
         ZylwcWk/2pC5FPQzxQzDrnz4EItx09m2aqIKGtelwLaOSDV5AldYujdB6v63i3G5SnWE
         63aSFlXiegOCe6oWubKPVWs910zqUiDS2h1Sg=
MIME-Version: 1.0
In-Reply-To: <4CE95FD7.1060805@redhat.com>
References: <1290349496-13297-1-git-send-email-minchan.kim@gmail.com>
	<4CE95FD7.1060805@redhat.com>
Date: Mon, 22 Nov 2010 09:49:32 +0900
Message-ID: <AANLkTimSE2j71uFPCZWBFdau4NE_hmTtTMvUOBWOdMhF@mail.gmail.com>
Subject: Re: [PATCH] vmscan: Make move_active_pages_to_lru more generic
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 3:07 AM, Rik van Riel <riel@redhat.com> wrote:
> On 11/21/2010 09:24 AM, Minchan Kim wrote:
>>
>> Now move_active_pages_to_lru can move pages into active or inactive.
>> if it moves the pages into inactive, it itself can clear PG_acive.
>> It makes the function more generic.
>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index aa4f1cb..bd408b3 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1457,6 +1457,10 @@ static void move_active_pages_to_lru(struct zone
>> *zone,
>>                VM_BUG_ON(PageLRU(page));
>>                SetPageLRU(page);
>>
>> +               /* we are de-activating */
>> +               if (!is_active_lru(lru))
>> +                       ClearPageActive(page);
>> +
>
> Does that mean we also want code to ensure that pages have
> the PG_active bit set when we add them to an active list?

Yes. the function name is move_"active"_pages_to_lru.
So  caller have to make sure pages have PG_active.

>
> --
> All rights reversed
>



-- 
Kind regards,
Minchan Kim
