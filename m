Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab0GRSiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 14:38:25 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:34717 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756994Ab0GRSiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 14:38:24 -0400
Message-ID: <4C434A19.9050207@linux.vnet.ibm.com>
Date: Mon, 19 Jul 2010 00:08:17 +0530
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Robert Hancock <hancockrwd@gmail.com>,
        Bryan Hundven <bryanhundven@gmail.com>, mchehab@redhat.com
Subject: Re: Interrupt Affinity in SMP
References: <AANLkTimhqRAMjaVNwo50GJO9B6kTzySWVtK04gEdu0rg@mail.gmail.com> <4C37C365.6090508@gmail.com> <AANLkTilH9Hn0MHvfOEOyEeRmDcPTrRXIFB3K8pq31yIH@mail.gmail.com> <AANLkTikZCBrZwROGgGTj-JREywN3fUnvaANtTGgkok--@mail.gmail.com> <AANLkTinbj4ScYca7WlnUiIKgsVkVbQwEO4ypgxFe5Zbo@mail.gmail.com> <AANLkTinSjNHPyariuoUuYZCRcbTf8nQALma81I4CPdsv@mail.gmail.com>
In-Reply-To: <AANLkTinSjNHPyariuoUuYZCRcbTf8nQALma81I4CPdsv@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Hundven wrote:
> On Sat, Jul 10, 2010 at 6:20 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
>   
>> On Sat, Jul 10, 2010 at 1:46 PM, Bryan Hundven <bryanhundven@gmail.com> wrote:
>>     
>>> I was able to set eth0 and it's TxRx queues to cpu1, but it is my
>>> understanding that 0xFFFFFFFF should distribute the interrupts across all
>>> cpus, much like LOC in my output of /proc/interrupts.
>>>
>>> I don't have access to the computer this weekend, but I will provide more
>>> info on Monday.
>>>       
>> That may be chipset dependent, I don't think all chipsets have the
>> ability to distribute the interrupts like that. Round-robin interrupt
>> distribution for a given handler isn't optimal for performance anyway
>> since it causes the relevant cache lines for the interrupt handler to
>> be ping-ponged between the different CPUs.
>>
>>     
>>> -bryan
>>>
>>> On Jul 9, 2010 5:48 PM, "Robert Hancock" <hancockrwd@gmail.com> wrote:
>>>
>>> On 07/09/2010 04:59 PM, Bryan Hundven wrote:
>>>       
>>>> Mauro, list,
>>>>
>>>> (please CC me in replies, I am not...
>>>>         
>>> Tried changing these files to exclude CPU0?
>>>
>>> Have you tried running the irqbalance daemon? That's what you likely want to
>>> be doing anyway..
>>>
>>>       
>>>> =====8<=====8<=====8<=====8<=====8<=====8<=====8<=====8<=====8<=====
>>>>
>>>> =====8<=====8<=====8<==...
>>>>         
>
> Please see the two attached examples.
>
> Notice on the 5410 example how we start with the affinity set to 0xff,
> and change it to 0xf0.
> This should spread the interrupts over the last 4 cores of this quad
> core - dual processor system.
>
> Also notice on the 5645 example, with the same commands we start with
> 0xffffff and change to 0xfff000 to spread the interrupts over the last
> 12 cores, but only the first of the last twelve cores receive
> interrupts.
>
> This is the inconsistency I was trying to explain before.
>   
What was the status of irqbalance daemon? Was it turned on? If it is 
running, there is a chance that the interrupt count is within the 
threshold limit and interrupts are not being routed to the other core.
Could you also try with increasing the interrupt load and see if the 
distribution is happening among the cores?

-Ciju
> --Bryan
>   

