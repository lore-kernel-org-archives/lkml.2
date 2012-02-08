Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab2BHPOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 10:14:21 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48684 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab2BHPOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 10:14:20 -0500
Message-ID: <4F32918E.9000905@linaro.org>
Date: Wed, 08 Feb 2012 07:15:26 -0800
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
        Venki Pallipadi <venki@google.com>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] sched: generalize CONFIG_IRQ_TIME_ACCOUNTING for X86
 and ARM
References: <1328705314-20978-1-git-send-email-dmitry.antipov@linaro.org> <20120208131833.GK889@n2100.arm.linux.org.uk>
In-Reply-To: <20120208131833.GK889@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 05:18 AM, Russell King - ARM Linux wrote:

>> diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
>> index 5416c7c..56d2a9d 100644
>> --- a/arch/arm/kernel/sched_clock.c
>> +++ b/arch/arm/kernel/sched_clock.c
>> @@ -162,5 +162,8 @@ void __init sched_clock_postinit(void)
>>   	if (read_sched_clock == jiffy_sched_clock_read)
>>   		setup_sched_clock(jiffy_sched_clock_read, 32, HZ);
>>
>> +	if (!no_sched_irq_time)
>> +		enable_sched_clock_irqtime();
>
> Why are you placing this here?  sched_clock is available from the point
> that it's registered, which should be before the first sched_clock()
> call.

This is just because I'm thinking about:

if (read_sched_clock == jiffy_sched_clock_read)
         setup_sched_clock(jiffy_sched_clock_read, 32, HZ);
else if (!no_sched_irq_time)
	enable_sched_clock_irqtime();

I suppose that "fine granularity task irq time accounting"
makes no sense if sched_clock() granularity is poor.

> This could have been written:
>
> 	depends on X86 || (ARM&&  HAVE_SCHED_CLOCK)
>
> However, ARM will always have HAVE_SCHED_CLOCK after the next merge window,
> so this can become a much simpler:
>
> 	depends on X86 || ARM

OK.

Dmitry

