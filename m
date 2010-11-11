Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab0KKLX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:23:58 -0500
Received: from mail.windriver.com ([147.11.1.11]:40539 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab0KKLX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:23:57 -0500
Message-ID: <4CDBD23D.5070107@windriver.com>
Date: Thu, 11 Nov 2010 19:23:41 +0800
From: DDD <dongdong.deng@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: dzickus@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V3 PATCH] x86: avoid calling arch_trigger_all_cpu_backtrace()
 at the same time on SMP
References: <1289473307-7965-1-git-send-email-dongdong.deng@windriver.com> <20101111111702.GA12644@elte.hu>
In-Reply-To: <20101111111702.GA12644@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Nov 2010 11:23:07.0464 (UTC) FILETIME=[D0922C80:01CB8192]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Hm, another thing i noticed is that there's two of these:
> 
>>  #ifdef ARCH_HAS_NMI_WATCHDOG
>> +/* "in progress" flag of arch_trigger_all_cpu_backtrace */
>> +static unsigned long backtrace_flag;
>> +
>>  void arch_trigger_all_cpu_backtrace(void)
>>  {
>>  	int i;
>> +	unsigned long flags;
>> +
>> +	/*
>> +	 * Have to disable irq here, as the
>> +	 * arch_trigger_all_cpu_backtrace() could be
>> +	 * triggered by "spin_lock()" with irqs on.
>> +	 */
>> +	local_irq_save(flags);
> 
>> +/* "in progress" flag of arch_trigger_all_cpu_backtrace */
>> +static unsigned long backtrace_flag;
>> +
>>  void arch_trigger_all_cpu_backtrace(void)
>>  {
>>  	int i;
>> +	unsigned long flags;
>> +
>> +	/*
>> +	 * Have to disable irq here, as the
>> +	 * arch_trigger_all_cpu_backtrace() could be
>> +	 * triggered by "spin_lock()" with irqs on.
>> +	 */
>> +	local_irq_save(flags);
>> +
>> +	if (test_and_set_bit(0, &backtrace_flag))
> 
> A fair amount of code is being duplicated in two places - which is not nice. Lets 
> try to create a shared facility instead?

Yep, It is a good idea, I will try to do that. :-)

Dongdong

> 
> Thanks,
> 
> 	Ingo
> 

