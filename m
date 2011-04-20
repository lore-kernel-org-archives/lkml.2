Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1DTW7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 18:59:33 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60744 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab1DTW7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 18:59:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X9sJ6/YAmeOXFvF/w7rqatQHF1i9ibA6Qh57kydm9c+dSw+R5Q02GiX5KpBX0mx5wt
         F4RdfyIZiQ75DMWmVGNdYwPPtGRKBfbMthyVFa2OTsYzJ/InJpP8FbMJsX169ys6UfnS
         J0rYx7brNCXHK+1N1gG0KHLHqPx7xDKXlHjNg=
MIME-Version: 1.0
In-Reply-To: <201104201631.40017.arnd@arndb.de>
References: <1303309252-9946-1-git-send-email-akinobu.mita@gmail.com>
	<201104201631.40017.arnd@arndb.de>
Date: Thu, 21 Apr 2011 07:59:30 +0900
Message-ID: <BANLkTimBF312svk0mRkt5_Y=t+B12cLW+Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] bitops: add ifdef CONFIG_GENERIC_FIND_BIT_LE guard
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/20 Arnd Bergmann <arnd@arndb.de>:
> On Wednesday 20 April 2011, Akinobu Mita wrote:
>> index 946a21b..bd2253e 100644
>> --- a/include/asm-generic/bitops/le.h
>> +++ b/include/asm-generic/bitops/le.h
>> @@ -30,6 +30,8 @@ static inline unsigned long find_first_zero_bit_le(const void *addr,
>>
>>  #define BITOP_LE_SWIZZLE       ((BITS_PER_LONG-1) & ~0x7)
>>
>> +#ifdef CONFIG_GENERIC_FIND_BIT_LE
>> +
>>  extern unsigned long find_next_zero_bit_le(const void *addr,
>>                 unsigned long size, unsigned long offset);
>>  extern unsigned long find_next_bit_le(const void *addr,
>> @@ -38,6 +40,8 @@ extern unsigned long find_next_bit_le(const void *addr,
>>  #define find_first_zero_bit_le(addr, size) \
>>         find_next_zero_bit_le((addr), (size), 0)
>>
>> +#endif /* CONFIG_GENERIC_FIND_BIT_LE */
>> +
>>  #else
>>  #error "Please fix <asm/byteorder.h>"
>>  #endif
>
> The style that we normally use in asm-generic is to test the macro itself
> for existence, so in asm-generic, do:
>
> #ifndef find_next_zero_bit_le
> extern unsigned long find_next_zero_bit_le(const void *addr,
>                 unsigned long size, unsigned long offset);
> #endif
>
> and in the architectures, write
>
> static inline unsigned long find_next_zero_bit_le(const void *addr,
>                 unsigned long size, unsigned long offset)
> #define find_next_zero_bit_le find_next_zero_bit_le
>
> I guess we can do the #ifdef separately for each of the three macros,
> or choose one of them to use as a key.

I see.

Should we also kill CONFIG_GENERIC_FIND_BIT_LE option comletely,
then add the #ifdef for each find_*() in lib/find_next_bit.c and always build
it unconditionally ?
