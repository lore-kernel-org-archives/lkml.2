Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab1FFL6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:58:32 -0400
Received: from ccserver2.unican.es ([130.206.5.101]:48567 "EHLO
	ccserver2.unican.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061Ab1FFL6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:58:31 -0400
Message-ID: <4DECC0DF.8070209@unican.es>
Date: Mon, 6 Jun 2011 13:58:23 +0200
From: Monica Puig-Pey <puigpeym@unican.es>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) 
	Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Rolando Martins <rolando.martins@gmail.com>
CC: <linux-rt-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Changing Kernel thread priorities
References: <4DEA1BA9.7020303@unican.es><4DEA1F22.6000603@unican.es><4DEA255
		B.2050503@unican.es><4DECBE44.2070803@unican.es> 
	<BANLkTi=xSJOgY735PE44YtkQmrdhgetGdQ@mail.gmail.com>
In-Reply-To: <BANLkTi=xSJOgY735PE44YtkQmrdhgetGdQ@mail.gmail.com>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [193.144.198.131]
X-imss-version: 2.054
X-imss-result: Passed
X-imss-scanInfo: M:P L:E SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:6.5.1024(18182.006)
X-imss-scores: Clean:99.90000 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:1 C:1 M:2 S:2 R:2 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 06/06/11 13:54, Rolando Martins escribió:
> Hi,
> I use the following:
>
> PIDs=$(ps -eLo pid,cls,rtprio,pri,nice,cmd | grep -i "irq" | awk '{
> print $1; }' | xargs echo)
> for i in $PIDs
> do
>      ret=$(chrt -f -p 99 $i)
> done
>
> This will change the kernel thread associated with an irq handler to
> RT FIFO prio 99.
> Just change the script to your specific interrupt.
>
> Hope it helps,
> Rolando
>
> On Mon, Jun 6, 2011 at 12:47 PM, Monica Puig-Pey<puigpeym@unican.es>  wrote:
>> I am writing a driver which has one kernel thread associated with it.
>> I want to change the priority of this thread, so that I can specify the
>> order in which it is scheduled following an interrupt.
>> I'm using:
>>
>>   sched_setscheduler(struct task_struct *, int, struct sched_param *);
>>
>> but it doesn't work. I tried to change the priority from the init_module,
>> and also from the Kernel Thread, but there is no way.
>>
>> Kernel version is 2.6.31-11-rt
>>
>> What do I call to change a kernel thread priority?
>>
>> Thanks you very much
>>
>> Mónica
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

I need to change the priority from inside the driver, when creating the 
kernel thread.
Your script is useful but it is done in user context,
Any other help please?

Mónica


