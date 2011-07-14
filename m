Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab1GNEkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 00:40:19 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:61800 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab1GNEkS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 00:40:18 -0400
MIME-Version: 1.0
In-Reply-To: <20110714134228.65fb79c5@notabene.brown>
References: <CAFR8uecaG68Oifuz1ucpM49vaw5m420Cn0et-JQZjBjhsOes-Q@mail.gmail.com>
	<20110714134228.65fb79c5@notabene.brown>
Date: Wed, 13 Jul 2011 21:40:17 -0700
Message-ID: <CAFR8uefeBTK8PaGO0h=-fbnjaxhUro7WS2WNVczdAfsqHFbBBw@mail.gmail.com>
Subject: Re: [PATCH]:drivers/md/raid10.c: r10buf_pool_alloc(): Set bi_vcnt for
 the new bio.
From: Muthu Kumar <muthu.lkml@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

>>
>> BTW, why are we not using bio_add_page() here to add the page to bio?
>
> How would that be useful?  We don't know what the underlying device is at
> this point, and the point of bio_add_page is to make sure the device can
> handle the extra page.
>
> We do call bio_add_page at the appropriate time in sync_request().

Yes. Thanks for the explanation.

Regards,
Muthu

>
> So - not applied.
>
> Thanks,
> NeilBrown
>
>
>>
>> Signed-off-by: Muthukumar R <muthur@gmail.com>
>>
>> ------
>>  drivers/md/raid10.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>> ------
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 6e84668..8504c5b 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -129,6 +129,7 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
>>
>>                         bio->bi_io_vec[i].bv_page = page;
>>                 }
>> +               bio->bi_vcnt = RESYNC_PAGES;
>>         }
>>
>>         return r10_bio;
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
