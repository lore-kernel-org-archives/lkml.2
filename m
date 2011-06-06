Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab1FFRDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:03:51 -0400
Received: from mx2.compro.net ([12.186.155.4]:33724 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab1FFRDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:03:50 -0400
X-Greylist: delayed 857 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jun 2011 13:03:49 EDT
X-IronPort-AV: E=Sophos;i="4.65,327,1304308800"; 
   d="scan'208";a="6671724"
Message-ID: <4DED051A.6020702@compro.net>
Date: Mon, 06 Jun 2011 12:49:30 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Monica Puig-Pey <puigpeym@unican.es>
CC: Rolando Martins <rolando.martins@gmail.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Changing Kernel thread priorities
References: <4DEA1BA9.7020303@unican.es><4DEA1F22.6000603@unican.es><4DEA255		B.2050503@unican.es><4DECBE44.2070803@unican.es> 	<BANLkTi=xSJOgY735PE44YtkQmrdhgetGdQ@mail.gmail.com> <4DECC0DF.8070209@unican.es>
In-Reply-To: <4DECC0DF.8070209@unican.es>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2011 07:58 AM, Monica Puig-Pey wrote:
> El 06/06/11 13:54, Rolando Martins escribió:
>> Hi,
>> I use the following:
>>
>> PIDs=$(ps -eLo pid,cls,rtprio,pri,nice,cmd | grep -i "irq" | awk '{
>> print $1; }' | xargs echo)
>> for i in $PIDs
>> do
>> ret=$(chrt -f -p 99 $i)
>> done
>>
>> This will change the kernel thread associated with an irq handler to
>> RT FIFO prio 99.
>> Just change the script to your specific interrupt.
>>
>> Hope it helps,
>> Rolando
>>
>> On Mon, Jun 6, 2011 at 12:47 PM, Monica Puig-Pey<puigpeym@unican.es>
>> wrote:
>>> I am writing a driver which has one kernel thread associated with it.
>>> I want to change the priority of this thread, so that I can specify the
>>> order in which it is scheduled following an interrupt.
>>> I'm using:
>>>
>>> sched_setscheduler(struct task_struct *, int, struct sched_param *);
>>>
>>> but it doesn't work. I tried to change the priority from the
>>> init_module,
>>> and also from the Kernel Thread, but there is no way.
>>>
>>> Kernel version is 2.6.31-11-rt
>>>
>>> What do I call to change a kernel thread priority?
>>>
>>> Thanks you very much
>>>
>>> Mónica
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-rt-users" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>
>
> I need to change the priority from inside the driver, when creating the
> kernel thread.
> Your script is useful but it is done in user context,
> Any other help please?

What I do is record the PID of the thread in the driver, then create an 
IOCTL for your driver that user land can call that either returns the 
PID so you can do it in user land, or cause the IOCTL code to do it in 
the driver.

The same can be done with the affinity of the IRQ if you record the IRQ 
number.

Mark
