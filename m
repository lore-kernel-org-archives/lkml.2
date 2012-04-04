Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab2DDHDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 03:03:05 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:48500 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab2DDHDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 03:03:03 -0400
Message-ID: <4F7BF212.3040005@linux.vnet.ibm.com>
Date: Wed, 04 Apr 2012 12:32:42 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Sasha Levin <levinsasha928@gmail.com>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: the maxcpus= boot parameter broke somewhere along the line
References: <x49vcmhhj2f.fsf@segfault.boston.devel.redhat.com> <CA+1xoqe_xS95xKM2=X-Mq-_gc+DqzxF2D8YiuCf=0=7=mVKsyw@mail.gmail.com> <20120306164835.GA26094@elliptictech.com> <CA+1xoqfzCb5X8wwvR1Bz+D6K20n7v3ChUR0E4Jqw_BWam5C7TQ@mail.gmail.com> <x49mx7thabf.fsf@segfault.boston.devel.redhat.com> <4F578198.8060708@linux.vnet.ibm.com> <x49ipigustu.fsf@segfault.boston.devel.redhat.com> <4F59E802.6070301@linux.vnet.ibm.com> <x49wr5ygrfx.fsf@segfault.boston.devel.redhat.com> <4F79B891.8020704@linux.vnet.ibm.com> <x49sjgmgpwc.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49sjgmgpwc.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12040320-6102-0000-0000-0000012AD9B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 08:08 PM, Jeff Moyer wrote:

> "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> writes:
> 
>> On 04/02/2012 07:35 PM, Jeff Moyer wrote:
>>
>>> "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> writes:
>>>
>>>> Looking at the mention of udev above, and considering the commit you bisected
>>>> to, I think it would be good to see whether someone is writing 1 to
>>>> /sys/device/system/cpu/cpu*/online and hence the cpus are getting hot-added
>>>> towards the end of boot. Maybe that sounds stupid, but worth a try :)
>>>>
>>>> So can you try the debug patch below? It applies on latest linux-3.3-rc6+
>>>
>>> Sorry it took me so long to get back to you.  You're patch did, in fact,
>>> trigger:
>>>
>>> udev: starting version 147
>>> CPU 3 online initated from userspace
>>> SMP alternatives: switching to SMP code
>>> WARNING! power/level is deprecated; use power/control instead
>>> Booting Node 0 Processor 3 APIC 0x3
>>> NMI watchdog: enabled, takes one hw-pmu counter.
>>> CPU 1 online initated from userspace
>>> Booting Node 0 Processor 1 APIC 0x2
>>> NMI watchdog: enabled, takes one hw-pmu counter.
>>> CPU 2 online initated from userspace
>>> Booting Node 0 Processor 2 APIC 0x1
>>> NMI watchdog: enabled, takes one hw-pmu counter.
>>> CPU 1 online initated from userspace
>>> CPU 3 online initated from userspace
>>> CPU 2 online initated from userspace
>>>
>>
>>
>> Aha! Just like I thought!
>> So there is no kernel bug with respect to the maxcpus= boot parameter :-)
> 
> But this IS a change in behaviour (using older kernels, the maxcpus=
> boot parameter works just fine).


Hmmm.. strange...

>  So, what exactly has changed is my
> question, and what is the right way to fix it?
> 


I am not sure about the root cause of this behaviour change.
I also observed (in the logs above) that the "CPU X online initiated from
userspace" message appears *twice* for each CPU! Could that give somebody
a hint on what might be going wrong, hopefully?

Maybe it would be good to compare the above logs with the logs produced
from the older kernels that work as expected.

Regards,
Srivatsa S. Bhat

