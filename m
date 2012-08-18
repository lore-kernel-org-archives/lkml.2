Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab2HRJyj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 05:54:39 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62146 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab2HRJyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 05:54:36 -0400
MIME-Version: 1.0
In-Reply-To: <871ujclpqk.fsf@devron.myhome.or.jp>
References: <1344743810-2443-1-git-send-email-linkinjeon@gmail.com>
	<871ujclpqk.fsf@devron.myhome.or.jp>
Date: Sat, 18 Aug 2012 18:54:35 +0900
Message-ID: <CAKYAXd8qH4YwFJQR6SRbfvSiQwmdpd_JuA52iDS3EEY1Va3yPQ@mail.gmail.com>
Subject: Re: [PATCH] fat: use accessor function for msdos_dir_entry 'start'
From: Namjae Jeon <linkinjeon@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Amit Sahrawat <amit.sahrawat83@gmail.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/12, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> Use accessor function for msdos_dir_entry 'start'
>
> Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
> Looks good. Thanks.
>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
>> ---
>>  fs/fat/dir.c |    6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/fat/dir.c b/fs/fat/dir.c
>> index 7b1b9c1..2f3e66e 100644
>> --- a/fs/fat/dir.c
>> +++ b/fs/fat/dir.c
>> @@ -1143,10 +1143,8 @@ int fat_alloc_new_dir(struct inode *dir, struct
>> timespec *ts)
>>  		de[0].ctime_cs = de[1].ctime_cs = 0;
>>  		de[0].adate = de[0].cdate = de[1].adate = de[1].cdate = 0;
>>  	}
>> -	de[0].start = cpu_to_le16(cluster);
>> -	de[0].starthi = cpu_to_le16(cluster >> 16);
>> -	de[1].start = cpu_to_le16(MSDOS_I(dir)->i_logstart);
>> -	de[1].starthi = cpu_to_le16(MSDOS_I(dir)->i_logstart >> 16);
>> +	fat_set_start(&de[0], cluster);
>> +	fat_set_start(&de[1], MSDOS_I(dir)->i_logstart);
>>  	de[0].size = de[1].size = 0;
>>  	memset(de + 2, 0, sb->s_blocksize - 2 * sizeof(*de));
>>  	set_buffer_uptodate(bhs[0]);
>
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
Hi. Andrew.

Would you plz check this patch ?

Thanks.
