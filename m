Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab2HIVJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 17:09:45 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33509 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507Ab2HIVJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:09:43 -0400
Message-ID: <502426FE.5030301@us.ibm.com>
Date: Thu, 09 Aug 2012 14:09:18 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Todd Poynor <toddpoynor@google.com>
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, arve@android.com
Subject: Re: [PATCH] alarmtimer: implement minimum alarm interval for allowing
 suspend
References: <1344497847-7161-1-git-send-email-toddpoynor@google.com> <50242670.4020302@linaro.org>
In-Reply-To: <50242670.4020302@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080921-9360-0000-0000-00000946C322
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 02:06 PM, John Stultz wrote:
> On 08/09/2012 12:37 AM, Todd Poynor wrote:
>> @@ -288,9 +293,11 @@ static int alarmtimer_suspend(struct device *dev)
>>       now = rtc_tm_to_ktime(tm);
>>       now = ktime_add(now, min);
>>
>> -    rtc_timer_start(rtc, &rtctimer, now, ktime_set(0, 0));
>> -
>> -    return 0;
>> +    /* Set alarm, if in the past reject suspend briefly to handle */
>> +    ret = rtc_timer_start(rtc, &rtctimer, now, ktime_set(0, 0));
>> +    if (ret < 0)
>> +        __pm_wakeup_event(ws, 1 * MSEC_PER_SEC);
>> +    return ret;
>
> What if something other then -ETIME  is returned from rtc_timer_start?

Bah, sorry, too fast on the trigger there (enlightenment somehow only 
comes with clicking the send button).
I see the wakeup_source will expire after a second and the next suspend 
can try again.

thanks
-john

