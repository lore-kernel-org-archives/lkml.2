Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab2FLAFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 20:05:43 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60313 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab2FLAFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 20:05:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120611155919.7decee80.akpm@linux-foundation.org>
References: <1339211730-10398-1-git-send-email-linkinjeon@gmail.com>
	<20120611155919.7decee80.akpm@linux-foundation.org>
Date: Tue, 12 Jun 2012 09:05:40 +0900
Message-ID: <CAKYAXd_7SeWb0TN=nWCWLrj2bKOTq1QYpjksagR6HbXvnhyhxQ@mail.gmail.com>
Subject: Re: [PATCH] include: Fix compile warning in include/linux/bitops.h
From: Namjae Jeon <linkinjeon@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/12, Andrew Morton <akpm@linux-foundation.org>:
> On Fri,  8 Jun 2012 23:15:30 -0400
> Namjae Jeon <linkinjeon@gmail.com> wrote:
>
>> The compile warning is caused by __const_hweight8 when using
>> hweight_long with -Wsign-compare option.
>> The reason is that the default return value of this macro is signed.
>> So need type casting to remove warning.
>
> um, what warning?
Hi Andrew.
Sorry, I forgot it.
When we use hwight_long function, We can see the below warning message.

include/linux/bitops.h: In function 'hweight_long':
include/linux/bitops.h:49: warning: signed and unsigned type in
conditional expression

Thanks a lot.
>
> Please always quote the compiler messages when fixing build warnings or
> errors.
>
>> index fa2a50b..3ad0dae 100644
>> --- a/include/asm-generic/bitops/const_hweight.h
>> +++ b/include/asm-generic/bitops/const_hweight.h
>> @@ -4,7 +4,7 @@
>>  /*
>>   * Compile time versions of __arch_hweightN()
>>   */
>> -#define __const_hweight8(w)		\
>> +#define __const_hweight8(w)	(unsigned long)	\
>>        (	(!!((w) & (1ULL << 0))) +	\
>>  	(!!((w) & (1ULL << 1))) +	\
>>  	(!!((w) & (1ULL << 2))) +	\
>
>
