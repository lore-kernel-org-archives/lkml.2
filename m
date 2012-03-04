Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab2CDFUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 00:20:07 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42641 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab2CDFUF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 00:20:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linkinjeon@gmail.com designates 10.180.107.67 as permitted sender) smtp.mail=linkinjeon@gmail.com; dkim=pass header.i=linkinjeon@gmail.com
MIME-Version: 1.0
In-Reply-To: <878vjhv1t7.fsf@devron.myhome.or.jp>
References: <1330737405-7129-1-git-send-email-linkinjeon@gmail.com>
	<878vjhv1t7.fsf@devron.myhome.or.jp>
Date: Sun, 4 Mar 2012 14:20:03 +0900
Message-ID: <CAKYAXd9jnXAUMuQGzQhK2-oDVdNfYoKMe9doY=PBTFiZWzUu6A@mail.gmail.com>
Subject: Re: [PATCH 2/2] fat: Fix bug in enforcing Long File Name length.
From: Namjae Jeon <linkinjeon@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ravishankar N <cyberax82@gmail.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. Andrew.

Would you plz check this patch also ?

Thanks.

2012/3/4 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>  Since '*outlen' is initialized to zero,it is currently possible to create a f ilename of length (FAT_LFN_LEN +1) when utf8 is not enabled.To enforce the FA T_LFN_LEN limit, we must perform one less iteration.
>
> Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>> Signed-off-by: Ravishankar N <cyberax82@gmail.com>
>> ---
>>  fs/fat/namei_vfat.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
>> index aae3b4e..98ae804 100644
>> --- a/fs/fat/namei_vfat.c
>> +++ b/fs/fat/namei_vfat.c
>> @@ -522,7 +522,7 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
>>               op = &outname[*outlen * sizeof(wchar_t)];
>>       } else {
>>               for (i = 0, ip = name, op = outname, *outlen = 0;
>> -                      i < len && *outlen <= FAT_LFN_LEN;
>> +                      i < len && *outlen < FAT_LFN_LEN;
>>                        *outlen += 1) {
>>                       if (escape && (*ip == ':')) {
>>                               if (i > len - 5)
>
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
