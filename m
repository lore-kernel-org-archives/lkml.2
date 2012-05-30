Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab2E3F45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 01:56:57 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50531 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458Ab2E3F44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 01:56:56 -0400
Message-ID: <4FC5B682.4010509@us.ibm.com>
Date: Tue, 29 May 2012 22:56:18 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V2 3/6] time: keep track of the pending utc/tai threshold
References: <20120522173953.GA4177@netboy.at.omicron.at> <4FBBD591.1000103@linaro.org> <20120523082916.GA15627@localhost.localdomain> <4FBD1545.4070408@linaro.org> <20120523191747.GA2348@netboy.at.omicron.at> <4FBD4613.7040003@linaro.org> <20120524064340.GA2180@netboy.at.omicron.at> <20120524065726.GB2180@netboy.at.omicron.at> <4FC57BF9.5010608@linaro.org> <4FC57CAA.3030809@us.ibm.com> <20120530051138.GA3356@netboy.at.omicron.at>
In-Reply-To: <20120530051138.GA3356@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12053005-3270-0000-0000-000006BF5071
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 10:11 PM, Richard Cochran wrote:
> On Tue, May 29, 2012 at 06:49:30PM -0700, John Stultz wrote:
>> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
>> index 6e46cac..81c76a9 100644
>> --- a/kernel/time/timekeeping.c
>> +++ b/kernel/time/timekeeping.c
>> @@ -962,6 +962,7 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
>>   		timekeeper.xtime.tv_sec++;
>>   		leap = second_overflow(timekeeper.xtime.tv_sec);
>>   		timekeeper.xtime.tv_sec += leap;
>> +		timekeeper.wall_to_monotonic.tv_sec -= leap;
> Don't you need this in update_wall_time() too?
Yep. Good point.

> BTW I suggest refactoring this code (two almost identical if{} bodies)
> into a shared helper function.
>
Sounds good, although since the logic is ever so slightly different I 
might split up the pure fix and do the refactoring later so the fix is 
easier to apply to -stable branches.

thanks
-john


