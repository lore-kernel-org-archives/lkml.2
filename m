Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab2LSGhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 01:37:17 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:33520 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2LSGhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 01:37:12 -0500
Message-ID: <50D16094.1030101@linaro.org>
Date: Tue, 18 Dec 2012 22:37:08 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dong Zhu <bluezhudong@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] timekeeping: avoid adjust kernel time once hwclock kept
 in UTC time
References: <20121206140334.GA24261@zhudong.nay.redhat.com> <20121219051518.GA8584@zhudong.nay.redhat.com>
In-Reply-To: <20121219051518.GA8584@zhudong.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2012 09:15 PM, Dong Zhu wrote:
> On Thu, Dec 06, 2012 at 10:03:34PM +0800, Dong Zhu wrote:
>>  From c126376cf1837b0956e0268056db61870fbbc1d4 Mon Sep 17 00:00:00 2001
>> From: Dong Zhu <bluezhudong@gmail.com>
>> Date: Thu, 6 Dec 2012 21:45:00 +0800
>> Subject: [PATCH] timekeeping: avoid adjust kernel time once hwclock kept in
>>   UTC time
>>
>> If the Hardware Clock kept in local time,kernel will adjust the time
>> to be UTC time.But if Hardware Clock kept in UTC time,system will make
>> a dummy settimeofday call first (sys_tz.tz_minuteswest = 0) to make sure
>> the time is not shifted,so at this point I think maybe it is not necessary
>> to set the kernel time once the sys_tz.tz_minuteswest is zero.
>>
>> Signed-off-by: Dong Zhu <bluezhudong@gmail.com>
>> ---
>>   kernel/time.c | 8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/time.c b/kernel/time.c
>> index d226c6a..0b592ce 100644
>> --- a/kernel/time.c
>> +++ b/kernel/time.c
>> @@ -134,9 +134,11 @@ static inline void warp_clock(void)
>>   {
>>   	struct timespec adjust;
>>   
>> -	adjust = current_kernel_time();
>> -	adjust.tv_sec += sys_tz.tz_minuteswest * 60;
>> -	do_settimeofday(&adjust);
>> +	if (sys_tz.tz_minuteswest) {
>> +		adjust = current_kernel_time();
>> +		adjust.tv_sec += sys_tz.tz_minuteswest * 60;
>> +		do_settimeofday(&adjust);
>> +	}
>>   }
>>   
>>   /*
>> -- 
>> 1.7.11.7
>>
> Hi,
>
> Any comments ?
Sorry for the slow response, been a little busy.   Honestly the 
warp_clock() code path is always been a bit odd to me, so I've not 
really been able to get my head around the implications of this change.

Really, I'm not sure if I'll get to this before the new year.
Its on my list, but don't be afraid to ping me early Jan if I haven't 
queued it for 3.9 by then.

thanks
-john

