Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750942Ab1FJEXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 00:23:03 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40225 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1FJEWz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 00:22:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hNJ+b6+Uy60OcVxzUfAb1AwDH5scoMojgPrNjCYw1EKhzVedogBTL5i+vFkx/87QQk
         rDRdGiekhK9hiGKD1xoxC2SiX3is0GsYJS9fUhMB6M0AcaGUHTFZjKAz9vvDKw3/x1WA
         7FlQDvSkRA4927MLjYLuyC7Bd69KWvLDlfC5s=
MIME-Version: 1.0
In-Reply-To: <1307675815.1537.9.camel@epip-laptop>
References: <1307617752-23426-1-git-send-email-gxt@mprc.pku.edu.cn>
	<BANLkTikNC8uh-X_0iJZH3tYd_kf46W1Rwg@mail.gmail.com>
	<BANLkTimWYjzxhQBH2A76D590KBfjKbguTA@mail.gmail.com>
	<1307675815.1537.9.camel@epip-laptop>
Date: Fri, 10 Jun 2011 13:22:54 +0900
Message-ID: <BANLkTi=aVFisCuS-W-4iNSmDVCtKOWD5_w@mail.gmail.com>
Subject: Re: [PATCH] unicore32: fix build error for find bitops
From: Akinobu Mita <akinobu.mita@gmail.com>
To: gxt@mprc.pku.edu.cn
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        greg@kroah.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/10 Guan Xuetao <gxt@mprc.pku.edu.cn>:
> On Thu, 2011-06-09 at 23:05 +0900, Akinobu Mita wrote:
>> 2011/6/9 Akinobu Mita <akinobu.mita@gmail.com>:
>> > 2011/6/9 GuanXuetao <gxt@mprc.pku.edu.cn>:
>> >> From: Guan Xuetao <gxt@mprc.pku.edu.cn>
>> >>
>> >> Remove the __uc32_ prefix in find bitops functions.
>> >> see commit <19de85ef574c3a2182e3ccad9581805052f14946>
>> >>  bitops: add #ifndef for each of find bitops
>> >>
>> >> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
>> >> Cc: Akinobu Mita <akinobu.mita@gmail.com>
>> >> ---
>> >>  arch/unicore32/include/asm/bitops.h |    6 ------
>> >>  arch/unicore32/kernel/ksyms.c       |    4 ++--
>> >>  arch/unicore32/lib/findbit.S        |   14 ++++++++------
>> >>  3 files changed, 10 insertions(+), 14 deletions(-)
>> >>
>> >> diff --git a/arch/unicore32/include/asm/bitops.h b/arch/unicore32/include/asm/bitops.h
>> >> index 1628a63..a9653f0 100644
>> >> --- a/arch/unicore32/include/asm/bitops.h
>> >> +++ b/arch/unicore32/include/asm/bitops.h
>> >> @@ -13,12 +13,6 @@
>> >>  #ifndef __UNICORE_BITOPS_H__
>> >>  #define __UNICORE_BITOPS_H__
>> >>
>> >> -#define find_next_bit          __uc32_find_next_bit
>> >> -#define find_next_zero_bit     __uc32_find_next_zero_bit
>> >> -
>> >> -#define find_first_bit         __uc32_find_first_bit
>> >> -#define find_first_zero_bit    __uc32_find_first_zero_bit
>> >> -
>> >
>> > Is this patch really fix the build error?
>> >
>> > If these find_*_bit macros are removed, vmlinux will have multiple
>> > definisions of find_*_bit. Because lib/find_next_bit.c is built
>> > unconditionally after the commit 63e424c84429903c92a0f1e9654c31ccaf6694d0
>> > ("arch: remove CONFIG_GENERIC_FIND_{NEXT_BIT,BIT_LE,LAST_BIT}".
>>
>> The attached patch hopefully fix the build error but it is untested
>> because I can't find crosstool for unicore32. So could you apply
>> this patch on top of your patch and check whether it fixes?
>
> Thanks Akinobu.
> I want to avoid the duplication of the 'extern' function definitions in
> asm-generic header and arch-specific header.

OK then adding the following four lines after asm-generic/bitops.h
inclusion should fix the problem.

#define find_next_bit find_next_bit
#define find_next_zero_bit find_next_zero_bit
#define find_first_bit find_first_bit
#define find_first_zero_bit find_first_zero_bit
