Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab1KSJdJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 04:33:09 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41214 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab1KSJdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 04:33:07 -0500
Message-ID: <4EC77662.7090002@gmail.com>
Date: Sat, 19 Nov 2011 10:26:58 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andrei Warkentin <andreiw@vmware.com>, linux-kernel@vger.kernel.org,
        Rolf Eike Beer <eike-kernel@sf-tec.de>, opensuse-kernel@opensuse.org,
        Sergiu Iordache <sergiu@chromium.org>,
        Eddie Wai <eddie.wai@broadcom.com>,
        Jayamohan Kallickal <jayamohan.kallickal@emulex.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] include/log2.h: Fix rounddown_pow_of_two(1)
References: <1321473366-31053-1-git-send-email-andreiw@vmware.com> <20111117150549.15528e81.akpm@linux-foundation.org>
In-Reply-To: <20111117150549.15528e81.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/11/2011 00:05, Andrew Morton ha scritto:
> On Wed, 16 Nov 2011 14:56:06 -0500
> Andrei Warkentin<andreiw@vmware.com>  wrote:
>
>> 1 is a power of two, therefore rounddown_pow_of_two(1) should return 1. It does
>> in case the argument is a variable but in case it's a constant it behaves
>> wrong and returns 0. Probably nobody ever did it so this was never noticed,
>> however net/drivers/vmxnet3 with latest GCC does and breaks on unicpu systems.
>>
>> This is similar to Rolf's patch to roundup_pow_of_two(1).
>>
>> Cc: Rolf Eike Beer<eike-kernel@sf-tec.de>
>> Cc: opensuse-kernel@opensuse.org
>> Reviewed-by: Jesper Juhl<jj@chaosbits.net>
>> Signed-off-by: Andrei Warkentin<andreiw@vmware.com>
>> ---
>>   include/linux/log2.h |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/log2.h b/include/linux/log2.h
>> index 25b8086..ccda848 100644
>> --- a/include/linux/log2.h
>> +++ b/include/linux/log2.h
>> @@ -185,7 +185,7 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
>>   #define rounddown_pow_of_two(n)			\
>>   (						\
>>   	__builtin_constant_p(n) ? (		\
>> -		(n == 1) ? 0 :			\
>> +		(n == 1) ? 1 :			\
>>   		(1UL<<  ilog2(n))) :		\
>>   	__rounddown_pow_of_two(n)		\
>>    )
>
> I assume that nobody has gone off and checked whether all current
> callers will survive this change.  If they had, they'd have looked in
> drivers/char/ramoops.c and seen:
>
> 	rounddown_pow_of_two(pdata->mem_size);
> 	rounddown_pow_of_two(pdata->record_size);
>
> These operations are no-ops.  It should be
>
> 	pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
> 	pdata->record_size = rounddown_pow_of_two(pdata->record_size);
>
> Marco or Sergio: please fix, test and send it over sometime?

Ok, I'll look at it.

Marco
