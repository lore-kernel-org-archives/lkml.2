Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275Ab2H0B0b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 21:26:31 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:40233 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab2H0B0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 21:26:30 -0400
MIME-Version: 1.0
In-Reply-To: <878vd1wy39.fsf@devron.myhome.or.jp>
References: <1345883011-6263-1-git-send-email-linkinjeon@gmail.com>
	<878vd1wy39.fsf@devron.myhome.or.jp>
Date: Mon, 27 Aug 2012 10:26:29 +0900
Message-ID: <CAKYAXd_1dv7Z-f7TjrKAi+kEV33OQXWCjZ-oYoakBk-9ofcv0g@mail.gmail.com>
Subject: Re: [PATCH 2/2] fat : no need to reset EOF in ent_put for FAT32
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/26, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> #define FAT_ENT_EOF(EOF_FAT32)
>>
>> there is no need to reset value of 'new' for FAT32 as the values is
>> already correct
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
>> ---
>>  fs/fat/fatent.c |    2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
>> index 31f08ab..af53815 100644
>> --- a/fs/fat/fatent.c
>> +++ b/fs/fat/fatent.c
>> @@ -186,8 +186,6 @@ static void fat16_ent_put(struct fat_entry *fatent,
>> int new)
>>
>>  static void fat32_ent_put(struct fat_entry *fatent, int new)
>>  {
>> -	if (new == FAT_ENT_EOF)
>> -		new = EOF_FAT32;
Hi OGAWA..
Okay, I will resend v2 patch after removing line.
Thanks.
>>
>
> Please remove this new line too. If it was removed,
>
> Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
>>  	WARN_ON(new & 0xf0000000);
>>  	new |= le32_to_cpu(*fatent->u.ent32_p) & ~0x0fffffff;
>
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
