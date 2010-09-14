Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab0INHqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 03:46:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:41575 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab0INHqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 03:46:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,363,1280732400"; 
   d="scan'208";a="657060270"
Message-ID: <4C8F285D.8020708@linux.intel.com>
Date: Tue, 14 Sep 2010 15:46:37 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; zh-CN; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] x86/hwmon:	 {core, pkg,	via-cpu}temp_device_remove()
 can all be __cpuinit
References: <4C8E19500200007800015B15@vpn.id2.novell.com>	<4C8F2317.60506@linux.intel.com> <4C8F41EB0200007800015E8D@vpn.id2.novell.com>
In-Reply-To: <4C8F41EB0200007800015E8D@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 9/14/2010 3:35 PM, Jan Beulich 写道:
>>>> On 14.09.10 at 09:24, Chen Gong<gong.chen@linux.intel.com>  wrote:
>> 于 9/13/2010 6:30 PM, Jan Beulich 写道:
>>> ... as they're being called only from a __cpuinit function.
>>>
>>> Signed-off-by: Jan Beulich<jbeulich@novell.com>
>>>
>>> ---
>>>    drivers/hwmon/coretemp.c    |    2 +-
>>>    drivers/hwmon/pkgtemp.c     |    2 +-
>>>    drivers/hwmon/via-cputemp.c |    2 +-
>>>    3 files changed, 3 insertions(+), 3 deletions(-)
>>>
>>> --- linux-2.6.36-rc4/drivers/hwmon/coretemp.c	2010-09-13 08:45:02.000000000
>> +0200
>>> +++ 2.6.36-rc4-x86-hwmon-sections/drivers/hwmon/coretemp.c	2010-09-03
>> 17:54:14.000000000 +0200
>>> @@ -480,7 +480,7 @@ exit:
>>>    	return err;
>>>    }
>>>
>>> -static void coretemp_device_remove(unsigned int cpu)
>>> +static void __cpuinit coretemp_device_remove(unsigned int cpu)
>>>    {
>>>    	struct pdev_entry *p, *n;
>>>    	mutex_lock(&pdev_list_mutex);
>>> --- linux-2.6.36-rc4/drivers/hwmon/pkgtemp.c	2010-09-13 08:45:03.000000000
>> +0200
>>> +++ 2.6.36-rc4-x86-hwmon-sections/drivers/hwmon/pkgtemp.c	2010-09-01
>> 09:00:45.000000000 +0200
>>> @@ -337,7 +337,7 @@ exit:
>>>    }
>>>
>>>    #ifdef CONFIG_HOTPLUG_CPU
>>> -static void pkgtemp_device_remove(unsigned int cpu)
>>> +static void __cpuinit pkgtemp_device_remove(unsigned int cpu)
>>>    {
>>>    	struct pdev_entry *p, *n;
>>>    	unsigned int i;
>>> --- linux-2.6.36-rc4/drivers/hwmon/via-cputemp.c	2010-09-13
>> 08:45:03.000000000 +0200
>>> +++ 2.6.36-rc4-x86-hwmon-sections/drivers/hwmon/via-cputemp.c	2010-09-13
>> 00:00:00.000000000 +0200
>>> @@ -238,7 +238,7 @@ exit:
>>>    }
>>>
>>>    #ifdef CONFIG_HOTPLUG_CPU
>>> -static void via_cputemp_device_remove(unsigned int cpu)
>>> +static void __cpuinit via_cputemp_device_remove(unsigned int cpu)
>>>    {
>>>    	struct pdev_entry *p, *n;
>>>    	mutex_lock(&pdev_list_mutex);
>>>
>>>
>>>
>>>
>>
>> I think the change in the coretemp.c is needed but other 2 are
>> unnecessary because CONFIG_HOTPLUG_CPU has covered the codes final
>> status after init done.
>
> Perhaps you're right, but (just like was done for coretemp) these
> CONFIG_HOTPLUG_CPU conditionals are really superfluous and should
> go away.
>
> Jan

Agree. Maybe you can fix them in a uniform way
