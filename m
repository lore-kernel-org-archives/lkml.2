Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880Ab2IFUfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:35:52 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54518 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759857Ab2IFUft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:35:49 -0400
Message-ID: <50490920.9070204@linaro.org>
Date: Thu, 06 Sep 2012 22:35:44 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: xen-devel@lists.xensource.com, linaro-dev@lists.linaro.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_NO_HZ + CONFIG_CPU_IDLE freeze the system (Was Re: [PATCH]
 acpi : remove power from acpi_processor_cx structure)
References: <1343164349-28550-1-git-send-email-daniel.lezcano@linaro.org> <50485698.1070905@linaro.org> <50486B58.7000901@linaro.org> <201209062204.11288.rjw@sisk.pl>
In-Reply-To: <201209062204.11288.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 10:04 PM, Rafael J. Wysocki wrote:
> On Thursday, September 06, 2012, Daniel Lezcano wrote:
>> On 09/06/2012 09:54 AM, Daniel Lezcano wrote:
>>> On 09/05/2012 03:41 PM, Rafael J. Wysocki wrote:
>>>> On Saturday, September 01, 2012, Rafael J. Wysocki wrote:
>>>>> On Friday, August 31, 2012, Daniel Lezcano wrote:
>>>>>> On 07/24/2012 11:06 PM, Konrad Rzeszutek Wilk wrote:
>>>>>>> On Tue, Jul 24, 2012 at 11:12:29PM +0200, Daniel Lezcano wrote:
>>>>>>>> Remove the power field as it is not used.
>>>>>>>>
>>>>>>>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>>>>>>>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>>>>>> Acked.
>>>>>> Hi Rafael,
>>>>>>
>>>>>> I did not see this patch going in. Is it possible to merge it ?
>>>>> I think so.  I'll take care of it when I get back from LinuxCon/Plumbers Conf.
>>>>> (early next week).
>>>> Applied to the linux-next branch of the linux-pm.git tree as v3.7 material.
>>> Thanks Rafael.
>>>
>>>> Are there any other patches you want me to consider for v3.7?
>>> Yes please, I have the per cpu latencies ready to be submitted but I
>>> want to do extra testing before. Unfortunately, the linux-pm-next hangs
>>> at boot time on my intel dual core (not related to the patchset).
>>>
>>> I am git bisecting right now.
>>
>> I found the culprit. This is not related to the linux-pm tree but with
>> net-next.
>> The following patch introduced the issue.
>>
>> commit 6bdb7fe31046ac50b47e83c35cd6c6b6160a475d
>> Author: Amerigo Wang <amwang@redhat.com>
>> Date:   Fri Aug 10 01:24:50 2012 +0000
>>
>>     netpoll: re-enable irq in poll_napi()
>>    
>>     napi->poll() needs IRQ enabled, so we have to re-enable IRQ before
>>     calling it.
>>    
>>     Cc: David Miller <davem@davemloft.net>
>>     Signed-off-by: Cong Wang <amwang@redhat.com>
>>     Signed-off-by: David S. Miller <davem@davemloft.net>
>>
>> AFAICS, it has been fixed by commit
>> 072a9c48600409d72aeb0d5b29fbb75861a06631 which is not yet in linux-pm-next.
> 
> If it is present in the current Linus' tree, you can just pull this one
> and merge linux-pm-next into it.  It should merge without conflicts.

Ok, thanks.

>> I fall into this issue because NETCONSOLE is set, disabling it allowed
>> me to go further.
>>
>> Unfortunately I am facing to some random freeze on the system which
>> seems to be related to CONFIG_NO_HZ=y and CONFIG_CPU_IDLE=y.
>>
>> Disabling one of them, make the freezes to disappear.
>>
>> Is it a known issue ?
> 
> Well, there are systems having problems with this configuration, but they
> should be exceptional.  What system is that?

It is a laptop T61p with a Core 2 Duo T9500. Nothing exceptional I
believe. Maybe someone got the same issue ?

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

