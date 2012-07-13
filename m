Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab2GMSg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 14:36:56 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58835 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969Ab2GMSgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 14:36:54 -0400
Message-ID: <50006ABC.5030004@us.ibm.com>
Date: Fri, 13 Jul 2012 11:36:44 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH 1/8] ntp: Fix STA_INS/DEL clearing bug
References: <1342156917-25092-1-git-send-email-john.stultz@linaro.org> <1342156917-25092-2-git-send-email-john.stultz@linaro.org> <20120713055843.GB18065@gmail.com>
In-Reply-To: <20120713055843.GB18065@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071318-5806-0000-0000-000017484D7A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2012 10:58 PM, Ingo Molnar wrote:
>
> * John Stultz <john.stultz@linaro.org> wrote:
>
>> From: John Stultz <johnstul@us.ibm.com>
>>
>> In commit 6b43ae8a619d17c4935c3320d2ef9e92bdeed05d, I
>> introduced a bug that kept the STA_INS or STA_DEL bit
>> from being cleared from time_status via adjtimex()
>> without forcing STA_PLL first.
>>
>> Usually once the STA_INS is set, it isn't cleared
>> until the leap second is applied, so its unlikely this
>> affected anyone. However during testing I noticed it
>> took some effort to cancel a leap second once STA_INS
>> was set.
>>
>> This issue affects 3.4 and up.
>>
>> Since this isn't urgent (issue is only observed in testing,
>> the behavior doesn't affect ntpd, nor is a leapsecond due
>> for at least ~6 months), and we're late in the 3.5-rc
>> cycle, I'm holding this off for 3.6 merge window,
>> where I'll then backport to 3.5-stable and 3.4-stable.
>
>> CC: stable@vger.kernel.org
>
> We generally don't do such a workflow. Either it's valid for
> tip:timers/urgent and it can have a -stable tag, or it should
> not be backported, and not have a -stable tag.
>
> The rule is: if it's important enough for -stable then it's
> doubly important for the current -rc kernel!

Ok. My concern here was that if the time/hrtimer leapsecond changes were 
possibly too large for merging this late in 3.5-rc, I didn't want to add 
anything more to that queue.

So if you're comfortable pushing this one upstream for 3.5-rc, I'd be 
happy to have it merged sooner.

thanks
-john

