Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759863Ab2HIXla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 19:41:30 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43317 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760042Ab2HIXl2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 19:41:28 -0400
MIME-Version: 1.0
In-Reply-To: <50242B4B.4090607@linaro.org>
References: <1344497847-7161-1-git-send-email-toddpoynor@google.com>
	<50242B4B.4090607@linaro.org>
Date: Thu, 9 Aug 2012 16:41:26 -0700
Message-ID: <CAMP5XgeDWnUkmSwyXTLgsnyfh4SYQ72C1Ws-Ls85SG_cMQt2dA@mail.gmail.com>
Subject: Re: [PATCH] alarmtimer: implement minimum alarm interval for allowing suspend
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Todd Poynor <toddpoynor@google.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 2:27 PM, John Stultz <john.stultz@linaro.org> wrote:
> On 08/09/2012 12:37 AM, Todd Poynor wrote:
>>
>> alarmtimer suspend return -EBUSY if the next alarm will fire in less
>> than 2 seconds.  This allows one RTC seconds tick to occur subsequent
>> to this check before the alarm wakeup time is set, ensuring the wakeup
>> time is still in the future (assuming the RTC does not tick one more
>> second prior to setting the alarm).
>>
>> If suspend is rejected due to an imminent alarm, hold a wakeup source
>> for 2 seconds to process the alarm prior to reattempting suspend.
>>
>> If setting the alarm incurs an -ETIME for an alarm set in the past,
>> or any other problem setting the alarm, abort suspend and hold a
>> wakelock for 1 second while the alarm is allowed to be serviced or
>> other hopefully transient conditions preventing the alarm clear up.
>>
>> Signed-off-by: Todd Poynor <toddpoynor@google.com>
>> ---
>>   kernel/time/alarmtimer.c |   18 +++++++++++++-----
>>   1 files changed, 13 insertions(+), 5 deletions(-)
>
>
> Thanks for sending this in!
> I've gone ahead and queued it for 3.7 (with the minor tweak Rafael
> suggested). I'll try to do some further testing of the edge case this
> handles as well.
>

You may want to add a wakeupsource to the rtc_timer interface as well.
In the version of the code I have it does not look like
rtc_timer_start will ever return -ETIME. rtc_timer_enqueue swallows
that error code and schedules work instead.

-- 
Arve Hjønnevåg
