Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab2BMQmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 11:42:11 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:45412 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab2BMQmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 11:42:09 -0500
Message-ID: <4F393D4A.7080704@linux.vnet.ibm.com>
Date: Mon, 13 Feb 2012 22:11:46 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 2/3] PM / Sleep: Make enter_state() in kernel/power/suspend.c
 static
References: <201202120003.20879.rjw@sisk.pl> <201202131612.26973.rjw@sisk.pl> <4F392D99.7030303@linux.vnet.ibm.com> <201202131653.02013.rjw@sisk.pl>
In-Reply-To: <201202131653.02013.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12021306-5140-0000-0000-000000BD421D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 09:23 PM, Rafael J. Wysocki wrote:

> On Monday, February 13, 2012, Srivatsa S. Bhat wrote:
>> On 02/13/2012 08:42 PM, Rafael J. Wysocki wrote:
>>
>>> On Monday, February 13, 2012, Srivatsa S. Bhat wrote:
>>>> On 02/13/2012 02:54 AM, Rafael J. Wysocki wrote:
>>>>
>>>>> On Sunday, February 12, 2012, Srivatsa S. Bhat wrote:
>>>>>> On 02/12/2012 04:34 AM, Rafael J. Wysocki wrote:
>>>>>>
>>>>>>> From: Rafael J. Wysocki <rjw@sisk.pl>
>>>>>>>
>>>>>>> The enter_state() function in kernel/power/suspend.c should be
>>>>>>> static and state_store() in kernel/power/suspend.c should call
>>>>>>> pm_suspend() instead of it, so make that happen (which also reduces
>>>>>>> code duplication related to suspend statistics).
>>>>>>>
>>>>>>> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>>>>>>> ---
>>>>>>>  kernel/power/main.c    |    6 +-----
>>>>>>>  kernel/power/power.h   |    2 --
>>>>>>>  kernel/power/suspend.c |    2 +-
>>>>>>>  3 files changed, 2 insertions(+), 8 deletions(-)
>>>>>>>
>>>>>>> Index: linux/kernel/power/main.c
>>>>>>> ===================================================================
>>>>>>> --- linux.orig/kernel/power/main.c
>>>>>>> +++ linux/kernel/power/main.c
>>>>>>> @@ -292,11 +292,7 @@ static ssize_t state_store(struct kobjec
>>>>>>>  #ifdef CONFIG_SUSPEND
>>>>>>>  	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++) {
>>>>>>>  		if (*s && len == strlen(*s) && !strncmp(buf, *s, len))
>>>>>>> -			break;
>>>>>>> -	}
>>>>>>> -	if (state < PM_SUSPEND_MAX && *s) {
>>>>>>> -		error = enter_state(state);
>>>>>>> -		suspend_stats_update(error);
>>>>>>> +			error = pm_suspend(state);
>>>>>>
>>>>>>
>>>>>> This code will not stop after calling pm_suspend(). It will try more iterations
>>>>>> in the for loop right?
>>>>>
>>>>> Well, only one string in pm_states[] can be matched at a time, but I agree that
>>>>> it doesn't make sense to continue the loop after we've found a match.
>>>>>
>>>>>> We can probably keep the 'for' loop as it is, and just replace the 'if' block
>>>>>> following the 'for' loop by: error = pm_suspend(state);
>>>>>
>>>>> I think the patch below is correct.
>>>>>
>>>>> Thanks,
>>>>> Rafael
>>>>>
>>>>> ---
>>>>> From: Rafael J. Wysocki <rjw@sisk.pl>
>>>>> Subject: PM / Sleep: Make enter_state() in kernel/power/suspend.c static
>>>>>
>>>>> The enter_state() function in kernel/power/suspend.c should be
>>>>> static and state_store() in kernel/power/suspend.c should call
>>>>> pm_suspend() instead of it, so make that happen (which also reduces
>>>>> code duplication related to suspend statistics).
>>>>>
>>>>> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>>>>> ---
>>>>
>>>>
>>>> Yeah, this version of the patch will work fine.
>>>>
>>>> Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>>>
>>> Thanks!
>>>
>>> I wonder if that should be Reviewed-by, tough?  You evidently have reviewed
>>> the patch (actually, all three of them).
>>>
>>
>>
>> Anything is fine :-) It is not very clear to me when to use Reviewed-by and
>> when to use Acked-by.. so I randomly chose one of them.. :-)
>> But please enlighten me as to when to use which one, so that in the future, I
>> can use the right one :-)
> 
> "Acked-by" means, roughly, "I have no objection" or "looks good to me",
> depending on who's saying that, but it doesn't imply that you've had more than
> a cursory look at the patch in question.  "Reviewied-by", in contrast, means
> something like "I have reviewed the patch in detail and haven't found anything
> wrong in it" (which obviously means that you have no objection too, because
> otherwise you'd have found _something_ wrong in the patch).
> 
> So, "Acked-by" from anyone other than the relevant maintainer is just an
> "I'm for" declaration, while "Reviewied-by" from _anyone_ carries some actual
> weight. 
> 

Wow! Nice :-) Thanks for the great explanation!
I'll keep this in mind from the next time onwards :-)

Regards,
Srivatsa S. Bhat

