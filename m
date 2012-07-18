Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab2GRLtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 07:49:06 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:45000 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab2GRLtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 07:49:02 -0400
Message-ID: <5006A2A6.8030902@linux.vnet.ibm.com>
Date: Wed, 18 Jul 2012 17:18:54 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Carsten Emde <C.Emde@osadl.org>
CC: Len Brown <len.brown@intel.com>, Kevin Hilman <khilman@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 1/1] Honor state disabling in the cpuidle ladder governor
References: <20120717185914.063547728@osadl.org> <20120717190330.700421963@osadl.org> <50065953.9040904@linux.vnet.ibm.com> <500697A9.6070101@osadl.org>
In-Reply-To: <500697A9.6070101@osadl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12071811-2674-0000-0000-0000054AE9FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 04:32 PM, Carsten Emde wrote:

> On 07/18/2012 08:36 AM, Deepthi Dharwar wrote:
>> On 07/18/2012 12:29 AM, Carsten Emde wrote:
>>
>>> There are two cpuidle governors ladder and menu. While the ladder
>>> governor is always available, if CONFIG_CPU_IDLE is selected, the
>>> menu governor additionally requires CONFIG_NO_HZ.
>>>
>>> A particular C state can be disabled by writing to the sysfs file
>>> /sys/devices/system/cpu/cpuN/cpuidle/stateN/disable, but this mechanism
>>> is only implemented in the menu governor. Thus, in a system where
>>> CONFIG_NO_HZ is not selected, the ladder governor becomes default and
>>> always will walk through all sleep states - irrespective of whether the
>>> C state was disabled via sysfs or not. The only way to select a specific
>>> C state was to write the related latency to /dev/cpu_dma_latency and
>>> keep the file open as long as this setting was required - not very
>>> practical and not suitable for setting a single core in an SMP system.
>>>
>>> With this patch, the ladder governor only will promote to the next
>>> C state, if it has not been disabled, and it will demote, if the
>>> current C state was disabled.
>>
>> Yes, I agree that currently that disabling a particular C-state
>> is not reflected in working of ladder governor. This patch is needed
>> to fix it on ladder too.
>>
>> Also wanted to clarify on the intended implementation here,
>> if there are say 5 C-states on a system, disabling 2nd
>> state would also end by disabling all the remaining 3 deeper states too
>> as ladder governor enters the lightest state first, and will only move
>> on to the next deeper state if a idle period was long enough as
>> per the implementation.
>> If one is disabling only the deepest state, then it would
>> work as intended.
> Yes, the patch does not make the setting of the sysfs variable
> "disable" coherent, i.e. if one is disabling a light state, then all
> deeper states are disabled as well, but the "disable" variable does not
> reflect it. Likewise, if one enables a deep state but a lighter state
> still is disabled, then this has no effect.

Agree, as per the ladder design.

> I could implement a sanitize mechanism of the ladder governor that
> takes care the "disable" variables of all deeper states are set to 1,
> if a state is disabled, and those of all lighter states are set to 0,
> if a state is enabled. Do you wish me to do that?
> 


No, I dont think thats necessary, current code suffices it.
The disable flag is knob we are giving to the user . So may be just
document  the  intended use of disable flag working
alongside design of ladder governor.

Cheers
Deepthi

>     -Carsten.
> 


