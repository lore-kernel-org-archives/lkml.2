Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab0EQOzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 10:55:33 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:14763 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab0EQOzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 10:55:32 -0400
Message-ID: <4BF158DF.3090509@gmail.com>
Date: Mon, 17 May 2010 18:55:27 +0400
From: Andrew Vagin <avagin@gmail.com>
Reply-To: avagin@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Andrey Vagin <avagin@openvz.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 2/3] posix_timer: fix error path in timer_create
References: <1274103704-11230-1-git-send-email-avagin@openvz.org>	<1274103704-11230-2-git-send-email-avagin@openvz.org> <20100517163138.5a9b93af@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <20100517163138.5a9b93af@dhcp-lab-109.englab.brq.redhat.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2010 06:31 PM, Stanislaw Gruszka wrote:
> On Mon, 17 May 2010 17:41:43 +0400
> Andrey Vagin<avagin@openvz.org>  wrote:
>
>    
>> @@ -593,6 +585,14 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
>>   	new_timer->sigq->info.si_tid   = new_timer->it_id;
>>   	new_timer->sigq->info.si_code  = SI_TIMER;
>>
>> +	it_id_set = IT_ID_SET;
>> +	new_timer->it_id = (timer_t) new_timer_id;
>>      
> This part should not be moved, this make possible leak of idr entry .
>    
You are right. Pls, skip this patches too.
>    
>> +	new_timer->it_clock = which_clock;
>> +	new_timer->it_overrun = -1;
>>      
> I'm not so convenient of moving this as well.
>
>    
>> +	error = CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
>> +	if (error)
>> +		goto out;
>> +
>>   	spin_lock_irq(&current->sighand->siglock);
>>   	new_timer->it_signal = current->signal;
>>   	list_add(&new_timer->list,&current->signal->posix_timers);
>>      
> Thanks
> Stanislaw
>    

