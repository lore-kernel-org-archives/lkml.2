Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab2HIVH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 17:07:57 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:58062 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab2HIVHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:07:55 -0400
Message-ID: <50242670.4020302@linaro.org>
Date: Thu, 09 Aug 2012 14:06:56 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Todd Poynor <toddpoynor@google.com>
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, arve@android.com
Subject: Re: [PATCH] alarmtimer: implement minimum alarm interval for allowing
 suspend
References: <1344497847-7161-1-git-send-email-toddpoynor@google.com>
In-Reply-To: <1344497847-7161-1-git-send-email-toddpoynor@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080921-2356-0000-0000-00000123ACA8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 12:37 AM, Todd Poynor wrote:
> @@ -288,9 +293,11 @@ static int alarmtimer_suspend(struct device *dev)
>   	now = rtc_tm_to_ktime(tm);
>   	now = ktime_add(now, min);
>
> -	rtc_timer_start(rtc, &rtctimer, now, ktime_set(0, 0));
> -
> -	return 0;
> +	/* Set alarm, if in the past reject suspend briefly to handle */
> +	ret = rtc_timer_start(rtc, &rtctimer, now, ktime_set(0, 0));
> +	if (ret < 0)
> +		__pm_wakeup_event(ws, 1 * MSEC_PER_SEC);
> +	return ret;

What if something other then -ETIME  is returned from rtc_timer_start?

thanks
-john


