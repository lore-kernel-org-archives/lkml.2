Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab2E3GXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 02:23:33 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39206 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631Ab2E3GXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 02:23:32 -0400
Message-ID: <4FC5BCDF.20807@us.ibm.com>
Date: Tue, 29 May 2012 23:23:27 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V2 3/6] time: keep track of the pending utc/tai threshold
References: <20120523082916.GA15627@localhost.localdomain> <4FBD1545.4070408@linaro.org> <20120523191747.GA2348@netboy.at.omicron.at> <4FBD4613.7040003@linaro.org> <20120524064340.GA2180@netboy.at.omicron.at> <20120524065726.GB2180@netboy.at.omicron.at> <4FC57BF9.5010608@linaro.org> <4FC57CAA.3030809@us.ibm.com> <20120530051138.GA3356@netboy.at.omicron.at> <4FC5B682.4010509@us.ibm.com> <20120530061931.GA3072@netboy.at.omicron.at>
In-Reply-To: <20120530061931.GA3072@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12053006-1780-0000-0000-000005FE9527
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000277; HX=3.00000188; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00143600; UDB=6.00033034; UTC=2012-05-30
 06:23:31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 11:19 PM, Richard Cochran wrote:
> On Tue, May 29, 2012 at 10:56:18PM -0700, John Stultz wrote:
>> On 05/29/2012 10:11 PM, Richard Cochran wrote:
>>> On Tue, May 29, 2012 at 06:49:30PM -0700, John Stultz wrote:
>>>> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
>>>> index 6e46cac..81c76a9 100644
>>>> --- a/kernel/time/timekeeping.c
>>>> +++ b/kernel/time/timekeeping.c
>>>> @@ -962,6 +962,7 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
>>>>   		timekeeper.xtime.tv_sec++;
>>>>   		leap = second_overflow(timekeeper.xtime.tv_sec);
>>>>   		timekeeper.xtime.tv_sec += leap;
>>>> +		timekeeper.wall_to_monotonic.tv_sec -= leap;
>>> Don't you need this in update_wall_time() too?
>> Yep. Good point.
> Okay, so I can confirm that this fixes the CLOCK_MONOTONIC timer issue
> during a leap second.
Thanks! Is it ok if I add your Tested-by:  to the patch?

thanks
-john

