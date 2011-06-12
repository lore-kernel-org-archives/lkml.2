Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1FLPxD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 11:53:03 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62371 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab1FLPxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 11:53:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jGo5hxsfMko4Ipv40C3LahqwS9umTbIcOufEEB9sVWriXlTWtcjIlneFppRSGj0QB3
         GQdHqoRs3u0IbxFjHLrFmxEgGnKDeiFLKnS7VbO88k1Ugb0gKrEND7nRwigOtBI1HSgt
         I6XneBp2psterMi/+wOPUBQHg/qr/r7wozNiQ=
Message-ID: <4DF4E0CB.4090900@gmail.com>
Date: Sun, 12 Jun 2011 08:52:43 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH]drivers:base:power:trace.c Add "UTC" Coordinated Universal
 Time to the printk.
References: <1307599301-2524-1-git-send-email-justinmattock@gmail.com> <201106121412.09903.rjw@sisk.pl>
In-Reply-To: <201106121412.09903.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2011 05:12 AM, Rafael J. Wysocki wrote:
> Hi,
>
> On Thursday, June 09, 2011, Justin P. Mattock wrote:
>> From: "Justin P. Mattock"<justinmattock@gmail.com>
>>
>> sounds stupid, but taking a glance at the time, and seeing the wrong time, or what seemed
>> wrong in dmesg, caused me to go into total check the time clock panic mode.. So the patch below adds:
>> "UTC" Coordinated Universal Time abreviation to the printk so people like me dont flip out over the time!
>>
>> before:
>> [    0.114915] Time:  1:47:03  Date: 06/09/11
>>
>> after:
>> [    0.114728] Time:  5:46:02 UTC Date: 06/09/11
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>
> I suspect the goal is to mark messages printed by the PM trace code so that
> they can be easily distinguished from messages from other sources to avoid
> confusion.  Why do you think it's a good idea to use the "UTC" string for
> this purpose?  The time printed in those messages need not be UTC.
>
> It would be better to simply print "RTC time: ..., date: ..." IMO.
>
> Thanks,
> Rafael
>

well.. if thats better, then thats better.. over here(people that dont 
know what RTC time is) would not get so confused with a simple UTC or 
PDT or whatever the time zone is but if RTC is bettr, then its better.

>
>> ---
>>   drivers/base/power/trace.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/base/power/trace.c b/drivers/base/power/trace.c
>> index c80e138..009f459 100644
>> --- a/drivers/base/power/trace.c
>> +++ b/drivers/base/power/trace.c
>> @@ -112,7 +112,7 @@ static unsigned int read_magic_time(void)
>>   	unsigned int val;
>>
>>   	get_rtc_time(&time);
>> -	pr_info("Time: %2d:%02d:%02d  Date: %02d/%02d/%02d\n",
>> +	pr_info("Time: %2d:%02d:%02d UTC Date: %02d/%02d/%02d\n",
>>   		time.tm_hour, time.tm_min, time.tm_sec,
>>   		time.tm_mon + 1, time.tm_mday, time.tm_year % 100);
>>   	val = time.tm_year;				/* 100 years */
>>
>
>

