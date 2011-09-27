Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab1I0Rwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:52:38 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:54480 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab1I0Rwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:52:37 -0400
MIME-Version: 1.0
In-Reply-To: <87hb3xj41s.fsf@devron.myhome.or.jp>
References: <CAK1hOcNus4RKQOF=eivuCXFEM5Lqb+jBdOD4YrMA_5bL2EB6yA@mail.gmail.com>
	<542eeafb16d173360eb79f8188f967cc3dcc9252.1317124046.git.andriy.shevchenko@linux.intel.com>
	<87hb3xj41s.fsf@devron.myhome.or.jp>
Date: Tue, 27 Sep 2011 20:52:37 +0300
Message-ID: <CAHp75Ve8TAZg96n-R8WHvAm_DKxr7y0b6XST1X-jR5aiat-Qsg@mail.gmail.com>
Subject: Re: [PATCHv2] fat: don't use custom hex_to_bin()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8RHqjmO025842

On Tue, Sep 27, 2011 at 8:19 PM, OGAWA Hirofumi
<hirofumi@mail.parknet.co.jp> wrote:
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:
>
> Looks good to me.
>
> Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
> Or if it's needed, I'll apply this to fat tree.
I guess so. Thanks!

>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>> ---
>>  fs/fat/namei_vfat.c |   30 ++++++++----------------------
>>  1 files changed, 8 insertions(+), 22 deletions(-)
>>
>> diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
>> index bb3f29c..cf0fd96 100644
>> --- a/fs/fat/namei_vfat.c
>> +++ b/fs/fat/namei_vfat.c
>> @@ -21,6 +21,8 @@
>>  #include <linux/slab.h>
>>  #include <linux/buffer_head.h>
>>  #include <linux/namei.h>
>> +#include <linux/kernel.h>
>> +
>>  #include "fat.h"
>>
>>  /*
>> @@ -505,10 +507,8 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
>>            struct nls_table *nls)
>>  {
>>       const unsigned char *ip;
>> -     unsigned char nc;
>>       unsigned char *op;
>> -     unsigned int ec;
>> -     int i, k, fill;
>> +     int i, rc, fill;
>>       int charlen;
>>
>>       if (utf8) {
>> @@ -528,26 +528,12 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
>>                               if (escape && (*ip == ':')) {
>>                                       if (i > len - 5)
>>                                               return -EINVAL;
>> -                                     ec = 0;
>> -                                     for (k = 1; k < 5; k++) {
>> -                                             nc = ip[k];
>> -                                             ec <<= 4;
>> -                                             if (nc >= '0' && nc <= '9') {
>> -                                                     ec |= nc - '0';
>> -                                                     continue;
>> -                                             }
>> -                                             if (nc >= 'a' && nc <= 'f') {
>> -                                                     ec |= nc - ('a' - 10);
>> -                                                     continue;
>> -                                             }
>> -                                             if (nc >= 'A' && nc <= 'F') {
>> -                                                     ec |= nc - ('A' - 10);
>> -                                                     continue;
>> -                                             }
>> +
>> +                                     rc = hex2bin(op, ip + 1, 2);
>> +                                     if (rc < 0)
>>                                               return -EINVAL;
>> -                                     }
>> -                                     *op++ = ec & 0xFF;
>> -                                     *op++ = ec >> 8;
>> +
>> +                                     op += 2;
>>                                       ip += 5;
>>                                       i += 5;
>>                               } else {
>
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
With Best Regards,
Andy Shevchenko
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
