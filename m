Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab1FMWUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 18:20:06 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39490 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab1FMWUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 18:20:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QwYU53TU9+VEJSVZI5TIZLv08jJ1xezSyXaJHHAbinU0jB/GHa3Wk8XiZL5AysJPTl
         fhZF0ioKDXZqD4dGqK8+LbuFzYK7U605cRS05VA6SqKBo3cd3Y0uFZXmFWW8jUuAaMDl
         pwnyh+dV4w8ieEz6YQBXfuDUQFqeGld8AQels=
Message-ID: <4DF68D00.8000200@gmail.com>
Date: Mon, 13 Jun 2011 15:19:44 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH]drivers:base:power:trace.c Add "UTC" Coordinated Universal
 Time to the printk.
References: <1307599301-2524-1-git-send-email-justinmattock@gmail.com> <201106122227.32992.rjw@sisk.pl> <4DF53DCC.1060604@gmail.com> <201106132347.08007.rjw@sisk.pl>
In-Reply-To: <201106132347.08007.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2011 02:47 PM, Rafael J. Wysocki wrote:
> On Monday, June 13, 2011, Justin P. Mattock wrote:
>> On 06/12/2011 01:27 PM, Rafael J. Wysocki wrote:
>>> On Sunday, June 12, 2011, Justin P. Mattock wrote:
>>>> On 06/12/2011 11:35 AM, Rafael J. Wysocki wrote:
>>>>> On Sunday, June 12, 2011, Justin P. Mattock wrote:
>>>>>> On 06/12/2011 05:12 AM, Rafael J. Wysocki wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> On Thursday, June 09, 2011, Justin P. Mattock wrote:
>>>>>>>> From: "Justin P. Mattock"<justinmattock@gmail.com>
>>>>>>>>
>>>>>>>> sounds stupid, but taking a glance at the time, and seeing the wrong time, or what seemed
>>>>>>>> wrong in dmesg, caused me to go into total check the time clock panic mode.. So the patch below adds:
>>>>>>>> "UTC" Coordinated Universal Time abreviation to the printk so people like me dont flip out over the time!
>>>>>>>>
>>>>>>>> before:
>>>>>>>> [    0.114915] Time:  1:47:03  Date: 06/09/11
>>>>>>>>
>>>>>>>> after:
>>>>>>>> [    0.114728] Time:  5:46:02 UTC Date: 06/09/11
>>>>>>>>
>>>>>>>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>>>>>>
>>>>>>> I suspect the goal is to mark messages printed by the PM trace code so that
>>>>>>> they can be easily distinguished from messages from other sources to avoid
>>>>>>> confusion.  Why do you think it's a good idea to use the "UTC" string for
>>>>>>> this purpose?  The time printed in those messages need not be UTC.
>>>>>>>
>>>>>>> It would be better to simply print "RTC time: ..., date: ..." IMO.
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Rafael
>>>>>>>
>>>>>>
>>>>>> well.. if thats better, then thats better.. over here(people that dont
>>>>>> know what RTC time is) would not get so confused with a simple UTC or
>>>>>> PDT or whatever the time zone is but if RTC is bettr, then its better.
>>>>>
>>>>> My point is we don't know this time is always UTC, so we rather shouldn't
>>>>> label it as UTC unconditionally, should we?
>>>>>
>>>>> Rafael
>>>>>
>>>>
>>>> sounds good to me!!
>>>
>>> I'm not sure what you mean?
>>>
>>
>> with what you are saying "RTC" if anything.. rather than "UTC"
>
> So, it looks like you'd like the appended patch to be appiled?
>
> Rafael


whatever works best with you guys... I just tripped out on that, and 
created what I had sent out..
>
> ---
> From: Rafael J. Wysocki<rjw@sisk.pl>
> Subject: PM: Add "RTC" to PM trace time stamps to avoid confusion
>
> Some users are apparently confused by dmesg output from
> read_magic_time(), which looks like "real" time and date.
> Add the "RTC" string to time stamps printed by read_magic_time() to
> avoid that confusion.
>
> Reported-by: Justin P. Mattock<justinmattock@gmail.com>
> Signed-off-by: Rafael J. Wysocki<rjw@sisk.pl>
> ---
>   drivers/base/power/trace.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-2.6/drivers/base/power/trace.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/trace.c
> +++ linux-2.6/drivers/base/power/trace.c
> @@ -112,7 +112,7 @@ static unsigned int read_magic_time(void
>   	unsigned int val;
>
>   	get_rtc_time(&time);
> -	pr_info("Time: %2d:%02d:%02d  Date: %02d/%02d/%02d\n",
> +	pr_info("RTC time: %2d:%02d:%02d, date: %02d/%02d/%02d\n",
>   		time.tm_hour, time.tm_min, time.tm_sec,
>   		time.tm_mon + 1, time.tm_mday, time.tm_year % 100);
>   	val = time.tm_year;				/* 100 years */
>


Justin P. Mattock
