Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab2HIV3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 17:29:00 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34303 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab2HIV26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:28:58 -0400
Message-ID: <50242B4B.4090607@linaro.org>
Date: Thu, 09 Aug 2012 14:27:39 -0700
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
x-cbid: 12080921-6148-0000-0000-0000087B38C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 12:37 AM, Todd Poynor wrote:
> alarmtimer suspend return -EBUSY if the next alarm will fire in less
> than 2 seconds.  This allows one RTC seconds tick to occur subsequent
> to this check before the alarm wakeup time is set, ensuring the wakeup
> time is still in the future (assuming the RTC does not tick one more
> second prior to setting the alarm).
>
> If suspend is rejected due to an imminent alarm, hold a wakeup source
> for 2 seconds to process the alarm prior to reattempting suspend.
>
> If setting the alarm incurs an -ETIME for an alarm set in the past,
> or any other problem setting the alarm, abort suspend and hold a
> wakelock for 1 second while the alarm is allowed to be serviced or
> other hopefully transient conditions preventing the alarm clear up.
>
> Signed-off-by: Todd Poynor <toddpoynor@google.com>
> ---
>   kernel/time/alarmtimer.c |   18 +++++++++++++-----
>   1 files changed, 13 insertions(+), 5 deletions(-)

Thanks for sending this in!
I've gone ahead and queued it for 3.7 (with the minor tweak Rafael 
suggested). I'll try to do some further testing of the edge case this 
handles as well.

thanks again,
-john

