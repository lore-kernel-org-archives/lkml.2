Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760484Ab2FDNI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:08:59 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:37376 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab2FDNI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:08:57 -0400
Message-ID: <4FCCB31B.6060302@linux.vnet.ibm.com>
Date: Mon, 04 Jun 2012 18:37:39 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Sam Ravnborg <sam@ravnborg.org>, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        yong.zhang0@gmail.com, akpm@linux-foundation.org,
        vatsa@linux.vnet.ibm.com, rjw@sisk.pl, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, nikunj@linux.vnet.ibm.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: [PATCH 01/27] smpboot: Provide a generic method to boot secondary
 processors
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091008.31979.93586.stgit@srivatsabhat.in.ibm.com> <20120601165113.GA18870@merkur.ravnborg.org> <4FC9424E.9060009@linux.vnet.ibm.com> <alpine.LFD.2.02.1206041228330.3086@ionos>
In-Reply-To: <alpine.LFD.2.02.1206041228330.3086@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12060402-1618-0000-0000-000001C18BE5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 04:02 PM, Thomas Gleixner wrote:

> On Sat, 2 Jun 2012, Srivatsa S. Bhat wrote:
> 
>> On 06/01/2012 10:21 PM, Sam Ravnborg wrote:
>>
>>>> +/* Implement the following functions in your architecture, as appropriate. */
>>>> +
>>>> +/**
>>>> + * __cpu_pre_starting()
>>>> + *
>>>> + * Implement whatever you need to do before the CPU_STARTING notifiers are
>>>> + * invoked. Note that the CPU_STARTING callbacks run *on* the cpu that is
>>>> + * coming up. So that cpu better be prepared! IOW, implement all the early
>>>> + * boot/init code for the cpu here. And do NOT enable interrupts.
>>>> + */
>>>> +#ifndef __cpu_pre_starting
>>>> +void __weak __cpu_pre_starting(void *arg) {}
>>>> +#endif
> 
> This wants to be a prototype w/o the __weak prefix and the #ifndef
> magic and the weak default implementation should be in kernel/smpboot.c
> 


I can add the prototype w/o the __weak prefix and the #ifndef magic in
include/linux/smpboot.h (which I will, and include it in v2).

However, I can't get rid of the #ifndef magic in kernel/smpboot.c because
it will cause build failures on x86.

I addressed this same issue in another email:
https://lkml.org/lkml/2012/6/3/33

>>> __What __is __the __purpose __of __all __these __underscaores __used
>>> __as __function __prefix? __It __does __not __help __readability.
>>
>>>
>>
>>
>> We had used "__" as the function prefix to emphasize that these functions are
>> implemented/overriden in the depths of architecture-specific code.
>>
>> But now that you mention it, I see that we don't really have something like an
>> arch-independent variant without the "__" prefix. So adding the "__" prefix
>> might not be really necessary, since there is nothing to distinguish name-wise.
>>
>> However, I do want to emphasize that this isn't generic code. So how about
>> an "arch_" prefix instead? Something like:
>> arch_cpu_pre_starting(), arch_cpu_pre_online() and arch_cpu_post_online()?
> 
> Yes, please.


Sure, queued up for v2. (Atm, figuring out how to deal with xen (patch 5). Once
that gets done, will post a v2.)

> 
> Otherwise, thanks for that work!


We are glad that it helps :-)

> From the first glance, it's not
> colliding much with the changes I have in the pipeline, but I will
> have a closer look.
> 


Great! Thanks a lot for your time, Thomas!
 
Regards,
Srivatsa S. Bhat

