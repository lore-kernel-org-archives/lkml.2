Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab1FJKLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 06:11:42 -0400
Received: from ccserver2.unican.es ([130.206.5.101]:38229 "EHLO
	ccserver2.unican.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab1FJKLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 06:11:41 -0400
Message-ID: <4DF1EDF3.6030808@unican.es>
Date: Fri, 10 Jun 2011 12:12:03 +0200
From: Monica Puig-Pey <puigpeym@unican.es>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) 
	Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: <markh@compro.net>
CC: <dmarkh@cfl.rr.com>, <linux-rt-users@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Changing Kernel thread priorities
References: <4DEA1BA9.7020303@unican.es><4DEA1F22.6000603@unican.es><4DEA255
								B.2050503@unican.es><4DECBE44.2070803@unican.es> 
							<BANLkTi=xSJOgY735PE44YtkQmrdhgetGdQ@mail.gmail.com> 
						<4DECC0DF.8070209@unican.es> <4DED051A.6020702@compro.net> 
				<4DEDE411.6010807@unican.es> <4DEDEBFF.10907@cfl.rr.com> 
			<4DEDF366.6000706@cfl.rr.com> <4DEE6F4E.1030107@unican.es> 
	<4DEE7415.8000606@compro.net>
In-Reply-To: <4DEE7415.8000606@compro.net>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [193.144.198.131]
X-imss-version: 2.054
X-imss-result: Passed
X-imss-scanInfo: M:P L:E SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:6.5.1024(18190.006)
X-imss-scores: Clean:92.85834 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:1 C:1 M:2 S:2 R:2 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 07/06/11 20:55, Mark Hounschell escribió:
> On 06/07/2011 02:34 PM, Monica Puig-Pey wrote:
>> El 07/06/11 11:46, Mark Hounschell escribió:
>>> On 06/07/2011 05:14 AM, Mark Hounschell wrote:
>>>> On 06/07/2011 04:40 AM, Monica Puig-Pey wrote:
>>>>> El 06/06/11 18:49, Mark Hounschell escribió:
>>>>>> On 06/06/2011 07:58 AM, Monica Puig-Pey wrote:
>>>>>>> El 06/06/11 13:54, Rolando Martins escribió:
>>>>>>>> Hi,
>>>>>>>> I use the following:
>>>>>>>>
>>>>>>>> PIDs=$(ps -eLo pid,cls,rtprio,pri,nice,cmd | grep -i "irq" | awk '{
>>>>>>>> print $1; }' | xargs echo)
>>>>>>>> for i in $PIDs
>>>>>>>> do
>>>>>>>> ret=$(chrt -f -p 99 $i)
>>>>>>>> done
>>>>>>>>
>>>>>>>> This will change the kernel thread associated with an irq
>>>>>>>> handler to
>>>>>>>> RT FIFO prio 99.
>>>>>>>> Just change the script to your specific interrupt.
>>>>>>>>
>>>>>>>> Hope it helps,
>>>>>>>> Rolando
>>>>>>>>
>>>>>>>> On Mon, Jun 6, 2011 at 12:47 PM, Monica Puig-Pey
>>>>>>>> wrote:
>>>>>>>>> I am writing a driver which has one kernel thread associated with
>>>>>>>>> it.
>>>>>>>>> I want to change the priority of this thread, so that I can
>>>>>>>>> specify the
>>>>>>>>> order in which it is scheduled following an interrupt.
>>>>>>>>> I'm using:
>>>>>>>>>
>>>>>>>>> sched_setscheduler(struct task_struct *, int, struct sched_param
>>>>>>>>> *);
>>>>>>>>>
>>>>>>>>> but it doesn't work. I tried to change the priority from the
>>>>>>>>> init_module,
>>>>>>>>> and also from the Kernel Thread, but there is no way.
>>>>>>>>>
>>>>>>>>> Kernel version is 2.6.31-11-rt
>>>>>>>>>
>>>>>>>>> What do I call to change a kernel thread priority?
>>>>>>>>>
>>>>>>>>> Thanks you very much
>>>>>>>>>
>>>>>>>>> Mónica
>>>>>>>>>
>>>>>>>>> --
>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>>> linux-rt-users" in
>>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>>>>>>>
>>>>>>>
>>>>>>> I need to change the priority from inside the driver, when creating
>>>>>>> the
>>>>>>> kernel thread.
>>>>>>> Your script is useful but it is done in user context,
>>>>>>> Any other help please?
>>>>>>
>>>>>> What I do is record the PID of the thread in the driver, then
>>>>>> create an
>>>>>> IOCTL for your driver that user land can call that either returns the
>>>>>> PID so you can do it in user land, or cause the IOCTL code to do
>>>>>> it in
>>>>>> the driver.
>>>>>>
>>>>>> The same can be done with the affinity of the IRQ if you record the
>>>>>> IRQ
>>>>>> number.
>>>>>>
>>>>>> Mark
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>> linux-rt-users" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>> But I don't have de PID of my Kthread, I only have the task_struc *
>>>>> that
>>>>> gives me the function:
>>>>>
>>>>> struct task_struct *kthread_create(int (*threadfn)(void *data),
>>>>> void *data,
>>>>> const char namefmt[], ...)
>>>>>
>>>>> How could I get the PID, and which function should I use in the IOCTL
>>>>> (kernel context) for changing its priority?
>>>>>
>>>>
>>>> The PID can be obtained from within the interrupt handler its self via
>>>> current->pid.
>>>> Obviously an interrupt has to occur first but after one interrupt you
>>>> have it.
>>>>
>>>> Actually I had forgot how I handled this. Where I change the RT
>>>> priority
>>>> and cpu affinity is in what used to be called the Bottom Half and the
>>>> IOCTL
>>>> referred to above simply tells the BH to do it and with what values.
>>>>
>>>
>>> In interrupt handler code snippet:
>>>
>>> struct task_struct *TSK;
>>> struct sched_param PARAM = {.sched_priority = MAX_RT_PRIO };
>>>
>>> TSK = current;
>>>
>>> Code snippet from BH:
>>>
>>> if (((rtom_rtprio != 0) &&
>>> (rtom_rtprio != PARAM.sched_priority)) ||
>>> (my_rtom_rtprio[BOARD] != rtom_rtprio)) {
>>>
>>> PARAM.sched_priority = rtom_rtprio;
>>> my_rtom_rtprio[COUNT] = rtom_rtprio;
>>> sched_setscheduler(TSK, SCHED_FIFO, &PARAM);
>>>
>>> set_cpus_allowed(TSK, rtom_devices[BOARD].irq_cpu_mask);
>>> rtom_devices[BOARD].irq_task_pid = TSK->pid;
>>> }
>>>
>>> rtom_rtprio and irq_cpu_mask are set by userland via an IOCTL. An
>>> interrupt must occur for this to happen and my BOARD never shares IRQs.
>>>
>>> Mark
>>>
>>
>> Thanks, your idea seems to be very useful to me. I was doing it very
>> similar, but I didn't use the "current" variable to know the
>> task_struct *.
>>
>> I have tried your suggestion on an easy example, but it didn't work.
>> Insmod returns through the kernel
>>
>> [11334.895499] kthread: Unknown symbol sched_setscheduler
>>
>> Code shown below:
>>
>> #include <linux/module.h>
>> #include <linux/kernel.h>
>> #include <linux/ioport.h>
>>
>> #include <linux/wait.h>
>> #include <linux/kthread.h>
>> #include <asm/io.h>
>> #include <linux/sched.h>
>>
>>
>> struct task_struct *ts;
>>
>> int thread(void *data)
>> {
>> struct task_struct *TSK;
>> struct sched_param PARAM = {.sched_priority = MAX_RT_PRIO };
>> TSK = current;
>>
>> PARAM.sched_priority = 50;
>> sched_setscheduler(TSK, SCHED_FIFO, &PARAM); // <-- unknown symbol??
>>
>> while(1){
>> printk("Hi I am kernel thread!\n");
>> msleep(100);
>> if (kthread_should_stop())
>> break;
>> }
>> return 0;
>> }
>>
>>
>> int init_module(void)
>> {
>> printk(KERN_INFO "init_module() called\n");
>> ts=kthread_run(thread,NULL,"kthread");
>> return 0;
>> }
>>
>> void cleanup_module(void)
>> {
>> printk(KERN_INFO "cleanup_module() called\n");
>> kthread_stop(ts);
>> }
>> .
>>
>
> In kernel/sched.c
>
> EXPORT_SYMBOL_GPL(sched_setscheduler);
>
> If your driver is not GPL, you can't use it.
>
> Mark

I did it, it worked!!! thank you so much!!!!! :)
-- 
__________________________________________________________________________________

Mónica Puig-Pey González       E-mail: puigpeym@unican.es

Grupo de Computadores y Tiempo Real, Departamento de Electrónica y 
Computadores.
Facultad de Ciencias - Universidad de Cantabria
Av. de los Castros s/n. 39005 - Santander, España
__________________________________________________________________________________
