Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab2HVCIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 22:08:00 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:56223 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab2HVCH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 22:07:56 -0400
Message-ID: <50343EF1.5060008@linux.vnet.ibm.com>
Date: Wed, 22 Aug 2012 10:07:45 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: scheduling while atomic, under native_smp_prepare_cpus()
References: <20120817134944.GA539@localhost> <50320163.5080703@linux.vnet.ibm.com> <20120820092744.GA3668@localhost> <5032067E.20505@linux.vnet.ibm.com> <20120821165006.GA24559@localhost>
In-Reply-To: <20120821165006.GA24559@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12082202-5140-0000-0000-000001F1F620
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 12:50 AM, Fengguang Wu wrote:
> On Mon, Aug 20, 2012 at 05:42:22PM +0800, Michael Wang wrote:
>> On 08/20/2012 05:27 PM, Fengguang Wu wrote:
>>> Hi Michael,
>>>
>>> On Mon, Aug 20, 2012 at 05:20:35PM +0800, Michael Wang wrote:
>>>> On 08/17/2012 09:49 PM, Fengguang Wu wrote:
>>>>
>>>> Hi, FengGuang
>>>>
>>>> native_smp_prepare_cpus has already disabled the preempt before
>>>> reach __irq_alloc_descs(), and sleep in mutex_lock() cause the bug.
>>>>
>>>> May be the follow patch could help to solve the issue(actually I
>>>> think the true problem should be in _cond_resched...).
>>>
>>> Is this a debug patch? Since what it does is to conditionally disable
>>> the warning.
>>
>> No, I use this as a solution, it should work as the bug reported in boot
>> process before init_post called.
>>
>> We have some reference from __might_sleep which also avoid the check if
>> system has not fully booted, so I think this way is acceptable, but I'm
>> not the one to make decision...
> 
> Fair enough.
> 
>>>
>>>> I can't do test by my self since I can't reproduce the issue on my
>>>> machine, the kernel_init thread never got a need sched flag set at
>>>> that moment in my case...
>>>
>>> I'll try it and report back :)
>>
>> Appreciate :)
> 
> It works! :)
> 
> Tested-by: Fengguang Wu <wfg@linux.intel.com>

Thanks for your testing, I will send out the patch later with your
Tested-by :)

Regards,
Michael Wang

> 
> Thanks,
> Fengguang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

